@RestResource(urlMapping='/ImageCompression/*')
global with sharing class ImageCompressionRest {
    
    @HttpGet
    global static List<ContentVersionWrapper> getImagesForRecord() {
        RestRequest req = RestContext.request;
        String recordId = req.params.get('recordId');
        
        if (String.isBlank(recordId)) { //|| !recordId.startsWith('a0N')
            throw new RestException('Invalid or missing recordId parameter');
        }
        
        List<ContentDocumentLink> cdlList = [
            SELECT ContentDocumentId
            FROM ContentDocumentLink
            WHERE LinkedEntityId = :recordId
        ];
        
        Set<Id> contentDocIds = new Set<Id>();
        for (ContentDocumentLink cdl : cdlList) {
            contentDocIds.add(cdl.ContentDocumentId);
        }
        
        List<ContentVersion> cvs = new List<ContentVersion>();
        if (!contentDocIds.isEmpty()) {
            cvs = [
                SELECT Id, Title, VersionData, FileExtension
                FROM ContentVersion
                WHERE ContentDocumentId IN :contentDocIds
                AND FileExtension IN ('jpg','jpeg','png','UNKNOWN')
                ORDER BY CreatedDate DESC
            ];
        }
        
        List<ContentVersionWrapper> results = new List<ContentVersionWrapper>();
        for (ContentVersion cv : cvs) {
            results.add(new ContentVersionWrapper(cv,recordId));
        }
        return results;
        
    }
    
    
    @HttpPost
    global static String uploadCompressedImage() {
        RestRequest req = RestContext.request;
        String jsonBody = req.requestBody.toString();
        if (String.isBlank(jsonBody)) {
            throw new RestException('Request body is empty');
        }
        
        Map<String, Object> payload = (Map<String, Object>) JSON.deserializeUntyped(jsonBody);
        
        String oldContentVersionId = (String) payload.get('contentVersionId');
        String base64CompressedImage = (String) payload.get('base64Data');
        String filename = (String) payload.get('filename');
        String linkedRecordId = (String) payload.get('linkedRecordId'); // Pass recordId to unlink old link if needed
        
        if (String.isBlank(oldContentVersionId) || String.isBlank(base64CompressedImage) || String.isBlank(filename) || String.isBlank(linkedRecordId)) {
            throw new RestException('Missing required fields: contentVersionId, base64Data, filename, linkedRecordId');
        }
        
        ContentVersion oldCV = [SELECT Id, ContentDocumentId FROM ContentVersion WHERE Id = :oldContentVersionId LIMIT 1];
        
        ContentVersion newCV = new ContentVersion();
        newCV.ContentDocumentId = oldCV.ContentDocumentId;
        newCV.Title = filename;
        newCV.PathOnClient = filename;
        newCV.VersionData = EncodingUtil.base64Decode(base64CompressedImage);
        newCV.IsMajorVersion = true;
        
        insert newCV;
        
        List<ContentDocumentLink> linksToDelete = [
            SELECT Id
            FROM ContentDocumentLink
            WHERE ContentDocumentId = :oldCV.ContentDocumentId
            AND LinkedEntityId = :linkedRecordId
        ];
        if (!linksToDelete.isEmpty()) {
            delete linksToDelete;
        }
        
        // Link new version to parent record
        ContentDocumentLink newLink = new ContentDocumentLink();
        newLink.ContentDocumentId = newCV.ContentDocumentId;
        newLink.LinkedEntityId = linkedRecordId;
        newLink.ShareType = 'V'; 
        newLink.Visibility = 'AllUsers';
        insert newLink;
        
        return JSON.serialize(
            new Map<String, Object>{
                'newContentVersionId' => newCV.Id,
                    'message' => 'Compressed image uploaded, old link removed, and new link created successfully'
                    }
        );
        
    }
    
    global class RestException extends Exception {}
    
    global class ContentVersionWrapper {
        @AuraEnabled public String contentVersionId { get; set; }
        @AuraEnabled public String filename { get; set; }
        @AuraEnabled public String fileExtension { get; set; }
        @AuraEnabled public String base64Data { get; set; }
        @AuraEnabled public String linkedRecordId { get; set; }
        
        public ContentVersionWrapper(ContentVersion cv, String linkedRecordId) {
            this.contentVersionId = cv.Id;
            this.filename = cv.Title;
            this.fileExtension = cv.FileExtension;
            this.base64Data = EncodingUtil.base64Encode(cv.VersionData);
            this.linkedRecordId = linkedRecordId;
        }
    }
}
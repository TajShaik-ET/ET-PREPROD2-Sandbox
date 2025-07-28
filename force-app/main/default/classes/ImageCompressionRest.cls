@RestResource(urlMapping='/ImageCompression/*')
global with sharing class ImageCompressionRest {
    
    @HttpGet
    global static List<ContentVersionWrapper> getImagesForRecord() {
        RestRequest req = RestContext.request;
        String recordId = req.params.get('recordId');
        //String afterDateStr = req.params.get('afterDate'); // ISO format string
        Integer limitSizeKb = 200; // 200 KB size filter
        Integer limitCount = 10;   // batch size
        
        if (String.isBlank(recordId)) {
            throw new RestException('Invalid or missing recordId parameter');
        }
        /*if (String.isBlank(afterDateStr)) {
            throw new RestException('Missing required parameter: afterDate');
        }
        
        //String afterDateStr = System.Label.YourCustomLabelName; //2025-07-01T00:00:00Z
        DateTime afterDate;
        try {
            afterDate = DateTime.valueOf(afterDateStr);
        } catch (Exception e) {
            throw new RestException('Invalid afterDate parameter format. Use ISO8601 datetime format.');
        }*/
        
        // Get ContentDocumentIds linked to record
        List<ContentDocumentLink> cdlList = [
            SELECT ContentDocumentId
            FROM ContentDocumentLink
            WHERE LinkedEntityId = :recordId
        ];
        
        Set<Id> contentDocIds = new Set<Id>();
        for (ContentDocumentLink cdl : cdlList) {
            contentDocIds.add(cdl.ContentDocumentId);
        }
        
        if (contentDocIds.isEmpty()) {
            return new List<ContentVersionWrapper>();
        }
        
        // Query old ContentVersions filtered by:
        // - linked ContentDocumentId
        // - CreatedDate after afterDate
        // - Is_Compressed_By_Batch__c = false (unprocessed)
        // - FileExtension in allowed images
        // - VersionData size > 200 KB (approximate size filter)
        // - Limit 10 records
        
        List<ContentVersion> cvs = [
            SELECT Id, Title, VersionData, FileExtension, ContentDocumentId, Is_Compressed_By_Batch__c, CreatedDate
            FROM ContentVersion
            WHERE ContentDocumentId IN :contentDocIds
            
            AND Is_Compressed_By_Batch__c = false
            AND FileExtension IN ('jpg','jpeg','png','UNKNOWN')
            ORDER BY CreatedDate ASC
            LIMIT :limitCount
        ];
        //AND CreatedDate >= :afterDate
        
        // Filter on actual size from VersionData (base64 encoded length)
        List<ContentVersion> filteredCvs = new List<ContentVersion>();
        for (ContentVersion cv : cvs) {
            Integer sizeKb = cv.VersionData != null ? (cv.VersionData.size() / 1024) : 0;
            if (sizeKb > limitSizeKb) {
                filteredCvs.add(cv);
            }
        }
        
        List<ContentVersionWrapper> results = new List<ContentVersionWrapper>();
        for (ContentVersion cv : filteredCvs) {
            results.add(new ContentVersionWrapper(cv, recordId));
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
        String linkedRecordId = (String) payload.get('linkedRecordId');
        
        if (String.isBlank(oldContentVersionId) || String.isBlank(base64CompressedImage) || String.isBlank(filename) || String.isBlank(linkedRecordId)) {
            throw new RestException('Missing required fields: contentVersionId, base64Data, filename, linkedRecordId');
        }
        
        ContentVersion oldCV = [SELECT Id, ContentDocumentId FROM ContentVersion WHERE Id = :oldContentVersionId LIMIT 1];
        
        // Create new ContentVersion without setting ContentDocumentId (to create new ContentDocument)
        ContentVersion newCV = new ContentVersion();
        newCV.Title = filename;
        newCV.PathOnClient = filename;
        newCV.VersionData = EncodingUtil.base64Decode(base64CompressedImage);
        newCV.IsMajorVersion = true;
        insert newCV;
        
        // Link new ContentDocument to the parent record
        ContentDocumentLink newLink = new ContentDocumentLink();
        newLink.ContentDocumentId = newCV.ContentDocumentId;
        newLink.LinkedEntityId = linkedRecordId;
        newLink.ShareType = 'V';
        newLink.Visibility = 'AllUsers';
        insert newLink;
        
        // Mark new version as processed
        newCV.Is_Compressed_By_Batch__c = true;
        update newCV;
        
        // Delete old ContentDocument and all versions under it (frees storage)
        // This also deletes old ContentVersions
        delete [SELECT Id FROM ContentDocument WHERE Id = :oldCV.ContentDocumentId];
        
        return JSON.serialize(
            new Map<String, Object>{
                'newContentVersionId' => newCV.Id,
                    'message' => 'Compressed image uploaded, new version marked processed, and old ContentDocument deleted successfully'
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
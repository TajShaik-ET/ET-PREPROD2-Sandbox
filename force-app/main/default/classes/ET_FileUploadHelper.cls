public class ET_FileUploadHelper {
    
    @AuraEnabled
    public static String uploadFile(String base64, String filename, String recordId){
        ContentVersion cv = createContentVersion(base64, filename);
        ContentDocumentLink cdl = createContentLink(cv.Id, recordId);
        if (cv == null || cdl == null){
            return null;
        }
        return cdl.Id;
    }
    
    private static ContentVersion createContentVersion(String base64, String filename){
        ContentVersion cv = new ContentVersion();
        cv.VersionData = EncodingUtil.base64Decode(base64);
        cv.Title = filename;
        cv.PathOnClient = filename;
        try{
            Insert cv;
            return cv;
        } catch (DMLException e){
            System.debug(e);
            return null;
        }
    }
    
    private static ContentDocumentLink createContentLink(String contentVersionId, String recordId){
        if (contentVersionId == null || recordId == null){
            return null;
        }
        ContentDocumentLink cdl = new ContentDocumentLink();
        cdl.ContentDocumentId = [SELECT ContentDocumentId
                                 FROM ContentVersion
                                 WHERE Id = :contentVersionId].ContentDocumentId;
        cdl.LinkedEntityId = recordId;
        // ShareType is either 'V', 'C', or 'I'
        // V = Viewer, C = Collaborator, I = Inferred
        cdl.ShareType = 'V';
        try{
            Insert cdl;
            return cdl;
        } catch (DMLException e){
            System.debug(e);
            return null;
        }
    }
    
    @AuraEnabled(cacheable = false)
    public static Map<ID, String> getRelatedFilesByRecordId(String recordId){
        List<ContentDocumentLink> ContentDocumentLinks = New List<ContentDocumentLink>();
        Map<ID, String> mapIdTitle = new Map<ID, String>();
        if (!String.isEmpty(recordId))
        ContentDocumentLinks = [SELECT ContentDocumentId
                     FROM ContentDocumentLink
                     WHERE LinkedEntityId = :recordId];
        List<ID> ContentDocumentIds = new List<ID>();
        if (ContentDocumentLinks.Size() > 0){
            for (ContentDocumentLink docLink : ContentDocumentLinks){
                ContentDocumentIds.add(docLink.ContentDocumentId);
            }
            List<ContentVersion> docs = [SELECT ContentDocumentId, FileExtension, Title
                                         FROM ContentVersion
                                         WHERE ContentDocumentId IN:ContentDocumentIds];
            for (ContentVersion docLink : docs){
                mapIdTitle.put(docLink.ContentDocumentId, docLink.Title);
            }
        }
        //System.debug('mapIdTitle Size: '+mapIdTitle.Size());
        if (mapIdTitle.Size() > 0)
            return mapIdTitle;
        else
            return null;
    }
    
    @AuraEnabled
    public static Boolean deleteFile(String ContentDocId){
        Boolean isSuccess;
        //System.debug('ContentDocId: '+ContentDocId);
        try{
            delete new ContentDocument(
                Id = ContentDocId
            );
            isSuccess = true;
        } catch (Exception e){
            System.debug(e);
            isSuccess = false;
        }
        return isSuccess;
    }
}
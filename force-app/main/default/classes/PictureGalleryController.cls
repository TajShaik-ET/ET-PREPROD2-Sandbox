public class PictureGalleryController {
 @AuraEnabled
    public static List<ContentVersion> imageDisplayList(Id recordID){
        
        Set<Id> linkId = new Set<Id>();
        List<ContentDocumentLink> contentDocIDList = [SELECT Id,ContentDocumentId FROM ContentDocumentLink where LinkedEntityId =: recordID];
        for(ContentDocumentLink cdl :contentDocIDList){
            linkId.add(cdl.ContentDocumentId);
        }
        
        return [SELECT Id,ContentDocumentId, ContentUrl, ContentBodyId, VersionNumber, Title, Description FROM ContentVersion 
                where ContentDocumentId in: linkId];
    }
}
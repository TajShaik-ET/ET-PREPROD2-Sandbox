public class ETI_VehicleUpload {
    
    
    @AuraEnabled
    public static Id saveTheFile( String fileName, String base64Data, String contentType) {
        system.debug('entered');
        system.debug('Saving chatter files '+fileName + ' '+ contentType);
        ContentVersion ContentInsert =new ContentVersion(); 
        ContentInsert.Title =fileName; 
        //EncodingUtil.urlDecode(String.valueOf(fileMap.get('fileBase64Data')), 'UTF-8');
        system.debug('Data'+EncodingUtil.urlDecode(base64Data,'UTF-8'));
        // ContentInsert.VersionData=EncodingUtil.base64Decode(base64Data);\
        base64Data=EncodingUtil.urlDecode(base64Data,'UTF-8');
        ContentInsert.VersionData= EncodingUtil.base64Decode(base64Data);
        ContentInsert.PathOnClient='/' + fileName ;
        insert ContentInsert; 
        system.debug('ContentInsert.id '+ ContentInsert.id);
        
       //  List<ContentDocumentLink> contentDocumentLinkList = [SELECT LinkedEntityId, ShareType, Visibility 
         //                                                    FROM ContentDocumentLink 
          //                                                   WHERE LinkedEntityId =: recordId];
        
       // ContentInsert = [select id, ContentDocumentId from ContentVersion WHERE Id =: ContentInsert.Id];
       // ContentDocumentLink cl = new ContentDocumentLink();
       // cl.ContentDocumentId = ContentInsert.ContentDocumentId;
       // cl.ShareType = 'V';
        //cl.Visibility = 'AllUsers';
        //insert cl;
        system.debug('ContentInsert.id');
        return ContentInsert.id;
    }
    
}
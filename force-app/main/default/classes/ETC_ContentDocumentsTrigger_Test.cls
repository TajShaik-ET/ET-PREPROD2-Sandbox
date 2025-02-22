@isTest
public class ETC_ContentDocumentsTrigger_Test {
    
    @isTest public static void testContentTrigger(){
        
                List<ETCAR_Car__c> carsList = ETC_TestDataFactory.createCars(3, 'SUV');
        insert carsList;
        
        Blob beforeblob=Blob.valueOf('Unit Test Attachment Body');
        ContentVersion cv = new ContentVersion();
        cv.title = 'test content trigger';      
        cv.PathOnClient ='test';           
        cv.VersionData =beforeblob;          
        insert cv;
        
        List<ContentDocument> documents = [SELECT Id, Title, LatestPublishedVersionId FROM ContentDocument];
        
        ContentDocumentLink contentlink=new ContentDocumentLink();
        contentlink.LinkedEntityId=carsList[0].id;
        contentlink.ShareType= 'V';
        contentlink.LinkedEntityId = carsList[0].id;
        contentlink.ContentDocumentId=documents[0].Id;
        insert contentlink;
        
    }
}
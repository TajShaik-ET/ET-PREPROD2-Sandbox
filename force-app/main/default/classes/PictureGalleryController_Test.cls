@isTest
public class PictureGalleryController_Test {
 @isTest Public static void codeCoverage(){
     Account testAccount = new Account();
     testAccount.Name='Test Account' ;
     insert testAccount;
     
     Contact cont = new Contact ();
     cont.FirstName = 'FirstName';
     cont.LastName = 'LastName';
     cont.Email='email@email.com';
     cont.phone='12345678';
     insert cont;
     
      Account acct = new Account(Name='TEST_ACCT');
        insert acct;
      ContentVersion contentVersion = new ContentVersion(
            Title = 'Penguins',
            PathOnClient = 'Penguins.jpg',
            VersionData = Blob.valueOf('Test Content'),
            IsMajorVersion = true
        );
     insert contentVersion;    
     List<ContentDocument> documents = [SELECT Id, Title, LatestPublishedVersionId FROM ContentDocument];
     
     //create ContentDocumentLink  record 
     ContentDocumentLink cdl = New ContentDocumentLink();
     cdl.LinkedEntityId = acct.id;
     cdl.ContentDocumentId = documents[0].Id;
     cdl.shareType = 'V';
     insert cdl;
        Test.startTest();
        List<ContentVersion> cv=PictureGalleryController.imageDisplayList(testAccount.Id);
        Test.stopTest();
    }
}
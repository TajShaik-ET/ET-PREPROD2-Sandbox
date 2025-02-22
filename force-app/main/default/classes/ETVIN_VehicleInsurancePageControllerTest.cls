@IsTest()//SeeAllData=true
public class ETVIN_VehicleInsurancePageControllerTest {

    private static testmethod void getInsuranceDetails(){
        
        Vehicle_Master__c ve =  new Vehicle_Master__c();
        ve.name = 'B0017298';
        ve.Internal_No__c = 'B0017298';
        ve.Plate_Type__c = 'Private';
        insert ve;
        
        
        
        Account acc = new Account();
        //acc.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Insurance_Partner').getRecordTypeId();
        acc.Name = 'test';

        insert acc;
        
        Veh_Default_Insurance_partner__c vehDe = new Veh_Default_Insurance_partner__c();
        vehDe.name = 'test';
        vehDe.Account_ID__c=acc.Id;
        insert vehDe;
        
        VehicleInsEmailNotification__c ev = new VehicleInsEmailNotification__c();
        ev.Email__c ='test@gmail.com';
        ev.Name ='test';
        ev.Label__c = 'PRO';
        insert ev;
            
        ETVIN_Vehicle_Insurance__c etv = new ETVIN_Vehicle_Insurance__c();
        etv.Vehicle__c = ve.Id;
        
        ETVIN_VehicleInsurancePageController.getInsuranceDetails('111', '23223', '232323', '3433', 'test', '');
        ETVIN_VehicleInsurancePageController.getRecordTypeId('Account', 'Insurance_Partner');
        
        ContentVersion contentVersionInsert = new ContentVersion(
            Title = 'Test',
            PathOnClient = 'Test.jpg',
            VersionData = Blob.valueOf('Test Content Data'),
            IsMajorVersion = true
        );
        insert contentVersionInsert;
        
        ContentVersion contentVersionSelect = [SELECT Id, Title, ContentDocumentId FROM ContentVersion WHERE Id = :contentVersionInsert.Id LIMIT 1];
        //List<ContentDocument> documents = [SELECT Id, Title, LatestPublishedVersionId FROM ContentDocument];
        
        
         //List<ContentDocument> cdList = [SELECT Id, Title, LatestPublishedVersionId FROM ContentDocument];
        ETVIN_VehicleInsurancePageController.deleteAttachment(contentVersionSelect.ContentDocumentId);
        ETVIN_VehicleInsurancePageController.getselectOptions('Case', 'Status');
        ETVIN_VehicleInsurancePageController.getPartnerAccList();
        ETVIN_VehicleInsurancePageController.getRenewalButtonSettings();
        ETVIN_VehicleInsurancePageController.getInsMasterDetails();
        ETVIN_VehicleInsurancePageController.getDefaultInsPartners();
        ETVIN_VehicleInsurancePageController.getInsClaimDetails();
        ETVIN_VehicleInsurancePageController.getDocumentMasterDetails('Dubai');
        
        JSONGenerator gen = JSON.createGenerator(true);
        gen.writeStartArray();
        gen.writeStartObject();
        gen.writeStringField('VehicleInternalNumber', 'B0017298');
        gen.writeStringField('InsuredValue', '244');
         gen.writeStringField('RefundPremium', '233');
         gen.writeStringField('RefundVAT', '10');
         gen.writeStringField('TotalAmount', '233');
        gen.writeEndObject();
        gen.writeEndArray();
        String jsonData = gen.getAsString();
       
        
        ETVIN_VehicleInsurancePageController.insertData(jsonData);
        
        JSONGenerator gen1 = JSON.createGenerator(true);
        gen1.writeStartArray();
        gen1.writeStartObject();
        gen1.writeStringField('VehicleInternalNumber', 'B0017298');
        gen1.writeStringField('InsurancePolicyNumber', '244');
        gen1.writeStringField('InsuredValue', '233');
        gen1.writeStringField('EffectiveDate', '2021-12-01');
        gen1.writeStringField('ExpiryDate', '2021-12-30');
        gen1.writeStringField('PremiumExpense', '10');
        gen1.writeStringField('InsurancePremiumWithVAT', '233');
        gen1.writeEndObject();
        gen1.writeEndArray();
        String jsonData2 = gen1.getAsString();
        
        ETVIN_VehicleInsurancePageController.insertDataRenewal(jsonData2);

        
    }
    
    
}
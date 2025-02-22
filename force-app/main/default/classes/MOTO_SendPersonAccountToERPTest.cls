@isTest
public class MOTO_SendPersonAccountToERPTest {

    @isTest
    public static void MOTO_SendPersonAccount(){
        
        Test.setMock(HttpCalloutMock.class, new Oracle_Integration_Mock());
        String RecTypeId= [select Id from RecordType where (Name='Person (B2C)') and (SobjectType='Account')].Id;
        Account Accnt = new Account(
            RecordTypeID=RecTypeId,
            FirstName='Test FName',
            LastName='Test LName',
            PersonEmail='test@yahoo.com',
            PersonMobilePhone='1234567',
            Phone='12345678' 
            
        );
        
        insert Accnt;
        
        opportunity Opp= new opportunity();
        opp.Name='DemoTest';
        opp.AccountId=Accnt.id;
        opp.Type='Growth Business';
        opp.CloseDate=Date.newInstance(2022,12,15);
        opp.StageName='Service Booking';
        
        insert opp;
        
        Test.startTest();
        MOTO_SendPersonAccountToERP.sendAccToERP(Accnt.Id,opp.Id);
        MOTO_CreateAccountInERP.createOracleAccount(Accnt.Id,opp.Id);
        ETSALES_OpportunityTriggerHandler.stageChangeValidation(new list<Opportunity>{opp});
        Test.stopTest();
    }
        
}
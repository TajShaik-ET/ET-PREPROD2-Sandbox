@isTest
public class GIN_InsuranceLinesInsertHandlerTest {
    
    public static testmethod void linesInsert(){
        
        GI_General_Insurance_Policy__c po = new GI_General_Insurance_Policy__c();
        po.Insurance_Type__c ='Money Policy';
        po.Money_Policy_For__c ='Fuel Card';
        insert po;
        
        Account acc = new Account();
        acc.Name = 'test';
        acc.ETIN_Employee_Id__c ='832183';
       
        insert acc;
        
        JSONGenerator gen = JSON.createGenerator(true);
        gen.writeStartArray();
        gen.writeStartObject();
        gen.writeStringField('FinanceNumber','832183');
        gen.writeStringField('InsuranceLimit', '2000');
        gen.writeEndObject();
        gen.writeEndArray();
        String fileData = gen.getAsString();
        
        GIN_InsuranceLinesInsertHandler.insertData(fileData, po.Id);
        GIN_InsuranceLinesInsertHandler.getInsLinesData(po.Id);
        
        JSONGenerator gen1 = JSON.createGenerator(true);
        gen1.writeStartArray();
        gen1.writeStartObject();
        gen1.writeStringField('FinanceNumber','832183');
        gen1.writeEndObject();
        gen1.writeEndArray();
        String fileData2 = gen.getAsString();
        
        GIN_InsuranceLinesInsertHandler.insertDataWorkComp(fileData2, po.Id);
        
        GI_General_Insurance_Request__c req = new GI_General_Insurance_Request__c();
        req.Insurance_Policy__c =po.Id;
        req.Request_Type__c ='Addition';
        insert req;
        
        GIN_InsuranceLinesInsertHandler.insertMoneyPolicyUnderInsReq(fileData, req.Id, 'Addition', po.Id);
        GIN_InsuranceLinesInsertHandler.getInsLinesByInsReqId(req.Id);
        
        GIN_InsuranceLinesInsertHandler.insertDataWorkCompUnderInsReq(fileData2, req.Id, 'Addition', po.Id);
        
    }
    

}
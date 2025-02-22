@IsTest
public class ETVIN_VehicleAllocationUploadCtrlTest {
    private static testmethod void getVehicleDetails(){ 
        JSONGenerator gen = JSON.createGenerator(true);
        gen.writeStartArray();
        gen.writeStartObject();
        gen.writeStringField('VehicleInternalNumber', '2323');
        gen.writeStringField('Amount', '244');
         gen.writeStringField('InvoiceType', 'Debit');
        gen.writeEndObject();
        gen.writeEndArray();
        String jsonData = gen.getAsString();
        ETIN_Insurance_Transactions__c et = new ETIN_Insurance_Transactions__c();
        et.Name = '12323';
        et.ETIN_Amount__c=200;
        et.ETIN_AP_Type__c='Credit Note';
        insert et;
        
        ETVIN_VehicleAllocationUploadCtrl.insertData(jsonData, et.Id);
        
    }
}
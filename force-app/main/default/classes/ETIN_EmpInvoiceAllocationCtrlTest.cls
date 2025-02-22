@IsTest
public class ETIN_EmpInvoiceAllocationCtrlTest {

   private static testmethod void getInsuranceDetails(){ 
    JSONGenerator gen = JSON.createGenerator(true);
        gen.writeStartArray();
        gen.writeStartObject();
        gen.writeStringField('MembershipCode', '2323');
        gen.writeStringField('Movement', '244322');
       gen.writeStringField('ClaimAmount', '244');
       gen.writeStringField('AnnualPremium', '244');
       gen.writeStringField('effectiveDate', '2020-12-23');
       gen.writeStringField('expiryDate', '2020-12-23');
        gen.writeStringField('Policy', '244322');
       
        gen.writeEndObject();
        gen.writeEndArray();
        String jsonData = gen.getAsString();
       ETIN_Insurance_Transactions__c et = new ETIN_Insurance_Transactions__c();
       et.Name = '12323';
       et.ETIN_Amount__c=200;
       et.ETIN_AP_Type__c='Credit Note';
       insert et;
       
    ETIN_EmpInvoiceAllocationCtrl.insertData(jsonData, et.Id);
   
   }
}
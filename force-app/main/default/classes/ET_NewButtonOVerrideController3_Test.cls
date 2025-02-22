@isTest
public class ET_NewButtonOVerrideController3_Test {
    
    static testMethod void createtestMethod(){
        Id rectypeid;
        Map<String, List<String>> picklistwrap= new Map<String, List<String>>();
        ETST_Student__c estud=new ETST_Student__c(ETST_Email__c='abc@xyz.com',ETST_Emirate__c='Dubai',Name='test Student',
                                                  ETST_Nationality__c='India',ETST_Emirates_Id__c='784-2131-3212131-2',
                                                  ETST_ESIS_No__c='2302',ETST_Division__c='5',ETST_Gender__c='Male',
                                                  ETST_Student_Id__c='1223',ETST_Date_of_Birth__c=system.today()-1200);
        insert estud;
        SObject enew ;
        Map<String, Schema.SObjectType> globalDescMap=Schema.getGlobalDescribe();
        Schema.SObjectType targetType=globalDescMap.get('Case');
        sObject sObj=targetType.newSObject();
        
        String rectypelabel='School transport';
        
        Test.startTest();
        rectypeid=ET_NewButtonOVerrideController3.getRecTypeId(rectypelabel);
        enew=ET_NewButtonOVerrideController3.getrecordDetails('ETST_Student__c',estud.id);
        picklistwrap= ET_NewButtonOVerrideController3.getDependentMap(sObj,'Business_Type__c','Case_Record_Types__c');
        ET_NewButtonOVerrideController3.decimalToBinary(10);
        ET_NewButtonOVerrideController3.base64ToBits('test');
        Test.stopTest();
        
    }
    
    
}
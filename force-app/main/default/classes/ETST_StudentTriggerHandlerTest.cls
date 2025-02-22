@isTest
public class ETST_StudentTriggerHandlerTest {
    public static testmethod void changeStudentSchoolTest(){
        
        Id RecordType = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Business (B2B) - School').getRecordTypeId();
        Account customerAccount=new Account();
        customerAccount.Name='Customer';
        customerAccount.RecordTypeId=RecordType;
        insert customerAccount;
        
        Account customerAccount1=new Account();
        customerAccount1.Name='Customer1';
        customerAccount1.RecordTypeId=RecordType;
        insert customerAccount1;
        
        
        
        ETST_School__c oldSchool = new ETST_School__c();
        oldSchool.Name='OldSchool';
        oldSchool.Customer__c=customerAccount.Id;
		insert oldSchool;
        
        ETST_School__c newSchool = new ETST_School__c();
        newSchool.Name='newSchool';
        newSchool.Customer__c=customerAccount1.Id;
		insert newSchool;
        
        ETST_Student__c student=new ETST_Student__c();
        student.Name='Test Student';
        student.ETST_School_Name__c=oldSchool.Id;
        student.ETST_Emirates_Id__c='784-1234-1234567-1';
        insert student;
        
        
        Map<Id,ETST_Student__c> oldStudentMap=new Map<Id,ETST_Student__c>();
        oldStudentMap.put(student.Id,student);
        
        set<Id>schoolIds=new set<Id>();
        schoolIds.add(student.ETST_School_Name__c);
        
        Map<id,id>schoolIdVsAccountId=new Map<id,id>();
        schoolIdVsAccountId.put(oldSchool.Id,oldSchool.Customer__c);
        
        //student.ETST_School_Name__c=newSchool.Id;
        //update student;
        
        List<ETST_Student__c> updateStudentList=new List<ETST_Student__c>();
        ETST_Student__c tempStudent=new ETST_Student__c();
        tempStudent.id=student.id;
        tempStudent.ETST_School_Name__c=newSchool.Id;
        //tempStudent.ETST_School__c=schoolIdVsAccountId.get(student.ETST_School_Name__c);
        tempStudent.ETST_School__c=customerAccount1.Id;
        updateStudentList.add(tempStudent);
        
        try{
            update updateStudentList;
        }
        
        catch(exception e){}
        
        Map<Id,ETST_Student__c> newStudentMap=new Map<Id,ETST_Student__c>();
        newStudentMap.put(updateStudentList[0].Id,updateStudentList[0]);
        
        
        
        ETST_StudentTriggerHandler.changeStudentSchool(newStudentMap,oldStudentMap);
    }
}
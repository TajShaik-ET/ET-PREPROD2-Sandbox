/*
Name: ETST_TermsAndCondCtrl
Test Class: ETST_TermsAndCondCtrlTest
Author: Sreelakshmi SK
Created Date: 21 Feb 2023
Description: Controller to provide student details in Student_Code_of_Conduct.vfp
*/

public class ETST_TermsAndCondCtrl {
    public list<ETST_Student__c> stdRecord{get; set;}       
    public ETST_TermsAndCondCtrl(){
        ID idtest=ApexPages.currentPage().getParameters().get('id');
        stdRecord=[select id,name,ETST_First_Name__c,ETST_Account_Name__r.name,CreatedDate,ETST_School__r.ETST_Account_Type__c from ETST_Student__c where id=:idtest];
    }
}
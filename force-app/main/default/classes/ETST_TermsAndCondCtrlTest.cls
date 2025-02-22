/*
Name: ETST_TermsAndCondCtrlTest
Class: ETST_TermsAndCondCtrl
Author: Sreelakshmi SK
Created Date: 22 Feb 2023
*/

@isTest
private class ETST_TermsAndCondCtrlTest {

    static testMethod void testConstructor() {
        Account acct = new Account(Name='Test Account');
        insert acct;
        Account sch = new Account(Name='Test School', ETST_Account_Type__c='Private School');
        insert sch;
        ETST_Student__c std = new ETST_Student__c(Name='Test Student', ETST_Emirates_Id__c='784-5678-9870000-9');
        insert std;
        ApexPages.currentPage().getParameters().put('id', std.Id);
        ETST_TermsAndCondCtrl controller = new ETST_TermsAndCondCtrl();
    }
}
/**************************************************************************************************
* Name               : AccountPlanController_test                                                           
* Description        : Account Revenu,Budget_vs_Actual,Customer Contract                                                          
* Created Date       : 22/02/2023                                                                 
* Created By         : Akash Yellure                                           
* ----------------------------------------------------------------------------------------------- 
**************************************************************************************************/ 

@isTest

public with sharing class AccountPlanController_test {
    
    @isTest
    public static void testMethod2(){
        //Create a test data for uploading csv file
        String str = JSON.serialize('Customer Name ,Docdate(year),Customer Activity(sector),Budget,Actual,Customer Number\n' +
                                    'AKASH,02-03-23,AjmanTaxi,2000,5000,2363\n');
        //create a Account for as per data and upsert it
        Account acc = new Account();
        acc.Name = 'AKASH';
        acc.Phone='+9112345678';
        upsert acc;
        
        //create Customer sector
        ETSALES_Account_Plan__c ap = new  ETSALES_Account_Plan__c();
        ap.ETSALES_Account__c=acc.id;  
        
        //call the apex call and method
        AccountPlanController.saveFile(str);
        
        
    }
    
    
    /*   

@isTest
public static void testMethod1(){

Account acc = new Account();
acc.Name = 'AKASH';
acc.Phone='+9112345678';
upsert acc;

ETSALES_Account_Plan__c ap = new  ETSALES_Account_Plan__c();
ap.ETSALES_Account__c=acc.id;        

insert ap;
Customer_Sector__c cs = new Customer_Sector__c();
cs.Account_Revenue__c=ap.Id;
cs.Customer_Sector__c='B2C/Managed for Cash';

insert cs;


Budget_vs_Actual__c ba= new Budget_vs_Actual__c();
ba.Customer_Sector__c= cs.Id;
ba.Name='B2C/Managed for Cash';
// ba.Month__c='01 - January';
ba.Start_Date__c= Date.valueOf('2022-12-31');
ba.End_Date__c= Date.valueOf('2022-12-31');
insert ba;



ContentVersion contentVersionInsert = new ContentVersion(
Title = 'Test',
PathOnClient = 'Test.csv',
VersionData = Blob.valueOf(deatis),
IsMajorVersion = true
);
insert contentVersionInsert;



}

@isTest
static void testUploadCSVFile() {
// Create a test CSV file as a String value
String csvFile = 'Customer ,Docdate(year),Customer Activity(sector),Budget,Actual\n' +
'AKASH,02-03-23,AjmanTaxi,2000,5000\n';

Test.startTest();

AccountPlanController.saveFile(csvFile);
Test.stopTest();



}


static String str = 'Customer ,Docdate(year),Customer Activity(sector),Budget,Actual\n' +
'AKASH,02-03-23,AjmanTaxi,2000,5000\n';

public static String[] csvFileLines;
public static Blob csvFileBody;

static testmethod void testfileupload(){
Test.startTest();       
csvFileBody = Blob.valueOf(str);
String csvAsString = csvFileBody.toString();
csvFileLines = csvAsString.split('\n'); 

//AccountPlanController importData = new AccountPlanController();
//importData.csvFileBody = csvFileBody;
// importData.saveFile();
// 
//   AccountPlanController.saveFile(csvFileLines);
Test.stopTest();
} 

static testmethod void testfileuploadNegative(){
Test.startTest();       
csvFileBody = Blob.valueOf(str);
String csvAsString = csvFileBody.toString();
csvFileLines = csvAsString.split('\n'); 

AccountPlanController importData = new AccountPlanController();
// importData.saveFile();
Test.stopTest();
}

@isTest public static void  testmethodclass(){
Test.startTest();
AccountPlanController.utilityMethod();


Test.stopTest();
}

*/
    
}
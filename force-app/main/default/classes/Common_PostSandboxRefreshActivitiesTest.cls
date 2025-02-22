@isTest
public class Common_PostSandboxRefreshActivitiesTest{
    Testmethod static void Common_PostSandboxRefreshActivitiesTest_1(){
        Lead ld = new Lead();
        ld.LastName = 'LastName';
        ld.Company = 'testCompany';
        ld.Phone = '522681736'; //9-digit
        ld.Email = 'testEmail123@123.com';
        ld.Street = 'Street';
        ld.ETSALES_Budget__c = 10000;
        ld.ETSALES_Lead_Rating__c = 'Hot';
        try{
            insert ld;
        }
        Catch(Exception e){
            ld.Phone = '52268173';//8 digit
            insert ld;
        }
        
        Id accRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Inspection').getRecordTypeId();
        List<Account> accountsList = new List<Account>();
        for(integer i =0; i<=5;i++){
            Account acc = new Account();
            acc.RecordTypeId = accRecordTypeId;
            acc.Name = 'Test'+i;
            acc.AccountNumber = '12345'+i;
            acc.ETSALES_Company_Email__c='testEmail'+i+'@123.com';
            accountsList.add(acc);
        }
        insert accountsList;
        
        Folder folderDet=[Select Id from Folder where Developername='Shared_Internal'];
        List<Document> docList=new List<Document>();
        
        String customMetadataStr='Sandbox Name,Metadata Object API Name,Masterlabel,Developername,Action__c,Authorization__c,Content_Type__c,EnvironmentType__c,Grant_Type__c,HostedSessionID__c,outletRef__c,PaymentURL__c,URL__c\r\n'+
                                 +'preprod,ET_External_Endpoint__mdt,ETNgeniusPayment,ETPayment_1,GET,MGI2ZTVmZDItMzM3My00MjA4LWI3MzYtOWZmNzkxNmUyNzI0Ojc1MTI5MDZlLWRlYWQtNDVkMi05MjI2LWU3Mzg0M2RlNmYzYQ==,application/x-www-form-urlencoded,UAT,client_credentials,YWJjMjQyZDEtZWJlMC00NDc1LTlkMmItMWY3Y2ZmYWY0MGFkOjFmMmRlNWY2LTM1NTYtNDU3Yi05ZDVhLTExMGQ4MTU5M2ViNg==,076a78b9-a3f4-4165-ac56-10b9dceff6ba,https://api-gateway-uat.ngenius-payments.com/transactions/outlets/~/payment/hosted-session/,https://identity-uat.ngenius-payments.com/auth/realms/ni/protocol/openid-connect/token \r\n'+
                                 +'test1,ET_External_Endpoint__mdt,ETNgeniusPayment,ETPayment_1,GET,MGI2ZTVmZDItMzM3My00MjA4LWI3MzYtOWZmNzkxNmUyNzI0Ojc1MTI5MDZlLWRlYWQtNDVkMi05MjI2LWU3Mzg0M2RlNmYzYQ==,application/x-www-form-urlencoded,UAT,client_credentials,YWJjMjQyZDEtZWJlMC00NDc1LTlkMmItMWY3Y2ZmYWY0MGFkOjFmMmRlNWY2LTM1NTYtNDU3Yi05ZDVhLTExMGQ4MTU5M2ViNg==,076a78b9-a3f4-4165-ac56-10b9dceff6ba,https://api-gateway-uat.ngenius-payments.com/transactions/outlets/~/payment/hosted-session/,https://identity-uat.ngenius-payments.com/auth/realms/ni/protocol/openid-connect/token \r\n'+
                                 +'etdev,ET_External_Endpoint__mdt,ETNgeniusPayment,ETPayment_1,GET,MGI2ZTVmZDItMzM3My00MjA4LWI3MzYtOWZmNzkxNmUyNzI0Ojc1MTI5MDZlLWRlYWQtNDVkMi05MjI2LWU3Mzg0M2RlNmYzYQ==,application/x-www-form-urlencoded,UAT,client_credentials,YWJjMjQyZDEtZWJlMC00NDc1LTlkMmItMWY3Y2ZmYWY0MGFkOjFmMmRlNWY2LTM1NTYtNDU3Yi05ZDVhLTExMGQ4MTU5M2ViNg==,076a78b9-a3f4-4165-ac56-10b9dceff6ba,https://api-gateway-uat.ngenius-payments.com/transactions/outlets/~/payment/hosted-session/,https://identity-uat.ngenius-payments.com/auth/realms/ni/protocol/openid-connect/token \r\n'+
                                 +'"",ET_External_Endpoint__mdt,ETNgeniusPayment,ETPayment_1,GET,MGI2ZTVmZDItMzM3My00MjA4LWI3MzYtOWZmNzkxNmUyNzI0Ojc1MTI5MDZlLWRlYWQtNDVkMi05MjI2LWU3Mzg0M2RlNmYzYQ==,application/x-www-form-urlencoded,UAT,client_credentials,YWJjMjQyZDEtZWJlMC00NDc1LTlkMmItMWY3Y2ZmYWY0MGFkOjFmMmRlNWY2LTM1NTYtNDU3Yi05ZDVhLTExMGQ4MTU5M2ViNg==,076a78b9-a3f4-4165-ac56-10b9dceff6ba,https://api-gateway-uat.ngenius-payments.com/transactions/outlets/~/payment/hosted-session/,https://identity-uat.ngenius-payments.com/auth/realms/ni/protocol/openid-connect/token';
        Document customMetadataDocument=new Document(Type='csv',name='Post Refresh - custom metadata -'+System.now().milliSecond()+'.csv',Body=Blob.ValueOf(customMetadataStr),FolderId=folderDet.Id);
        docList.add(customMetadataDocument);
        
        ETIN_RenewalButton__c insertCustomSetting=new ETIN_RenewalButton__c(name='Renewal_Button_1',Visibility__c=false);
        insert insertCustomSetting;
        
        String customSettingStr='Sandbox Name,Custom Setting API Name,Name,Visibility__c\r\n'+
                                'preprod,ETIN_RenewalButton__c,Renewal_Button,TRUE\r\n'+
                                'test1,ETIN_RenewalButton__c,Renewal_Button,TRUE';
                                
        Document customSettingStrDocument=new Document(Type='csv',name='Post Refresh - custom setting -'+System.now().milliSecond()+'.csv',Body=Blob.ValueOf(customSettingStr),FolderId=folderDet.Id);
        docList.add(customSettingStrDocument);
        
        String customLabelStr='Sandbox Name,fullName,shortDescription,categories,language,protected_x,value\r\n'+
                                'preprod,ETSALES_InvoiceEndPoint,ETSALES_InvoiceEndPoint,,en_US,TRUE,https://etdevsoa.et.gov.ae:443/soa-infra/services/CommonBusinessServices/SyncARInvoiceToEBSService/syncarinvoicetoebsservicebpelprocess_client_ep\r\n'+
                                'preprod,ETCSendPaymentLink,ETCSendPaymentLink,,en_US,TRUE,http://preprod-et.cs87.force.com\r\n'+
                                'preprod,ETcarServicesOutletId,ETcarServicesOutletId,,en_US,TRUE,076a78b9-a3f4-4165-ac56-10b9dceff6ba\r\n'+
                                'preprod,ETC_Payment_Site,ETC_Payment_Site,,en_US,TRUE,https://preprod-et.cs87.force.com/paymentPage/\r\n'+
                                'preprod,ETC_Person_Account_RecordTypeId,ETC_Person_Account_RecordTypeId,,en_US,TRUE,0123z000000Z5i8AAC\r\n'+
                                'preprod,ETC_RPABotMailAddress,ETC_RPABotMailAddress,,en_US,TRUE,"vinoth.d@smaartt.com,sree.chandu@smaartt.com"\r\n'+
                                'preprod,ETInspectionOutletId,ETInspectionOutletId,,en_US,TRUE,076a78b9-a3f4-4165-ac56-10b9dceff6ba\r\n'+
                                'preprod,ETInspectionSPEAOutletId,ETInspectionSPEAOutletId,,en_US,TRUE,6cde65b4-80ed-4972-9c7d-7cdfc1dfc3d1\r\n'+
                                'preprod,ETSchoolOutletId,ETSchoolOutletId,,en_US,TRUE,076a78b9-a3f4-4165-ac56-10b9dceff6ba\r\n'+
                                'preprod,ETSchoolOutletIdbkp,ETSchoolOutletIdbkp,,en_US,TRUE,076a78b9-a3f4-4165-ac56-10b9dceff6ba\r\n'+
                                'preprod,Business_Community_URL,Business Community URL,,en_US,TRUE,https://preprod-oneet.cs87.force.com/Business/s/\r\n'+
                                'preprod,CommunityURL,CommunityURL,,en_US,TRUE,https://etpdev-et.cs110.force.com/B2B/s/\r\n'+
                                'preprod,PAYMENT_INTEGRATION_ENVIRONMENT,PAYMENT INTEGRATION ENVIRONMENT,,en_US,TRUE,UAT\r\n'+
                                'preprod,etstUrl,etstUrl,ET School,en_US,TRUE,http://preprod-et.cs87.force.com/customer/s/etst-home-page\r\n'+
                                'preprod,ET_Customer_User_Name_Postifx,ET_Customer_User_Name_Postifx,,en_US,TRUE, @oneetpreprod.com\r\n'+
                                'preprod,oneETUrl,oneETUrl,ET School,en_US,TRUE,http://preprod-et.cs87.force.com\r\n'+
                                'preprod,ETSALES_InvoiceEndPoint,ETSALES_InvoiceEndPoint,,en_US,TRUE,https://etdevsoa.et.gov.ae:443/soa-infra/services/CommonBusinessServices/SyncARInvoiceToEBSService/syncarinvoicetoebsservicebpelprocess_client_ep\r\n'+
                                'preprod,ETCSendPaymentLink,ETCSendPaymentLink,,en_US,TRUE,http://preprod-et.cs87.force.com\r\n'+
                                'preprod,ETcarServicesOutletId,ETcarServicesOutletId,,en_US,TRUE,076a78b9-a3f4-4165-ac56-10b9dceff6ba\r\n'+
                                'preprod,ETC_Payment_Site,ETC_Payment_Site,,en_US,TRUE,https://preprod-et.cs87.force.com/paymentPage/\r\n'+
                                'preprod,ETC_Person_Account_RecordTypeId,ETC_Person_Account_RecordTypeId,,en_US,TRUE,0123z000000Z5i8AAC\r\n'+
                                'preprod,ETC_RPABotMailAddress,ETC_RPABotMailAddress,,en_US,TRUE,"vinoth.d@smaartt.com,sree.chandu@smaartt.com"\r\n'+
                                'preprod,ETInspectionOutletId,ETInspectionOutletId,,en_US,TRUE,076a78b9-a3f4-4165-ac56-10b9dceff6ba\r\n'+
                                'preprod,ETInspectionSPEAOutletId,ETInspectionSPEAOutletId,,en_US,TRUE,6cde65b4-80ed-4972-9c7d-7cdfc1dfc3d1\r\n'+
                                'preprod,ETSchoolOutletId,ETSchoolOutletId,,en_US,TRUE,076a78b9-a3f4-4165-ac56-10b9dceff6ba\r\n'+
                                'preprod,ETSchoolOutletIdbkp,ETSchoolOutletIdbkp,,en_US,TRUE,076a78b9-a3f4-4165-ac56-10b9dceff6ba\r\n'+
                                'preprod,Business_Community_URL,Business Community URL,,en_US,TRUE,https://preprod-oneet.cs87.force.com/Business/s/\r\n'+
                                'preprod,CommunityURL,CommunityURL,,en_US,TRUE,https://etpdev-et.cs110.force.com/B2B/s/\r\n'+
                                'preprod,PAYMENT_INTEGRATION_ENVIRONMENT,PAYMENT INTEGRATION ENVIRONMENT,,en_US,TRUE,UAT\r\n'+
                                'preprod,etstUrl,etstUrl,ET School,en_US,TRUE,http://preprod-et.cs87.force.com/customer/s/etst-home-page\r\n'+
                                'preprod,ET_Customer_User_Name_Postifx,ET_Customer_User_Name_Postifx,,en_US,TRUE, @oneetpreprod.com\r\n'+
                                'preprod,oneETUrl,oneETUrl,ET School,en_US,TRUE,http://preprod-et.cs87.force.com\r\n'+
                                'preprod,ETSALES_InvoiceEndPoint,ETSALES_InvoiceEndPoint,,en_US,TRUE,https://etdevsoa.et.gov.ae:443/soa-infra/services/CommonBusinessServices/SyncARInvoiceToEBSService/syncarinvoicetoebsservicebpelprocess_client_ep\r\n'+
                                'preprod,ETCSendPaymentLink,ETCSendPaymentLink,,en_US,TRUE,http://preprod-et.cs87.force.com\r\n'+
                                'preprod,ETcarServicesOutletId,ETcarServicesOutletId,,en_US,TRUE,076a78b9-a3f4-4165-ac56-10b9dceff6ba\r\n'+
                                'preprod,ETC_Payment_Site,ETC_Payment_Site,,en_US,TRUE,https://preprod-et.cs87.force.com/paymentPage/\r\n'+
                                'preprod,ETC_Person_Account_RecordTypeId,ETC_Person_Account_RecordTypeId,,en_US,TRUE,0123z000000Z5i8AAC\r\n'+
                                'preprod,ETC_RPABotMailAddress,ETC_RPABotMailAddress,,en_US,TRUE,"vinoth.d@smaartt.com,sree.chandu@smaartt.com"\r\n'+
                                'preprod,ETInspectionOutletId,ETInspectionOutletId,,en_US,TRUE,076a78b9-a3f4-4165-ac56-10b9dceff6ba\r\n'+
                                'preprod,ETInspectionSPEAOutletId,ETInspectionSPEAOutletId,,en_US,TRUE,6cde65b4-80ed-4972-9c7d-7cdfc1dfc3d1\r\n'+
                                'preprod,ETSchoolOutletId,ETSchoolOutletId,,en_US,TRUE,076a78b9-a3f4-4165-ac56-10b9dceff6ba\r\n'+
                                'preprod,ETSchoolOutletIdbkp,ETSchoolOutletIdbkp,,en_US,TRUE,076a78b9-a3f4-4165-ac56-10b9dceff6ba\r\n'+
                                'preprod,Business_Community_URL,Business Community URL,,en_US,TRUE,https://preprod-oneet.cs87.force.com/Business/s/\r\n'+
                                'preprod,CommunityURL,CommunityURL,,en_US,TRUE,https://etpdev-et.cs110.force.com/B2B/s/\r\n'+
                                'preprod,PAYMENT_INTEGRATION_ENVIRONMENT,PAYMENT INTEGRATION ENVIRONMENT,,en_US,TRUE,UAT\r\n'+
                                'preprod,etstUrl,etstUrl,ET School,en_US,TRUE,http://preprod-et.cs87.force.com/customer/s/etst-home-page\r\n'+
                                'preprod,ET_Customer_User_Name_Postifx,ET_Customer_User_Name_Postifx,,en_US,TRUE, @oneetpreprod.com\r\n'+
                                'preprod,oneETUrl,oneETUrl,ET School,en_US,TRUE,http://preprod-et.cs87.force.com\r\n'+
                                'preprod,ETT_InspectionCriteria_FM,ETT_InspectionCriteria_FM,,en_US,TRUE,0058E000007SUI0QAO\n'+
                                'preprod,ETT_InspectionCriteria_HOO,ETT_InspectionCriteria_HOO,,en_US,TRUE,0058E000007SUI5QAO\n'+
                                'preprod,ETT_InspectionCriteria_Receptionist,ETT_InspectionCriteria_Receptionist,,en_US,TRUE,0058E000007SUIAQA4\n'+
                                'preprod,ETT_Collection_Card_Access_Users,Collection Card Access Users,,en_US,TRUE,"0058E000007SUIFQA4,0058E000007SUIKQA4"\n'+
                                'preprod,ETT_InspectionCriteria_Sales,ETT InspectionCriteria Sales,ET Tyre,en_US,TRUE,0058E000007SUIjQAO\n'+
                                'preprod,ETT_InspectionCriteria_Supervisor,ETT_InspectionCriteria_Supervisor,,en_US,TRUE,0058E000007SUIuQAO\n'+
                                'preprod,ETT_Job_Technician,ETT_Job_Technician,,en_US,TRUE,00G0C0000016Lyf\n'+
                                'preprod,ETT_LeadRecordTypeSales,ETT_LeadRecordTypeSales,,en_US,TRUE,0120C00000073eAQAQ\n'+
                                'preprod,ETT_Refurbished_Tyre_Sales,ETT Refurbished Tyre Sales,ET Tyre,en_US,TRUE,0123M0000000Ij5QAE\n'+
                                'preprod,ETT_Cash_Supplier,ETT_Cash_Supplier,ET Tyre,en_US,TRUE,0123z000000Z86pAAC\n'+
                                'preprod,ETT_Tyre_Credit_B2B_Supplier_CL,ETT_Tyre_Credit_B2B_Supplier_CL,ET Tyre,en_US,TRUE,0123z000000Z86uAAC\n'+
                                'preprod,ETT_Tyre_Refurbishing_Services_CL,ETT_Tyre_Refurbishing_Services_CL,ET Tyre,en_US,TRUE,0123z000000Z86zAAC\n'+
                                'preprod,ETT_QuotationSupplier,ETT_QuotationSupplier,,en_US,TRUE,0123z000000Z87jAAC\n'+
                                'preprod,ETT_Cash_Tyre_Supplier,ETT Cash Tyre Supplier,ET Tyre,en_US,TRUE,0128E000000G81FQAS\n'+
                                'preprod,ETT_LeadRecordTypeSupplier,ETT_LeadRecordTypeSupplier,,en_US,TRUE,0128E000000G81FQAS\n'+
                                'preprod,ETT_Credit_B2B_Tyre_Supplier,ETT Credit B2B Tyre Supplier,ET Tyre,en_US,TRUE,0128E000000G81GQAS\n'+
                                'preprod,ETT_Tyre_B2B_Supplier,Tyre - B2B Supplier,,en_US,TRUE,0128E000000G81GQAS\n'+
                                'preprod,ETT_Tyre_Credit_B2B_Supplier,Tyre - Credit/B2B Supplier,ET Tyre,en_US,TRUE,0128E000000G81GQAS\n'+
                                'preprod,ETT_Tyre_B2B_Supplier_WOLI,Tyre - B2B Supplier WOLI,,en_US,TRUE,0128E000000G81NQAS\n'+
                                'preprod,ETT_Tyre_Cash_Individual,ETT Tyre Cash Individual,,en_US,TRUE,0128E000000G8SeQAK\n'+
                                'preprod,ETT_LeadRecordTypeService,ETT_LeadRecordTypeService,,en_US,TRUE,0128E000000G8SfQAK\n'+
                                'preprod,ETT_Tyre_Refurbishing_Services,ETT Tyre Refurbishing Services,ET Tyre,en_US,TRUE,0128E000000G8SfQAK\n'+
                                'preprod,ETT_Tyre_Refurbishing_Services_WOLI,Tyre - Refurbishing Services WOLI,,en_US,TRUE,0128E000000G8SkQAK\n'+
                                'test1,ETSALES_InvoiceEndPoint,ETSALES_InvoiceEndPoint,,en_US,TRUE,https://etdevsoa.et.gov.ae:443/soa-infra/services/CommonBusinessServices/SyncARInvoiceToEBSService/syncarinvoicetoebsservicebpelprocess_client_ep\r\n'+
                                'test1,ETCSendPaymentLink,ETCSendPaymentLink,,en_US,TRUE,http://preprod-et.cs87.force.com\r\n'+
                                'test1,ETcarServicesOutletId,ETcarServicesOutletId,,en_US,TRUE,076a78b9-a3f4-4165-ac56-10b9dceff6ba\r\n'+
                                'test1,ETC_Payment_Site,ETC_Payment_Site,,en_US,TRUE,https://preprod-et.cs87.force.com/paymentPage/\r\n'+
                                'test1,ETC_Person_Account_RecordTypeId,ETC_Person_Account_RecordTypeId,,en_US,TRUE,0123z000000Z5i8AAC\r\n'+
                                'test1,ETC_RPABotMailAddress,ETC_RPABotMailAddress,,en_US,TRUE,"vinoth.d@smaartt.com,sree.chandu@smaartt.com"\r\n'+
                                'test1,ETInspectionOutletId,ETInspectionOutletId,,en_US,TRUE,076a78b9-a3f4-4165-ac56-10b9dceff6ba\r\n'+
                                'test1,ETInspectionSPEAOutletId,ETInspectionSPEAOutletId,,en_US,TRUE,6cde65b4-80ed-4972-9c7d-7cdfc1dfc3d1\r\n'+
                                'test1,ETSchoolOutletId,ETSchoolOutletId,,en_US,TRUE,076a78b9-a3f4-4165-ac56-10b9dceff6ba\r\n'+
                                'test1,ETSchoolOutletIdbkp,ETSchoolOutletIdbkp,,en_US,TRUE,076a78b9-a3f4-4165-ac56-10b9dceff6ba\r\n'+
                                'test1,Business_Community_URL,Business Community URL,,en_US,TRUE,https://preprod-oneet.cs87.force.com/Business/s/\r\n'+
                                'test1,CommunityURL,CommunityURL,,en_US,TRUE,https://etpdev-et.cs110.force.com/B2B/s/\r\n'+
                                'test1,PAYMENT_INTEGRATION_ENVIRONMENT,PAYMENT INTEGRATION ENVIRONMENT,,en_US,TRUE,UAT\r\n'+
                                'test1,etstUrl,etstUrl,ET School,en_US,TRUE,http://preprod-et.cs87.force.com/customer/s/etst-home-page\r\n'+
                                'test1,ET_Customer_User_Name_Postifx,ET_Customer_User_Name_Postifx,,en_US,TRUE, @oneetpreprod.com\r\n'+
                                'test1,oneETUrl,oneETUrl,ET School,en_US,TRUE,http://preprod-et.cs87.force.com\r\n';

        Document customLabelDocument=new Document(Type='csv',name='Post Refresh - custom label.csv',Body=Blob.ValueOf(customLabelStr),FolderId=folderDet.Id);
        docList.add(customLabelDocument);
        
        insert docList;
        
        Test.StartTest();
            Test.testSandboxPostCopyScript(new Common_PostSandboxRefreshActivities(), UserInfo.getOrganizationId(),UserInfo.getOrganizationId(),'preprod'); 
            CustomMetadataCallback callBaclIns=new CustomMetadataCallback();
            Metadata.DeployResult result = new Metadata.DeployResult();
            result.details=new Metadata.DeployDetails();
            result.details.componentFailures=new List<Metadata.DeployMessage>();
            Metadata.DeployMessage mesg=new Metadata.DeployMessage();
            mesg.fullName='preprod';
            result.details.componentFailures.add(mesg);
            Metadata.DeployCallbackContext context = new Metadata.DeployCallbackContext();
            callBaclIns.handleResult(result, context);
        Test.StopTest();
    }
    
    Testmethod static void Common_PostSandboxRefreshActivitiesTest_BatchError(){
        Lead ld = new Lead();
        ld.LastName = 'LastName';
        ld.Company = 'testCompany';
        ld.Phone = '522681736'; //9-digit
        ld.Email = 'testEmail123@123.com';
        ld.Street = 'Street';
        ld.ETSALES_Budget__c = 10000;
        ld.ETSALES_Lead_Rating__c = 'Hot';
        try{
            insert ld;
        }
        Catch(Exception e){
            ld.Phone = '52268173';//8 digit
            insert ld;
        }
        
        Id accRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Inspection').getRecordTypeId();
        List<Account> accountsList = new List<Account>();
        for(integer i =0; i<=5;i++){ 
            Account acc = new Account();
            acc.RecordTypeId = accRecordTypeId;
            acc.Name = 'Test'+i;
            acc.AccountNumber = '12345'+i;
            acc.ETSALES_Company_Email__c='testEmail'+i+'@123.com';
            accountsList.add(acc);
        }
        insert accountsList;
        
        Test.StartTest();
            Common_UpdateSobjectBatch batchIns=new Common_UpdateSobjectBatch('Account',new Set<String>{'ETSALES_Company_Email__c'});
            batchIns.errorMap=new Map<string,String>();
            batchIns.errorMap.put('Generic Error','Test error');
            Database.executeBatch(batchIns);  
            System.enQueueJob(new Common_PostRefreshErrorEmailQueuable(null));
            TestClassNew ns=new TestClassNew();
        Test.StopTest();
    }
}
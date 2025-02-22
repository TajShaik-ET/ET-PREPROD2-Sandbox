@IsTest
private class ETST_UploadContractClass_Test{
    
    @testSetup
    public static void testSetup(){
        
        Id accParentRecordType = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Person_B2C').getRecordTypeId();
        Id accSchoolRecordType = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Business_School').getRecordTypeId();
        Profile p = [SELECT Id FROM Profile WHERE Name='School Coordinator']; 
        User coordinator = new User(Alias = 'cordu', Email='coordinatoruser@testorg.com', 
                                    EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
                                    LocaleSidKey='en_US', ProfileId = p.Id, 
                                    TimeZoneSidKey='America/Los_Angeles', UserName='coordinatoruser@testorg.com');
        insert coordinator;
        
        Account parentAccount = new Account(FirstName='Test',LastName='Parent',RecordTypeId=accParentRecordType,
                                            ETSALES_Emirates_Passport__c='784-1272-8373838-3',Phone='971581484471',PersonEmail='vinod.test@test.com',
                                            ETSALES_Customer_Type__c='Person');
        insert parentAccount;
        
        Account schoolAccount = new Account(Name='Test School',RecordTypeId=accSchoolRecordType,
                                            ETST_Account_Type__c='Private School',ETSALES_Trade_License_Number__c='11211',ETST_SchoolRefID__c='110011',
                                            ETSALES_Trade_License_Expiry_Date__c=system.today().addDays(365),ETST_Coordinator__c=coordinator.Id);
        insert schoolAccount;
        
        ET_Sales_Agreement__c agr = new ET_Sales_Agreement__c(Salesforce_Customer__c=schoolAccount.Id);
        insert agr;
        
    } 
    
    public static  testMethod void uploadContractTest(){ 
        
        System.Test.startTest();
        
        ETST_UploadContractClass ctrct = new ETST_UploadContractClass();        
        ctrct.getbaseUrl();
        
        ETST_UploadContractClass ctrct7 = new ETST_UploadContractClass();
        String s15 = 'Org Id,Org Name,Contract Id*,Contract Lines,School Id*,School Name,AR Customer number,Lines ,Zone*,Areas,Trarnsport Type*(Two Way/Pick up only/Drop off only),Yearly Amount*,Monthly Amount*,Yeraly Discount %,Half Yeraly Discount %,Quarterly Discount %,Tax %,Commision Value,Commision %,Cancellation  Refund %,Refundable  Amount,Maintenance Amount,Other Services Cost ,Contact Start Date*(dd/mm/yyyy),Contract End Date*(dd/mm/yyyy),Monthly Allowed*(P/O),Quarterly Allowed*(P/O),Half Yearly Allowed*(P/O),Yearly Allowed*(P/O),Payee*(School/Parent/Group),Pro Rate*(Month/Day),On Demand Allowd*(P/O),Min. Duration (in days),Max Duration (in days),Rate per Day,Cheque Payment Allowed*(P/O),Courier Address,Cancellation Mode(Month/Day),Cancellation Fee,Created Date';
        String s16 = ',Aldar Academies,213657,,9231,ALDAR Academies - Al Bateen Academy,562750,,A,,Two Way,5000,500,,,,,,,,,0,0,01/01/2019,30/06/2021,O,P,P,P,Parent,Month,O,,,,P,Emirates Transport- Abu Dhabi,Month,0,';  
        s15=s15+'\n'+s16;        
        ctrct7.contentFile = Blob.valueOf(s15);        
        ctrct7.ReadFile();
        
        System.Test.stopTest();
        
    }
    
    public static  testMethod void uploadContractTest1(){ 
        
        System.Test.startTest();
        
        ContentVersion cv=new Contentversion();
        cv.title='Pricelist Template';
        cv.PathOnClient ='test';
        Blob b=Blob.valueOf('Unit Test Attachment Body');
        cv.versiondata=EncodingUtil.base64Decode('Unit Test Attachment Body');
        insert cv;   
        
        ETST_UploadContractClass ctrct = new ETST_UploadContractClass();
        ctrct.nameFile = 'Pricelist Template'; 
        ctrct.getbaseUrl();
        
        String s1 = 'Org Id,Org Name,Contract Id*,Contract Lines,School Id*,School Name,AR Customer number,Lines,Zone*,Areas,Trarnsport Type*(Two Way/Pick up only/Drop off only),Yearly Amount*,Monthly Amount*,Yeraly Discount %,Half Yeraly Discount %,Quarterly Discount %,Tax %,Commision Value,Commision %,Cancellation  Refund %,Refundable  Amount,Maintenance Amount,Other Services Cost,Contact Start Date*(mm/dd/yyyy),Contract End Date*(mm/dd/yyyy),Monthly Allowed*(P/O),Quarterly Allowed*(P/O),Half Yearly Allowed*(P/O),Yearly Allowed*(P/O),Payee*(School/Parent/Group),Pro Rate*(P/O),On Demand Allowd*(P/O),    Min. Duration (in days),Max Duration (in days),Rate per Day,Cheque Payment Allowed*(P/O),Courier Address,Created Date';
        String s2 = ',,213657,,110011,Test School,1091,,A,,Two Way,3830,383,10,5,,,,10,10,,0,0,01-09-2018,05-06-2020,O,O,P,P,School,O,O,10,60,20,P,Emirates Transport,,';   
        s1=s1+'\n'+s2;        
        ctrct.contentFile = Blob.valueOf(s1);        
        ctrct.ReadFile();        
        
        ETST_UploadContractClass ctrct1 = new ETST_UploadContractClass();
        String s3 = 'Org Id,Org Name,Contract Id*,Contract Lines,School Id*,School Name,AR Customer number,Lines,Zone*,Areas,Trarnsport Type*(Two Way/Pick up only/Drop off only),Yearly Amount*,Monthly Amount*,Yeraly Discount %,Half Yeraly Discount %,Quarterly Discount %,Tax %,Commision Value,Commision %,Cancellation  Refund %,Refundable  Amount,Maintenance Amount,Other Services Cost,Contact Start Date*(mm/dd/yyyy),Contract End Date*(mm/dd/yyyy),Monthly Allowed*(P/O),Quarterly Allowed*(P/O),Half Yearly Allowed*(P/O),Yearly Allowed*(P/O),Payee*(School/Parent/Group),Pro Rate*(P/O),On Demand Allowd*(P/O),    Min. Duration (in days),Max Duration (in days),Rate per Day,Cheque Payment Allowed*(P/O),Courier Address,Created Date';
        String s4 = ',,,,110011,Test School,1091,,A,,Two Way,3830,383,10,5,,,,10,10,,0,0,01-09-2018,05-06-2020,O,O,P,P,School,O,O,10,60,20,P,Emirates Transport,,'; 
        s3=s3+'\n'+s4;        
        ctrct1.contentFile = Blob.valueOf(s3);
        ctrct1.ReadFile();
        
        ETST_UploadContractClass ctrct2 = new ETST_UploadContractClass();
        String s5 = 'Org Id,Org Name,Contract Id*,Contract Lines,School Id*,School Name,AR Customer number,Lines,Zone*,Areas,Trarnsport Type*(Two Way/Pick up only/Drop off only),Yearly Amount*,Monthly Amount*,Yeraly Discount %,Half Yeraly Discount %,Quarterly Discount %,Tax %,Commision Value,Commision %,Cancellation  Refund %,Refundable  Amount,Maintenance Amount,Other Services Cost,Contact Start Date*(mm/dd/yyyy),Contract End Date*(mm/dd/yyyy),Monthly Allowed*(P/O),Quarterly Allowed*(P/O),Half Yearly Allowed*(P/O),Yearly Allowed*(P/O),Payee*(School/Parent/Group),Pro Rate*(P/O),On Demand Allowd*(P/O),    Min. Duration (in days),Max Duration (in days),Rate per Day,Cheque Payment Allowed*(P/O),Courier Address,Created Date';
        String s6 = ',,213657,,,Test School,1091,,A,,Two Way,3830,383,10,5,,,,10,10,,0,0,01-09-2018,05-06-2020,O,O,P,P,School,O,O,10,60,20,P,Emirates Transport,,'; 
        s5=s5+'\n'+s6;        
        ctrct2.contentFile = Blob.valueOf(s5);
        ctrct2.ReadFile();
        
        ETST_UploadContractClass ctrct3 = new ETST_UploadContractClass();
        String s7 = 'Org Id,Org Name,Contract Id*,Contract Lines,School Id*,School Name,AR Customer number,Lines,Zone*,Areas,Trarnsport Type*(Two Way/Pick up only/Drop off only),Yearly Amount*,Monthly Amount*,Yeraly Discount %,Half Yeraly Discount %,Quarterly Discount %,Tax %,Commision Value,Commision %,Cancellation  Refund %,Refundable  Amount,Maintenance Amount,Other Services Cost,Contact Start Date*(mm/dd/yyyy),Contract End Date*(mm/dd/yyyy),Monthly Allowed*(P/O),Quarterly Allowed*(P/O),Half Yearly Allowed*(P/O),Yearly Allowed*(P/O),Payee*(School/Parent/Group),Pro Rate*(P/O),On Demand Allowd*(P/O),    Min. Duration (in days),Max Duration (in days),Rate per Day,Cheque Payment Allowed*(P/O),Courier Address,Created Date';
        String s8 = ',,213657,,110011,Test School,1091,,,,Two Way,3830,383,10,5,,,,10,10,,0,0,01-09-2018,05-06-2020,O,O,P,P,School,O,O,10,60,20,P,Emirates Transport,,';    
        s7=s7+'\n'+s8;        
        ctrct3.contentFile = Blob.valueOf(s7);        
        ctrct3.ReadFile(); 
        
        ETST_UploadContractClass ctrct4 = new ETST_UploadContractClass();
        String s9 = 'Org Id,Org Name,Contract Id*,Contract Lines,School Id*,School Name,AR Customer number,Lines,Zone*,Areas,Trarnsport Type*(Two Way/Pick up only/Drop off only),Yearly Amount*,Monthly Amount*,Yeraly Discount %,Half Yeraly Discount %,Quarterly Discount %,Tax %,Commision Value,Commision %,Cancellation  Refund %,Refundable  Amount,Maintenance Amount,Other Services Cost,Contact Start Date*(mm/dd/yyyy),Contract End Date*(mm/dd/yyyy),Monthly Allowed*(P/O),Quarterly Allowed*(P/O),Half Yearly Allowed*(P/O),Yearly Allowed*(P/O),Payee*(School/Parent/Group),Pro Rate*(P/O),On Demand Allowd*(P/O),    Min. Duration (in days),Max Duration (in days),Rate per Day,Cheque Payment Allowed*(P/O),Courier Address,Created Date';
        String s10 = ',,213657,,110011,Test School,1091,,A,,,3830,383,10,5,,,,10,10,,0,0,01-09-2018,05-06-2020,O,O,P,P,School,O,O,10,60,20,P,Emirates Transport,,'; 
        s9=s9+'\n'+s10;        
        ctrct4.contentFile = Blob.valueOf(s9);        
        ctrct4.ReadFile();
        
        ETST_UploadContractClass ctrct5 = new ETST_UploadContractClass();
        String s11 = 'Org Id,Org Name,Contract Id*,Contract Lines,School Id*,School Name,AR Customer number,Lines,Zone*,Areas,Trarnsport Type*(Two Way/Pick up only/Drop off only),Yearly Amount*,Monthly Amount*,Yeraly Discount %,Half Yeraly Discount %,Quarterly Discount %,Tax %,Commision Value,Commision %,Cancellation  Refund %,Refundable  Amount,Maintenance Amount,Other Services Cost,Contact Start Date*(mm/dd/yyyy),Contract End Date*(mm/dd/yyyy),Monthly Allowed*(P/O),Quarterly Allowed*(P/O),Half Yearly Allowed*(P/O),Yearly Allowed*(P/O),Payee*(School/Parent/Group),Pro Rate*(P/O),On Demand Allowd*(P/O),   Min. Duration (in days),Max Duration (in days),Rate per Day,Cheque Payment Allowed*(P/O),Courier Address,Created Date';
        String s12 = ',,213657,,110011,Test School,1091,,A,,Two Way,,383,10,5,,,,10,10,,0,0,01-09-2018,05-06-2020,O,O,P,P,Parent,O,O,10,60,20,P,Emirates Transport,,';  
        s11=s11+'\n'+s12;        
        ctrct5.contentFile = Blob.valueOf(s11);        
        ctrct5.ReadFile();        
        
        ETST_UploadContractClass ctrct6 = new ETST_UploadContractClass();
        String s13 = 'Org Id,Org Name,Contract Id*,Contract Lines,School Id*,School Name,AR Customer number,Lines,Zone*,Areas,Trarnsport Type*(Two Way/Pick up only/Drop off only),Yearly Amount*,Monthly Amount*,Yeraly Discount %,Half Yeraly Discount %,Quarterly Discount %,Tax %,Commision Value,Commision %,Cancellation  Refund %,Refundable  Amount,Maintenance Amount,Other Services Cost,Contact Start Date*(mm/dd/yyyy),Contract End Date*(mm/dd/yyyy),Monthly Allowed*(P/O),Quarterly Allowed*(P/O),Half Yearly Allowed*(P/O),Yearly Allowed*(P/O),Payee*(School/Parent/Group),Pro Rate*(P/O),On Demand Allowd*(P/O),   Min. Duration (in days),Max Duration (in days),Rate per Day,Cheque Payment Allowed*(P/O),Courier Address,Created Date';
        String s14 = ',,213657,,110011,Test School,1091,,A,,Two Way,3830,,10,5,,,,10,10,,0,0,01-09-2018,05-06-2020,O,O,P,P,Parent,O,O,10,60,20,P,Emirates Transport,,'; 
        s13=s13+'\n'+s14;        
        ctrct6.contentFile = Blob.valueOf(s13);        
        ctrct6.ReadFile();        
        
        ETST_UploadContractClass ctrct7 = new ETST_UploadContractClass();
        String s15 = 'Org Id,Org Name,Contract Id*,Contract Lines,School Id*,School Name,AR Customer number,Lines,Zone*,Areas,Trarnsport Type*(Two Way/Pick up only/Drop off only),Yearly Amount*,Monthly Amount*,Yeraly Discount %,Half Yeraly Discount %,Quarterly Discount %,Tax %,Commision Value,Commision %,Cancellation  Refund %,Refundable  Amount,Maintenance Amount,Other Services Cost,Contact Start Date*(mm/dd/yyyy),Contract End Date*(mm/dd/yyyy),Monthly Allowed*(P/O),Quarterly Allowed*(P/O),Half Yearly Allowed*(P/O),Yearly Allowed*(P/O),Payee*(School/Parent/Group),Pro Rate*(P/O),On Demand Allowd*(P/O),   Min. Duration (in days),Max Duration (in days),Rate per Day,Cheque Payment Allowed*(P/O),Courier Address,Created Date';
        String s16 = ',,213657,,110011,Test School,1091,,A,,Two Way,3830,383,10,5,1,1,1,10,10,,0,0,01/09/2018,05/06/2020,O,O,P,P,School,O,O,10,60,20,P,Emirates Transport,,';   
        s15=s15+'\n'+s16;        
        ctrct7.contentFile = Blob.valueOf(s15);        
        ctrct7.ReadFile();        
        
        ETST_UploadContractClass ctrct8 = new ETST_UploadContractClass();
        String s17 = 'Org Id,Org Name,Contract Id*,Contract Lines,School Id*,School Name,AR Customer number,Lines,Zone*,Areas,Trarnsport Type*(Two Way/Pick up only/Drop off only),Yearly Amount*,Monthly Amount*,Yeraly Discount %,Half Yeraly Discount %,Quarterly Discount %,Tax %,Commision Value,Commision %,Cancellation  Refund %,Refundable  Amount,Maintenance Amount,Other Services Cost,Contact Start Date*(mm/dd/yyyy),Contract End Date*(mm/dd/yyyy),Monthly Allowed*(P/O),Quarterly Allowed*(P/O),Half Yearly Allowed*(P/O),Yearly Allowed*(P/O),Payee*(School/Parent/Group),Pro Rate*(P/O),On Demand Allowd*(P/O),   Min. Duration (in days),Max Duration (in days),Rate per Day,Cheque Payment Allowed*(P/O),Courier Address,Created Date';
        String s18 = ',,213657,,110011,Test School,1091,,A,,Two Way,3830,383,10,5,,,,10,10,,0,0,,05/06/2020,O,O,P,P,School,O,O,10,60,20,P,Emirates Transport,,';    
        s17=s17+'\n'+s18;        
        ctrct8.contentFile = Blob.valueOf(s17);        
        ctrct8.ReadFile();   
        
        
        //,,213657,,110011,Test School,1091,,A,,Two Way,3830,383,10,5,,,,10,10,,0,0,01-09-2018,05-06-2020,O,O,P,P,School,O,O,10,60,20,P,Emirates Transport,,
        ETST_UploadContractClass ctrct9 = new ETST_UploadContractClass();
        String s19 = 'Org Id,Org Name,Contract Id*,Contract Lines,School Id*,School Name,AR Customer number,Lines,Zone*,Areas,Trarnsport Type*(Two Way/Pick up only/Drop off only),Yearly Amount*,Monthly Amount*,Yeraly Discount %,Half Yeraly Discount %,Quarterly Discount %,Tax %,Commision Value,Commision %,Cancellation  Refund %,Refundable  Amount,Maintenance Amount,Other Services Cost,Contact Start Date*(mm/dd/yyyy),Contract End Date*(mm/dd/yyyy),Monthly Allowed*(P/O),Quarterly Allowed*(P/O),Half Yearly Allowed*(P/O),Yearly Allowed*(P/O),Payee*(School/Parent/Group),Pro Rate*(P/O),On Demand Allowd*(P/O),   Min. Duration (in days),Max Duration (in days),Rate per Day,Cheque Payment Allowed*(P/O),Courier Address,Created Date';
        String s20 = ',,213657,,110011,Test School,1091,,A,,Two Way,3830,383,10,5,,,,10,10,,0,0,09/01/2020,,O,O,P,P,School,O,O,10,60,20,P,Emirates Transport,,';    
        s19=s19+'\n'+s20;        
        ctrct9.contentFile = Blob.valueOf(s19);        
        ctrct9.ReadFile();        
        
        ETST_UploadContractClass ctrctA = new ETST_UploadContractClass();
        String s1b = 'Org Id,Org Name,Contract Id*,Contract Lines,School Id*,School Name,AR Customer number,Lines,Zone*,Areas,Trarnsport Type*(Two Way/Pick up only/Drop off only),Yearly Amount*,Monthly Amount*,Yeraly Discount %,Half Yeraly Discount %,Quarterly Discount %,Tax %,Commision Value,Commision %,Cancellation  Refund %,Refundable  Amount,Maintenance Amount,Other Services Cost,Contact Start Date*(mm/dd/yyyy),Contract End Date*(mm/dd/yyyy),Monthly Allowed*(P/O),Quarterly Allowed*(P/O),Half Yearly Allowed*(P/O),Yearly Allowed*(P/O),Payee*(School/Parent/Group),Pro Rate*(P/O),On Demand Allowd*(P/O),   Min. Duration (in days),Max Duration (in days),Rate per Day,Cheque Payment Allowed*(P/O),Courier Address,Created Date';
        String s2b = ',,213657,,110011,Test School,1091,,A,,Two Way,3830,383,10,5,,,,10,10,,0,0,09/01/2020,05/06/2021,S,O,P,P,School,O,O,10,60,20,P,Emirates Transport,,';  
        s1b=s1b+'\n'+s2b;        
        ctrctA.contentFile = Blob.valueOf(s1b);        
        ctrctA.ReadFile(); 
        
        ETST_UploadContractClass ctrctB = new ETST_UploadContractClass();
        String s1c = 'Org Id,Org Name,Contract Id*,Contract Lines,School Id*,School Name,AR Customer number,Lines,Zone*,Areas,Trarnsport Type*(Two Way/Pick up only/Drop off only),Yearly Amount*,Monthly Amount*,Yeraly Discount %,Half Yeraly Discount %,Quarterly Discount %,Tax %,Commision Value,Commision %,Cancellation  Refund %,Refundable  Amount,Maintenance Amount,Other Services Cost,Contact Start Date*(mm/dd/yyyy),Contract End Date*(mm/dd/yyyy),Monthly Allowed*(P/O),Quarterly Allowed*(P/O),Half Yearly Allowed*(P/O),Yearly Allowed*(P/O),Payee*(School/Parent/Group),Pro Rate*(P/O),On Demand Allowd*(P/O),   Min. Duration (in days),Max Duration (in days),Rate per Day,Cheque Payment Allowed*(P/O),Courier Address,Created Date';
        String s2c = ',,213657,,110011,Test School,1091,,A,,Two Way,3830,383,10,5,,,,10,10,,0,0,09/01/2020,05/06/2021,O,S,P,P,School,O,O,10,60,20,P,Emirates Transport,,';  
        s1c=s1c+'\n'+s2c;        
        ctrctB.contentFile = Blob.valueOf(s1c);        
        ctrctB.ReadFile();
        
        ETST_UploadContractClass ctrctC = new ETST_UploadContractClass();
        String s1d = 'Org Id,Org Name,Contract Id*,Contract Lines,School Id*,School Name,AR Customer number,Lines,Zone*,Areas,Trarnsport Type*(Two Way/Pick up only/Drop off only),Yearly Amount*,Monthly Amount*,Yeraly Discount %,Half Yeraly Discount %,Quarterly Discount %,Tax %,Commision Value,Commision %,Cancellation  Refund %,Refundable  Amount,Maintenance Amount,Other Services Cost,Contact Start Date*(mm/dd/yyyy),Contract End Date*(mm/dd/yyyy),Monthly Allowed*(P/O),Quarterly Allowed*(P/O),Half Yearly Allowed*(P/O),Yearly Allowed*(P/O),Payee*(School/Parent/Group),Pro Rate*(P/O),On Demand Allowd*(P/O),   Min. Duration (in days),Max Duration (in days),Rate per Day,Cheque Payment Allowed*(P/O),Courier Address,Created Date';
        String s2d = ',,213657,,110011,Test School,1091,,A,,Two Way,3830,383,10,5,,,,10,10,,0,0,09/01/2020,05/06/2021,O,S,P,P,School,O,O,10,60,20,P,Emirates Transport,,';  
        s1d=s1d+'\n'+s2d;        
        ctrctB.contentFile = Blob.valueOf(s1d);        
        ctrctB.ReadFile();
        
        ETST_UploadContractClass ctrctD = new ETST_UploadContractClass();
        String s1e = 'Org Id,Org Name,Contract Id*,Contract Lines,School Id*,School Name,AR Customer number,Lines,Zone*,Areas,Trarnsport Type*(Two Way/Pick up only/Drop off only),Yearly Amount*,Monthly Amount*,Yeraly Discount %,Half Yeraly Discount %,Quarterly Discount %,Tax %,Commision Value,Commision %,Cancellation  Refund %,Refundable  Amount,Maintenance Amount,Other Services Cost,Contact Start Date*(mm/dd/yyyy),Contract End Date*(mm/dd/yyyy),Monthly Allowed*(P/O),Quarterly Allowed*(P/O),Half Yearly Allowed*(P/O),Yearly Allowed*(P/O),Payee*(School/Parent/Group),Pro Rate*(P/O),On Demand Allowd*(P/O),   Min. Duration (in days),Max Duration (in days),Rate per Day,Cheque Payment Allowed*(P/O),Courier Address,Created Date';
        String s2e = ',,213657,,110011,Test School,1091,,A,,Two Way,3830,383,10,5,,,,10,10,,0,0,09/01/2020,05/06/2021,O,O,S,P,School,O,O,10,60,20,P,Emirates Transport,,';  
        s1e=s1e+'\n'+s2e;        
        ctrctD.contentFile = Blob.valueOf(s1e);        
        ctrctD.ReadFile();
        
        ETST_UploadContractClass ctrctE = new ETST_UploadContractClass();
        String s1f = 'Org Id,Org Name,Contract Id*,Contract Lines,School Id*,School Name,AR Customer number,Lines,Zone*,Areas,Trarnsport Type*(Two Way/Pick up only/Drop off only),Yearly Amount*,Monthly Amount*,Yeraly Discount %,Half Yeraly Discount %,Quarterly Discount %,Tax %,Commision Value,Commision %,Cancellation  Refund %,Refundable  Amount,Maintenance Amount,Other Services Cost,Contact Start Date*(mm/dd/yyyy),Contract End Date*(mm/dd/yyyy),Monthly Allowed*(P/O),Quarterly Allowed*(P/O),Half Yearly Allowed*(P/O),Yearly Allowed*(P/O),Payee*(School/Parent/Group),Pro Rate*(P/O),On Demand Allowd*(P/O),   Min. Duration (in days),Max Duration (in days),Rate per Day,Cheque Payment Allowed*(P/O),Courier Address,Created Date';
        String s2f = ',,213657,,110011,Test School,1091,,A,,Two Way,3830,383,10,5,,,,10,10,,0,0,09/01/2020,05/06/2021,O,O,P,S,School,O,O,10,60,20,P,Emirates Transport,,';  
        s1f=s1f+'\n'+s2f;        
        ctrctE.contentFile = Blob.valueOf(s1f);        
        ctrctE.ReadFile();
        
        ETST_UploadContractClass ctrctG = new ETST_UploadContractClass();
        String s1g = 'Org Id,Org Name,Contract Id*,Contract Lines,School Id*,School Name,AR Customer number,Lines,Zone*,Areas,Trarnsport Type*(Two Way/Pick up only/Drop off only),Yearly Amount*,Monthly Amount*,Yeraly Discount %,Half Yeraly Discount %,Quarterly Discount %,Tax %,Commision Value,Commision %,Cancellation  Refund %,Refundable  Amount,Maintenance Amount,Other Services Cost,Contact Start Date*(mm/dd/yyyy),Contract End Date*(mm/dd/yyyy),Monthly Allowed*(P/O),Quarterly Allowed*(P/O),Half Yearly Allowed*(P/O),Yearly Allowed*(P/O),Payee*(School/Parent/Group),Pro Rate*(P/O),On Demand Allowd*(P/O),   Min. Duration (in days),Max Duration (in days),Rate per Day,Cheque Payment Allowed*(P/O),Courier Address,Created Date';
        String s2g = ',,213657,,110011,Test School,1091,,A,,Two Way,3830,383,10,5,,,,10,10,,0,0,09/01/2020,05/06/2021,O,O,P,P,Test,O,O,10,60,20,P,Emirates Transport,,';    
        s1g=s1g+'\n'+s2g;        
        ctrctD.contentFile = Blob.valueOf(s1g);        
        ctrctD.ReadFile();
        
        ETST_UploadContractClass ctrctH = new ETST_UploadContractClass();
        String s1h = 'Org Id,Org Name,Contract Id*,Contract Lines,School Id*,School Name,AR Customer number,Lines,Zone*,Areas,Trarnsport Type*(Two Way/Pick up only/Drop off only),Yearly Amount*,Monthly Amount*,Yeraly Discount %,Half Yeraly Discount %,Quarterly Discount %,Tax %,Commision Value,Commision %,Cancellation  Refund %,Refundable  Amount,Maintenance Amount,Other Services Cost,Contact Start Date*(mm/dd/yyyy),Contract End Date*(mm/dd/yyyy),Monthly Allowed*(P/O),Quarterly Allowed*(P/O),Half Yearly Allowed*(P/O),Yearly Allowed*(P/O),Payee*(School/Parent/Group),Pro Rate*(P/O),On Demand Allowd*(P/O),   Min. Duration (in days),Max Duration (in days),Rate per Day,Cheque Payment Allowed*(P/O),Courier Address,Created Date';
        String s2h = ',,213657,,110011,Test School,1091,,A,,Two Way,3830,383,10,5,,,,10,10,,0,0,01/09/2018,05/06/2020,O,O,P,P,School,O,O,10,60,20,,Emirates Transport,,';   
        s1h=s1h+'\n'+s2h;        
        ctrctH.contentFile = Blob.valueOf(s1h);        
        ctrctH.ReadFile();
        
        ETST_UploadContractClass ctr = new ETST_UploadContractClass();
        String s1i = 'Org Id,Org Name,Contract Id*,Contract Lines,School Id*,School Name,AR Customer number,Lines,Zone*,Areas,Trarnsport Type*(Two Way/Pick up only/Drop off only),Yearly Amount*,Monthly Amount*,Yeraly Discount %,Half Yeraly Discount %,Quarterly Discount %,Tax %,Commision Value,Commision %,Cancellation  Refund %,Refundable  Amount,Maintenance Amount,Other Services Cost,Contact Start Date*(mm/dd/yyyy),Contract End Date*(mm/dd/yyyy),Monthly Allowed*(P/O),Quarterly Allowed*(P/O),Half Yearly Allowed*(P/O),Yearly Allowed*(P/O),Payee*(School/Parent/Group),Pro Rate*(P/O),On Demand Allowd*(P/O),   Min. Duration (in days),Max Duration (in days),Rate per Day,Cheque Payment Allowed*(P/O),Courier Address,Created Date';
        String s2i = ',,213657,,110011,Test School,1091,,A,,Two Way,3830,383,10,5,,,,10,10,,0,0,09/01/2020,05/06/2021,O,O,P,P,School,O,S,10,60,20,P,Emirates Transport,,';  
        s1i=s1i+'\n'+s2i;        
        ctr.contentFile = Blob.valueOf(s1i);        
        ctr.ReadFile();
        
        ETST_UploadContractClass ctr1 = new ETST_UploadContractClass();
        String s1j = 'Org Id,Org Name,Contract Id*,Contract Lines,School Id*,School Name,AR Customer number,Lines,Zone*,Areas,Trarnsport Type*(Two Way/Pick up only/Drop off only),Yearly Amount*,Monthly Amount*,Yeraly Discount %,Half Yeraly Discount %,Quarterly Discount %,Tax %,Commision Value,Commision %,Cancellation  Refund %,Refundable  Amount,Maintenance Amount,Other Services Cost,Contact Start Date*(mm/dd/yyyy),Contract End Date*(mm/dd/yyyy),Monthly Allowed*(P/O),Quarterly Allowed*(P/O),Half Yearly Allowed*(P/O),Yearly Allowed*(P/O),Payee*(School/Parent/Group),Pro Rate*(P/O),On Demand Allowd*(P/O),   Min. Duration (in days),Max Duration (in days),Rate per Day,Cheque Payment Allowed*(P/O),Courier Address,Created Date';
        String s2j = ',,213657,,110011,Test School,1091,,A,,Two Way,3830,383,10,5,,,,10,10,,0,0,09/01/2020,05/06/2021,O,O,P,P,School,O,S,10,60,20,A,Emirates Transport,,';  
        s1j=s1j+'\n'+s2j;        
        ctr1.contentFile = Blob.valueOf(s1j);        
        ctr1.ReadFile();
        
        ETST_UploadContractClass ctr2 = new ETST_UploadContractClass();
        String s1x = 'Org Id,Org Name,Contract Id*,Contract Lines,School Id*,School Name,AR Customer number,Lines,Zone*,Areas,Trarnsport Type*(Two Way/Pick up only/Drop off only),Yearly Amount*,Monthly Amount*,Yeraly Discount %,Half Yeraly Discount %,Quarterly Discount %,Tax %,Commision Value,Commision %,Cancellation  Refund %,Refundable  Amount,Maintenance Amount,Other Services Cost,Contact Start Date*(mm/dd/yyyy),Contract End Date*(mm/dd/yyyy),Monthly Allowed*(P/O),Quarterly Allowed*(P/O),Half Yearly Allowed*(P/O),Yearly Allowed*(P/O),Payee*(School/Parent/Group),Pro Rate*(P/O),On Demand Allowd*(P/O),   Min. Duration (in days),Max Duration (in days),Rate per Day,Cheque Payment Allowed*(P/O),Courier Address,Created Date';
        String s2x = ',,213657,,110011,Test School,1091,,A,,Two Way,3830,383,10,5,,,,10,10,,0,0,09/01/2020,05/06/2021,O,O,P,P,School,O,P,10,60,,A,Emirates Transport,,';    
        s1x=s1x+'\n'+s2x;        
        ctr2.contentFile = Blob.valueOf(s1j);        
        ctr2.ReadFile();
        
        System.Test.stopTest();
        
    }
    
}
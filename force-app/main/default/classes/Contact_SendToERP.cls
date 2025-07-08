/**
*Author: Janardhan Muddana
*Test Class: Account_SendToERP_Test
*/

public class Contact_SendToERP implements Queueable,Database.AllowsCallouts{
    public Id accID;
    public string ERPAccId;
    public string siteId;
    
    public Contact_SendToERP(Id AccountId,string ERPAccId,string siteId){
        this.accID=AccountId;
        this.ERPAccId=ERPAccId;
        this.siteId =siteId;
    }
    
    public void execute(QueueableContext cont){
        List<Contact> conList = [SELECT Id,FirstName,MiddleName,Salutation,LastName,Title,Email,Phone_Country_Code__c,Phone,
                                 ETSALES_Mob_Country_Code__c,MobilePhone,Site_Use_Id__c,Oracle_Account_ID__c,
                                 Integration_Message__c,Integration_Status__c,ETSales_Contact_Person_Id__c,
                                 ETSales_Contact_Email_Id__c,ETSales_Contact_Phone_Id__c,ETSales_Phone__c,
                                 ETSales_Contact_Mobile_Id__c FROM Contact WHERE AccountId =:accID LIMIT 1];   
        System.debug('--conList Size-- '+conList.Size());
        if(conList.Size() > 0) {
            contact con = conList[0];
            String CustAccountId = ERPAccId;//(con.Oracle_Account_ID__c!=null)?(''+con.Oracle_Account_ID__c+''):null;
            String SiteUseId = siteId;// (con.Site_Use_Id__c!=null)?(''+con.Site_Use_Id__c+''):null;
            String Salute = (con.Salutation!=null)?('"'+con.Salutation+'"'):null;
            String FirstName = (con.FirstName!=null)?('"'+con.FirstName+'"'):null;
            String MiddleName = (con.MiddleName!=null)?('"'+con.MiddleName+'"'):null;
            String LastName = (con.LastName!=null)?('"'+con.LastName+'"'):null;      
            String Title = (con.Title!=null)?('"'+con.Title+'"'):null;       
            String PhoneCountryCode = (con.Phone_Country_Code__c!=null)?('"'+con.Phone_Country_Code__c+'"'):null;
            String Phone = (con.ETSales_Phone__c!=null)?('"'+con.ETSales_Phone__c+'"'):null;           
            String PhonePurpose = '"BUSINESS"';     
            String MobileCountryCode = (con.ETSALES_Mob_Country_Code__c!=null)?('"'+con.ETSALES_Mob_Country_Code__c+'"'):null;     
            String Mobile = (con.MobilePhone!=null)?('"'+con.MobilePhone+'"'):null;    
            String MobilePurpose = '"BUSINESS"';    
            String EMail = (con.Email!=null)?('"'+con.Email+'"'):null; 
            String SFDC_ID = (con.id!=null)?('"'+con.id+'"'):null;
            if(MobileCountryCode!=null&&MobileCountryCode.contains('(')&&MobileCountryCode.contains(')'))
            {
                Integer startindex = MobileCountryCode.indexOf('(');
                Integer endindex = MobileCountryCode.indexOf(')');
                MobileCountryCode = MobileCountryCode.substring(startindex+1,endindex);
                MobileCountryCode = '"' + MobileCountryCode + '"';
            }
            if(PhoneCountryCode!=null&&PhoneCountryCode.contains('(')&&PhoneCountryCode.contains(')'))
            {
                Integer startindex = PhoneCountryCode.indexOf('(');
                Integer endindex = PhoneCountryCode.indexOf(')');
                PhoneCountryCode = PhoneCountryCode.substring(startindex+1,endindex);
                PhoneCountryCode = '"' + PhoneCountryCode + '"';
                
            }
            String body ='';
            HttpRequest request = new HttpRequest();
            body = '{"CustAccountId":'+CustAccountId+',"SiteUseId":'+SiteUseId+','+
                '"Salute":'+Salute+','+'"FirstName":'+FirstName+','+
                '"MiddleName":'+MiddleName+','+'"LastName":'+LastName+','+
                '"Title":'+Title+','+'"PhoneCountryCode":'+PhoneCountryCode+','+
                '"Phone":'+Phone+','+'"PhonePurpose":'+PhonePurpose+','+
                '"MobileCountryCode":'+MobileCountryCode+','+'"Mobile":'+Mobile+','+
                '"MobilePurpose":'+MobilePurpose+','+'"EMail":'+EMail+','+
                '"SFDC_ID":'+SFDC_ID+ '}';            
            System.debug('body='+body);
            request.setEndpoint(Label.ETSOA_End_Point +'/soa-infra/resources/SalesForceIntegration/ArkanCustomerAPI/ArkanCustomerApiRest/Contact');
            request.setMethod('POST');
            request.setTimeout(120000);
            request.setHeader('Content-Type', 'application/json');
            request.setBody(body);  
            Arkani_API_Credentials__mdt	credentialsMetadata=[Select Password__c,UserName__c from Arkani_API_Credentials__mdt where DeveloperName = 'Arkani_Credential'];                 
            //String Username = 'Salesforce';
            //String password = 'salesforce123';
            String Username = credentialsMetadata.UserName__c;
            String password = credentialsMetadata.Password__c;   
            String combined = Username+':'+password;
            Blob beforeblob = Blob.valueOf(combined);
            string base64Key = EncodingUtil.base64Encode(beforeblob);
            System.debug('paramvalue='+base64Key);
            String AuthroizationValue = 'Basic '+base64Key;
            request.setHeader('Authorization', AuthroizationValue);   
            Map<String, Object> responseResult =new Map<String, Object>();
            Http http = new Http();
            HttpResponse response = http.send(request);
            if (response.getStatusCode() != 200) {
                System.debug('Failed ');
                responseResult = null;             
            }
            else{
                if(response.getStatusCode() == 200){
                    System.debug('Sucess ');
                    Map<String, Object> result = (Map<String, Object>)JSON.deserializeUntyped(response.getBody());
                    responseResult =result;
                    System.debug('--conRes--'+responseResult);
                }
            }
        }
    }
}
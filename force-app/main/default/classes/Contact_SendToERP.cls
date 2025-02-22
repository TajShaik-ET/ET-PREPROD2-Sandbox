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
        
        
         Contact Con = [Select id,FirstName,MiddleName,Salutation,LastName,Title,Email,Phone_Country_Code__c,Phone,
                           ETSALES_Mob_Country_Code__c,MobilePhone,Site_Use_Id__c,Oracle_Account_ID__c,
                           Integration_Message__c,Integration_Status__c,ETSales_Contact_Person_Id__c,
                           ETSales_Contact_Email_Id__c,ETSales_Contact_Phone_Id__c,ETSales_Phone__c,
                           ETSales_Contact_Mobile_Id__c from Contact where AccountId =:accID];   

            String CustAccountId = ERPAccId;//(Con.Oracle_Account_ID__c!=null)?(''+Con.Oracle_Account_ID__c+''):null;
            String SiteUseId =siteId;// (Con.Site_Use_Id__c!=null)?(''+Con.Site_Use_Id__c+''):null;
            String Salute =(Con.Salutation!=null)?('"'+Con.Salutation+'"'):null;
            String FirstName = (Con.FirstName!=null)?('"'+Con.FirstName+'"'):null;
            String MiddleName = (Con.MiddleName!=null)?('"'+Con.MiddleName+'"'):null;
            String LastName =(Con.LastName!=null)?('"'+Con.LastName+'"'):null;      
            String Title =(Con.Title!=null)?('"'+Con.Title+'"'):null;       
            String PhoneCountryCode = (Con.Phone_Country_Code__c!=null)?('"'+Con.Phone_Country_Code__c+'"'):null;
            String Phone =(Con.ETSales_Phone__c!=null)?('"'+Con.ETSales_Phone__c+'"'):null;           
            String PhonePurpose = '"BUSINESS"';     
            String MobileCountryCode = (Con.ETSALES_Mob_Country_Code__c!=null)?('"'+Con.ETSALES_Mob_Country_Code__c+'"'):null;     
            String Mobile = (Con.MobilePhone!=null)?('"'+Con.MobilePhone+'"'):null;    
            String MobilePurpose ='"BUSINESS"';    
            String EMail = (Con.Email!=null)?('"'+Con.Email+'"'):null; 
            
            String SFDC_ID = (Con.id!=null)?('"'+Con.id+'"'):null;
            
            if(MobileCountryCode!=null&&MobileCountryCode.contains('(')&&MobileCountryCode.contains(')'))
            {
                Integer startindex= MobileCountryCode.indexOf('(');
                Integer endindex= MobileCountryCode.indexOf(')');
                MobileCountryCode = MobileCountryCode.substring(startindex+1,endindex);
                MobileCountryCode = '"' + MobileCountryCode + '"';
            }
        
     	   if(PhoneCountryCode!=null&&PhoneCountryCode.contains('(')&&PhoneCountryCode.contains(')'))
            {
                Integer startindex= PhoneCountryCode.indexOf('(');
                Integer endindex= PhoneCountryCode.indexOf(')');
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
                system.debug('--conRes--'+responseResult);
            }
            
        }
        
    }
    
}
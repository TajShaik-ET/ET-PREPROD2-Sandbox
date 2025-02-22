/*******************************************************************************************************************
Class       : ET_UAEPASS
Author      : Janardhan Muddana, Taj Shaik
Description : SSO auth plugin class for Portal users 
TestClass   : ET_UAEPASSTest
----------------------------------------------------------------------------------------------------------------
            -- History --
----------------------------------------------------------------------------------------------------------------
Sr.No.  version_DevInitials     Date                Details
1.          V1.0_SH          Sep 15th, 2022    Initial Version
*******************************************************************************************************************/

global class ET_UAEPASS extends Auth.AuthProviderPluginClass {
    public String redirectUrl; 
    private String key;
    private String secret;    
    private String authUrl;
    private String accessTokenUrl;
    private String customMetadataTypeApiName;
    private String userAPIUrl; 
    
    global PageReference initiate(Map<string,string> authProviderConfiguration, String stateToPropagate) {
        System.debug(' ===:: <initiate> authProviderConfiguration ===' + authProviderConfiguration);   
        authUrl = authProviderConfiguration.get('Auth_URL__c');
        key = authProviderConfiguration.get('key__c'); 
        redirectUrl = authProviderConfiguration.get('Redirect_URI__c');  //System.label.UpassRedirectURL_1;
        String url = authUrl + '?response_type=code&client_id='+ key ;
        url += '&scope=urn:uae:digitalid:profile:general&acr_values=urn:safelayer:tws:policies:authentication:level:low&redirect_uri='+ redirectUrl;
        url += '&state=' + stateToPropagate;
        System.debug('--url-- '+url);
        return new PageReference(url);
    }
    
    global Auth.AuthProviderTokenResponse handleCallback(Map<string,string> authProviderConfiguration, Auth.AuthProviderCallbackState state ) {
        System.debug(' ===:: <handleCallback> authProviderConfiguration === ' + authProviderConfiguration);
        System.debug(' ===:: <handleCallback> authProviderConfiguration Redirect_URI__c === ' + authProviderConfiguration.get('Redirect_URI__c'));
        key = authProviderConfiguration.get('key__c');
        secret = authProviderConfiguration.get('Secret__c');
        accessTokenUrl = authProviderConfiguration.get('Access_Token_Url__c');
        String code = state.queryParameters.get('code');
        String sfdcState = state.queryParameters.get('state'); 
        redirectUrl = authProviderConfiguration.get('Redirect_URI__c'); 
        HttpRequest req = new HttpRequest();
        String url = accessTokenUrl + '?code=' + code + '&client_id=' + key + '&client_secret=' + secret; 
        url += '&grant_type=authorization_code&redirect_uri='+redirectUrl;// System.label.UpassRedirectURL_1;
        req.setEndpoint(url);
        req.setHeader('Content-Type','application/x-www-form-urlencoded');
        req.setMethod('GET');
        Http http = new Http();
        HTTPResponse res = http.send(req);
        CB_Response cbResp = (CB_Response)JSON.deserialize(res.getBody(), CB_Response.class);
        system.debug('cbResp--- '+cbResp);
        return new Auth.AuthProviderTokenResponse('uaepass', cbResp.access_token, 'refreshToken', sfdcState);
    }
    
    global Auth.UserData getUserInfo(Map<string,string> authProviderConfiguration, Auth.AuthProviderTokenResponse response) { 
        System.debug(' ===:: <getUserInfo> authProviderConfiguration === ' + authProviderConfiguration);
        System.debug(' ===:: <getUserInfo> response === ' + response);
        String token = response.oauthToken;
        userAPIUrl = authProviderConfiguration.get('API_User_Url__c');
        HttpRequest req = new HttpRequest();
        req.setHeader('Authorization', 'Bearer ' + response.oauthToken); 
        req.setEndpoint(userAPIUrl);
        req.setMethod('GET');        
        Http http = new Http();
        HTTPResponse res = http.send(req);
        String responseBody = res.getBody();
        System.debug(' ===:: <getUserInfo> responseBody === ' + responseBody);
        UAEPassUser userData = (UAEPassUser)JSON.deserialize(responseBody, UAEPassUser.class);
        System.debug(' ===:: <getUserInfo> userData === ' + userData);
        Map<String,String> mapAttributes = new Map<String,String>();
        mapAttributes.put('sub',userData.sub);
        mapAttributes.put('userType',userData.userType);
        mapAttributes.put('gender',userData.gender);
        mapAttributes.put('nationalityEN',userData.nationalityEN);
        mapAttributes.put('mobile',userData.mobile);
        return new Auth.UserData(
            userData.uuid, userData.firstnameEN, userData.lastnameEN, userData.fullnameEN, 
            userData.email, 'what', userData.email, null, 'uaepass', null, mapAttributes
        );
    }
    
    global String getCustomMetadataType() {
        return 'UPass_SSO_Settings__mdt';
    }
    
    /**************************************************************************************************************
    ****@ Wrapper Classes @****
    ***************************************************************************************************************/    
    public class CB_Response {
        public String access_token{get;set;}
        public String scope{get;set;}
        public String token_type{get;set;}
        public Integer expires_in{get;set;}
    }
    
    public class UAEPassUser {
        public String sub{get;set;}
        public String email{get;set;}
        public String gender{get;set;}
        public String nationalityEN{get;set;}
        public String firstnameEN{get;set;}
        public String lastnameEN{get;set;}  
        public String fullnameEN{get;set;}
        public String userType{get;set;} 
        public String uuid{get;set;} 
        public String mobile{get;set;} 
    }
    
    //smaple resp json : {"sub":"904a019b-112a-4007-a657-acb609dff023","gender":"Male","nationalityEN":"IND","firstnameEN":"ABCD","mobile":"971550098765","lastnameEN":"EFGH","fullnameEN":"ABCD EFGH","userType":"SOP1","nationalityAR":"هندى","uuid":"904a019b-112a-4007-a657-acb609dff023","email":"abcd.efgh@sample.com"}
    
}
@isTest
public class ET_UAEPASSTest{

    static testmethod void testMethod1(){
        ET_UAEPASS uae = new ET_UAEPASS();
        uae.getCustomMetadataType();
        Map<string, string> authProvider = new Map<string, string>();
        uae.initiate(authProvider, 'stateToPropagate');
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new ET_UAEPASSTestHttpCalloutTest());
        map<string, string> var = new map<string, string>();
        var.put('key__c', 'key');
        var.put('Secret__c', 'key');
        var.put('Access_Token_Url__c', 'key');
        var.put('code', 'key');
        var.put('state', 'key');
        //Auth.AuthProviderCallbackState state = new Auth.AuthProviderCallbackState();
        //Map<String,String> authProviderConfiguration = setupAuthProviderConfig();
        Map<String, String> queryParams = new Map<String, String>();
        queryParams.put('code', 'code');
        queryParams.put('state', 'success');
        Auth.AuthProviderCallbackState cbState = new Auth.AuthProviderCallbackState(null, null, queryParams);
        uae.handleCallback(var, cbState);
        Map<String, String> authProviderConfiguration = new Map<String, String>();
        authProviderConfiguration.put('API_User_Url__c', 'URL');
        Auth.AuthProviderTokenResponse response = new Auth.AuthProviderTokenResponse('Concur', 'testToken', 'sampleOauthSecret', 'mocktestState');
        Auth.UserData actualUserData = uae.getUserInfo(authProviderConfiguration, response);
        Test.stopTest();
    }

}
@isTest
public class ETC_UtilityClass_Test {
    
    @isTest public static void testData(){
        
        ETC_UtilityClass.getAccountId();
        ETC_UtilityClass.getBaseURL();
        ETC_UtilityClass.getUserDetails();
        ETC_UtilityClass.mobileRegex('00971504117692');   
        ETC_UtilityClass.mobileRegex('0971504117692');  
        ETC_UtilityClass.mobileRegex('+971504117692');  
        
        try {
            Contact con = new Contact(email ='test@test.com');
            insert con;
        } catch(Exception e) {
            ETC_UtilityClass.logException(e, 'test');
        }
    }
}
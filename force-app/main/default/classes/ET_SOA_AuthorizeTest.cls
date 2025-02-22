@isTest
public class ET_SOA_AuthorizeTest {
    public static testmethod void testMethod1(){
		ET_SOA_Authorize obj =new ET_SOA_Authorize();
        ET_SOA_Authorize.initializeSecurityForLookup();
        ET_SOA_Authorize.initializeDynamicSecurity('AMAN_Test_Result');
        
        
    }
}
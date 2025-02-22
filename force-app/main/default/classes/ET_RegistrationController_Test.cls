@isTest(seeAllData=true)
public class ET_RegistrationController_Test {
    
    public static testmethod void testMethod1(){
        
        
        ET_Registration_Request__c reg=new ET_Registration_Request__c(ET_Email_Id__c='test@test.com', 
                                                                      ET_First_name__c='test', 
                                                                      ET_Organization_Name__c='aa', 
                                                                      ET_Preferred_Location__c='Sharjah', 
                                                                      ET_Organization_Type__c='B2B', 
                                                                      ET_Last_name__c='test', 
                                                                      ET_Mobile_Number__c='33333');
        insert reg;
        ET_RegistrationController.getDetails();
        ET_RegistrationController.saveRegistration(reg);
        ET_RegistrationController.createCommunityUser(reg.Id);
    }

}
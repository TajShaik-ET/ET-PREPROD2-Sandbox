@isTest 
public class OneETRegistrationHandlerTest {
    @isTest 
    static void testCreateUser(){
        System.Test.startTest();
        Id profileId=[select id from profile where name='ETS Community Login'].id;
        Map<SObjectField, String> registrationAttributes=new Map<SObjectField, String>();
        
        registrationAttributes.put(Schema.User.FirstName,'test');
        registrationAttributes.put(Schema.User.LastName,'test');
        registrationAttributes.put(Schema.User.UserName,'test@onetest.com');
        registrationAttributes.put(Schema.User.email,'test@onetest.com');
        //registrationAttributes.put(Schema.User.password,'abcd1234');
        //ring password='13@232dsds';
        OneETRegistrationHandler oneet=new OneETRegistrationHandler();
        oneet.createUser(null,profileId,registrationAttributes,null);
        System.Test.stopTest();
    }
    @isTest 
    static void testCreateUser1(){
        System.Test.startTest();
        Account acc=new Account(Name='test');
        insert acc;
        Contact con=new Contact(LastName='test',accountId=acc.Id);
        insert con;
        User adminUser=[select id from user where profile.Name='System Administrator' AND isactive=true and userRoleId!=null LIMIT 1];
        Id profileId=[select id from profile where name='ETS Community Login'].id;
        Map<SObjectField, String> registrationAttributes=new Map<SObjectField, String>();
        
        //registrationAttributes.put(Schema.User.FirstName,'test1');
        //registrationAttributes.put(Schema.User.LastName,'test1');
        //registrationAttributes.put(Schema.User.UserName,'test1@test.com');
        //registrationAttributes.put(Schema.User.email,'test1@test.com');
        registrationAttributes.put(Schema.User.ContactId,con.Id);
        //ring password='13@232dsds';
        OneETRegistrationHandler oneet=new OneETRegistrationHandler();
        System.runAs(adminUser){
            try{
                oneet.createUser(acc.Id,profileId,registrationAttributes,null);
            }catch(Auth.DiscoveryCustomErrorException e){
                System.debug('ex');
            }
            try{
                oneet.createUser(acc.Id,profileId,registrationAttributes,null);
            }catch(Auth.DiscoveryCustomErrorException e){
                System.debug('ex');
            }
        }
        System.Test.stopTest();
    }
}
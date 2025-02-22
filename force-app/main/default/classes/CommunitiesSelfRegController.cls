/**
* An apex page controller that supports self registration of users in communities that allow self registration
*/
public class CommunitiesSelfRegController {
    
    public String firstName {get; set;}
    public String lastName {get; set;}
    public String email {get; set;}
    public String MobilePhone {get; set;}
    public String emiratesId {get; set;}
    public String street {get;set;}
    public String city {get;set;}
    public String country {get;set;}
    public string Emirate {get;set;}
    public String password {get; set {password = value == null ? value : value.trim(); } }
    public String confirmPassword {get; set { confirmPassword = value == null ? value : value.trim(); } }
    public String communityNickname {get; set { communityNickname = value == null ? value : value.trim(); } } 
    
    public CommunitiesSelfRegController() {
        String expid = ApexPages.currentPage().getParameters().get('expid');            
        if (expId != null) {
            Site.setExperienceId(expId); 
        }    
    }
    
    public List<SelectOption> getNationality(){
        List<SelectOption> options = new List<SelectOption>();
        options= new List<SelectOption>();
        options.add(new SelectOption('','Emirate'));
        options.add(new SelectOption('Abu Dhabi','Abu Dhabi'));
        options.add(new SelectOption('Dubai','Dubai'));
        options.add(new SelectOption('Ajman','Ajman'));
        options.add(new SelectOption('Fujairah','Fujairah'));
        options.add(new SelectOption('Ras al Khaimah','Ras al Khaimah'));
        options.add(new SelectOption('Sharjah','Sharjah'));
        options.add(new SelectOption('Umm al Quwain','Umm al Quwain'));
        return options;
    }
    private boolean isValidPassword() {
        return password == confirmPassword;
    }
    
    public PageReference registerUser() {
        
        // it's okay if password is null - we'll send the user a random password in that case
        if (!isValidPassword()) {
            ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.ERROR, Label.site.passwords_dont_match);
            ApexPages.addMessage(msg);
            return null;
        }    
        
        String profileId = null; // To be filled in by customer.
        String roleEnum = null; // To be filled in by customer.
        String accountId = ''; // To be filled in by customer.
        //String roleId=[select id from userrole where developerName ='ETS_Community_User'].Id;
        String userName = email;
        
        User u = new User();
        u.Username = userName;
        u.Email = email;
        u.FirstName = firstName;
        u.LastName = lastName;
        u.CommunityNickname = LastName;
        u.ProfileId = profileId;
        u.ETST_Emirates_ID__c=emiratesId;
        u.MobilePhone=MobilePhone;
        u.street=street;
        u.city=city;
        //u.country=country;
        u.Emirate__c = emirate;
        u.TimeZoneSidKey ='Asia/Dubai';
        u.LanguageLocaleKey ='en_US';
        u.EmailEncodingKey ='UTF-8';
        u.LocaleSidKey = 'en_US';
        String userId;
        
        try {
            userId = Site.createExternalUser(u, accountId, password);
        } catch(Site.ExternalUserCreateException ex) {
            List<String> errors = ex.getDisplayMessages();
            for (String error : errors)  {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, error));
            }            
            // This message is used for debugging. Do not display this in the UI to the end user.
            // It has the information around why the user creation failed.
            System.debug(ex.getMessage());
        }
        if (userId != null) { 
            if (password != null && password.length() > 1) {
                return Site.login(userName, password, ApexPages.currentPage().getParameters().get('startURL'));
            }
            else {
                PageReference page = System.Page.CommunitiesSelfRegConfirm;
                page.setRedirect(true);
                return page;
            }            
        } 
        return null;
    }
}
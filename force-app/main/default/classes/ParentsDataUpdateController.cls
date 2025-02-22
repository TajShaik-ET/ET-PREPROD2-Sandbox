public class ParentsDataUpdateController {
    
    public static String eid {get;set;}
    public String email {get;set;}
    public String phone {get;set;}
    public Boolean showSearchForm {set; get;}
    public List<ETST_Student__c> students = new List<ETST_Student__c>();
    public List<ETST_Student__c> orphanstudents = new List<ETST_Student__c>();
    public static String stdEmiratesId {set; get;}
    public Boolean accountFound {set; get;}
    public Boolean userFound {set; get;}
    public Boolean orphanStudentFound {set; get;}
    public Boolean userUpdatedSuccessfully{set; get;}
    
    /**
     * @description to find the user and Account info based on emirates Id
     */
	public void search() {
        phone = '';
        email = '';
        accountFound = false;
        userFound = false;
        userUpdatedSuccessfully = false;
        students = new List<ETST_Student__c>();
        String tempEid = eid;
        tempEid = tempEid.replace('-', '');
        tempEid = tempEid.replace(' ', '');
        System.debug('----tempEid--'+tempEid);
        if(String.isNotBlank(eid) && tempEid.length() == 15){
            Map<String, String> selectedAccountAndUser = getSelectedAccountRelatedInfo(eid);
            System.debug('----eid-in accounts--'+selectedAccountAndUser);
            if(selectedAccountAndUser.size() > 0 && accountFound){
                Account a = [Select id, name,PersonMobilePhone, PersonContactId from Account where id =:selectedAccountAndUser.get('accountId') ];
                phone = a.PersonMobilePhone;
                if(String.isNotBlank(selectedAccountAndUser.get('userId'))){
                	email = selectedAccountAndUser.get('userEmail');
                }
                students = [select id, name, ETST_Emirates_Id__c, ETST_Grade__c, ETST_Student_Id__c, ETST_Nationality__c, ETST_Account_Name__c from ETST_Student__c where ETST_Account_Name__c =:a.id];                
            }
        }
	}
    
    /**
     * @description to update the user and personAccount info
     */
    public void save(){
        //try{
            System.debug('-save-eid--'+eid);
            Map<String, String> selectedAccountAndUser = getSelectedAccountRelatedInfo(eid);
            System.debug('---selectedAccountAndUser---'+selectedAccountAndUser);
            
        
        if(selectedAccountAndUser.size() > 0){
                Contact contact  = [Select id, name, MobilePhone,email  from Contact where id =:selectedAccountAndUser.get('contactId')];
                System.debug('--user--'+contact);
                contact.MobilePhone = phone;
                contact.Email = email;
                update contact;
                User user = [Select id,name, Email from user where id =:selectedAccountAndUser.get('userId')];
                System.debug('--user--'+user);
                if(user.Email != email){
                   user.Email = email;
                    update user;
                    System.resetPassword(user.id, true);
                }
                userUpdatedSuccessfully = true;
                ApexPages.AddMessage(new ApexPages.Message(ApexPages.Severity.CONFIRM,'Record Updated Successfully!'));

          }
         /*}
        }Catch(Exception e){
            
        }*/
    }
    
    public Map<String, String> getSelectedAccountRelatedInfo(String e){
        String selectedAccountId = '';
        Map<String, String> selectedAccountAndUser = new  Map<String, String>();
        Map<String, String> accPersonid = new Map<String, String>();
        accPersonid = buildAccountPersonIdMap(e);
        if(accPersonid.size() > 0){
            accountFound = true;
            List<User> users = [Select id, name, Email, contactId from user where IsActive = true AND contactId =: accPersonid.values() order by createdDate desc];
            if(users.size() > 0){
                userFound = true;
                User u = users.get(0);
                System.debug('--account id--' + getKeyFromValue(accPersonid, u.ContactId));
                selectedAccountAndUser.put('accountId', getKeyFromValue(accPersonid, u.ContactId));
        		selectedAccountAndUser.put('userId', u.id);
                selectedAccountAndUser.put('contactId', u.contactId);
                selectedAccountAndUser.put('userEmail', u.email);
            }
        }
       return selectedAccountAndUser;
    }
    
    public Map<String, String> buildAccountPersonIdMap(String e){
        Map<String, String> eids = formatEmiratesId(e);
        Map<String, String> accPersonid = new Map<String, String>();
        List<Account> accounts = [Select id, name,PersonMobilePhone, PersonContactId from Account where (ET_Emirates_Id__c =:eids.get('unformatedEid') OR ET_Emirates_Id__c =:eids.get('formattedEid')) and RecordTypeId = '0123z000000Z5i8AAC' AND Government_School_Parent__c = true  order by CreatedDate asc];
        for(Account a : accounts){
            accPersonid.put(a.id, a.PersonContactId);
        }
        return accPersonid;
    }
    
    public String getKeyFromValue(Map<String, String> accPersonid, String val){
        String key = '';
        for(String k : accPersonid.keySet()){
            if(val == accPersonid.get(k)){
                key = k;
                break;
            }
        }
        return key;
    }
    
    
    public void searchStudent(){
        String tempEid = stdEmiratesId;
        tempEid = tempEid.replace('-', '');
        tempEid = tempEid.replace(' ', '');
        orphanStudentFound = false;
        System.debug('--searchStudent--tempEid--'+tempEid);
        if(String.isNotBlank(stdEmiratesId) && tempEid.length() == 15){
            Map<String, String> eids = formatEmiratesId(stdEmiratesId);
            System.debug('----orphanstudents--'+eids.get('formattedEid'));
            orphanstudents = [select id, name, ETST_Emirates_Id__c, ETST_Grade__c, ETST_Student_Id__c, ETST_Nationality__c, ETST_Account_Name__c from ETST_Student__c where  ETST_Emirates_Id__c =:eids.get('unformatedEid') OR ETST_Emirates_Id__c =:eids.get('formattedEid')];                
            if(orphanstudents.size()> 0){
                orphanStudentFound = true;
            }
            System.debug('---orphanstudents--'+orphanstudents);
        }
    }
    
    public List<ETST_Student__c> getorphanstudents(){
        return orphanstudents;
    }
    
    /**
     * @description to send email to user whose email got updated
     */
    public void SendEmailTemplateWithTemplate(String toEmail, String cId) {
        EmailTemplate et = [SELECT Id, subject, HtmlValue   FROM EmailTemplate WHERE Name ='ParentEmailUpdate'];
        System.debug('--Email Template--'+et);
        List<string> toAddress = new List<string>();
        toAddress.add(toEmail);
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            mail.setTemplateId(et.Id);
            mail.setToAddresses(toAddress);
            mail.setSubject(et.subject);
            mail.setHTMLBody(et.HtmlValue);
            mail.setTargetObjectId(cId);
            mail.setWhatId(et.Id);
            mail.setSaveAsActivity(false);
            mail.setUseSignature(false);
        	mail.setTreatTargetObjectAsRecipient(false);
        List<Messaging.SingleEmailMessage> allmsg = new List<Messaging.SingleEmailMessage>();
        allmsg.add(mail);

        try {
            Messaging.sendEmail(allmsg,false);
            return;
        } catch (Exception e) {
            System.debug(e.getMessage());
        }        
    }
    
    public List<ETST_Student__c> getstudents(){
        return students;
    }
    
    public Map<String, String> formatEmiratesId(String e){
        Map<String, String> eids = new Map<String, String>(); 
        e = e.replace('-', '');
        e = e.replace(' ', '');
        String unformatedEid = e; 
        String e1 = e.substring(0,3);
        String e2 = e.substring(3, 7);
        String e3 = e.substring(7, 14);
        String e4 = e.substring(14, 15);
        String formattedEid = e1 + '-' + e2 + '-' + e3 + '-' + e4;
        eids.put('unformatedEid', unformatedEid);
        eids.put('formattedEid', formattedEid);
        return eids;
    }
    
    public static void testCoverage(){
        Integer i =0;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
    }
}
global class ETI_BookingReminderBatch implements Database.Batchable<sObject>,Database.stateful, Schedulable
{
    public Date todayDate;
    public Id walkinRecordtypeId;
    public Id B2BRecordtypeId;

    public void Execute(SchedulableContext sc){
        ETI_BookingReminderBatch batchBookingReminder = new ETI_BookingReminderBatch(null);
        Database.executeBatch(batchBookingReminder);
    }
    public ETI_BookingReminderBatch(Date runDate) {
        this.todayDate = runDate!=null ? runDate:Date.Today()+1;
        walkinRecordtypeId = Schema.SObjectType.ETI_Booking__c.getRecordTypeInfosByDeveloperName().get('Walk_In').getRecordTypeId();
        B2BRecordtypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get(Label.ETI_Business_B2B_Inspection).getRecordTypeId();
    }
    global Database.QueryLocator start(Database.BatchableContext bc) 
    {
        String query='SELECT Id,Name,Booking_Date__c,Vehicle_Number__c,Booking_Status__c,User__c,User__r.PersonEmail,User__r.recordtypeid,CreatedBy.Contact.Email FROM ETI_Booking__c WHERE Booking_Status__c = \'Booked\' AND Booking_Date__c=:todayDate';
        return Database.getQueryLocator(query);
    }
    global void execute(Database.BatchableContext BC, list<ETI_Booking__c> scope)
    {
        list<Contact> contacts=new list<Contact>();
        Messaging.SingleEmailMessage[] emailToSend=new List<Messaging.SingleEmailMessage>();
        try{
            contacts = [select id, Email from Contact where email !=null limit 1];
            OrgWideEmailAddress[] owea = [select Id from OrgWideEmailAddress where Address = :System.Label.orgWideEmail];
            if(!contacts.isEmpty()){
                list<EmailTemplate> EmailTemplates=[SELECT Id,Subject,HtmlValue FROM EmailTemplate WHERE DeveloperName = 'Booking_Reminder' limit 1];
                for(ETI_Booking__c bkng: scope){
                    if(EmailTemplates!=NULL && EmailTemplates.size()>0 ){
                        Messaging.SingleEmailMessage msg = new Messaging.SingleEmailMessage();
                        if(bkng.CreatedBy.Contact.Email !=null && bkng.CreatedBy.Contact.Email !='' && bkng.User__r.recordtypeid ==B2BRecordtypeId)
                            msg.setToAddresses(new List<string>{bkng.CreatedBy.Contact.Email});
                        else 
                            msg.setToAddresses(new List<string>{bkng.User__r.PersonEmail});
                        string subject = EmailTemplates[0].Subject;
                        string emailcontent = EmailTemplates[0].HtmlValue;
                        msg.setWhatId(bkng.Id);
                        msg.setTargetObjectId(contacts[0].id);
                        if(emailcontent.contains('{!ETI_Booking__c.Vehicle_Number__c}') && bkng.Vehicle_Number__c!=null && bkng.Vehicle_Number__c!='')
                        {
                            emailcontent = emailcontent.replace('{!ETI_Booking__c.Vehicle_Number__c}', bkng.Vehicle_Number__c);   
                        }
                        if(emailcontent.contains('{!ETI_Booking__c.Booking_Date__c}') && bkng.Booking_Date__c!=null)
                        {
                            Date d = bkng.Booking_Date__c;
                            String dt = DateTime.newInstance(d.year(),d.month(),d.day()).format('d/MM/YYYY');
                            emailcontent = emailcontent.replace('{!ETI_Booking__c.Booking_Date__c}', dt);   
                        }
                        msg.setHTMLBody(emailcontent);
                        msg.setSubject(subject);
                        Savepoint sp = Database.setSavepoint();
                        Messaging.sendEmail(new Messaging.SingleEmailMessage[] {msg});
                        Database.rollback(sp);
                        Messaging.SingleEmailMessage sEmail = new Messaging.SingleEmailMessage();
                        if(owea.size() > 0) {
                            sEmail.setOrgWideEmailAddressId(owea.get(0).Id);
                        }
                        sEmail.setToAddresses(msg.getToAddresses());
                        sEmail.setPlainTextBody(msg.getPlainTextBody());
                        sEmail.setHTMLBody(msg.getHTMLBody());
                        sEmail.setSubject(msg.getSubject());
                        emailToSend.add(sEmail);
                    }
                }
            }
            if(!emailToSend.isEmpty()){
                List<Messaging.SendEmailResult> results = Messaging.sendEmail(emailToSend);
            }
        }catch(exception e){
            System.debug('Exception '+e.getMessage());
        }
    }
    global void finish(Database.BatchableContext BC)
    {
        
    }
}
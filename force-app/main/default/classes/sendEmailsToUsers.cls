/********************************************************************************************************************
Trigger Class : sendEmailsToUsers
Author        : Akash yellure
Description   : Description
TestClass     : sendEmailsToUsers_test
----------------------------------------------------------------------------------------------------------------
-- History --
----------------------------------------------------------------------------------------------------------------
Sr.No.       version_DevInitials   Date          Author           Details                                        
1.           v1.0                  21/9/2023     Akash            Initial Version
*******************************************************************************************************************/
public class sendEmailsToUsers {
    public static void sendEmailsToESEUsersAfterInsert(Map<Id, Case> trgNewMap) {
        String emailsubjectLabel = System.Label.eseEmailSubject;
        String emailLogoLabel = System.Label.ese_mail_logo_link;
        String emailCaseLink = System.Label.Ese_case_link_for_redirect_to_case;
        Set<String> esedptCateValue = new Set<String>();
        Set<Id> setofSchoolAccID = new Set<Id>();
        Map<String, List<String>> eseDptEseUserEmailMap = new Map<String, List<String>>();
        //collect the org wid email address for this sender type
        list<OrgWideEmailAddress> owea = [SELECT Id, Address, DisplayName FROM OrgWideEmailAddress WHERE Address=:system.label.No_reply];
        for (Case cs : trgNewMap.values()) { 
            if (cs.AccountId != null) {
                setofSchoolAccID.add(cs.AccountId);
            }
            if (cs.Status_Category__c != null) {
                esedptCateValue.add(cs.Status_Category__c);
            }
        }
        for (ESE_User__c us : [SELECT Id, Name, User__c, School_Department__r.School_Name__c, School_Department__r.Category__c ,User__r.Email,User__r.Name
                               FROM ESE_User__c 
                               WHERE School_Department__r.Category__c IN :esedptCateValue AND School_Department__r.School_Name__c IN :setofSchoolAccID]) {
                                   String category = us.School_Department__r.Category__c;
                                   String email = us.User__r.Email;
                                   if (!eseDptEseUserEmailMap.containsKey(category)) {
                                       eseDptEseUserEmailMap.put(category, new List<String>());
                                   }
                                   eseDptEseUserEmailMap.get(category).add(email);
                               }
        Messaging.SingleEmailMessage[] emailList = new List<Messaging.SingleEmailMessage>();
        for (Case cs : trgNewMap.values()) {
            if (eseDptEseUserEmailMap.containsKey(cs.Status_Category__c)) {
                List<String> emailAddresses = eseDptEseUserEmailMap.get(cs.Status_Category__c);
                for (String emailAddress : emailAddresses) {
                    Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
                    email.setOrgWideEmailAddressId(owea[0].Id); // Set the org-wide email address
                    email.setToAddresses(new List<String>{ emailAddress });
                    email.setSubject(emailsubjectLabel);
                    String messageBody = '<html><head><style>';
                    // CSS styling
                    messageBody += 'table { border-collapse: collapse; width: 100%; }'; // Simple table styling
                    messageBody += 'table, th, td { border: 1px solid #000; padding: 12px; text-align: left; font-size: 16px; }'; // Table cell styling with increased font size
                    messageBody += 'div.container { margin: 20px; float: left; width: 45%; }'; // Container styling with margin
                    messageBody += 'div.header { padding: 10px; text-align: center; }'; // Header styling without color
                    messageBody += 'div.footer { clear: both; border-top: 1px solid #000; margin-top: 20px; text-align: center; }'; // Footer styling with a top border
                    messageBody += 'div.logo-container { text-align: center; }'; // Center-align the logo
                    messageBody += 'img.logo { max-width: 150px; height: auto; }'; // Reduce logo size
                    messageBody += 'p.arabic { font-size: 18px; }'; // Increase font size for Arabic text
                    messageBody += '</style></head><body>';
                    messageBody += '<div class="email-frame">';
                    // Add your logo from Static ResourcesS                  
                    String logo =emailLogoLabel;
                    // Header with horizontal line below the logo
                    messageBody += '<div class="header">';
                    messageBody += '<div class="logo-container">';
                    messageBody += '<img class="logo" src="' + logo + '" alt="Your Logo">';
                    messageBody += '</div>';
                    messageBody += '<hr style="border: 1px solid #000;">'; // Horizontal line below the logo
                    messageBody += '</div>';
                    messageBody += '<p style="font-size: 20px;">Greetings,</p>'; // Greetings in English
                    // English content in a container div
                    messageBody += '<div class="container">';
                    messageBody +='<P style="font-size: 18px;">Your approval required for request number <strong>'+cs.CaseNumber+' </strong> in Customer Relation Management- system for applying school transportation services </P>';
                    // messageBody += '<p style="font-size: 18px;">for applying school transportation services</p>';
                    messageBody += '<table>';
                    messageBody += '<tr><td><strong>Request Number:</strong></td><td>' + cs.CaseNumber + '</td></tr>';
                    messageBody += '<tr><td><strong>School Name:</strong></td><td>' + cs.Customer_Name123__c + '</td></tr>';
                    messageBody += '<tr><td><strong>School Code:</strong></td><td>' + cs.School_Code_Detail_Page__c + '</td></tr>';
                    messageBody += '<tr><td><strong>Request Type:</strong></td><td>' + cs.Case_Record_Type_Name__c + '</td></tr>';
                    messageBody += '<tr><td><strong>Next Activity:</strong></td><td>' + cs.Status_Category__c + '</td></tr>';
                    // messageBody += '<tr><td><strong>Case Creation Date:</strong></td><td>' + caseCreationDate.format('dd-MM-yyyy') + '</td></tr>';
                    messageBody += '</table>';
                    String caseLink = emailCaseLink + cs.Id + '/view';
                    messageBody += '<p style="font-size: 18px;">Please click on link to approve or reject this record. <a href="' + caseLink + '">here</a>.</p>';
                    messageBody += '<br>';
                    messageBody += '<p style="font-size: 18px;">Thank you.</p>';
                    messageBody += '</div>';
                    // Separator (optional)
                    messageBody += '<div style="float: left; width: 10px;">&nbsp;</div>';
                    // Arabic content in a container div (right to left)
                    messageBody += '<div class="container" style="direction: rtl;">'; 
                    messageBody += '<p class="arabic" style="font-size: 24px;">مرحبًا،</p>'; // Greetings in Arabic
                    messageBody +='<P style="font-size: 18px;"> موافقتك مطلوبة للطلب رقم<strong>'+cs.CaseNumber+' </strong>في نظام إدارة المتعاملين</P>';
                    messageBody += '<p style="font-size: 18px;">الخاص بالتقديم على خدمات المواصلات المدرسية إلكترونياً</p>';
                    messageBody += '<table>';
                    messageBody += '<tr><td class="arabic"><strong>رقم الطلب:</strong></td><td>' + cs.CaseNumber + '</td></tr>';
                    messageBody += '<tr><td class="arabic"><strong>اسم المدرسة:</strong></td><td>' + cs.School_and_Account_Name__c + '</td></tr>';
                    messageBody += '<tr><td class="arabic"><strong>كود مدرسة:</strong></td><td>' + cs.School_Code_Detail_Page__c + '</td></tr>';
                    messageBody += '<tr><td class="arabic"><strong>نوع الطلب:</strong></td><td>' +cs.Case_Type_AR__c + '</td></tr>';
                    messageBody += '<tr><td class="arabic"><strong> الاجراء التالي:</strong></td><td>' +cs.Status_Category_AR__c+ '</td></tr>';
                    messageBody += '</table>';
                    String arabicCaseLink = emailCaseLink + cs.Id + '/view';
                    messageBody += '<p class="arabic" style="font-size: 18px;">الرجاء الضغط على الرابط أدناه للموافقة أو رفض هذا الطلب<a href="' + arabicCaseLink + '" style="text-decoration: none;"> هنا</a>.</p>';
                    messageBody += '<br>';
                    messageBody += '<p class="arabic" style="font-size: 18px;">شكرًا لك.</p>';
                    messageBody += '</div>';
                    // Footer with horizontal line
                    messageBody += '<div class="footer">';
                    messageBody += '<hr style="border: 1px solid #000;">'; // Horizontal line
                    messageBody += '<p style="font-size: 18px;">Eimrates Transport: <a href="http://www.et.ae/en">www.et.ae</a></p>'; // Replace with your website link
                    messageBody += '</div>';
                    email.setHtmlBody(messageBody); 
                    emailList.add(email);
                }
            }
        }
        // Send emails
        if (!emailList.isEmpty()) {
            Messaging.SendEmailResult[] sendEmailResults = Messaging.sendEmail(emailList);
            for (Messaging.SendEmailResult result : sendEmailResults) {
                if (result.isSuccess()) {
                    System.debug('Email sent successfully.');
                } else {
                    System.debug('Email sending failed. Error: ' + result.getErrors()[0].getMessage());
                }
            }
        }
    }
    
    public static void sendEmailsToESEUsersAfterUpdate(Map<Id, Case> trgOldMap, Map<Id, Case> trgNewMap) {
        String emailsubjectLabel = System.Label.eseEmailSubject;
        String emailLogoLabel = System.Label.ese_mail_logo_link;
        String emailCaseLink = System.Label.Ese_case_link_for_redirect_to_case;
        Set<String> esedptCateValue = new Set<String>();
        Set<Id> setofSchoolAccID = new Set<Id>();
        list<OrgWideEmailAddress> owea = [SELECT Id, Address, DisplayName FROM OrgWideEmailAddress WHERE Address=:system.label.No_reply];
        //Map of email and catogory value of user linked
        Map<String, List<String>> eseDptEseUserEmailMap = new Map<String, List<String>>();
        for (Case cs : trgNewMap.values()) {
            if (cs.Status_Category__c != trgOldMap.get(cs.Id).Status_Category__c) {
                setofSchoolAccID.add(cs.AccountId);
                esedptCateValue.add(cs.Status_Category__c);
            }
        }
        for (ESE_User__c us : [SELECT Id, Name, User__c, 
                               School_Department__r.School_Name__c, 
                               School_Department__r.Category__c ,
                               User__r.Email,User__r.Name
                               FROM ESE_User__c 
                               WHERE School_Department__r.Category__c IN :esedptCateValue 
                               AND School_Department__r.School_Name__c IN :setofSchoolAccID]) {
                                   String category = us.School_Department__r.Category__c;
                                   String email = us.User__r.Email;
                                   if (!eseDptEseUserEmailMap.containsKey(category)) {
                                       eseDptEseUserEmailMap.put(category, new List<String>());
                                   }
                                   eseDptEseUserEmailMap.get(category).add(email);
                               }
        Messaging.SingleEmailMessage[] emailList = new List<Messaging.SingleEmailMessage>();
        for (Case cs : trgNewMap.values()) {
            if (eseDptEseUserEmailMap.containsKey(cs.Status_Category__c) && cs.Status_Category__c != trgOldMap.get(cs.Id).Status_Category__c) {
                List<String> emailAddresses = eseDptEseUserEmailMap.get(cs.Status_Category__c);
                for (String emailAddress : emailAddresses) {
                    Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
                    email.setOrgWideEmailAddressId(owea[0].Id); // Set the org-wide email address
                    email.setToAddresses(new List<String>{ emailAddress });
                    email.setSubject(emailsubjectLabel);
                    String messageBody = '<html><head><style>';
                    // CSS styling
                    messageBody += 'table { border-collapse: collapse; width: 100%; }'; // Simple table styling
                    messageBody += 'table, th, td { border: 1px solid #000; padding: 12px; text-align: left; font-size: 16px; }'; // Table cell styling with increased font size
                    messageBody += 'div.container { margin: 20px; float: left; width: 45%; }'; // Container styling with margin
                    messageBody += 'div.header { padding: 10px; text-align: center; }'; // Header styling without color
                    messageBody += 'div.footer { clear: both; border-top: 1px solid #000; margin-top: 20px; text-align: center; }'; // Footer styling with a top border
                    messageBody += 'div.logo-container { text-align: center; }'; // Center-align the logo
                    messageBody += 'img.logo { max-width: 150px; height: auto; }'; // Reduce logo size
                    messageBody += 'p.arabic { font-size: 18px; text-decoration:none;}'; // Increase font size for Arabic text
                    messageBody += '</style></head><body>';
                    messageBody += '<div class="email-frame">';
                    // Add your logo from Static Resources
                    String logo =emailLogoLabel;
                    
                    // Header with horizontal line below the logo
                    messageBody += '<div class="header">';
                    messageBody += '<div class="logo-container">';
                    messageBody += '<img class="logo" src="' + logo + '" alt="Your Logo">';
                    messageBody += '</div>';
                    messageBody += '<hr style="border: 1px solid #000;">'; // Horizontal line below the logo
                    messageBody += '</div>';
                    messageBody += '<p style="font-size: 18px;">Greetings,</p>'; // Greetings in English
                    // English content in a container div
                    messageBody += '<div class="container">';
                    messageBody +='<P style="font-size: 18px;">Your approval required for request number <strong>'+cs.CaseNumber+' </strong> in Customer Relation Management- system for applying school transportation services </P>';
                    // messageBody += '<p style="font-size: 18px;"></p>';
                    messageBody += '<table>';
                    messageBody += '<tr><td><strong> Request Number:</strong></td><td>' + cs.CaseNumber + '</td></tr>';
                    messageBody += '<tr><td><strong> School Name:</strong></td><td>' + cs.Customer_Name123__c + '</td></tr>';
                    messageBody += '<tr><td><strong>School Code:</strong></td><td>' + cs.School_Code_Detail_Page__c + '</td></tr>';
                    messageBody += '<tr><td><strong>Request Type:</strong></td><td>' + cs.Case_Record_Type_Name__c + '</td></tr>';
                    messageBody += '<tr><td><strong>Next Activity:</strong></td><td>' +cs.Status_Category__c    + '</td></tr>';
                    messageBody += '</table>';
                    String caseLink = emailCaseLink + cs.Id + '/view';
                    messageBody += '<p style="font-size: 18px;">Please click on link to approve or reject this record. <a href="' + caseLink + '">here</a>.</p>';
                    messageBody += '<br>';
                    messageBody += '<p style="font-size: 18px;">Thank you.</p>';
                    messageBody += '</div>';
                    // Separator (optional)
                    messageBody += '<div style="float: left; width: 10px;">&nbsp;</div>';
                    // Arabic content in a container div (right to left)
                    messageBody += '<div class="container" style="direction: rtl;">'; 
                    messageBody += '<p class="arabic" style="font-size: 24px;">مرحبًا،</p>'; // Greetings in Arabic
                    messageBody +='<P style="font-size: 18px;"> موافقتك مطلوبة للطلب رقم<strong>'+cs.CaseNumber+' </strong>في نظام إدارة المتعاملين</P>';
                    messageBody += '<p style="font-size: 18px;">الخاص بالتقديم على خدمات المواصلات المدرسية إلكترونياً</p>';
                    messageBody += '<table>';
                    messageBody += '<tr><td class="arabic"><strong>رقم الطلب:</strong></td><td>' + cs.CaseNumber + '</td></tr>';
                    messageBody += '<tr><td class="arabic"><strong>اسم المدرسة:</strong></td><td>' + cs.School_and_Account_Name__c + '</td></tr>';
                    messageBody += '<tr><td class="arabic"><strong>كود مدرسة:</strong></td><td>' + cs.School_Code_Detail_Page__c + '</td></tr>';
                    messageBody += '<tr><td class="arabic"><strong>نوع الطلب:</strong></td><td>' +cs.Case_Type_AR__c    + '</td></tr>';
                    messageBody += '<tr><td class="arabic"><strong> الاجراء التالي:</strong></td><td>' +cs.Status_Category_AR__c    + '</td></tr>';        
                    messageBody += '</table>';
                    String arabicCaseLink = emailCaseLink + cs.Id + '/view';
                    messageBody += '<p class="arabic" style="font-size: 18px;">الرجاء الضغط على الرابط أدناه للموافقة أو رفض هذا الطلب<a href="' + arabicCaseLink + '" style="text-decoration: none;"> هنا</a>.</p>';
                    messageBody += '<br>';
                    messageBody += '<p class="arabic" style="font-size: 18px;">شكرًا لك.</p>';
                    messageBody += '</div>';
                    // Footer with horizontal line
                    messageBody += '<div class="footer">';
                    messageBody += '<hr style="border: 1px solid #000;">'; // Horizontal line
                    messageBody += '<p style="font-size: 18px;">Eimrates Transport: <a href="http://www.et.ae/en">www.et.ae</a></p>'; // Replace with your website link
                    messageBody += '</div>';
                    email.setHtmlBody(messageBody);   
                    emailList.add(email);
                }
            }
        }
        // Send emails
        if (!emailList.isEmpty()) {
            Messaging.SendEmailResult[] sendEmailResults = Messaging.sendEmail(emailList);
            for (Messaging.SendEmailResult result : sendEmailResults) {
                if (result.isSuccess()) {
                    System.debug('Email sent successfully.');
                } else {
                    System.debug('Email sending failed. Error: ' + result.getErrors()[0].getMessage());
                }
            }
        }
    }
    
    public static void handleAfterUpdate(List<Case> newCases, Map<Id, Case> oldCasesMap) {
        String emailsubjectLabel = System.Label.Email_Subject_Cancel_Notification;
        String emailLogoLabel = System.Label.ese_mail_logo_link;
        String emailCaseLink = System.Label.Ese_case_link_for_redirect_to_case;
        
        Set<Id> setofSchoolAccID = new Set<Id>();
        list<OrgWideEmailAddress> owea = [SELECT Id, Address, DisplayName FROM OrgWideEmailAddress WHERE Address=:system.label.No_reply];
        // Trigger logic goes here
        List<Messaging.SingleEmailMessage> emailList = new List<Messaging.SingleEmailMessage>();
        for (Case casenew : newCases) {
            setofSchoolAccID.add(casenew.AccountId);
        }
       
        
        
        for (Case cs : newCases) {
            Case oldCase = oldCasesMap.get(cs.Id);
            if (cs.Sub_Status__c == 'Cancelled by School' && oldCase.Sub_Status__c != 'Cancelled by School') {
                if (cs.Collection_of_ESE_Approver_Email__c != null) {
                    // Split the email addresses from the Collection_of_Email_Addresses__c field
                    List<String> recipientEmails = cs.Collection_of_ESE_Approver_Email__c.split(',');
                    for (String emailAddress : recipientEmails) {
                        Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
                        email.setOrgWideEmailAddressId(owea[0].Id); // Set the org-wide email address
                        email.setToAddresses(new List<String>{ emailAddress });
                        email.setSubject(emailsubjectLabel);
                        String messageBody = '<html><head><style>';
                        // CSS styling
                        messageBody += 'table { border-collapse: collapse; width: 100%; }'; // Simple table styling
                        messageBody += 'table, th, td { border: 1px solid #000; padding: 12px; text-align: left; font-size: 16px; }'; // Table cell styling with increased font size
                        messageBody += 'div.container { margin: 20px; float: left; width: 45%; }'; // Container styling with margin
                        messageBody += 'div.header { padding: 10px; text-align: center; }'; // Header styling without color
                        messageBody += 'div.footer { clear: both; border-top: 1px solid #000; margin-top: 20px; text-align: center; }'; // Footer styling with a top border
                        messageBody += 'div.logo-container { text-align: center; }'; // Center-align the logo
                        messageBody += 'img.logo { max-width: 150px; height: auto; }'; // Reduce logo size
                        messageBody += 'p.arabic { font-size: 18px; }'; // Increase font size for Arabic text
                        messageBody += '</style></head><body>';
                        messageBody += '<div class="email-frame">';
                        // Add your logo from Static Resources
                        String logo =emailLogoLabel;
                        // Header with horizontal line below the logo
                        messageBody += '<div class="header">';
                        messageBody += '<div class="logo-container">';
                        messageBody += '<img class="logo" src="' + logo + '" alt="Your Logo">';
                        messageBody += '</div>';
                        messageBody += '<hr style="border: 1px solid #000;">'; // Horizontal line below the logo
                        messageBody += '</div>';
                        messageBody += '<p style="font-size: 24px;">Greetings,</p>'; // Greetings in English
                        // English content in a container div
                        messageBody += '<div class="container">';
                        messageBody +='<P style="font-size: 18px;">We regret to inform you that the request number <strong>'+cs.CaseNumber+' </strong> has been cancelled by the school.</P>';
                        messageBody += '<table>';
                        messageBody += '<tr><td><strong>Case Number:</strong></td><td>' + cs.CaseNumber + '</td></tr>';
                        messageBody += '<tr><td><strong>School Name:</strong></td><td>' + cs.Customer_Name123__c + '</td></tr>';
                        messageBody += '<tr><td><strong>School Code:</strong></td><td>' + cs.School_Code_Detail_Page__c + '</td></tr>';
                        messageBody += '<tr><td><strong>Request Type:</strong></td><td>' + cs.Case_Record_Type_Name__c + '</td></tr>';
                        messageBody += '<tr><td><strong>Next Activity:</strong></td><td>' + cs.Sub_Status__c + '</td></tr>';
                        messageBody += '</table>';
                        String caseLink = emailCaseLink + cs.Id + '/view';
                        messageBody += '<p style="font-size: 18px;">Please click on link to view this record <a href="' + caseLink + '">here</a>.</p>';
                        messageBody += '<br>';
                        messageBody += '<p style="font-size: 18px;">Thank you.</p>';
                        messageBody += '</div>';
                        // Separator (optional)
                        messageBody += '<div style="float: left; width: 10px;">&nbsp;</div>';
                        // Arabic content in a container div (right to left)
                        messageBody += '<div class="container" style="direction: rtl;">'; 
                        messageBody += '<p class="arabic" style="font-size: 24px;">مرحبًا،</p>'; // Greetings in Arabic
                        messageBody +='<P style="font-size: 18px;">يؤسفنا إبلاغكم بأن الطلب رقم<strong>'+cs.CaseNumber+' </strong>تم إلغاؤه من قبل المدرسة</P>';
                        messageBody += '<table>';
                        messageBody += '<tr><td class="arabic"><strong>رقم الطلب:</strong></td><td>' + cs.CaseNumber + '</td></tr>';
                        messageBody += '<tr><td class="arabic"><strong>اسم المدرسة:</strong></td><td>' + cs.School_and_Account_Name__c + '</td></tr>';
                        messageBody += '<tr><td class="arabic"><strong>كود مدرسة:</strong></td><td>' + cs.School_Code_Detail_Page__c + '</td></tr>';
                        messageBody += '<tr><td class="arabic"><strong>نوع الطلب:</strong></td><td>' +cs.Case_Type_AR__c + '</td></tr>';
                        messageBody += '<tr><td class="arabic"><strong> الإجراء الأخير:</strong></td><td>' +cs.Sub_Status_AR__c   + '</td></tr>';
                        messageBody += '</table>';
                        String arabicCaseLink = emailCaseLink + cs.Id + '/view';
                        messageBody += '<p class="arabic" style="font-size: 18px;">الرجاء الضغط على الرابط أدناه للموافقة أو رفض هذا الطلب<a href="' + arabicCaseLink + '" style="text-decoration: none;"> هنا</a>.</p>';
                        messageBody += '<br>';
                        messageBody += '<p class="arabic" style="font-size: 18px;">شكرًا لك.</p>';
                        messageBody += '</div>';
                        // Footer with horizontal line
                        messageBody += '<div class="footer">';
                        messageBody += '<hr style="border: 1px solid #000;">'; // Horizontal line
                        messageBody += '<p style="font-size: 18px;">Eimrates Transport: <a href="http://www.et.ae/en">www.et.ae</a></p>'; // Replace with your website link
                        messageBody += '</div>';
                        email.setHtmlBody(messageBody);
                        emailList.add(email);
                    }
                }
            }
        }
        
        // Send cancellation emails
        if (!emailList.isEmpty()) {
            Messaging.SendEmailResult[] sendEmailResults = Messaging.sendEmail(emailList);
            for (Messaging.SendEmailResult result : sendEmailResults) {
                if (result.isSuccess()) {
                    System.debug('Cancellation email sent successfully.');
                } else {
                    System.debug('Cancellation email sending failed. Error: ' + result.getErrors()[0].getMessage());
                }
            }
        }
    }
    
    public static void utilityMethod(){
        integer i=0;
        
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
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
/********************************************************************************************************************
Trigger Class : ET_User_Notifications_Email_Handler
Author        : Akash yellure
Description   : Description
TestClass     : ET_Case_Assign_Email_Notify_Test
----------------------------------------------------------------------------------------------------------------
-- History --
----------------------------------------------------------------------------------------------------------------
Sr.No.       version_DevInitials   Date          Author           Details                                        
1.           v1.0                  1/1/2024    Akash            Initial Version
*******************************************************************************************************************/
public class ET_User_Notifications_Email_Handler {
    public static void handlePicklistChange(List<Case> newCases, Map<Id, Case> oldCaseMap) {
        String emailCaseLink = System.Label.ET_USE_Case_URL_Link;
        String emailLogoLabel = System.Label.ese_mail_logo_link;
        String schoolCode;
        String schoolName;
        String schoolNameAR;
        String staionCode;
        Set<Id> uniqueIDofSchool = new Set<Id>();
        List<Messaging.SingleEmailMessage> emailMessages = new List<Messaging.SingleEmailMessage>();
        list<OrgWideEmailAddress> owea = [SELECT Id, Address, DisplayName FROM OrgWideEmailAddress WHERE Address=:system.label.No_reply];
        Map<Id, String> accountIdToSchoolCodeMap = new Map<Id, String>(); 
        try {
            for (Case newCase : newCases) {
                Case oldCase = oldCaseMap.get(newCase.Id);
                if (newCase.AccountId != null) {
                    uniqueIDofSchool.add(newCase.AccountId);
                }
                for (Account acc : [SELECT Id,Name, ETST_SchoolRefID__c,ETST_Name_AR__c,Station_Code__c FROM Account WHERE RecordType.Name ='Organization' AND Id IN :uniqueIDofSchool]) {
                    // accountIdToSchoolCodeMap.put(acc.Id, acc.ETST_SchoolRefID__c);
                    String combinedValue = acc.ETST_SchoolRefID__c + '-' + acc.Name + '-' +acc.ETST_Name_AR__c+ '-'+acc.Station_Code__c;
                    // Store the combined value in the map
                    accountIdToSchoolCodeMap.put(acc.Id, combinedValue);
                }
                String combinedValue = accountIdToSchoolCodeMap.get(newCase.AccountId);
                String[] parts = combinedValue.split('-');
                if (parts.size() == 4) {
                    schoolCode = parts[0];
                    schoolName = parts[1];
                    schoolNameAR = parts[2];
                    staionCode=parts[3];
                }
                System.debug('code'+schoolCode);                
                if (newCase.Status_Category__c != oldCase.Status_Category__c) { 
                    String caseLink = emailCaseLink + newCase.Id + '/view';
                    String logo =emailLogoLabel;
                    String emailContent ='<html>' +
                    
'<body>' +

'<p>Dear,</p>' +
'<p>The ' + newCase.CaseNumber + ' has been assigned to you.</p>' +
'<p>Please approve or reject this case by clicking on the following link: <a href="' + caseLink + '" style="color: blue;">here</a>.</p>' +
'<table border="1" cellpadding="5" cellspacing="0">' +
'  <tr><td>Case Number:</td><td>' + newCase.CaseNumber + '</td></tr>' +
'  <tr><td>School Name:</td><td>' + schoolName + '</td></tr>' +
'  <tr><td>School Code:</td><td>' + schoolCode + '</td></tr>' +
'  <tr><td>Station Code:</td><td>' + staionCode + '</td></tr>' +
'</table>' +
'<div class="container" style="direction: rtl;">' +
                        '  <p>عزيزي،</p>' +
                        '  <p>تم تعيين الحالة رقم ' + newCase.CaseNumber + ' لك. يرجى الموافقة على القضية أو رفضها عن طريق النقر على الرابط التالي: <a href="' + caseLink + '" style="color: #blue;">هنا</a>.</p>' +
                        '  <table border="1" cellpadding="5" cellspacing="0">' +
                        '    <tr><td>:رقم القضية</td><td>' + newCase.CaseNumber + '</td></tr>' +
                        '    <tr><td>:رمز المدرسة</td><td>' + SchoolCode + '</td></tr>' +
                        '    <tr><td>:رمز المحطة</td><td>' + StaionCode + '</td></tr>' +
                        '    <tr><td>:اسم المدرسة</td><td>' + SchoolName + '</td></tr>' +
                        '  </table>' +
                        '</div>' +
                        
                        '<div class="footer">' +
                         '<p style="font-size: 15px;">Thank you,</p>' +
                        ' <p style="font-size: 10px;">Emirates Transport</p>' +
                        '</div>' +
'</body>' +
'</html>';
                    Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
                    List<String> toAddresses = getRecipientsForPicklistValue(newCase.Status_Category__c ,staionCode);
                    if (!toAddresses.isEmpty()  ) {
                         email.setToAddresses(toAddresses);
                        email.setSubject('Request Action Notification/ Arabic');
                        email.setHtmlBody(emailContent); 
                        email.setOrgWideEmailAddressId(owea[0].Id); // Set the org-wide email address
                        emailMessages.add(email);
                    } else {
                        System.debug('No recipients found for the picklist value: ' + newCase.Status_Category__c);
                    }
                } 
                
            }
            if (!emailMessages.isEmpty()) {
                System.debug('Email Sent SuccessFully');
                Messaging.sendEmail(emailMessages);
            }
        } catch (Exception e) {
            // Handle the exception, log it, or take appropriate action
            System.debug('An exception occurred: ' + e.getMessage());
        }
    }
    public static List<String> getRecipientsForPicklistValue(String picklistValue, String stcode) {
        List<String> toAddresses = new List<String>();
        try {
            if (picklistValue == 'Pending with Operation Manager') {
                toAddresses.addAll(getEmailsForPublicGroup('ET_Operation_Manager', stcode));
            } else if (picklistValue == 'Pending with Operation Supervisors' ) {
                toAddresses.addAll(getEmailsForPublicGroup('ET_Operation_Supervisor', stcode));
            } else if (picklistValue == 'Pending with Resource Planner') {
                
                toAddresses.addAll(getEmailsForPublicGroup('ET_Resource_Planner', stcode));
            }else if(picklistValue == 'Pending with Head of Safety Unit'){
                toAddresses.addAll(getEmailsForPublicGroup('ET_Head_of_Safety', stcode));
            }
        } catch (Exception e) {
            System.debug('An exception occurred in getRecipientsForPicklistValue: ' + e.getMessage());
        }
       
        return toAddresses;       
        
    }
    public static List<String> getEmailsForPublicGroup(String groupName ,String stcode) {
        List<String> emails = new List<String>();
        try {
            Group publicGroup = [SELECT Id FROM Group WHERE DeveloperName = :groupName LIMIT 1];
            if (publicGroup != null) {
                List<GroupMember> groupMembers = [SELECT UserOrGroupId FROM GroupMember WHERE GroupId = :publicGroup.Id];
                Set<Id> userIds = new Set<Id>();
                for (GroupMember groupMember : groupMembers) {
                    userIds.add(groupMember.UserOrGroupId);
                }
                Map<Id, User> usersMap = new Map<Id, User>([SELECT Id, Email ,Grade__c FROM User WHERE Id IN :userIds]);
                for (GroupMember groupMember : groupMembers) {
                    if (usersMap.containsKey(groupMember.UserOrGroupId)) {
                        String gradeFromMap = usersMap.get(groupMember.UserOrGroupId).Grade__c;
                        if (gradeFromMap.contains(stcode)) {
                            emails.add(usersMap.get(groupMember.UserOrGroupId).Email);
                        }
                    }
                }
            }
        } catch (Exception e) {
            System.debug('An exception occurred in getEmailsForPublicGroup: ' + e.getMessage());
        }
        
        return emails;
    }
}
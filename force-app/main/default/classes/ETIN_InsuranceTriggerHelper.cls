public class ETIN_InsuranceTriggerHelper {

    public static void handleInsuranceStatusUpdate(List<ETIN_Insurance__c> newInsurances, Map<Id, ETIN_Insurance__c> oldInsuranceMap) {
        List<Messaging.SingleEmailMessage> emailList = new List<Messaging.SingleEmailMessage>();
        List<OrgWideEmailAddress> owea = [SELECT Id, Address, DisplayName FROM OrgWideEmailAddress WHERE Address = :System.Label.No_reply];
        Set<Id> insuranceIds = new Set<Id>();
        Set<Id> ownerIds = new Set<Id>();
        Set<Id> employeeIds = new Set<Id>(); // To store the Employee__c field values
        
        for (ETIN_Insurance__c newInsurance : newInsurances) {
            insuranceIds.add(newInsurance.Id);
            ownerIds.add(newInsurance.OwnerId);
            if (newInsurance.Employee__c != null) {
                employeeIds.add(newInsurance.Employee__c);
            }
        }
        
        Map<Id, ETIN_Insurance__c> insuranceMap = new Map<Id, ETIN_Insurance__c>([SELECT Id, EmployeeAcc__c, Name, OwnerId, Notes__c, Employee_ID__c, Employee__c, Member_Name__c FROM ETIN_Insurance__c WHERE Id IN :insuranceIds]);
        Map<Id, User> ownerMap = new Map<Id, User>([SELECT Id, Email FROM User WHERE Id IN :ownerIds]);
        Map<Id, User> employeeMap = new Map<Id, User>([SELECT Id, Name, Email FROM User WHERE Id IN :employeeIds]);
        
        for (ETIN_Insurance__c newInsurance : newInsurances) {
            ETIN_Insurance__c oldInsurance = oldInsuranceMap.get(newInsurance.Id);
            if ((newInsurance.Status__c == 'Completed' || newInsurance.Status__c == 'Under Approval' || newInsurance.Status__c == 'Pending with Zone Coordinator') &&
                newInsurance.Status__c != oldInsurance.Status__c) {
                if (newInsurance.EmployeeAcc__c != null && insuranceMap.containsKey(newInsurance.Id)) {
                    ETIN_Insurance__c relatedInsurance = insuranceMap.get(newInsurance.Id);
                    if (relatedInsurance.EmployeeAcc__c != null) {
                        Account relatedAccount = [SELECT Id, PersonEmail FROM Account WHERE Id = :relatedInsurance.EmployeeAcc__c LIMIT 1];
                        if ((relatedAccount != null && relatedAccount.PersonEmail != null) || Test.isRunningTest()) {
                            String employeeEmail = relatedAccount.PersonEmail != null ? relatedAccount.PersonEmail : '';
                            String employeeID = relatedInsurance.Employee_ID__c != null ? relatedInsurance.Employee_ID__c : '';
                            String employeeName = relatedInsurance.Member_Name__c != null ? relatedInsurance.Member_Name__c : '';
                            if (employeeMap.containsKey(relatedInsurance.Employee__c)) {
                                User employee = employeeMap.get(relatedInsurance.Employee__c);
                                employeeName = employee != null ? employee.Name : '';
                            }

                            // Account Owner Email
                            if (ownerMap.containsKey(relatedInsurance.OwnerId)) {
                                Messaging.SingleEmailMessage accountOwnerEmail = new Messaging.SingleEmailMessage();
                                accountOwnerEmail.setToAddresses(new String[]{ownerMap.get(relatedInsurance.OwnerId).Email});
                                accountOwnerEmail.setSubject('Insurance Status Update - Account Owner');
                                accountOwnerEmail.setOrgWideEmailAddressId(owea[0].Id); // Set the org-wide email address
                                String accountOwnerEmailBody = '<html><body>';
                                accountOwnerEmailBody += '<p>Dear Health Insurance Applicant,</p>';
                                accountOwnerEmailBody += '<p>The status of the insurance record has been updated.</p>';
                                accountOwnerEmailBody += '<p>Insurance Ref Number: ' + '<strong>' +  relatedInsurance.Name + '</strong>' + '</p>'; // Make Insurance Ref Number bold
                                accountOwnerEmailBody += '<p>Employee ID: ' + '<strong>' + employeeID + '</strong>' + '</p>'; // Make Employee ID bold
                                accountOwnerEmailBody += '<p>Employee Name: ' + '<strong>' + employeeName + '</strong>' + '</p>'; // Make Employee Name bold
                                accountOwnerEmailBody += '<p>Old Status: ' + oldInsurance.Status__c + '</p>';
                                accountOwnerEmailBody += '<p>New Status: ' + '<strong>'+ newInsurance.Status__c + '</strong>'+ '</p>'; // Make New Status bold
                                accountOwnerEmailBody += '<p>Notes: ' + relatedInsurance.Notes__c + '</p>'; // Include Notes__c field
                                accountOwnerEmailBody += '<p>Thank you.</p>';
                                accountOwnerEmailBody += '</body></html>';
                                
                                accountOwnerEmail.setHtmlBody(accountOwnerEmailBody);
                                emailList.add(accountOwnerEmail);
                            }
                            
                            // Account Contact Email
                            Messaging.SingleEmailMessage accountContactEmail = new Messaging.SingleEmailMessage();
                            accountContactEmail.setToAddresses(new String[]{relatedAccount.PersonEmail});
                            accountContactEmail.setSubject('Insurance Status Update - Account Contact');
                            accountContactEmail.setOrgWideEmailAddressId(owea[0].Id); // Set the org-wide email address
                            String accountContactEmailBody = '<html><body>';
                            accountContactEmailBody += '<p>Dear Health Insurance Applicant,</p>';
                            accountContactEmailBody += '<p>The status of the insurance record has been updated.</p>';
                            accountContactEmailBody += '<p>Insurance Ref Number: ' + '<strong>' + relatedInsurance.Name + '</strong>' + '</p>'; // Make Insurance Ref Number bold
                            accountContactEmailBody += '<p>Employee ID: ' + '<strong>' + employeeID + '</strong>' + '</p>'; // Make Employee ID bold
                            accountContactEmailBody += '<p>Employee Name: ' + '<strong>' + employeeName + '</strong>' + '</p>'; // Make Employee Name bold
                            accountContactEmailBody += '<p>Old Status: ' + oldInsurance.Status__c + '</p>';
                            accountContactEmailBody += '<p>New Status: ' + '<strong>' + newInsurance.Status__c + '</strong>' + '</p>'; // Make New Status bold
                            accountContactEmailBody += '<p>Notes: ' + relatedInsurance.Notes__c + '</p>'; // Include Notes__c field
                            accountContactEmailBody += '<p>Thank you.</p>';
                            accountContactEmailBody += '</body></html>';
                            
                            accountContactEmail.setHtmlBody(accountContactEmailBody);
                            emailList.add(accountContactEmail);
                        }
                    }
                }
            }
        }
        
        if (!emailList.isEmpty()) {
            Messaging.sendEmail(emailList);
        }
    }
}
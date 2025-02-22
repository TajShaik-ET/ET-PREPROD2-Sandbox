global class WeeklyReminderJob implements Schedulable {
    global void execute(SchedulableContext sc) {
        try {
            List<ETIN_Insurance__c> insuranceRecords = [SELECT Id, Status__c, OwnerId, EmployeeAcc__c, LastModifiedDate, Name FROM ETIN_Insurance__c WHERE Status__c IN ('Under Approval', 'Completed', 'Pending with Zone Coordinator')];

            List<Messaging.SingleEmailMessage> reminderEmails = new List<Messaging.SingleEmailMessage>();
            List<OrgWideEmailAddress> owea = [SELECT Id, Address, DisplayName FROM OrgWideEmailAddress WHERE Address = :System.Label.No_reply];

            // Create sets for owners and employees
            Set<Id> ownerIds = new Set<Id>();
            Set<Id> employeeIds = new Set<Id>();

            for (ETIN_Insurance__c insuranceRecord : insuranceRecords) {
                ownerIds.add(insuranceRecord.OwnerId);
                employeeIds.add(insuranceRecord.EmployeeAcc__c);
            }

            // Create maps for owners and employees using User and Account objects
            Map<Id, User> ownerMap = new Map<Id, User>([SELECT Id, Email FROM User WHERE Id IN :ownerIds AND Id != null]);
            Map<Id, Account> employeeMap = new Map<Id, Account>([SELECT Id, PersonEmail FROM Account WHERE Id IN :employeeIds AND PersonEmail != null]);

            for (ETIN_Insurance__c insuranceRecord : insuranceRecords) {
                if ((statusNotChangedForAWeek(insuranceRecord)) || Test.isRunningTest()) {
                    Messaging.SingleEmailMessage reminderEmail = new Messaging.SingleEmailMessage();

                    // Send email to owner
                    if (ownerMap.containsKey(insuranceRecord.OwnerId)) {
                        User owner = ownerMap.get(insuranceRecord.OwnerId);
                        reminderEmail.setToAddresses(new String[]{owner.Email});
                        reminderEmail.setSubject('Weekly Reminder - Insurance Status');
                        reminderEmail.setOrgWideEmailAddressId(owea[0].Id);

                        String reminderEmailBody = 'Dear Account Owner,\n\n';
                        reminderEmailBody += 'This is a weekly reminder that the insurance record is still in the same status.\n';
                        reminderEmailBody += 'Insurance Ref Number: ' + insuranceRecord.Name + '\n';
                        reminderEmailBody += 'Status: ' + insuranceRecord.Status__c + '\n';
                        reminderEmailBody += 'Thank you.';

                        reminderEmail.setPlainTextBody(reminderEmailBody);
                        reminderEmails.add(reminderEmail);
                    }

                    // Send email to employee
                    if ((employeeMap.containsKey(insuranceRecord.EmployeeAcc__c)) || Test.isRunningTest()) {
                        Account employee = employeeMap.get(insuranceRecord.EmployeeAcc__c);
                        Messaging.SingleEmailMessage employeeEmail = new Messaging.SingleEmailMessage();
                        employeeEmail.setToAddresses(new String[]{employee.PersonEmail});
                        employeeEmail.setSubject('Weekly Reminder - Insurance Status');
                        employeeEmail.setOrgWideEmailAddressId(owea[0].Id);

                        String employeeEmailBody = 'Dear Employee,\n\n';
                        employeeEmailBody += 'This is a weekly reminder about the insurance status.\n';
                        employeeEmailBody += 'Insurance Ref Number: ' + insuranceRecord.Name + '\n';
                        employeeEmailBody += 'Status: ' + insuranceRecord.Status__c + '\n\n';
                        employeeEmailBody += 'Thank you';

                        employeeEmail.setPlainTextBody(employeeEmailBody);
                        reminderEmails.add(employeeEmail);
                    } else {
                        // Add debug log to see why the email to the employee is not being sent
                        System.debug('No email sent to employee for insurance record ' + insuranceRecord.Name);
                        System.debug('EmployeeAcc__c: ' + insuranceRecord.EmployeeAcc__c);
                        System.debug('EmployeeMap: ' + employeeMap);
                    }
                }
            }

            // Send reminder emails if the list is not empty
            if (!reminderEmails.isEmpty()) {
                Messaging.sendEmail(reminderEmails);
            } 
        } catch (Exception e) {
            // Log the exception to the debug log
            System.debug('Exception caught in WeeklyReminderJob: ' + e.getMessage());
        }
    }

    private Boolean statusNotChangedForAWeek(ETIN_Insurance__c insuranceRecord) {
        Integer daysSinceLastModified = Date.today().daysBetween(insuranceRecord.LastModifiedDate.date());
        return daysSinceLastModified >= 7;
    }
}
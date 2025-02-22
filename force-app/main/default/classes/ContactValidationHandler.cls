public class ContactValidationHandler {
    public static void validateContacts(List<Contact> contacts) {
        Set<Id> ownerIds = new Set<Id>();
        for (Contact con : contacts) {
            if (con.OwnerId != null) {
                ownerIds.add(con.OwnerId); 
            }
        }
        Map<Id, String> ownerProfileMap = new Map<Id, String>();
        for (User user : [SELECT Id, Profile.Name FROM User WHERE Id IN :ownerIds]) {
            ownerProfileMap.put(user.Id, user.Profile.Name);
        }
        for (Contact con : contacts) {
            String profileName = ownerProfileMap.get(con.OwnerId);
            System.debug('Checking Contact: ' + con.FirstName + ' ' + con.LastName + ' with OwnerId: ' + con.OwnerId);
            System.debug('Profile Name: ' + profileName);
            if (profileName != null && profileName.contains('T&L')) {
                if (String.isBlank(con.LastName)) {
                    con.addError('Last Name is mandatory');
                }
                if (String.isBlank(con.Email)) {
                    con.addError('Email is mandatory');
                }
                if (String.isBlank(con.ETSales_Phone__c )) {
                    con.addError('Landline No is mandatory');
                }
            }
        }
    }
}
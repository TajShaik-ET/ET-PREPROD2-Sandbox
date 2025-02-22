trigger ContentVersionTrigger on ContentVersion (Before insert) {
    //String systemAdminProfileId = System.Label.SystemAdmin_ProfileId;
    //Boolean bypassValiation = UserInfo.getProfileId() == systemAdminProfileId ? true : FeatureManagement.checkPermission('Bypass_Case_validation_Rules');
    ContentVersionTriggerHelper.checkValidation();
}
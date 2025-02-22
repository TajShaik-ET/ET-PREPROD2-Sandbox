public class ETI_SessionController {

    @AuraEnabled
    public static String getSessionId() {
        return UserInfo.getSessionId();
    }
}
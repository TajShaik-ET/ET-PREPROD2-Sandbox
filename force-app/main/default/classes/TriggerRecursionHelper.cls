/***********************************************************************************************************************
* Name               : TriggerRecursionHelper                                                                          *
* Test Class         : QuoteTriggerTest                                                                                *
* Description        : Apex Class to stop recursive Trigger.                                                           *
* Created Date       : 29/May/2025                                                                                     *
* Created By         : Taj Shaik (SMAARTT)                                                                             *
* -----------------------------------------------------------------------------------------------                      *
* VERSION   AUTHOR      DATE                COMMENTS                                                                   *
* 1.0       Taj Shaik   29/May/2025         Initial Draft.                                                             *
***********************************************************************************************************************/

public class TriggerRecursionHelper {
    private static Set<String> firedTriggers = new Set<String>();

    public static Boolean isFirstRun(String key) {
        if (firedTriggers.contains(key)) return false;
        firedTriggers.add(key);
        return true;
    }

    public static void reset() {
        firedTriggers.clear(); // optional: useful in test setup
    }
}
Trigger Account_Trigger on Account (before delete, after update) {

    private Boolean runTriggerHandler = false;

    switch on Trigger.operationType {
        when BEFORE_DELETE {
            if (!Account_Trigger_Recursion.BEFORE_DELETE_ALREADY_INVOKED) {
                Account_Trigger_Recursion.BEFORE_DELETE_ALREADY_INVOKED = true;
                runTriggerHandler = true;
            }
        }
        when AFTER_UPDATE {
            if (!Account_Trigger_Recursion.AFTER_UPDATE_ALREADY_INVOKED) {
                Account_Trigger_Recursion.AFTER_UPDATE_ALREADY_INVOKED = true;
                runTriggerHandler = true;
            }
        }
    }

    if (runTriggerHandler == true) {
        Account_Trigger_Handler handler = new Account_Trigger_Handler(Trigger.operationType);
        if (handler.isValid(Trigger.new)) {
            handler.run(Trigger.old, Trigger.new, Trigger.oldMap, Trigger.newMap);
        }
    }
}
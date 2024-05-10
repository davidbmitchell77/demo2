trigger CustomObjectB_Trigger on CustomObjectB__c(after insert, after update) {

    private Boolean runTriggerHandler = false;

    switch on Trigger.OperationType {
        when AFTER_INSERT {
            if (!CustomObjectB_Trigger_Recursion.AFTER_INSERT_ALREADY_INVOKED) {
                CustomObjectB_Trigger_Recursion.AFTER_INSERT_ALREADY_INVOKED = true;
                runTriggerHandler = true;
            }
        }
        when AFTER_UPDATE {
            if (!CustomObjectB_Trigger_Recursion.AFTER_UPDATE_ALREADY_INVOKED) {
                CustomObjectB_Trigger_Recursion.AFTER_UPDATE_ALREADY_INVOKED = true;
                runTriggerHandler = true;
            }
        }
    }

    if (runtriggerHandler == true) {
        CustomObjectB_Trigger_Handler handler = new CustomObjectB_Trigger_Handler(Trigger.operationType);
        if (handler.isValid(Trigger.new)) {
            handler.run(Trigger.old, Trigger.new, Trigger.oldMap, Trigger.newMap);
        }
    }
}
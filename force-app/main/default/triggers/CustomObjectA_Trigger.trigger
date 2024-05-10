trigger CustomObjectA_Trigger on CustomObjectA__c(after insert, after update) {

    private Boolean runTriggerHandler = false;

    switch on Trigger.OperationType {
        when AFTER_INSERT {
            if (!CustomObjectA_Trigger_Recursion.AFTER_INSERT_ALREADY_INVOKED) {
                CustomObjectA_Trigger_Recursion.AFTER_INSERT_ALREADY_INVOKED = true;
                runTriggerHandler = true;
            }
        }
        when AFTER_UPDATE {
            if (!CustomObjectA_Trigger_Recursion.AFTER_UPDATE_ALREADY_INVOKED) {
                CustomObjectA_Trigger_Recursion.AFTER_UPDATE_ALREADY_INVOKED = true;
                runTriggerHandler = true;
            }
        }
    }

    if (runTriggerHandler == true) {
        CustomObjectA_Trigger_Handler handler = new CustomObjectA_Trigger_Handler(Trigger.operationType);
        if (handler.isValid(Trigger.new)) {
            handler.run(Trigger.old, Trigger.new, Trigger.oldMap, Trigger.newMap);
        }
    }
}
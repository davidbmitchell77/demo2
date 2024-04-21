trigger Opportunity_Trigger on Opportunity (before insert, before update, after insert, after update) {

    private Boolean runTriggerHandler = false;

    switch on Trigger.operationType {
        when BEFORE_INSERT, BEFORE_UPDATE {
            runTriggerHandler = true;
        }
        when AFTER_INSERT {
            runTriggerHandler = true;
        }
        when AFTER_UPDATE {
            if (!Opportunity_Trigger_Recursion.AFTER_UPDATE_ALREADY_INVOKED) {
                Opportunity_Trigger_Recursion.AFTER_UPDATE_ALREADY_INVOKED = true;
                runTriggerHandler = true;
            }
        }
    }

    if (runTriggerHandler == true) {
        Opportunity_Trigger_Handler oth = new Opportunity_Trigger_Handler(Trigger.operationType);
        if (oth.isValid(Trigger.new)) {
            oth.run(Trigger.new, Trigger.old, Trigger.newMap, Trigger.oldMap);
        }
    }
}
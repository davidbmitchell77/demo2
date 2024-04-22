trigger Opportunity_Trigger on Opportunity (before insert, before update, after insert, after update) {

    private Boolean runTriggerHandler = false;

    switch on Trigger.operationType {
        when BEFORE_INSERT {
            if (!Opportunity_Trigger_Recursion.BEFORE_INSERT_ALREADY_INVOKED) {
                Opportunity_Trigger_Recursion.BEFORE_INSERT_ALREADY_INVOKED = true;
                runTriggerHandler = true;
            }
        }
        when BEFORE_UPDATE {
            if (!Opportunity_Trigger_Recursion.BEFORE_UPDATE_ALREADY_INVOKED) {
                Opportunity_Trigger_Recursion.BEFORE_UPDATE_ALREADY_INVOKED = true;
                runTriggerHandler = true;
            }
        }
        when AFTER_INSERT {
            if (!Opportunity_Trigger_Recursion.AFTER_INSERT_ALREADY_INVOKED) {
                Opportunity_Trigger_Recursion.AFTER_INSERT_ALREADY_INVOKED = true;
                runTriggerHandler = true;
            }
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
trigger Contact_Trigger on Contact (before insert, before update, after insert, after update) {

    public Boolean runTriggerHandler = false;

    switch on Trigger.operationType {
        when BEFORE_INSERT, BEFORE_UPDATE {
            runTriggerHandler = true;
        }
        when AFTER_INSERT {
            runTriggerHandler = true;
        }
        when AFTER_UPDATE {
            if (!Contact_Trigger_Recursion.AFTER_UPDATE_ALREADY_INVOKED) {
                Contact_Trigger_Recursion.AFTER_UPDATE_ALREADY_INVOKED = true;
                runTriggerHandler = true;
            }
        }
    }

    if (runTriggerHandler == true) {
        Contact_Trigger_Handler cth = new Contact_Trigger_Handler(Trigger.operationType);
        if (cth.isValid(Trigger.new)) {
            cth.run(Trigger.old, Trigger.new, Trigger.oldMap, Trigger.newMap);
        }
    }
}
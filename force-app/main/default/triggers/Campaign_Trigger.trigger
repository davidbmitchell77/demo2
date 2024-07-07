trigger Campaign_Trigger on Campaign (before insert, before update, before delete, after insert, after update, after delete, after undelete) {

    private TriggerSetting__mdt ts = TriggerSettings.getInstance('Campaign');
    private Boolean runTriggerHandler = false;

    Campaign_Trigger_Recursion.reset(Trigger.old, Trigger.new);

    switch on Trigger.operationType {
        when BEFORE_INSERT {
            if (!Campaign_Trigger_Recursion.BEFORE_INSERT_ALREADY_INVOKED) {
                campaign_Trigger_Recursion.BEFORE_INSERT_ALREADY_INVOKED = true;
                runTriggerHandler = ts.BeforeInsert__c;
            }
        }
        when BEFORE_UPDATE {
            if (!Campaign_Trigger_Recursion.BEFORE_UPDATE_ALREADY_INVOKED) {
                Campaign_Trigger_Recursion.BEFORE_UPDATE_ALREADY_INVOKED = true;
                runTriggerHandler = ts.BeforeUpdate__c;
            }
        }
        when BEFORE_DELETE {
            if (!Campaign_Trigger_Recursion.BEFORE_DELETE_ALREADY_INVOKED) {
                Campaign_Trigger_Recursion.BEFORE_DELETE_ALREADY_INVOKED = true;
                runTriggerHandler = ts.BeforeDelete__c;
            }
        }
        when AFTER_INSERT {
            if (!Campaign_Trigger_Recursion.AFTER_INSERT_ALREADY_INVOKED) {
                Campaign_Trigger_Recursion.AFTER_INSERT_ALREADY_INVOKED = true;
                runTriggerHandler = ts.AfterInsert__c;
            }
        }
        when AFTER_UPDATE {
            if (!Campaign_Trigger_Recursion.AFTER_UPDATE_ALREADY_INVOKED) {
                Campaign_Trigger_Recursion.AFTER_UPDATE_ALREADY_INVOKED = true;
                runTriggerHandler = ts.AfterUpdate__c;
            }
        }
        when AFTER_DELETE {
            if (!Campaign_Trigger_Recursion.AFTER_DELETE_ALREADY_INVOKED) {
                Campaign_Trigger_Recursion.AFTER_DELETE_ALREADY_INVOKED = true;
                runTriggerHandler = ts.AfterDelete__c;
            }
        }
        when AFTER_UNDELETE {
            if (!Campaign_Trigger_Recursion.AFTER_UNDELETE_ALREADY_INVOKED) {
                Campaign_Trigger_Recursion.AFTER_UNDELETE_ALREADY_INVOKED = true;
                runTriggerHandler = ts.AfterUndelete__c;
            }
        }
    }

    if (runTriggerHandler == true) {
        try {
            Campaign_Trigger_Handler handler = new Campaign_Trigger_Handler(Trigger.operationType);
            if (handler.isValid(Trigger.new)) {
                handler.run(Trigger.old, Trigger.new, Trigger.oldMap, Trigger.newMap);
            }
        }
        catch(Exception e) {
            Logger.error(e.getMessage(), ((Trigger.new != null) ? Trigger.new : Trigger.old)).addTag('Campaign_Trigger_Handler');
            Logger.saveLog();
            throw new SYS_UTILS.SYS_EXCEPTION(e.getMessage());
        }
    }
}
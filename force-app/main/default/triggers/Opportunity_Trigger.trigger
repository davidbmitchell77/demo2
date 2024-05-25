trigger Opportunity_Trigger on Opportunity (before insert, before update, after insert, after update,before delete, after delete, after undelete) {

    private TriggerSetting__mdt ts = TriggerSettings.getInstance('Opportunity');
    private Boolean runTriggerHandler = false;

    switch on Trigger.operationType {
        when BEFORE_INSERT {
            if (!Opportunity_Trigger_Recursion.BEFORE_INSERT_ALREADY_INVOKED) {
                Opportunity_Trigger_Recursion.BEFORE_INSERT_ALREADY_INVOKED = true;
                runTriggerHandler = ts.BeforeInsert__c;
            }
        }
        when BEFORE_UPDATE {
            if (!Opportunity_Trigger_Recursion.BEFORE_UPDATE_ALREADY_INVOKED) {
                Opportunity_Trigger_Recursion.BEFORE_UPDATE_ALREADY_INVOKED = true;
                runTriggerHandler = ts.BeforeUpdate__c;
            }
        }
        when BEFORE_DELETE {
            if (!Opportunity_Trigger_Recursion.BEFORE_DELETE_ALREADY_INVOKED) {
                Opportunity_Trigger_Recursion.BEFORE_DELETE_ALREADY_INVOKED = true;
                runTriggerHandler = ts.BeforeDelete__c;
            }
        }
        when AFTER_INSERT {
            if (!Opportunity_Trigger_Recursion.AFTER_INSERT_ALREADY_INVOKED) {
                Opportunity_Trigger_Recursion.AFTER_INSERT_ALREADY_INVOKED = true;
                runTriggerHandler = ts.AfterInsert__c;
            }
        }
        when AFTER_UPDATE {
            if (!Opportunity_Trigger_Recursion.AFTER_UPDATE_ALREADY_INVOKED) {
                Opportunity_Trigger_Recursion.AFTER_UPDATE_ALREADY_INVOKED = true;
                runTriggerHandler = ts.AfterUpdate__c;
            }
        }
        when AFTER_DELETE {
            if (!Opportunity_Trigger_Recursion.AFTER_DELETE_ALREADY_INVOKED) {
                Opportunity_Trigger_Recursion.AFTER_DELETE_ALREADY_INVOKED = true;
                runTriggerHandler = ts.AfterDelete__c;
            }
        }
        when AFTER_UNDELETE {
            if (!Opportunity_Trigger_Recursion.AFTER_UNDELETE_ALREADY_INVOKED) {
                Opportunity_Trigger_Recursion.AFTER_UNDELETE_ALREADY_INVOKED = true;
                runTriggerHandler = ts.AfterUndelete__c;
            }
        }
    }

    if (runTriggerHandler == true) {
        Opportunity_Trigger_Handler handler = new Opportunity_Trigger_Handler(Trigger.operationType);
        if (handler.isValid(Trigger.new)) {
            handler.run(Trigger.old, Trigger.new, Trigger.oldMap, Trigger.newMap);
        }
    }
}
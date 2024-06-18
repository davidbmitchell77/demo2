trigger CustomObjectA_Trigger on CustomObjectA__c(before insert, before update, before delete, after insert, after update, after delete, after undelete) {

    TriggerSetting__mdt ts = TriggerSettings.getInstance('CustomObjectA');
    private Boolean runTriggerHandler = false;

    switch on Trigger.OperationType {
        when BEFORE_INSERT {
            if (!CustomObjectA_Trigger_Recursion.BEFORE_INSERT_ALREADY_INVOKED) {
                CustomObjectA_Trigger_Recursion.BEFORE_INSERT_ALREADY_INVOKED = true;
                runTriggerHandler = ts.BeforeInsert__c;
            }
        }
        when BEFORE_UPDATE {
            if (!CustomObjectA_Trigger_Recursion.BEFORE_UPDATE_ALREADY_INVOKED) {
                CustomObjectA_Trigger_Recursion.BEFORE_UPDATE_ALREADY_INVOKED = true;
                runTriggerHandler = ts.BeforeUpdate__c;
            }
        }
        when BEFORE_DELETE {
            if (!CustomObjectA_Trigger_Recursion.BEFORE_DELETE_ALREADY_INVOKED) {
                CustomObjectA_Trigger_Recursion.BEFORE_DELETE_ALREADY_INVOKED = true;
                runTriggerHandler = ts.BeforeDelete__c;
            }
        }
        when AFTER_INSERT {
            if (!CustomObjectA_Trigger_Recursion.AFTER_INSERT_ALREADY_INVOKED) {
                CustomObjectA_Trigger_Recursion.AFTER_INSERT_ALREADY_INVOKED = true;
                runTriggerHandler = ts.AfterInsert__c;
            }
        }
        when AFTER_UPDATE {
            if (!CustomObjectA_Trigger_Recursion.AFTER_UPDATE_ALREADY_INVOKED) {
                CustomObjectA_Trigger_Recursion.AFTER_UPDATE_ALREADY_INVOKED = true;
                runTriggerHandler = ts.AfterUpdate__c;
            }
        }
        when AFTER_DELETE {
            if (!CustomObjectA_Trigger_Recursion.AFTER_DELETE_ALREADY_INVOKED) {
                CustomObjectA_Trigger_Recursion.AFTER_DELETE_ALREADY_INVOKED = true;
                runTriggerHandler = ts.AfterDelete__c;
            }
        }
        when AFTER_UNDELETE {
            if (!CustomObjectA_Trigger_Recursion.AFTER_UNDELETE_ALREADY_INVOKED) {
                CustomObjectA_Trigger_Recursion.AFTER_UNDELETE_ALREADY_INVOKED = true;
                runTriggerHandler = ts.AfterUndelete__c;
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
trigger Account_Trigger on Account (before insert, before update, before delete, after insert, after update, after delete, after undelete) {

    private TriggerSetting__mdt ts = TriggerSettings.getInstance('Account');
    private Boolean runTriggerHandler = false;

    switch on Trigger.operationType {
        when BEFORE_INSERT {
            if (!Account_Trigger_Recursion.BEFORE_INSERT_ALREADY_INVOKED) {
                Account_Trigger_Recursion.BEFORE_INSERT_ALREADY_INVOKED = true;
                runTriggerHandler = ts.BeforeInsert__c;
            }
        }
        when BEFORE_UPDATE {
            if (!Account_Trigger_Recursion.BEFORE_UPDATE_ALREADY_INVOKED) {
                Account_Trigger_Recursion.BEFORE_UPDATE_ALREADY_INVOKED = true;
                runTriggerHandler = ts.BeforeUpdate__c;
            }
        }
        when BEFORE_DELETE {
            if (!Account_Trigger_Recursion.BEFORE_DELETE_ALREADY_INVOKED) {
                Account_Trigger_Recursion.BEFORE_DELETE_ALREADY_INVOKED = true;
                runTriggerHandler = ts.BeforeDelete__c;
            }
        }
        when AFTER_INSERT {
            if (!Account_Trigger_Recursion.AFTER_INSERT_ALREADY_INVOKED) {
                Account_Trigger_Recursion.AFTER_INSERT_ALREADY_INVOKED = true;
                runTriggerHandler = ts.AfterInsert__c;
            }
        }
        when AFTER_UPDATE {
            if (!Account_Trigger_Recursion.AFTER_UPDATE_ALREADY_INVOKED) {
                Account_Trigger_Recursion.AFTER_UPDATE_ALREADY_INVOKED = !Test.isRunningTest();
                runTriggerHandler = ts.AfterUpdate__c;
            }
        }
        when AFTER_DELETE {
            if (!Account_Trigger_Recursion.AFTER_DELETE_ALREADY_INVOKED) {
                Account_Trigger_Recursion.AFTER_DELETE_ALREADY_INVOKED = true;
                runTriggerHandler = ts.AfterDelete__c;
            }
        }
        when AFTER_UNDELETE {
            if (!Account_Trigger_Recursion.AFTER_UNDELETE_ALREADY_INVOKED) {
                Account_Trigger_Recursion.AFTER_UNDELETE_ALREADY_INVOKED = true;
                runTriggerHandler = ts.AfterUndelete__c;
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
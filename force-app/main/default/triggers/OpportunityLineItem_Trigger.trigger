trigger OpportunityLineItem_Trigger on OpportunityLineItem (before insert, before update, before delete, after insert, after update, after delete) {

    TriggerSetting__mdt ts = TriggerSettings.getInstance('OpportunityLineItem');
    private Boolean runTriggerHandler = false;

    OpportunityLineItem_Trigger_Recursion.reset(Trigger.old, Trigger.new);

    switch on Trigger.operationType {
        when BEFORE_INSERT {
            if (!OpportunityLineItem_Trigger_Recursion.BEFORE_INSERT_ALREADY_INVOKED) {
                OpportunityLineItem_Trigger_Recursion.BEFORE_INSERT_ALREADY_INVOKED = true;
                runTriggerHandler = ts.BeforeInsert__c;
            }
        }
        when BEFORE_UPDATE {
            if (!OpportunityLineItem_Trigger_Recursion.BEFORE_UPDATE_ALREADY_INVOKED) {
                OpportunityLineItem_Trigger_Recursion.BEFORE_UPDATE_ALREADY_INVOKED = true;
                runTriggerHandler = ts.BeforeUpdate__c;
            }
        }
        when BEFORE_DELETE {
            if (!OpportunityLineItem_Trigger_Recursion.BEFORE_DELETE_ALREADY_INVOKED) {
                OpportunityLineItem_Trigger_Recursion.BEFORE_DELETE_ALREADY_INVOKED = true;
                runTriggerHandler = ts.BeforeDelete__c;
            }
        }
        when AFTER_INSERT {
            if (!OpportunityLineItem_Trigger_Recursion.AFTER_INSERT_ALREADY_INVOKED) {
                OpportunityLineItem_Trigger_Recursion.AFTER_INSERT_ALREADY_INVOKED = true;
                runTriggerHandler = ts.AfterInsert__c;
            }
        }
        when AFTER_UPDATE {
            if (!OpportunityLineItem_Trigger_Recursion.AFTER_UPDATE_ALREADY_INVOKED) {
                OpportunityLineItem_Trigger_Recursion.AFTER_UPDATE_ALREADY_INVOKED = true;
                runTriggerHandler = ts.AfterUpdate__c;
            }
        }
        when AFTER_DELETE {
            if (!OpportunityLineItem_Trigger_Recursion.AFTER_DELETE_ALREADY_INVOKED) {
                OpportunityLineItem_Trigger_Recursion.AFTER_DELETE_ALREADY_INVOKED = true;
                runTriggerHandler = ts.AfterDelete__c;
            }
        }
    }

    if (runTriggerHandler == true) {
        try {
            OpportunityLineItem_Trigger_Handler handler = new OpportunityLineItem_Trigger_Handler(Trigger.operationType);
            if (handler.isValid(Trigger.new)) {
                handler.run(Trigger.old, Trigger.new, Trigger.oldMap, Trigger.newMap);
            }
        }
        catch(Exception e) {
            Logger.error(e.getMessage()).addTag('OpportunityLineItem_Trigger');
            Logger.saveLog();
            throw new SYS_UTILS.OPPORTUNITY_LINE_ITEM_TRIGGER_EXCEPTION(e.getMessage());
        }
    }
}
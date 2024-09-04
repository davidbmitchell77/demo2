trigger QuoteLineItem_Trigger on QuoteLineItem (before insert, before update, before delete, after insert, after update, after delete, after undelete) {

    TriggerSetting__mdt ts = TriggerSettings.getInstance('QuoteLineItem');
    private Boolean runTriggerHandler = false;

    QuoteLineItem_Trigger_Recursion.reset(Trigger.old, Trigger.new);

    switch on Trigger.operationType {
        when BEFORE_INSERT {
            if (!QuoteLineItem_Trigger_Recursion.BEFORE_INSERT_ALREADY_INVOKED) {
                QuoteLineItem_Trigger_Recursion.BEFORE_INSERT_ALREADY_INVOKED = true;
                runTriggerHandler = ts.BeforeInsert__c;
            }
        }
        when BEFORE_UPDATE {
            if (!QuoteLineItem_Trigger_Recursion.BEFORE_UPDATE_ALREADY_INVOKED) {
                QuoteLineItem_Trigger_Recursion.BEFORE_UPDATE_ALREADY_INVOKED = true;
                runTriggerHandler = ts.BeforeUpdate__c;
            }
        }
        when BEFORE_DELETE {
            if (!QuoteLineItem_Trigger_Recursion.BEFORE_DELETE_ALREADY_INVOKED) {
                QuoteLineItem_Trigger_Recursion.BEFORE_DELETE_ALREADY_INVOKED = true;
                runTriggerHandler = ts.BeforeDelete__c;
            }
        }
        when AFTER_INSERT {
            if (!QuoteLineItem_Trigger_Recursion.AFTER_INSERT_ALREADY_INVOKED) {
                QuoteLineItem_Trigger_Recursion.AFTER_INSERT_ALREADY_INVOKED = true;
                runTriggerHandler = ts.AfterInsert__c;
            }
        }
        when AFTER_UPDATE {
            if (!QuoteLineItem_Trigger_Recursion.AFTER_UPDATE_ALREADY_INVOKED) {
                QuoteLineItem_Trigger_Recursion.AFTER_UPDATE_ALREADY_INVOKED = true;
                runTriggerHandler = ts.AfterUpdate__c;
            }
        }
        when AFTER_DELETE {
            if (!QuoteLineItem_Trigger_Recursion.AFTER_DELETE_ALREADY_INVOKED) {
                QuoteLineItem_Trigger_Recursion.AFTER_DELETE_ALREADY_INVOKED = true;
                runTriggerHandler = ts.AfterDelete__c;
            }
        }
        when AFTER_UNDELETE {
            if (!QuoteLineItem_Trigger_Recursion.AFTER_UNDELETE_ALREADY_INVOKED) {
                QuoteLineItem_Trigger_Recursion.AFTER_UNDELETE_ALREADY_INVOKED = true;
                runTriggerHandler = ts.AfterUndelete__c;
            }
        }
    }

    if (runTriggerHandler == true) {
        try {
            QuoteLineItem_Trigger_Handler handler = new QuoteLineItem_Trigger_Handler(Trigger.operationType);
            if (handler.isValid(Trigger.new)) {
                handler.run(Trigger.old, Trigger.new, Trigger.oldMap, Trigger.newMap);
            }
        }
        catch(Exception e) {
            Logger.error(e.getMessage()).addTag('QuoteLineItem_Trigger');
            Logger.saveLog();
            throw new SYS_UTILS.QUOTE_LINE_ITEM_TRIGGER_EXCEPTION(e.getMessage());
        }
    }
}
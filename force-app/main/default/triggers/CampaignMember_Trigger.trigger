trigger CampaignMember_Trigger on CampaignMember (before insert, before update, before delete, after insert, after update, after delete) {

    private TriggerSetting__mdt ts = TriggerSettings.getInstance('CampaignMember');
    private Boolean runTriggerHandler = false;

    CampaignMember_Trigger_Recursion.reset(Trigger.old, Trigger.new);

    switch on Trigger.operationType {
        when BEFORE_INSERT {
            if (!CampaignMember_Trigger_Recursion.BEFORE_INSERT_ALREADY_INVOKED) {
                CampaignMember_Trigger_Recursion.BEFORE_INSERT_ALREADY_INVOKED = true;
                runTriggerHandler = ts.BeforeInsert__c;
            }
        }
        when BEFORE_UPDATE {
            if (!CampaignMember_Trigger_Recursion.BEFORE_UPDATE_ALREADY_INVOKED) {
                CampaignMember_Trigger_Recursion.BEFORE_UPDATE_ALREADY_INVOKED = true;
                runTriggerHandler = ts.BeforeUpdate__c;
            }
        }
        when BEFORE_DELETE {
            if (!CampaignMember_Trigger_Recursion.BEFORE_DELETE_ALREADY_INVOKED) {
                CampaignMember_Trigger_Recursion.BEFORE_DELETE_ALREADY_INVOKED = true;
                runTriggerHandler = ts.BeforeDelete__c;
            }
        }
        when AFTER_INSERT {
            if (!CampaignMember_Trigger_Recursion.AFTER_INSERT_ALREADY_INVOKED) {
                CampaignMember_Trigger_Recursion.AFTER_INSERT_ALREADY_INVOKED = true;
                runTriggerHandler = ts.AfterInsert__c;
            }
        }
        when AFTER_UPDATE {
            if (!CampaignMember_Trigger_Recursion.AFTER_UPDATE_ALREADY_INVOKED) {
                CampaignMember_Trigger_Recursion.AFTER_UPDATE_ALREADY_INVOKED = true;
                runTriggerHandler = ts.AfterUpdate__c;
            }
        }
        when AFTER_DELETE {
            if (!CampaignMember_Trigger_Recursion.AFTER_DELETE_ALREADY_INVOKED) {
                CampaignMember_Trigger_Recursion.AFTER_DELETE_ALREADY_INVOKED = true;
                runTriggerHandler = ts.AfterDelete__c;
            }
        }
    }

    if (runTriggerHandler == true) {
        try {
            CampaignMember_Trigger_Handler handler = new CampaignMember_Trigger_Handler(Trigger.operationType);
            if (handler.isValid(Trigger.new)) {
                handler.run(Trigger.old, Trigger.new, Trigger.oldMap, Trigger.newMap);
            }
        }
        catch(Exception e) {
            Logger.error(JSON.serialize(e), ((Trigger.new != null) ? Trigger.new : Trigger.old));
            Logger.saveLog();
            throw new SYS_UTILS.SYS_EXCEPTION(e);
        }
    }
}
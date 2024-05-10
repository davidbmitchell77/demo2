public with sharing class CustomObjectA_Trigger_Handler {

    private TriggerOperation operationType;

    public CustomObjectA_Trigger_Handler(TriggerOperation operationType) {
        this.operationType = operationType;
    }

    public Boolean isValid(List<CustomObjectA__c> cobjaRecs) {
        Boolean result = true;
        for (CustomObjectA__c cobja : cobjaRecs) {
        }
        return result;
    }

    public void run(List<CustomObjectA__c> oldRecords, List<CustomObjectA__c> newRecords, Map<Id,CustomObjectA__c> oldMap, Map<Id,CustomObjectA__c> newMap) {
        switch on operationType {
            when AFTER_INSERT, AFTER_UPDATE {
                synchronizeFieldsWithCustomObjectB(oldRecords, newRecords, oldMap, newMap);
            }
        }
    }

    public void synchronizeFieldsWithCustomObjectB(List<CustomObjectA__c> oldRecords, List<CustomObjectA__c> newRecords, Map<Id,CustomObjectA__c> oldMap, Map<Id,CustomObjectA__c> newMap)
    {
        List<CustomObjectB__c> cobjbList = new List<CustomObjectB__c>();

        for (CustomObjectA__c cobja : newRecords)
        {
            Boolean fieldAHasChanged = false;
            Boolean fieldBHasChanged = false;

            if (operationType == TriggerOperation.AFTER_INSERT) {
                fieldAHasChanged = true;
                fieldBHasChanged = true;
            }
            else if (cobja.FieldA__c != oldMap.get(cobja.Id).FieldA__c) {
                fieldAHasChanged = true;
            }
            else if (cobja.FieldB__c != oldMap.get(cobja.Id).FieldB__c) {
                fieldBHasChanged = true;
            }

            if (fieldAHasChanged || fieldBHasChanged) {
                CustomObjectB__c cobjb = new CustomObjectB__c();
                cobjb.ExternalId__c = cobja.Id;
                cobjb.FieldA__c = cobja.FieldA__c;
                cobjb.FieldB__c = cobja.FieldB__c;
                cobjbList.add(cobjb);
            }
        }

        if (!cobjbList.isEmpty()) {
            upsert cobjbList ExternalId__c;
        }
    }
}
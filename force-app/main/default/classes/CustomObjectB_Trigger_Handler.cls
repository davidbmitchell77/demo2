public with sharing class CustomObjectB_Trigger_Handler {

    private TriggerOperation operationType;

    public CustomObjectB_Trigger_Handler(TriggerOperation operationType) {
        this.operationType = operationType;
    }

    public Boolean isValid(List<CustomObjectB__c> cobjbRecs) {
        Boolean result = true;
        for (CustomObjectB__c cobjb : cobjbRecs) {
        }
        return result;
    }

    public void run(List<CustomObjectB__c> oldRecords, List<CustomObjectB__c> newRecords, Map<Id,CustomObjectB__c> oldMap, Map<Id,CustomObjectB__c> newMap) {
        switch on operationType {
            when AFTER_INSERT, AFTER_UPDATE {
                synchronizeFieldsWithCustomObjectA(oldRecords, newRecords, oldMap, newMap);
            }
        }
    }

    public void synchronizeFieldsWithCustomObjectA(List<CustomObjectB__c> oldRecords, List<CustomObjectB__c> newRecords, Map<Id,CustomObjectB__c> oldMap, Map<Id,CustomObjectB__c> newMap)
    {
        List<CustomObjectA__c> cobjaList = new List<CustomObjectA__c>();

        for (CustomObjectB__c cobjb : newRecords)
        {
            Boolean fieldAHasChanged = false;
            Boolean fieldBHasChanged = false;

            if (operationType == TriggerOperation.AFTER_INSERT) {
                fieldAHasChanged = true;
                fieldBHasChanged = true;
            }
            else if (cobjb.FieldA__c != oldMap.get(cobjb.Id).FieldA__c) {
                fieldAHasChanged = true;
            }
            else if (cobjb.FieldB__c != oldMap.get(cobjb.Id).FieldB__c) {
                fieldBHasChanged = true;
            }

            if (fieldAHasChanged || fieldBHasChanged) {
                CustomObjectA__c cobja = new CustomObjectA__c();
                cobja.ExternalId__c = cobjb.Id;
                cobja.FieldA__c = cobjb.FieldA__c;
                cobja.FieldB__c = cobjb.FieldB__c;
                cobjaList.add(cobja);
            }
        }

        if (!cobjaList.isEmpty()) {
            upsert cobjaList ExternalId__c;
        }
    }
}
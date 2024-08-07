public with sharing class CustomObjectA_Trigger_Handler {

    private TriggerOperation operationType;

    public CustomObjectA_Trigger_Handler(TriggerOperation to) {
        this.operationType = to;
    }

    public Boolean isValid(List<CustomObjectA__c> aObjects) {
        Boolean result = true;
        if (aObjects != null) {
            for (CustomObjectA__c aObj : aObjects) {
                if (String.isBlank(aObj.Name)) {
                    aObj.Name.addError(System.Label.CUSTOM_OBJECT_A_NAME_IS_REQUIRED);
                    result = false;
                }
            }
        }
        if (result == false) {
            if (SYS_UTILS.isBatch() || SYS_UTILS.isTest()) {
                throw new SYS_UTILS.SYS_EXCEPTION(System.Label.CUSTOM_OBJECT_A_RECORD_DATA_IS_NOT_VAILD);
            }
        }
        return result;
    }

    public void run(List<CustomObjectA__c> oldRecords, List<CustomObjectA__c> newRecords, Map<Id,CustomObjectA__c> oldMap, Map<Id,CustomObjectA__c> newMap) {
        switch on this.operationType {
            when BEFORE_INSERT {

            }
            when BEFORE_UPDATE {

            }
            when BEFORE_DELETE {

            }
            when AFTER_INSERT {
                synchronizeFieldsWithCustomObjectB(oldRecords, newRecords, oldMap, newMap);
            }
            when AFTER_UPDATE {
                synchronizeFieldsWithCustomObjectB(oldRecords, newRecords, oldMap, newMap);
            }
            when AFTER_DELETE {

            }
            when AFTER_UNDELETE {

            }
        }
        updateProcessedRecordIds(this.operationType, oldRecords, newRecords);
    }

    private void synchronizeFieldsWithCustomObjectB(List<CustomObjectA__c> oldRecords, List<CustomObjectA__c> newRecords, Map<Id,CustomObjectA__c> oldMap, Map<Id,CustomObjectA__c> newMap)
    {
        Map<String,CustomObjectB__c> bObjects = new Map<String,CustomObjectB__c>();

        for (CustomObjectB__c bObj : [SELECT Id,
                                             Name,
                                             FieldA__c,
                                             FieldB__c,
                                             ExternalId__c
                                        FROM CustomObjectB__c
                                       WHERE ExternalId__c IN :externalIds(newRecords)
        ]) {
            if (!bObjects.containsKey(bObj.ExternalId__c)) {
                bObjects.put(bObj.ExternalId__c, bObj);
            }
        }

        Set<Id> updatedRecordIds = new Set<Id>();

        if (newRecords != null) {
            for (CustomObjectA__c aObj : newRecords) {
                if (!alreadyInvoked(this.operationType, aObj.Id)) {
                    CustomObjectA__c oldRecord = (oldMap != null ? oldMap.get(aObj.Id) : new CustomObjectA__c());
                    CustomObjectA__c newRecord = (newMap != null ? newMap.get(aObj.Id) : new CustomObjectA__c());
                    if ((oldRecord.FieldA__c != newRecord.FieldA__c) || (oldRecord.FieldB__c != newRecord.FieldB__c)) {
                        if (bObjects.containsKey(aObj.ExternalId__c)) {
                            CustomObjectB__c bObj = bObjects.get(aObj.ExternalId__c);
                            if (aObj.FieldA__c != bObj.FieldA__c || aObj.FieldB__c != bObj.FieldB__c) {
                                bObj.FieldA__c = aObj.FieldA__c;
                                bObj.FieldB__c = aObj.FieldB__c;
                                bObjects.put(bObj.Id, bObj);
                                updatedRecordIds.add(bObj.Id);
                            }
                        }
                    }
                }
            }
        }

        bObjects = filter(bObjects, updatedRecordIds);

        if (!bObjects.isEmpty()) {
            DB_UTILS.upd(bObjects.values());
        }
    }

    private Boolean alreadyInvoked(TriggerOperation to, Id recordId) {
        return CustomObjectA_Trigger_Recursion.alreadyInvoked(to, recordId);
    }

    private Set<String> externalIds(List<CustomObjectA__c> aObjects) {
        Set<String> results = new Set<String>();
        if (aObjects != null) {
            for (CustomObjectA__c aObj : aObjects) {
                if (aObj.ExternalId__c != null) {
                    if (!results.contains(aObj.ExternalId__c )) {
                        results.add(aObj.ExternalId__c );
                    }
                }
            }
        }
        return results;
    }

    private Map<String,CustomObjectB__c> filter(Map<String,CustomObjectB__c> bObjects, Set<Id> recordIds) {
        Map<String,CustomObjectB__c> results = new Map<String,CustomObjectB__c>();
        if (bObjects != null) {
            for (CustomObjectB__c bObj : bObjects.values()) {
                if (recordIds.contains(bObj.Id)) {
                    results.put(bObj.Id, bObj);
                }
            }
        }
        return results;
    }

    private void updateProcessedRecordIds(TriggerOperation to, List<CustomObjectA__c> oldRecords, List<CustomObjectA__c> newRecords) {
        CustomObjectA_Trigger_Recursion.updateProcessedRecordIds(to, oldRecords, newRecords);
    }
}
public with sharing class CustomObjectB_Trigger_Handler {

    private TriggerOperation operationType;

    public CustomObjectB_Trigger_Handler(TriggerOperation to) {
        this.operationType = to;
    }

    public Boolean isValid(List<CustomObjectB__c> bObjects) {
        Boolean result = true;
        if (bObjects != null) {
            for (CustomObjectB__c bObj : bObjects) {
                if (String.isBlank(bObj.Name)) {
                    bObj.Name.addError(System.Label.CUSTOM_OBJECT_B_NAME_IS_REQUIRED);
                    result = false;
                }
            }
            if (result == false) {
                if (SYS_UTILS.isBatch() || SYS_UTILS.isTest()) {
                    throw new SYS_UTILS.SYS_EXCEPTION(System.Label.CUSTOM_OBJECT_B_RECORD_DATA_IS_NOT_VALID);
                }
            }
        }
        return result;
    }

    public void run(List<CustomObjectB__c> oldRecords, List<CustomObjectB__c> newRecords, Map<Id,CustomObjectB__c> oldMap, Map<Id,CustomObjectB__c> newMap) {
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

    private void synchronizeFieldsWithCustomObjectB(List<CustomObjectB__c> oldRecords, List<CustomObjectB__c> newRecords, Map<Id,CustomObjectB__c> oldMap, Map<Id,CustomObjectB__c> newMap)
    {
        Map<String,CustomObjectA__c> aObjects = new Map<String,CustomObjectA__c>();

        for (CustomObjectA__c aObj : [SELECT Id,
                                             Name,
                                             FieldA__c,
                                             FieldB__c,
                                             ExternalId__c
                                        FROM CustomObjectA__c
                                       WHERE ExternalId__c IN :externalIds(newRecords)
        ]) {
            if (!aObjects.containsKey(aObj.ExternalId__c)) {
                aObjects.put(aObj.ExternalId__c, aObj);
            }
        }

        Set<Id> updatedRecordIds = new Set<Id>();

        if (newRecords != null) {
            for (CustomObjectB__c bObj : newRecords) {
                if (!alreadyInvoked(this.operationType, bObj.Id)) {
                    CustomObjectB__c oldRecord = (oldMap != null ? oldMap.get(bObj.Id) : new CustomObjectB__c());
                    CustomObjectB__c newRecord = (newMap != null ? newMap.get(bObj.Id) : new CustomObjectB__c());
                    if (oldRecord.FieldA__c != newRecord.FieldA__c || oldRecord.FieldB__c != newRecord.FieldB__c) {
                        if (aObjects.containsKey(bObj.ExternalId__c)) {
                            CustomObjectA__c aObj = aObjects.get(bObj.ExternalId__c);
                            if (bObj.FieldA__c != aObj.FieldA__c || bObj.FieldB__c != aObj.FieldB__c) {
                                aObj.FieldA__c = bObj.FieldA__c;
                                aObj.FieldB__c = bObj.FieldB__c;
                                aObjects.put(aObj.Id, aObj);
                                updatedRecordIds.add(aObj.Id);
                            }
                        }
                    }
                }
            }
        }

        aObjects = filter(aObjects, updatedRecordIds);

        if (!aObjects.isEmpty()) {
            DB_UTILS.upd(aObjects.values());
        }
    }

    private Boolean alreadyInvoked(TriggerOperation to, Id recordId) {
        return CustomObjectB_Trigger_Recursion.alreadyInvoked(to, recordId);
    }

    private Set<String> externalIds(List<CustomObjectB__c> bObjects) {
        Set<String> results = new Set<String>();
        if (bObjects != null) {
            for (CustomObjectB__c bObj : bObjects) {
                if (bObj.ExternalId__c != null) {
                    if (!results.contains(bObj.ExternalId__c )) {
                        results.add(bObj.ExternalId__c );
                    }
                }
            }
        }
        return results;
    }

    private Map<String,CustomObjectA__c> filter(Map<String,CustomObjectA__c> aObjects, Set<Id> recordIds) {
        Map<String,CustomObjectA__c> results = new Map<String,CustomObjectA__c>();
        if (aObjects != null) {
            for (CustomObjectA__c aObj : aObjects.values()) {
                if (recordIds.contains(aObj.Id)) {
                    results.put(aObj.Id, aObj);
                }
            }
        }
        return results;
    }

    private void updateProcessedRecordIds(TriggerOperation to, List<CustomObjectB__c> oldRecords, List<CustomObjectB__c> newRecords) {
        CustomObjectB_Trigger_Recursion.updateProcessedRecordIds(to, oldRecords, newRecords);
    }
}
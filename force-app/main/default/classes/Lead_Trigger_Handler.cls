public with sharing class Lead_Trigger_Handler {

    private TriggerOperation operationType;

    public Lead_Trigger_Handler(TriggerOperation to) {
        this.operationType = to;
    }

    public Boolean isValid(List<Lead> leads) {
        Boolean result = true;
        if (leads != null) {
            for (Lead l : leads) {
                if (String.isBlank(l.LastName)) {
                    l.LastName.addError(System.Label.LEAD_LAST_NAME_IS_REQUIRED);
                    result = false;
                }
            }
        }
        if (result == false) {
            if (SYS_UTILS.isBatch() || SYS_UTILS.isTest()) {
                throw new SYS_UTILS.SYS_EXCEPTION(System.Label.LEAD_RECORD_DATA_IS_NOT_VALID);
            }
        }
        return result;
    }

    public void run(List<Lead> oldLeads, List<Lead> newLeads, Map<Id,Lead> oldMap, Map<Id,Lead> newMap) {
        switch on this.operationType {
            when BEFORE_INSERT {

            }
            when BEFORE_UPDATE {

            }
            when BEFORE_DELETE {

            }
            when AFTER_INSERT {

            }
            when AFTER_UPDATE {

            }
            when AFTER_DELETE {

            }
            when AFTER_UNDELETE {

            }
        }
        updateProcessedRecordIds((newLeads!= null ? newLeads : (oldLeads != null ? oldLeads : null)));
    }

    private void updateProcessedRecordIds(List<Lead> leads) {
        if (leads != null) {
            List<Id> leadIds = nvl(Lead_Trigger_Recursion.PROCESSED_RECORD_IDS.get(this.operationType));
            for (Lead l : leads) {
                if (l.Id != null) {
                    if (!leadIds.contains(l.Id)) {
                        leadIds.add(l.Id);
                        Lead_Trigger_Recursion.PROCESSED_RECORD_IDS.put(this.operationType, leadIds);
                    }
                }
            }
        }
    }

    private List<Id> nvl(List<Id> recordIds) {
        return ((recordIds != null) ? recordIds : new List<Id>());
    }
}
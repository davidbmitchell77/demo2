public with sharing class OpportunityLineItem_Trigger_Handler {

    private TriggerOperation operationType;

    public OpportunityLineItem_Trigger_Handler(TriggerOperation to) {
        this.operationType = to;
    }

    public Boolean isValid(List<OpportunityLineItem> lineItems) {
        Boolean result = true;
        if (lineItems != null) {
            for (OpportunityLineItem li : lineItems) {
                if (String.isBlank(li.Name)) {
                    li.Name.addError(System.Label.OPPORTUNITY_LINE_ITEM_NAME_IS_REQUIRED);
                    result = false;
                }
            }
        }
        if (result == false) {
            if (SYS_UTILS.isBatch() || SYS_UTILS.isTest()) {
                throw new SYS_UTILS.OPPORTUNITY_LINE_ITEM_TRIGGER_EXCEPTION(System.Label.OPPORTUNITY_LINE_ITEM_RECORD_DATA_IS_NOT_VALID);
            }
        }
        return result;
    }

    public void run(List<OpportunityLineItem> oldLineItems, List<OpportunityLineItem> newLineItems, Map<Id,OpportunityLineItem> oldMap, Map<Id,OpportunityLineItem> newMap) {
        switch on this.operationType {
            when BEFORE_INSERT {

            }
            when BEFORE_UPDATE {

            }
            when BEFORE_DELETE {

            }
            when AFTER_INSERT {
                updateParentAccounts(oldLineItems, newLineItems, oldMap, newMap);
            }
            when AFTER_UPDATE {
                updateParentAccounts(oldLineItems, newLineItems, oldMap, newMap);
            }
            when AFTER_DELETE {

            }
            when AFTER_UNDELETE {

            }
        }
    }

    private void updateParentAccounts(List<OpportunityLineItem> oldLineItems, List<OpportunityLineItem> newLineItems, Map<Id,OpportunityLineItem> oldMap, Map<Id,OpportunityLineItem> newMap) {
        Map<Id,Account> accountsMap = new Map<Id,Account>();

        for (AggregateResult agr : [SELECT Opportunity.AccountId, COUNT(Id) TotalLineItems
                                      FROM OpportunityLineItem
                                     WHERE OpportunityId IN :opportunityIds(newLineItems)
                                  GROUP BY Opportunity.AccountId
        ]) {
            Id accountId = (Id)(agr.get('Opportunity.AccountId'));
            Integer totalLineItems = (Integer)(agr.get('TotalLineItems'));
            accountsMap.put(accountId, new Account(Id=accountId, TotalLineItems__c=totalLineItems));
        }

        if (!accountsMap.isEmpty()) {
            DB_UTILS.upd(accountsMap.values());
        }
    }

    private Set<Id> opportunityIds(List<OpportunityLineItem> lineItems) {
        Set<Id> results = new Set<Id>();
        if (lineItems != null) {
            for (OpportunityLineItem li : lineItems) {
                if (li.OpportunityId != null) {
                    if (!results.contains(li.OpportunityId)) {
                        results.add(li.OpportunityId);
                    }
                }
            }
        }
        return results;
    }
}
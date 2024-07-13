public with sharing class Opportunity_Trigger_Handler2 {

    private TriggerOperation operationType;

    public Opportunity_Trigger_Handler2(TriggerOperation to) {
        this.operationType = to;
    }

    public Boolean isValid(List<Opportunity> opportunities) {
        Boolean result = true;
        if (opportunities != null) {
            for (Opportunity o : opportunities) {
                if (String.isBlank(o.Name)) {
                    o.Name.addError(System.Label.OPPORTUNITY_NAME_IS_REQUIRED);
                    result = false;
                }
            }
        }
        if (result == false) {
            if (SYS_UTILS.isBatch() || SYS_UTILS.isTest()) {
                throw new SYS_UTILS.OPPORTUNITY_TRIGGER_EXCEPTION(System.Label.OPPORTUNITY_RECORD_DATA_IS_NOT_VALID);
            }
        }
        return result;
    }

    public void run(List<Opportunity> oldOpportunities, List<Opportunity> newOpportunities, Map<Id,Opportunity> oldMap, Map<Id,Opportunity> newMap) {
        switch on this.operationType {
            when BEFORE_INSERT {

            }
            when BEFORE_UPDATE {

            }
            when BEFORE_DELETE {

            }
            when AFTER_INSERT {
                updateParentAccounts(oldOpportunities, newOpportunities, oldMap, newMap);
            }
            when AFTER_UPDATE {
                updateParentAccounts(oldOpportunities, newOpportunities, oldMap, newMap);
            }
            when AFTER_DELETE {

            }
            when AFTER_UNDELETE {

            }
        }
        updateProcessedRecordIds(this.operationType, oldOpportunities, newOpportunities);
    }

    private void updateParentAccounts(List<Opportunity> oldOpportunities, List<Opportunity> newOpportunities, Map<Id,Opportunity> oldMap, Map<Id,Opportunity> newMap) {
        Map<Id,Account> accountsMap = new Map<Id,Account>();

        for (AggregateResult agr : [SELECT AccountId, MAX(ExpectedRevenue) maxExpectedRevenue
                                      FROM Opportunity
                                     WHERE AccountId IN :accountIds(newOpportunities)
                                  GROUP BY AccountId
        ]) {
            Id accountId = (Id)agr.get('AccountId');
            Decimal maxExpectedRevenue = (Decimal)agr.get('maxExpectedRevenue');
            accountsMap.put(accountId, new Account(Id=accountId, MaximumExpectedOpportunityRevenue__c=maxExpectedRevenue));
        }

        if (!accountsMap.isEmpty()) {
            DB_UTILS.ins(accountsMap.values());
        }
    }

    private Set<Id> accountIds(List<Opportunity> opportunities) {
        Set<Id> results = new Set<Id>();
        if (opportunities != null) {
            for (Opportunity o : opportunities) {
                if (o.AccountId != null) {
                    if (!results.contains(o.AccountId)) {
                        results.add(o.AccountId);
                    }
                }
            }
        }
        return results;
    }

    private void updateProcessedRecordIds(TriggerOperation to, List<Opportunity> oldOpportunities, List<Opportunity> newOpportunities) {
        Opportunity_Trigger_Recursion.updateProcessedRecordIds(to, oldOpportunities, newOpportunities);
    }
}
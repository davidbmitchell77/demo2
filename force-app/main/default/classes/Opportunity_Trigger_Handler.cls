public with sharing class Opportunity_Trigger_Handler {

    private TriggerOperation operationType;

    public Opportunity_Trigger_Handler(TriggerOperation to) {
        this.operationType = to;
    }

    public Boolean isValid(List<Opportunity> opportunities) {

        Boolean result = true;

        if (opportunities != null) {
            for (Opportunity o : opportunities)  {
                if (o.Name == null) {
                    o.Name.addError(System.Label.OPPORTUNITY_NAME_IS_REQUIRED);
                    result = false;
                }
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
                updateParentAccountBiggestOpty(oldOpportunities, newOpportunities, oldMap, newMap);
            }
            when AFTER_UPDATE {
                updateParentAccountBiggestOpty(oldOpportunities, newOpportunities, oldMap, newMap);
            }
            when AFTER_DELETE {

            }
            when AFTER_UNDELETE {

            }
        }
    }

    private void updateParentAccountBiggestOpty(List<Opportunity> oldOpportunities, List<Opportunity> newOpportunities, Map<Id,Opportunity> oldMap, Map<Id,Opportunity> newMap) {

        Map<Id,Account> accountsMap1 = new Map<Id,Account>([SELECT Id, MaximumExpectedOpportunityRevenue__c
                                                              FROM Account
                                                             WHERE Id IN :accountIds(newOpportunities)
        ]);

        Map<Id,Account> accountsMap2 = new Map<Id,Account>();

        if (newOpportunities != null) {
            for (Opportunity o : newOpportunities) {
                if (newMap.get(o.Id).ExpectedRevenue != ((oldMap != null) ? oldMap.get(o.Id).ExpectedRevenue : null)) {
                    if (o.AccountId != null) {
                        if (accountsMap1.containsKey(o.AccountId)) {
                            if (o.ExpectedRevenue > accountsMap1.get(o.AccountId).MaximumExpectedOpportunityRevenue__c) {
                                accountsMap2.put(o.AccountId, new Account(Id=o.AccountId, MaximumExpectedOpportunityRevenue__c=o.ExpectedRevenue));
                            }
                        }
                    }
                }
            }
        }

        if (!accountsMap2.isEmpty()) {
            update accountsMap2.values();
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
}
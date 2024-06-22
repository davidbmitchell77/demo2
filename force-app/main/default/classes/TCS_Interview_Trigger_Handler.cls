public with sharing class TCS_Interview_Trigger_Handler {

    private TriggerOperation operationType;

    public TCS_Interview_Trigger_Handler(TriggerOperation operationType) {
        this.operationType = operationType;
    }

    public void run(List<Opportunity> oldOpps, List<Opportunity>newOpps,  Map<Id,Opportunity> oldMap, Map<Id,Opportunity> newMap) {
        switch on operationType {
            when AFTER_INSERT {
                if (!isBatchJob() && !isTest()) {
                    updateAccountBiggestOpportunityName(oldOpps, newOpps, oldMap, newMap);
                }
            }
            when AFTER_UPDATE {
                if (!isBatchJob() && !isTest()) {
                    updateAccountBiggestOpportunityName(oldOpps, newOpps, oldMap, newMap);
                }
            }
        }
    }

    private void updateAccountBiggestOpportunityName(List<Opportunity> oldOpps, List<Opportunity>newOpps,  Map<Id,Opportunity> oldMap, Map<Id,Opportunity> newMap) {

        Set<Id> accountIds = new Set<Id>();
        for (Opportunity newOpp : newOpps) {
            if (newOpp.AccountId != null) {
                if (!accountIds.contains(newOpp.AccountId)) {
                    accountIds.add(newOpp.AccountId);
                }
            }
        }

        List<Account> accounts = new List<Account>();
        Map<Id,Account> accountsMap = new Map<Id,Account>([SELECT Id, AnnualRevenue FROM Account WHERE Id IN :accountIds LIMIT 200]);
        for (Opportunity newOpp : newOpps) {
            if (accountsMap.containsKey(newOpp.accountId)) {
                if (newOpp.Amount > accountsMap.get(newOpp.AccountId).AnnualRevenue) {
                    Account a = new Account(Id = newOpp.AccountId, AnnualRevenue = newOpp.Amount, Description = newOpp.Name);
                    accounts.add(a);
                }
            }
        }

        if (!accounts.isEmpty()) {
            update accounts;
        }
    }

    private static Boolean isBatchJob() {
        Boolean result = false;
        switch on Request.getCurrent().getQuiddity() {
            when BATCH_ACS            { result = true; }
            when BATCH_APEX           { result = true; }
            when BATCH_CHUNK_PARALLEL { result = true; }
            when BATCH_CHUNK_SERIAL   { result = true; }
            when BULK_API             { result = true; }
            when QUEUEABLE            { result = true; }
        }
        return result;
    }

    private static Boolean isTest() {
        Boolean result = false;
        switch on Request.getCurrent().getQuiddity() {
            when RUNTEST_DEPLOY               { result = true; }
            when RUNTEST_SYNC, RUNTEST_ASYNC  { result = true; }
        }
        return result;
    }

    public Boolean isValid(List<Opportunity> opportunities) {
        Boolean result = true;
        for (Opportunity o : opportunities) {
          //if () {
              //result = false;
          //}
        }
        return result;
    }
}
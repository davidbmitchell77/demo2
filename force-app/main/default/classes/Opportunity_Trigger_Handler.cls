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
    }

    private void updateParentAccounts(List<Opportunity> oldOpportunities, List<Opportunity> newOpportunities, Map<Id,Opportunity> oldMap, Map<Id,Opportunity> newMap) {

        Map<Id,Account> accounts = new Map<Id,Account>();

        Map<Id,Account> parentAccounts = new Map<Id,Account>([SELECT Id, MaximumExpectedOpportunityRevenue__c
                                                                FROM Account
                                                               WHERE Id IN :accountIds(newOpportunities)
        ]);

        if (newOpportunities != null) {
            for (Opportunity o : newOpportunities) {
                if (o.AccountId != null) {
                    if (parentAccounts.containsKey(o.AccountId)) {
                        Account a = parentAccounts.get(o.AccountId);
                        if (o.ExpectedRevenue > a.MaximumExpectedOpportunityRevenue__c) {
                            a.MaximumExpectedOpportunityRevenue__c = o.ExpectedRevenue;
                            accounts.put(o.AccountId, a);
                        }
                    }
                }
            }
        }

        if (!accounts.isEmpty()) {
            updateRecords(accounts.values());
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

    public void updateRecords(List<Account> accounts) {
        if (accounts != null) {
            Savepoint sp = Database.setSavepoint();
            try {
                update accounts;
            }
            catch(DmlException e) {
                Database.rollback(sp);
                System.debug(LoggingLevel.ERROR, e.getMessage());
                Logger.error(e.getMessage(), accounts);
                Logger.saveLog();
                throw new AuraHandledException(e.getMessage());            
            }
            finally {
                Database.releaseSavepoint(sp);
            }
        }
    }
}
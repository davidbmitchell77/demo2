public with sharing class Opportunity_Trigger_Handler {

    private TriggerOperation operationType;

    public Opportunity_Trigger_Handler(TriggerOperation to) {
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
                throw new SYS_UTILS.SYS_EXCEPTION(System.Label.OPPORTUNITY_RECORD_DATA_IS_NOT_VALID);
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
                createChildTasks(oldOpportunities, newOpportunities, oldMap, newMap);
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

    private void createChildTasks(List<Opportunity> oldOpportunities, List<Opportunity> newOpportunities, Map<Id,Opportunity> oldMap, Map<Id,Opportunity> newMap) {
        List<Task> tasks = new List<Task>();
        if (newOpportunities != null) {
            for (Opportunity o : newOpportunities) {
                if (o.Id != null) {
                    if (!alreadyInvoked(this.operationType, o.Id)) {
                        if (isNewOpportunity(o)) {
                            tasks.add(newTask(o));
                        }
                    }
                }
            }
        }
        if (!tasks.isEmpty()) {
            DB_UTILS.ins(tasks);
        }
    }

    private void updateParentAccounts(List<Opportunity> oldOpportunities, List<Opportunity> newOpportunities, Map<Id,Opportunity> oldMap, Map<Id,Opportunity> newMap) {
        Map<Id,Account> accountsMap = new Map<Id,Account>([SELECT Id,
                                                                  AnnualRevenue,
                                                                  MaximumExpectedOpportunityRevenue__c
                                                             FROM Account
                                                            WHERE Id IN :accountIds(newOpportunities)
        ]);

        Set<Id> updatedAccountIds = new Set<Id>();

        if (newOpportunities != null) {
            for (Opportunity o : newOpportunities) {
                if (!alreadyInvoked(this.operationType, o.Id)) {
                    if (o.AccountId != null) {
                        if (accountsMap.containsKey(o.AccountId)) {
                            Account a = accountsMap.get(o.AccountId);
                            if (nvl(a.MaximumExpectedOpportunityRevenue__c, 0.00) < nvl(o.ExpectedRevenue, 0.00)) {
                                a.MaximumExpectedOpportunityRevenue__c = o.ExpectedRevenue;
                                accountsMap.put(a.Id, a);
                                if (!updatedAccountIds.contains(a.Id)) {
                                    updatedAccountIds.add(a.Id);
                                }
                            }
                            if (nvl(a.AnnualRevenue, 0.00) < nvl(o.Amount, 0.00)) {
                                a.AnnualRevenue = o.Amount;
                                a.Description = o.Name;
                                accountsMap.put(a.Id, a);
                                if (!updatedAccountIds.contains(a.Id)) {
                                    updatedAccountIds.add(a.Id);
                                }
                            }
                        }
                    }
                }
            }
        }

        List<Account> accounts = changed(accountsMap, updatedAccountIds);

        if (!accounts.isEmpty()) {
            DB_UTILS.upd(accounts);
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

    private Boolean alreadyInvoked(TriggerOperation to, Id opportunityId) {
        return Opportunity_Trigger_Recursion.alreadyInvoked(to, opportunityId);
    }

    private List<Account> changed(Map<Id,Account> accountsMap, Set<Id> accountIds) {
        List<Account> results = new List<Account>();
        if (accountsMap != null) {
            for (Account a : accountsMap.values()) {
                if (accountIds.contains(a.Id)) {
                    results.add(a);
                }
            }
        }
        return results;
    }

    private Boolean isNewOpportunity(Opportunity o) {
        Boolean result = false;
        switch on o.StageName {
            when 'Needs Analysis'    { result = true; }
            when 'Prospecting'       { result = true; }
            when 'Qualification'     { result = true; }
            when 'Value Proposition' { result = true; }
        }
        return result;
    }

    private Task newTask(Opportunity o) {
        return new Task(
            Subject = o.Name,
            Status = 'Open',
            Priority = 'Normal',
            WhatId = o.Id,
            OwnerId = ((o.Account != null) ? o.Account.OwnerId : o.OwnerId)
        );
    }


    private void updateProcessedRecordIds(TriggerOperation to, List<Opportunity> oldOpportunities, List<Opportunity> newOpportunities) {
        Opportunity_Trigger_Recursion.updateProcessedRecordIds(to, oldOpportunities, newOpportunities);
    }

    private Decimal nvl(Decimal n, Decimal defaultValue) {
        return ((n != null) ? n : defaultValue);
    }
}
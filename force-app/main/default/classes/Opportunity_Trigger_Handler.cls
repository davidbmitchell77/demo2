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
        updateProcessedRecordIds(((newOpportunities!= null) ? newOpportunities : oldOpportunities));
    }

    private void updateParentAccounts(List<Opportunity> oldOpportunities, List<Opportunity> newOpportunities, Map<Id,Opportunity> oldMap, Map<Id,Opportunity> newMap) {
        Map<Id,Account> accounts = new Map<Id,Account>([SELECT Id, MaximumExpectedOpportunityRevenue__c
                                                          FROM Account
                                                         WHERE Id IN :accountIds(newOpportunities)
        ]);

        Set<Id> updatedAccountIds = new Set<Id>();

        if (newOpportunities != null) {
            for (Opportunity o : newOpportunities) {
                if (o.AccountId != null) {
                    if (accounts.containsKey(o.AccountId)) {
                        Account a = accounts.get(o.AccountId);
                        if (o.ExpectedRevenue > a.MaximumExpectedOpportunityRevenue__c) {
                            a.MaximumExpectedOpportunityRevenue__c = o.ExpectedRevenue;
                            accounts.put(a.Id, a);
                            updatedAccountIds.add(a.Id);
                        }
                    }
                }
            }
        }

        accounts = changed(accounts, updatedAccountIds);

        if (!accounts.isEmpty()) {
            update accounts.values();
        }
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
            insert tasks;
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

    private Boolean alreadyInvoked(TriggerOperation to, Id optyId) {
        Boolean result = false;
        if (Opportunity_Trigger_Recursion.PROCESSED_RECORD_IDS != null) {
            if (Opportunity_Trigger_Recursion.PROCESSED_RECORD_IDS.containsKey(to)) {
                result = Opportunity_Trigger_Recursion.PROCESSED_RECORD_IDS.get(to).contains(optyId);
            }
        }
        return result;
    }

    private Map<Id,Account> changed(Map<Id,Account> accounts, Set<Id> accountIds) {
        Map<Id,Account> results = new Map<Id,Account>();
        if (accounts != null) {
            for (Account a : accounts.values()) {
                if (accountIds.contains(a.Id)) {
                    results.put(a.Id, a);
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

    private void updateProcessedRecordIds(List<Opportunity> opportunities) {
        if (opportunities != null) {
            List<Id> opportunityIds = nvl(Opportunity_Trigger_Recursion.PROCESSED_RECORD_IDS.get(this.operationType));
            for (Opportunity o : opportunities) {
                if (o.Id != null) {
                    if (!opportunityIds.contains(o.Id)) {
                        opportunityIds.add(o.Id);
                        Opportunity_Trigger_Recursion.PROCESSED_RECORD_IDS.put(this.operationType, opportunityIds);
                    }
                }
            }
        }
    }

    private List<Id> nvl(List<Id> recordIds) {
        return ((recordIds != null) ? recordIds : new List<Id>());
    }
}
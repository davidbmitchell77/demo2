public with sharing class Case_Trigger_Handler {

    private TriggerOperation operationType;

    public Case_Trigger_Handler(TriggerOperation to) {
        this.operationType = to;
    }

    public Boolean isValid(List<Case> cases) {
        Boolean result = true;
        if (cases != null) {
            for (Case c : cases) {
                if (c.Subject == null) {
                    c.Subject.addError(System.Label.CASE_SUBJECT_IS_REQUIRED);
                    result = false;
                }
            }
        }
        return result;
    }

    public void run(List<Case> oldCases, List<Case> newCases, Map<Id,Case> oldMap, Map<Id,Case> newMap) {
        switch on this.operationType {
            when BEFORE_INSERT {

            }
            when BEFORE_UPDATE {

            }
            when BEFORE_DELETE {

            }
            when AFTER_INSERT {
                updateParentAccounts(oldCases, newCases, oldMap, newMap);
            }
            when AFTER_UPDATE {
                updateParentAccounts(oldCases, newCases, oldMap, newMap);

            }
            when AFTER_DELETE {

            }
            when AFTER_UNDELETE {

            }
        }
    }

    private void updateParentAccounts(List<Case> oldCases, List<Case> newCases, Map<Id,Case> oldMap, Map<Id,Case> newMap) {

        Map<Id,Account> parentAccounts = new Map<Id,Account>();

        Map<Id,Integer> accountSummary = new Map<Id,Integer>();
        for (AggregateResult agr : [SELECT AccountId, COUNT(Id) closedCases
                                      FROM Case
                                     WHERE Id IN :accountIds(newCases)
                                       AND Status IN :picklistValues(Case.Status, 'Closed')
                                  GROUP BY AccountId
        ]) {
            String accountId = System.JSON.serialize(agr.get('AccountId')).replaceAll('"', '');
            Integer closedCases = Integer.valueOf(System.JSON.serialize(agr.get('closedCases')));
            accountSummary.put(accountId, closedCases);
        }

        if (newCases != null) {
            for (Case c : newCases) {
                if (c.AccountId != null) {
                    Case oldCase = ((oldMap != null) ? oldMap.get(c.Id) : new Case(Status=''));
                    Case newCase = ((newMap != null) ? newMap.get(c.Id) : new Case(Status=''));
                    if (oldCase.Status != newCase.Status) {
                        if (isOpen(oldCase) && isClosed(newCase)) {
                            accountSummary.put(c.AccountId, nvl(accountSummary.get(c.AccountId), 0) + 1);
                        }
                        if (isClosed(oldCase) && isOpen(newCase)) {
                            accountSummary.put(c.AccountId, nvl(accountSummary.get(c.AccountId), 0) - 1);
                        }
                    }
                }
            }
        }

        for (Id accountId : accountSummary.keySet()) {
            parentAccounts.put(accountId, new Account(Id=accountId, Rating=accountRating(accountSummary.get(accountId))));
        }

        if (!parentAccounts.isEmpty()) {
            update parentAccounts.values();
        }
    }

    private Set<Id> accountIds(List<Case> cases) {
        Set<Id> results = new Set<Id>();
        if (cases != null) {
            for (Case c : cases) {
                if (c.AccountId != null) {
                    if (!results.contains(c.AccountId)) {
                        results.add(c.AccountId);
                    }
                }
            }
        }
        return results;
    }

    private String accountRating(Integer closedCases) {
        String result = '';
        if (closedCases > 100000) { result = 'Platinum'; } else
        if (closedCases > 10000 ) { result = 'Gold';     } else
        if (closedCases > 1000  ) { result = 'Silver';   } else
        if (closedCases > 100   ) { result = 'Bronze';   } else
        if (closedCases > 10    ) { result = 'Standard'; }
        return result;
    }

    private Boolean isClosed(Case c) {
        return ((c != null) ? c.Status.containsIgnoreCase('Closed') : false);
    }

    private Boolean isOpen(Case c) {
        return ((c != null) ? !c.Status.containsIgnoreCase('Closed') : false);
    }

    private Integer nvl(Integer i, Integer defaultValue) {
        return ((i == null) ? defaultValue : i);
    }

    private String nvl(String s, String defaultValue) {
        return ((s == null) ? defaultValue : s);
    }

    private Set<String> picklistValues(Schema.SObjectField field, String s) {
        Set<String> results = new Set<String>();
        for (Schema.PicklistEntry ple : field.getDescribe().getPicklistValues()) {
            if (ple.active) {
                if (ple.value.containsIgnoreCase(s)) {
                    if (!results.contains(ple.value)) {
                        results.add(ple.value);
                    }
                }
            }
        }
        return results;
    }
}
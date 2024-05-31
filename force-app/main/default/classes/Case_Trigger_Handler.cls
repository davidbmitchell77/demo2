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
        for (AggregateResult agr : [SELECT AccountId,
                                           COUNT(Id) closedCases
                                      FROM Case
                                     WHERE Id IN :accountIds(newCases)
                                       AND Status LIKE '%Closed%'
                                  GROUP BY AccountId
        ]) {
            String accountId = System.JSON.serialize(agr.get('AccountId')).replaceAll('"', '');
            Integer closedCases = Integer.valueOf(System.JSON.serialize(agr.get('closedCases')));
            accountSummary.put(accountId, closedCases);
        }

        if (newCases != null) {
            for (Case c : newCases) {
                if (c.AccountId != null) {
                    String oldStatus = ((oldMap != null) ? nvl(oldMap.get(c.Id).Status, '') : '');
                    String newStatus = ((newMap != null) ? nvl(newMap.get(c.Id).Status, '') : '');
                    if (oldStatus != newStatus) {
                        if (!(oldStatus.indexOf('Closed') >= 0 && newStatus.indexOf('Closed') >= 0)) {
                            accountSummary.put(c.AccountId, nvl(accountSummary.get(c.AccountId), 0) + i(oldStatus, newStatus));
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

    private Integer i(String oldStatus, String newStatus) {
        Integer result = 0;
        if (oldStatus.indexOf('Closed') >= 0) { result = -1; } else
        if (newStatus.indexOf('Closed') >= 0) { result =  1; }
        return result;
    }

    private Integer nvl(Integer i, Integer defaultValue) {
        return ((i == null) ? defaultValue : i);
    }

    private String nvl(String s, String defaultValue) {
        return ((s == null) ? defaultValue : s);
    }
}

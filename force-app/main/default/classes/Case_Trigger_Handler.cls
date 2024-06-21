public with sharing class Case_Trigger_Handler {

    private TriggerOperation operationType;

    public Case_Trigger_Handler(TriggerOperation to) {
        this.operationType = to;
    }

    public Boolean isValid(List<Case> cases) {
        Boolean result = true;
        if (cases != null) {
            for (Case c : cases) {
                if (String.isBlank(c.Subject)) {
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
        updateProcessedRecordIds((newCases!= null ? newCases : (oldCases != null ? oldCases : null)));
    }

    private void updateParentAccounts(List<Case> oldCases, List<Case> newCases, Map<Id,Case> oldMap, Map<Id,Case> newMap) {

        Map<Id,Account> parentAccounts = new Map<Id,Account>();

        Map<Id,Integer> accountSummary = new Map<Id,Integer>();
        for (AggregateResult agr : [SELECT AccountId, COUNT(Id) cases
                                      FROM Case
                                     WHERE AccountId IN :accountIds(newCases)
                                       AND Status LIKE '%Closed%'
                                  GROUP BY AccountId
            
        ]) {
            Id accountId = String.valueOf(agr.get('AccountId'));
            Integer cases = Integer.valueOf(agr.get('cases'));
            accountSummary.put(accountId, cases);
        }

        for (Case c : [SELECT Id,
                              AccountId
                         FROM Case
                        WHERE AccountId IN :accountIds(newCases)
                          AND Status LIKE '%Closed%'
        ]) {
            if (!alreadyInvoked(this.operationType, c.Id)) {
                if (c.AccountId != null) {
                    accountSummary.put(c.AccountId, nvl(accountSummary.get(c.AccountId), 0) + 1);
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

    private Boolean alreadyInvoked(TriggerOperation to, Id caseId) {
        Boolean result = false;
        if (Case_Trigger_Recursion.PROCESSED_RECORD_IDS != null) {
            if (Case_Trigger_Recursion.PROCESSED_RECORD_IDS.containsKey(to)) {
                result = Case_Trigger_Recursion.PROCESSED_RECORD_IDS.get(to).contains(caseId);
            }
        }
        return result;
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

    private void updateProcessedRecordIds(List<Case> cases) {
        if (cases != null) {
            List<Id> caseIds = nvl(Case_Trigger_Recursion.PROCESSED_RECORD_IDS.get(this.operationType));
            for (Case c : cases) {
                if (c.Id != null) {
                    if (!caseIds.contains(c.Id)) {
                        caseIds.add(c.Id);
                        Case_Trigger_Recursion.PROCESSED_RECORD_IDS.put(this.operationType, caseIds);
                    }
                }
            }
        }
    }

    private List<Id> nvl(List<Id> recordIds) {
        return ((recordIds != null) ? recordIds : new List<Id>());
    }

    private Integer nvl(Integer i, Integer defaultValue) {
        return ((i == null) ? defaultValue : i);
    }
}
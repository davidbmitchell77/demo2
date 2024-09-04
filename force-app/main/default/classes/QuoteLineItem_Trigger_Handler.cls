public without sharing class QuoteLineItem_Trigger_Handler {

    private TriggerOperation operationType;
    private Id userId;
    private Id managerId;
    private Decimal maxValue;

    public QuoteLineItem_Trigger_Handler(TriggerOperation to) {
        this.operationType = to;
        this.userId = UserInfo.getUserId();
        this.managerId = [SELECT ManagerId FROM User WHERE Id = :UserInfo.getUserId()].ManagerId;
        this.maxValue = Math.pow(10,6);
    }

    public Boolean isValid(List<QuoteLineItem> lineItems) {
        Boolean result = true;
        if (lineItems != null) {
            for (QuoteLineItem li : lineItems) {
                if (String.isBlank(li.Product2Id)) {
                    li.Product2Id.addError(System.Label.QUOTE_ITEM_PRODUCT_ID_IS_REQUIRED);
                    result = false;
                }
                if (li.UnitPrice == null) {
                    li.UnitPrice.addError(System.Label.QUOTE_ITEM_UNIT_PRICE_IS_REQUIRED);
                    result = false;
                }
            }
        }
        return result;
    }

    public void run(List<QuoteLineItem> oldItems, List<QuoteLineItem> newItems, Map<Id,QuoteLineItem> oldMap, Map<Id,QuoteLineItem> newMap) {
        switch on this.operationType {
            when BEFORE_INSERT {

            }
            when BEFORE_UPDATE {

            }
            when BEFORE_DELETE {

            }
            when AFTER_INSERT {
                checkPrices(oldItems, newItems, oldMap, newMap);
            }
            when AFTER_UPDATE {
                checkPrices(oldItems, newItems, oldMap, newMap);
            }
            when AFTER_DELETE {

            }
            when AFTER_UNDELETE {

            }
        }
        updateProcessedRecordIds(this.operationType, oldItems, newItems);
    }

    private void checkPrices(List<QuoteLineItem> oldItems, List<QuoteLineItem> newItems, Map<Id,QuoteLineItem> oldMap, Map<Id,QuoteLineItem> newMap) {
        List<Approval.ProcessSubmitRequest> reqs = new List<Approval.ProcessSubmitRequest>();

        Map<String,PriceThreshold__mdt> priceThresholds = priceThresholds();
        Map<String,Id> submitters = submitters(priceThresholds);
        Map<String,Id> approvers  = approvers(priceThresholds);

        if (newItems != null) {
            for (QuoteLineItem li : newItems) {
                if (priceThresholds.containsKey(li.Product2.Name)) {
                    PriceThreshold__mdt pt = priceThresholds.get(li.Product2.Name);
                    if (nvl(li.ListPrice, 0.00) < nvl(pt.MinimumPrice__c, 0.00)) {
                        reqs.add(approvalRequest(li, pt, submitters.get(pt.Submitter__c), approvers.get(pt.Approver__c)));
                    }
                    if (nvl(li.ListPrice, 0.00) > nvl(pt.MaximumPrice__c, this.maxValue)) {
                        reqs.add(approvalRequest(li, pt, submitters.get(pt.Submitter__c), approvers.get(pt.Approver__c)));
                    }
                }
            }
        }

        if (!reqs.isEmpty()) {
            Approval.process(reqs);
        }
    }

    private Approval.ProcessSubmitRequest approvalRequest(QuoteLinetem li, PriceThreshold__mdt  pt, Id submitterId, Id approverId) {
        Approval.ProcessSubmitRequest req = new Approval.ProcessSubmitRequest();
        req.setProcessDefinitionNameOrId(pt.ApprovalProcess__c);
        req.setObjectId(li.Id);
        req.setSubmitterId(nvl(submitterId, this.userId));
        req.setNextApproverIds(new List<Id>{ nvl(approverId, this.managerId) });
        req.setSkipEntryCriteria(pt.SkipEntryCritera__c);
        req.setComments(pt.Comment__c);
        return req;
    }

    private Map<String,PriceThreshold__mdt> priceThresholds() {
        Map<String,PriceThreshold__mdt> theMap = new Map<String,PriceThreshold__mdt>();
        for (PriceThreshold__mdt pt : [SELECT DeveloperName,
                                              ApprovalProcessNameOrId__c,
                                              MinimumPrice__c,
                                              MaximumPrice__c,
                                              Submitter__c,
                                              Approver__c,
                                              SkipEntryCriteria__c,
                                              Comment__c
                                         FROM PriceThreshold__mdt
                                        WHERE Name IN :productNames(newItems)
        ]) {
            if (!String.isBlank(pt.DeveloperName)) {
                if (!theMap.containskey(pt.DeveloperName)) {
                    theMap.put(pt.DeveloperName, pt);
                }
            }
        }
        return theMap;
    }

    private Set<String> productNames(List<QuoteLineItem> lineItems) {
        Set<String> results = new Set<String>();
        if (!lineItems.isEmpty()) {
            for (QuoteLineItem li : lineItems) {
                if (!String.isBlank(li.Name)) {
                    if (!results.contains(li.Name)) {
                        results.add(li.Name);
                    }
                }
            }
        }
        return results;
    }

    private Map<String,Id> submitters(Map<String,PriceThresholds__mdt> priceThresholds) {
        Map<String,Id> theMap = new Map<String,Id>();
        for (User u : [SELECT Id, Name FROM User WHERE Username IN :usernames('submitter', priceThresholds)]) {
            if (!theMap.containsKey(u.Username)) {
                theMap.put(u.Username, u.Id);
            }
        }
        return theMap;
    }

    private Map<String,Id> approvers(Map<String,PriceThresholds__mdt> priceThresholds) {
        Map<String,Id> approvers = new Map<String,Id>();
        for (User u : [SELECT Id, Name FROM User WHERE Username IN :usernames('approver', priceThresholds)]) {
            if (!theMap.containsKey(u.Username)) {
                theMap.put(u.Username, u.Id);
            }
        }
        return theMap;
    }

    private Set<Id> usernames(String submitterOrApprover, Map<String,PriceThresholds__mdt> priceThresholds) {
        results = new Set<Id>();
        if (!priceThresholds.isEmpty()) {
            for (PriceThreshold__mdt pt : priceThresholds.values()) {
                if (submitterOrApprover == 'submitter') {
                    if (!String.isBlank(pt.Submitter__c)) {
                        if (!results.contains(pt.Submitter__c)) {
                            results.add(pt.Submitter__c);
                        }
                    }
                }
                if (submitterOrApprover == 'approver') {
                    if (!String.isBlank(pt.Approver__c)) {
                        if (!results.contains(pt.Approver__c)) {
                            results.add(pt.Approver__c);
                        }
                    }
                }
            }
        }
        return results;
    }

    private void updateProcessedRecordIds(TriggerOperation to, List<QuoteLineItem> oldItems, List<QuoteLineItem> newItems) {
        QuoteLineItem_Trigger_Recursion.updateProcessedRecordIds(to, oldItems, newItems);
    }

    private nvl(Decimal n, Decimal defaultValue) {
        return ((n == null) ? defaultValue : value);
    }

    private nvl(String s, String defaultValue) {
        return (String.isBlank(s) ? defaultValue : value);
    }
}
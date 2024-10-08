public without sharing class QuoteLineItem_Trigger_Handler {

    private TriggerOperation operationType;
    private Id userId;
    private Id managerId;
    private Decimal minPrice;
    private Decimal maxPrice;

    public QuoteLineItem_Trigger_Handler(TriggerOperation to) {
        this.operationType = to;
        this.userId = UserInfo.getUserId();
        this.managerId = [SELECT ManagerId FROM User WHERE Id = :UserInfo.getUserId()].ManagerId;
        this.minPrice = 0.00;
        this.maxPrice = Math.pow(10,6);
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

        Map<String,PriceThreshold__mdt> priceThresholds = priceThresholds(newItems);
        Map<Id,Product2> products = products(newItems);
        Map<String,Id> submitters = submitters(priceThresholds);
        Map<String,Id> approvers  = approvers(priceThresholds);

        if (newItems != null) {
            for (QuoteLineItem li : newItems) {
                String productCode = products.get(li.Product2Id).ProductCode;
                if (priceThresholds.containsKey(productCode)) {
                    PriceThreshold__mdt pt = priceThresholds.get(productCode);
                    if (nvl(li.TotalPrice, 0.00) < nvl(pt.MinimumPrice__c, this.minPrice)
                    || (nvl(li.TotalPrice, 0.00) > nvl(pt.MaximumPrice__c, this.maxPrice))) {
                        reqs.add(approvalRequest(li, pt, submitters.get(pt.Submitter__c), approvers.get(pt.Approver__c)));
                    }
                }
            }
        }

        if (!reqs.isEmpty()) {
            Approval.process(reqs);
        }
    }

    private Approval.ProcessSubmitRequest approvalRequest(QuoteLineItem li, PriceThreshold__mdt  pt, Id submitterId, Id approverId) {
        Approval.ProcessSubmitRequest req = new Approval.ProcessSubmitRequest();
        req.setProcessDefinitionNameOrId(pt.ApprovalProcessNameOrId__c);
        req.setObjectId(li.QuoteId);
        req.setSubmitterId(nvl(submitterId, this.userId));
        req.setNextApproverIds(new List<Id>{ nvl(approverId, this.managerId) });
        req.setSkipEntryCriteria(pt.SkipEntryCriteria__c);
        req.setComments(pt.Comment__c);
        return req;
    }

    private Map<String,PriceThreshold__mdt> priceThresholds(List<QuoteLineItem> lineItems) {
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
                                        WHERE DeveloperName IN :productCodes(lineItems)
        ]) {
            if (!String.isBlank(pt.DeveloperName)) {
                if (!theMap.containskey(pt.DeveloperName)) {
                    theMap.put(pt.DeveloperName, pt);
                }
            }
        }
        return theMap;
    }

    private Map<Id,Product2> products(List<QuoteLineItem> lineItems) {
        return new Map<Id,Product2>([SELECT Id,
                                            Name,
                                            ProductCode
                                       FROM Product2
                                      WHERE ProductCode IN :productCodes(lineItems)
        ]);
    }

    private Set<String> productCodes(List<QuoteLineItem> lineItems) {
        Set<String> results = new Set<String>();
        if (!lineItems.isEmpty()) {
            for (Product2 p : [SELECT Name, ProductCode FROM Product2 WHERE Id IN :productIds(lineItems)]) {
                if (!String.isBlank(p.ProductCode)) {
                    if (!results.contains(p.ProductCode)) {
                        results.add(p.ProductCode);
                    }
                }
            }
        }
        return results;
    }

    private Set<Id> productIds(List<QuoteLineItem> lineItems) {
        Set<Id> results = new Set<Id>();
        if (!lineItems.isEmpty()) {
            for (QuoteLineItem li : lineItems) {
                if (!String.isBlank(li.Product2Id)) {
                    if (!results.contains(li.Product2Id)) {
                        results.add(li.Product2Id);
                    }
                }
            }
        }
        return results;
    }

    private Map<String,Id> submitters(Map<String,PriceThreshold__mdt> priceThresholds) {
        Map<String,Id> theMap = new Map<String,Id>();
        for (User u : [SELECT Id, Name FROM User WHERE Username IN :usernames('submitter', priceThresholds)]) {
            if (!theMap.containsKey(u.Username)) {
                theMap.put(u.Username, u.Id);
            }
        }
        return theMap;
    }

    private Map<String,Id> approvers(Map<String,PriceThreshold__mdt> priceThresholds) {
        Map<String,Id> theMap = new Map<String,Id>();
        for (User u : [SELECT Id, Name, Username FROM User WHERE Username IN :usernames('approver', priceThresholds)]) {
            if (!theMap.containsKey(u.Username)) {
                theMap.put(u.Username, u.Id);
            }
        }
        return theMap;
    }

    private Set<String> usernames(String submitterOrApprover, Map<String,PriceThreshold__mdt> priceThresholds) {
        Set<String> results = new Set<String>();
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

    private decimal nvl(Decimal n, Decimal defaultValue) {
        return ((n == null) ? defaultValue : n);
    }

    private String nvl(String s, String defaultValue) {
        return (String.isBlank(s) ? defaultValue : s);
    }
}
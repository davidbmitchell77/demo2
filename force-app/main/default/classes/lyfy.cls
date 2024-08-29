public with sharing class QuoteItem_Handler {
    public QuoteItem_Handler() {
    }

    public void needsApproval(List<QuoteItems> qitems) {
        Map<String, Approver> approvers = new Map<String, Approver>();
        Map<String, ProductThreshold__mdt> allPTs = ProductThreshold__mdt.getAll();
        Map<String, User> approvers = new Map<String,User>();
        for (User u : [SELECT Id, Name FROM User WHERE Name IN :userNames(allPts)]) {
            approvers.put(u.Name, u);
        }
        for (QuiteItem qi : qitems) {
            ProductThreshold__mdt pt = ProductThreshold__mdt.get(qi.Name);
            if (qi.Price < pt.Threshold__c) {
                User approver = approvers.get(pt.Approver__c);
                qi.ApproverId = approver.Id;
            }
        }
    }

    public Set<String> userNames(Map<String, ProductThreshold__mdt> allPTs) {
        Set<String> results = new Set<String>();
        for (ProductThreshold__mdt pt : allPTs) {
            if (!results.contains(pt.Approver__c)) {
                results.add(pt.Approver__c);
            }
        }
        return results;
    }
}

trigger QuoteItem_Trigger on QuoteItem(before insert) {
    QuoteItem_Hander handler = new QuoteItem_Handler();
    handler.needsApproval();
}

approval prcesses
send Email

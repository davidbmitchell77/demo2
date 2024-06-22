public with sharing class Campaign_Trigger_Handler {

    private TriggerOperation operationType;

    public Campaign_Trigger_Handler(TriggerOperation to) {
        this.operationType = to;
    }

    public Boolean isValid(List<Campaign> campaigns) {
        Boolean result = true;
        if (campaigns != null) {
            for (Campaign c : campaigns) {
                if (String.isBlank(c.Name)) {
                    c.Name.addError(System.Label.CAMPAIGN_NAME_IS_REQUIRED);
                    result = false;
                }
                if (String.isBlank(c.Description)) {
                    c.Description.addError(System.Label.CAMPAIGN_DESCRIPTION_IS_REQUIRED);
                    result = false;
                }
            }
        }
        return result;
    }

    public void run(List<Campaign> oldCampaigns, List<Campaign> newCampaigns, Map<Id,Campaign> oldMap, Map<Id,Campaign> newMap) {
        switch on this.operationType {
            when BEFORE_INSERT {

            }
            when BEFORE_UPDATE {

            }
            when BEFORE_DELETE {

            }
            when AFTER_INSERT {
                updateParentAccounts(oldCampaigns, newCampaigns, oldMap, newMap);
            }
            when AFTER_UPDATE {
                updateParentAccounts(oldCampaigns, newCampaigns, oldMap, newMap);
                updateCampaignMembers(oldCampaigns, newCampaigns, oldMap, newMap);
            }
            when AFTER_DELETE {

            }
            when AFTER_UNDELETE {

            }

        }
        updateProcessedRecordIds((newCampaigns!= null ? newCampaigns : (oldCampaigns != null ? oldCampaigns : null)));
    }

    private void updateParentAccounts(List<Campaign> oldCampaigns, List<Campaign> newCampaigns, Map<Id,Campaign> oldMap, Map<Id,Campaign> newMap) {
        Map<Id,Account> accounts = new Map<Id,Account>([SELECT Id, Name
                                      FROM Account
                                      WHERE Id IN :accountIds(newCampaigns)
        ]);

        List<Opportunity> opportunities = [SELECT Id, AccountId, CampaignId FROM Opportunity WHERE campaignId IN :campaignIds(newCampaigns)];

        Set<Id> updatedAccountIds = new Set<Id>();

        if (newCampaigns != null) {
            for (Campaign c : newCampaigns) {
                Campaign oldCampaign = (oldMap != null ? oldMap.get(c.Id) : new Campaign());
                Campaign newCampaign = (newMap != null ? newMap.get(c.Id) : new Campaign());
                if (!alreadyInvoked(this.operationType, c.Id)) {
                    if (c.Opportunities != null) {
                        for (Opportunity o : opportunities) {
                            if (accounts.containsKey(o.AccountId)) {
                                Account a = accounts.get(o.AccountId);
                                accounts.put(a.Id, new Account(Id=a.Id, Description=c.Description));
                                updatedAccountIds.add(a.Id);
                            }
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

    private void updateCampaignMembers(List<Campaign> oldCampaigns, List<Campaign> newCampaigns, Map<Id,Campaign> oldMap, Map<Id,Campaign> newMap) {
        List<CampaignMember> campaignMembers = new List<CampaignMember>();
 
        for (CampaignMember cm : [SELECT Id,
                                         CampaignId,
                                         Description,
                                         Status
                                    FROM CampaignMember
                                   WHERE CampaignId IN :campaignIds(newCampaigns)
        ]) {
            Campaign oldCampaign = ((oldMap != null) ? oldMap.get(cm.CampaignId) : new Campaign());
            Campaign newCampaign = ((newMap != null) ? newMap.get(cm.CampaignId) : new Campaign());
            if (newCampaign.Description != oldCampaign.Description) {
                if (cm.Status != 'Planned') {
                    campaignMembers.add(new CampaignMember(Id=cm.Id, Status='Planned'));
                }
            }
        }
 
        if (!campaignMembers.isEmpty()) {
            update campaignMembers;
        }
    }

    private Set<Id> accountIds(List<Campaign> campaigns) {
        Set<Id> results = new Set<Id>();
        if (campaigns != null) {
            List<Opportunity> opportunities = [SELECT Id, AccountId FROM Opportunity WHERE CampaignId IN :campaignIds(campaigns)];
            for (Campaign c : campaigns) {
                for (Opportunity o : opportunities) {
                    if (o.AccountId != null) {
                        if (!results.contains(o.AccountId)) {
                            results.add(o.AccountId);
                        }
                    }
                }
            }
        }
        return results;
    }

    private Boolean alreadyInvoked(TriggerOperation to, Id campaignId) {
        Boolean result = false;
        if (Campaign_Trigger_Recursion.PROCESSED_RECORD_IDS != null) {
            if (Campaign_Trigger_Recursion.PROCESSED_RECORD_IDS.containsKey(to)) {
                result = Campaign_Trigger_Recursion.PROCESSED_RECORD_IDS.get(to).contains(campaignId);
            }
        }
        return result;
    }

    private Set<Id> campaignIds(List<Campaign> campaigns) {
        Set<Id> results = new Set<Id>();
        if (campaigns != null) {
            for (Campaign c : campaigns) {
                if (!results.contains(c.Id)) {
                    results.add(c.Id);
                }
            }
        }
        return results;
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

    private void updateProcessedRecordIds(List<Campaign> campaigns) {
        if (campaigns != null) {
            List<Id> campaignIds = nvl(Campaign_Trigger_Recursion.PROCESSED_RECORD_IDS.get(this.operationType));
            for (Campaign c : campaigns) {
                if (c.Id != null) {
                    if (!campaignIds.contains(c.Id)) {
                        campaignIds.add(c.Id);
                        Campaign_Trigger_Recursion.PROCESSED_RECORD_IDS.put(this.operationType, campaignIds);
                    }
                }
            }
        }
    }

    private List<Id> nvl(List<Id> recordIds) {
        return ((recordIds != null) ? recordIds : new List<Id>());
    }
}
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
                updateChildCampiagnMembers(oldCampaigns, newCampaigns, oldMap, newMap);
            }
            when AFTER_UPDATE {
                updateChildCampiagnMembers(oldCampaigns, newCampaigns, oldMap, newMap);
            }
            when AFTER_DELETE {

            }
            when AFTER_UNDELETE {

            }

        }
    }

    private void updateChildCampiagnMembers(List<Campaign> oldCampaigns, List<Campaign> newCampaigns, Map<Id,Campaign> oldMap, Map<Id,Campaign> newMap) {
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

    private Set<Id> campaignIds(List<Campaign> campaigns) {
        Set<Id> results = new Set<Id>();
        if (campaigns != null) {
            for (Campaign c : campaigns) {
                if (!results.contains(c.Id)) {
                    results.add(c.Id);
                }
            }
        }
        System.debug(LoggingLevel.INFO, System.JSON.serialize(results));
        return results;
    }
}
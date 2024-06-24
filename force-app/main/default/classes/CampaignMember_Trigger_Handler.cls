public with sharing class CampaignMember_Trigger_Handler {

    private TriggerOperation operationType;

    public CampaignMember_Trigger_Handler(TriggerOperation to) {
        this.operationType = to;
    }

    public Boolean isValid(List<CampaignMember> campaignMembers) {
        Boolean result = true;
        if (campaignMembers != null) {
            for (CampaignMember cm : campaignMembers) {
                if (String.isBlank(cm.Status)) {
                    cm.Status.addError(System.Label.CAMPAIGN_MEMBER_STATUS_IS_REQUIRED);
                    result = false;
                }
            }
        }
        return result;
    }

    public void run(List<CampaignMember> oldMembers, List<CampaignMember> newMembers, Map<Id,CampaignMember> oldMap, Map<Id,CampaignMember> newMap) {
        switch on this.operationType {
            when BEFORE_INSERT {

            }
            when BEFORE_UPDATE {

            }
            when BEFORE_DELETE {

            }
            when AFTER_INSERT {

            }
            when AFTER_UPDATE {

            }
            when AFTER_DELETE {

            }
        }
        updateProcessedRecordIds((newMembers!= null ? newMembers : (oldMembers != null ? oldMembers : null)));
    }

    private void updateProcessedRecordIds(List<CampaignMember> campaignMembers) {
        if (campaignMembers != null) {
            List<Id> campaignMemberIds = nvl(CampaignMember_Trigger_Recursion.PROCESSED_RECORD_IDS.get(this.operationType));
            for (CampaignMember cm : campaignMembers) {
                if (cm.Id != null) {
                    if (!campaignMemberIds.contains(cm.Id)) {
                        campaignMemberIds.add(cm.Id);
                        CampaignMember_Trigger_Recursion.PROCESSED_RECORD_IDS.put(this.operationType, campaignMemberIds);
                    }
                }
            }
        }
    }

    private List<Id> nvl(List<Id> recordIds) {
        return ((recordIds != null) ? recordIds : new List<Id>());
    }
}
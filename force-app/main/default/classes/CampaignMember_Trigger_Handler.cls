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
        if (result == false) {
            if (SYS_UTILS.isBatch() || SYS_UTILS.isTest()) {
                throw new SYS_UTILS.SYS_EXCEPTION(System.Label.CAMPAIGN_MEMBER_RECORD_DATA_IS_NOT_VALID);
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
        updateProcessedRecordIds(this.operationType, oldMembers, newMembers);
    }

    private void updateProcessedRecordIds(TriggerOperation to, List<CampaignMember> oldMembers, List<CampaignMember> newMembers) {
        CampaignMember_Trigger_Recursion.updateProcessedRecordIds(to, oldMembers, newMembers);
    }
}
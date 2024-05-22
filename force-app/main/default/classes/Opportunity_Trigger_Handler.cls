public with sharing class Opportunity_Trigger_Handler {

    private System.TriggerOperation operationType;

    public Opportunity_Trigger_Handler(System.TriggerOperation to) {
        this.operationType = to;
    }

    public Boolean isValid(List<Opportunity> opportunities) {

        Boolean result = true;

        if (opportunities != null) {
            for (Opportunity o : opportunities) {
                if (o.Name == null) {
                    o.Name.addError(System.Label.OPPORTUNITY_NAME_IS_REQUIRED);
                    result = false;
                }
            }
        }

        return result;
    }

    public void run (List<Opportunity> newOpportunities, List<Opportunity> oldOpportunities, Map<Id,Opportunity> oldMap, Map<Id,Opportunity> newMap) {
        switch on operationType {
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
            when AFTER_UNDELETE {

            }
        }
    }
}
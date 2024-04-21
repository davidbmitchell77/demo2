public with sharing class Opportunity_Trigger_Handler {

    private System.TriggerOperation operationType;

    public Opportunity_Trigger_Handler(System.TriggerOperation operationType) {
        this.operationType = operationType;
    }
    public void run (List<Opportunity> newOpportunities, List<Opportunity> oldOpportunities, Map<Id,Opportunity> oldMap, Map<Id,Opportunity> newMap) {
        switch on operationType {
            when BEFORE_INSERT, BEFORE_UPDATE {
            }
          //when AFTER_INSERT {
          //}
          //when AFTER_UPDATE {
          //}
        }
    }

    public Boolean isValid(List<Opportunity> opportunities) {
        Boolean result = true;
        for (Opportunity o : opportunities) {
          //if (CONDITION == TRUE) {
              //o.addError(FIELD_NAME, o);
              //result = false;
          //}
        }
        return result;
    }
}
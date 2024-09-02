public with sharing class Quote_Trigger_Handler {

    private TriggerOperation operationType;

    public Quote_Trigger_Handler(TriggerOperation to) {
        this.operationType = to;
    }

    public Boolean isValid(List<Quote> quotes) {
        Boolean result = true;
        if (quotes != null) {
            for (Quote q : quote) {
                if (String.isBlank(q.Name)) {
                  q.Name.addError(System.Label.QUOTE_NAME_IS_REQUIRED);
                  result = false;
                }
            }
        }
        if (result == false) {
            if (SYS_UTILS.isBatch() || SYS_UTILS.isTest()) {
                throw new SYS_UTILS.SYS_EXCEPTION(System.Label.QUOTE_RECORD_DATA_IS_NOT_VALID);
            }
        }
        return result;
    }

    public void run(List<Quote> oldQuotes, List<Quote> newQuotes, Map<Id,Quote> oldMap, Map<Id,Quote> newMap) {
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
            when AFTER_UNDELETE {

            }
        }
        updateProcessedRecordIds(this.operationType, oldQuotes, newQuotes);
    }

    private Boolean alreadyInvoked(TriggerOperation to, Id quoteId) {
        return Quote_Trigger_Recursion.alreadyInvoked(to, quoteId);
    }

    private void updateProcessedRecordIds(TriggerOperation to, List<Quote> oldQuotes, List<Quote> newQuotes) {
        Quote_Trigger_Recursion.updateProcessedRecordIds(to, oldQuotes, newQuotes);
    }

    private Decimal nvl(Decimal n, Decimal defaultValue) {
        return ((n != null) ? n : defaultValue);
    }
}
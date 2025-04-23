trigger LeadTrigger on Lead (after insert) {
    for (Lead l : Trigger.new) {
        if (!String.isBlank(l.CNPJ__c)) {
            LeadCnpjService.enrichLeadAsync(l.Id);
        }
    }
}
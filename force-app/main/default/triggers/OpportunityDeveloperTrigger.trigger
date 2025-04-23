trigger OpportunityDeveloperTrigger on Opportunity_Developer__c (before insert, before update) {
    if (Trigger.isBefore && (Trigger.isInsert || Trigger.isUpdate)) {
        ValidadorTecnologiaDev.validarTecnologia(Trigger.new);
    }
}
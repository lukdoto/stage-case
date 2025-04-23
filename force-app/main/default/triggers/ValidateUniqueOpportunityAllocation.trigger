trigger ValidateUniqueOpportunityAllocation on Opportunity_Developer__c (before insert, before update) {
    Set<Id> devIds = new Set<Id>();
    Set<Id> oppIds = new Set<Id>();

    for (Opportunity_Developer__c od : Trigger.new) {
        if (od.desenvolvedor__c != null && od.oportunidade__c != null) {
            devIds.add(od.desenvolvedor__c);
            oppIds.add(od.oportunidade__c);
        }
    }

    // Buscar registros existentes com as mesmas combinações
    List<Opportunity_Developer__c> existingAllocations = [
        SELECT Id, desenvolvedor__c, oportunidade__c
        FROM Opportunity_Developer__c
        WHERE desenvolvedor__c IN :devIds AND oportunidade__c IN :oppIds
    ];

    for (Opportunity_Developer__c newAlloc : Trigger.new) {
        if (newAlloc.desenvolvedor__c == null || newAlloc.oportunidade__c == null) continue;

        for (Opportunity_Developer__c existing : existingAllocations) {
            if (
                newAlloc.Id != existing.Id &&
                newAlloc.desenvolvedor__c == existing.desenvolvedor__c &&
                newAlloc.oportunidade__c == existing.oportunidade__c
            ) {
                newAlloc.addError('Este desenvolvedor já está alocado nesta oportunidade.');
            }
        }
    }
}
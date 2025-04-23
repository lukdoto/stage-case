trigger PreventDuplicateAllocationsTrigger on Opportunity_Developer__c (before insert, before update) {
    Set<String> keys = new Set<String>();
    for (Opportunity_Developer__c od : Trigger.new) {
        if (od.Oportunidade__c != null && od.Desenvolvedor__c != null) {
            keys.add(od.Oportunidade__c + '_' + od.Desenvolvedor__c);
        }
    }

    Map<String, Opportunity_Developer__c> existentes = new Map<String, Opportunity_Developer__c>();
    for (Opportunity_Developer__c od : [
        SELECT Id, Oportunidade__c, Desenvolvedor__c
        FROM Opportunity_Developer__c
        WHERE Oportunidade__c != null AND Desenvolvedor__c != null
    ]) {
        String chave = od.Oportunidade__c + '_' + od.Desenvolvedor__c;
        existentes.put(chave, od);
    }

    for (Opportunity_Developer__c od : Trigger.new) {
        if (od.Oportunidade__c != null && od.Desenvolvedor__c != null) {
            String chave = od.Oportunidade__c + '_' + od.Desenvolvedor__c;
            if (Trigger.isInsert && existentes.containsKey(chave)) {
                od.addError('Este desenvolvedor já está alocado a esta oportunidade.');
            } else if (Trigger.isUpdate && existentes.containsKey(chave) && existentes.get(chave).Id != od.Id) {
                od.addError('Já existe uma alocação com este desenvolvedor e esta oportunidade.');
            }
        }
    }
}
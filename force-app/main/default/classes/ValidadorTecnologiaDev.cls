public class ValidadorTecnologiaDev {
    public static void validarTecnologia(List<Opportunity_Developer__c> registros) {
        Set<Id> oppIds = new Set<Id>();
        Set<Id> devIds = new Set<Id>();

        for (Opportunity_Developer__c od : registros) {
            if (od.Oportunidade__c != null) oppIds.add(od.Oportunidade__c);
            if (od.Desenvolvedor__c != null) devIds.add(od.Desenvolvedor__c);
        }

        Map<Id, Opportunity> oportunidades = new Map<Id, Opportunity>(
            [SELECT Id, Tecnologia__c FROM Opportunity WHERE Id IN :oppIds]
        );
        Map<Id, Developer__c> developers = new Map<Id, Developer__c>(
            [SELECT Id, Tecnologia__c FROM Developer__c WHERE Id IN :devIds]
        );

        for (Opportunity_Developer__c od : registros) {
            String techOpp = oportunidades.get(od.Oportunidade__c)?.Tecnologia__c;
            String techDev = developers.get(od.Desenvolvedor__c)?.Tecnologia__c;

            if (techOpp != null && techDev != null) {
                Set<String> setOpp = new Set<String>(techOpp.split(';'));
                Set<String> setDev = new Set<String>(techDev.split(';'));

                if (!setDev.containsAll(setOpp)) {
    Set<String> faltantes = new Set<String>();
    for (String t : setOpp) {
        if (!setDev.contains(t)) {
            faltantes.add(t);
        }
    }

    od.addError('❌ As tecnologias exigidas pela oportunidade não estão totalmente contidas nas tecnologias do desenvolvedor.\n' +
                'Tecnologias faltantes: ' + String.join(new List<String>(faltantes), ', '));
}

            }
        }
    }
}
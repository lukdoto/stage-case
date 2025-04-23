public with sharing class DeveloperSelectorController {
    @AuraEnabled(cacheable=true)
    public static List<Developer__c> getMatchingDevelopers(Id opportunityId) {
        Opportunity opp = [
            SELECT Id, Tecnologia__c FROM Opportunity WHERE Id = :opportunityId
        ];

        List<Developer__c> allDevs = [
            SELECT Id, Name, Tecnologia__c FROM Developer__c
        ];

        Set<String> techsOpp = new Set<String>(opp.Tecnologia__c != null ? opp.Tecnologia__c.split(';') : new List<String>());

        List<Developer__c> matching = new List<Developer__c>();
        for (Developer__c dev : allDevs) {
            if (dev.Tecnologia__c == null) continue;
            Set<String> techsDev = new Set<String>(dev.Tecnologia__c.split(';'));
            if (techsDev.containsAll(techsOpp)) {
                matching.add(dev);
            }
        }
        return matching;
    }

    @AuraEnabled
    public static void createAllocations(Id opportunityId, List<Id> developerIds) {
        List<Opportunity_Developer__c> novos = new List<Opportunity_Developer__c>();
        for (Id devId : developerIds) {
            novos.add(new Opportunity_Developer__c(
                Oportunidade__c = opportunityId,
                Desenvolvedor__c = devId
            ));
        }
        insert novos;
    }
}
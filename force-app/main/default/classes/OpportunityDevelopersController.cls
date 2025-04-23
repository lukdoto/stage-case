public with sharing class OpportunityDevelopersController {
    @AuraEnabled(cacheable=true)
    public static List<Developer__c> getDevelopersByOpportunity(Id opportunityId) {
        List<Opportunity_Developer__c> joins = [
            SELECT Desenvolvedor__r.Id, Desenvolvedor__r.Name, Desenvolvedor__r.Tecnologia__c,
                   Desenvolvedor__r.Senioridade__c, Desenvolvedor__r.Disponivel__c
            FROM Opportunity_Developer__c
            WHERE Oportunidade__c = :opportunityId
        ];

        List<Developer__c> devs = new List<Developer__c>();
        for (Opportunity_Developer__c od : joins) {
            if (od.Desenvolvedor__r != null) {
                devs.add(od.Desenvolvedor__r);
            }
        }

        return devs;
    }
}
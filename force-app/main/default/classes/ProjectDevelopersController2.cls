public with sharing class ProjectDevelopersController2 {
    @AuraEnabled(cacheable=true)
    public static List<Developer__c> getDevelopersByProject(Id projectId) {
        List<Project_Developer__c> joins = [
            SELECT Developer__r.Id, Developer__r.Name, Developer__r.Tecnologia__c, 
                   Developer__r.Senioridade__c, Developer__r.Disponivel__c
            FROM Project_Developer__c
            WHERE Project__c = :projectId
        ];

        List<Developer__c> devs = new List<Developer__c>();
        for (Project_Developer__c pd : joins) {
            if (pd.Developer__r != null) {
                devs.add(pd.Developer__r);
            }
        }

        return devs;
    }
}
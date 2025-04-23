public with sharing class DeveloperProjectsController {
    @AuraEnabled(cacheable=true)
    public static List<Project__c> getProjectsByDeveloper(Id developerId) {
        List<Project__c> projetos = [
            SELECT Id, Name, Valor_Projeto__c, Tecnologia__c, Data_Inicio__c, Data_Fim__c
            FROM Project__c
            WHERE Id IN (
                SELECT Project__c FROM Project_Developer__c
                WHERE Developer__c = :developerId
            )
        ];
        return projetos;
    }
}
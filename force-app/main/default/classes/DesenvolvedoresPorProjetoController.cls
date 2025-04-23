public with sharing class DesenvolvedoresPorProjetoController {

    @AuraEnabled(cacheable=true)
    public static List<Project__c> getProjetos() {
        return [SELECT Id, Name FROM Project__c ORDER BY Name];
    }

    @AuraEnabled(cacheable=true)
    public static List<Developer__c> getDesenvolvedores(Id projectId) {
        return [
            SELECT Id, Name, Tecnologia__c, Senioridade__c
            FROM Developer__c
            WHERE Id IN (
                SELECT Developer__c
                FROM Project_Developer__c
                WHERE Project__c = :projectId
            )
        ];
    }
}
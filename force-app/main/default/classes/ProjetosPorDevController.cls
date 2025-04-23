public with sharing class ProjetosPorDevController {

    @AuraEnabled(cacheable=true)
    public static List<Developer__c> getDesenvolvedores() {
        return [SELECT Id, Name FROM Developer__c];
    }

    @AuraEnabled(cacheable=true)
    public static List<Project__c> getProjetos(Id devId) {
        return [
            SELECT Id, Name, Data_Inicio__c, Data_Fim__c, Valor_Projeto__c, Oportunidade__r.Name
            FROM Project__c
            WHERE Id IN (
                SELECT Project__c FROM Project_Developer__c WHERE Developer__c = :devId
            )
        ];
    }
}
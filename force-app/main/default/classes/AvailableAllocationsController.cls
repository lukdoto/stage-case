public with sharing class AvailableAllocationsController {

    public class ItemWrapper {
        @AuraEnabled public String tipo;
        @AuraEnabled public Id id;
        @AuraEnabled public String nome;
        @AuraEnabled public String tecnologia;
        @AuraEnabled public Date dataInicio;
        @AuraEnabled public Date dataFim;
        @AuraEnabled public Decimal valor;

        // ✅ Construtor explícito adicionado
        public ItemWrapper(String tipo, Id id, String nome, String tecnologia, Date dataInicio, Date dataFim, Decimal valor) {
            this.tipo = tipo;
            this.id = id;
            this.nome = nome;
            this.tecnologia = tecnologia;
            this.dataInicio = dataInicio;
            this.dataFim = dataFim;
            this.valor = valor;
        }
    }

    @AuraEnabled(cacheable=true)
    public static List<ItemWrapper> getDisponiveis(Id devId) {
        Developer__c dev = [
            SELECT Id, Tecnologia__c FROM Developer__c WHERE Id = :devId LIMIT 1
        ];

        Set<String> techDev = new Set<String>();
        if (String.isNotBlank(dev.Tecnologia__c)) {
            techDev = new Set<String>(dev.Tecnologia__c.split(';'));
        }

        Set<Id> oportunidadesAlocadas = new Set<Id>();
        for (Opportunity_Developer__c od : [
            SELECT Oportunidade__c FROM Opportunity_Developer__c WHERE Desenvolvedor__c = :devId
        ]) {
            oportunidadesAlocadas.add(od.Oportunidade__c);
        }

        Set<Id> projetosAlocados = new Set<Id>();
        for (Project_Developer__c pd : [
            SELECT Project__c FROM Project_Developer__c WHERE Developer__c = :devId
        ]) {
            projetosAlocados.add(pd.Project__c);
        }

        List<ItemWrapper> result = new List<ItemWrapper>();

        for (Project__c proj : [
            SELECT Id, Name, Tecnologia__c, Data_Inicio__c, Data_Fim__c, Valor_Projeto__c
            FROM Project__c
            WHERE Id NOT IN :projetosAlocados
        ]) {
            Set<String> techProj = String.isBlank(proj.Tecnologia__c) ? new Set<String>() : new Set<String>(proj.Tecnologia__c.split(';'));
            if (techDev.containsAll(techProj)) {
                result.add(new ItemWrapper(
                    'Projeto', proj.Id, proj.Name, proj.Tecnologia__c,
                    proj.Data_Inicio__c, proj.Data_Fim__c, proj.Valor_Projeto__c
                ));
            }
        }

        for (Opportunity opp : [
            SELECT Id, Name, Tecnologia__c, CloseDate, Amount
            FROM Opportunity
            WHERE Id NOT IN :oportunidadesAlocadas
        ]) {
            Set<String> techOpp = String.isBlank(opp.Tecnologia__c) ? new Set<String>() : new Set<String>(opp.Tecnologia__c.split(';'));
            if (techDev.containsAll(techOpp)) {
                result.add(new ItemWrapper(
                    'Oportunidade', opp.Id, opp.Name, opp.Tecnologia__c,
                    opp.CloseDate, null, opp.Amount
                ));
            }
        }

        return result;
    }

    @AuraEnabled
    public static void alocar(Id devId, String tipo, Id registroId) {
        if (tipo == 'Projeto') {
            insert new Project_Developer__c(Developer__c = devId, Project__c = registroId);
        } else if (tipo == 'Oportunidade') {
            insert new Opportunity_Developer__c(Desenvolvedor__c = devId, Oportunidade__c = registroId);
        }
    }
}
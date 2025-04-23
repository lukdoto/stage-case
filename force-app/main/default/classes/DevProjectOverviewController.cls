public with sharing class DevProjectOverviewController {
    public class ProjetoDTO {
        @AuraEnabled public String tipo;
        @AuraEnabled public String nomeProjeto;
        @AuraEnabled public String nomeOportunidade;
        @AuraEnabled public Date dataInicio;
        @AuraEnabled public Date dataFim;
        @AuraEnabled public Decimal valor;
        @AuraEnabled public Id recordId;
    }

    @AuraEnabled(cacheable=true)
    public static List<ProjetoDTO> getProjetosPorDesenvolvedor(Id developerId) {
        Map<Id, Project__c> projetosMap = new Map<Id, Project__c>();
        Set<Id> oportunidadesComProjeto = new Set<Id>();
        List<ProjetoDTO> resultado = new List<ProjetoDTO>();

        for (Project_Developer__c pd : [
            SELECT Project__r.Id, Project__r.Name, Project__r.Oportunidade__r.Name,
                   Project__r.Data_Inicio__c, Project__r.Data_Fim__c,
                   Project__r.Valor_Projeto__c, Project__r.Oportunidade__c
            FROM Project_Developer__c
            WHERE Developer__c = :developerId
        ]) {
            Project__c proj = pd.Project__r;
            if (proj != null && !projetosMap.containsKey(proj.Id)) {
                ProjetoDTO dto = new ProjetoDTO();
                dto.tipo = 'Projeto';
                dto.nomeProjeto = proj.Name;
                dto.nomeOportunidade = proj.Oportunidade__r != null ? proj.Oportunidade__r.Name : null;
                dto.dataInicio = proj.Data_Inicio__c;
                dto.dataFim = proj.Data_Fim__c;
                dto.valor = proj.Valor_Projeto__c;
                dto.recordId = proj.Id;
                resultado.add(dto);
                projetosMap.put(proj.Id, proj);
                if (proj.Oportunidade__c != null) {
                    oportunidadesComProjeto.add(proj.Oportunidade__c);
                }
            }
        }

        for (Opportunity_Developer__c od : [
            SELECT Oportunidade__r.Id, Oportunidade__r.Name,
                   Oportunidade__r.CloseDate, Oportunidade__r.Amount,
                   Oportunidade__r.StageName
            FROM Opportunity_Developer__c
            WHERE Desenvolvedor__c = :developerId
        ]) {
            if (!oportunidadesComProjeto.contains(od.Oportunidade__r.Id)) {
                ProjetoDTO dto = new ProjetoDTO();
                dto.tipo = 'Oportunidade';
                dto.nomeProjeto = null;
                dto.nomeOportunidade = od.Oportunidade__r.Name;
                dto.dataInicio = od.Oportunidade__r.CloseDate;
                dto.valor = od.Oportunidade__r.Amount;
                dto.recordId = od.Oportunidade__r.Id;
                resultado.add(dto);
            }
        }

        return resultado;
    }
}
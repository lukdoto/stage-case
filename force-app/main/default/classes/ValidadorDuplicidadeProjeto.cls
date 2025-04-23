public class ValidadorDuplicidadeProjeto {
    public static void validarDuplicidade(List<Opportunity_Developer__c> registros) {
        Set<Id> oportunidadeIds = new Set<Id>();
        Set<Id> desenvolvedorIds = new Set<Id>();
        
        for (Opportunity_Developer__c od : registros) {
            if (od.Oportunidade__c != null) {
                oportunidadeIds.add(od.Oportunidade__c);
            }
            if (od.Desenvolvedor__c != null) {
                desenvolvedorIds.add(od.Desenvolvedor__c);
            }
        }

        // Map de oportunidades para projetos
        Map<Id, Project__c> projetosPorOportunidade = new Map<Id, Project__c>(
            [SELECT Id, Oportunidade__c FROM Project__c WHERE Oportunidade__c IN :oportunidadeIds]
        );

        // Pegar todas as alocações existentes com o mesmo projeto e dev
        List<Opportunity_Developer__c> alocacoesExistentes = [
            SELECT Id, Oportunidade__c, Desenvolvedor__c
            FROM Opportunity_Developer__c
            WHERE Oportunidade__c IN :projetosPorOportunidade.keySet()
              AND Desenvolvedor__c IN :desenvolvedorIds
        ];

        Set<String> combinacoesExistentes = new Set<String>();
        for (Opportunity_Developer__c od : alocacoesExistentes) {
            combinacoesExistentes.add(od.Oportunidade__c + '-' + od.Desenvolvedor__c);
        }

        for (Opportunity_Developer__c novo : registros) {
            if (projetosPorOportunidade.containsKey(novo.Oportunidade__c)) {
                String chave = novo.Oportunidade__c + '-' + novo.Desenvolvedor__c;
                if (combinacoesExistentes.contains(chave)) {
                    novo.addError('❌ Este desenvolvedor já está alocado no projeto relacionado a esta oportunidade.');
                }
            }
        }
    }
}
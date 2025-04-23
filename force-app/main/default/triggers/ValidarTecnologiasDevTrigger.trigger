trigger ValidarTecnologiasDevTrigger on Opportunity_Developer__c (before insert, before update) {
    // Valida compatibilidade de tecnologias entre Desenvolvedor e Oportunidade
    ValidadorTecnologiaDev.validarTecnologia(Trigger.new);

    // Valida se o desenvolvedor já está alocado para o projeto relacionado
    ValidadorDuplicidadeProjeto.validarDuplicidade(Trigger.new);
}
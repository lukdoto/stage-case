@isTest
private class TestValidadorTecnologiaDev {

    @isTest
    static void testTecnologiaCompativel() {
        Developer__c dev = new Developer__c(Name = 'Dev Compatível', Tecnologia__c = 'Java;React');
        insert dev;

        Opportunity opp = new Opportunity(
            Name = 'Oportunidade Java React',
            StageName = 'Qualificação',
            CloseDate = Date.today(),
            Tecnologia__c = 'Java;React',
            Email_Cliente__c = 'cliente@teste.com'
        );
        insert opp;

        Opportunity_Developer__c aloc = new Opportunity_Developer__c(
            Desenvolvedor__c = dev.Id,
            Oportunidade__c = opp.Id
        );
        insert aloc;
    }

    @isTest
    static void testTecnologiaIncompativel() {
        Developer__c dev = new Developer__c(Name = 'Dev Incompatível', Tecnologia__c = 'Java');
        insert dev;

        Opportunity opp = new Opportunity(
            Name = 'Oportunidade Java React',
            StageName = 'Qualificação',
            CloseDate = Date.today(),
            Tecnologia__c = 'Java;React',
            Email_Cliente__c = 'cliente@teste.com'
        );
        insert opp;

        Opportunity_Developer__c aloc = new Opportunity_Developer__c(
            Desenvolvedor__c = dev.Id,
            Oportunidade__c = opp.Id
        );

        Test.startTest();
        try {
            insert aloc;
            System.assert(false, 'Erro esperado não foi lançado.');
        } catch (DmlException e) {
            System.debug('💥 Erro esperado: ' + e.getMessage());

            System.assert(
                e.getMessage().contains('React'),
                'A mensagem de erro deveria listar "React" como tecnologia faltante.'
            );
        }
        Test.stopTest();
    }
}
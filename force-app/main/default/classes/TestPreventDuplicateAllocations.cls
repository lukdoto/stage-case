@isTest
public class TestPreventDuplicateAllocations {

    @isTest
    static void testAlocacaoDuplicadaNaoPermitida() {
        // Criar um desenvolvedor
        Developer__c dev = new Developer__c(Name = 'Dev A', Tecnologia__c = 'Java;Apex');
        insert dev;

        // Criar uma oportunidade
        Opportunity opp = new Opportunity(
            Name = 'Oportunidade Teste',
            StageName = 'Qualificação',
            CloseDate = Date.today(),
            Tecnologia__c = 'Java;Apex',
            Email_Cliente__c = 'cliente@exemplo.com'
        );
        insert opp;

        // Criar uma alocação válida
        Opportunity_Developer__c aloc1 = new Opportunity_Developer__c(
            Desenvolvedor__c = dev.Id,
            Oportunidade__c = opp.Id
        );
        insert aloc1;

        // Tentar criar uma alocação duplicada (espera erro)
        Opportunity_Developer__c aloc2 = new Opportunity_Developer__c(
            Desenvolvedor__c = dev.Id,
            Oportunidade__c = opp.Id
        );

        Test.startTest();
        try {
            insert aloc2;
            System.assert(false, 'Deveria lançar erro de alocação duplicada.');
        } catch (DmlException e) {
            System.debug('⚠️ Erro esperado: ' + e.getMessage());
            System.assert(e.getMessage().contains('já está alocado'), 'Erro não detectado corretamente.');
        }
        Test.stopTest();
    }

    @isTest
    static void testAlocacaoDiferentePermitida() {
        // Criar dois desenvolvedores e duas oportunidades
        Developer__c dev1 = new Developer__c(Name = 'Dev 1', Tecnologia__c = 'React');
        Developer__c dev2 = new Developer__c(Name = 'Dev 2', Tecnologia__c = 'React');
        insert new List<Developer__c>{ dev1, dev2 };

        Opportunity opp1 = new Opportunity(
            Name = 'Opp 1',
            StageName = 'Qualificação',
            CloseDate = Date.today(),
            Tecnologia__c = 'React',
            Email_Cliente__c = 'cliente1@example.com'
        );
        Opportunity opp2 = new Opportunity(
            Name = 'Opp 2',
            StageName = 'Qualificação',
            CloseDate = Date.today(),
            Tecnologia__c = 'React',
            Email_Cliente__c = 'cliente2@example.com'
        );
        insert new List<Opportunity>{ opp1, opp2 };

        // Dev1 → Opp1 e Opp2 (válido)
        // Dev2 → Opp1 (válido)
        insert new List<Opportunity_Developer__c>{
            new Opportunity_Developer__c(Desenvolvedor__c = dev1.Id, Oportunidade__c = opp1.Id),
            new Opportunity_Developer__c(Desenvolvedor__c = dev1.Id, Oportunidade__c = opp2.Id),
            new Opportunity_Developer__c(Desenvolvedor__c = dev2.Id, Oportunidade__c = opp1.Id)
        };
    }
}
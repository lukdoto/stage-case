@isTest
public class LeadCnpjServiceTest {

    @isTest
    static void testCnpjValido() {
        Lead l = new Lead(
            LastName = 'Teste Válido',
            Company = 'Empresa LTDA',
            CNPJ__c = '27865757000102'
        );
        insert l;

        Test.startTest();
        new LeadCnpjService(new MockCnpjValidatorSuccess()).enrichLeadWithCnpj(l);
        Test.stopTest();

        System.assertEquals('Empresa Teste', l.Razao_Social__c);
        System.assertEquals('Teste LTDA', l.Nome_Fantasia__c);
    }

    @isTest
    static void testCnpjInvalido() {
        Lead l = new Lead(
            LastName = 'Teste Inválido',
            Company = 'Erro Ltda',
            CNPJ__c = '00000000000000'
        );
        insert l;

        Test.startTest();
        new LeadCnpjService(new MockCnpjValidatorFail()).enrichLeadWithCnpj(l);
        Test.stopTest();

        System.assertEquals(null, l.Razao_Social__c);
        System.assertEquals(null, l.Nome_Fantasia__c);
    }
}
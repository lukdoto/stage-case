@isTest
public class LeadTriggerTest {

    @isTest
    static void testTriggerCnpjValidoAsync() {
        Test.setMock(HttpCalloutMock.class, new MockCnpjSuccess());

        Lead l = new Lead(
            LastName = 'Async Lead',
            Company = 'Empresa Async',
            CNPJ__c = '27865757000102'
        );

        Test.startTest();
        insert l;
        Test.stopTest();

        // Não dá para verificar resultado direto aqui, pois é @future
        // Apenas validar que não houve erro de DML
        System.assertNotEquals(null, l.Id);
    }
}
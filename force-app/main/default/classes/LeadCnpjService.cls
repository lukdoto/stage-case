public class LeadCnpjService {

    private ICnpjValidator validator;

    public LeadCnpjService() {
        this.validator = new BrasilApiCnpjValidator();
    }

    // Construtor para testes
    public LeadCnpjService(ICnpjValidator customValidator) {
        this.validator = customValidator;
    }

    public void enrichLeadWithCnpj(Lead l) {
        if (String.isBlank(l.CNPJ__c)) return;

        if (!validator.isValid(l.CNPJ__c)) {
            System.debug('CNPJ inválido ou não encontrado na Receita Federal.');
            return;
        }

        Map<String, String> data = validator.getCompanyData(l.CNPJ__c);
        l.Razao_Social__c = data.get('Razao_Social__c');
        l.Nome_Fantasia__c = data.get('Nome_Fantasia__c');
    }

    @future(callout=true)
    public static void enrichLeadAsync(Id leadId) {
        Lead l = [SELECT Id, CNPJ__c FROM Lead WHERE Id = :leadId LIMIT 1];
        try {
            new LeadCnpjService().enrichLeadWithCnpj(l);
            update l;
        } catch (Exception e) {
            System.debug('Erro na execução do LeadCnpjService: ' + e.getMessage());
        }
    }
}
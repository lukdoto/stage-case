public with sharing class SendOpportunityEmailWithAttachment {

    @InvocableMethod(label='Enviar Email com Documentos da Oportunidade')
    public static void send(List<OpportunityRequest> requests) {
        for (OpportunityRequest req : requests) {
            Opportunity opp = [
                SELECT Id, Name, Email_Cliente__c, Doc_Proposta__c, Doc_NDA__c
                FROM Opportunity
                WHERE Id = :req.oppId
                LIMIT 1
            ];

            if (String.isBlank(opp.Email_Cliente__c)) {
                System.debug('Email do cliente está vazio. Abortando envio.');
                continue;
            }

            // Buscar todos os arquivos anexados à Opportunity
            List<ContentDocumentLink> docLinks = [
                SELECT ContentDocumentId, ContentDocument.Title
                FROM ContentDocumentLink
                WHERE LinkedEntityId = :opp.Id
            ];

            List<Messaging.EmailFileAttachment> attachments = new List<Messaging.EmailFileAttachment>();

            // Procurar documento da proposta
            String nomeProposta = opp.Doc_Proposta__c;
            String nomeNDA = opp.Doc_NDA__c;

            for (ContentDocumentLink link : docLinks) {
                String titulo = link.ContentDocument.Title;

                if (
                    (nomeProposta != null && titulo == nomeProposta) ||
                    (nomeNDA != null && titulo == nomeNDA)
                ) {
                    // Buscar versão mais recente do documento
                    List<ContentVersion> versoes = [
                        SELECT Id, Title, VersionData
                        FROM ContentVersion
                        WHERE ContentDocumentId = :link.ContentDocumentId
                        ORDER BY VersionNumber DESC
                        LIMIT 1
                    ];

                    if (!versoes.isEmpty()) {
                        ContentVersion versao = versoes[0];

                        Messaging.EmailFileAttachment anexo = new Messaging.EmailFileAttachment();
                        anexo.setFileName(versao.Title + '.pdf');
                        anexo.setBody(versao.VersionData);
                        anexo.setContentType('application/pdf');

                        attachments.add(anexo);
                    }
                }
            }

            if (attachments.isEmpty()) {
                System.debug('Nenhum arquivo correspondente encontrado. Nenhum e-mail será enviado.');
                continue;
            }

            Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
            email.setToAddresses(new String[] { opp.Email_Cliente__c });
            email.setSubject('Documentos para assinatura – Oportunidade ' + opp.Name);
            email.setPlainTextBody('Olá,\n\nSegue os documentos para assinatura referentes à oportunidade "' + opp.Name + '".\n\nAtenciosamente,\nEquipe Comercial');
            email.setFileAttachments(attachments);

            Messaging.SendEmailResult[] resultado = Messaging.sendEmail(new Messaging.SingleEmailMessage[] { email });

            if (!resultado[0].isSuccess()) {
                System.debug('Erro ao enviar o e-mail: ' + resultado[0].getErrors()[0].getMessage());
            }
        }
    }

    public class OpportunityRequest {
        @InvocableVariable(required=true)
        public Id oppId;
    }
}
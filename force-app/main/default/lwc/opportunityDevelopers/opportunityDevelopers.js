// opportunityDevelopers.js
import { LightningElement, api, track } from 'lwc';
import getDevelopersByOpportunity from '@salesforce/apex/OpportunityDevelopersController.getDevelopersByOpportunity';

export default class OpportunityDevelopers extends LightningElement {
    @api recordId;
    @track developers;
    @track error;

    columns = [
        { label: 'Nome', fieldName: 'Name' },
        { label: 'Tecnologias', fieldName: 'Tecnologia__c' },
        { label: 'Senioridade', fieldName: 'Senioridade__c' },
        { label: 'Disponível', fieldName: 'Disponivel__c', type: 'boolean' }
    ];

    connectedCallback() {
        if (this.recordId) {
            getDevelopersByOpportunity({ opportunityId: this.recordId })
                .then(result => {
                    this.developers = result;
                    this.error = undefined;
                })
                .catch(error => {
                    this.error = error.body.message;
                    this.developers = undefined;
                });
        }
    }
}
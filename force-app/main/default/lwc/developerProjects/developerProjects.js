import { LightningElement, api, track } from 'lwc';
import getDevelopersByProject from '@salesforce/apex/ProjectDevelopersController2.getDevelopersByProject';

export default class ProjectDevelopers extends LightningElement {
    @api recordId; // Esse será o ID do Project__c
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
            getDevelopersByProject({ projectId: this.recordId })
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
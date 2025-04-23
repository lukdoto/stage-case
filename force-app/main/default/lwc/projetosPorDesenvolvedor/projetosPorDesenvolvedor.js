import { LightningElement, track, wire } from 'lwc';
import getDesenvolvedores from '@salesforce/apex/ProjetosPorDevController.getDesenvolvedores';
import getProjetos from '@salesforce/apex/ProjetosPorDevController.getProjetos';
import { NavigationMixin } from 'lightning/navigation';

export default class ProjetosPorDesenvolvedor extends NavigationMixin(LightningElement) {
  @track developerOptions = [];
  @track selectedDev = '';
  @track projects = [];

  columns = [
    { label: 'Projeto', fieldName: 'Name' },
    { label: 'Data Início', fieldName: 'Data_Inicio__c', type: 'date' },
    { label: 'Data Fim', fieldName: 'Data_Fim__c', type: 'date' },
    { label: 'Valor', fieldName: 'Valor_Projeto__c', type: 'currency' },
    { label: 'Oportunidade', fieldName: 'Oportunidade__r.Name', type: 'text' },
    {
      type: 'button',
      typeAttributes: {
        label: 'Ver Projeto',
        name: 'verProjeto',
        title: 'Ver Projeto',
        variant: 'brand'
      }
    }
  ];

  connectedCallback() {
    getDesenvolvedores().then(result => {
      this.developerOptions = result.map(dev => ({
        label: dev.Name,
        value: dev.Id
      }));
    });
  }

  handleDeveloperChange(event) {
    this.selectedDev = event.detail.value;
    getProjetos({ devId: this.selectedDev }).then(result => {
      this.projects = result;
    });
  }

  handleRowAction(event) {
    const row = event.detail.row;
    this[NavigationMixin.Navigate]({
      type: 'standard__recordPage',
      attributes: {
        recordId: row.Id,
        objectApiName: 'Project__c',
        actionName: 'view'
      }
    });
  }
}
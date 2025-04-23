import { LightningElement, api, track } from 'lwc';
import getProjetosPorDesenvolvedor from '@salesforce/apex/DevProjectOverviewController.getProjetosPorDesenvolvedor';

export default class DevProjectOverview extends LightningElement {
    @api recordId;
    @track projetos = [];
    @track oportunidades = [];
    @track error;

    columnsProjeto = [
        { label: 'Projeto', fieldName: 'nomeProjeto' },
        { label: 'Oportunidade', fieldName: 'nomeOportunidade' },
        { label: 'Data Início', fieldName: 'dataInicio', type: 'date' },
        { label: 'Data Fim', fieldName: 'dataFim', type: 'date' },
        { label: 'Valor', fieldName: 'valor', type: 'currency' }
    ];

    columnsOportunidade = [
        { label: 'Oportunidade', fieldName: 'nomeOportunidade' },
        { label: 'Data Estimada de Fechamento', fieldName: 'dataInicio', type: 'date' },
        { label: 'Valor', fieldName: 'valor', type: 'currency' }
    ];

    connectedCallback() {
        if (this.recordId) {
            getProjetosPorDesenvolvedor({ developerId: this.recordId })
                .then(result => {
                    this.projetos = result.filter(item => item.tipo === 'Projeto');
                    this.oportunidades = result.filter(item => item.tipo === 'Oportunidade');
                })
                .catch(error => {
                    this.error = error;
                });
        }
    }
}
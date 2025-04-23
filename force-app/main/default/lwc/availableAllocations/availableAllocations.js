import { LightningElement, api, track } from 'lwc';
import getDisponiveis from '@salesforce/apex/AvailableAllocationsController.getDisponiveis';
import alocar from '@salesforce/apex/AvailableAllocationsController.alocar';

export default class AvailableAllocations extends LightningElement {
    @api recordId;
    @track itens = [];

    columns = [
        { label: 'Tipo', fieldName: 'tipo' },
        { label: 'Nome', fieldName: 'nome' },
        { label: 'Tecnologias Requeridas', fieldName: 'tecnologia' },
        { label: 'Data Início / Fechamento', fieldName: 'dataInicio', type: 'date' },
        { label: 'Data Fim', fieldName: 'dataFim', type: 'date' },
        { label: 'Valor', fieldName: 'valor', type: 'currency' },
        {
            type: 'action',
            typeAttributes: {
                rowActions: [
                    { label: 'Alocar', name: 'alocar' }
                ]
            }
        }
    ];

    connectedCallback() {
        this.loadData();
    }

    loadData() {
        getDisponiveis({ devId: this.recordId })
            .then(result => {
                this.itens = result;
            })
            .catch(error => {
                console.error('Erro ao carregar dados', error);
            });
    }

    handleRowAction(event) {
        const action = event.detail.action.name;
        const row = event.detail.row;

        if (action === 'alocar') {
            alocar({ devId: this.recordId, tipo: row.tipo, registroId: row.id })
                .then(() => {
                    this.loadData();
                })
                .catch(error => {
                    console.error('Erro ao alocar', error);
                });
        }
    }
}
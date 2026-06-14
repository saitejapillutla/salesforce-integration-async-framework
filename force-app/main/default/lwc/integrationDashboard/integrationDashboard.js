import { LightningElement, wire } from 'lwc';
import getOrders from '@salesforce/apex/IntegrationDashboardController.getOrders';

const COLUMNS = [
{ label: 'Order', fieldName: 'Order_Number__c' },
{ label: 'Status', fieldName: 'Status__c' },
{ label: 'Retries', fieldName: 'Retry_Count__c' },
{ label: 'Last Error', fieldName: 'Last_Error__c' },
{ label: 'Created', fieldName: 'CreatedDate', type: 'date' }
];

export default class IntegrationDashboard extends LightningElement {


columns = COLUMNS;
orders = [];

@wire(getOrders)
wiredOrders({ data, error }) {

    if (data) {
        this.orders = data;
    } else if (error) {
        console.error(error);
    }
}


}
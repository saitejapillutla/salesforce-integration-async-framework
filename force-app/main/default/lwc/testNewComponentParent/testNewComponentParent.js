// testManDatatable.js
import { LightningElement, wire } from 'lwc';
import { getObjectInfo } from 'lightning/uiObjectInfoApi';
import { getListUi } from 'lightning/uiListApi';
import TEST_MAN_OBJECT from '@salesforce/schema/Report';
import { CurrentPageReference } from 'lightning/navigation';


import CONTACT_OBJECT from '@salesforce/schema/Contact';
import NAME_FIELD from '@salesforce/schema/Contact.Name';

const columns = [
    { label: 'Name', fieldName: 'Name', type: 'text' },
    { label: 'Field1', fieldName: 'CreatedDate', type: 'Date' },
    { label: 'Field2', fieldName: 'STATUS__c', type: 'text' },
    // Add more columns as needed
];

export default class TestNewComponentParent extends LightningElement {
    testManRecords;
    columns = columns;
    urlId = null;
    urlLanguage = null;
    urlType = null;

    // @wire(CurrentPageReference)
    // getStateParameters(currentPageReference) {
    //     if (currentPageReference) {
    //         this.urlId = currentPageReference.state?.id;
    //         this.urlLanguage = currentPageReference.state?.lang;
    //         this.urlType = currentPageReference.state?.type;
    //     }
    // }

    // @wire(getObjectInfo, { objectApiName: TEST_MAN_OBJECT })
    // objectInfo;

    testManRecords = [];
    @wire(getListUi, { objectApiName: TEST_MAN_OBJECT  })
    wiredTestManRecords({ error, data }) {
        
            console.log(' starts >>>>>');

        if (data) {
            console.log('Log starts >>>>>');
            console.log( JSON.stringify( data));


            this.testManRecords = data.records.records;
             
            this.testManRecords.
            console.log(' >>>>>> Loggd');


            console.log(data.records);
            // const records = data.map(record => {
            //     const fields = record.fields;
            //     return {
            //         Id: fields.Id.value,
            //         Name: fields.Name.value,
            //         CreatedDate: fields.CreatedDate.value,
            //         STATUS__c: fields.STATUS__c.value
            //         // Add more fields as needed
            //     };
            // });

            // console.log(records);
            // this.testManRecords = records;
        } else if (error) {
            // Handle error

            
            console.log('ERRO R'+ error);
        }
    }
}
import { LightningElement, track } from 'lwc';
import getBooksByTag from '@salesforce/apex/BookController.getBooksByTag';
import getBooks from '@salesforce/apex/BookController.getBooks';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

const columns = [
    { label: 'Book', fieldName: 'Name' },
    { label: 'Author', fieldName: 'Author__c'},
    { label: 'Summary', fieldName: 'Summary__c'},
    { label: 'ISBN', fieldName: 'ISBN__c'},
    
];




export default class SmartSearch extends LightningElement {

  @track inputValue;
  @track showDataTable = false;
  @track data =[];
  @track columns = columns;


  connectedCallback() {
    //   if(this.inputValue != null) {
    //       this.showResult = true;
    //   }
  }



   handleChange(event) {
       this.inputValue = event.target.value;
   }

   // eslint-disable-next-line no-unused-vars
   handleSearchByTag(event) {

       getBooksByTag({keyword: this.inputValue})
       .then(result => {
          
           this.data = [];
           this.data = result;
           
           if(result.length === 0) {
            this.showError(); 
           }else{
             this.showDataTable = true;
           }

       })
       .catch(error => {
           // eslint-disable-next-line no-console
           console.log(error);
       })
   }

   // eslint-disable-next-line no-unused-vars
   handleSearchByBook(event) {
     getBooks({keyword: this.inputValue}).
     then(result => {
         this.data = [];
        this.data = result;
        if(result.length === 0) {
            this.showError(); 
           }else{
             this.showDataTable = true;
           }
     })
     .catch(error => {
         // eslint-disable-next-line no-console
         console.log(error);
     })
   }

   showError() {
        
        this.dispatchEvent(new ShowToastEvent({
        title: 'No Result',
        message: 'Nothing Found!',
        variant: 'error',
        mode: 'dismissable'
       }));
   
    }
}
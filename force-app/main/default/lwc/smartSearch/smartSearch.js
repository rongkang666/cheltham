import { LightningElement, track } from 'lwc';
import getBooksByTag from '@salesforce/apex/BookController.getBooksByTag';
import getBooks from '@salesforce/apex/BookController.getBooks';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { NavigationMixin } from 'lightning/navigation';

//datatable configuration
const actions = [
    { label: 'View', name: 'show_details' },
];
const columns = [
    {
        type: 'action',
        typeAttributes: {
            rowActions: actions,
            menuAlignment: 'right'
    }
    },
    { label: 'Book', fieldName: 'Name' },
    { label: 'Author', fieldName: 'Author__c'},
    { label: 'Summary', fieldName: 'Summary__c'},
    { label: 'ISBN', fieldName: 'ISBN__c'},
    
];

export default class SmartSearch extends NavigationMixin(LightningElement) {

  @track inputValue; //input value from client input
  @track showDataTable = false; //flag to show datatable
  @track data =[]; //initialize datatable data
  @track columns = columns; //initialize datatable columns

  //lightning button title
  searchByTagBtnTitle = 'Seach via book tag';
  searchByBookBtnTitle = 'Search via book name, or book author, or ISBN number';


   //pass input value from html
   handleChange(event) {
       this.inputValue = event.target.value;
   }

   //event handler that call click event
   // eslint-disable-next-line no-unused-vars
   handleSearchByTag(event) {

    this.showDataTable = false; 
        
       //call apex method to retrive book data based on tag
       getBooksByTag({keyword: this.inputValue})
       .then(result => {
          
           this.data = [];
           this.data = result;
           
           //check if returned book list has value
           if(result.length === 0) {
            //show user notification if no book is returned
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

   //event handler that call click event
   // eslint-disable-next-line no-unused-vars
   handleSearchByBook(event) {
    this.showDataTable = false;

     //call apex method to retrive book data based on 
     //book name, or book author, or book ISBN number   
     getBooks({keyword: this.inputValue}).
     then(result => {
        this.data = [];
        this.data = result;
        //check if returned book list has value
        if(result.length === 0) {
            this.showError(); 
           }else{
            //show user notification if no book is returned
            this.showDataTable = true;
           }
     })
     .catch(error => {
         // eslint-disable-next-line no-console
         console.log(error);
     })
   }

   //navigation function that redirect to object record page
   navigateToRecordViewPage(event) {

    this[NavigationMixin.Navigate]({
        type: 'standard__recordPage',
        attributes: {
            recordId: event.detail.row.Id,
            //objectApiName: 'Lead', // objectApiName is optional
            actionName: 'view'
        }
    });

   }

   //toast funciton that show error message when no results are found 
   //in book smart search
   showError() {
        
        this.dispatchEvent(new ShowToastEvent({
        title: 'No Result',
        message: 'Nothing Found!',
        variant: 'error',
        mode: 'dismissable'
       }));
   
    }
}
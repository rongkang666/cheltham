import { LightningElement, track } from 'lwc';

const columns = [
    { label: 'Name', fieldName: 'name' },
    { label: 'Author', fieldName: 'author'},
    { label: 'Edition', fieldName: 'edition'},
    { label: 'Summary', fieldName: 'summary'},
    { label: 'Tag', fieldName: 'tag'},
];


export default class SmartSearch extends LightningElement {

  @track inputValue;
  @track data =[];
  @track columns = columns;
  @track showResult = false;

  connectedCallback() {
      if(this.inputValue != null) {
          this.showResult = true;
      }
  }



   handleChange(event) {
       this.inputValue = event.target.value;
       // eslint-disable-next-line no-console
       console.log(this.inputValue);
   }

}
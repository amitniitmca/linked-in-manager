/**
 * @description       : LinkedInManagerType LWC is used to specify the LinkedIn Manager Type
 * @author            : Amit Kumar [amitniitmca@gmail.com]
 * @last modified on  : 19-03-2022
 * @last modified by  : Amit Kumar [amitniitmca@gmail.com]
 * Modifications Log
 * Ver   Date         Author                               Modification
 * 1.0   02-03-2022   Amit Kumar [amitniitmca@gmail.com]   Initial Version
**/
import { LightningElement, track } from 'lwc';
import storeManagerTypeValue from '@salesforce/apex/LinkedInManagerTypeController.storeManagerTypeValue';

const OPTIONS = [
    {label: '---SELECT TYPE---', value: '---SELECT---'},
    {label: 'Company Page Manager', value: 'ORG'},
    {label: 'Individual Profile Manager', value: 'USER'}
];
export default class LinkedInManagerType extends LightningElement {
    
    @track linkedInManagerTypeOptions = OPTIONS;
    @track linkedInManagerTypeValue='---SELECT---';
    // @api showPanel;

    handleLinkedInManagerTypeChange(event){
        this.linkedInManagerTypeValue = event.target.value;
    }

    handleSubmitClick(event){
        if(this.linkedInManagerTypeValue === '---SELECT---'){
            this.showMessage('error', 'Manager Type Required', 'Please choose a LinkedIn Manager Type before Submitting!');
        }
        else{
            storeManagerTypeValue({value : this.linkedInManagerTypeValue})
            .then(result=>{
                this.showMessage('success', 'Successful', "LinkedIn Manager Type Stored Successfully!");
                this.dispatchEvent(new CustomEvent('stored'));
            })
            .catch(error=>{
                this.showMessage('error', "Unable to Store", "LinkedIn Manager Type can't be Stored!");
            });
        }
    }

    showMessage(type, title, message){
        const toast = this.template.querySelector('c-custom-toast');
        switch (type) {
            case 'success':
                toast.showSuccessMessage(title, message);
                break;
            case 'error':
                toast.showErrorMessage(title, message);
                break;
            case 'warning':
                toast.showWarningMessage(title, message);
                break;
            case 'info':
                toast.showInfoMessage(title, message);
                break;
        }
    }

}
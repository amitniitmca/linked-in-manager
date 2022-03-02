/**
 * @description       : LinkedInManagerType LWC is used to specify the LinkedIn Manager Type
 * @author            : Amit Kumar [amitniitmca@gmail.com]
 * @last modified on  : 02-03-2022
 * @last modified by  : Amit Kumar [amitniitmca@gmail.com]
 * Modifications Log
 * Ver   Date         Author                               Modification
 * 1.0   02-03-2022   Amit Kumar [amitniitmca@gmail.com]   Initial Version
**/
import { LightningElement, wire } from 'lwc';
import isLinkedInManagerTypeSaved from '@salesforce/apex/LinkedInManagerTypeController.isLinkedInManagerTypeSaved';
import storeManagerTypeValue from '@salesforce/apex/LinkedInManagerTypeController.storeManagerTypeValue';
import isCurrentUserAdmin from '@salesforce/apex/LinkedInManagerTypeController.isCurrentUserAdmin';
import {refreshApex} from '@salesforce/apex';

const OPTIONS = [
    {label: '---SELECT TYPE---', value: '---SELECT---'},
    {label: 'Company Page Manager', value: 'ORG'},
    {label: 'Individual Profile Manager', value: 'USER'}
];

export default class LinkedInManagerType extends LightningElement {

    linkedInManagerTypeOptions = OPTIONS;
    linkedInManagerTypeValue='---SELECT---';

    showLinkedInManagerType=true;
    isAdmin=true;
    
    wiredIsLinkedInManagerTypeSavedResult;
    @wire(isLinkedInManagerTypeSaved)
    wiredIsLinkedInManagerTypeSaved(result){
        this.wiredIsLinkedInManagerTypeSavedResult = result;
        const {data, error} = result;
        if(data){
            this.showLinkedInManagerType = !data;
        }
        if(error){
            this.showMessage('error','error',error);
        }
    }

    @wire(isCurrentUserAdmin)
    wiredIsCurrentUserAdmin(data, error){
        if(data){
            this.isAdmin = data.data;
        }
        if(error){
            this.showMessage('error','error',error);
        }
    }


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
                refreshApex(this.wiredIsLinkedInManagerTypeSavedResult);
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
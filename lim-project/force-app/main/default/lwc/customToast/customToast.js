/**
 * @description       : 
 * @author            : Amit Kumar [amitniitmca@gmail.com]
 * @group             : 
 * @last modified on  : 02-03-2022
 * @last modified by  : Amit Kumar [amitniitmca@gmail.com]
 * Modifications Log
 * Ver   Date         Author                               Modification
 * 1.0   02-03-2022   Amit Kumar [amitniitmca@gmail.com]   Initial Version
**/
import { LightningElement, api } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

export default class CustomToast extends LightningElement {
    
    @api showSuccessMessage(title, message){
        const event = new ShowToastEvent({
            title: title,
            message: message,
            variant: 'success',
            mode: 'dismissible' 
        });
        this.dispatchEvent(event);
    }

    @api showErrorMessage(title, message){
        const event = new ShowToastEvent({
            title: title,
            message: message,
            variant: 'error',
            mode: 'dismissible' 
        });
        this.dispatchEvent(event);
    }

    @api showWarningMessage(title, message){
        const event = new ShowToastEvent({
            title: title,
            message: message,
            variant: 'warning',
            mode: 'dismissible' 
        });
        this.dispatchEvent(event);
    }

    @api showInfoMessage(title, message){
        const event = new ShowToastEvent({
            title: title,
            message: message,
            variant: 'info',
            mode: 'dismissible' 
        });
        this.dispatchEvent(event);
    }
}
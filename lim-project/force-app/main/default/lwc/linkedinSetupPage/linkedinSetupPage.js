/**
 * @description       : 
 * @author            : Amit Kumar [amitniitmca@gmail.com]
 * @group             : 
 * @last modified on  : 19-03-2022
 * @last modified by  : Amit Kumar [amitniitmca@gmail.com]
 * Modifications Log
 * Ver   Date         Author                               Modification
 * 1.0   02-03-2022   Amit Kumar [amitniitmca@gmail.com]   Initial Version
**/
import { LightningElement, wire, track } from 'lwc';
import { loadStyle } from 'lightning/platformResourceLoader';
import {refreshApex} from '@salesforce/apex';
import LI_Resource from '@salesforce/resourceUrl/LI_Resource';
import isLinkedInManagerTypeSaved from '@salesforce/apex/LinkedInSetupPageController.isLinkedInManagerTypeSaved';
import isCurrentUserAdmin from '@salesforce/apex/LinkedInSetupPageController.isCurrentUserAdmin';


export default class LinkedinSetupPage extends LightningElement {

    @track showLinkedInManagerType=true;
    @track isAdmin=true;
    
    wiredIsLinkedInManagerTypeSavedResult;
    @wire(isLinkedInManagerTypeSaved)
    wiredIsLinkedInManagerTypeSaved(result){
        this.wiredIsLinkedInManagerTypeSavedResult = result;
        const {data, error} = result;
        console.log(JSON.stringify(result));
        if(data){
            this.showLinkedInManagerType = !data;
            console.log(this.showLinkedInManagerType);
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

    resourceLoaded=false;
    renderedCallback(){
        if(this.resourceLoaded === false){
            loadStyle(this, LI_Resource+'/style.css');
            loadStyle(this, LI_Resource+'/NoHeader.css');
            this.resourceLoaded = true;
        }
    }

    handledManagerTypeStored(){
        refreshApex(this.wiredIsLinkedInManagerTypeSavedResult);
    }

}
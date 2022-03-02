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
import { LightningElement } from 'lwc';
import LI_Resource from '@salesforce/resourceUrl/LI_Resource';
import { loadStyle } from 'lightning/platformResourceLoader';

export default class LinkedinSetupPage extends LightningElement {

    resourceLoaded=false;

    renderedCallback(){
        if(this.resourceLoaded === false){
            loadStyle(this, LI_Resource+'/style.css');
            loadStyle(this, LI_Resource+'/NoHeader.css');
            this.resourceLoaded = true;
        }
    }

}
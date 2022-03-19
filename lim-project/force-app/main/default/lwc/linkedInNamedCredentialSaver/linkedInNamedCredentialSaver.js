/**
 * @description       : 
 * @author            : Amit Kumar [amitniitmca@gmail.com]
 * @group             : 
 * @last modified on  : 19-03-2022
 * @last modified by  : Amit Kumar [amitniitmca@gmail.com]
 * Modifications Log
 * Ver   Date         Author                               Modification
 * 1.0   19-03-2022   Amit Kumar [amitniitmca@gmail.com]   Initial Version
**/
import { LightningElement, track, wire, api } from 'lwc';
import getAvailableNamedCredentials from '@salesforce/apex/LinkedInNamedCredentialSaverController.getAvailableNamedCredentials';
import isNamedCredentialForUserSaved from '@salesforce/apex/LinkedInNamedCredentialSaverController.isNamedCredentialForUserSaved';

const HEADING_TEXT = "Use the following links if you haven't created any Auth. Provider and Named Credential yet.";

export default class LinkedInNamedCredentialSaver extends LightningElement {

    @track headingText = HEADING_TEXT;

    @wire(getAvailableNamedCredentials)
    wiredGetAvailableNamedCredentials(result){
        const{data, error} = result;
        if(data){
            console.log(JSON.stringify(data));
        }
        if(error){
            console.log(error);
        }
    }

    @wire(isNamedCredentialForUserSaved)
    wiredIsNamedCredentialForUserSaved(result){
        const{data, error} = result;
        if(data){
            console.log(data);
        }
        if(error){
            console.log(error);
        }
    }

}
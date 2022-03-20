/**
 * @description       : 
 * @author            : Amit Kumar [amitniitmca@gmail.com]
 * @group             : 
 * @last modified on  : 20-03-2022
 * @last modified by  : Amit Kumar [amitniitmca@gmail.com]
 * Modifications Log
 * Ver   Date         Author                               Modification
 * 1.0   19-03-2022   Amit Kumar [amitniitmca@gmail.com]   Initial Version
**/
import { LightningElement, track, wire, api } from 'lwc';
import {refreshApex} from '@salesforce/apex';
import getAvailableNamedCredentials from '@salesforce/apex/LinkedInNamedCredentialSaverController.getAvailableNamedCredentials';
import isNamedCredentialForUserSaved from '@salesforce/apex/LinkedInNamedCredentialSaverController.isNamedCredentialForUserSaved';
import storeNamedCredential from '@salesforce/apex/LinkedInNamedCredentialSaverController.storeNamedCredential';

const HEADING_TEXT = "Use the following links if you haven't created any Auth. Provider and Named Credential yet.";
const NC_UNAVAILABLE_TEXT = "No Named Credential is available to store!";

export default class LinkedInNamedCredentialSaver extends LightningElement {

    @track headingText = HEADING_TEXT;
    @track ncUnavailableText = NC_UNAVAILABLE_TEXT;
    @track ncOptions = [];
    @track selectedNC = undefined;
    @track ncAvailable = false;
    @track ncSaved;
    @track isViewable=false;

    @api adminUser;
    @api managerTypeUser;

    wiredIsNamedCredentialForUserSavedResult;
    @wire(getAvailableNamedCredentials)
    wiredGetAvailableNamedCredentials(result) {
        const { data, error } = result;
        if (data) {
            console.log(JSON.stringify(data));
            for (const det of data) {
                this.ncOptions = [...this.ncOptions, { label: det, value: det }];
            }
            if (this.ncOptions.length > 0) {
                this.ncOptions.unshift({ label: "---SELECT NC---", value: "---SELECT---" });
                this.ncAvailable = true;
                this.selectedNC = "---SELECT---";
            }

        }
        if (error) {
            console.log(error);
        }
    }

    @wire(isNamedCredentialForUserSaved)
    wiredIsNamedCredentialForUserSaved(result) {
        this.wiredIsNamedCredentialForUserSavedResult = result;
        const { data, error } = result;
        if (data) {
            this.ncSaved = data;
        }
        if (error) {
            console.log(error);
        }
    }

    connectedCallback(){
        if(this.adminUser === true && (this.managerTypeUser === "ORG" || this.managerTypeUser === "USER")){
            this.isViewable = true;
        }
        else if(this.adminUser === false && this.managerTypeUser === "USER"){
            this.isViewable = true;
        }
        else{
            this.isViewable = false;
        }
    }

    handleNcChange(event){
        this.selectedNC = event.detail.value;
    }

    handleSubmitClick(){
        if(this.selectedNC === "---SELECT---"){
            this.showMessage('error','Error', "Please choose a Named Credential before clicking on Submit!");
        }
        else{
            storeNamedCredential({value : this.selectedNC, isAdmin : this.isAdmin})
            .then(result=>{
                this.showMessage("success","Success","Named Credential stored successfully!");
                refreshApex(this.wiredIsNamedCredentialForUserSavedResult);
            })
            .catch(error=>{
                console.log(error);
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
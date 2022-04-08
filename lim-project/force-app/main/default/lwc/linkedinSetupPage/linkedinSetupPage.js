/**
 * @description       : 
 * @author            : Amit Kumar [amitniitmca@gmail.com]
 * @group             : 
 * @last modified on  : 29-03-2022
 * @last modified by  : Amit Kumar [amitniitmca@gmail.com]
 * Modifications Log
 * Ver   Date         Author                               Modification
 * 1.0   02-03-2022   Amit Kumar [amitniitmca@gmail.com]   Initial Version
**/
import { LightningElement, wire, track } from 'lwc';
import { loadStyle } from 'lightning/platformResourceLoader';
import { refreshApex } from '@salesforce/apex';
import { publish, MessageContext } from 'lightning/messageService';
import connectionChannel from '@salesforce/messageChannel/connectionChannel__c';
import LI_Resource from '@salesforce/resourceUrl/LI_Resource';
import isLinkedInManagerTypeSaved from '@salesforce/apex/LinkedInSetupPageController.isLinkedInManagerTypeSaved';
import isCurrentUserAdmin from '@salesforce/apex/LinkedInSetupPageController.isCurrentUserAdmin';
import getStoredManagerType from '@salesforce/apex/LinkedInSetupPageController.getStoredManagerType';
import storeManagerTypeValue from '@salesforce/apex/LinkedInSetupPageController.storeManagerTypeValue';
import getAvailableNamedCredentials from '@salesforce/apex/LinkedInSetupPageController.getAvailableNamedCredentials';
import isNamedCredentialForUserSaved from '@salesforce/apex/LinkedInSetupPageController.isNamedCredentialForUserSaved';
import storeNamedCredential from '@salesforce/apex/LinkedInSetupPageController.storeNamedCredential';
import isConnected from '@salesforce/apex/LinkedInSetupPageController.isConnected';

const HEADING_TEXT = "Use the following links if you haven't created any Auth. Provider and Named Credential yet.";
const NC_UNAVAILABLE_TEXT = "No Named Credential is available to store!";

const OPTIONS = [
    { label: '---SELECT TYPE---', value: '---SELECT---' },
    { label: 'Company Page Manager', value: 'ORG' },
    { label: 'Individual Profile Manager', value: 'USER' }
];
export default class LinkedinSetupPage extends LightningElement {

    @track linkedInManagerTypeOptions = OPTIONS;
    @track linkedInManagerTypeValue = '---SELECT---';

    @track showLinkedInManagerType = true;
    @track isAdmin = false;
    @track managerType;

    @track headingText = HEADING_TEXT;
    @track ncUnavailableText = NC_UNAVAILABLE_TEXT;
    @track ncOptions = [];
    @track selectedNC = undefined;
    @track ncAvailable = false;
    @track ncSaved;
    @track isViewable = true;

    @track connectionStatus;
    @track connectionStatusClass = "slds-var-p-around_medium";

    @wire(MessageContext)
    messageContext;

    @wire(isLinkedInManagerTypeSaved)
    wiredIsLinkedInManagerTypeSaved(result) {
        this.wiredIsLinkedInManagerTypeSavedResult = result;
        const { data, error } = result;
        if (data) {
            this.showLinkedInManagerType = !data;
            console.log('showLinkedInManagerType => ' + this.showLinkedInManagerType);
            this.checkForViewable();
        }
        if (error) {
            this.showMessage('error', 'error', error);
        }
    }

    @wire(isCurrentUserAdmin)
    wiredIsCurrentUserAdmin(data, error) {
        if (data) {
            this.isAdmin = data.data;
            console.log('isAdmin => ' + this.isAdmin);
            this.checkForViewable();
        }
        if (error) {
            this.showMessage('error', 'error', error);
        }
    }

    @wire(getStoredManagerType)
    wiredGetStoredManagerType(result) {
        this.wiredGetStoredManagerTypeResult = result;
        const { data, error } = result;
        if (data) {
            this.managerType = data;
            console.log('managerType => ' + this.managerType);
            this.checkForViewable();
        }
        if (error) {
            console.log(error);
        }
    }

    @wire(getAvailableNamedCredentials)
    wiredGetAvailableNamedCredentials(result) {
        const { data, error } = result;
        if (data) {
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
            console.log('ncSaved => ' + this.ncSaved);
        }
        if (error) {
            console.log(error);
        }
    }

    connectedCallback() {
        loadStyle(this, LI_Resource + '/style.css');
        loadStyle(this, LI_Resource + '/NoHeader.css');
    }

    checkForViewable() {
        if (this.isAdmin === true && (this.managerType === "ORG" || this.managerType === "USER")) {
            this.isViewable = true;
        }
        else if (this.isAdmin === false && this.managerType === "USER") {
            this.isViewable = true;
        }
        else {
            this.isViewable = false;
        }
        console.log('check for viewable : ' + this.isViewable);
    }

    handleLinkedInManagerTypeChange(event) {
        this.linkedInManagerTypeValue = event.target.value;
    }

    handleSubmitClick(event) {
        const targetButton = event.target.name;
        if (targetButton === "managerTypeSubmit") {
            if (this.linkedInManagerTypeValue === '---SELECT---') {
                this.showMessage('error', 'Manager Type Required', 'Please choose a LinkedIn Manager Type before Submitting!');
            }
            else {
                storeManagerTypeValue({ value: this.linkedInManagerTypeValue })
                    .then(result => {
                        this.showMessage('success', 'Successful', "LinkedIn Manager Type Stored Successfully!");
                        refreshApex(this.wiredIsLinkedInManagerTypeSavedResult);
                        refreshApex(this.wiredGetStoredManagerTypeResult);

                    })
                    .catch(error => {
                        this.showMessage('error', "Unable to Store", "LinkedIn Manager Type can't be Stored!");
                    });
            }
        }
        else {
            if (this.selectedNC === "---SELECT---") {
                this.showMessage('error', 'Error', "Please choose a Named Credential before clicking on Submit!");
            }
            else {
                storeNamedCredential({ value: this.selectedNC, managerTypeUser: this.managerTypeUser })
                    .then(result => {
                        this.showMessage("success", "Success", "Named Credential stored successfully!");
                        refreshApex(this.wiredIsNamedCredentialForUserSavedResult);
                    })
                    .catch(error => {
                        console.log(error);
                    });
            }
        }
    }

    handleNcChange(event) {
        this.selectedNC = event.detail.value;
    }

    showMessage(type, title, message) {
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

    handleTestConnectionClick() {
        isConnected()
            .then(result => {
                if (result === true) {
                    this.connectionStatus = "Connected";
                    this.connectionStatusClass = "slds-var-p-around_medium connection-status-connected"
                    const connectionLoad = { isConnected: true };
                    publish(this.messageContext, connectionChannel, connectionLoad);
                    localStorage.setItem('connected', 'true');
                }
                else {
                    this.connectionStatus = "Not Connected";
                    this.connectionStatusClass = "slds-var-p-around_medium connection-status-not-connected";
                    localStorage.setItem('connected', 'false');
                    const connectionLoad = { isConnected: false };
                    publish(this.messageContext, connectionChannel, connectionLoad);
                }
            })
            .catch(error => {
                console.log(error);
                const connectionLoad = { isConnected: false };
                publish(this.messageContext, connectionChannel, connectionLoad);
            });
    }

    renderedCallback(){
        if(localStorage.getItem('connected')){
            if(localStorage.getItem('connected') === 'true'){
                this.connectionStatus = "Connected";
                this.connectionStatusClass = "slds-var-p-around_medium connection-status-connected"
            }
            else{
                this.connectionStatus = "Not Connected";
                this.connectionStatusClass = "slds-var-p-around_medium connection-status-not-connected";
            }
        }
    }
}
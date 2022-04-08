/**
 * @description       : 
 * @author            : Amit Kumar [amitniitmca@gmail.com]
 * @last modified on  : 04-04-2022
 * @last modified by  : Amit Kumar [amitniitmca@gmail.com]
 * Modifications Log
 * Ver   Date         Author                               Modification
 * 1.0   29-03-2022   Amit Kumar [amitniitmca@gmail.com]   Initial Version
**/
import { LightningElement, wire, track } from 'lwc';
import { subscribe, unsubscribe, APPLICATION_SCOPE, MessageContext } from 'lightning/messageService';
import { refreshApex } from '@salesforce/apex';
import connectionChannel from '@salesforce/messageChannel/connectionChannel__c';
import getCurrentBasicInfo from '@salesforce/apex/LinkedInProfilePictureController.getCurrentBasicInfo';
import getProfilePictureInfo from '@salesforce/apex/LinkedInProfilePictureController.getProfilePictureInfo';
import storeCompanyId from '@salesforce/apex/LinkedInProfilePictureController.storeCompanyId';
import isCompanyIdStored from '@salesforce/apex/LinkedInProfilePictureController.isCompanyIdStored';
import getStoredCompanyId from '@salesforce/apex/LinkedInProfilePictureController.getStoredCompanyId';

export default class LinkedinProfilePicture extends LightningElement {
    @track subscription = null;
    @track isConnected = false;
    @track userName;
    @track profilePictureUrl;
    @track companyId;
    @track storedCompanyId;
    @track wiredIsCompanyIdStoredResult;
    @track customToast;

    @wire(MessageContext)
    messageContext;

    @wire(isCompanyIdStored)
    wiredIsCompanyIdStored(result) {
        this.wiredIsCompanyIdStoredResult = result;
        const { data, error } = result;
        if (data) {
            if (data === true) {
                console.log('company id stored');
                getStoredCompanyId()
                    .then(res => {
                        this.storedCompanyId = res;
                    })
                    .catch(err => {
                        console.log(err);
                        this.storedCompanyId = undefined;
                        this.customToast.showErrorMessage("Error", err.body.message + ", Please contact Administrator!");
                    });
            }
            else {
                this.customToast.showErrorMessage("Error", "Company Id not stored, Please contact Administrator!");
            }
        }
        if (error) {
            this.customToast.showErrorMessage("Error", error.body.message + ", Please contact Administrator!");
        }
    }

    renderedCallback() {
        this.subscribeMC();
        this.customToast = this.template.querySelector("c-custom-toast");
        if(localStorage.getItem('connected') && localStorage.getItem('connected') === 'true'){
            this.getBasicInfo();
        }
    }

    subscribeMC() {
        if (!this.subscription) {
            this.subscription = subscribe(
                this.messageContext,
                connectionChannel,
                (message) => this.handleMessage(message),
                { scope: APPLICATION_SCOPE }
            );
        }
    }

    handleMessage(message) {
        this.isConnected = message.isConnected;
        if (this.isConnected === true) {
            this.getBasicInfo();
        }
    }

    getBasicInfo() {
        getCurrentBasicInfo()
            .then(res1 => {
                this.userName = res1.localizedFirstName + " " + res1.localizedLastName;
                localStorage.setItem('userId', res1.id);
                getProfilePictureInfo()
                    .then(res2 => {
                        this.setProfilePictureUrl(JSON.parse(res2));
                    })
                    .catch(err2 => {
                        this.customToast.showErrorMessage("Error", err2.body.message + ", Please contact Administrator!");
                    });
            })
            .catch(err1 => {
                this.customToast.showErrorMessage("Error", err1.body.message + ", Please contact Administrator!");
            });
    }

    setProfilePictureUrl(result) {
        for (const ele of result.profilePicture['displayImage~'].elements) {
            const size = ele.data['com.linkedin.digitalmedia.mediaartifact.StillImage'].displaySize.width;
            if (size === 800) {
                this.profilePictureUrl = ele.identifiers[0].identifier;
            }
        }
    }

    handleCompanyChange(event) {
        this.companyId = event.detail.value;
    }

    handleSaveClick() {
        if (this.companyId === undefined || this.companyId.length === 0) {
            this.customToast.showErrorMessage("Error", "Please provide Company Id to save");
        }
        else {
            storeCompanyId({ value: this.companyId })
                .then(result => {
                    this.customToast.showSuccessMessage("Success", "Company Id stored Successfully!");
                    refreshApex(this.wiredIsCompanyIdStoredResult);
                })
                .catch(error => {
                    this.customToast.showErrorMessage("Error", error.body.message + ", Please contact your administrator!");
                });
        }
    }

    unsubscribeMC() {
        unsubscribe(this.subscription);
        this.subscription = null;
    }

    disconnectedCallback() {
        this.unsubscribeMC();
    }
}
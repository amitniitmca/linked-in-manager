/**
 * @description       : 
 * @author            : Amit Kumar [amitniitmca@gmail.com]
 * @last modified on  : 04-04-2022
 * @last modified by  : Amit Kumar [amitniitmca@gmail.com]
 * Modifications Log
 * Ver   Date         Author                               Modification
 * 1.0   29-03-2022   Amit Kumar [amitniitmca@gmail.com]   Initial Version
**/
import { LightningElement, wire } from 'lwc';
import { subscribe, unsubscribe, APPLICATION_SCOPE, MessageContext } from 'lightning/messageService';
import connectionChannel from '@salesforce/messageChannel/connectionChannel__c';
import getCurrentBasicInfo from '@salesforce/apex/LinkedInProfilePictureController.getCurrentBasicInfo';
import getProfilePictureInfo from '@salesforce/apex/LinkedInProfilePictureController.getProfilePictureInfo';
import storeCompanyId from '@salesforce/apex/LinkedInProfilePictureController.storeCompanyId';
import isCompanyIdStored from '@salesforce/apex/LinkedInProfilePictureController.isCompanyIdStored';
import getStoredCompanyId from '@salesforce/apex/LinkedInProfilePictureController.getStoredCompanyId';

export default class LinkedinProfilePicture extends LightningElement {
    subscription = null;

    isConnected=false;
    userName;
    profilePictureUrl;
    companyId;

    @wire(MessageContext)
    messageContext;

    @wire(isCompanyIdStored)
    wiredIsCompanyIdStored(result){
        this.wiredIsCompanyIdStoredResult = result;
        const {data, error} = result;
        if(data){
            if(data === true){
                console.log('company id stored');
                getStoredCompanyId()
                .then(res=>{
                    console.log(res);
                    this.companyId = res;
                })
                .catch(err=>{
                    console.log(err);
                    this.companyId = undefined;
                });
            }
            else{
                console.log('company id not stored');
            }
        }
        if(error) {
            console.log(error);
        }
    }

    renderedCallback(){
        this.subscribeMC();
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
        if(this.isConnected === true){
            getCurrentBasicInfo()
            .then(res1=>{
                this.userName = res1.localizedFirstName+" "+res1.localizedLastName;
                getProfilePictureInfo()
                .then(res2=>{
                    this.setProfilePictureUrl(JSON.parse(res2));
                })
                .catch(err2=>{
                    console.log(err2);
                });
            })
            .catch(err1=>{
                console.log(err1);
            });
        }
    }

    setProfilePictureUrl(result){
        for(const ele of result.profilePicture['displayImage~'].elements){
            const size = ele.data['com.linkedin.digitalmedia.mediaartifact.StillImage'].displaySize.width;
            if(size === 800){
                this.profilePictureUrl = ele.identifiers[0].identifier;
            }
        }
    }

    handleCompanyChange(event){
        this.companyId = event.detail.value;
    }

    handleSaveClick(){
        if(this.companyId === undefined || this.companyId.length === 0){
            this.template.querySelector("c-custom-toast").showErrorMessage("Error", "Please provide Company Id to save");
        }
        else{
            storeCompanyId({value : this.companyId})
            .then(result =>{
                this.template.querySelector("c-custom-toast").showSuccessMessage("Success", "Company Id stored Successfully!");    
            })
            .catch(error=>{
                this.template.querySelector("c-custom-toast").showErrorMessage("Error", error.message+", Please contact your administrator!");
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
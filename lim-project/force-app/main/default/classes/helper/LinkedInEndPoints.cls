/**
 * @description       : 
 * @author            : Amit Kumar [amitniitmca@gmail.com]
 * @group             : 
 * @last modified on  : 08-04-2022
 * @last modified by  : Amit Kumar [amitniitmca@gmail.com]
 * Modifications Log
 * Ver   Date         Author                               Modification
 * 1.0   26-03-2022   Amit Kumar [amitniitmca@gmail.com]   Initial Version
**/
public inherited sharing class LinkedInEndPoints {
    private static final String NAMED_CREDENTIALS;
    static{
        String type = new ManagerTypeService().getStoredValue().Value__c;
        String nc;
        if(type == 'ORG'){
            nc = new UserNamedCredentialService().getStoredValueForOrg();
        }
        else{
            nc = new UserNamedCredentialService().getStoredValueForUser();
        }
        NAMED_CREDENTIALS = 'callout:'+nc;
    }

    public static String currentMemberBasic(){
        return NAMED_CREDENTIALS+'/me?projection=(id,localizedFirstName,localizedLastName)';
    }

    public static String profilePicture(){
        return NAMED_CREDENTIALS+'/me?projection=(id,profilePicture(displayImage~digitalmediaAsset:playableStreams))';
    }

    public static String shareByOwner(String personId){
        return NAMED_CREDENTIALS+'/shares?q=owners&owners=urn:li:person:'+personId+'&sortBy=LAST_MODIFIED&sharesPerOwner=100';
    }
}

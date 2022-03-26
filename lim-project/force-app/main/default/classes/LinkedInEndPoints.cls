/**
 * @description       : 
 * @author            : Amit Kumar [amitniitmca@gmail.com]
 * @group             : 
 * @last modified on  : 26-03-2022
 * @last modified by  : Amit Kumar [amitniitmca@gmail.com]
 * Modifications Log
 * Ver   Date         Author                               Modification
 * 1.0   26-03-2022   Amit Kumar [amitniitmca@gmail.com]   Initial Version
**/
public inherited sharing class LinkedInEndPoints {
    private static final String NAMED_CREDENTIALS = '';
    static{
        String type = new ManagerTypeService().getStoredValue().Value__c;
        String nc;
        if(type == 'ORG'){
            nc = new UserNamedCredentialService().getStoredValueForOrg();
        }
        else{
            nc = new UserNamedCredentialService().getStoredValueForUser();
        }
        NAMED_CREDENTIALS = nc;
    }

    public static String getCurrentMember(){
        return NAMED_CREDENTIALS+'/me';
    }
}

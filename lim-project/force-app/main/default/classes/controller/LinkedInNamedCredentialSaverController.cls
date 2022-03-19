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
public inherited sharing class LinkedInNamedCredentialSaverController {
    
    @AuraEnabled(cacheable=true)
    public static List<String> getAvailableNamedCredentials(){
        List<NamedCredential> ncs = [SELECT Id , DeveloperName FROM NamedCredential WITH SECURITY_ENFORCED];
        List<String> ncNames = new List<String>();
        for(NamedCredential nc : ncs){
            ncNames.add(nc.DeveloperName);
        }
        return ncNames;
    }

    @AuraEnabled(cacheable=true)
    public static Boolean isNamedCredentialForUserSaved(){
        List<User_Named_Credential__c> uncs = new UserNamedCredentialService().getAllStoredValues();
        Id userId = UserInfo.getUserId();
        Boolean flag = false;
        for(User_Named_Credential__c unc : uncs){
            if(unc.SetupOwnerId == userId){
                flag = true;
                break;
            }
        }
        return flag;
    }
}

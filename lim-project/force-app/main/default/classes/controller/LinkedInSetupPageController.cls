/**
 * @description       : 
 * @author            : Amit Kumar [amitniitmca@gmail.com]
 * @group             : 
 * @last modified on  : 26-03-2022
 * @last modified by  : Amit Kumar [amitniitmca@gmail.com]
 * Modifications Log
 * Ver   Date         Author                               Modification
 * 1.0   18-03-2022   Amit Kumar [amitniitmca@gmail.com]   Initial Version
**/
public inherited sharing class LinkedInSetupPageController {
    
    @AuraEnabled(cacheable=true)
    public static Boolean isLinkedInManagerTypeSaved(){
        try {
            return new ManagerTypeService().isValueStored();            
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled(cacheable=true)
    public static Boolean isCurrentUserAdmin(){
        try {
            Id profileId= UserInfo.getProfileId();
            String profileName=[SELECT Id,Name from Profile where Id=:profileId].Name;
            return profileName == 'System Administrator';
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled(cacheable=true)
    public static String getStoredManagerType(){
        try {
            Manager_Type__c manType = new ManagerTypeService().getStoredValue();
            return manType.Value__c;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled
    public static void storeManagerTypeValue(String value){
        try {
            new ManagerTypeService().storeRecord(value);
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

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

    @AuraEnabled
    public static void storeNamedCredential(String value, String managerTypeUser){
        try {
            if(managerTypeUser == 'ORG'){
                new UserNamedCredentialService().storeRecordForOrg(value);
            }
            else{
                new UserNamedCredentialService().storeRecordForUser(value);
            }
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled(cacheable=true)
    public static String getStoredNamedCredential(String managerTypeUser){
        try {
            if(managerTypeUser == 'USER'){
                return new UserNamedCredentialService().getStoredValueForUser();
            }
            else{
                return new UserNamedCredentialService().getStoredValueForOrg();
            }
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }
}

/**
 * @description       : 
 * @author            : Amit Kumar [amitniitmca@gmail.com]
 * @group             : 
 * @last modified on  : 20-03-2022
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
}

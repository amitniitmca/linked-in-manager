/**
 * @description       : LinkedInManagerTypeController class is controller for the linkedInManagerType LWC
 * @author            : Amit Kumar [amitniitmca@gmail.com]
 * @group             : 
 * @last modified on  : 02-03-2022
 * @last modified by  : Amit Kumar [amitniitmca@gmail.com]
 * Modifications Log
 * Ver   Date         Author                               Modification
 * 1.0   02-03-2022   Amit Kumar [amitniitmca@gmail.com]   Initial Version
**/
public inherited sharing class LinkedInManagerTypeController {
    
    @AuraEnabled(cacheable=true)
    public static Boolean isLinkedInManagerTypeSaved(){
        try {
            return new ManagerTypeService().isValueStored();            
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled(cacheable=true)
    public static String getStoredManagerTypeValue(){
        try {
            Manager_Type__c managerType = new ManagerTypeService().getStoredValue();
            return managerType.Value__c;
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
}

/**
 * @description       : ManagerTypeService class is used to perform operations on Manager_Type_Service custom setting
 * @author            : Amit Kumar [amitniitmca@gmail.com]
 * @last modified on  : 02-03-2022
 * @last modified by  : Amit Kumar [amitniitmca@gmail.com]
 * Modifications Log
 * Ver   Date         Author                               Modification
 * 1.0   02-03-2022   Amit Kumar [amitniitmca@gmail.com]   Initial Version
**/
public inherited sharing class ManagerTypeService {
    
    /**
    * @description This method is used to store the value in the custom setting
    * @author Amit Kumar [amitniitmca@gmail.com] | 02-03-2022 
    * @param String value It is the value to be stored in the custom setting, i.e. ORG or USER
    **/
    public void storeRecord(String value){
        if(!isCreatable()){
            return;
        }
        Id orgId = UserInfo.getOrganizationId();
        Manager_Type__c mt = new Manager_Type__c();
        mt.SetupOwnerId = orgId;
        mt.Value__c = value;
        INSERT mt;
    }
    
    /**
    * @description This method is used to specify whether the record is saved in the custom setting or not
    * @author Amit Kumar [amitniitmca@gmail.com] | 02-03-2022 
    * @return Boolean It returns true if the record is saved in the custom setting otherwise false
    **/
    public Boolean isValueStored(){
        Manager_Type__c mt = getStoredValue();
        return mt.Value__c != null;
    }
    
    /**
    * @description This method is used to get the stored value in the custom setting
    * @author Amit Kumar [amitniitmca@gmail.com] | 02-03-2022 
    * @return Manager_Type__c It returns the Custom Setting record stored
    **/
    public Manager_Type__c getStoredValue(){
        Id orgId = UserInfo.getOrganizationId();
        Manager_Type__c mt = Manager_Type__c.getInstance(orgId);
        return mt;
    }

    /**
    * @description This private method is to check whether the only field of the custom setting is createable or not
    * @author Amit Kumar [amitniitmca@gmail.com] | 02-03-2022 
    * @return Boolean It returns true if the field is createable, otherwise false
    **/
    private static Boolean isCreatable(){
        return (Schema.sObjectType.Manager_Type__c.fields.Value__c.isCreateable());
    }
}

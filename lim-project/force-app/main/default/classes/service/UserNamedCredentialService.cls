/**
 * @description       : UserNamedCredentialService class is used to perform operations on User_Named_Credential_Service custom setting
 * @author            : Amit Kumar [amitniitmca@gmail.com]
 * @last modified on  : 19-03-2022
 * @last modified by  : Amit Kumar [amitniitmca@gmail.com]
 * Modifications Log
 * Ver   Date         Author                               Modification
 * 1.0   02-03-2022   Amit Kumar [amitniitmca@gmail.com]   Initial Version
 **/
public inherited sharing class UserNamedCredentialService{
    /**
     * @description This method is used to store the named credential info for the current user
     * @author Amit Kumar [amitniitmca@gmail.com] | 02-03-2022
     * @param String value It is the named credential name to be stored for the current user
     **/
    public void storeRecordForUser(String value){
        Id userId = UserInfo.getUserId();
        storeRecord(userId, value);
    }

    /**
     * @description This method is used to store the named credential info for the org
     * @author Amit Kumar [amitniitmca@gmail.com] | 02-03-2022
     * @param String value It is the named credential name to be stored for the org
     **/
    public void storeRecordForOrg(String value){
        Id orgId = UserInfo.getOrganizationId();
        storeRecord(orgId, value);
    }

    /**
    * @description This method is used to check whether named credential info for the user is stored or not
    * @author Amit Kumar [amitniitmca@gmail.com] | 02-03-2022 
    * @return Boolean It returns true if the named credential info for the user is stored otherwise false
    **/
    public Boolean isValueStoredForUser(){
        Id userId = UserInfo.getUserId();
        User_Named_Credential__c unc = User_Named_Credential__c.getInstance(userId);
        return unc.Value__c != null;
    }

    /**
    * @description This method is used to check whether named credential info for the org is stored or not
    * @author Amit Kumar [amitniitmca@gmail.com] | 02-03-2022 
    * @return Boolean It returns true if the named credential info for the org is stored otherwise false
    **/
    public Boolean isValueStoredForOrg(){
        Id orgId = UserInfo.getOrganizationId();
        User_Named_Credential__c unc = User_Named_Credential__c.getInstance(orgId);
        return unc.Value__c != null;
    }

    /**
    * @description This method is used to return all the stored records of the named credentials in the custom settings
    * @author Amit Kumar [amitniitmca@gmail.com] | 02-03-2022 
    * @return List<User_Named_Credential__c> It returns the list of all stored records in the custom settings
    **/
    public List<User_Named_Credential__c> getAllStoredValues(){
        List<User_Named_Credential__c> userDetails = [SELECT Id, Value__c, SetupOwnerId  FROM User_Named_Credential__c WITH SECURITY_ENFORCED];
        return userDetails;
    }

    /**
     * @description This private method is to check whether the only field of the custom setting is upsertable or not
     * @author Amit Kumar [amitniitmca@gmail.com] | 02-03-2022
     * @return Boolean It returns true if the field is upsertable, otherwise false
     **/
    private static Boolean isUpsertable(){
        return (Schema.sObjectType.User_Named_Credential__c.fields.Value__c.isUpdateable() || Schema.sObjectType.User_Named_Credential__c.fields.Value__c.isCreateable());
    }

    /**
    * @description This private method is used to store named credential info for the specified owner id
    * @author Amit Kumar [amitniitmca@gmail.com] | 02-03-2022 
    * @param Id ownerId It is the owner id for the custom setting record, which can be for current user or org
    * @param String value It is the named credential name to be stored as the record
    **/
    private static void storeRecord(Id ownerId, String value){
        if (!isUpsertable()){
            return;
        }
        User_Named_Credential__c unc = User_Named_Credential__c.getInstance(ownerId);
        if (unc.Value__c == null){
            unc = new User_Named_Credential__c();
            unc.SetupOwnerId = ownerId;
        }
        unc.Value__c = value;
        UPSERT unc;
    }

}
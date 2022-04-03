/**
 * @description       : LinkedInIdsService class is used to perform operations on LinkedIn_Ids custom setting
 * @author            : Amit Kumar [amitniitmca@gmail.com]
 * @last modified on  : 03-04-2022
 * @last modified by  : Amit Kumar [amitniitmca@gmail.com]
 * Modifications Log
 * Ver   Date         Author                               Modification
 * 1.0   03-04-2022   Amit Kumar [amitniitmca@gmail.com]   Initial Version
**/
public inherited sharing class LinkedInIdsService {
    
    /**
    * @description This method is used to store the LinkedIn Company Id for the LinkedIn Connection
    * @author Amit Kumar [amitniitmca@gmail.com] | 03-04-2022 
    * @param String value It is Company Id to be stored in the Custom Setting
    **/
    public void storeRecordForOrg(String value){
        Id ownerId = UserInfo.getOrganizationId();
        LinkedInIdsService.storeRecord(ownerId, value);
    }

    /**
    * @description This method is used to store the LinkedIn User Id for the LinkedIn Connection of the current User
    * @author Amit Kumar [amitniitmca@gmail.com] | 03-04-2022 
    * @param String value It is Company Id to be stored in the Custom Setting
    **/
    public void storeRecordForUser(String value){
        Id ownerId = UserInfo.getUserId();
        LinkedInIdsService.storeRecord(ownerId, value);
    }

    /**
    * @description This method is used to check whether the LinkedIn User Id is already stored for the LinkedIn Connection of the current User
    * @author Amit Kumar [amitniitmca@gmail.com] | 03-04-2022 
    * @return Boolean It s true if the value is already stored otherwise false
    **/
    public Boolean isValueStoredForUser(){
        Id userId = UserInfo.getUserId();
        LinkedIn_Ids__c lid = LinkedIn_Ids__c.getInstance(userId);
        return lid.Value__c != null;
    }
    
    /**
    * @description This method is used to check whether the LinkedIn Company Id is already stored for the LinkedIn Connection
    * @author Amit Kumar [amitniitmca@gmail.com] | 03-04-2022 
    * @return Boolean It s true if the value is already stored otherwise false
    **/
    public Boolean isValueStoredForOrg(){
        Id orgId = UserInfo.getOrganizationId();
        LinkedIn_Ids__c lid = LinkedIn_Ids__c.getInstance(orgId);
        return lid.Value__c != null;
    }

    /**
    * @description This method is to get stored company Id for the Linked In Connection
    * @author Amit Kumar [amitniitmca@gmail.com] | 03-04-2022 
    * @return String It is the stored company id of the linkedIn connection
    **/
    public String getStoredOrgValue(){
        Id ownerId = UserInfo.getOrganizationId();
        return LinkedInIdsService.getStoredValue(ownerId);
    }

    /**
    * @description This method is to get stored user Id for the Linked In Connection of the current user
    * @author Amit Kumar [amitniitmca@gmail.com] | 03-04-2022 
    * @return String It is the stored company id of the linkedIn connection
    **/
    public String getStoredUserValue(){
        Id ownerId = UserInfo.getUserId();
        return LinkedInIdsService.getStoredValue(ownerId);
    }

    /**
    * @description This private method is to return the stored user id or company id for the specified owner id
    * @author Amit Kumar [amitniitmca@gmail.com] | 26-03-2022 
    * @param Id ownerId It is the owner id for the custom setting record, which can be for current user or org
    * @return String It returns the stored user id or company id of the specified owner id in the custom settings
    **/
    private static String getStoredValue(Id ownerId){
        LinkedIn_Ids__c lid = LinkedIn_Ids__c.getInstance(ownerId);
        return lid.Value__c;
    }

    /**
    * @description This private method is used to store User Id or Company Id for the specified owner id
    * @author Amit Kumar [amitniitmca@gmail.com] | 02-03-2022 
    * @param Id ownerId It is the owner id for the custom setting record, which can be for current user or org
    * @param String value It is the User Id or the Company Id to be stored as the record
    **/
    private static void storeRecord(Id ownerId, String value){
        if(!isUpsertable()){
            return;
        }
        LinkedIn_Ids__c lid = LinkedIn_Ids__c.getInstance(ownerId);
        if (lid.Value__c == null){
            lid = new LinkedIn_Ids__c();
            lid.SetupOwnerId = ownerId;
        }
        lid.Value__c = value;
        UPSERT lid;
    }

    /**
     * @description This private method is to check whether the only field of the custom setting is upsertable or not
     * @author Amit Kumar [amitniitmca@gmail.com] | 02-03-2022
     * @return Boolean It returns true if the field is upsertable, otherwise false
     **/
    private static Boolean isUpsertable(){
        return (Schema.sObjectType.LinkedIn_Ids__c.fields.Value__c.isUpdateable() || Schema.sObjectType.LinkedIn_Ids__c.fields.Value__c.isCreateable());
    }
}

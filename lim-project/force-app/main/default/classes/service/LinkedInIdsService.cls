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

    public Boolean isValueStoredForUser(){
        Id userId = UserInfo.getUserId();
        LinkedIn_Ids__c lid = LinkedIn_Ids__c.getInstance(userId);
        return lid.Value__c != null;
    }
    
    public Boolean isValueStoredForOrg(){
        Id orgId = UserInfo.getOrganizationId();
        LinkedIn_Ids__c lid = LinkedIn_Ids__c.getInstance(orgId);
        return lid.Value__c != null;
    }

    public String getStoredOrgValue(){
        Id ownerId = UserInfo.getOrganizationId();
        return LinkedInIdsService.getStoredValue(ownerId);
    }

    public String getStoredUserValue(){
        Id ownerId = UserInfo.getUserId();
        return LinkedInIdsService.getStoredValue(ownerId);
    }

    private static String getStoredValue(Id ownerId){
        LinkedIn_Ids__c lid = LinkedIn_Ids__c.getInstance(ownerId);
        return lid.Value__c;
    }

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

    private static Boolean isUpsertable(){
        return (Schema.sObjectType.LinkedIn_Ids__c.fields.Value__c.isUpdateable() || Schema.sObjectType.LinkedIn_Ids__c.fields.Value__c.isCreateable());
    }
}

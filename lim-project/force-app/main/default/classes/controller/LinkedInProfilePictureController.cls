/**
 * @description       : 
 * @author            : Amit Kumar [amitniitmca@gmail.com]
 * @group             : 
 * @last modified on  : 29-03-2022
 * @last modified by  : Amit Kumar [amitniitmca@gmail.com]
 * Modifications Log
 * Ver   Date         Author                               Modification
 * 1.0   29-03-2022   Amit Kumar [amitniitmca@gmail.com]   Initial Version
**/
public inherited sharing class LinkedInProfilePictureController {
    @AuraEnabled
    public static Map<String,Object> getCurrentBasicInfo(){
        try {
            Map<String,Object> statusMap = LinkedInConnections.getCurrentProfileBasicInfo();
            return statusMap;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled
    public static String getProfilePictureInfo(){
        try {
            return LinkedInConnections.getProfilePicture();
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }
}

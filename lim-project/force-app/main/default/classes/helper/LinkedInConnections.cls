/**
 * @description       :
 * @author            : Amit Kumar [amitniitmca@gmail.com]
 * @group             :
 * @last modified on  : 29-03-2022
 * @last modified by  : Amit Kumar [amitniitmca@gmail.com]
 * Modifications Log
 * Ver   Date         Author                               Modification
 * 1.0   26-03-2022   Amit Kumar [amitniitmca@gmail.com]   Initial Version
 **/
public inherited sharing class LinkedInConnections{
    // {"localizedLastName":"Kumar","id":"xxxxxxxxxx","localizedFirstName":"Amit"}
    public static Map<String, String> getCurrentProfileBasicInfo(){
        HttpRequest request = new HttpRequest();
        request.setEndpoint(LinkedInEndPoints.currentMemberBasic());
        request.setMethod('GET');
        HttpResponse response = new Http().send(request);
        Map<String, String> basicInfo = null;
        if (response.getStatusCode() == 200){
            basicInfo = (Map<String, String>)JSON.deserializeUntyped(response.getBody());
        }
        return basicInfo;
    }

    public static Map<String, String> getConnectionStatus(){
        HttpRequest request = new HttpRequest();
        request.setEndpoint(LinkedInEndPoints.currentMemberBasic());
        request.setMethod('GET');
        HttpResponse response = new Http().send(request);
        Map<String, String> statusMap = new Map<String, String>();
        statusMap.put('Status', response.getStatus());
        statusMap.put('StatusCode', String.valueOf(response.getStatusCode()));
        return statusMap;
    }

    public static String getProfilePicture(){
        HttpRequest request = new HttpRequest();
        request.setEndpoint(LinkedInEndPoints.profilePicture());
        request.setMethod('GET');
        HttpResponse response = new Http().send(request);
        if (response.getStatusCode() == 200){
            
        }
        return 'pictureUrl';
    }
}
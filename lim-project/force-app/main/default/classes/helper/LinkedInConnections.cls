/**
 * @description       : 
 * @author            : Amit Kumar [amitniitmca@gmail.com]
 * @group             : 
 * @last modified on  : 27-03-2022
 * @last modified by  : Amit Kumar [amitniitmca@gmail.com]
 * Modifications Log
 * Ver   Date         Author                               Modification
 * 1.0   26-03-2022   Amit Kumar [amitniitmca@gmail.com]   Initial Version
**/
public inherited sharing class LinkedInConnections {

    // {"localizedLastName":"Kumar","id":"xxxxxxxxxx","localizedFirstName":"Amit"}
    public static String getCurrentProfileBasicInfo(){
        HttpRequest request = new HttpRequest();
        request.setEndpoint(LinkedInEndPoints.getCurrentMember());
        request.setMethod('GET');
        HttpResponse response = new Http().send(request);
        Map<String,String> basicInfo = null;
        if(response.getStatusCode() == 200){
            basicInfo = JSON.deserializeUntyped(response.getBody());
        }
        return basicInfo;
    }

    public static Map<String, String> getConnectionStatus(){
        HttpRequest request = new HttpRequest();
        request.setEndpoint(LinkedInEndPoints.getCurrentMember());
        request.setMethod('GET');
        HttpResponse response = new Http().send(request);
        Map<String,String> statusMap = new Map<String,String>();
        statusMap.put('Status', response.getStatus());
        statusMap.put('StatusCode', String.valueOf(response.getStatusCode()));
        return statusMap;
    }
}

/**
 * @description       : 
 * @author            : Amit Kumar [amitniitmca@gmail.com]
 * @group             : 
 * @last modified on  : 08-04-2022
 * @last modified by  : Amit Kumar [amitniitmca@gmail.com]
 * Modifications Log
 * Ver   Date         Author                               Modification
 * 1.0   08-04-2022   Amit Kumar [amitniitmca@gmail.com]   Initial Version
**/
public inherited sharing class LinkedInShares {
    
    public static void getSharesByOwner(String personId){
        HttpRequest request = new HttpRequest();
        request.setEndpoint(LinkedInEndPoints.shareByOwner(personId));
        request.setMethod('GET');
        HttpResponse response = new Http().send(request);
        System.debug(response.getStatusCode());
        System.debug(response.getStatus());
        System.debug(response.getBody());
    } 
}

public inherited sharing class NcCreatorHelper {
    @InvocableMethod
    public static void createNCFrom(List<NamedCredential> ncDetail) {
        NamedCredential nc = ncDetail[0];
        Map<String, String> ncMap = new Map<String, String>();
        AuthProvider auth = (AuthProvider) [SELECT Id, DeveloperName, DefaultScopes FROM AuthProvider WHERE Id = :nc.AuthProviderId WITH SECURITY_ENFORCED LIMIT 1][0];
        ncMap.put('AuthProvider', auth.DeveloperName);
        ncMap.put('Endpoint', nc.Endpoint);
        ncMap.put('DeveloperName',nc.DeveloperName);
        ncMap.put('Scope',auth.DefaultScopes);

        new NamedCredentialsHelper().createNC(ncMap);
    }
}

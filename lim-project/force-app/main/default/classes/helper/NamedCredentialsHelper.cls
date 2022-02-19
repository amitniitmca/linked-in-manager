public inherited sharing class NamedCredentialsHelper{

    /*
        credential.authProvider = 'Sample_Auth';
        credential.endpoint = 'https://api.linkedin.com';
        credential.allowMergeFieldsInHeader = true;
        credential.generateAuthorizationHeader = true;
        credential.label = 'sampleNCEX';
        credential.oauthScope = 'rw_organization_admin w_organization_social r_organization_social w_member_social rw_ads r_ads r_ads_reporting r_1st_connections r_ads_leadgen_automation rw_dmp_segments_r_basicprofilesize w_member_social r_liteprofile r_emailaddress';
        credential.principalType = 'NamedUser';
        credential.protocol = 'Oauth';
        credential.fullName='Sample';
        credential.label='Sample';
    */
    public void createNC(Map<String, String> credentialInfo){
        MetadataService.NamedCredential credential = new MetadataService.NamedCredential();
        credential.allowMergeFieldsInHeader = true;
        credential.generateAuthorizationHeader = true;
        credential.principalType = 'NamedUser';
        credential.protocol = 'Oauth';

        credential.authProvider = credentialInfo.get('AuthProvider');
        credential.endpoint = credentialInfo.get('Endpoint');
        credential.label = credentialInfo.get('DeveloperName');
        credential.fullName=credentialInfo.get('DeveloperName');
        credential.oauthScope = credentialInfo.get('Scope');

        createMetadata(credential);
        updateMetadata(credential);
    }

    static MetadataService.MetadataPort createService(){
        MetadataService.MetadataPort service = new MetadataService.MetadataPort();
        service.SessionHeader = new MetadataService.SessionHeader_element();
        service.SessionHeader.sessionId = UserInfo.getSessionId();
        return service;
    }

    static List<MetadataService.SaveResult> createMetadata(MetadataService.Metadata input){
        return createService().createMetadata(new List<MetadataService.Metadata>{ input });
    }

    static List<MetadataService.SaveResult> updateMetadata(MetadataService.Metadata input){
        return createService().updateMetadata(new List<MetadataService.Metadata>{ input });
    }

    static List<MetadataService.DeleteResult> deleteMetadata(String type, String fullName){
        return createService().deleteMetadata(type, new List<String>{ fullName });
    }

}
/**
 * @description       : This class is used to Create Record in Custom Metadata
 * @author            : Amit Kumar [amitniitmca@gmail.com]
 * @last modified on  : 15-02-2022
 * @last modified by  : Amit Kumar [amitniitmca@gmail.com]
 **/
public class CreateMetadata{
    private String customMetadataName;
    private String metadataRecordName;
    private Map<String, Object> fieldsAndValues;
    private List<Object> values;

    public CreateMetadata(String customMetadataName, String metadataRecordName, Map<String, Object> fieldsAndValues){
        this.customMetadataName = customMetadataName;
        this.metadataRecordName = metadataRecordName;
        this.fieldsAndValues = fieldsAndValues;
    }

    public void updateAndDeployMetadata(){
        Metadata.CustomMetadata customMetadata = new Metadata.CustomMetadata();
        Metadata.DeployContainer mdContainer = new Metadata.DeployContainer();
        
        customMetadata.fullName = this.customMetadataName + '.' + this.metadataRecordName;

        Set<String> keySet = this.fieldsAndValues.keySet();
        for(String key : keySet){
            Metadata.CustomMetadataValue customField = new Metadata.CustomMetadataValue();
            customField.field = key;
            customField.value = this.fieldsAndValues.get(key);
            customMetadata.values.add(customField);
            mdContainer.addMetadata(customMetadata);
        }

        CustomMetadataDeployCallback callback = new CustomMetadataDeployCallback();
        Id deployRequestId = Metadata.Operations.enqueueDeployment(mdContainer, callback);
    }

}
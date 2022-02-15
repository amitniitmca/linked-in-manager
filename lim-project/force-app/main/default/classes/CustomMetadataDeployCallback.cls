/**
 * @description       : 
 * @author            : Amit Kumar [amitniitmca@gmail.com]
 * @group             : 
 * @last modified on  : 15-02-2022
 * @last modified by  : Amit Kumar [amitniitmca@gmail.com]
**/
public class CustomMetadataDeployCallback implements Metadata.DeployCallback{
    public void handleResult(Metadata.DeployResult result,
                             Metadata.DeployCallbackContext context) {
        Id jobId = context.getCallbackJobId();

        // Todo: Need to work on these status

        // switch on (result.status) {
        //     when Succeeded {
                
        //     }
        //     when SucceededPartial {
                
        //     }
        //     when Failed {
                
        //     }
        //     when Canceled {

        //     }
        //     when Pending, InProgress, Canceling {
                
        //     }
        // }
    }
}

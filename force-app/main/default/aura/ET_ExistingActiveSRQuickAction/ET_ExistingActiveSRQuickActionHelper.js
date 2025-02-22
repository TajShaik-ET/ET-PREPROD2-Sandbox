({
    getActivatedSRId : function(component,oppId){
        var action = component.get("c.getActiveSRId");
        component.set('v.loaded', !component.get('v.loaded'));
        action.setParams({
            'opportunityId' : oppId   
        });
        
        action.setCallback(this, function(a) {
            var state = a.getState();
            component.set('v.loaded', !component.get('v.loaded'));
            if (state === "SUCCESS"){
                var result = a.getReturnValue();
                if(result){
                    if(result == 'NoActiveSR'){
                        var toastReference = $A.get("e.force:showToast");
                        toastReference.setParams({
                            "type":"warning",
                            "title":"warning",
                            "message":"No active service request is associated to this Opportunity",
                            "mode":"sticky"
                        });
                        toastReference.fire();
                        // alert('No active service request is associated to this Opportunity');
                    }
                    else{
                        
                        //ET_ServiceRequestForm
                        // window.open('/c/CreatePricingServiceRequestApp.app?recordId='+result, '_blank'); 
                        
                        
                        //Added by Jana
                        var pageReference = {
                            type: 'standard__component',
                            attributes: {
                                componentName: 'c__ET_ServiceRequestForm'
                            },
                            state: {
                                c__recordId: result
                            }
                        };
                        component.set("v.pageReference", pageReference);
                        const navService = component.find('navService');
                        const pageRef = component.get('v.pageReference');
                        const handleUrl = (url) => {
                            window.open(url);
                        };
                            const handleError = (error) => {
                            console.log(error);
                        };
                            navService.generateUrl(pageRef).then(handleUrl, handleError); 
                            //Ended -Jana
                            
                            
                            
                            
                        } 
                        }else{
                            var toastReference = $A.get("e.force:showToast");
                            toastReference.setParams({
                            "type":"Error",
                            "title":"Error",
                            "message":"Something wrong happened!,Please contact Administrator",
                            "mode":"sticky"
                        });
                        toastReference.fire();
                        //alert('Something wrong happened!,Please contact Administrator');
                    }
                    
                }
                $A.get("e.force:closeQuickAction").fire();
            });
            $A.enqueueAction(action);
            
        }
                           })
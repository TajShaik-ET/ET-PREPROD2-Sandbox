({
    checkOppStageIsValid : function(component,recordId) {
        var action = component.get("c.validateOppStage");
        component.set('v.loaded', !component.get('v.loaded'));
        action.setParams({'recordId' : recordId});
        console.log('recordId : ' + recordId);
        action.setCallback(this, function(a){
            var state = a.getState();
            component.set('v.loaded', !component.get('v.loaded'));
            if(state === 'SUCCESS'){
                var response = a.getReturnValue();
                
                //window.open('/c/CreatePricingServiceRequestApp.app?recordId='+recordId, '_blank');
                //Added by Jana
              
                var pageReference = {
                    type: 'standard__component',
                    attributes: {
                        componentName: 'c__ET_ServiceRequestForm'
                    },
                    state: {
                        c__recordId: recordId
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
                    else if(state === "ERROR"){
                    var errors = action.getError();
                    if (errors) {
                    if (errors[0] && errors[0].message) {
                    this.showToast('Error','error',errors[0].message,'sticky');
                }
                }
                }
                    
                    else{
                    console.log('callback from the server failed');
                }
                    $A.get("e.force:closeQuickAction").fire();
                })
                    $A.enqueueAction(action);
                },
                    
                    showToast : function(title,type,message,mode){
                        var toastEvent = $A.get("e.force:showToast");
                        toastEvent.setParams({
                            "title": title,
                            "type":type,
                            "message": message,
                            "mode": mode
                        });
                        toastEvent.fire();
                    },
                })
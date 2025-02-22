({
    getOppAccountVehicleWrapperhelper: function(component, event, helper) {
        let activeSections = component.get("v.activeSections");
        if (activeSections.length === 0) {
            component.set("v.activeSections",["A","B","C","D","E"]);
        }/* else {
            component.set("v.activeSections",[]);
        }*/
        var a= component.get("v.recordId");
        console.log('***In helper Opp Id is :'+a);
        //call apex class method
        var action = component.get('c.getOppAccountVehicleDetails');
        action.setParams({
            oppId : component.get("v.recordId")
        });
        action.setCallback(this, function(response) {
            //store state of response
            var state = response.getState();
            
            //var psr = component.get("v.noOfPSRs");
            if (state === "SUCCESS") {
                if( response.getReturnValue().approvalStatus === "Submitted For Approval" ){
                    component.set('v.btnLabel', "Approval Pending");
                    var btn = component.find('submitBtn');
                    console.log(btn);
                    btn.set('v.disabled',true);
                }else if(response.getReturnValue().approvalStatus === "Rejected"){
                    component.set('v.btnLabel', "Submit for Re-Approval");
                }else if(response.getReturnValue().approvalStatus === "Approved"){
                    component.set('v.btnLabel', response.getReturnValue().approvalStatus);
                    var btn = component.find('submitBtn');
                    console.log(btn);
                    btn.set('v.disabled',true);
                }else if(response.getReturnValue().oppStage != "Requirement Analysis" && 
                         response.getReturnValue().oppRecord != null){
                    component.set('v.btnLabel', "Mark Stage as Requirement Analysis to Submit for Approval");
                    //component.set('v.btnLabel', "Opportunity Stage - "+response.getReturnValue().oppStage);
                    var btn = component.find('submitBtn');
                    console.log(btn);
                    btn.set('v.disabled',true);
                }else if(response.getReturnValue().oppRecord == null){
                    console.log('display none');
                    var btn1 = component.find('submitBtn');
                    var btn2 = component.find('cancelBtn');
                    $A.util.addClass(btn1, 'toggle');
                }
                //set response value in wrapperList attribute on component.
                component.set('v.getOppAccountVehicleDetails', response.getReturnValue());
                component.set('v.noOfPSRs', response.getReturnValue().noOfPSRs);
                //alert('++++'+response.getReturnValue().oppRecord.Pricing_Service_Requests__r[0].ET_Service_Request_Common_Data__r.ET_Price_Utilization__c);
                component.set("v.activeSections",["A","B","C","D","E"]);
                console.log('++++'+response.getReturnValue().workForceRecords);
            }
            else if(state == "ERROR"){
                var errors = response.getError();                       
                component.set("v.showError",true);
                component.set("v.errorMessage",errors[0].message);
                //component.set("v.errorMessage",'Error');
            }
        });
        $A.enqueueAction(action);
    },
    
    submitForApprovalHelper: function(component, event, helper) {
        console.log('***In helper Submit for approval');
        var a= component.get("v.recordId");
        console.log('***In helper'+a);
        var psr = component.get("v.noOfPSRs");
        //if(psr>0){
            //call apex class method
            var action = component.get('c.submitForOppApproval');
            action.setParams({
                oppId : component.get("v.recordId")
            });
            action.setCallback(this, function(response) {
                //store state of response
                var state = response.getState();
                if (state === "SUCCESS") {
                    var dismissActionPanel = $A.get("e.force:closeQuickAction");
                    dismissActionPanel.fire();
                    console.log('+1++'+response.getReturnValue());
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        title : 'Success',
                        message: 'Record Has been successfully submitted for Approval!',
                        duration:' 7000',
                        key: 'info_alt',
                        type: 'success',
                        mode: 'pester'
                    });
                    toastEvent.fire();
                    $A.get('e.force:refreshView').fire();    
                }
                else if(state == "ERROR"){
                    var errors = response.getError();                      
                    component.set("v.showError",true);
                    component.set("v.errorMessage",errors[0].message);
                    alert(errors[0].message);
                }
            });
            $A.enqueueAction(action);
    },
    getOpportunityDetails: function(component, event, helper) {
        var action = component.get('c.getOpportunityDetails');
        action.setParams({
            oppId : component.get("v.recordId")
        });
        action.setCallback(this, function(response) {
            //store state of response
            var state = response.getState();
            if (state === "SUCCESS") {
                console.log('+1++',response.getReturnValue());
                component.set('v.opportunityRecordType',response.getReturnValue());
            }
        });
        $A.enqueueAction(action);
    },
})
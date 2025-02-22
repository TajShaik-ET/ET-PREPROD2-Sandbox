({
    doInit : function(component, event, helper) {
        helper.fetchPickListVal(component, "Lane_Status__c", "lanStatusMap");
        
        var action = component.get("c.getLaneDetailsBookings");
        action.setParams({
            recordId: component.get("v.recordId")
        });
        action.setCallback(this, function(response) {
            console.log(response.getState());
            if (response.getState() == "SUCCESS") {
                var result = response.getReturnValue();
                component.set("v.lstBookings",result);
            }else{
                console.log("Failed with state: " + state);
                console.log('errror');
            }
        });
        $A.enqueueAction(action);
        
        var act = component.get("c.getLaneDetails");
        act.setParams({
            recordId: component.get("v.recordId")
        });
        act.setCallback(this, function(response) {
            if (response.getState() == "SUCCESS") {
                var result = response.getReturnValue();
                component.set("v.laneDetails",result);
            }else{
                console.log("Failed with state: " + state);
                console.log('errror');
            }
        });
        $A.enqueueAction(act);
        
    },
    validateDate : function(component, event, helper){
        
        var today = new Date();        
        var dd = today.getDate();
        var mm = today.getMonth() + 1; //January is 0!
        var yyyy = today.getFullYear();
        // if date is less then 10, then append 0 before date   
        if(dd < 10){
            dd = '0' + dd;
        } 
        // if month is less then 10, then append 0 before date    
        if(mm < 10){
            mm = '0' + mm;
        }
        
        var todayFormattedDate = yyyy+'-'+mm+'-'+dd;
        if(component.get("v.laneDetails.From_Date__c") != '' && component.get("v.laneDetails.From_Date__c") < todayFormattedDate){
            helper.showErrorToast({
                title: "Error: ",
                type: "error",
                message:"Please select Today's or Future Date"
            });
            component.set("v.isDateValid",true);
            return false;  
        }else if(component.get("v.laneDetails.To_Date__c") != '' && component.get("v.laneDetails.To_Date__c") < todayFormattedDate){
            helper.showErrorToast({
                title: "Error: ",
                type: "error",
                message:"Please select Today's or Future Date"
            });
            component.set("v.isDateValid",true);
            return false;  
        }else{
            component.set("v.isDateValid",false);
        }        
    },
    handleConfirmDialogNo : function(component, event, helper) {
        console.log('No');
        component.set('v.showConfirmDialog', false);
    },
    handleConfirmDialogYes : function(component, event, helper) {
        console.log('Yes');
        component.set('v.showConfirmDialog', false);
        
        var laneDetails = component.get("v.laneDetails");
        if(laneDetails.To_Date__c == ''){
            delete laneDetails['To_Date__c'];
        }
        
        var action = component.get("c.updateLaneStatus");
        var mapNameForStagingObjects = {
            laneDetails: JSON.stringify(component.get("v.laneDetails"))
        };
        action.setParams({
            mapofStageJsonList: mapNameForStagingObjects
        });
        action.setCallback(this, function(response) {
            
            console.log(response.getState());
            
            if (response.getState() == "SUCCESS") {
                var result = response.getReturnValue();
                console.log(result);
                
                helper.showErrorToast({
                    title: "Success: ",
                    type: "success",
                    message:"Status updated successfully"
                });
                
                $A.get("e.force:closeQuickAction").fire();
                $A.get('e.force:refreshView').fire();                
                
            }else{
                console.log("Failed with state: " + state);
                console.log('errror');
            }
        });
        $A.enqueueAction(action);
        
    },
    Cancel : function(component, event, helper) {
        $A.get("e.force:closeQuickAction").fire();
    },
    Save : function(component, event, helper) {
        
        var lstBookings = component.get("v.lstBookings");        
        var laneDetails = component.get("v.laneDetails");
        laneDetails.Id =  component.get("v.recordId");
        component.set("v.laneDetails",laneDetails);
        
        if(laneDetails.Lane_Status__c == ''){
            helper.showErrorToast({
                title: "Error: ",
                type: "error",
                message:"Please select Lane Status"
            });
            return false;            
        }
        if(laneDetails.From_Date__c == ''){
            helper.showErrorToast({
                title: "Error: ",
                type: "error",
                message:"Please select From Date"
            });
            return false;            
        }
        /*if(laneDetails.To_Date__c == ''){
            helper.showErrorToast({
                title: "Error: ",
                type: "error",
                message:"Please select To Date"
            });
            return false;            
        }*/
        if(laneDetails.To_Date__c!=''){
            if(laneDetails.From_Date__c > laneDetails.To_Date__c){
                helper.showErrorToast({
                    title: "Error: ",
                    type: "error",
                    message:"Please select valid Dates"
                });
                return false;  
            }
        }
        
        if(component.get("v.isDateValid")){
            
            helper.showErrorToast({
                    title: "Error: ",
                    type: "error",
                    message:"Please select Today's or Future Dates"
                });
            return false;
        }
        if(lstBookings!=null && lstBookings.length > 0){
            
            for(var i=0; i<lstBookings.length; i++ ){
                if(lstBookings[i].Booking_Date__c == laneDetails.From_Date__c){
                    component.set('v.bookingsCount', lstBookings.length);
                    component.set('v.showConfirmDialog', true);                    
                }
                
                if(lstBookings[i].Booking_Date__c > laneDetails.From_Date__c &&
                   lstBookings[i].Booking_Date__c < laneDetails.To_Date__c){
                    component.set('v.bookingsCount', lstBookings.length);
                    component.set('v.showConfirmDialog', true);
                }
            }            
        }
        
        if(component.get('v.showConfirmDialog') == false){
            var action = component.get("c.updateLaneStatus");
            var mapNameForStagingObjects = {
                laneDetails: JSON.stringify(component.get("v.laneDetails"))
            };
            action.setParams({
                mapofStageJsonList: mapNameForStagingObjects
            });
            action.setCallback(this, function(response) {
                
                console.log(response.getState());
                
                if (response.getState() == "SUCCESS") {
                    var result = response.getReturnValue();
                    console.log(result);
                    
                    helper.showErrorToast({
                        title: "Success: ",
                        type: "success",
                        message:"Status updated successfully"
                    });
                    $A.get("e.force:closeQuickAction").fire();
                    $A.get('e.force:refreshView').fire();
                }else{
                    console.log("Failed with state: " + state);
                    console.log('errror');
                }
            });
            $A.enqueueAction(action);
        }
    }
})
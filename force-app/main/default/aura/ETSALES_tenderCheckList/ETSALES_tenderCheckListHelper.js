({
	getCheckListDetails : function(component, event, helper) {
		var action = component.get("c.handleCheckList");
        component.set('v.loaded', !component.get('v.loaded'));
        action.setParams({ tenderId : component.get("v.recordId") });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                //console.log('check List Details =  ' + JSON.stringify(response.getReturnValue()));
                component.set('v.loaded', !component.get('v.loaded'));
                component.set("v.checklistData" ,response.getReturnValue());
				console.log('check List Details-------------------->  ' + JSON.stringify(component.get("v.checklistData.checklist")));
                var listofCheckList = component.get("v.checklistData.checklist");
                console.log('size----------->>>>>>>>'+listofCheckList.size);
            }
            else if (state === "INCOMPLETE") {
                // do something
            }
            else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error message: " + 
                                 errors[0].message);
                    }
                } else {
                    console.log("Unknown error");
                }
            }
        });
        $A.enqueueAction(action);
        
        
	},
    
    handleSubmitHelper : function(component, event, helper) {
        //console.log('check List Details = '+ JSON.stringify(component.get("v.checkList")));
        var action = component.get("c.saveCheckList");
        component.set('v.loaded', !component.get('v.loaded'));
        //console.log('to save-----> = '+ JSON.stringify(component.get("v.checklistData.checklist")));
        var getcheckline = component.get("v.checklistData.checklist");
        var checklistLine =[];
        for(var items in getcheckline){
            if(getcheckline[items].ETSALES_AddChecklist__c){
                console.log('getcheckline[items].ETSALES_Status__c'+getcheckline[items].ETSALES_Status__c);
                if(getcheckline[items].ETSALES_Status__c == undefined){
                    getcheckline[items].ETSALES_Status__c='Available';
                }
                checklistLine.push(getcheckline[items]);
            }
        }
        console.log('------>final list'+JSON.stringify(checklistLine));
        action.setParams({ 
            checkListItems :checklistLine ,
            tenderId : component.get("v.recordId") 
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            console.log(response.getState());
            if (state === "SUCCESS") {
                console.log('response =  ' + response.getReturnValue());
                if(response.getReturnValue() == 'Success'){
                    component.set('v.loaded', !component.get('v.loaded'));
                    var toastEvent = $A.get("e.force:showToast");
						toastEvent.setParams({
    						 title: 'Success',
    						 type: 'success',
     						message: 'Check list has been created'
						});
						toastEvent.fire();
                    $A.get("e.force:closeQuickAction").fire();
                    
                }else if(state === "ERROR"){
                    var errors = response.getError();
         	   	    console.log('Error ' + errors);
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        "type":"error",
                        "title": "Error",
                        "message":errors[0].message
                    });
                    toastEvent.fire();
                }
            }
            else if (state === "INCOMPLETE") {
                // do something
            }
            else if (state === "ERROR") {
                var errors = response.getError();
                console.log('Error ' + errors);
                var toastEvent = $A.get("e.force:showToast");
               		 toastEvent.setParams({
                        "type":"error",
                        "title": "Error",
                        "message":errors[0].message
                    });
                 toastEvent.fire();
            }
        });
        $A.enqueueAction(action);

    },
    handleStatusChange : function(component, event, helper) {
        var status = component.find("option").get("v.value");
        if(status == 'Requested'){
            alert('onchage');
            //component.set("v.optionstatus", false);
        }
    }
})
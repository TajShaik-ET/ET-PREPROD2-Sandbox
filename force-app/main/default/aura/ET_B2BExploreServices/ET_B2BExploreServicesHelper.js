({
	 getTypesHelper: function(component, event, helper,type)  {
        var action = component.get('c.getTypes');
        action.setParams({
            
        });
         action.setCallback(this, function (a) {
             var state = a.getState(); // get the response state
             if (state == 'SUCCESS') {
                 var result = a.getReturnValue();
                 console.log('result12 '+JSON.stringify(result));
                /* for(var item in result){
                     result[item].isChecked = true;
                 } */
                 console.log('result'+JSON.stringify(result));
                 component.set('v.types',result); 
                 component.set('v.selectedCheckBoxes',result); 
                 this.getServiceTypesHelper(component, event);
             }else{
                 console.log('error ----'+JSON.stringify(a.getError()));
             }
         });
        $A.enqueueAction(action);
              
    },
    
    getServiceTypesHelper : function(component, event, helper,type)  {
        var action = component.get('c.getServiceTypes');
        action.setParams({
            type:  component.get('v.selectedCheckBoxes')
        });
        action.setCallback(this, function (a) {
            var state = a.getState(); // get the response state
            if (state == 'SUCCESS') {
                  component.set('v.serviceTypes',a.getReturnValue()); 
                 }else{
                console.log('error ----'+JSON.stringify(a.getError()));
            }
        });
        $A.enqueueAction(action);
              
    },
    saveOppHelper: function(component, event, helper)  {
        var type= component.get('v.type');
        var oppDesc = component.get('v.opp');
        var existingDesc = oppDesc.Description;
        oppDesc.Description = type+' - '+existingDesc;
        var action = component.get('c.saveOpportunity');
        
        console.log('selectedPreferredLocation=='+component.get('v.selectedPreferredLocation'));
        action.setParams({
            type:  component.get('v.type'),
            opp:  oppDesc, //component.get('v.opp'),
            preferredLocation : component.get('v.selectedPreferredLocation')
            
        });
        action.setCallback(this, function (a) {
            var state = a.getState(); // get the response state
            if (state == 'SUCCESS') {
                  var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "type": "success",
                    "title": "Success!",
                    "message": "The Opportunity with us is created succesfully"
                });
                toastEvent.fire(); 
                 component.set('v.isOpenModel',false);
                 }else{
                console.log('error ----'+JSON.stringify(a.getError()));
            }
        });
        $A.enqueueAction(action);
              
    },
    getLoctionValueHelper: function(component, event, helper)  {
        var action = component.get('c.getPickListValues');
        action.setParams({
            selectedObject:  "Opportunity",
            selectedField:  "Preferred_Location__c"
            
        });
        action.setCallback(this, function (a) {
            var state = a.getState(); // get the response state
            if (state == 'SUCCESS') {
                var result = a.getReturnValue();
                var opts = [];
                for (var i in result){
                    console.log(i);
                    opts.push({
                        label: result[i],
                        value: i
                    });
                }
                component.set("v.preferredLocation", opts);
            }else{
                console.log('error ----'+JSON.stringify(a.getError()));
            }
        });
        $A.enqueueAction(action);
        
    },
})
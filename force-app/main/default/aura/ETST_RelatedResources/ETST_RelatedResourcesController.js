({
    myAction : function(component, event, helper) 
    {
        
        component.set('v.columns', [
            {label: 'First Name', fieldName: 'FirstName', type: 'text' ,  editable: true},
            {label: 'Last Name', fieldName: 'LastName', type: 'text' ,  editable: true}
        ]);
       
       //Commented code by Janardhan - Hanging the page
      /*  var ConList = component.get("c.getRelatedList");
        ConList.setParams
        ({
            recordId: component.get("v.recordId")
        });
        
        ConList.setCallback(this, function(data) 
                            {
                                component.set("v.ResourceList", data.getReturnValue());
                            });
        $A.enqueueAction(ConList);*/
    },
    
    gotoURL:function(component,event,helper){
        console.log('Enter Here');
        var evt = $A.get("e.force:navigateToComponent");
        console.log('evt'+evt);
        evt.setParams({
            componentDef: "c:NewCAseButton3",
            componentAttributes :{
                recordId:component.get("v.recordId"),
                parentobj:'ETST_Student__c',
                resourceRecord:component.get("v.ResourceList")[0]
            }
            
        });
        
        evt.fire();
    }
    
})
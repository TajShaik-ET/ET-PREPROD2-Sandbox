({
	 getRecordTypes : function(component,event,helper){
       // console.log('$$$$$Re56c$$$');
        var action = component.get("c.GetAvailableRecordTypeCase");
       // console.log('$$$$$Rec$$$'+action);
        action.setCallback(this,function(response){
            var state = response.getState();
            console.log('state'+state)
            if(state === "SUCCESS"){
                var returning = [];
                var recordTypes = response.getReturnValue();
               // console.log('$$$$$Rec$$$'+recordTypes);
                for(var key in recordTypes){
                    console.log("Record Type Id: "+key+" Name: "+recordTypes[key]);
                    returning.push({key:key,value:recordTypes[key]});
                }
                component.set("v.availableRecordTypes",returning);
               
            }
            else{
                alert("Temporary Error: There is a problem getting the Record Types.");// Temporary, Will be changed to ToastError.
            } 
           /* else if(state == "ERROR"){
                var errors = response.getError();  
                alert("Temporary Error: "+errors[0].message);
            } */
        });
        $A.enqueueAction(action); 
    },
})
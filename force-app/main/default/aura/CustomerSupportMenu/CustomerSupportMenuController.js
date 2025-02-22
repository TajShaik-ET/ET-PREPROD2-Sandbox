({
    handleSelect: function(component, event, helper) {
        var selected = event.getParam('name');
        if (selected === 'Create_Service_Request') {
            
            var appEvent = $A.get("e.c:ServiceRequestEvent");
            appEvent.setParams({
                "createRequest" : true,
                "reqHistory" : false,
                "escalation" : false,
                "feedback" : false
            });
            appEvent.fire();
        } else if(selected === 'Service_Request_History'){
            var appEvent = $A.get("e.c:ServiceRequestEvent");
            appEvent.setParams({
                "createRequest" : false,
                "reqHistory" : true,
                "escalation" : false,
                "feedback" : false
            });
            appEvent.fire();
        }else if(selected === 'Escalate'){
            var appEvent = $A.get("e.c:ServiceRequestEvent");
            appEvent.setParams({
                "createRequest" : false,
                "reqHistory" : false,
                "escalation" : true,
                "feedback" : false
            });
            appEvent.fire();
            
        }else if(selected === 'Service_Request_Feedback'){
            var appEvent = $A.get("e.c:ServiceRequestEvent");
            appEvent.setParams({
                "createRequest" : false,
                "reqHistory" : false,
                "escalation" : false,
                "feedback" : true
            });
            appEvent.fire();
            
        }
    },
    
})
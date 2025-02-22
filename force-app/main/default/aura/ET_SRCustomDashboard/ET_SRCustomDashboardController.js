({
    scriptsLoaded : function(component, event, helper) { 
        var action = component.get("c.getSpecialRequestDashboardData");
        action.setCallback(this, function(response) {
            var state = response.getState();
           // alert(state);
            if (state === "SUCCESS") {
                let result = response.getReturnValue() ;
                console.log('result='+JSON.stringify(result));
                
                let caseBySchoolVar = result.casesPerSchool;
                helper.casesBySchool(component, event, caseBySchoolVar);  //Cases By School
                
                let caseByStatusVar = result.casesByStatus;
                helper.casesByStatus(component, event, caseByStatusVar);  //Cases By Status
                
                let casesByTypeVar = result.casesByType;
                helper.casesByType(component, event, casesByTypeVar); //Cases By Type
               
                             
            }
        });
        $A.enqueueAction(action);
        
    }, 
})
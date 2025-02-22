({
    scriptsLoaded : function(component, event, helper) { 
        var action = component.get("c.getDashboardData");
        action.setCallback(this, function(response) {
            var state = response.getState();
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
    
   /* ctr : function(cmp, event, helper) {
        var temp = [];
        var temp2 = [];
        var action1 = cmp.get("c.getLineChartMap");
        var action = cmp.get("c.getChartMap");
        action.setCallback(this, function(response){
            if(response.getState() === 'SUCCESS' && response.getReturnValue()){
                temp = response.getReturnValue();
                helper.createGraph(cmp, temp);
            }
        });      
        action1.setCallback(this, function(response){        	    	    
            if(response.getState() === 'SUCCESS' && response.getReturnValue()){
                temp2 = JSON.parse(response.getReturnValue());
                helper.createLineGraph(cmp, temp2);
            }            
        });  
       $A.enqueueAction(action);	
       $A.enqueueAction(action1);
	}*/
})
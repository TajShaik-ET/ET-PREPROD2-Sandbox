({
	doInit : function(component, event, helper) {
       
        
        var utility = component.find("SS_TicketingSystem_UtilityMethods");
        var backendMethod = "getDashboardData";
         var params = {
             
        };
        var promise = utility.executeServerCall(component, backendMethod, params);
        		
        promise.then (
            $A.getCallback(function(response) {
                console.log('response = '+ response);
                var dashbrdWrap = JSON.parse(response);
                component.set('v.totalCount',dashbrdWrap.newCount+dashbrdWrap.ApprovalCount+dashbrdWrap.closedCount+dashbrdWrap.inProgressCount+dashbrdWrap.onHoldCount); 
                component.set('v.newCount',dashbrdWrap.newCount); 
                component.set('v.closedCount',dashbrdWrap.closedCount); 
                component.set('v.inProgressCount',dashbrdWrap.inProgressCount); 
                component.set('v.onHoldCount',dashbrdWrap.onHoldCount); 
                component.set('v.ApprovalCount',dashbrdWrap.ApprovalCount); 
                
            }),
            
            $A.getCallback(function(error) {
                var err = JSON.parse(error);
                var errorToShow = utility.convertToUserFriendlyErrMsg(err.MESSAGE);
                utility.showToast("Ticket Management", errorToShow, "error", "dismissible");
            })
        )
       	this.getUserDetails(component, event, helper);
        
    },
    getUserDetails : function(component, event, helper) {
        // alert('calling getUserDetails');
        var utility = component.find("SS_TicketingSystem_UtilityMethods");
        var backendMethod = "fetchUser";
        var params = {
        };
        var promise = utility.executeServerCall(component, backendMethod, params);
        
        promise.then (
            $A.getCallback(function(response) {
                console.log('response result=41 '+ JSON.parse(response));
                var result = JSON.parse(response);
                component.set('v.Profilename',result.Profile.Name); 
                console.log('v.Profilename'+result.Profile.Name);
                var pro =result.Profile.Name;
                console.log('pro '+pro);
                if(pro.includes('MOE') || pro.includes('Govt') || pro.includes('ESE')){
                    component.set('v.Profilename',true);
                   
                }
                if(pro.includes('HSE')){
                      component.set('v.customerCare',true);
                }
            }),
            
            $A.getCallback(function(error) {
                var err = JSON.parse(error);
                var errorToShow = utility.convertToUserFriendlyErrMsg(err.MESSAGE);
                utility1.showToast("Ticket Management", errorToShow, "error", "dismissible");
            })
        )
    },
    
})
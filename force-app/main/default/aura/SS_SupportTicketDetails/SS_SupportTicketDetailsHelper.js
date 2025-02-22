({
	queryTicketDetails : function(component, event, helper) {
        console.log('-------->insideticket');
		var utility = component.find("SS_TicketingSystem_UtilityMethods");
        var backendMethod = "getTicketDetails";
        console.log('########'+component.get('v.status'));
        var params = {
             "status" : component.get('v.status')
        };
        var promise = utility.executeServerCall(component, backendMethod, params);
        promise.then (
            $A.getCallback(function(response) {
                console.log('response = ' + response); 
                component.set('v.allTickets',JSON.parse(response));
                var allTickts = JSON.parse(response);
                var corousalSize=component.get('v.corousalSize'); 
                component.set('v.currentPageTickets',allTickts.slice(0,corousalSize)); 
                console.log('currentPageTickets ='+allTickts.slice(0,corousalSize));
                component.set('v.totalRecords',allTickts.length);  
                component.set('v.RecordsCount',allTickts.length);
                component.set('v.loaded', !component.get('v.loaded'));
            }),
            $A.getCallback(function(error) {
                var err = JSON.parse(error);
                var errorToShow = utility.convertToUserFriendlyErrMsg(err.MESSAGE);
                utility.showToast("Ticket Management", errorToShow, "error", "dismissible");
            })
        )	
	},
    fetchapprovaldetails : function(component, event, helper) {
        console.log('-------->insideticket');
       var recordId = event.target.dataset.caseid;
 	   if(recordId===null || recordId===undefined)
   		{
       		var recordId = event.getSource().get('v.value');
   		}
     
		var utility = component.find("SS_TicketingSystem_UtilityMethods");
        var backendMethod = "getApprovalDetails";
        var params = {
             "recId" : recordId
        };
        var promise = utility.executeServerCall(component, backendMethod, params);
        promise.then (
            $A.getCallback(function(response) {
                console.log('response = ' + response); 
                var approvalId = JSON.parse(response);
               
               /* var event = $A.get( 'e.force:navigateToSObject' );
   				 if ( event ) {
		        event.setParams({
        	    'recordId' : approvalId
        		}).fire();
				
    			}
                */
                
                 component.set("v.showRecordDetailModal", true);
        		 component.set("v.recordDetailId", approvalId);
        		 component.set("v.recordTypeName", "detail/");
                 
            }),
            $A.getCallback(function(error) {
                var err = JSON.parse(error);
                var errorToShow = utility.convertToUserFriendlyErrMsg(err.MESSAGE);
                utility.showToast("Ticket Management", errorToShow, "error", "dismissible");
            })
        )	
	}
})
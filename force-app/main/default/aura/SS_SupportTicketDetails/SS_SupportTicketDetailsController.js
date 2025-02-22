({
	doInit : function(component, event, helper) {
		helper.queryTicketDetails(component, event, helper);
	},
    naviteToCaseRecord : function(component, event, helper) {
  /*    
   if(recordId===null || recordId===undefined)
   {
       var recordId = event.getSource().get('v.value');
   }
    var event = $A.get( 'e.force:navigateToSObject' );

    if ( event ) {


        event.setParams({
            'recordId' : recordId
        }).fire();

    }
      */
        
         var recordId = event.currentTarget.id;
  	     component.set("v.showRecordDetailModal", true);
        component.set("v.recordDetailId", recordId);
        component.set("v.recordTypeName", "case/");
      
	},
     navigateToapprovalRecord : function(component, event, helper) {
		console.log( 'naviteToCaseRecord' );

        helper.fetchapprovaldetails(component, event, helper);
	},
    
    getPreviousList: function(component, event, helper) {
         $A.util.addClass(component.find("ConfirmDialog1"), 'slds-hide');
        var corousalSize=component.get('v.corousalSize'); 
        var start=component.get('v.start'); 
        start-=corousalSize;
        var allTickets=component.get('v.allTickets'); 
        component.set('v.currentPageTickets',allTickets.slice(start,start+corousalSize)); 
        component.set('v.start',start);
        
     },
    getNextList: function(component, event, helper) {
        $A.util.addClass(component.find("ConfirmDialog1"), 'slds-hide');
        var corousalSize=component.get('v.corousalSize'); 
        var start=component.get('v.start'); 
        start+=corousalSize;
        var allTickets=component.get('v.allTickets'); 
        component.set('v.currentPageTickets',allTickets.slice(start,start+corousalSize)); 
        component.set('v.start',start); 
    },
    
    openCloseCaseModal : function(component, event, helper) {
        var ticket = event.getSource().get('v.value');
        console.log('ticket  = '+ ticket);
        component.set('v.ticketId',ticket);        
        component.set('v.isCancelModal',true);
    },
    
    openReopenCaseModal : function(component, event, helper) {
        var ticket = event.getSource().get('v.value');
        console.log('ticket  = '+ ticket);
        component.set('v.ticketId',ticket);        
        component.set('v.isReopenModal',true);
    },
    
    openAddCommentsModal : function(component, event, helper) {
        var ticket = event.getSource().get('v.value');
        console.log('ticket  = '+ ticket);
        component.set('v.ticketId',ticket);        
        component.set('v.isAddCommentModal',true);
    },
    
    openViewCommentsModal : function(component, event, helper) {
        var ticket = event.getSource().get('v.value');
        console.log('ticket  = '+ ticket);
        component.set('v.ticketId',ticket);        
        component.set('v.isViewCommentsModal',true);
    },
 
 
 })
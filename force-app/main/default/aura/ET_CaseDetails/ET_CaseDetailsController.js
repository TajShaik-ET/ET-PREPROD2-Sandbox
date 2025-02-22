({
    doInit: function(component, event, helper)  {
        
         var url_string = window.location.href; 
        var url = new URL(url_string);
        var service = url.searchParams.get("ser");
        if(service==null || service=='' || service==undefined){
            component.set('v.service',"All");
        } 
        else if(service='etst'){
            component.set('v.service',"School Transport");
        }
        helper.doInit(component, event, helper);
        helper.setCommunityLanguage(component, event,helper);
    },
    
    handleDone:function(component, event, helper){ 
        $A.util.toggleClass(component.find("ConfirmDialog1"), 'slds-hide');
    },
    
    getPreviousList: function(component, event, helper) {
         $A.util.addClass(component.find("ConfirmDialog1"), 'slds-hide');
        var corousalSize=component.get('v.corousalSize'); 
        var start=component.get('v.start'); 
        start-=corousalSize;
        var deliveryData=component.get('v.deliveryData'); 
        component.set('v.currentData',deliveryData.slice(start,start+corousalSize)); 
        component.set('v.start',start);
        
     },
     getNextList: function(component, event, helper) {
          $A.util.addClass(component.find("ConfirmDialog1"), 'slds-hide');
        var corousalSize=component.get('v.corousalSize'); 
        var start=component.get('v.start'); 
        start+=corousalSize;
        var deliveryData=component.get('v.deliveryData'); 
        component.set('v.currentData',deliveryData.slice(start,start+corousalSize)); 
        component.set('v.start',start); 
    },
    searchRequest: function(component, event, helper) {
        $A.util.addClass(component.find("ConfirmDialog1"), 'slds-hide');
        var searchKey=component.get('v.searchText').toLowerCase();
        if(searchKey.length>2){
            var deliveryData = component.get('v.deliveryData');
        
            var fileredData =  deliveryData.filter(function(item) {
                return (item.CaseNumber.toLowerCase().indexOf(searchKey) !== -1);
                //(item.Status.toLowerCase().indexOf(searchKey) !== -1)||
            });
            component.set('v.currentData',fileredData);
            component.set('v.totalRecords',fileredData.size); 
        }else{
            component.set('v.start',0);
            var start=component.get('v.start'); 
            var corousalSize=component.get('v.corousalSize'); 
            var deliveryData=component.get('v.deliveryData'); 
            component.set('v.currentData',deliveryData.slice(start,start+corousalSize)); 
            component.set('v.totalRecords',component.get("v.RecordsCount"));
        }
    
    },
    sortData: function(component, event, helper) {
        $A.util.addClass(component.find("ConfirmDialog1"), 'slds-hide');
        var item=event.getSource().get('v.value');
        var currentData=component.get('v.currentData'); 
        currentData.sort((a, b) => (parseInt(a.item) > parseInt(b.item)) ? 1 : -1)
        component.set('v.currentData',currentData); 
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
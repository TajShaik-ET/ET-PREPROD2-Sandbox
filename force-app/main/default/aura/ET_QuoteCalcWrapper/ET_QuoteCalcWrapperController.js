({
    doInit : function(component, event, helper) {
        var url_string = window.location.href;
        var url = new URL(url_string);
        var recordId = url.searchParams.get("recordId");
        //alert('inside workforce detail ,recordId'+recordId);   
        if(recordId != null && recordId != '' && recordId != undefined) {
            component.set("v.quoteId",recordId);
        }
        helper.getAllWorkforceCalcDetails(component,event,helper);
    },
    
    handleLineNoChange : function(component, event, helper) {
        var tabIds = ['vehicleCalcTab' , 'driverCalcTab' , 'nannyCalcTab' , 'supervisorCalcTab','coordinatorCalcTab','accountantCalcTab',
                      'otherEmpCalcTab',
                     'financialAnalysisCalcTab'];
        
        var response = component.get('v.response');
        
        if(response){
            component.set('v.calcDetailsWpr',response[component.get("v.lineNumber")]);
            component.set('v.rentalPriceHeaderInfo',response[component.get("v.lineNumber")].quoteHeaderInfo);
        }
        
        if(tabIds != undefined && tabIds.length){
            for(var tabId of tabIds){
                var tabComp = component.find(tabId); 
                if(tabComp){
                    tabComp.handleLineNumberChange(component.get("v.lineNumber"));
                }
            }
        }     
    }
})
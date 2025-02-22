({
    doInit : function(component, event, helper) {
        var url_string = window.location.href;
        var url = new URL(url_string);
        var recordId = url.searchParams.get("recordId");
        //alert('inside workforce detail ,recordId'+recordId);   
        if(recordId != null && recordId != '' && recordId != undefined) {
            component.set("v.quoteId",recordId);
        }
        helper.getworkforceCalcDetails(component,event,helper);
    },
    
    getDataWithRespectToLine : function(component, event, helper) {
        helper.resetAllLines(component, event, helper);
        var params = event.getParam('arguments');
        var lineNo = params.lineNo;
        helper.getPageData(component,event,helper,lineNo);
    },
    
})
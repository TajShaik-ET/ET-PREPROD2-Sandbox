({
    
    doInit: function(component,event,helper){
        var url_string = window.location.href;
        var url = new URL(url_string);
        var RecordId = url.searchParams.get("recordId"); 
        if(RecordId != null && RecordId != '' && RecordId != undefined){
            helper.UserPermissions(component,event,helper);
           // helper.getSObjectName(component,RecordId,helper);
        }
        //SK- 
       // alert(component.get("v.OpprecordTypeName"));
        if(component.get("v.OpprecordTypeName")==undefined){
            var compEvent = component.getEvent("OpprecordTypeNameEvent");
            compEvent.setParams({
                "oppRecordType": "ET_ServiceRequestData"
            });
            compEvent.fire();
        }
    },

    //SK- 
    getOpprecordTypeName: function(component, event, helper){
        var params = event.getParam('arguments');
        var fieldDivIds = ["Oppleasediv1", "Oppleasediv2", "Oppleasediv3", "Oppleasediv4", "Oppleasediv5", "Oppleasediv6"];
        
        if(params){
            component.set("v.OpprecordTypeName", params.OpprecordTypeName);
            /*if(params.OpprecordTypeName == 'Leasing/ Rental'){
                fieldDivIds.forEach(function(id) {
                    var fieldDivCmp = component.find(id);
                    $A.util.addClass(fieldDivCmp, 'slds-hide');
                });
                console.log('inside getOpprecordTypeName of ET_ServiceRequestData ' + JSON.stringify(component.get("v.OpprecordTypeName")));
            } else {
                fieldDivIds.forEach(function(id) {
                    var fieldDivCmp = component.find(id);
                    $A.util.removeClass(fieldDivCmp, 'slds-hide');
                });
            }*/
        }
    },

    updateSelectedTabs : function(component, event, helper) {
        var selectedCheckbox = event.getSource().getLocalId();
       // console.log(selectedCheckbox);
        //console.log('From Aura Id ',component.find(selectedCheckbox).get("v.checked"));
        var selected = component.find(selectedCheckbox).get("v.checked");
        helper.updateTabs(component,selectedCheckbox,selected);
            //event.getSource().get("v.value");
        //console.log(selected);
        
       
    },

   
    setSelectedTab: function(component,event,helper){
        var args = event.getParam("arguments");
        var selectedTab = args.selectedTab;
        var selected = args.selected;
        (component.find(selectedTab)).set("v.checked",selected);
        helper.updateTabs(component,selectedTab,selected);
    }
})
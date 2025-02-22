({
    doInit : function(component, event, helper) {
        var url_string = window.location.href;
        var url = new URL(url_string);
        var RecordId = url.searchParams.get("c__recordId"); 
        
        var pageReference = component.get("v.pageReference");
        
        if(pageReference.state.c__recordId){
            helper.getSObjectName(component,pageReference.state.c__recordId,helper);
            helper.profilePermissions(component, event, helper);
            /*--SK--*/
            helper.getVehicleDetails(component,pageReference.state.c__recordId,helper);
        }
        
        /* if(RecordId != null && RecordId != '' && RecordId != undefined){
            helper.getSObjectName(component,RecordId,helper);
            helper.profilePermissions(component, event, helper);
        }*/
    },
    
    handleSave : function(component, event, helper) {
        debugger;
        var wrapperCmp = component.find('bodyComponent');
        if(wrapperCmp!=undefined){
            wrapperCmp.getData();
        }
    },
    
    handleAlterRatesSave : function(component, event, helper) {
        var wrapperCmp = component.find('bodyComponent');
        if(wrapperCmp!=undefined){
            wrapperCmp.getAlterRatesData();
        }
    },
    
    handleCustomizePricing : function(component, event, helper) {
        var wrapperCmp = component.find('bodyComponent');
        if(wrapperCmp!=undefined){
            wrapperCmp.handleCustomizePricingClicked();
        }
    },
    
    handleQuoteButton : function(component,event, helper){
        var wrapperCmp = component.find('bodyComponent');
        if(wrapperCmp!=undefined){
            wrapperCmp.generateQuotation();
        }
    },
    
    handleTotalProject :  function(component,event, helper){
        var wrapperCmp = component.find('bodyComponent');
        if(wrapperCmp!=undefined){
            wrapperCmp.generateTotalProject();
        }
    },
    
    handleOpenQuoteButton: function (component, event, helper) {
        var wrapperCmp = component.find('bodyComponent');
        if (wrapperCmp != undefined) {
            var quoteDetail = component.get("v.quoteDetail");
            console.log('quoteDetail:1 ' + JSON.stringify(quoteDetail));
            wrapperCmp.set("v.quoteDetail", quoteDetail);
            wrapperCmp.openQuotation(); 
        }
    },
    
    handleCancelClick: function(component,event,helper){
        var wrapperCmp = component.find('bodyComponent');
        if(wrapperCmp!=undefined){
            wrapperCmp.handleCancelButton();
        }
        
    },
    handleAlterRateEvent : function(component, event, helper) {
        var alterRatesObj = event.getParam("alterRatesObj");
        var isAlterRateChanged = event.getParam("isAlterRateChanged");
        console.log('alterRatesObj form = '+JSON.stringify(alterRatesObj) );
        component.set("v.alterRatesObj", alterRatesObj);
    },
    deleteAlterRates: function(component, event, helper) {
        var r = confirm("Are you sure you want to Delete this Quotation. Please confirm.");
        if (r == true) {
            var wrapperCmp = component.find('bodyComponent');
            if(wrapperCmp!=undefined){
                wrapperCmp.deleteAlterRatesData();
            }
        } 
        
    },
    rejectServiceRequest: function(component, event, helper) {
        var wrapperCmp = component.find('bodyComponent');
        if(wrapperCmp!=undefined){
            wrapperCmp.rejectRequestData();
        }
    },
    
    handleQuoteSubmit: function (component, event, helper) {
        var wrapperCmp = component.find('bodyComponent');
        if (wrapperCmp != undefined) {
            var quoteDetail = component.get("v.quoteDetail");
            console.log('quoteDetail:2 '+JSON.stringify(quoteDetail));
            wrapperCmp.set("v.quoteDetail", quoteDetail);
            //wrapperCmp.set("v.quoteDetail", quoteDetail.Quote_Type__c);
            wrapperCmp.submitQuoteForApproval(component.get('v.quoteId'));
            wrapperCmp.checkValidations();
        }
    },
    
    submitForApproval:function(component, event, helper){
        var wrapperCmp = component.find('bodyComponent');
        if(wrapperCmp!=undefined){
            wrapperCmp.submitToHeadOfSales(component.get('v.quoteId'));
        }
    },

    handlechangeInTabs: function (component, message, helper) {
        if (message && message.getParam('selectedTabs')) {
            console.log('selectedTabs: ' + message.getParam('selectedTabs'));
            var tabs = message.getParam('selectedTabs');
            var selectedTabs = '';
            for (var key in tabs) {
                console.log('key: ' + key);
                console.log('tab: ' + tabs[key]);
                if (selectedTabs == '') {
                    selectedTabs = tabs[key];
                } else {
                    selectedTabs = selectedTabs + ';' + tabs[key];
                }
            }
            component.set("v.selectedTabs", selectedTabs);
        }
        console.log('selectedTabs: ' + component.get("v.selectedTabs"));
        //alert('selectedTabs: '+component.get("v.selectedTabs"));
    },

    requestInitiateQuotation:function(component, event, helper){
        helper.sendEmailNotification(component, event, helper, 'requestInitiateQuotation');
    },

    validateQuotation:function(component, event, helper){
        helper.sendEmailNotification(component, event, helper, 'validateQuotation');
    },
})
({
    doinit : function(component, event, helper) {
        console.log('alterRatesObj in alter rate component= '+JSON.stringify(component.get("v.alterRatesObj")) );
        var alterRatesObj = component.get('v.alterRatesObj');
        component.set('v.alterRatesObj1',JSON.parse(JSON.stringify(alterRatesObj)));

        /*for(var idx = 0; idx < alterRatesObj.length; idx++){
            if(alterRatesObj[idx].service==component.get('v.serviceName')){
                for (var jdx = 0; jdx < alterRatesObj[idx].elementRatesLineObj.length; jdx++) {
                    if(alterRatesObj[idx].elementRatesLineObj[jdx].Line==component.get('v.Line')){
                        component.set('v.alterRatesObj1',JSON.parse(JSON.stringify(alterRatesObj[idx].elementRatesLineObj[jdx].elementRatesYearObj)));
                    }
                }
            }
        }*/
    },
    editEliment: function(component, event, helper) {
        var element=event.getSource().get("v.value");
        var alterRatesObj = component.get('v.alterRatesObj');
        console.log('alterRatesObj = '+JSON.stringify(alterRatesObj) );
        for(var idx = 0; idx < alterRatesObj.length; idx++){
            if(alterRatesObj[idx].service==component.get('v.serviceName')){
                for (var jdx = 0; jdx < alterRatesObj[idx].elementRatesLineObj.length; jdx++) {
                    if(alterRatesObj[idx].elementRatesLineObj[jdx].Line==component.get('v.Line')){
                        for (var kdx = 0; kdx < alterRatesObj[idx].elementRatesLineObj[jdx].elementRatesYearObj.length; kdx++) {
                            if(kdx==element){
                                if(!alterRatesObj[idx].elementRatesLineObj[jdx].elementRatesYearObj[kdx].isRowEdit)
                                	alterRatesObj[idx].elementRatesLineObj[jdx].elementRatesYearObj[kdx].isRowEdit=true;
                                else 
                                    alterRatesObj[idx].elementRatesLineObj[jdx].elementRatesYearObj[kdx].isRowEdit=false;
                                for(var i = 0; i < alterRatesObj[idx].elementRatesLineObj[jdx].elementRatesYearObj[kdx].elementRatesLineItemsObj.length; i++){
                                    if(!alterRatesObj[idx].elementRatesLineObj[jdx].elementRatesYearObj[kdx].elementRatesLineItemsObj[i].isEdit)
                                        alterRatesObj[idx].elementRatesLineObj[jdx].elementRatesYearObj[kdx].elementRatesLineItemsObj[i].isEdit=true;
                                    else 
                                        alterRatesObj[idx].elementRatesLineObj[jdx].elementRatesYearObj[kdx].elementRatesLineItemsObj[i].isEdit=false;
                                }
                            }
                        }
                    }
                }
            }
        }
        component.set('v.alterRatesObj', alterRatesObj);
    },
    handleSelect: function(component, event, helper) {
        var element=event.getSource().get("v.value");
        console.log('element = '+JSON.stringify(element) );
        var alterRatesObj = component.get('v.alterRatesObj');
        console.log('alterRatesObj = '+JSON.stringify(alterRatesObj) );
        let cloneElements;
        for(var idx = 0; idx < alterRatesObj.length; idx++){
            if(alterRatesObj[idx].service==component.get('v.serviceName')){
                for (var jdx = 0; jdx < alterRatesObj[idx].elementRatesLineObj.length; jdx++) {
                    if(alterRatesObj[idx].elementRatesLineObj[jdx].Line==component.get('v.Line')){
                        for (var kdx = 0; kdx < alterRatesObj[idx].elementRatesLineObj[jdx].elementRatesYearObj.length; kdx++) {
                            if(kdx==element){//alterRatesObj[idx].elementRatesLineObj[jdx].elementRatesYearObj[kdx].isSelected){
                                cloneElements=alterRatesObj[idx].elementRatesLineObj[jdx].elementRatesYearObj[kdx];
                            }
                        }
                    }
                }
            }
        }
        console.log('cloneElements = '+JSON.stringify(cloneElements) );
        if(cloneElements!= undefined && cloneElements!=null){
            for(var idx = 0; idx < alterRatesObj.length; idx++){
                if(alterRatesObj[idx].service==component.get('v.serviceName')){
                    for (var jdx = 0; jdx < alterRatesObj[idx].elementRatesLineObj.length; jdx++) {
                        if(alterRatesObj[idx].elementRatesLineObj[jdx].Line!=component.get('v.Line')){
                            for(var kdx = 0; kdx < alterRatesObj[idx].elementRatesLineObj[jdx].elementRatesYearObj.length; kdx++) {
                                if(kdx==element){
                                    console.log('kdx: '+kdx);
                                    console.log('elementRatesLineItemsObj = '+JSON.stringify(alterRatesObj[idx].elementRatesLineObj[jdx].elementRatesYearObj[kdx].elementRatesLineItemsObj));
                                    console.log('clone elementRatesLineItemsObj: '+cloneElements.elementRatesLineItemsObj);
                                    for(var i = 0; i < alterRatesObj[idx].elementRatesLineObj[jdx].elementRatesYearObj[kdx].elementRatesLineItemsObj.length; i++){
                                        if(alterRatesObj[idx].elementRatesLineObj[jdx].elementRatesYearObj[kdx].elementRatesLineItemsObj[i].elementRate!=null){
                                            if(cloneElements.elementRatesLineItemsObj[i].elementRate!=undefined && cloneElements.elementRatesLineItemsObj[i].elementRate!=null)
                                                alterRatesObj[idx].elementRatesLineObj[jdx].elementRatesYearObj[kdx].elementRatesLineItemsObj[i].elementRate=cloneElements.elementRatesLineItemsObj[i].elementRate;
                                            else
                                                alterRatesObj[idx].elementRatesLineObj[jdx].elementRatesYearObj[kdx].elementRatesLineItemsObj[i].elementRate=null;
                                        }
                                    }
                                    if(cloneElements.requestedBy!=undefined && cloneElements.requestedBy!=null)
                                        alterRatesObj[idx].elementRatesLineObj[jdx].elementRatesYearObj[kdx].requestedBy=cloneElements.requestedBy;
                                    else
                                        alterRatesObj[idx].elementRatesLineObj[jdx].elementRatesYearObj[kdx].requestedBy=null;
                                    if(cloneElements.approvedBy!=undefined && cloneElements.approvedBy!=null)
                                        alterRatesObj[idx].elementRatesLineObj[jdx].elementRatesYearObj[kdx].approvedBy=cloneElements.approvedBy;
                                    else
                                        alterRatesObj[idx].elementRatesLineObj[jdx].elementRatesYearObj[kdx].approvedBy=null;
                                    if(cloneElements.alteringReason!=undefined && cloneElements.alteringReason!=null)
                                        alterRatesObj[idx].elementRatesLineObj[jdx].elementRatesYearObj[kdx].alteringReason=cloneElements.alteringReason;
                                    else
                                        alterRatesObj[idx].elementRatesLineObj[jdx].elementRatesYearObj[kdx].alteringReason=null;
                                }
                            }
                        }
                    }
                }
            }
            component.set('v.alterRatesObj', alterRatesObj);
            var compEvent = component.getEvent("alterRateEvent");
            compEvent.setParams({
                "alterRatesObj" : JSON.parse(JSON.stringify(alterRatesObj))
            });
            compEvent.fire();
        }
    },    
    handleSelectAll: function(component, event, helper) {
        let isAllSelected=false;
        var element=event.getSource().get("v.value");
        var alterRatesObj = component.get('v.alterRatesObj');
        console.log('alterRatesObj = '+JSON.stringify(alterRatesObj) );
        for(var idx = 0; idx < alterRatesObj.length; idx++){
            if(alterRatesObj[idx].service==component.get('v.serviceName')){
                for (var jdx = 0; jdx < alterRatesObj[idx].elementRatesLineObj.length; jdx++) {
                    if(alterRatesObj[idx].elementRatesLineObj[jdx].Line==component.get('v.Line')){
                        for(var kdx = 0; kdx < alterRatesObj[idx].elementRatesLineObj[jdx].elementRatesYearObj.length; kdx++) {
                            alterRatesObj[idx].elementRatesLineObj[jdx].elementRatesYearObj[kdx].isSelected=true;
                            isAllSelected=true;
                        }
                    }
                }
            }
        }
        console.log('isAllSelected end = '+isAllSelected);
        if(isAllSelected){
            component.set('v.alterRatesObj', alterRatesObj);
            var compEvent = component.getEvent("alterRateEvent");
            compEvent.setParams({
                "alterRatesObj" : JSON.parse(JSON.stringify(alterRatesObj))
            });
            compEvent.fire();
        }
    },
    //Taj
    handleChange: function (component, event, helper) {
        var isPricingTeam = component.get('v.isPricingTeam');
        console.log('isPricingTeam:',isPricingTeam);
        var inputName = event.getSource().get("v.name");
        var arrayName = inputName.split(':');
        var elementLabel = arrayName[0];
        var index = arrayName[1];
        if (!isPricingTeam && elementLabel == 'Required Operating Profit Margin') {
            var alterRatesObj = component.get('v.alterRatesObj');
            //console.log("alterRatesObj: " + JSON.stringify(alterRatesObj));
            var inputValue = event.getSource().get("v.value");
            if (inputValue < 11.50) {
                helper.showToast(component, event, helper, 'Warning', 'The required profit margin must not be less than 11.50.', 'warning', 'dismissible');
                for (var idx = 0; idx < alterRatesObj.length; idx++) {
                    if (alterRatesObj[idx].service == component.get('v.serviceName')) {
                        for (var jdx = 0; jdx < alterRatesObj[idx].elementRatesLineObj.length; jdx++) {
                            if (alterRatesObj[idx].elementRatesLineObj[jdx].Line == component.get('v.Line')) {
                                for (var kdx = 0; kdx < alterRatesObj[idx].elementRatesLineObj[jdx].elementRatesYearObj.length; kdx++) {
                                    if (alterRatesObj[idx].elementRatesLineObj[jdx].elementRatesYearObj[kdx].elementLabel == elementLabel) {
                                       if (alterRatesObj[idx].elementRatesLineObj[jdx].elementRatesYearObj[kdx].elementRatesLineItemsObj[index].elementRate < 11.50) {
                                            alterRatesObj[idx].elementRatesLineObj[jdx].elementRatesYearObj[kdx].elementRatesLineItemsObj[index].elementRate = '11.50';
                                            console.log('elementRatesLineItemsObj = ' + JSON.stringify(alterRatesObj[idx].elementRatesLineObj[jdx].elementRatesYearObj[kdx].elementRatesLineItemsObj));
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
                component.set('v.alterRatesObj', alterRatesObj);
                /*var compEvent = component.getEvent("alterRateEvent");
                compEvent.setParams({
                    "alterRatesObj": JSON.parse(JSON.stringify(alterRatesObj))
                });
                compEvent.fire();*/
            }
        }
    },
    closeAlterRates: function(component, event, helper) {
		component.set('v.showAlterRates', false);
        /*console.log('alterRatesObj1 in = '+JSON.stringify(component.get("v.alterRatesObj1")) );
        var alterRatesObj = component.get('v.alterRatesObj');
        for(var idx = 0; idx < alterRatesObj.length; idx++){
            if(alterRatesObj[idx].service==component.get('v.serviceName')){
                for (var jdx = 0; jdx < alterRatesObj[idx].elementRatesLineObj.length; jdx++) {
                    if(alterRatesObj[idx].elementRatesLineObj[jdx].Line==component.get('v.Line')){
                        alterRatesObj[idx].elementRatesLineObj[jdx].elementRatesYearObj=component.get("v.alterRatesObj1");
                    }
                }
            }
        }
        component.set('v.alterRatesObj', alterRatesObj);*/
        component.set('v.alterRatesObj',component.get("v.alterRatesObj1"));
    },
    submitAlterRates: function(component, event, helper) {
        let isDataMissing=false;
        var alterRatesObj = component.get('v.alterRatesObj');
        if(alterRatesObj.length>0){
            for(var idx = 0; idx < alterRatesObj.length; idx++){
                if(alterRatesObj[idx].service==component.get('v.serviceName')){
                    for (var jdx = 0; jdx < alterRatesObj[idx].elementRatesLineObj.length; jdx++) {
                        if(alterRatesObj[idx].elementRatesLineObj[jdx].Line==component.get('v.Line')){
                            for(var kdx = 0; kdx < alterRatesObj[idx].elementRatesLineObj[jdx].elementRatesYearObj.length; kdx++) {
                                if(alterRatesObj[idx].elementRatesLineObj[jdx].elementRatesYearObj[kdx].isRowEdit){
                                   if((alterRatesObj[idx].elementRatesLineObj[jdx].elementRatesYearObj[kdx].requestedBy==null 
                                      || alterRatesObj[idx].elementRatesLineObj[jdx].elementRatesYearObj[kdx].requestedBy=='') 
                                      && (alterRatesObj[idx].elementRatesLineObj[jdx].elementRatesYearObj[kdx].approvedBy==null 
                                      || alterRatesObj[idx].elementRatesLineObj[jdx].elementRatesYearObj[kdx].approvedBy=='')
                                      && (alterRatesObj[idx].elementRatesLineObj[jdx].elementRatesYearObj[kdx].alteringReason==null 
                                      || alterRatesObj[idx].elementRatesLineObj[jdx].elementRatesYearObj[kdx].alteringReason=='')){
                                   		alterRatesObj[idx].elementRatesLineObj[jdx].elementRatesYearObj[kdx].errorMsg='Please fill Requested By, Approved By and Reason.';
                                        isDataMissing=true;
                                   }else if((alterRatesObj[idx].elementRatesLineObj[jdx].elementRatesYearObj[kdx].requestedBy==null 
                                      || alterRatesObj[idx].elementRatesLineObj[jdx].elementRatesYearObj[kdx].requestedBy=='') 
                                      && (alterRatesObj[idx].elementRatesLineObj[jdx].elementRatesYearObj[kdx].approvedBy==null 
                                      || alterRatesObj[idx].elementRatesLineObj[jdx].elementRatesYearObj[kdx].approvedBy=='')){
                                   		alterRatesObj[idx].elementRatesLineObj[jdx].elementRatesYearObj[kdx].errorMsg='Please fill Requested By and Approved By.';
                                        isDataMissing=true;
                                   }else if((alterRatesObj[idx].elementRatesLineObj[jdx].elementRatesYearObj[kdx].requestedBy==null 
                                      || alterRatesObj[idx].elementRatesLineObj[jdx].elementRatesYearObj[kdx].requestedBy=='') 
                                      && (alterRatesObj[idx].elementRatesLineObj[jdx].elementRatesYearObj[kdx].alteringReason==null 
                                      || alterRatesObj[idx].elementRatesLineObj[jdx].elementRatesYearObj[kdx].alteringReason=='')){
                                   		alterRatesObj[idx].elementRatesLineObj[jdx].elementRatesYearObj[kdx].errorMsg='Please fill Requested By and Reason.';
                                        isDataMissing=true;
                                   }else if((alterRatesObj[idx].elementRatesLineObj[jdx].elementRatesYearObj[kdx].approvedBy==null 
                                      || alterRatesObj[idx].elementRatesLineObj[jdx].elementRatesYearObj[kdx].approvedBy=='')
                                      && (alterRatesObj[idx].elementRatesLineObj[jdx].elementRatesYearObj[kdx].alteringReason==null 
                                      || alterRatesObj[idx].elementRatesLineObj[jdx].elementRatesYearObj[kdx].alteringReason=='')){
                                   		alterRatesObj[idx].elementRatesLineObj[jdx].elementRatesYearObj[kdx].errorMsg='Please fill Approved By and Reason.';
                                        isDataMissing=true;
                                   }else if(alterRatesObj[idx].elementRatesLineObj[jdx].elementRatesYearObj[kdx].requestedBy==null 
                                      || alterRatesObj[idx].elementRatesLineObj[jdx].elementRatesYearObj[kdx].requestedBy==''){
                                       alterRatesObj[idx].elementRatesLineObj[jdx].elementRatesYearObj[kdx].errorMsg='Please fill Requested By to submit.';
                                       isDataMissing=true;
                                   }else if(alterRatesObj[idx].elementRatesLineObj[jdx].elementRatesYearObj[kdx].approvedBy==null 
                                      || alterRatesObj[idx].elementRatesLineObj[jdx].elementRatesYearObj[kdx].approvedBy==''){
                                       alterRatesObj[idx].elementRatesLineObj[jdx].elementRatesYearObj[kdx].errorMsg='Please fill Approved By to submit.';
                                       isDataMissing=true;
                                   }else if(alterRatesObj[idx].elementRatesLineObj[jdx].elementRatesYearObj[kdx].alteringReason==null 
                                      || alterRatesObj[idx].elementRatesLineObj[jdx].elementRatesYearObj[kdx].alteringReason==''){
                                       alterRatesObj[idx].elementRatesLineObj[jdx].elementRatesYearObj[kdx].errorMsg='Please fill Alter Reason to submit.';
                                       isDataMissing=true;
                                   }else {
                                       alterRatesObj[idx].elementRatesLineObj[jdx].elementRatesYearObj[kdx].errorMsg='';
                                   }
                                }
                            }
                        }
                    }
                }
            }
        }
        if(isDataMissing)
        	component.set('v.alterRatesObj', alterRatesObj);
        else {
            let isAllSelected=false;
            let cloneAllElements= new Map();
            for(var idx = 0; idx < alterRatesObj.length; idx++){
                if(alterRatesObj[idx].service==component.get('v.serviceName')){
                    for (var jdx = 0; jdx < alterRatesObj[idx].elementRatesLineObj.length; jdx++) {
                        if(alterRatesObj[idx].elementRatesLineObj[jdx].Line==component.get('v.Line')){
                            for(var kdx = 0; kdx < alterRatesObj[idx].elementRatesLineObj[jdx].elementRatesYearObj.length; kdx++) {
                                if(alterRatesObj[idx].elementRatesLineObj[jdx].elementRatesYearObj[kdx].isSelected)
                                    cloneAllElements.set(kdx,alterRatesObj[idx].elementRatesLineObj[jdx].elementRatesYearObj[kdx]);
                            }
                        }
                    }
                }
            }
            if(cloneAllElements.size>0){
                for(var idx = 0; idx < alterRatesObj.length; idx++){
                    if(alterRatesObj[idx].service==component.get('v.serviceName')){
                        for (var jdx = 0; jdx < alterRatesObj[idx].elementRatesLineObj.length; jdx++) {
                            if(alterRatesObj[idx].elementRatesLineObj[jdx].Line!=component.get('v.Line')){
                                for(var kdx = 0; kdx < alterRatesObj[idx].elementRatesLineObj[jdx].elementRatesYearObj.length; kdx++) {
                                    if(cloneAllElements.has(kdx)){
                                        if(cloneAllElements.get(kdx).elementRatesLineItemsObj.length>0){
                                            for(var i = 0; i < alterRatesObj[idx].elementRatesLineObj[jdx].elementRatesYearObj[kdx].elementRatesLineItemsObj.length; i++){
                                                if(alterRatesObj[idx].elementRatesLineObj[jdx].elementRatesYearObj[kdx].elementRatesLineItemsObj[i].elementRate!=null){
                                                    if(cloneAllElements.get(kdx).elementRatesLineItemsObj[i].elementRate!=undefined && cloneAllElements.get(kdx).elementRatesLineItemsObj[i].elementRate!='' && cloneAllElements.get(kdx).elementRatesLineItemsObj[i].elementRate!=null){
                                                        alterRatesObj[idx].elementRatesLineObj[jdx].elementRatesYearObj[kdx].elementRatesLineItemsObj[i].elementRate=cloneAllElements.get(kdx).elementRatesLineItemsObj[i].elementRate;
                                                    }else {
                                                        alterRatesObj[idx].elementRatesLineObj[jdx].elementRatesYearObj[kdx].elementRatesLineItemsObj[i].elementRate=null;
                                                    }
                                                }
                                            }
                                        }
                                        if(cloneAllElements.get(kdx).requestedBy!=undefined && cloneAllElements.get(kdx).requestedBy!=null)
                                            alterRatesObj[idx].elementRatesLineObj[jdx].elementRatesYearObj[kdx].requestedBy=cloneAllElements.get(kdx).requestedBy;
                                        else
                                            alterRatesObj[idx].elementRatesLineObj[jdx].elementRatesYearObj[kdx].requestedBy=null;
                                        if(cloneAllElements.get(kdx).approvedBy!=undefined && cloneAllElements.get(kdx).approvedBy!=null)
                                            alterRatesObj[idx].elementRatesLineObj[jdx].elementRatesYearObj[kdx].approvedBy=cloneAllElements.get(kdx).approvedBy;
                                        else
                                            alterRatesObj[idx].elementRatesLineObj[jdx].elementRatesYearObj[kdx].approvedBy=null;
                                        if(cloneAllElements.get(kdx).alteringReason!=undefined && cloneAllElements.get(kdx).alteringReason!=null)
                                            alterRatesObj[idx].elementRatesLineObj[jdx].elementRatesYearObj[kdx].alteringReason=cloneAllElements.get(kdx).alteringReason;
                                        else
                                            alterRatesObj[idx].elementRatesLineObj[jdx].elementRatesYearObj[kdx].alteringReason=null;
                                    }
                                }
                            }
                        }
                    }
                }
            }
            component.set('v.alterRatesObj', JSON.parse(JSON.stringify(alterRatesObj)));
            component.set('v.alterRatesObj1',JSON.parse(JSON.stringify(alterRatesObj)));
			
            var compEvent = component.getEvent("alterRateEvent");
            compEvent.setParams({
                "alterRatesObj" : JSON.parse(JSON.stringify(alterRatesObj))
            });
            compEvent.fire();
            
            //fire the event to notify main Wrapper component - ET_ServiceRequestWrapper component...
            var compEvent = component.getEvent("notifyAlterRatesEvent");
            compEvent.setParams({
                "alterRatesObj" : JSON.parse(JSON.stringify(alterRatesObj)) //component.get("v.alterRatesObj") 
            });
            component.set('v.showAlterRates', false);
            alert('Please change the Rates in any other line if needed and Proceed to Click on \'Save Alter Rates\' to Create New Quotation with Changed Rates.');
            compEvent.fire();
        }
    },
})
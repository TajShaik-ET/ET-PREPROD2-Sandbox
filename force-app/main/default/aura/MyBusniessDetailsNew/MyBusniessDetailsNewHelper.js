({
    doInitHelper: function(component, event, helper)  {
        
        
        
    },
    
    getSalesAgreements:function(component, event, helper)  {       
        
        var action = component.get('c.getSaleAgreementInfo');      
        action.setParams({
            AccountId : component.get('v.currentaccountId'),
            showAllAcc: component.get("v.showAll")
        });
        
        action.setCallback(this, function(response) {
            var state = response.getState();
            
            if (state === "SUCCESS") {  
                let data = response.getReturnValue();
                //console.log(data)
                component.set("v.activeotherAgreements",data.length);
                
                let callOut=[];
                let fixedAgreemnets=[];
                
                data.forEach(function(item){
                    if(item.Sales_Agreement_Type__c=='Variable'){                        
                        callOut.push(item);
                    }
                    if(item.Sales_Agreement_Type__c=='Fixed'){                        
                        fixedAgreemnets.push(item);
                    }
                    
                });
                component.set("v.currentCalloutList",callOut); 
                component.set("v.AllCalloutList",callOut); 
                
                component.set("v.currentpoList",fixedAgreemnets); 
                component.set("v.salesAgreeFilterList",fixedAgreemnets); 
                
                
            }
            else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error message: " + errors[0].message);
                        
                    }
                } else {
                    console.log("Unknown error");
                    
                }
            }
        }); 
        
        $A.enqueueAction(action);
        
    },
    getAccountVisits:function(component, event, helper)  {       
        
        var action = component.get('c.getAccVisitsInfo');      
        action.setParams({
            AccountId : component.get('v.currentaccountId'),
            showAllAcc: component.get("v.showAll")
        });
        
        action.setCallback(this, function(response) {
            var state = response.getState();
            
            if (state === "SUCCESS") {  
                let data = response.getReturnValue();
                //console.log(data)
                component.set("v.noOfVisits",data.length);              
                component.set("v.accVisitFilterList",data);    
                component.set("v.accVisitList",data);    
                
            }
            else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error message: " + errors[0].message);
                        
                    }
                } else {
                    console.log("Unknown error");
                    
                }
            }
        }); 
        
        $A.enqueueAction(action);
        
    },
    getVehicleAccidents:function(component, event, helper)  {       
        
        var action = component.get('c.getVehicleAccidentInfo');      
        action.setParams({
            AccountId : component.get('v.currentaccountId'),
            showAllAcc: component.get("v.showAll")
        });
        
        action.setCallback(this, function(response) {
            var state = response.getState();
            
            if (state === "SUCCESS") {  
                let data = response.getReturnValue();
                // console.log(data)
                component.set("v.noOfAccidents",data.length);
                component.set("v.accidentsFilterList",data);    
                component.set("v.accidentsList",data); 
                
            }
            else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error message: " + errors[0].message);
                        
                    }
                } else {
                    console.log("Unknown error");
                    
                }
            }
        }); 
        
        $A.enqueueAction(action);
        
    },
    
    
    getCustomerWorkstationInfo:function(component, event, helper)  {       
        
        var action = component.get('c.getAccVsWorkShopMaster');      
        action.setParams({
            AccountId : component.get('v.currentaccountId')            
        });
        
        action.setCallback(this, function(response) {
            var state = response.getState();
            
            if (state === "SUCCESS") {  
                let data = response.getReturnValue();
                if(data)
                    component.set("v.defaultWorkStation",data[0].Workshop_Location__c);        
                
            }
            else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error message: " + errors[0].message);
                        
                    }
                } else {
                    console.log("Unknown error");
                    
                }
            }
        }); 
        
        $A.enqueueAction(action);
        
    },
    
    getfleetReqt:function(component, event, helper)  {       
        
        var action = component.get('c.getFleetServiceRequest');      
        action.setParams({
            AccountId : component.get('v.currentaccountId'),
            showAllAcc: component.get("v.showAll")
        });
        
        action.setCallback(this, function(response) {
            var state = response.getState();
            
            if (state === "SUCCESS") {  
                let fleetdata = response.getReturnValue();
                console.log(fleetdata);
                
                component.set("v.fleetServiceRequestList",fleetdata); 
                component.set("v.noOfFleetReq",fleetdata.length);
                
            }
            else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error message: " + errors[0].message);
                        
                    }
                } else {
                    console.log("Unknown error");
                    
                }
            }
        }); 
        
        $A.enqueueAction(action);
        
    },
    
    
    
    getHSEInfoHelper:function(component, event, helper)  {       
        
        var action = component.get('c.getHSEInfo');      
        action.setParams({
            AccountId : component.get('v.currentaccountId'),
            showAllAcc: component.get("v.showAll")
        });
        
        action.setCallback(this, function(response) {
            var state = response.getState();
            
            if (state === "SUCCESS") {  
                let data = response.getReturnValue();
                console.log(data);
                let hseInspection = [];
                let ivmsDevice = [];
                let spotCheck=[];
                let roadSafety = [];
                let induction = [];
                data.forEach(function(item){
                    
                    if(item.RecordType.DeveloperName == 'HSE_Inspections'){
                        hseInspection.push(item);                        
                    }
                    if(item.RecordType.DeveloperName == 'IVMS_Devices'){
                        ivmsDevice.push(item);                        
                    }   
                    if(item.RecordType.DeveloperName == 'Spot_Check'){
                        spotCheck.push(item);  
                        
                    }  
                    if(item.RecordType.DeveloperName == 'HSE_Road_Safety_Workshop'){
                        roadSafety.push(item);                        
                    } 
                    if(item.RecordType.DeveloperName == 'HSE_Induction'){
                        induction.push(item);                        
                    }                   
                    
                    
                });
                component.set("v.hseInspections",hseInspection);
                component.set("v.ivmsDevices",ivmsDevice);
                component.set("v.spotChecks",spotCheck);
                component.set("v.roadSafetyWrksp",roadSafety);                
                component.set("v.hseInduction",induction);
                
            }
            else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error message: " + errors[0].message);
                        
                    }
                } else {
                    console.log("Unknown error");
                    
                }
            }
        }); 
        
        $A.enqueueAction(action);
        
    },    
    
    saveOppHelper: function(component, event, helper)  {
        //console.log('inside save opp helper');
        let fileInfo = component.get('v.uploadedFileList');
        component.set('v.showSpinner',true);
        
        var action = component.get('c.saveOpportunity');
        action.setParams({
            type:  'Sales opportunity',
            opp:  component.get('v.opp'),
            currentPO : component.get('v.currentPO') ,
            fileData: JSON.stringify(fileInfo)
            
        });
        action.setCallback(this, function (a) {
            var state = a.getState(); // get the response state
            if (state == 'SUCCESS') {
                component.set('v.showSpinner',false);
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "type": "success",
                    "title": "Success!",
                    "message": "The Opportunity with us is created succesfully"
                });
                toastEvent.fire(); 
                component.set('v.more',false);
            }else{
                component.set('v.showSpinner',false);
                console.log('error ----'+JSON.stringify(a.getError()));
                helper.showToast('Error','Error','Please check with system admin');
                
            }
        });
        $A.enqueueAction(action);
        
    },
    getDocIdHelper: function(component, event, helper,docId)  {
        var action = component.get('c.getDocId');
        action.setParams({         
            fiscalMonth: component.get('v.currentDate')+'-'+component.get('v.currentMonth'),
            po: component.get('v.currentPO')
        });
        action.setCallback(this, function (a) {
            var state = a.getState(); // get the response state
            if (state == 'SUCCESS') {
                component.set('v.selectedDocIds',a.getReturnValue());
                //      console.log('selectedDocIds ----'+component.get('v.selectedDocIds'));
            }else{
                console.log('error ----'+JSON.stringify(a.getError()));
            }
        });
        $A.enqueueAction(action);
        
    },
    getTimesheetHelper: function(component, event, helper)  {
        component.set('v.timesheetURL','');
        var action = component.get('c.getTimesheet');
        //console.log(component.get('v.currentMonth')+'-'+ component.get('v.currentDate'));
        //console.log('accountId='+component.get('v.accountId')); 
        action.setParams({         
            fiscalMonth: component.get('v.currentMonth')+'-'+ component.get('v.currentDate'),
            accountId: component.get('v.accountId')
        });
        action.setCallback(this, function (a) {
            var state = a.getState(); // get the response state
            if (state == 'SUCCESS') {
                console.log('timesheetURL ----'+a.getReturnValue());
                component.set('v.timesheetURL',a.getReturnValue());
            }else{
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "type": "error",
                    "title": "error!",
                    "message": "Error in fetching timesheet information"
                });
                toastEvent.fire();
                console.log('error ----'+JSON.stringify(a.getError()));
            }
        });
        $A.enqueueAction(action);
        
    },
    setUploadedFile: function(component, event, helper)  {
        var docId = component.get('v.docId');
        var action = component.get('c.saveUploadedFile');
        action.setParams({         
            docId: docId,
            fiscalMonth: component.get('v.currentDate')+'-'+component.get('v.currentMonth'),
            po: component.get('v.currentPO'),
            name: component.get('v.fileName')
        });
        action.setCallback(this, function (a) {
            var state = a.getState(); // get the response state
            if (state == 'SUCCESS') {
                
            }else{
                console.log('error ----'+JSON.stringify(a.getError()));
            }
        });
        $A.enqueueAction(action);
        
    },
    terminateRequestHelper: function(component, event, helper)  {
        
        component.set('v.showSpinner',true);
        let fileInfo = component.get('v.uploadedFileList');
        var action = component.get('c.terminateRequest');
        action.setParams({
            caseRecord:  component.get('v.caseRecord'),           
            POName: component.get('v.currentPO'),
            fileData: JSON.stringify(fileInfo)
        });
        action.setCallback(this, function (a) {
            var state = a.getState(); // get the response state
            if (state == 'SUCCESS') {
                component.set('v.showSpinner',false);
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "type": "success",
                    "title": "Success!",
                    "message": "The case is created succesfully"
                });
                toastEvent.fire(); 
                component.set('v.more',false);
                //component.set('v.terminateRequest',false); 
            }else{
                
                component.set('v.showSpinner',false);
                console.log('error ----'+JSON.stringify(a.getError()));
                helper.showToast('Error','Error','Please check with system admin');
            }
        });
        $A.enqueueAction(action);
        
    },
    holdRequestHelper: function(component, event, helper)  {
        component.set('v.showSpinner',true);
        let fileInfo = component.get('v.uploadedFileList');
        var action = component.get('c.terminateRequest');
        action.setParams({
            caseRecord:  component.get('v.caseRecord'),           
            POName: component.get('v.currentPO'),
            fileData: JSON.stringify(fileInfo)
        });
        action.setCallback(this, function (a) {
            var state = a.getState(); // get the response state
            if (state == 'SUCCESS') {
                component.set('v.showSpinner',false);
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "type": "success",
                    "title": "Success!",
                    "message": "The case is created succesfully"
                });
                toastEvent.fire(); 
                //component.set('v.hold',false); 
                component.set('v.more',false);
            }else{
                component.set('v.showSpinner',false);
                console.log('error ----'+JSON.stringify(a.getError()));
                helper.showToast('Error','Error','Please check with system admin');
            }
        });
        $A.enqueueAction(action);
        
    },
    
    offHireRequestHelper: function(component, event, helper)  {
        //console.log('inside offhire request helper');
        component.set('v.showSpinner',true);
        let fileInfo = component.get('v.uploadedFileList');
        var action = component.get('c.createOffHireRequest');
        action.setParams({
            caseRecord:  component.get('v.caseRecord'),           
            POName: component.get('v.currentPO'),
            fileData: JSON.stringify(fileInfo)
        });
        action.setCallback(this, function (a) {
            var state = a.getState(); // get the response state
            if (state == 'SUCCESS') {
                
                component.set('v.showSpinner',false);
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "type": "success",
                    "title": "Success!",
                    "message": "The case is created succesfully"
                });
                toastEvent.fire(); 
                //component.set('v.offHire',false); 
                component.set('v.more',false);
            }else{
                component.set('v.showSpinner',false);
                console.log('error ----'+JSON.stringify(a.getError()));
                helper.showToast('Error','Error','Please check with system admin');
            }
        });
        $A.enqueueAction(action);
        
    },
    showSalesAggsHelper : function(component, event, helper)  {
        component.set('v.salesAgreement',true);
        component.set('v.isSalesAggs',true);
        var item=event.getSource().get('v.value');
        component.set('v.currentPO',item);
        var action = component.get('c.getPODetails');
        action.setParams({
            POName: item
        });
        action.setCallback(this, function (a) {
            var state = a.getState(); // get the response state
            if (state == 'SUCCESS') {
                
                var result = a.getReturnValue();
                console.log('result'+JSON.stringify(result));
                //  result.vehicleCount[0]=100;
                
                component.set("v.cntList", result);
                // alert(JSON.stringify(result));
                /*var custs=[];
                var recs=[];
                for ( var key in result.VehicleCount ) {
                    custs.push({value:result.VehicleCount[key], key:key});
                } 
				for ( var key in result.resourceCount ) {
                    recs.push({value:result.resourceCount[key], key:key});
                }
                
                if(recs.length==0){
                    recs.push({value:0, key:9});
                    recs.push({value:0, key:10});
                    recs.push({value:0, key:11});
                }
                else if(recs.length==1){
                    recs.push({value:0, key:9});
                    recs.push({value:0, key:10});
                }
                else if(recs.length==2){
                    recs.push({value:0, key:9});
                }
                if(custs.length==0){
                    custs.push({value:0, key:9});
                    custs.push({value:0, key:10});
                    custs.push({value:0, key:11});
                }
                else if(custs.length==1){
                    custs.push({value:0, key:9});
                    custs.push({value:0, key:10});
                }
                else if(custs.length==2){
                    custs.push({value:0, key:9});
                }
                component.set("v.VehicleCount", custs);
                component.set("v.resourceCount", recs);
                
                 */
                
                
            }else{
                alert('error ----'+JSON.stringify(a.getError()));
            }
        });
        $A.enqueueAction(action);
        
    },
    showOtherAggsHelper : function(component, event, helper)  {
        component.set('v.otherAgreement',true);
        component.set('v.isOtherAggs',true);
        var item=event.getSource().get('v.value');
        component.set('v.currentPO',item);
        var action = component.get('c.getPODetails');
        action.setParams({
            POName: item
        });
        action.setCallback(this, function (a) {
            var state = a.getState(); // get the response state
            if (state == 'SUCCESS') {
                
                var result = a.getReturnValue();
                console.log('result'+JSON.stringify(result));
                //  result.vehicleCount[0]=100;
                
                component.set("v.cntList2", result);           
                
            }else{
                alert('error ----'+JSON.stringify(a.getError()));
            }
        });
        $A.enqueueAction(action);
        
    },
    showMaintenanceAggsHelper : function(component, event, helper)  {
        component.set('v.maintenanceAgreement',true);
        component.set('v.isMaintenanceAggs',true);
        var item=event.getSource().get('v.value');
        component.set('v.currentPO',item);
        var action = component.get('c.getMaintenancePODetails');
        action.setParams({
            POName: item
        });
        action.setCallback(this, function (a) {
            var state = a.getState(); // get the response state
            if (state == 'SUCCESS') {
                
                var result = a.getReturnValue();
                console.log('cntList1result111 '+JSON.stringify(result));
                
                component.set("v.cntList1", result);
            }else{
                alert('error ----'+JSON.stringify(a.getError()));
            }
        });
        $A.enqueueAction(action);
        
    },
    showVehiclesHelper: function (component, event, helper,monthNo) {
        var action = component.get('c.showVehiclesforMonth');
        console.log('POName'+component.get('v.currentPO'));
        action.setParams({
            POName:  component.get('v.currentPO'),
            monthNo: monthNo,
            year:component.get('v.currentDate')
        });
        action.setCallback(this, function (a) {
            var state = a.getState(); // get the response state
            if (state == 'SUCCESS') {
                var result = a.getReturnValue();
                component.set('v.vehileList', result);
                component.set('v.currentvehileList', result);
            }
        });
        $A.enqueueAction(action);
    },
    showMaintenanceVehiclesHelper: function (component, event, helper,monthNo) {
        console.log('inside-handle2')
        try{
            var action = component.get('c.showMaintenanceVehiclesforMonth');
            
            action.setParams({
                POName:  component.get('v.currentPO'),
                monthNo: monthNo,
                year:component.get('v.currentDate')
            });
            action.setCallback(this, function (a) {
                var state = a.getState(); // get the response state
                console.log(state)
                if (state == 'SUCCESS') {
                    var result = a.getReturnValue();
                    component.set('v.vehicleMaintenanceList', result);
                    console.log(result)
                }else if (state === "ERROR") {
                    var errors = response.getError();
                    if (errors) {
                        if (errors[0] && errors[0].message) {
                            console.log("Error message: " + errors[0].message);
                            
                        }
                    } else {
                        console.log("Unknown error");
                        
                    }
                }
            });
            $A.enqueueAction(action);
        }catch(e){
            console.log(e.message)
        }
    },
    
    showMaintenanceWOHelper: function (component, event, helper,monthNo) {
        var action = component.get('c.showMaintenanceWoforMonth');
        console.log('POName'+component.get('v.currentPO'));
        action.setParams({
            POName:  component.get('v.currentPO'),
            monthNo: monthNo,
            year:component.get('v.currentDate')
        });
        action.setCallback(this, function (a) {
            var state = a.getState(); // get the response state
            if (state == 'SUCCESS') {
                var result = a.getReturnValue();
                console.log()
                component.set('v.maintenanceWoList', result);
                
            }
        });
        $A.enqueueAction(action);
    },
    showEstimationHelper: function (component, event, helper,monthNo) {
        var action = component.get('c.showEstimationforMonth');
        console.log('POName'+component.get('v.currentPO'));
        action.setParams({
            POName:  component.get('v.currentPO'),
            monthNo: monthNo,
            year:component.get('v.currentDate')
        });
        action.setCallback(this, function (a) {
            var state = a.getState(); // get the response state
            if (state == 'SUCCESS') {
                var result = a.getReturnValue();
                component.set('v.maintenanceEstList', result);
                
            }
        });
        $A.enqueueAction(action);
    },
    
    showActiveMaintenanceWOHelper: function (component, event, helper,monthNo) {
        console.log('monthNomonthNo '+monthNo);
        console.log('POName'+component.get('v.currentPO'));
        var action = component.get('c.showActiveMaintenanceWoforMonth');
        action.setParams({
            POName:  component.get('v.currentPO'),
            monthNo: monthNo,
            year:component.get('v.currentDate')
        });
        
        action.setCallback(this, function (a) {
            var state = a.getState(); // get the response state
            if (state == 'SUCCESS') {
                var result = a.getReturnValue();
                
                console.log(result)
                component.set('v.activeMaintenanceWoList', result);
                
            }
        });
        $A.enqueueAction(action);
    },
    getSiteDetailsHelper: function (component, event, helper) {
        var action = component.get('c.getSiteDetails');
        action.setParams({
            "AccountId" : component.get('v.currentaccountId')
        });
        action.setCallback(this, function (a) {
            var state = a.getState(); // get the response state
            if (state == 'SUCCESS') {
                var result = a.getReturnValue();
                component.set('v.currentsiteData', result);
                component.set('v.siteList', result);
                
            }
        });
        $A.enqueueAction(action);
    },
    getInvHelper: function (component, event, helper) {
        var action = component.get('c.getInvDetails');
        action.setParams({
            "AccountId" : component.get('v.currentaccountId')
        });
        action.setCallback(this, function (a) {
            var state = a.getState(); // get the response state
            if (state == 'SUCCESS') {
                var result = a.getReturnValue();
                component.set('v.currentInvoicesList', result.allinvoices);
                component.set('v.invoicesList', result.allinvoices);
                component.set('v.paidList', result.paidinvoices);
                component.set('v.unpaidList', result.unpaidinvoices);
                
            }
        });
        $A.enqueueAction(action);
    },
    getTrafficFineInfo : function (component, event, helper) {
        
        var action = component.get('c.getTrafficFineDetails');      
        action.setParams({
            AccountId : component.get('v.currentaccountId'),
            showAllAcc: component.get("v.showAll")
        });
        console.log(component.get('v.currentaccountId'))
        action.setCallback(this, function(response) {
            var state = response.getState();
            
            if (state === "SUCCESS") {  
                let data = response.getReturnValue();
                
                component.set("v.trafficFineCount",data.length);
                component.set("v.trafficFineList",data);
                component.set('v.trafficFineFilterList',data);
                
            }
            else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error message: " + errors[0].message);
                        
                    }
                } else {
                    console.log("Unknown error");
                    
                }
            }
        }); 
        
        $A.enqueueAction(action);
    },
    
    showResourcesHelper: function (component, event, helper,monthNo) {
        var action = component.get('c.showResourcesforMonth');
        //  alert(component.get('v.currentPO'));
        action.setParams({
            POName:  component.get('v.currentPO'),
            monthNo: monthNo,
            year:component.get('v.currentDate')
            // year param added on 06-06-2021
        });
        action.setCallback(this, function (a) {
            var state = a.getState(); // get the response state
            if (state == 'SUCCESS') {
                var result = a.getReturnValue();
                component.set('v.resourceList', result);
                component.set('v.currentresourceList', result);
            }
        });
        $A.enqueueAction(action);
    },
    resetFlags : function(component)  {
        component.set('v.more', false); 
        component.set('v.addMore', false); 
        component.set('v.assignVehicles', false); 
        component.set('v.terminateRequest', false); 
        
    },
    convertArrayOfObjectsToCSV : function(component,objRecords,type,helper) {
        
        var csvStringResult,counter,keys,lineDivider,columnDivider;
        if(objRecords==null || !objRecords.length)
        {
            return null;         
        }
        columnDivider=',';
        lineDivider='\n';
        if(type=='site'){
            keys=['FirstName','LastName','Phone'];
            csvStringResult='';
        }else if(type=='vehicle'){
            keys=['Name','Vehicle_Number__c','Plate_Number__c','Plate_Code__c','Plate_Source__c','Vehicle_Description__c','Assign_Start_Date__c','Assign_End_Date__c'];
            csvStringResult='';
            csvStringResult+=['Vehicle Name','Vehicle Number','Plate Number','Plate Code','Plate Source','Vehicle Description','Assign Start Date','Assign End Date'];
            
        }else if(type=='resource'){
            keys=['Employee_ID__c','Name','Employee_Type__c','Actual_Salary_Amount__c','Deduction_Amount__c','Salary_Paid_Amount__c','Deduction_Reason__c','Salary_Paid_Date__c','Sales_Agreement__r','Assign_Start_Date__c','Assign_End_Date__c'];
            csvStringResult='';
            csvStringResult+=['Employee ID','Empoyee Name','Employee Type','Actual Salary Amount','Deduction Amount','Salary Paid Amount','Deduction Reason','Salary Paid Date','Sales Agreement No','Assign Start Date','Assign End Date'];
        }else if(type=='invoice'){
            keys=['Name','Invoice_Date__c','Invoice_Amount__c','Due_Amount__c','Sales_Agreement__r'];
            csvStringResult='';
            csvStringResult+=['Invoice Number','Invoice Date','Invoice Amount','Due Amount','Sales Agreement'];
        }else if(type=='vehicleMaintenance'){
            keys=['Plate_No__c','Internal_No__c','Vehicle_Type__c','Vehicle_Make__c','Vehicle_Family__c','Vehicle_Year__c'];
            csvStringResult='';
            csvStringResult+=['Vehicle Plate No','ET Ref No','Vehicle Type','Make','Family','Year'];
        }else if(type=='maintenanceWO'){
            keys=['Plate_Number__c','Work_Order__c','Service_Req_Ref_No__c','Vehicle_Received_On__c','Delivered_On__c','Service_Location__c','Work_Status__c','KM_Reading__c','Description__c'];
            csvStringResult='';
            csvStringResult+=['Vehicle','Work order','Service Ref No','Vehicle checked in','Delivered On','Service Location','Status','KM Reading','Description'];
        }else if(type=='maintenanceEstimation'){
            keys=['Plate_Number__c','Name','Work_order__c','Service_Location__c','Estimator__c','CreatedDate','Materials__c','Labor__c','Others__c','Net_Amount__c','Invoice_Number__c','Invoiced__c','Paid__c'];
            csvStringResult='';
            csvStringResult+=['Vehicle','Estimate No','Work order','Service Location','Estimator','Creation Date','Total Material Charge','Total Labor Charge','Other Charges','Net Amount','Invoice Number','Invoiced Y/N','Paid Y/N'];
        }else if(type=='activeMaintenanceWO'){
            keys=['Plate_Number__c','Work_Order__c','Vehicle_Received_On__c','Delivered_On__c','Service_Location__c','Work_Status__c','KM_Reading__c'];
            csvStringResult='';
            csvStringResult+=['Vehicle','Work order','Vehicle checked in','Delivered On','Service Location','Status','KM Reading'];
        }
        
        //csvStringResult+=keys.join(columnDivider);
        csvStringResult+=lineDivider;
        
        for(var i=0;i<objRecords.length;i++)
        {
            
            counter=0;
            for(var tempKey in keys)
            {
                var skey=keys[tempKey];
                
                if(counter>0)
                {
                    csvStringResult+=columnDivider;
                }
                // Querying standard related object field
                if(typeof objRecords[i][skey]==='object' && skey==='RecordType'){
                    if(objRecords[i][skey].Name!=undefined && objRecords[i][skey].Name!=null){
                        csvStringResult+='"'+objRecords[i][skey].Name+'"';
                    }else{
                        csvStringResult+='"'+''+'"';
                    }
                    
                    counter ++;
                }
                // Querying custom related object field
                else if(typeof objRecords[i][skey]==='object' && (skey==='Sales_Agreement__r')){
                    if(objRecords[i][skey].Name!=undefined && objRecords[i][skey].Name!=null){
                        csvStringResult+='"'+objRecords[i][skey].Name+'"';
                    }else{
                        csvStringResult+='"'+''+'"';
                    }
                    counter ++;
                }
                // Querying same object field
                    else{
                        // console.log('inside else '+skey);
                        if(objRecords[i][skey]!=undefined && objRecords[i][skey]!=null){
                            if(skey==='Assign_Start_Date__c'){
                                var newDate=helper.formatDate(objRecords[i][skey],helper);
                                csvStringResult+='"'+newDate+'"'; 
                            }else if(skey==='Assign_End_Date__c'){
                                var newDate=helper.formatDate(objRecords[i][skey],helper);
                                csvStringResult+='"'+newDate+'"';
                            }else{ 
                                csvStringResult+='"'+objRecords[i][skey]+'"';
                            } 
                        }else{
                            csvStringResult+='"'+''+'"';
                        }
                        counter ++;
                    }
                
            }
            csvStringResult+=lineDivider;
            
        }
        
        return csvStringResult;
    },
    formatDate : function(date1,helper) {
        var date=new Date(date1)
        var year = date.getFullYear().toString().substr(-2),
            month = date.getMonth() + 1, // months are zero indexed
            day = date.getDate(),
            hour = date.getHours(),
            minute = date.getMinutes(),
            second = date.getSeconds(),
            hourFormatted = hour % 12 || 12, // hour returned in 24 hour format
            minuteFormatted = minute < 10 ? "0" + minute : minute,
            morning = hour < 12 ? "am" : "pm";
        //alert( month + "/" + day + "/" + year + " " + hourFormatted + ":" + minuteFormatted + morning);
        return day + "-" + month + "-" + year + " " + hourFormatted + ":" +
            minuteFormatted + morning;
    },
    resetDashBoard: function(component) {
        component.set('v.sites',false);
        component.set('v.salesAgreementClick', false);
        component.set('v.salesAgreement', false);
        component.set('v.isHSEDetail', false);
        component.set('v.maintenanceAgreementClick', false);
        component.set('v.maintenanceAgreement', false);
        
        component.set('v.assignResources', false);
        component.set('v.assignResourcesClick', false);
        
        component.set('v.assignVehiclesClick', false);
        component.set('v.assignVehicles', false);
        
        component.set('v.invoicesClick', false);
        component.set('v.invoices', false);
        component.set('v.isSalesAggs',false); 
        component.set('v.isMaintenanceAggs',false); 
        component.set('v.studentsClick', false);
        component.set('v.students', false);
        
        component.set('v.salesAgreementDashboard', false);
        component.set('v.maintenanceAgreementDashboard', false);
        component.set('v.assignMaintenanceWo', false);
        component.set('v.assignEstimation', false);
        component.set('v.assignActiveMaintenanceWo', false);
        component.set('v.assignMaintenanceVehicles', false);
        component.set('v.otherAgreement', false);
        component.set("v.showDashboard",false);
        component.set('v.isTrafficFines', false);
        component.set("v.isAccVisit", false);
        component.set("v.isVehAccident", false);
        component.set("v.isServiceReq", false);
        component.set("v.eT_overTimeAutoLWCcomp", false);
        component.set("v.showFuelConsumption", false);
        
    },
    
    
    showToast : function (Type,Title,Msg){ //added by janardhan - 04/08/22
        var toastReference = $A.get("e.force:showToast");
        toastReference.setParams({
            "type":Type,
            "title":Title,
            "message":Msg,
            "mode":"dismissible"
        });
        toastReference.fire();
        
    },
    
    getAllDocs : function(component, event, helper){  
        
        var recId=event.getSource().get('v.value');
        
        var action = component.get("c.getFiles");  
        action.setParams({  
            "recordId":recId  
        });      
        action.setCallback(this,function(response){  
            var state = response.getState();  
            if(state=='SUCCESS'){  
                var result = response.getReturnValue();  
                console.log(result)
                
                component.set("v.files",result);  
                
                if(result.length == 0){
                    
                    helper.showToast('Warning','Warning','No files are attached.');
                }
                if(result[0].Id){
                    $A.get('e.lightning:openFiles').fire({
                        //Lightning Openfiles event  
                        recordIds: [result[0].Id] //file id  	
                    }); 
                }
            }  
        });  
        $A.enqueueAction(action); 
        
    },
    
    getProfileName : function(component, event, helper){  
        var action = component.get("c.getprivateschoolUserData");  
        action.setCallback(this,function(response){  
            var state = response.getState();  
            if(state=='SUCCESS'){  
                var result = response.getReturnValue();  
                console.log(result)
                component.set("v.profileName",result.loggedinUserProfileName);  
            }  
        });  
        $A.enqueueAction(action); 
    },
    
    healperhandleFuelConsumptionClick :function(component, event, helper){  
        var action = component.get("c.getFuelConsumptionRecords");
         component.set('v.showSpinner',true);
        action.setCallback(this, function(response) {
            var state = response.getState();
            console.log('state : ' + state);
            
            if (state === "SUCCESS") {
                var records = response.getReturnValue();
                console.log('allRecords : ' + JSON.stringify(records.allRecords));
                // If records are found, update the component's attributes
                component.set("v.Allrecords", records.allRecords);
                component.set("v.CurrentMonthrecords", records.currentMonthRecords);
                component.set("v.janMonthRecs", records.januaryMonthRecords);
                component.set("v.febMonthRecs", records.februaryMonthRecords);
                component.set("v.marMonthRecs", records.marchMonthRecords);
                component.set("v.aprMonthRecs", records.aprilMonthRecords);
                component.set("v.mayMonthRecs", records.mayMonthRecords);
                component.set("v.junMonthRecs", records.juneMonthRecords);
                component.set("v.julMonthRecs", records.julyMonthRecords);
                component.set("v.augMonthRecs", records.augustMonthRecords);
                component.set("v.sepMonthRecs", records.septemberMonthRecords);
                component.set("v.octMonthRecs", records.octoberMonthRecords);
                component.set("v.novMonthRecs", records.novemberMonthRecords);
                component.set("v.decMonthRecs", records.decemberMonthRecords);
                
                component.set('v.Fuelrecords', records.currentMonthRecords);
                component.set("v.noRecords", false);
                
            } else if (state === "ERROR") {
                var errors = response.getError();
                if (errors && errors[0] && errors[0].message) {
                    console.error("Error message: " + errors[0].message);
                } else {
                    console.error("Unknown error");
                }
            }
        });
        
        // Enqueue the action to send it to the server
        $A.enqueueAction(action);
        
        // Show the fuel consumption section/component
        component.set("v.showFuelConsumption", true);
        component.set('v.showSpinner',false);
        
    }
    
    
    
    
})
({
    setImageURLforCheckOut : function(component){
        
        let assetType =component.get("v.assetType");
        console.log('-asset Type---'+assetType);
        
        if(assetType){
            var imgUrl2 = $A.get('$Resource.CICO_Diagrams')+'/images/'+assetType+'.jpg';
        }else{
            var imgUrl2 = $A.get('$Resource.CICO_NoImage');
        }
        
        component.set('v.imgUrl',imgUrl2); //Setting img for CheckOut
        
        
    },
    getVehiclesInfoHandler : function(component, event, helper) { 
        
        var action = component.get('c.getVehicleInfo');
        action.setParams({                 
            recId:component.find("internalNo").get("v.value")
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            
            if (state === "SUCCESS") {  
                
                let res = response.getReturnValue();
                //console.log(res)
                //console.log(res.Name) 
                component.set("v.vehicleInternalNo",res.Name);  
                component.set("v.lastKmReading",res.Last_KM_Reading__c);
                component.set("v.plateNumber",res.Plate_Number__c);
                component.set("v.chassisNumber",res.Chassis_No__c); 
                component.set("v.assetType",res.Asset_Type__c);
                helper.setImageURLforCheckOut(component);
                
                
            }
            else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error message: " + errors[0].message);
                        helper.showToast('error','error','Error-'+errors[0].message);  
                    }
                } else {
                    console.log("Unknown error");
                    
                }
            }
        }); 
        
        $A.enqueueAction(action);
        
    },
    
    /* getVehicleAssetTypeHandler : function(component, event, helper){
         var action = component.get('c.getVehicleAssetType');
            action.setParams({                 
                recId:component.find("internalNo").get("v.value")
                
            });
            action.setCallback(this, function(response) {
                var state = response.getState();
             
                if (state === "SUCCESS") {  
                    
                     component.set("v.assetType",response.getReturnValue());  
                     helper.setImageURLforCheckOut(component);
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
    },*/
    getCheckOutDetailsWithFile : function(component, event, helper){
        
        
        return new Promise($A.getCallback(function(resolve, reject) {
            var action = component.get('c.getCheckOutDetails');
            action.setParams({                 
                recId:component.find("internalNo").get("v.value"), //event.getSource().get("v.value")
                checkOutFor:component.find("checkInFor").get("v.value")
            });
            action.setCallback(this, function(response) {
                var state = response.getState();
                
                if (state === "SUCCESS") {  
                    
                    resolve(response.getReturnValue());
                    
                    
                }
                else if (state === "ERROR") {
                    var errors = response.getError();
                    if (errors) {
                        if (errors[0] && errors[0].message) {
                            console.log("Error message: " + errors[0].message);
                            
                            //helper.getVehicleAssetsAndCustomerInfoHandler(component, event, helper);
                            //helper.showToast('warning','warning','Check out data is not available for selected vehicle');
                            
                        }
                    } else {
                        console.log("Unknown error");
                        
                    }
                }
            }); 
            
            $A.enqueueAction(action); 
            
        }));
        
    },
    
    showToast : function (Type,Title,Msg){
        var toastReference = $A.get("e.force:showToast");
        toastReference.setParams({
            "type":Type,
            "title":Title,
            "message":Msg,
            "mode":"dismissible"
        });
        toastReference.fire();
        
    },
    
    setImageURLOnLoad : function(component){
        
        
        var imgUrl = $A.get('$Resource.CICO_NoImage');
        
        component.set('v.CI_Imgurl',imgUrl);//setting default img as no image for Check Out
        component.set('v.imgUrl',imgUrl); //setting default img as no image for Check In
        
    },
    
    createChildAssetRec : function(component, event, helper) {        
        try{
            
            let listVal = component.get("v.ChildAssetFromOracle");
            
            const checkBoxList = component.find('CheckBox');
            const childAssestForm = component.find('NewChildAsset');
            
            if(listVal.length === 1){
                childAssestForm.submit();
            }  
            
            // checkBoxList.forEach(function(item,i){
            for(var i=0; i < checkBoxList.length;i++){ 
                
                for(var j=0; j < childAssestForm.length;j++){
                    if(checkBoxList[i].get('v.value')){
                        childAssestForm[i].submit(); 
                        console.log(i +'success'); 
                        break;
                    }
                    
                }                     
            } 
            
        }catch(e){
            console.log('--error--'+e.message);
        }
        
        
    },
    
    showRelatedDataHelper : function(component, event, helper) {
        
        let id = component.find("internalNo").get("v.value");
        //event.getSource().get("v.value");
        component.set('v.checkOutInfo',null);
        
        if(id)
            helper.getVehiclesInfoHandler(component, event, helper);
        
        let pickVal = component.find("checkInFor").get("v.value");
        
        if(pickVal == 'Vehicle Rental'){
            
            component.set('v.showRentalInfo',true);
            component.set("v.showInspectedBy",true);
            component.set("v.showReplacement",false);
            component.set("v.showDriver",false);
            component.set("v.showInternalNo",false);
            
            //start - draft vehicle rental mode
            if(component.get("v.recordStatus") != 'New'){
                try{
                    let data = component.get("v.record");
                    
                    //rental status change logic on draft mode
                    let status = data.Rental_Status__c;
                    
                    if(status){
                        if(status == 'Replace'){
                            
                            component.set("v.showReplacement",true);
                            component.set("v.showDriver",false);
                            component.set("v.showInternalNo",false);
                        }else{
                            component.set("v.showReplacement",false);
                        }
                    }
                    
                    //rental replace option change logic on draft mode
                    let replacementOptn = data.Replacement_Option__c;
                    
                    if(replacementOptn){
                        
                        if(replacementOptn == 'Both'){
                            component.set("v.showDriver",true);
                            component.set("v.showInternalNo",true);
                        }else if(replacementOptn == 'Vehicle'){
                            component.set("v.showDriver",false);
                            component.set("v.showInternalNo",true); 
                            
                        }else if(replacementOptn == 'Driver'){
                            
                            component.set("v.showDriver",true);
                            component.set("v.showInternalNo",false);
                        }
                    }
                    //end 
                }catch(e){
                    console.log('ex'+e.message)
                }
            }
        }else if(pickVal == 'Maintenance'){
            component.set("v.showInspectedBy",true);
            component.set('v.showRentalInfo',false);
        }else{
            component.set('v.showRentalInfo',false);
            component.set("v.showInspectedBy",false);
        }
        
        if(id && pickVal ){
            //helper.getVehicleAssetTypeHandler(component, event, helper);  
            
            var imgUrl = $A.get('$Resource.CICO_NoImage');        
            component.set('v.CI_Imgurl',imgUrl);
            
            /* helper.getCheckOutDetailsWithFile(component, event, helper).then($A.getCallback(function (data) {
                
                console.log(data);
                component.set('v.ChildAssetList',data.childAssests);                
                
                if(data.childAssests) {
                    //alert('has childAss')
                } else{
                    //alert('no childAss');
                }             
                 component.set("v.ChildAssetFromOracle",data.childAssests);
                
                 const ci = data.checkOutData;
                
                 component.set('v.checkOutInfo',ci);
                
                if(ci){                                       
                    
                    const checkBoxList = component.find('COAccesories');
                    let checkOutCount =0;
                    for(var i=0; i < checkBoxList.length;i++){
                        
                        if(checkBoxList[i].get("v.value")){
                            checkOutCount++;
                        }
                    } 
                    component.set('v.COAssCount',checkOutCount); 
                    
                }
                 component.set('v.customerName',ci.Customer_Name__c);
                 component.set('v.customerEmail',ci.Customer_Email__c);
                 component.set('v.referenceNo',ci.Reference_Number__c);
                 component.set('v.assignedDriver',ci.Assigned_Driver_ID__c);
                
                
                
                 helper.loadFuelGuageCheckOut(component,ci.Check_Out_fuel_reading__c);
                 
                 //component.set('v.assetType',ci.Asset_Type__c);
                    
                 if(component.get("v.recordStatus") == 'New')
                 helper.setImageURLforCheckOut(component);
                
                if(data.fileData){
                    let files = data.fileData;
                  
                    if(files.MarkedDiagram){
                        //updating last check in image
                         component.set('v.CI_Imgurl','/CICO/sfc/servlet.shepherd/version/renditionDownload?rendition=ORIGINAL_Png&versionId='+data.fileData.MarkedDiagram)
                    }
                    
                    var filesId = [];
                    for (let idval of Object.keys(files)) {
                         
                       if(idval !='Sign' && idval != 'MarkedDiagram')                       
                        filesId.push('/CICO/sfc/servlet.shepherd/version/renditionDownload?rendition=ORIGINAL_Png&versionId='+files[idval])
                    }
                     component.set("v.filesList",filesId);
                      component.set("v.noofRecCI",filesId.length);
                    
                    var start=component.get('v.startCI');
                    var corousalSize=component.get('v.corousalSizeCI');
                                        
                    if(filesId.length > corousalSize){
                        component.set("v.carouseFileList",filesId.slice(start,start+corousalSize));
                    }else{
                        component.set("v.carouseFileList",filesId);
                    }
                }else{
                    
                }
                             
            })); */
            
            
            //directly fetching Check out info from oracle, it doesn't have asset details and last fuel reading
            helper.getVehicleAssetsAndCustomerInfoHandler(component, event, helper);
            var fuelreading=0;
            helper.loadFuelGuageCheckOut(component,fuelreading);
            if(component.get("v.recordStatus") == 'New')
                helper.setImageURLforCheckOut(component);			
            
        }else{
            component.set('v.checkOutInfo',null);
            
        }
        
        
    },
    
    getFileDetails : function(component, event, helper) {
        
        var action = component.get('c.getRecordFileDetails');
        
        action.setParams({ 
            
            RecId:component.get("v.recordId")
            
        });
        
        action.setCallback(this, function(response) {
            var state = response.getState();
            
            if (state === "SUCCESS") {  
                
                var data = response.getReturnValue();
                //console.log(data)
                
                if(data.MarkedDiagram){
                    
                    component.set('v.imgUrl','/CICO/sfc/servlet.shepherd/version/renditionDownload?rendition=ORIGINAL_Png&versionId='+data.MarkedDiagram);
                }else{
                    
                    this.setImageURLforCheckOut(component);
                }
                if(data.Sign){
                    let recStatus = component.get("v.recordStatus");
                    component.set('v.signUrl','/CICO/sfc/servlet.shepherd/version/renditionDownload?rendition=ORIGINAL_Png&versionId='+data.Sign);
                    
                    if(recStatus !='Check In'){
                        var canvas=component.find('canvasSign').getElement();
                        var img = component.find('signImg').getElement(); 
                        var ctx = canvas.getContext("2d");
                        var w = canvas.width;
                        var h = canvas.height;
                        
                        img.onload = function() {
                            ctx.drawImage(img, 0,0,500,100);
                        }
                    }
                }
                
                var tempdata = Object.assign({}, data);
                if(tempdata.MarkedDiagram)
                    delete tempdata.MarkedDiagram;
                if(tempdata.Sign)
                    delete tempdata.Sign;
                
                
                let all_Ids = [];
                for(let key in tempdata){
                    
                    all_Ids.push({id:tempdata[key],value:'/CICO/sfc/servlet.shepherd/version/renditionDownload?rendition=ORIGINAL_Png&versionId='+tempdata[key]});
                    
                }                  
                component.set("v.checkOutSavedFiles",all_Ids);
                
                try{
                    component.set("v.noofUploadImgSaved",all_Ids.length);
                    component.set("v.startSaved",0);
                    
                    var start=component.get('v.startSaved');
                    var corousalSize=component.get('v.corousalSize');
                    
                    
                    if(all_Ids.length > corousalSize){
                        
                        component.set("v.checkOutSavedFilesCaruosel",all_Ids.slice(start,start+corousalSize));
                    }else{
                        
                        component.set("v.checkOutSavedFilesCaruosel",all_Ids);
                    }
                }catch(e){
                    console.log('err'+e.message);
                }
                
                
                
                
                
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
    
    getChildAssetHandler : function(component, event, helper) {
        
        var action = component.get('c.getChildAssetDetailsCI');
        action.setParams({                 
            recId:component.get('v.recordId')
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            
            if (state === "SUCCESS") {  
                
                component.set("v.childAssetSavedList",response.getReturnValue());
                console.log(response.getReturnValue())
                
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
    
    loadFuelGuageCheckOut : function(component,value){
        
        var opts = {
            angle: 0, // The span of the gauge arc
            lineWidth: 0.44, // The line thickness
            radiusScale: 1, // Relative radius
            pointer: {
                length: 0.6, // // Relative to gauge radius
                strokeWidth: 0.035, // The thickness
                color: '#000000' // Fill color
            },
            limitMax: false,     // If false, max value increases automatically if value > maxValue
            limitMin: false,     // If true, the min value of the gauge will be fixed
            colorStart: '#6FADCF',   // Colors
            colorStop: '#8FC0DA',    // just experiment with them
            strokeColor: '#E0E0E0',  // to see which ones work best for you
            generateGradient: true,
            highDpiSupport: true,     // High resolution support
            staticZones: [
                {strokeStyle: "#F03E3E", min: 0, max: 30}, // Red from 100 to 130
                {strokeStyle: "#FFDD00", min: 30, max: 70}, // Yellow
                {strokeStyle: "#30B32D", min: 70, max: 100}// Green
                
            ],
            staticLabels: {
                font: "10px sans-serif",  // Specifies font
                labels: [0, 10,20,30, 40,50,60,70, 80,90, 100],  // Print labels at these values
                color: "#000000",  // Optional: Label text color
                fractionDigits: 0  // Optional: Numerical precision. 0=round off.
            },
            
        };
        var target =component.find("checkOut").getElement();// document.getElementById('foo'); // your canvas element
        var gauge = new Gauge(target).setOptions(opts); // create sexy gauge!
        gauge.maxValue = 100; // set max gauge value
        gauge.setMinValue(0);  // Prefer setter over gauge.minValue = 0
        gauge.animationSpeed = 46; // set animation speed (32 is default value)
        // let val = component.get("v.sliderVal");
        
        gauge.set(value); 
        
    },
    
    loadFuelGuage : function(component){
        
        var target =component.find("checkOut").getElement();// document.getElementById('foo'); // your canvas element
        var gauge = new Gauge(target).setOptions(component.get("v.preSettings")); // create sexy gauge!
        gauge.maxValue = 100; // set max gauge value
        gauge.setMinValue(0);  // Prefer setter over gauge.minValue = 0
        gauge.animationSpeed = 46; // set animation speed (32 is default value)
        // let val = component.get("v.sliderVal");
        gauge.set(0); 
    },
    dynamicFuelGuage : function(component,value){
        
        var target =component.find("CheckIn").getElement();
        
        var gauge = new Gauge(target).setOptions(component.get("v.preSettings"));
        
        gauge.maxValue = 100; // set max gauge value
        gauge.setMinValue(0);  // Prefer setter over gauge.minValue = 0
        gauge.animationSpeed = 46;
        
        gauge.set(value); 
        
    },
    
    getCheckOutDetailsByCheckOutIdHandler :function(component, event, helper) {  
        
        var action = component.get('c.getCheckOutDetailsByCheckOutRecId');
        action.setParams({                 
            recId:component.get("v.record.Check_Out__c")
            
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            
            if (state === "SUCCESS") {  
                
                let data = response.getReturnValue()
                
                console.log(data);
                component.set('v.ChildAssetList',data.childAssests); 
                
                
                component.set("v.ChildAssetFromOracle",data.childAssests);
                
                const ci = data.checkOutData;
                
                component.set('v.checkOutInfo',ci);
                
                helper.loadFuelGuageCheckOut(component,ci.Check_Out_fuel_reading__c);
                
                component.set('v.assetType',ci.Asset_Type__c);
                
                
                if(data.fileData){
                    let files = data.fileData;
                    
                    if(files.MarkedDiagram){
                        //updating last check in image
                        component.set('v.CI_Imgurl','/CICO/sfc/servlet.shepherd/version/renditionDownload?rendition=ORIGINAL_Png&versionId='+data.fileData.MarkedDiagram)
                    }
                    
                    var filesId = [];
                    for (let idval of Object.keys(files)) {
                        
                        if(idval !='Sign' && idval != 'MarkedDiagram')                       
                            filesId.push('/CICO/sfc/servlet.shepherd/version/renditionDownload?rendition=ORIGINAL_Png&versionId='+files[idval])
                            }
                    component.set("v.filesList",filesId);
                    component.set("v.noofRecCI",filesId.length);
                    
                    var start=component.get('v.startCI');
                    var corousalSize=component.get('v.corousalSizeCI');
                    
                    if(filesId.length > corousalSize){
                        component.set("v.carouseFileList",filesId.slice(start,start+corousalSize));
                    }else{
                        component.set("v.carouseFileList",filesId);
                    }
                }
                
                
            }
            else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error message: " + errors[0].message);
                        
                        //helper.showToast('warning','warning','Check In data is not available to this Vehicle');
                        
                    }
                } else {
                    console.log("Unknown error");
                    
                }
            }
        }); 
        
        $A.enqueueAction(action); 
        
    },
    callOracleServer : function(component, event, helper) { 
        
        var params = event.getParams();
        let id = params.response.id;
        
        var action = component.get('c.sendCheckInToOracle');
        action.setParams({                 
            recId:id
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            
            if (state === "SUCCESS") {  
                component.set("v.toggleSpinner",false);
                let res = JSON.parse(response.getReturnValue());
                console.log(response.getReturnValue())
                
                if(res.Status === 'S'){
                    
                    helper.showToast('success','success','Vehicle has been check in successfully-Doc No.'+res.DocNo); 
                    //navigatetoListView
                    var pageChangeEvent = component.getEvent("goToListView");
                    pageChangeEvent.fire();
                }
                if(res.Status === 'E'){
                    
                    helper.showToast('error','error','Error-'+res.Message);  
                    component.set("v.uploadedDiagram",null); 
                    
                    helper.deleteCheckInChildAssetsHandler(component, event, helper);
                    
                }
                
                
                
            }
            else if (state === "ERROR") {
                component.set("v.toggleSpinner",false);
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error message: " + errors[0].message);
                        helper.showToast('error','error','Error-'+errors[0].message);  
                    }
                } else {
                    console.log("Unknown error");
                    
                }
            }
        }); 
        
        $A.enqueueAction(action);
    },
    getAssetTypePicklistValuesHandler: function(component, event, helper) { 
        var action = component.get('c.getselectOptions');
        action.setParams({                 
            objObject:"Vehicle_Master__c",
            fld:"Asset_Type__c"
        });
        action.setCallback(this, function(response) {
            var state = response.getState();            
            if (state === "SUCCESS") {  
                
                let res = response.getReturnValue();
                
                var items = [];
                res.forEach(function (item, index) {
                    var item = {
                        "label": item,
                        "value": item
                    };
                    items.push(item);
                });
                
                component.set("v.assetList", items);
                
                
            }
            else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error message: " + errors[0].message);
                        helper.showToast('error','error','Error-'+errors[0].message);  
                    }
                } else {
                    console.log("Unknown error");
                    
                }
            }
        }); 
        
        $A.enqueueAction(action);
    },
    updateVehicleMasterHandler : function(component, event, helper){
        
        console.log("--vid-"+component.get("v.vehicleId")+'--'+component.get("v.assetType"))
        var action = component.get('c.updateVehicleMaster');
        action.setParams({                 
            recId:component.get("v.vehicleId"),
            assetType:component.get("v.assetType")
        });
        action.setCallback(this, function(response) {
            var state = response.getState();            
            if (state === "SUCCESS") {  
                
                let res = response.getReturnValue();
                
            }
            else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error message: " + errors[0].message);
                        helper.showToast('error','error','Error-'+errors[0].message);  
                    }
                } else {
                    console.log("Unknown error");
                    
                }
            }
        }); 
        
        $A.enqueueAction(action);
        
    },
    getVehicleAssetsAndCustomerInfoHandler : function(component, event, helper) { 
        
        console.log('--int--'+component.get("v.vehicleInternalNo")+'--'+component.find("checkInFor").get("v.value"))
        var action = component.get('c.getVehicleChildAssetCheckIn');
        action.setParams({                 
            InternalNo:component.get("v.vehicleInternalNo"),
            CheckInType:component.find("checkInFor").get("v.value")
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            
            if (state === "SUCCESS") {  
                
                let res = JSON.parse(response.getReturnValue());
                console.log(res) 
                if(res.Status === 'S' ){
                    component.set("v.showOracleChildAssets",true);
                    
                    //component.set("v.referenceNo",'0000');
                    component.set("v.referenceNo",res.PreCheckInInfo.DocNo);
                    component.set("v.customerName",res.PreCheckInInfo.CustomerName);
                    component.set("v.customerEmail",res.PreCheckInInfo.CustomerEmailAddress);
                    component.set("v.assignedDriver",res.PreCheckInInfo.AssignedDriverId);
                    
                    component.set("v.ChildAssetFromOracle",res.PreCheckInInfo.ChildAssets);
                    
                    if(component.find("checkInFor").get("v.value")==='Maintenance'){
                        
                        if(res.Message && res.Message != null){
                            //helper.showToast('warning','warning',res.Message); 
                            
                            var toastReference = $A.get("e.force:showToast");
                            toastReference.setParams({
                                "type":"warning",
                                "title":"warning",
                                "message":res.Message,
                                "mode":"sticky"
                            });
                            toastReference.fire();
                        }
                    }
                    
                }else if(res.Status === 'E'){
                    
                    helper.showToast('error','error','Unable to get child asset/Drive/Customer info-'+res.Message); 
                }
                
                
            }
            else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        //component.set("v.referenceNo",'0000');
                        console.log("Error message: " + errors[0].message);
                        helper.showToast('error','error','Error-'+errors[0].message);
                    }
                } else {
                    console.log("Unknown error");
                    
                }
            }
        }); 
        
        $A.enqueueAction(action);
        
        
    },
    
    deleteCheckInChildAssetsHandler : function(component, event, helper){
        
        
        var action = component.get('c.deleteCheckInChildAssets');
        action.setParams({                 
            recId:component.get("v.recordId") 
            
        });
        action.setCallback(this, function(response) {
            var state = response.getState();            
            if (state === "SUCCESS") {  
                
                let res = response.getReturnValue();
                
            }
            else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error message: " + errors[0].message);
                        helper.showToast('error','error','Error-'+errors[0].message);  
                    }
                } else {
                    console.log("Unknown error");
                    
                }
            }
        }); 
        
        $A.enqueueAction(action);
        
    },
    
    getUserLoginDetails : function(component, event, helper){
        
        var action = component.get('c.getUserLocationInfo');
        
        action.setCallback(this, function(response) {
            var state = response.getState();            
            if (state === "SUCCESS") {  
                
                let res = response.getReturnValue();
                console.log(res[0].Name)
                
                component.find("checkInloc").set("v.value", res[0].Id);
            }
            else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error message: " + errors[0].message);
                        helper.showToast('error','error','Error-'+errors[0].message);  
                    }
                } else {
                    console.log("Unknown error");
                    
                }
            }
        }); 
        
        $A.enqueueAction(action);
        
    },
    
    getUserTypeInfo : function(component, event, helper){
        
        //this method will tell tech or operational user
        
        var action = component.get('c.getUserLoginInfo');
        
        action.setCallback(this, function(response) {
            var state = response.getState();            
            if (state === "SUCCESS") {  
                
                let res = response.getReturnValue();
                console.log('-UserType-'+res.Grade__c)
                
                if(res.Grade__c.includes('OPER')){
                    component.set("v.checkInFor",'Vehicle Rental');
                }else if(res.Grade__c.includes('TECH')){
                    
                    component.set("v.checkInFor",'Maintenance');
                }
                
            }
            else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error message: " + errors[0].message);
                        helper.showToast('error','error','Error-'+errors[0].message);  
                    }
                } else {
                    console.log("Unknown error");
                    
                }
            }
        }); 
        
        $A.enqueueAction(action);
        
    }
    
})
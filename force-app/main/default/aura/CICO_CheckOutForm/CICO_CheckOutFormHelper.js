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
   
    
    getCheckInDetailsWithFile : function(component, event, helper){
      
        return new Promise($A.getCallback(function(resolve, reject) {
            var action = component.get('c.getCheckInDetails');
            action.setParams({                 
                recId:component.find("internalNo").get("v.value"), //event.getSource().get("v.value")
                checkOutFor:component.find("checkOutFor").get("v.value")
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
                             
                            //helper.showToast('warning','warning','Check In data is not available to this Vehicle');
                            
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
        
            const checkBoxList = component.find('CheckBoxId');
            const childAssestForm = component.find('NewChildAssetform');
            
            if(listVal.length === 1){
                childAssestForm.submit();
            }              
         
            //checkBoxList.forEach(function(item,i){
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
       
         component.set('v.checkInInfo',null);
        let id = component.find("internalNo").get("v.value");
        //event.getSource().get("v.value");
        if(id)
        helper.getVehiclesInfoHandler(component, event, helper); 
        
         var imgUrl = $A.get('$Resource.CICO_NoImage');        
         component.set('v.CI_Imgurl',imgUrl);
                 
       let pickVal = component.find("checkOutFor").get("v.value");
       let status = component.get("v.recordStatus");
      
        if(id && pickVal ){     
                       
            helper.getCheckInDetailsWithFile(component, event, helper).then($A.getCallback(function (data) {
                
                console.log(data);
                component.set('v.ChildAssetList',data.childAssests);                
                                              
                const ci = data.checkInData;
                
                 component.set('v.checkInInfo',ci);
                
                if(pickVal == 'Maintenance'){
                   
                    component.set('v.chkOutlocation',ci.Check_in_Location__c);
                    component.set('v.chkOutKmReadng',ci.Checkin_Reading__c);
                    
                }
                
                
                if(ci){
                    const checkBoxList = component.find('CIAccesories');
                    let checkInCount =0;
                    for(var i=0; i < checkBoxList.length;i++){
                        
                        if(checkBoxList[i].get("v.value")){
                            checkInCount++;
                        }
                    } 
                    component.set('v.CIAssCount',checkInCount); 
                    
                }
                
                
                if(ci.Asset_Type__c && status =='New'){
                    component.set("v.assetType",ci.Asset_Type__c);
                    helper.setImageURLforCheckOut(component);
                }
                
                
                 helper.loadFuelGuageCheckIn(component,ci.Check_in_fuel_reading__c);
                
                       
                
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
                             
            }));
              helper.getVehicleAssetsAndCustomerInfoHandler(component, event, helper); 
        }else{
         
            component.set('v.checkInInfo',null);
            component.set('v.ChildAssetList',null);
            
            
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
               console.log(data)
                            
                if(data.MarkedDiagram){
                    
                    component.set('v.imgUrl','/CICO/sfc/servlet.shepherd/version/renditionDownload?rendition=ORIGINAL_Png&versionId='+data.MarkedDiagram);
                    component.set("v.loadImageOnce",false);
                }else{
                  
                   this.setImageURLforCheckOut(component);
                }
                
                
                let recStatus = component.get("v.recordStatus");
                if(data.Sign){
                    component.set('v.signUrl','/CICO/sfc/servlet.shepherd/version/renditionDownload?rendition=ORIGINAL_Png&versionId='+data.Sign);
                    
                    if(recStatus !='Check Out'){
                        
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
      
       var action = component.get('c.getChildAssetDetails');
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
     
     loadFuelGuageCheckIn : function(component,value){
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
        var target =component.find("checkIn").getElement();// document.getElementById('foo'); // your canvas element
        var gauge = new Gauge(target).setOptions(opts); // create sexy gauge!
        gauge.maxValue = 100; // set max gauge value
        gauge.setMinValue(0);  // Prefer setter over gauge.minValue = 0
        gauge.animationSpeed = 46; // set animation speed (32 is default value)
        // let val = component.get("v.sliderVal");
       
         gauge.set(value); 
        
    },
    
    loadFuelGuage : function(component){
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
             /*renderTicks: {
                 divisions: 10,
                 divWidth: 1.1,
                 divLength: 0.4,
                 divColor: "#333333",
                 subDivisions: 2,
                 subLength: 0.2,
                 subWidth: 0.6,
                 subColor: "#666666"
             }*/
            
        };
        var target =component.find("CheckOut").getElement();// document.getElementById('foo'); // your canvas element
        var gauge = new Gauge(target).setOptions(opts); // create sexy gauge!
        gauge.maxValue = 100; // set max gauge value
        gauge.setMinValue(0);  // Prefer setter over gauge.minValue = 0
        gauge.animationSpeed = 46; // set animation speed (32 is default value)
        // let val = component.get("v.sliderVal");
        
        gauge.set(0); 
    },
    dynamicFuelGuage : function(component,value){
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
             
           /*renderTicks: {
                 divisions: 10,
                 divWidth: 1.1,
                 divLength: 0.4,
                 divColor: "#333333",
                 subDivisions: 2,
                 subLength: 0.2,
                 subWidth: 0.6,
                 subColor: "#666666"
             }*/
            
        };
        
      var target =component.find("CheckOut").getElement();
      var gauge = new Gauge(target).setOptions(opts);
        gauge.maxValue = 100; // set max gauge value
        gauge.setMinValue(0);  // Prefer setter over gauge.minValue = 0
        gauge.animationSpeed = 46;
        gauge.set(value); 
        
       
    },
    
    getCheckInDetailsByCheckInIdHandler :function(component, event, helper) {  
        
        var action = component.get('c.getCheckInDetailsByCheckInID');
        action.setParams({                 
            recId:component.get("v.record.Check_In__c")
            
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            
            if (state === "SUCCESS") {  
             
              let data = response.getReturnValue()
              
                console.log(data);
                component.set('v.ChildAssetList',data.childAssests);               
                
                const ci = data.checkInData;
                
                 component.set('v.checkInInfo',ci);
                
                let pickVal = component.find("checkOutFor").get("v.value");
              
                if(pickVal == 'Maintenance'){
                   
                    component.set('v.chkOutlocation',ci.Check_in_Location__c);
                    component.set('v.chkOutKmReadng',ci.Checkin_Reading__c);
                    
                }
                
                 helper.loadFuelGuageCheckIn(component,ci.Check_in_fuel_reading__c);
                
                 //component.set('v.assetType',ci.Asset_Type__c);
                
                
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
                        
                       // helper.showToast('warning','warning','Check In data is not available to this Vehicle');
                       
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
        
        var action = component.get('c.sendCheckOutToOracle');
        action.setParams({                 
            recId:id
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            
            if (state === "SUCCESS") {  
               
                let res = JSON.parse(response.getReturnValue());
                console.log(response.getReturnValue())
                  component.set("v.toggleSpinner",false);             
                if(res.Status === 'S'){
                   
                    helper.showToast('success','success','Vehicle has been check out successfully - Doc No.'+res.DocNo); 
                    //navigatetoListView
                    var pageChangeEvent = component.getEvent("goToListView");
                    pageChangeEvent.fire();
                }
                if(res.Status === 'E'){
                    
                    helper.showToast('error','error','Internal Error-'+res.Message);
                    component.set("v.uploadedDiagram",null);
                    
                    helper.deleteCheckOutChildAssetsHandler(component, event, helper);
                }
                
                
                
            }
            else if (state === "ERROR") {
                var errors = response.getError();
               component.set("v.toggleSpinner",false);
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
    getVehiclesInfoHandler : function(component, event, helper) { 
    	          
        var action = component.get('c.getVehicleInfo');
        action.setParams({                 
            recId:component.find("internalNo").get("v.value")
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            
            if (state === "SUCCESS") {  
               
                let res = response.getReturnValue();
               //console.log(response.getReturnValue())
               // console.log(res.Name)
                 component.set("v.vehicleInfo",res);     
                
                 component.set("v.vehicleId",res.Id);
                component.set("v.lastKmReading",res.Last_KM_Reading__c);
                component.set("v.plateNumber",res.Plate_Number__c);
                component.set("v.chassisNumber",res.Chassis_No__c);
                component.set("v.vehicleInternalNo",res.Name); 
                component.set("v.assetType",res.Asset_Type__c);
                if(component.get("v.loadImageOnce"))
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
    
    getVehicleAssetsAndCustomerInfoHandler : function(component, event, helper) { 
     
       console.log('--int--'+component.get("v.vehicleInternalNo")+'--'+component.find("checkOutFor").get("v.value"))
        var action = component.get('c.getVehicleChildAssetCustomerInfo');
        action.setParams({                 
            InternalNo:component.get("v.vehicleInternalNo"),
            CheckoutType:component.find("checkOutFor").get("v.value")
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            
            if (state === "SUCCESS") {  
                component.set("v.toggleSpinner",false);
                let res = JSON.parse(response.getReturnValue());
                console.log(res) 
                if(res.Status === 'S' ){
                   
                    component.set("v.referenceNumber",res.PreCheckOutInfo.DocNo);
                    component.set("v.customerName",res.PreCheckOutInfo.CustomerName);
                    component.set("v.customerEmail",res.PreCheckOutInfo.CustomerEmailAddress);
                    component.set("v.assignedDriver",res.PreCheckOutInfo.AssignedDriverId);
                    component.set("v.ChildAssetFromOracle",res.PreCheckOutInfo.ChildAssets);
                     
                    
                }else if(res.Status === 'E'){
                    
                    helper.showToast('error','error','Unable to get child asset/Drive/Customer info-'+res.Message); 
                   
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
        
        //console.log("--vid-"+component.get("v.vehicleId")+'--'+component.get("v.assetType"))
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
    getZoneInfoFromCoordinates : function(component, event, helper){
        
        
        //let lat='25.23635';
       // let lng='55.36082';
      let lat='';
        let lng='';
         try{
       if (navigator.geolocation) {
            
            navigator.geolocation.getCurrentPosition(function (p) {
                //alert(p.coords.latitude+'--'+p.coords.longitude);
                lat = p.coords.latitude;
                lng= p.coords.longitude;
                
               // alert(lat.toString().substring(0, 8)+'--'+lng.toString().substring(0, 8));
            });
        }else {
            alert('Geo Location feature is not supported in this browser.');
        }
        
       
        
        var action = component.get('c.getWorkshopCoord');
       
        action.setCallback(this, function(response) {
            var state = response.getState();            
            if (state === "SUCCESS") {    
             // console.log(response.getReturnValue());
                 var myPosition = new google.maps.LatLng(lat,lng);
                 var zonePolygons = response.getReturnValue(); 
                
                for (var i=0;i<zonePolygons.length;i++){
                    
                    var polygonsBoundaries = JSON.parse(zonePolygons[i].Boundary_Coordinates__c);
                    let polygons = new google.maps.Polygon({ paths: [polygonsBoundaries] });
                 
                    if(google.maps.geometry.poly.containsLocation(myPosition,polygons)){
                       alert(zonePolygons[i].Name);
                    }else{
                        console.log('No match',zonePolygons[i].Boundary_Coordinates__c)
                        alert('no Match')
                    }
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
        }catch(e){
                    console.log('err--'+e.message)
                }
    },
     deleteCheckOutChildAssetsHandler : function(component, event, helper){
        
        
        var action = component.get('c.deleteCheckOutChildAssets');
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
                
                component.set('v.chkOutlocation', res[0].Id);
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
                    component.set("v.checkOutFor",'Vehicle Rental');
                }else if(res.Grade__c.includes('TECH')){
                    
                     component.set("v.checkOutFor",'Maintenance');
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
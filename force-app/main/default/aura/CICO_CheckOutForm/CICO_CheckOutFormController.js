({
	doInit : function(component, event, helper) {
      
        
       helper.setImageURLOnLoad(component);   //No image setup  
       helper.getAssetTypePicklistValuesHandler(component,event, helper);
         
        
       /*let lat='',lng='';
        if (navigator.geolocation) {
             
            navigator.geolocation.getCurrentPosition(function (p) {
              
                lat = p.coords.latitude;
                lng= p.coords.longitude;
               
                component.set('v.vfUrl','../apex/CICO_googleMap_polygonChecker?lat='+lat+'&long='+lng);
                
                window.addEventListener("message", $A.getCallback(function(event) {
                    console.log('--->'+event.origin);
                    console.log('--->'+event.data);
                }));   
                //alert(lat+'--'+lng)
              // alert(lat.toString().substring(0, 8)+'--'+lng.toString().substring(0, 8));
            });
        }else {
            alert('Geo Location feature is not supported in this browser.');
        }
       */    
             
        let status = component.get("v.recordStatus");
        if(status =='New'){
             helper.getUserTypeInfo(component,event, helper);   
        }
        
        if(status == 'Draft'){
          
            helper.getChildAssetHandler(component, event, helper);
        }
        if(status == 'Check Out'){ 
          
            component.set("v.readMode",true);
            helper.getChildAssetHandler(component, event, helper);
        }
      
	},
    onloadHandler :function(component, event, helper) {
        
     
        let status = component.get("v.recordStatus");
       
        if(status == 'New'){
             
            component.set("v.readMode",false);
           
            let currentTime  = $A.localizationService.formatDate(new Date(), "yyyy-MM-ddTHH:mm:ss");
           
            //component.set("v.checkOutDate",currentTime );
            component.set("v.driverId", null);
            component.set("v.driverName", null);
            component.set("v.recieverName",null);
            component.set("v.recieverId",null);
            
            component.set("v.inspectionName",null);
            component.set("v.inspectionId",null);
            
             if(component.get("v.callAssetOnce")){
                 component.set("v.assetType",null);
                 component.set("v.referenceNumber",null);
                 component.set("v.recordId",'');
                 component.set("v.sliderVal",0);
                 component.set('v.chkOutlocation','');
                  helper.getUserLoginDetails(component,event, helper);
                 component.set('v.chkOutKmReadng','');
               component.set("v.callAssetOnce",false);
             }
           
                                 
          
        } 
        
      if(status == 'Draft' && component.get("v.callOnce")){
           
            //helper.showRelatedDataHelper(component, event, helper);
           
            helper.getVehicleAssetsAndCustomerInfoHandler(component, event, helper);
              let currentTime  = $A.localizationService.formatDate(new Date(), "yyyy-MM-ddTHH:mm:ss");
              
              //component.set("v.checkOutDate",currentTime );              
                     
             component.set("v.callOnce",false);
           let data = component.get("v.record");
        component.set('v.assetType',data.Internal_No__r.Asset_Type__c);
           helper.getFileDetails(component, event, helper);  
         
            
        }
      if(status == 'Check Out'  && component.get("v.callOnce")){ 
           
          component.set("v.showAsset",false);       
          //helper.showRelatedDataHelper(component, event, helper);
          helper.getFileDetails(component, event, helper);
          //helper.getVehicleAssetsAndCustomerInfoHandler(component, event, helper);
          
          component.set("v.callOnce",false);
             
        }
        
        
           
    },
    onForceLoad :function(component, event, helper) {
        
       var eventParams = event.getParams();
       // alert(eventParams.changeType) 
        try{
          let status = component.get("v.recordStatus");
        let data = component.get("v.record");
            if(data.New_Driver__c){
                component.set("v.driverName",data.New_Driver__r.Name);
                component.set("v.driverId",data.New_Driver__c);
            }
            
            if(data.Inspected_By__c){
                component.set("v.inspectionName",data.Inspected_By__r.Name);
                component.set("v.inspectionId",data.Inspected_By__c);
                
            }
            
            if(data.Reference_Number__c){
                 component.set("v.referenceNumber",data.Reference_Number__c);                
            } 
        
       
         component.set("v.vehicleId",data.Internal_No__c);
            if(data.Internal_No__c){
                component.set("v.vehicleInternalNo",data.Internal_No__r.Name);
                component.set("v.assetType",data.Internal_No__r.Asset_Type__c);
                
                
            } 
            
         if(data.Receiver_Name__c)
         component.set("v.recieverName",data.Receiver_Name__r.Name);
         component.set("v.recieverId",data.Receiver_Name__c);
            
          
            
          if(data.Check_Out_For__c){
            let checkoutfor = data.Check_Out_For__c;
             
            
             //maintanance related fields
              if(checkoutfor == 'Maintenance' || checkoutfor =='Vehicle Transfer'){
                  
                  component.set("v.showInMaintainance",true);
              }else{
                  component.set("v.showInMaintainance",false);
              }
              
               //Vehicle Rental realted fields
               if(checkoutfor == 'Vehicle Rental'){
                  
                  component.set("v.showCustomInfo",true);
                  component.set("v.showInspectedBy",true);
                   
               }else if(checkoutfor == 'Maintenance'){
                    component.set("v.showCustomInfo",false);
                   component.set("v.showInspectedBy",true);
               }else if(checkoutfor == 'Internal Assignments'){
                     component.set("v.showCustomInfo",true);
                   component.set("v.showInspectedBy",false);

               } else{
                  component.set("v.showCustomInfo",false);
                  component.set("v.showInspectedBy",false);
              } 
              
            }
            
       
        
        let fuel = component.get("v.record.Check_Out_fuel_reading__c");
        component.set("v.sliderVal",fuel);
           
              
        if(status != 'New')
        helper.dynamicFuelGuage(component,fuel);
        
        let checkInId = component.get("v.record.Check_In__c");
       
      
        if(checkInId){
            
            if(status != 'New')   { 
               if(data.Check_Out_For__c)
               component.set("v.checkOutFor",data.Check_Out_For__c);
               helper.getCheckInDetailsByCheckInIdHandler(component, event, helper);
               
           /*  if(status  != 'Check Out')
             component.set("v.checkOutFor",null);*/
	        //component.set("v.checkOutFor",checkoutfor);
            }
        }else{
            if(component.get("v.callonForceLoad")){
              
                if(status  != 'Check Out')
                component.set("v.checkOutFor",null);
                
                component.set("v.callonForceLoad",false);
               }
             
            
        }
        }catch(e){
            
            console.log('-error--'+e.message);
        }
        
         
    },
    
     sliderHandler :function(component, event, helper) {
         var val = component.get("v.sliderVal");
         
         component.set("v.sliderVal",val); 
         helper.dynamicFuelGuage(component,val);
      //let timer = setTimeout(()=>{},1000)

    },
    scriptsLoaded2 :function(component, event, helper) {
       
       let status = component.get("v.recordStatus");
        if(status == 'New'){
            
            helper.loadFuelGuage(component);
            helper.loadFuelGuageCheckIn(component,0);
        }
          helper.loadFuelGuageCheckIn(component,0);
    
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
        var target =component.find("CheckOut").getElement();// document.getElementById('foo'); // your canvas element
        var gauge = new Gauge(target).setOptions(opts); // create sexy gauge!
        gauge.maxValue = 100; // set max gauge value
        gauge.setMinValue(0);  // Prefer setter over gauge.minValue = 0
        gauge.animationSpeed = 46; // set animation speed (32 is default value)
        // let val = component.get("v.sliderVal");
        gauge.set(0); 
        
       let vol = component.find("vol").getElement(); 
        vol.addEventListener("input", function (e){
           
            gauge.set(vol.value);
        },false);
      
    },
    
     doInitCanvas : function(component, event, helper) {
         
         //Range slider logic      
       
         let vol = component.find("vol").getElement();
         let rangeVal = component.find("rangeVal").getElement();
         let fuelWarn = component.find("fuelWarn").getElement();
         
         
         vol.addEventListener("input", function (e){
             
             component.set("v.sliderVal",vol.value);
             let checkInVal = component.get("v.checkInInfo.Check_in_fuel_reading__c");
             
             if(checkInVal === null){
                  fuelWarn.style="display:block";
             }else if(component.get("v.sliderVal") < checkInVal){
                 fuelWarn.style="display:block";
             }else{
                  fuelWarn.style="display:none";
             }
                         
         },false);        
         
         
        //Canvas for car diagram start
        let status = component.get("v.recordStatus"); 
       if(status != 'Check Out'){
        try{       
            var canvas, ctx, flag = false,
                prevX = 0,
                currX = 0,
                prevY = 0,
                currY = 0,
                currentCanvas,
                temp = [],
                dot_flag = false;
            
            var x = "red",
                y = 2,
                w,h;
            canvas= component.find("canvasDia").getElement();
           
            var ratio = Math.max(window.devicePixelRatio || 1, 1);
            w = canvas.width*ratio;
            h = canvas.height*ratio;
            ctx = canvas.getContext("2d");
            var img = component.find('customImg').getElement(); 
            var myStorage = localStorage;
            img.onload = function() {
                ctx.drawImage(img,0,0,img.width,img.height);
                initLocalStorage();
            }
           
            //console.log('ctx:='+ctx);
            
            canvas.addEventListener("mousemove", function (e) {
                findxy('move', e)
            }, false);
            canvas.addEventListener("mousedown", function (e) {
                findxy('down', e)
            }, false);
            canvas.addEventListener("mouseup", function (e) {
                findxy('up', e)
                setLocalStoreage()  
            }, false);
            canvas.addEventListener("mouseout", function (e) {
                findxy('out', e)
            }, false);
            // Set up touch events for mobile, etc
            canvas.addEventListener("touchstart", function (e) {
                var touch = e.touches[0];
                //console.log('touch start:='+touch);
                var mouseEvent = new MouseEvent("mousedown", {
                    clientX: touch.clientX,
                    clientY: touch.clientY
                });
                canvas.dispatchEvent(mouseEvent);
                e.preventDefault();
            }, false);
            canvas.addEventListener("touchend", function (e) {
                var mouseEvent = new MouseEvent("mouseup", {});
                canvas.dispatchEvent(mouseEvent);
                setLocalStoreage()
            }, false);
            canvas.addEventListener("touchmove", function (e) {
                var touch = e.touches[0];
                var mouseEvent = new MouseEvent("mousemove", {
                    clientX: touch.clientX,
                    clientY: touch.clientY
                });
                canvas.dispatchEvent(mouseEvent);
                e.preventDefault();
                
            }, false);
            
            // Get the position of a touch relative to the canvas
            function getTouchPos(canvasDom, touchEvent) {
                var rect = canvasDom.getBoundingClientRect();
                return {
                    x: touchEvent.touches[0].clientX - rect.left,
                    y: touchEvent.touches[0].clientY - rect.top
                };
            }
            
            function findxy(res, e){
                const rect = canvas.getBoundingClientRect();
                if (res == 'down') {
                    prevX = currX;
                    prevY = currY;
                    currX = e.clientX - rect.left ;
                    currY = e.clientY -  rect.top;
                    
                    flag = true;
                    dot_flag = true;
                    if (dot_flag) {
                        ctx.beginPath();
                        ctx.fillStyle = x;
                        ctx.fillRect(currX, currY, 2, 2);
                        ctx.closePath();
                        dot_flag = false;
                    }
                }
                if (res == 'up' || res == "out") {
                    flag = false;
                }
                if (res == 'move') {
                    if (flag) {
                        prevX = currX;
                        prevY = currY;
                        currX = e.clientX -  rect.left;
                        currY = e.clientY - rect.top;
                        draw(component,ctx);
                    }
                }
            }
            function draw() {
                
                ctx.beginPath();
                ctx.moveTo(prevX, prevY);
                ctx.lineTo(currX, currY);
                ctx.strokeStyle = x;
                ctx.lineWidth = y;
                ctx.stroke();
                
                ctx.closePath();
            }
            
             //Undo/Redo Code starts here
             function initLocalStorage(){
                myStorage.setItem("__log", JSON.stringify([]));
            }
            
          function setLocalStoreage(){
               
                var png = canvas.toDataURL();
                var logs = JSON.parse(myStorage.getItem("__log"));
               
                setTimeout(function(){
                logs.unshift({png});
               myStorage.setItem("__log", JSON.stringify(logs));
                currentCanvas = 0;
                temp = [];       }, 0);
                                  
              }
           let vol = component.find("backBtnCanvas").getElement();
                 
          vol.addEventListener("click", function (e){
                              
           var logs = JSON.parse(myStorage.getItem("__log"));  
           if(logs.length > 0){
                                 
           temp.unshift(logs.shift());                                  
           setTimeout(function(){
           myStorage.setItem("__log", JSON.stringify(logs));
           resetCanvas();
                                  
          if(logs.length != 0)
          drawJana(logs[0]['png']);
                                  
           }, 0);
          }
                                  
          });
                                  
         let vol2 = component.find("nxtBtn").getElement();
                                  
         vol2.addEventListener("click", function (e){
          var logs = JSON.parse(myStorage.getItem("__log"));
                                  
          if(temp.length > 0)
             {
             logs.unshift(temp.shift());
             setTimeout(function(){
             myStorage.setItem("__log", JSON.stringify(logs));
             resetCanvas();
             drawJana(logs[0]['png']);

        }, 0);
        }
       });
                                  
           
       function resetCanvas() {
            ctx.clearRect(0, 0, ctx.canvas.clientWidth, ctx.canvas.clientHeight);
            ctx.drawImage(img, 0,0,canvas.width,canvas.height);
       }                      
       function drawJana(src) {
             var img = new Image();
             img.src = src;
            img.onload = function() {
                ctx.drawImage(img, 0, 0);
                  }
        }
            
        } catch(e){
            console.log("-Diagram Canvas Error--"+e.message);
           
        }
        //Canvas for car diagram End--  
          //Canvas for Signature - Start
        try{
        var s_canvas, s_ctx, s_flag = false,
            s_prevX = 0,
            s_currX = 0,
            s_prevY = 0,
            s_currY = 0,
            s_dot_flag = false;
        
        var s_x = "blue",
            s_y = 2,
            s_w,s_h;
        s_canvas=component.find('canvasSign').getElement();
       
        var s_ratio = Math.max(window.devicePixelRatio || 1, 1);
        s_w = s_canvas.width*s_ratio;
        s_h = s_canvas.height*s_ratio;
        s_ctx = s_canvas.getContext("2d");
                            
        s_canvas.addEventListener("mousemove", function (e) {
            s_findxy('move', e)
        }, false);
        s_canvas.addEventListener("mousedown", function (e) {
            s_findxy('down', e)
        }, false);
        s_canvas.addEventListener("mouseup", function (e) {
            s_findxy('up', e)
        }, false);
        s_canvas.addEventListener("mouseout", function (e) {
            s_findxy('out', e)
        }, false);
        // Set up touch events for mobile, etc
        s_canvas.addEventListener("touchstart", function (e) {
            var s_touch = e.touches[0];
           // console.log('touch start:='+s_touch);
            var s_mouseEvent = new MouseEvent("mousedown", {
                clientX: s_touch.clientX,
                clientY: s_touch.clientY
            });
            s_canvas.dispatchEvent(s_mouseEvent);
            e.preventDefault();
        }, false);
        s_canvas.addEventListener("touchend", function (e) {
            var s_mouseEvent = new MouseEvent("mouseup", {});
            s_canvas.dispatchEvent(s_mouseEvent);
        }, false);
        s_canvas.addEventListener("touchmove", function (e) {
            var touch = e.touches[0];
            var s_mouseEvent = new MouseEvent("mousemove", {
                clientX: touch.clientX,
                clientY: touch.clientY
            });
            s_canvas.dispatchEvent(s_mouseEvent);
            e.preventDefault();
            
        }, false);
        
        // Get the position of a touch relative to the canvas
        function s_getTouchPos(canvasDom, touchEvent) {
            var rect = canvasDom.getBoundingClientRect();
            return {
                s_x: touchEvent.touches[0].clientX - rect.left,
                s_y: touchEvent.touches[0].clientY - rect.top
            };
        }
        
        function s_findxy(res, e){
            const rect = s_canvas.getBoundingClientRect();
            if (res == 'down') {
                s_prevX = s_currX;
                s_prevY = s_currY;
                s_currX = e.clientX - rect.left ;
                s_currY = e.clientY -  rect.top;
                
                s_flag = true;
                s_dot_flag = true;
                if (s_dot_flag) {
                    s_ctx.beginPath();
                    s_ctx.fillStyle = s_x;
                    s_ctx.fillRect(s_currX, s_currY, 2, 2);
                    s_ctx.closePath();
                    s_dot_flag = false;
                }
            }
            if (res == 'up' || res == "out") {
                s_flag = false;
            }
            if (res == 'move') {
                if (s_flag) {
                    s_prevX = s_currX;
                    s_prevY = s_currY;
                    s_currX = e.clientX -  rect.left;
                    s_currY = e.clientY - rect.top;
                    s_draw(component,ctx);
                }
            }
        }
        function s_draw() {
            
            s_ctx.beginPath();
            s_ctx.moveTo(s_prevX, s_prevY);
            s_ctx.lineTo(s_currX, s_currY);
            s_ctx.strokeStyle = s_x;
            s_ctx.lineWidth = s_y;
            s_ctx.stroke();
            
            s_ctx.closePath();
        }
        }catch(e){
            
            console.log('--Sign--Erro'+e.message);
        }
       }
        //Canvas for Signature - End
    },
    
     erase : function(component, event, helper){
        var m = confirm("Do you Want to clear?");
        if (m) {
            helper.setImageURLforCheckOut(component);
            var canvas=component.find('canvasDia').getElement();
            var img = component.find('customImg').getElement(); 
            var ctx = canvas.getContext("2d");
            var w = canvas.width;
            var h = canvas.height;
            ctx.clearRect(0, 0, w, h);
            ctx.drawImage(img, 0,0,w,h);
        }
    },
     eraseSign : function(component, event, helper){
        var m = confirm("Do you Want to clear?");
        if (m) {
            var canvas=component.find('canvasSign').getElement();
            var ctx = canvas.getContext("2d");
            var w = canvas.width;
            var h = canvas.height;
            ctx.clearRect(0, 0, w, h);
           
        }
    },    
    goToListView : function(component, event, helper) {
       
    
     var pageChangeEvent = component.getEvent("goToListView");
        pageChangeEvent.fire();
        component.set("v.readMode",false);
		
    },
    
    
     OnUpload : function(component, event, helper) {
          try{
             var files = component.get("v.uploadedDocs");
             
              var fileUploadWrapper = component.get("v.uploadedImgList");
              //var imgPreview =document.getElementById("imgPreview");
              var contentWrapperArr = [];
           
             if(files && files.length > 0) {
                for(var i=0; i < files[0].length; i++){
                  var file = files[0][i];
                    
                    
                    if(file.size ) { //< 2000000
                        var reader = new FileReader();
                        reader.name = file.name;
                        reader.type = file.type;
                      
                        reader.onloadend = function(e) {
                            
                            console.log(e.target.result.length);
                            try{
                                var ctx;
                                var img = new Image();
                                img.src = e.target.result;
                                var imgName = e.target.name;
                                var imgType = e.target.type;
                                 img.onload = function() {
                                  
                                  var w = img.naturalWidth;
                                  var h = img.naturalHeight;
                                     
                                var canvas = document.createElement("canvas");
                                var scaleFactor = 500 / w;
                                canvas.width = 500;
                                canvas.height = h*scaleFactor;
                             
                                ctx = canvas.getContext("2d");
                                ctx.drawImage(img, 0, 0, 500, h*scaleFactor);
                                     
                                     var newDataUrl = canvas.toDataURL('image/jpeg',0.5);
                                     //var tarRes =  downscaleImage(e.target.result, 200,'image/jpeg',0.7) ;
                                     //console.log(newDataUrl.length);
                                     //console.log(newDataUrl);
                                     if(newDataUrl.length < 1000000){
                                         fileUploadWrapper.push({
                                             'strFileName':imgName,
                                             'strFileType':imgType,
                                             'strBase64Data':newDataUrl
                                             
                                         });
                                         contentWrapperArr.push({
                                             'strFileName':imgName,
                                             'strFileType':imgType,
                                             'strBase64Data':newDataUrl                      
                                         });
                                         component.set("v.uploadedImgList",fileUploadWrapper);
                                         var start=component.get('v.start');
                                         var corousalSize=component.get('v.corousalSize');
                                         //start+=corousalSize;
                                         let imgList=component.get('v.uploadedImgList'); 
                                         component.set("v.noofUploadImg",imgList.length);
                                         if(imgList.length > corousalSize){
                                             component.set("v.carouselImgList",imgList.slice(start,start+corousalSize));
                                         }else{
                                              component.set("v.carouselImgList",imgList);
                                         }
                                         
                                    
                                         
                                     }else {
                                         
                                         helper.showToast('warning','warning','Image size must be less than 1MB');
                                     }
                                 }
                            }catch(e){
                                console.log('--err-'+e.message);
                            }
                            
                            
                            
                        }
                        
                        function handleEvent(event) {
                            if(contentWrapperArr.length == i){
                                
                                component.set("v.uploadedImgList",fileUploadWrapper);
                            }
                        }
                        reader.readAsDataURL(file);
                        reader.addEventListener('loadend', handleEvent);
                        
                    }
                    
             
                   }
              }
               //console.log('--data--'+ JSON.stringify(component.get("v.uploadedImgList")));
        }catch(e){
            console.log('---'+e.message);
        }
      
       
                            
    },
    
    removeImg : function(component, event, helper) {
        try{
        var index = event.target.dataset.index;
        var toremovefile = event.currentTarget.dataset.filename;
        
        var removefileToBeUploaded= component.get("v.uploadedImgList");
        removefileToBeUploaded.splice(index, 1);
        component.set("v.uploadedImgList", removefileToBeUploaded);
        
         var removefile = component.get("v.carouselImgList");
        removefile.splice(index, 1);
        component.set("v.carouselImgList", removefile);
        
        let uploadList = component.get("v.uploadedImgList");
        component.set("v.noofUploadImg",uploadList.length);
        
        let corousalSize=component.get('v.corousalSize'); 
        
       
       if(uploadList.length >= corousalSize)
         component.set("v.start",0);
              
        if(uploadList.length >= corousalSize){
        
            component.set("v.carouselImgList",uploadList.slice(0,0+corousalSize));
        }else{
            component.set("v.carouselImgList",uploadList);
        }
            
        }catch(e){
            console.log('-err-'+e.message);
        }
    },
    
    deleteFile:function(component, event, helper) {
         var fileId = event.currentTarget.dataset.filename;
          var index = event.target.dataset.index;
        
        var action = component.get('c.deleteFilewithVersionId');
            action.setParams({                 
                recId:fileId
                
            });
            action.setCallback(this, function(response) {
                var state = response.getState();
                
                if (state === "SUCCESS") {  
                    
                   helper.getFileDetails(component, event, helper);
                }
                else if (state === "ERROR") {
                    var errors = response.getError();
                    if (errors) {
                        if (errors[0] && errors[0].message) {
                            console.log("Error message: " + errors[0].message);
                            helper.showToast('error','error','Error-'+ errors[0].message);
                            
                        }
                    } else {
                        console.log("Unknown error");
                        
                    }
                }
            }); 
            
            $A.enqueueAction(action); 
        
    },
    deleteChildAsset :function(component, event, helper) {
        var recId = event.currentTarget.dataset.filename;
        var index = event.target.dataset.index;
              
        var action = component.get('c.deleteRecordInSF');
        action.setParams({                 
            recId:recId
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            
            if (state === "SUCCESS") {  
                
                var removefile = component.get("v.childAssetSavedList");
                removefile.splice(index, 1);
                component.set("v.childAssetSavedList", removefile);
            
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
        
        $A.enqueueAction(action)
    },
    
     getPreviousList: function(component, event, helper) {
        var corousalSize=component.get('v.corousalSize'); 
        var start=component.get('v.start'); 
        start-=corousalSize;
        var imgList=component.get('v.uploadedImgList'); 
        component.set('v.carouselImgList',imgList.slice(start,start+corousalSize)); 
        component.set('v.start',start);
        
    },
    getNextList: function(component, event, helper) {
        var corousalSize=component.get('v.corousalSize'); 
        var start=component.get('v.start'); 
        start+=corousalSize;
        var imgList=component.get('v.uploadedImgList'); 
        component.set('v.carouselImgList',imgList.slice(start,start+corousalSize)); 
        component.set('v.start',start); 
    },
     getPreviousSavedList : function(component, event, helper) {
        var corousalSize=component.get('v.corousalSize'); 
        var start=component.get('v.startSaved'); 
        start-=corousalSize;
        var imgList=component.get('v.checkOutSavedFiles'); 
        component.set('v.checkOutSavedFilesCaruosel',imgList.slice(start,start+corousalSize)); 
        component.set('v.startSaved',start);
        
    },
    
    getNextSavedList :function(component, event, helper) {
        var corousalSize=component.get('v.corousalSize'); 
        var start=component.get('v.startSaved'); 
        start+=corousalSize;
        var imgList=component.get('v.checkOutSavedFiles'); 
        component.set('v.checkOutSavedFilesCaruosel',imgList.slice(start,start+corousalSize)); 
        component.set('v.startSaved',start); 
    },
    
     showRelatedDataHandler : function(component, event, helper) {
       
         let pickVal = component.find("checkOutFor").get("v.value");
         if(pickVal == 'Vehicle Rental'){
             component.set("v.showCustomInfo",true);
             component.set("v.showInspectedBy",true);
         }else if(pickVal == 'Maintenance'){
              component.set("v.showCustomInfo",false);
             component.set("v.showInspectedBy",true);
         }else if(pickVal == 'Internal Assignments'){
              component.set("v.showCustomInfo",true);
             component.set("v.showInspectedBy",false);
         }else{
             component.set("v.showCustomInfo",false);
             component.set("v.showInspectedBy",false);
         } 
         //Maintainance data
         if(pickVal == 'Maintenance' || pickVal =='Vehicle Transfer'){
             
              component.set("v.showInMaintainance",true);
         }else{
             component.set("v.showInMaintainance",false);
         }
         
         
      helper.showRelatedDataHelper(component, event, helper);     
     
       
    },
    
    getPreviousListCI: function(component, event, helper) {
        var corousalSize=component.get('v.corousalSizeCI'); 
        var start=component.get('v.startCI'); 
        start-=corousalSize;
        var intimList=component.get('v.filesList'); 
        component.set('v.carouseFileList',intimList.slice(start,start+corousalSize)); 
        component.set('v.startCI',start);
        
    },
    getNextListCI: function(component, event, helper) {
        var corousalSize=component.get('v.corousalSizeCI'); 
        var start=component.get('v.startCI'); 
        start+=corousalSize;
        var intimList=component.get('v.filesList'); 
        component.set('v.carouseFileList',intimList.slice(start,start+corousalSize)); 
        component.set('v.startCI',start); 
    },
    
    customHandleSubmit : function(component, event, helper) {
        
        let btnVal = event.getSource().get("v.name");
        component.set('v.FormStatus',btnVal);
    },
   
    
    handleSubmit :function(component, event, helper) {
    
        event.preventDefault();
        component.set("v.toggleSpinner",true);
        var eventFields = event.getParam("fields");
        let btnVal = component.get('v.FormStatus');
        //eventFields["Check_Out_Status__c"] ='Draft';
        eventFields["Check_Out_fuel_reading__c"] =component.get("v.sliderVal");
        
        let currentTime  = $A.localizationService.formatDateUTC(new Date(), "yyyy-MM-ddTHH:mm:ss");
        //if(btnVal=='Check Out')
        //eventFields["Check_Out_Date__c"] =currentTime;
        
        var sign=component.find('canvasSign').getElement();
        
        
        let lastKmReadng = component.get("v.lastKmReading");
        let currentReadng=component.find("chkoutReading").get("v.value");
        
        let refNo = component.get("v.referenceNumber");
       
        //console.log(refNo);
        
        let chkInInfo =  component.get("v.checkInInfo");  
        let chkoutfor = component.get("v.checkOutFor");
        let driver =  component.get("v.driverId");
       
       let checkoutDate =  component.get("v.checkOutDate");  
        if(checkoutDate == null){
            checkoutDate = currentTime;
          }

        try{
            console.log('---kM reading--'+component.get("v.chkOutKmReadng"))
         if(currentReadng && currentReadng.toString().length > $A.get("$Label.c.CICO_KmLimit")){
             component.set("v.toggleSpinner",false);
            helper.showToast('Warning','warning','Km reading should be '+$A.get("$Label.c.CICO_KmLimit")+' Characters');
        }else if(chkInInfo && chkInInfo.Check_In_Date__c && chkInInfo.Check_In_Date__c > checkoutDate ){
            component.set("v.toggleSpinner",false);
            helper.showToast('Warning','warning','Check Out date should be greater than last check In date');
        }else if(refNo == null && chkoutfor!='Internal Assignments' ){ //&& checkinfor =='Maintenance'
            component.set("v.toggleSpinner",false);
            helper.showToast('Warning','warning','Assign/Fleet Service/Ref No. is required to do check Out');
        }else if(!driver && chkoutfor =='Internal Assignments'){
            component.set("v.toggleSpinner",false);
            helper.showToast('Warning','warning','Driver is required.');
        }else if(!component.get("v.inspectionId") &&(chkoutfor == 'Vehicle Rental'  || chkoutfor == 'Maintenance')){
            component.set("v.toggleSpinner",false);
            helper.showToast('Warning','warning','Inspected By is required.');
      
        }/*else if(lastKmReadng && currentReadng < lastKmReadng ){
            component.set("v.toggleSpinner",false); 
            helper.showToast('Warning','warning','Checkout KM reading is lessthan checkin');
        }*/else if(sign.toDataURL().length < 3000 && btnVal=='Check Out'){
            component.set("v.toggleSpinner",false);
            helper.showToast('Warning','warning','Signature is required');
            var canvas=component.find('canvasSign').getElement();
            var ctx = canvas.getContext("2d");
            var w = canvas.width;
            var h = canvas.height;
            ctx.clearRect(0, 0, w, h); 
            
        }else{
            //alert('save')
            component.find('CheckOutForm').submit(eventFields);
            
            
        }
        }catch(e){
            console.log('exception'+e.message)
        } 
        
              
        
    },
    
    handleSuccess : function(component, event, helper) {
       
        
        component.set("v.toggleSpinner",true);
        
        helper.updateVehicleMasterHandler(component, event, helper);        
        
        let uploadedDiagram = [];//component.get("v.uploadedDiagram");
         
         var diagram=component.find('canvasDia').getElement();
         var sign=component.find('canvasSign').getElement();
         
         var ctx = sign.getContext("2d");
          
         ctx.globalCompositeOperation = "destination-over";
         ctx.fillStyle = "#FFF"; //white
         ctx.fillRect(0,0,sign.width, sign.height);
         
       
         uploadedDiagram.push({
             'strFileName':'MarkedDiagram.png',
             'strFileType':'image/png',
             'strBase64Data':diagram.toDataURL()
             
         }); 
         uploadedDiagram.push({
             'strFileName':'Sign.png',
             'strFileType':'image/png',
             'strBase64Data':sign.toDataURL()
             
         }); 
        let imgList = component.get("v.uploadedImgList")
        //let Diagram2 = component.get("v.uploadedDiagram");
        let finalDocList = imgList.concat(uploadedDiagram);
        console.log(finalDocList.length)
         var params = event.getParams();
         let id = params.response.id;
        component.set("v.CheckOutSuccessId",id);
        
        let frmStatus = component.get("v.FormStatus");
        if(frmStatus != 'Draft'){
            helper.createChildAssetRec(component, event, helper);
        }
        
        component.set("v.recordId",id);
        
       
        
        //Submit req to Server
        var action = component.get('c.addImagesToRecId');
        action.setParams({
            recordId : id,
            imgData:JSON.stringify(finalDocList)
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
                       
            if (state === "SUCCESS") {  
                               
                
                //Stop server call in draft mode
                let frmStatus = component.get("v.FormStatus");
                if(frmStatus != 'Draft')
                helper.callOracleServer(component, event, helper);
                
                if(frmStatus == 'Draft'){
                    component.set("v.toggleSpinner",false);
                    helper.showToast('success','success','Your request has been draft successfully');
                    //navigatetoListView
                    var pageChangeEvent = component.getEvent("goToListView");
                    pageChangeEvent.fire();
                }
                
                              
                 
            }
            else if (state === "ERROR") {
               var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error message: " + errors[0].message);
                         helper.showToast('Error','Error','Internal Server Error'+errors[0].message);
                     component.set("v.toggleSpinner",false);
                        
                    }
                } else {
                    console.log("Unknown error");
                    component.set("v.toggleSpinner",false);
                    
                }
            }
          }); 
        
        $A.enqueueAction(action); 
        
       
        
    },
    
    handleError :function(component, event, helper) { 
    console.log(event.getParam("message"));
    },
    
   
    childAssetSubmit : function(component, event, helper) {
        event.preventDefault();
        //using createChildAssetRec to create child assets
        
    },
    
    
    childAssetSuccess : function(component, event, helper) {
        
         var params = event.getParams();
         let id = params.response.id;
        console.log('--'+id);
        
    },
    childAssetErr : function(component, event, helper) {
       
         console.log('--err--');
    },
    
    printPDF : function(component, event, helper) {
        
          window.open("../apex/CICO_CheckOutPdf?id="+component.get("v.recordId"), "Print Document");
    },
    
    sendEmailModelOpen :function(component, event, helper) {
        
        component.set("v.isSendEmailModalOpen",true);
        
    },
    closeModel : function(component, event, helper) {

        component.set("v.isSendEmailModalOpen",false);
    },
    closeEmailPopup : function(component, event, helper) {
        component.set("v.isSendEmailModalOpen",false);
    },
    assetTypeHandler : function(component, event, helper){
        
        let asset = event.getSource().get("v.value");
        component.set('v.assetType',asset);        
        
        helper.setImageURLforCheckOut(component);
    },
    openSearchModel : function(component, event, helper){
        
        component.set("v.showModalbox",true);
    },
    closeModel : function(component, event, helper){
        component.set("v.showModalbox",false);
    },
    handleChangeSearch : function(component, event, helper){
        let plateNumber = component.find("plateNumber").get("v.value");
        let plateColorCode= component.find("plateColorCode").get("v.value");
        let plateSource= component.find("plateSource").get("v.value");
        
        console.log(plateNumber +'--'+plateColorCode+'--'+plateSource)
        
    },
    searchHandler : function(component, event, helper){
       
        let plateNumber = component.find("plateNumber").get("v.value");
        let plateColorCode= component.find("plateColorCode").get("v.value");
        let plateSource= component.find("plateSource").get("v.value");
        let plateType = component.find("plateType").get("v.value");
        
        var action = component.get('c.getVehicleMasterList');
        action.setParams({                 
            plateNumber:plateNumber,
            PlateCode: plateColorCode,
            PlateSource:plateSource,
            PlateType:plateType
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            
            if (state === "SUCCESS") {  
              
                component.set("v.vehicleMasterList",response.getReturnValue());
                //console.log(response.getReturnValue())
               
                
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
    
    autoPopulateIntNo : function(component, event, helper){
        
        var id = event.currentTarget.dataset.id;
        component.find("internalNo").set("v.value",id);
        component.set("v.showModalbox",false);
    },
    googleMapScript : function(component, event, helper){
        
        console.log('Map is loaded');
        //helper.getZoneInfoFromCoordinates(component, event, helper);
    },
    checkOutAccessoriesHandler : function(component, event, helper){
        try{
        const checkBoxList = component.find('COAccesories');
        let accWarn = component.find("AccWarnMsg").getElement();
        let checkOutCount =0;
            for(var i=0; i < checkBoxList.length;i++){
                
                
                if(checkBoxList[i].get("v.value")){
                    checkOutCount++;
                }
            }
            if(checkOutCount < component.get('v.CIAssCount')){
                accWarn.style='display:block';
            }else{
                accWarn.style='display:none';
            } 
        
        
        }catch(e){
            console.log(e.message)
        }
        
    },
        
    DateValidation :function(component, event, helper){
         
         let checkoutDate = new Date(component.get("v.checkOutDate")); 
         let currentTime  = new Date($A.localizationService.formatDateUTC(new Date(), "yyyy-MM-ddTHH:mm:ss"));
         let days = (currentTime-checkoutDate)/8.64e7;
        
        if(days > 5){
            
            helper.showToast('Warning','warning','Check Out date allowed only for last 5 days');
            component.set("v.checkOutDate",null);
        }
       
    },
     lengthValidation : function(component, event, helper){
            
            let km = event.getSource().get("v.value");
            if(km.length >= $A.get("$Label.c.CICO_KmLimit")){
                
                event.preventDefault();
            }
      }
    
})
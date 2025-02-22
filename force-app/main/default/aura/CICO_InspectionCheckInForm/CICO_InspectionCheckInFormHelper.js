({
	 getUserLoginDetails : function(component, event, helper) {
   
    var action = component.get('c.getUserDetails');
      
        action.setCallback(this, function(response) {
            var state = response.getState();
                       
            if (state === "SUCCESS") {  
              
                
                component.set("v.userInfo", response.getReturnValue());
                                   
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
    
   
    getFileDetails : function(component, event, helper) {
        
        var action = component.get('c.getRecordFileDetails');
        
         action.setParams({ 
                
                RecId:component.get("v.vehicelSpecId")
                
            });
       
        action.setCallback(this, function(response) {
            var state = response.getState();
                     
            if (state === "SUCCESS") {  
              
               var data = response.getReturnValue();
               console.log(data)
                if(data.MarkedDiagram){
                    component.set('v.imgUrl','/CICO/sfc/servlet.shepherd/version/renditionDownload?rendition=ORIGINAL_Png&versionId='+data.MarkedDiagram);
                }else{
                   this.setImageURLforMarking(component);
                }
                if(data.Sign){
                    component.set('v.signUrl','/CICO/sfc/servlet.shepherd/version/renditionDownload?rendition=ORIGINAL_Png&versionId='+data.Sign);
                    var canvas=component.find('canvasSign').getElement();
                    var img = component.find('signImg').getElement(); 
                    var ctx = canvas.getContext("2d");
                    var w = canvas.width;
                    var h = canvas.height;
                                       
                    img.onload = function() {
                        ctx.drawImage(img, 0,0,500,100);
                    }
                    
                }
               if(data.Sign2){
                    component.set('v.signUrl2','/CICO/sfc/servlet.shepherd/version/renditionDownload?rendition=ORIGINAL_Png&versionId='+data.Sign2);
                    var canvas2=component.find('canvasSign2').getElement();
                    var img2 = component.find('signImg2').getElement(); 
                    var ctx2 = canvas2.getContext("2d");
                    var w2 = canvas2.width;
                    var h2 = canvas2.height;
                                       
                    img2.onload = function() {
                        ctx2.drawImage(img2, 0,0,500,100);
                    }
                    
                }
               if(data.Sign3){
                    component.set('v.signUrl3','/CICO/sfc/servlet.shepherd/version/renditionDownload?rendition=ORIGINAL_Png&versionId='+data.Sign3);
                    var canvas3=component.find('canvasSign3').getElement();
                    var img3 = component.find('signImg3').getElement(); 
                    var ctx3 = canvas3.getContext("2d");
                    var w3 = canvas3.width;
                    var h3 = canvas3.height;
                                       
                    img3.onload = function() {
                        ctx3.drawImage(img3, 0,0,500,100);
                    }
                    
                }
                if(data.Sign4){
                    component.set('v.signUrl4','/CICO/sfc/servlet.shepherd/version/renditionDownload?rendition=ORIGINAL_Png&versionId='+data.Sign4);
                    var canvas4=component.find('canvasSign4').getElement();
                    var img4 = component.find('signImg4').getElement(); 
                    var ctx4 = canvas4.getContext("2d");
                    var w4 = canvas4.width;
                    var h4 = canvas4.height;
                                       
                    img4.onload = function() {
                        ctx4.drawImage(img4, 0,0,500,100);
                    }
                    
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
    
    setImageURLforMarking : function(component){
         
        let assetType =component.get("v.assetType");
        //console.log('-asset Type---'+assetType);
       
        if(assetType){
              var imgUrl2 = $A.get('$Resource.CICO_Diagrams')+'/images/'+assetType+'.jpg';
        }else{
            var imgUrl2 = $A.get('$Resource.CICO_NoImage');
        }
      
        component.set('v.imgUrl',imgUrl2);
        
    }
    
})
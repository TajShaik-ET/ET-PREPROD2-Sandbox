({
	getIntimationDetails : function(component, event, helper) {
       
		var action = component.get('c.getIntimationWithRelatedDetails');
      
        action.setCallback(this, function(response) {
            var state = response.getState();
                
            if (state === "SUCCESS") {  
                var data =JSON.parse('['+response.getReturnValue()+']');
                component.set("v.intimationList", data);
                component.set("v.noOfIntimationList",data.length);
                var start=component.get('v.start');
                var corousalSize=component.get('v.corousalSize');
                //start+=corousalSize;
                
                if(data.length > corousalSize){
                       
                    component.set("v.CarousalintimationList",data.slice(start,start+corousalSize));
                }else{
                       
                    component.set("v.CarousalintimationList",data);
                }
                try{
                    // var data1 =component.get("v.intimationList");
                 //console.log('---'+JSON.stringify(data1));
                }catch(e){
                   console.log('---'+ e.message);
                    
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
    
    
    getUserLoginInformation : function(component, event, helper) {
   
    var action = component.get('c.getUserLoginInfo');
      
        action.setCallback(this, function(response) {
            var state = response.getState();
                       
            if (state === "SUCCESS") {  
                
                component.set("v.userLoginInfo", response.getReturnValue());
                let loginInfo = response.getReturnValue();
                console.log(loginInfo.Grade__c)
                if( loginInfo.Grade__c == 'OPER' ){ //loginInfo.Grade__c == 'TECH' ||
                    
                    component.set("v.showcico", false);
                    component.set("v.showInspectionTab", true);
                }else if(loginInfo.Grade__c == 'OPER-CICO'){
                    
                     component.set("v.showInspectionTab", false);
                     component.set("v.showcico", true);
                    //to show checkout default
                    component.set("v.selectedTab","checkout");
                    component.set("v.showCheckout",true);
                    component.set("v.showMotoTabs",false);
                }else if(loginInfo.Grade__c == 'MOTO'){
                     component.set("v.showInspectionTab", false);
                     component.set("v.showcico", false);
                    component.set("v.showMotoTabs",true);
                     component.set("v.selectedTab","ReceivingForm");
                     component.set("v.showReceivingForm",true);
                    
                }else{
                    
                    component.set("v.showcico", true);
                    component.set("v.showInspectionTab", true);
                }
                //console.log(response.getReturnValue());
                                   
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
	}
    
    
})
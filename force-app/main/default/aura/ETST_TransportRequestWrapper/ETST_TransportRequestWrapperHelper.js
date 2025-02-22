({
    doInit : function(component, event, helper) {
        var utility = component.find("ETST_UtilityMethods");
        var backendMethod = "getProfileDetails";
        
        var params = {
            
        };
        var promise = utility.executeServerCall(component, backendMethod, params);
        
        promise.then (
            $A.getCallback(function(response) {
                //changed logic to ETST_Emirates_Id field --- sreelakshmi sk 9/6/23
                component.set('v.EID',response.ETST_Emirates_Id__c);
                component.set('v.Phone',response.PersonMobilePhone);
                component.set('v.EtEid',response.ET_Emirates_Id__c);
                if(response.ETST_Emirates_Id__c==null|| response.ETST_Emirates_Id__c==undefined
                  || response.ETST_Emirates_Id__c==''){
                    component.set('v.needMoreInfo',true);
                    component.set('v.isEID',true);
                }
                if(response.PersonMobilePhone == null || response.PersonMobilePhone==''){
                    component.set('v.needMoreInfo',true);
                    component.set('v.isPhone',true);
                    
                }
                component.set('v.userId',response.Id);
            }),
            
            $A.getCallback(function(error) {
                var err = JSON.parse(error);
                var errorToShow = utility.convertToUserFriendlyErrMsg(err.MESSAGE);
                utility.showToast("School Tranport", errorToShow, "error", "dismissible");
            })
        )	

    },
    
    
     profileData: function(component, event, helper){
       
        var action = component.get('c.getProfileDetails');
      
        action.setCallback(this, function(response) {
            var state = response.getState();
                       
            if (state === "SUCCESS") {  
                let data = response.getReturnValue();
                
                component.set("v.govParent",data.Government_School_Parent__c);
               
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
    
    updateProfile: function(component, event, helper) {
        var utility = component.find("ETST_UtilityMethods");
        var backendMethod = "updateProfile";
        
        var params = {
            'eid':component.get('v.EID'),
            'Phone':component.get('v.Phone'),
            'userId':component.get('v.userId'),
        };
        var promise = utility.executeServerCall(component, backendMethod, params);
        
        promise.then (
            $A.getCallback(function(response) {
                component.set('v.needMoreInfo',false);                
                           
            }),
            
            $A.getCallback(function(error) {
                var err = JSON.parse(error);
                var errorToShow = utility.convertToUserFriendlyErrMsg(err.MESSAGE);
                console.log(errorToShow);
				utility.showToast("School Tranport", $A.get("$Label.c.ETST_Customer_Error_Msg"), "error", "dismissible");
            })
        )	

    },
})
({
	doInit : function(component, event, helper) {
        //component.set('v.loaded',false);
        var utility = component.find("ETST_UtilityMethods");
        var backendMethod = "getProfileDetails";
        
        var params = {
            
        };
        var promise = utility.executeServerCall(component, backendMethod, params);
        
        promise.then (
            $A.getCallback(function(response) {
                 component.set('v.userId',response.Id);
                 component.set('v.userName',response.Name);
                 component.set('v.isGovtParent',response.Government_School_Parent__c);

                if(response.ET_Preferred_Location__c==null|| response.ET_Preferred_Location__c==undefined
                  || response.ET_Preferred_Location__c==''){
                    component.set('v.needMoreInfo',true);
                }else{
                    component.set('v.loc',response.ET_Preferred_Location__c);                    
                    helper.changeLocation(component, event, helper,response.ET_Preferred_Location__c);
                    helper.updateAccChangedLocation(component, event, helper,response.ET_Preferred_Location__c);
                   
                }
              // component.set('v.loaded',true);
               
            }),
            
            $A.getCallback(function(error) {
                var err = JSON.parse(error);
                var errorToShow = utility.convertToUserFriendlyErrMsg(err.MESSAGE);
                utility.showToast("School Tranport", errorToShow, "error", "dismissible");
            })
        )	

    },
   updateProfile: function(component, event, helper) {
        //debugger;
        var utility = component.find("ETST_UtilityMethods");
        var backendMethod = "updateUserLoc";
        
        var params = {
            'loc':component.get('v.loc'),            
            'userId':component.get('v.userId')
        };
        var promise = utility.executeServerCall(component, backendMethod, params);
        
        promise.then (
            $A.getCallback(function(response) {
                component.set('v.needMoreInfo',false);    
                helper.changeLocation(component, event, helper,component.get('v.loc'));       
                //$A.get('e.force:refreshView').fire();  
            }),
            
            $A.getCallback(function(error) {
                var err = JSON.parse(error);
                var errorToShow = utility.convertToUserFriendlyErrMsg(err.MESSAGE);
                utility.showToast("School Tranport", errorToShow, "error", "dismissible");
            })
        )	

    },
   updateAccChangedLocation: function(component, event, helper,selectedLocation) {
         
        // debugger;
        var utility = component.find("ETST_UtilityMethods");
        var backendMethod = "updateUserChangedLoc";
        
        var params = {
            'loc':selectedLocation,            
            'userId':component.get('v.userId')
        };
        var promise = utility.executeServerCall(component, backendMethod, params);
        
        promise.then (
            $A.getCallback(function(response) {
               //console.log('--res--'+response);
                //component.set('v.needMoreInfo',false);                
                //helper.changeLocation(component, event, helper,component.get('v.loc'));           
            }),
            
            $A.getCallback(function(error) {
                var err = JSON.parse(error);
                var errorToShow = utility.convertToUserFriendlyErrMsg(err.MESSAGE);
                utility.showToast("Inspection", errorToShow, "error", "dismissible");
            })
        )	

    },
    changeLocation: function(component, event, helper,selectedLocation) {
        // debugger;
        if (selectedLocation == "Dubai") {     
            component.set("v.showSchool", true);
            component.set("v.showInspection",false);
            
        }
        else if(selectedLocation=="Abu Dhabi"){
            component.set("v.showSchool",true);
            component.set("v.showInspection", true);
        }
        else if(selectedLocation=="All"){
            component.set("v.showInspection",true);
            component.set("v.showSchool", true);
            }
          else if(selectedLocation=="Fujairah"){
            component.set("v.showInspection",true);
            component.set("v.showSchool", true);
            }
           else if(selectedLocation=="Sharjah"){
                        component.set("v.showInspection",true);
                        component.set("v.showSchool", true);
           }else{
                component.set("v.showInspection",false);
                component.set("v.showSchool", true);
           }
     },
    
    getServiceLocDetails : function(component, event, helper) {
        // debugger;
        var utility = component.find("ETST_UtilityMethods");
        var backendMethod = "getServiceLocationDetails";
        
        var params = {
            
        };
        var promise = utility.executeServerCall(component, backendMethod, params);
        
        promise.then (
            $A.getCallback(function(response) {
                console.log('---->'+JSON.stringify(response));
                component.set("v.serviceMap",response);
                var school=component.get('v.serviceMap.School_Transport');
                var selectedLocation=component.get('v.loc');
                if(school.includes(selectedLocation)){
                    component.set('v.showSchool',true);
                }else{
                    component.set('v.showSchool',false);
                }
                var inspection=component.get('v.serviceMap.Vehicle_Inspection');
                if(inspection.includes(selectedLocation)){
                    component.set('v.showInspection',true);
                }else{
                    component.set('v.showInspection',false);
                }
                var spea=component.get('v.serviceMap.SPEA_Inspection');
                if(spea){
                    if(spea.includes(selectedLocation)){
                        component.set('v.showSPEA',true);
                    }else{
                        component.set('v.showSPEA',false);
                    }
                }
                
               // debugger;
                var limo=component.get('v.serviceMap.Limo_Services');
                console.log('limo = '+ limo);
                console.log('selectedLocation = '+ selectedLocation);
                if(limo){
                    if(limo.includes(selectedLocation)){
                        component.set('v.showLimo',true);
                    }else{
                        component.set('v.showLimo',false);
                    }
                }
                var rental=component.get('v.serviceMap.Rental_Services');
                console.log('showRental = '+ rental);
                console.log('selectedLocation = '+ selectedLocation);
                if(limo){
                    if(limo.includes(selectedLocation)){
                        component.set('v.showRental',true);
                    }else{
                        component.set('v.showRental',false);
                    }
                }
                
                //component.set('v.loaded',true);
            }),
            
            $A.getCallback(function(error) {
                var err = JSON.parse(error);
                var errorToShow = utility.convertToUserFriendlyErrMsg(err.MESSAGE);
                utility.showToast("School Tranport", errorToShow, "error", "dismissible");
            })
        )	

    }
       
})
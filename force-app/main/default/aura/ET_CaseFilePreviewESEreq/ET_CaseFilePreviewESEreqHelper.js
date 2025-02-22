({
   
  getuploadedFiles:function(component){
       
      var action = component.get("c.getFiles"); 
      var documentId=component.get("v.ticketId");
      
      action.setParams({  
          fileId : component.get("v.ticketId")
      });      
      action.setCallback(this,function(response){  
          var state = response.getState();  
          if(state=='SUCCESS'){ 
              console.log(state);
              
              var result = response.getReturnValue(); 
              console.log(result);
              
              component.set('v.files',result); 
              
              
          } 
          
      });  
      $A.enqueueAction(action);  
  },
    
    delUploadedfiles : function(component,documentId) {  
        var action = component.get("c.deleteFiles");           
        action.setParams({
            "sdocumentId":documentId            
        });  
        action.setCallback(this,function(response){  
            var state = response.getState();  
            if(state=='SUCCESS'){  
                this.getuploadedFiles(component);
                component.set("v.Spinner", false); 
            }
            
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                title : 'Success',
                message: 'This is File deleted successfully',
                duration:' 5000',
                key: 'info_alt',
                type: 'success',
                mode: 'pester'
        });
        toastEvent.fire();
            
        });  
        $A.enqueueAction(action);  
    }, 
    
     getProfiledata: function(component, event, helper,status){ 
         alert(state);
        var action = component.get('c.getprivateschoolUserData');
        action.setParams({
            
        });
        action.setCallback(this, function (a) {
            var state = a.getState();  
            
            if (state == 'SUCCESS') {
                alert(state);
                var result=a.getReturnValue();               
                component.set('v.userParentProfileWrap', result);  
                console.log('sas'+JSON.stringify(result));
              if(result.loggedinUserProfileName == 'Govt School Partner User Login'){
                       component.set('v.isGovDepartment', true);
                    }                
            }else{
                alert('Error in getting User details');
            }
       
        });
        $A.enqueueAction(action);       
    },
    
    getProfiledata: function(component, event, helper, status) {    
    var action = component.get('c.getuserDetails');
    action.setParams({});

    action.setCallback(this, function (a) {
        var state = a.getState();            
        if (state == 'SUCCESS') {
            var result = a.getReturnValue();  
            console.log('Result: ' + JSON.stringify(result));

            // Extract email and profile name
            var userEmail = result.Email ? result.Email.toLowerCase() : '';
            var profileName = result.Profile ? result.Profile.Name : '';
            
            console.log('User Email: ' + userEmail);
            console.log('Profile Name: ' + profileName);

            // Check if the user is an ESE user
            if (
                userEmail === 'adel.almarzooqi@ese.gov.ae' ||
                userEmail === 'malha.albreiki@ese.gov.ae' ||
                userEmail === 'mohd.jibriel@ese.gov.ae' ||
                userEmail === 'noura.aldhaheri@ese.gov.ae' ||
                userEmail === 'darcy.aubrey@ese.gov.ae'
            ) {
                component.set('v.isESEuser', true);
            }

            // Check if the user is Humaid
            if (userEmail === 'humaid.alshamsi@ese.gov.ae') {
                component.set('v.ishumid', true);
                component.set('v.isESEuser', true);
            }

            // Check if the user belongs to the Government Department based on profile name
            if (profileName === 'Govt School Partner User Login') {
                component.set('v.isGovDepartment', true);
            } else {
                // Ensure flags are reset if conditions are not met
                component.set('v.isGovDepartment', false);
            }
        } else {
            console.error('Error fetching user details: ' + state);
        }
    });

    $A.enqueueAction(action);       
}

      
})
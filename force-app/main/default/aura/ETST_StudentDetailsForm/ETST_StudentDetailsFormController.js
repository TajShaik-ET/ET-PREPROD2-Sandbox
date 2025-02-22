({
    doInit : function(component, event, helper) {
        
        var url_string = window.location.href; 
        var url = new URL(url_string);
        console.log('url***'+url);
        var requestId = url.searchParams.get("requestId");
        console.log('requestId***'+requestId);
        var documentId = url.searchParams.get("docId");
        console.log('documentId***'+documentId);
        var lang = url.searchParams.get("lang");
        console.log('lang***'+lang);
        if(requestId != null && requestId != '' && requestId != undefined) {
            component.set("v.requestId", requestId);
            helper.getServiceDetails(component, event, helper);
        }
        
        if(documentId != null && documentId != '' && documentId != undefined){
            var prefixURL = component.get("v.prefixURL");
            var imageURL = prefixURL+documentId;
            component.set("v.documentId", documentId);
            component.set("v.imageURL", imageURL);  
        } 
        if (navigator.geolocation) {
            //alert("able to retrieve your location1");
            navigator.geolocation.getCurrentPosition(function(position) {
                var latit = position.coords.latitude;
                var longit = position.coords.longitude;
                component.set('v.lat',latit);
                component.set('v.lon',longit);
                component.set('v.vfUrl','/apex/ETST_GoogleMapFinder?lat='+latit+'&long='+longit);
       
            });
         
        }else{
            console.log("Unable to retrieve your location");
        }    
        helper.setCommunityLanguage(component, event, helper);
        var urlString=window.location.href;
        
        var vfOrigin = urlString.substring(0, urlString.indexOf("/customer/s"));
         window.addEventListener("message", $A.getCallback(function(event) {
            
            if (event.origin !== vfOrigin) {
                // Not the expected origin: Reject the message!
                //console.log(event.data);
                return;
            }
            // Handle the message
            console.log(event);
            var message = event.data;
            console.log('message-->'+message);
            /*if(message=='PaymentCancelled'){
                //helper.redirectTo(component, '/etst-home-page');
            }*/
            var res = message.split("~");
            if(res.length > 0){ 
                
                 component.set('v.lat',res[0]);
                component.set('v.lon',res[1]);
                
                
            }
            
            /*if(messageText == 'SUCCESS'){
                 // component.set("v.currentStep",'Payment success');
                  helper.updateTransportRequestStatus(component, event, helper);
                  return;
            }*/
            
            
        }), false);
       // alert('serviceInfo****'+component.get("v.serviceInfo"));
        console.log('lang:'+component.get("v.clLang"));
    },
    
    // Added by Sreelakshmi SK 5/6/23
    onForceLoad: function(component, event, helper){
      let data = component.get("v.studentRecord");  
        console.log('schoolname:'+data.ETST_School_Name__r.ETST_Account_Type__c);
        if(data.ETST_School_Name__r.ETST_Account_Type__c=="Government School"){
            component.set("v.showPayment",false);
            component.set("v.showSupportButton",false);
            component.set("v.showNote",true);
            component.set("v.showPInfoSave",false);
            component.set("v.PersonalIfoforGov",true);
        }
    },
    
    openModel: function(component, event, helper) {
      // Set isModalOpen attribute to true
      component.set("v.isModalOpen", true);
   },
   closeModel: function(component, event, helper) {
      // Set isModalOpen attribute to false  
      component.set("v.isModalOpen", false);
   },
  
    handleUploadFinished: function (component, event, helper) {
        // Get the list of uploaded files
        var uploadedFiles = event.getParam("files");
        console.log('uploadedFiles'+JSON.stringify(uploadedFiles));
        var documentId = uploadedFiles[0].documentId;
        console.log('documentId'+documentId);
        component.set('v.documentId',documentId);
        helper.getImageContent(component, event, helper);
        $A.get('e.force:refreshView').fire();
        
    },
   submitDetails: function(component, event, helper) {
      // Set isModalOpen attribute to false
      //Add your code to call apex method or do some processing
      component.set("v.isModalOpen", false);
   },
    cancelSave: function(component, event, helper) {
        helper.redirectTo(component, '/etst-home-page?lang='+component.get("v.clLang"));
    },
    onLoadActions: function(component, event, helper) {
        component.set("v.showSpinner",false);
        component.set("v.disabled",false);
        component.set('v.currentSchoolName',component.find("ETST_School_Name__c").get("v.value"));
        //alert(component.get('v.currentSchoolName'));
    },
    onSchoolChangeAction: function(component, event, helper) { 
        component.set('v.newSchoolName',component.find("ETST_School_Name__c").get("v.value"));
        //alert(component.get('v.newSchoolName'));
    },
    onError : function(component, event, helper) {
        console.log('Inside Error handling');
        var error = event.getParam("error");
        console.log('error***'+JSON.stringify(error)); 
        component.set("v.showSpinner",false);
        component.set("v.disabled",false);
    },
    onSuccess : function(component, event, helper) {
        var payload = event.getParams().response;
        console.log(payload.id);
        component.set("v.showSpinner",false);
        var utility = component.find("ETST_UtilityMethods");
        utility.showToast("School Tranport", 'Student details Succefully saved!', "success", "dismissible");
    },
    onSubmit : function(component, event, helper) {
        component.set("v.showSpinner",true);
        component.set("v.disabled", true);
        var currentSchool=component.get('v.currentSchoolName');
        var newSchool=component.get('v.newSchoolName');
        console.log('currentSchool***'+currentSchool);
        console.log('newSchool***'+newSchool);
        var utility = component.find("ETST_UtilityMethods");
        if(currentSchool!=newSchool && component.get("v.requestId")!=null && newSchool !='' && newSchool!=undefined){
            utility.showToast("School Tranport", 'Existing transport request will be deactivated if you change the school', "success", "dismissible");
            //alert('Existing transport request will be deactivated if you change the school');
            helper.deactivateService(component, event, helper);
        } 
        event.preventDefault();   
        var eventFields = event.getParam("fields");
        component.find('StudentDetailsEditForm').submit(eventFields);
    },
    saveServiceDetails: function(component, event, helper) {
        var isChange = component.get("v.myBool");
        var currentSchool=component.get('v.currentSchoolName');
        var newSchool=component.get('v.newSchoolName');
        var emiratesId = component.find("inputCmp").get("v.value");
        var utility = component.find("ETST_UtilityMethods");
        console.log('newSchool***'+newSchool); 
        console.log('currentSchool***'+currentSchool);
        console.log('isChange***'+isChange);
        console.log('emiratesId***'+emiratesId); 
        var inputCmp = component.find("inputCmp");
       /* var fieldstoValidate = inputCmp.get("v.value");
        var blank=0;
        if(fieldstoValidate.length!=undefined) {
            console.log('value***'+fieldstoValidate.length);
                // Iterating all the fields
                var allValid = fieldstoValidate.reduce(function (validSoFar, inputCmp) {
                // Show help message if single field is invalid
                inputCmp.showHelpMessageIfInvalid();
                // return whether all fields are valid or not
                return validSoFar && inputCmp.get('v.validity').valid;
                }, true);
                // If all fields are not valid increment the counter
                if (!allValid) {
                    blank++;
                }
            } else {
                // If there is only one field, get that field and check for validity (true/false)
                var allValid = fieldstoValidate;
                // If field is not valid, increment the counter
                if (!allValid.get('v.validity').valid) {
                    blank++;
           		}
            } */
		if(currentSchool!=newSchool && component.get("v.requestId")!=null && newSchool !=''){
            utility.showToast("School Tranport", 'Existing transport request will be deactivated if you change the school', "success", "dismissible");
            //alert('Existing transport request will be deactivated if you change the school');
            helper.deactivateService(component, event, helper);
        }
       /* if(isChange == true && (newSchool == null || newSchool == 'undefined' || newSchool == '')){
            utility.showToast("School Tranport", 'School should not be empty', "Error", "dismissible");
        } 
        else if(emiratesId == ''){
            utility.showToast("School Tranport", 'Emirates Id shouls not be empty', "Error", "dismissible");
        } 
        else{ */
       	 utility.showToast("School Tranport", 'Student details Succefully saved!', "success", "dismissible");
       // } 
    },
    openFeedbackModal: function(component, event, helper){
        component.set('v.isfeebackModal',true);
    },
    changeLoc: function(component,event){
        component.set('v.openpickupMap',true);        
        component.set('v.locType',event.getSource().get('v.value'));
        
    },
    closePickupModel: function(component){
        component.set('v.openpickupMap',false);
    },
    
    updateLocationController: function(component, event, helper){
         helper.updateLocationHelper(component, event, helper);
    },
    getSearchResultbyEnter: function(component, event, helper) {
         
         window.addEventListener("keyup", function(event) {
         if(event.code == "Enter"){
             component.set('v.mapLoaded',false);
             helper.getAddressRecommendations(component, event,helper, component.get('v.searchText'));
         } 
          }, true);
    },
    getSearchResult: function(component, event, helper) {
        component.set('v.mapLoaded',false);
         helper.getAddressRecommendations(component, event,helper, component.get('v.searchText'));
         
    }
    
})
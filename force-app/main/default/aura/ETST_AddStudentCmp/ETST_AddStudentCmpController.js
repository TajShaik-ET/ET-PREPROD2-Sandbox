({
    doInit : function(component, event, helper) {
        helper.doInit(component, event, helper);         
       	helper.setCommunityLanguage(component, event, helper); 
        var lang=component.get('v.clLang');
        console.log('lang***'+lang);
        if(lang=='ar'){
            component.set('v.studentType',null);
            $A.util.addClass(component.find("mainDiv"), 'slds-modal__bodyrtl');
            $A.util.addClass(component.find("labelDiv"), 'custom_label_AR');
            $A.util.addClass(component.find("eidDiv"), 'teltextno_AR');
            $A.util.addClass(component.find("ETST_Date_of_Birth__c"), 'slds-input__icon--left');
            $A.util.removeClass(component.find("mainDiv"), 'slds-modal__body');
            $A.util.removeClass(component.find("ETST_Date_of_Birth__c"), 'slds-input__icon--right');
            component.set("v.EID", 'الهوية الإماراتية');
            component.set("v.Phone", 'هاتف');
            $A.util.addClass(component.find("ETST_Secondary_Mobile_Number__c"), 'mobilesecondno_AR');
            $A.util.removeClass(component.find("ETST_Secondary_Mobile_Number__c"), 'mobilesecondno');
        }else{
            component.set('v.studentTypeAR',null);
            $A.util.addClass(component.find("mainDiv"), 'slds-modal__body');
             $A.util.addClass(component.find("labelDiv"), 'custom_label');
            $A.util.addClass(component.find("eidDiv"), 'teltextno');
            $A.util.addClass(component.find("ETST_Date_of_Birth__c"), 'slds-input-has-icon--right');
            $A.util.removeClass(component.find("mainDiv"), 'slds-modal__bodyrtl');
            $A.util.removeClass(component.find("ETST_Date_of_Birth__c"), 'slds-input-has-icon--left');
            component.set("v.EID", 'EID');
            component.set("v.Phone", 'Phone');
            $A.util.removeClass(component.find("ETST_Secondary_Mobile_Number__c"), 'mobilesecondno_AR');
            $A.util.addClass(component.find("ETST_Secondary_Mobile_Number__c"), 'mobilesecondno');
        } 
    },
    validateDOB: function(component, event, helper) {
        var today = $A.localizationService.formatDate(new Date(), "YYYY-MM-DD");
        if(component.get('v.studentRecord.ETST_Date_of_Birth__c')>=today){
            $A.util.removeClass(component.find("invaliddob"), "slds-hide");
            
        }else{
            $A.util.addClass(component.find("invaliddob"), "slds-hide");
        }
    },
    openSchoolSearchPopup: function(component, event, helper) {
        component.set("v.isSchoolPopup",true);
    },
    closeSchoolPopup: function(component, event, helper) {
        component.set("v.isSchoolPopup",false);
    },
    handleUploadFinished: function(component, event, helper) {
        var utility = component.find("ETST_UtilityMethods");
        utility.showToast("Student Details", 'Please upload valid image', "error", "dismissible");
    },
    handleEvent: function(component, event, helper) {
        var selectedRecords=event.getParam("selectedRecords");
        if(selectedRecords>0){
            component.set("v.disableAddSerice",false);
        }else{
            component.set("v.disableAddSerice",true);
        }
    },
    openStudentModal : function(component, event, helper) {       
        component.set('v.addStudentModal',true);
    },
    onchangeSchool : function(component, event, helper) { 
      /*  console.log('fired');
        var lookupField = component.find("lookupField").get("v.value");
        console.log("lookupField***"+lookupField);
        if(lookupField == null || lookupField == '' || lookupField == 'undefined'){
            $A.util.removeClass(component.find("schoolname"), "slds-hide"); 
           	mandatoryFieldsCmps.push(component.find("lookupField"));
        }else{
            $A.util.addClass(component.find("schoolname"), "slds-hide");
        } */
    },
    onchangeCheckbox : function(component, event, helper) { 
       // alert('clicked');
        console.log('fired');
        var termsandconditions = component.find("termsandconditions");
        var checkbox = termsandconditions.doCheck();
        console.log("checkbox***"+checkbox);
        if(!checkbox){
            $A.util.removeClass(component.find("TC"), "slds-hide"); 
           	mandatoryFieldsCmps.push(component.find("termsandconditions"));
        }else{
            $A.util.addClass(component.find("TC"), "slds-hide");
        }
    },
    createNewStudent : function(component, event, helper) {
         
        var showValidationError = false;
        var vaildationFailReason = '';
        var mandatoryFieldsList = component.get("v.othermandatoryFields");
        var mandatoryFieldsCmps = [];
        for(var id in mandatoryFieldsList){
            mandatoryFieldsCmps.push(component.find(mandatoryFieldsList[id]));
        }
        var termsandconditions = component.find("termsandconditions");
        var checkbox = termsandconditions.doCheck();
        console.log("checkbox***"+checkbox);
        if(!checkbox){
            $A.util.removeClass(component.find("TC"), "slds-hide"); 
           	mandatoryFieldsCmps.push(component.find("termsandconditions"));
        }else{
            $A.util.addClass(component.find("TC"), "slds-hide");
        }
        if(mandatoryFieldsList.length!=undefined && mandatoryFieldsList.length > 0){
            var allValid =mandatoryFieldsCmps.reduce(function (validSoFar, inputCmp) {
                inputCmp.showHelpMessageIfInvalid();
                return validSoFar && !inputCmp.get('v.validity').valueMissing;
            }, true);
            if (allValid) {
                var today = $A.localizationService.formatDate(new Date(), "YYYY-MM-DD");
                if(component.get('v.studentRecord.ETST_Date_of_Birth__c')<today){
                    $A.util.addClass(component.find("previousDiv"), "slds-hide");
                    //if(component.get('v.studentTypeSelected')!='Government School'){
                        helper.createNewStudent(component, event, helper);
                    //}
                    
                }
  
            }
        }else{
            $A.util.addClass(component.find("previousDiv"), "slds-hide");
            //if(component.get('v.studentTypeSelected')!='Government School'){
            	helper.createNewStudent(component, event, helper);
            //}
        }
    },
    closeModel: function(component, event, helper) {
        component.set('v.addStudentModal',false);
        component.set('v.isfeebackModal',false);
        $A.get('e.force:refreshView').fire();
    },
    closeModelwithRefresh: function(component, event, helper) {
        
        /* Added if else condition to make image upload mandatory for gov school --- Sreelakshmi SK 24/5/23 */
        if(component.get('v.studentTypeSelected')=='Government School' && component.get('v.fileuploaded')==false){
            console.log('entered exception condition');
            var utility = component.find("ETST_UtilityMethods");
            utility.showToast("Student Photo", 'Please upload the photo of student', "error", "dismissible");
        }
        
        else{
        component.set('v.addStudentModal',false);
        var utility = component.find("ETST_UtilityMethods");
        utility.showToast("Student Details", 'Student details saved successfully!', "success", "dismissible");
        
        var actionEvt = $A.get("e.c:ETST_sendDataEvent");
        actionEvt.setParams({
            "actionname": 'refresh'
        });
        
        actionEvt.fire();
        }
    },
    handleUploadFinished: function (component, event, helper) {
        // Get the list of uploaded files
        var uploadedFiles = event.getParam("files");
        console.log('uploadedFiles'+JSON.stringify(uploadedFiles));
        var documentId = uploadedFiles[0].documentId;
        console.log('documentId'+documentId);
        component.set('v.documentId',documentId);
        helper.getImageContent(component, event, helper);
        
        /* Set the fileuploaded variable as true if file is uploaded --- Sreelakshmi SK 24/5/23 */
        component.set("v.fileuploaded",true);
        console.log(component.get('v.fileuploaded'));
        
        $A.get('e.force:refreshView').fire();
        
    },
    
    gotoNextDiv: function(component, event, helper){
        component.set("v.disableSave",false);
        var phone =component.get('v.studentRecord.ETST_Phone__c');
        component.set('v.studentRecord.Name',component.get('v.studentRecord.Name').trim());
        component.set('v.studentRecord.ETST_Student_Id__c',component.get('v.studentRecord.ETST_Student_Id__c').trim());
        component.set('v.studentRecord.ETST_ESIS_No__c',component.get('v.studentRecord.ETST_ESIS_No__c').trim());
        component.set('v.studentRecord.ETST_Emirates_Id__c',component.get('v.studentRecord.ETST_Emirates_Id__c').trim());
        component.set('v.studentRecord.ETST_Phone__c',phone.trim());
        var schoolname=component.get("v.selectedRecord.Name");
        var mandatoryFieldsList = component.get("v.perosanalmandatoryFields");
        var mandatoryFieldsCmps = [];
        for(var id in mandatoryFieldsList){
            mandatoryFieldsCmps.push(component.find(mandatoryFieldsList[id]));
        }
        var allValid =mandatoryFieldsCmps.reduce(function (validSoFar, inputCmp) {
            inputCmp.showHelpMessageIfInvalid();
            return validSoFar && inputCmp.get('v.validity').valid;
        }, true);
        
        if(allValid){
            if(schoolname!=null&& schoolname!=''&&schoolname!=undefined){
                $A.util.addClass(component.find("schoolname"), "slds-hide"); 
                $A.util.addClass(component.find("school"), "slds-hide");
                $A.util.removeClass(component.find("personal"), "slds-hide");
                $A.util.addClass(component.find("nextDiv"), "slds-hide");
                $A.util.removeClass(component.find("previousDiv"), "slds-hide");
                $A.util.removeClass(component.find("newStudentButton"), "slds-hide");
                $A.util.removeClass(component.find("schooltab"), "activetab");  
                 $A.util.removeClass(component.find("schooltab1"), "activetab");  
                $A.util.addClass(component.find("personaltab"), "activetab"); 
                $A.util.addClass(component.find("personaltab1"), "activetab"); 
            }else{
                $A.util.removeClass(component.find("schoolname"), "slds-hide");  
            }
        }
    },
    gotoPreviousDiv: function(component, event, helper){
        
        $A.util.removeClass(component.find("school"), "slds-hide");
        $A.util.addClass(component.find("personal"), "slds-hide");
        $A.util.removeClass(component.find("nextDiv"), "slds-hide");
        $A.util.addClass(component.find("previousDiv"), "slds-hide");
        $A.util.addClass(component.find("newStudentButton"), "slds-hide");
        $A.util.removeClass(component.find("personaltab"), "activetab");  
        $A.util.removeClass(component.find("personaltab1"), "activetab");  
        $A.util.addClass(component.find("schooltab"), "activetab");
        $A.util.addClass(component.find("schooltab1"), "activetab");
        
    },
    eidMasking : function(component, event, helper){
        window.addEventListener("keyup", function(event) {
            
            if(event.code != "Delete" && event.code != 'Backspace'){
                var e1=component.get('v.eid1');
                var e2=component.get('v.eid2');
                var e3=component.get('v.eid3');
                //alert('1 '+e1.length);
                var eid='784-'+e1+'-'+e2+'-'+e3;
                //alert("key: " + event.key + ", code: " + event.code);
                /*var eid =  component.get('v.studentRecord.ETST_Emirates_Id__c');
            var eidLength=eid.length;
            var chars = eid.split('');
	       
            if(eidLength==3){
                eid=  eid+'-';
            }else if(eidLength==4 && eid.charAt(3)!='-' ){
                chars[4] = chars[3];
                chars[3] = '-';
                eid=  chars.join('');
            }else if(eidLength==8){
                eid=  eid+'-';
            }else if(eidLength==9 && eid.charAt(8)!='-' ){
                chars[9] = chars[8];
                chars[8] = '-';
                eid=  chars.join('');
            }else if(eidLength==16){
                eid=  eid+'-';
            }else if(eidLength==17 && eid.charAt(16)!='-' ){
                chars[17] = chars[16];
                chars[16] = '-';
                eid=  chars.join('');
            }*/
               component.set('v.studentRecord.ETST_Emirates_Id__c', eid);
               //  alert('eid  '+eid);
           }
        }, true);
        
        
        
        // console.log('eid***'+eid.match(/.{1,3}/g).join('-'));
        /* eid = eid.split('-').join('');    // Remove dash (-) if mistakenly entered.
        var finalVal = eid.match(new RegExp('.{1,3}','g')).join("-");
        console.log('finalVal***'+eid.match(/\d{3}(?=\d{4}\d{2})|\d+/g).join("-"));
        component.set('v.studentRecord.ETST_Emirates_Id__c', finalVal);
        //eid.replace(/^(\d\d)(\d)$/g,'$1/$2').replace(/^(\d\d\/\d\d)(\d+)$/g,'$1/$2').replace(/[^\d\/]/g,'');
        //*/
    },
    changeFocus1: function(component, event, helper) {
        var e1=component.get('v.eid1');
        if(e1.length==4)
            component.find("eid2").focus();
        
    },
    changeFocus2: function(component, event, helper) {
        
        var e2=component.get('v.eid2');
        if(e2.length==7)
            component.find("eid3").focus();
        
    },
})
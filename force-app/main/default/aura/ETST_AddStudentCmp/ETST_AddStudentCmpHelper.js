({
    doInit: function(component, event, helper) {
        var meta = document.createElement("meta");
        meta.setAttribute("name", "viewport");
        meta.setAttribute("content", "width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=0");
        document.getElementsByTagName('head')[0].appendChild(meta);
        
        var utility = component.find("ETST_UtilityMethods");
        var backendMethod = "getSchoolList";
        var lang = component.get("v.clLang");
        var studentType = lang == 'ar'? component.get("v.studentTypeAR"): component.get("v.studentType");
        component.set("v.studentTypeSelected",studentType);
        console.log('studentTypeSelected:'+component.get("v.studentTypeSelected"));
        console.log('studentType***'+studentType);
        var params = {
            "studentType" : studentType
        };
       
        var promise = utility.executeServerCall(component, backendMethod, params);
        promise.then (
            $A.getCallback(function(response) {
                console.log('schoolsList-->'+response.schoolsList);
                component.set("v.schoolList",response.schoolsList);
                component.set("v.divisionList",response.divisionList);
                component.set("v.bloodGroupList",response.bloodGroupList);
                component.set("v.gradeList",response.gradeList); 
                component.set("v.nationalityList", response.nationalityList);
                component.set("v.nationalityListAR", response.nationalityListAR);
                component.set("v.genderList", response.genderList);
                component.set("v.genderListAR", response.genderListAR);
                component.set("v.profileData", response.parentProfle);
                component.set("v.studentRecord.ETST_Email__c", response.parentProfle.PersonEmail);
                var phone=response.parentProfle.PersonMobilePhone.replace('+971', '');
                   component.set("v.studentRecord.ETST_Phone__c", phone);
                component.set("v.studentRecord.ETST_Nationality__c", response.parentProfle.ET_Nationality__c);
                
                
            }),
            
            $A.getCallback(function(error) {
                var err = JSON.parse(error);
                var errorToShow = utility.convertToUserFriendlyErrMsg(err.MESSAGE);
                console.log(errorToShow);  
				utility.showToast("School Tranport", $A.get("$Label.c.ETST_Customer_Error_Msg"), "error", "dismissible");
            })
        )    
    },
    
    createNewStudent : function(component, event, helper) {
        component.set('v.loaded', false);
        //component.set("v.disableSave",true);
        var utility = component.find("ETST_UtilityMethods");
        var backendMethod = "createNewStudent";
        var studentRecord = component.get("v.studentRecord");
        studentRecord.is_New_Student__c = true;
        var params = {
            "schoolId" : component.get("v.selectedRecord.Id"),
            "studentRecord" : studentRecord
        };
        var promise = utility.executeServerCall(component, backendMethod, params);
        promise.then (
            $A.getCallback(function(response) {
                
                $A.util.addClass(component.find("personal"), "slds-hide");
                $A.util.addClass(component.find("nextDiv"), "slds-hide");
                $A.util.addClass(component.find("previousDiv"), "slds-hide");
                $A.util.addClass(component.find("closeModel"), "slds-hide");
                $A.util.removeClass(component.find("closeModelRefresh"), "slds-hide");
                $A.util.removeClass(component.find("uploadImage"), "slds-hide");
                $A.util.addClass(component.find("newStudentButton"), "slds-hide"); 
                $A.util.addClass(component.find("imgtab"), "activetab"); 
                $A.util.addClass(component.find("imgtab1"), "activetab"); 
                $A.util.removeClass(component.find("personaltab"), "activetab");
                $A.util.removeClass(component.find("personaltab1"), "activetab");
                $A.util.removeClass(component.find("schooltab"), "activetab");
                $A.util.removeClass(component.find("schooltab1"), "activetab");
                component.set('v.studentId',response);
                component.set('v.loaded', true);
            }),
            
            $A.getCallback(function(error) {
                var err = JSON.parse(error);
                var errorToShow = utility.convertToUserFriendlyErrMsg(err.MESSAGE);
                console.log('error:');
                console.table(error);
                console.log(errorToShow);
				utility.showToast("School Tranport", errorToShow, "error", "dismissible");
                component.set('v.loaded', true);
                $A.util.removeClass(component.find("previousDiv"), "slds-hide");
                //$A.util.removeClass(component.find("newStudentButton"), "slds-hide");                
            })
        )	
    },
    getImageContent : function(component, event, helper) {
        var utility = component.find("ETST_UtilityMethods");
        var backendMethod = "getImageContent";
        var params = {
            "docId" : component.get("v.documentId"),
            "studentId" : component.get("v.studentId")
        };
        var promise = utility.executeServerCall(component, backendMethod, params);
        promise.then (
            $A.getCallback(function(response) {
              component.set('v.imageURL',component.get('v.prefixURL')+response);  
              $A.util.removeClass(component.find("showImage"), "slds-hide");
              $A.util.removeClass(component.find("closeModelRefresh"), "slds-hide");
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
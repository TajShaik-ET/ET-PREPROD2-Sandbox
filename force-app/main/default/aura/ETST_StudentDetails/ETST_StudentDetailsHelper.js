({
    doInit : function(component, event, helper,flag) {
        var meta = document.createElement("meta");
        meta.setAttribute("name", "viewport");
        meta.setAttribute("content", "width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=0");
        document.getElementsByTagName('head')[0].appendChild(meta);
      
        component.set('v.loaded',false);
        var utility = component.find("ETST_UtilityMethods");
        var backendMethod = "getStudentDetails";

        var params = {
            "activeFlag" : flag
        };
        var promise = utility.executeServerCall(component, backendMethod, params);
        
        promise.then (
            $A.getCallback(function(response) {
                component.set('v.transportTypes',response.transportTypes);
                component.set('v.serviceTypes',response.serviceTypes);
                component.set('v.studentList',response.studentList); 
                var corousalSize=component.get('v.corousalSize'); 
                component.set('v.studentCourosalList',response.studentList.slice(0,corousalSize)); 
                component.set('v.noofStudents',response.studentList.length);
                component.set('v.cancellationTypes',response.cancellationTypes);  
                component.set('v.cancellationReasons',response.cancellationReasons); 
                component.set('v.bankNames',response.bankNames); 
                component.set('v.parentCancellationReasons',response.parentCancellationReasons); 
                 component.set('v.loaded',true);
                if(flag){  
                    $A.util.addClass(component.find('current'), 'btnsorticon_active');        
        			$A.util.removeClass(component.find('renew'), 'btnsorticon_active');
                }else{
                    $A.util.removeClass(component.find('current'), 'btnsorticon_active');        
                    $A.util.addClass(component.find('renew'), 'btnsorticon_active');
                }
            }),
            
            $A.getCallback(function(error) {
                var err = JSON.parse(error);
                var errorToShow = utility.convertToUserFriendlyErrMsg(err.MESSAGE);
                console.log(errorToShow);
                utility.showToast("School Tranport", $A.get("$Label.c.ETST_Customer_Error_Msg"), "error", "dismissible");
            })
        )	
    },
    
    //Added by Sreelakshmi SK 5/6/23
    
    profileData: function(component, event, helper){
       
        var action = component.get('c.getProfileDetails');
      
        action.setCallback(this, function(response) {
            var state = response.getState();
                       
            if (state === "SUCCESS") {  
                let data = response.getReturnValue();
                console.log(data);
                console.log(data.Government_School_Parent__c);
                //component.get()
                component.set("v.govParent",data.Government_School_Parent__c);
                console.log(component.get("v.govParent"));
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
    
    
    emailInvoiceHelper: function(component, event, helper,srId) {
        //component.set('v.loaded',false);
        var utility = component.find("ETST_UtilityMethods");
        var backendMethod = "emailUserInvoice";

        var params = {
            "srId" : srId
        };
        var promise = utility.executeServerCall(component, backendMethod, params);
        
        promise.then (
            $A.getCallback(function(response) {
               utility.showToast("School Tranport", 'Invoice is sent to your email address!', "success", "dismissible");
               //alert('Invoice is sent to your email address!') 
            }),
            
            $A.getCallback(function(error) {
                var err = JSON.parse(error);
                var errorToShow = utility.convertToUserFriendlyErrMsg(err.MESSAGE);
                console.log(errorToShow);
				utility.showToast("School Tranport", $A.get("$Label.c.ETST_Customer_Error_Msg"), "error", "dismissible");
            })
        )	
    },
    getBankDetailsHelper: function(component, event, helper){
        
        
        var utility = component.find("ETST_UtilityMethods");
        var backendMethod = "getParentBankDetails";
        var params = {
            "studentId" : component.get('v.serviceRecord.ETST_Student__c'),
            
        };
        var promise = utility.executeServerCall(component, backendMethod, params);
        
        promise.then (
            $A.getCallback(function(response) {
                 
                component.set('v.Beneficiary',response.ET_Beneficiary__c);
                component.set('v.BankName',v.BankName);//response.ET_Bank_Name__c);
                component.set('v.AccountNo',response.ET_Account_No__c);
                component.set('v.IBAN',response.ET_IBAN_Code__c);
                component.set('v.Branch',response.ET_Branch_Name__c);
                component.set('v.BankAddress',response.ET_Bank_Address__c);
            }),
            
            $A.getCallback(function(error) {
                var err = JSON.parse(error);
                var errorToShow = utility.convertToUserFriendlyErrMsg(err.MESSAGE);
                console.log(errorToShow);
				utility.showToast("School Tranport", $A.get("$Label.c.ETST_Customer_Error_Msg"), "error", "dismissible");
            })
        )	
    },
    deactivateStudentHelper: function(component, event, helper){
        //alert('deactivateStudent: ' );
        var utility = component.find("ETST_UtilityMethods");
        var backendMethod = "deactivateStudent";
        var params = {
            "studentId" : component.get('v.serviceRecord.ETST_Student__c'),
            "serviceRecord": component.get('v.serviceRecord'),
            "balanceAmount":  component.get('v.refundAmount'),
            "Beneficiary":  component.get('v.Beneficiary'),
            "BankName":  component.get('v.BankName'),
            "AccountNo":  component.get('v.AccountNo'),
            "IBAN":  component.get('v.IBAN'),
            "Branch":  component.get('v.Branch'),
            "BankAddress":  component.get('v.BankAddress'),
            "documentId": component.get('v.documentId')
        };
        var promise = utility.executeServerCall(component, backendMethod, params);
        
        promise.then (
            $A.getCallback(function(response) {
                utility.showToast("Student", 'Student Service is cancelled', "success", "dismissible");
                $A.get('e.force:refreshView').fire();
                //window.location='/customer/s/etst-home-page';
                component.set('v.serviceRecord',component.get('v.newService'));
                component.set('v.deactivateServiceModal',false);
            }),
            
            $A.getCallback(function(error) {
                var err = JSON.parse(error);
                var errorToShow = utility.convertToUserFriendlyErrMsg(err.MESSAGE);
                console.log(errorToShow);
				utility.showToast("School Tranport", $A.get("$Label.c.ETST_Customer_Error_Msg"), "error", "dismissible");
            })
        )	
    },
    cancelServiceHelper: function(component, event, helper){
        var utility = component.find("ETST_UtilityMethods");
        var backendMethod = "cancelStudentService";
        var params = {
            "serviceRecord": component.get('v.serviceRecord')
        };
        var promise = utility.executeServerCall(component, backendMethod, params);
        
        promise.then (
            $A.getCallback(function(response) {
                utility.showToast("Student", 'Student Service is cancelled', "success", "dismissible");
                $A.get('e.force:refreshView').fire();
                component.set('v.serviceRecord',component.get('v.newService'));
                //window.location='/customer/s/etst-home-page';
                component.set('v.cancelServiceModal',false);
            }),
            
            $A.getCallback(function(error) {
                var err = JSON.parse(error);
                var errorToShow = utility.convertToUserFriendlyErrMsg(err.MESSAGE);
                console.log(errorToShow);
				utility.showToast("School Tranport", $A.get("$Label.c.ETST_Customer_Error_Msg"), "error", "dismissible");
            })
        )	
    },
    getStudentSchoolAreas : function(component, event, helper){
        console.log('--schoolId--'+component.get('v.schoolId'));
        var utility = component.find("ETST_UtilityMethods");
        var backendMethod = "getStudentSchoolAreas";
        var params = {
            "schoolId" : component.get('v.schoolId')
        };
        var promise = utility.executeServerCall(component, backendMethod, params);
        
        promise.then (
            $A.getCallback(function(response) {
                component.set('v.schoolAreas',response);
            }),
            
            $A.getCallback(function(error) {
                var err = JSON.parse(error);
                var errorToShow = utility.convertToUserFriendlyErrMsg(err.MESSAGE);
                console.log(errorToShow);
				utility.showToast("School Tranport", $A.get("$Label.c.ETST_Customer_Error_Msg"), "error", "dismissible");
            })
        )	
    },
    
    getRefundAmountHelper: function(component, event, helper) {
         
        var utility = component.find("ETST_UtilityMethods");
        var backendMethod = "getRefundAmount";
        var params = {
            "serviceRecord": component.get('v.serviceRecord'),
            "isCurrent": component.get('v.isCurrent')
        };
        var promise = utility.executeServerCall(component, backendMethod, params);
        
        promise.then (
            $A.getCallback(function(response) {
                //alert('response '+response);
                component.set('v.serviceRecord.ET_Refund_Amount__c', response);
                component.set('v.refundAmount',response);
                if(response>0){
                    component.set('v.hasService',true);
                }
                
            
            }),
            
            $A.getCallback(function(error) {
                var err = JSON.parse(error);
                var errorToShow = utility.convertToUserFriendlyErrMsg(err.MESSAGE);
                console.log(errorToShow);
				utility.showToast("School Tranport", $A.get("$Label.c.ETST_Customer_Error_Msg"), "error", "dismissible");
            })
        )	
    },
    activateOnholdService: function(component, event, helper){
        var utility = component.find("ETST_UtilityMethods");
        var backendMethod = "activateOnholdService";
        var params = {
            "serviceRecord": component.get('v.serviceRecord')
        };
        var record = component.get('v.serviceRecord');       
        console.log('record***'+JSON.stringify(record));
        var promise = utility.executeServerCall(component, backendMethod, params);   
        promise.then (
            $A.getCallback(function(response) {
                utility.showToast("Student", 'Student Service is activated', "success", "dismissible");
                $A.get('e.force:refreshView').fire();
				component.set('v.onholdServiceModal',false);
            }),
            
            $A.getCallback(function(error) {
                var err = JSON.parse(error);
                var errorToShow = utility.convertToUserFriendlyErrMsg(err.MESSAGE);
                console.log(errorToShow);
				utility.showToast("School Tranport", $A.get("$Label.c.ETST_Customer_Error_Msg"), "error", "dismissible");
            })
        )	
    },
    validateForm : function(component) {
        console.log('validate form');
        if(component.get("v.serviceRecord.ETST_Reason_for_Cancellation__c") == '' || component.get("v.caseRecord.Case_Types__c") == '--None--'){
            $A.util.removeClass(component.find("errorId"), "slds-hide");
            return false;
        }
        if(component.get("v.caseRecord.ET_Issue_Category__c") == '' || component.get("v.caseRecord.ET_Issue_Category__c") == '--None--'){
            $A.util.removeClass(component.find("issueCategoryId"), "slds-hide");
            return false;
        }
        if(component.get("v.caseRecord.ET_Issue_Type_New__c") == '' || component.get("v.caseRecord.ET_Issue_Type_New__c") == '--None--'){
            $A.util.removeClass(component.find("issueTypeId"), "slds-hide");
            return false;
        }
        return true;
    },
    changeSchoolHelper: function(component, event, helper){
        var utility = component.find("ETST_UtilityMethods");
        var backendMethod = "changeStudentSchool";
        var params = {
            "studentId": component.get('v.selectedStudentId'),
            "schoolId" : component.get("v.selectedRecord.Id"),            
            "Beneficiary":  component.get('v.Beneficiary'),
            "BankName":  component.get('v.BankName'),
            "AccountNo":  component.get('v.AccountNo'),
            "IBAN":  component.get('v.IBAN'),
            "Branch":  component.get('v.Branch'),
            "BankAddress":  component.get('v.BankAddress'),
            "serviceRecord": component.get('v.serviceRecord'),
            "balanceAmount":  component.get('v.refundAmount'),
            "isCurrent": component.get('v.isCurrent'),
            "documentId": component.get('v.documentId')
        };
       var promise = utility.executeServerCall(component, backendMethod, params);   
        promise.then (
            $A.getCallback(function(response) {
                utility.showToast("Student", 'School changed successfully!', "success", "dismissible");
                $A.get('e.force:refreshView').fire();
                component.set('v.serviceRecord',component.get('v.newService'));
				component.set('v.changeSchoolModal',false);
            }),
            
            $A.getCallback(function(error) {
                var err = JSON.parse(error);
                var errorToShow = utility.convertToUserFriendlyErrMsg(err.MESSAGE);
                console.log(errorToShow);
				utility.showToast("School Tranport", $A.get("$Label.c.ETST_Customer_Error_Msg"), "error", "dismissible");
            })
        )	
    },
    deleteFileHelper: function(component, event, helper) {
         
        var utility = component.find("ETST_UtilityMethods");
        var backendMethod = "deleteDocuments";
        var params = {
            "docIds": component.get('v.documentId')
        };
        var promise = utility.executeServerCall(component, backendMethod, params);
        
        promise.then (
            $A.getCallback(function(response) {
                if(response=='SUCCESS'){
                    component.set('v.documentId',null);
                    component.set('v.fileNames',null);
                    
                }
                
            
            }),
            
            $A.getCallback(function(error) {
                var err = JSON.parse(error);
                var errorToShow = utility.convertToUserFriendlyErrMsg(err.MESSAGE);
                console.log(errorToShow);
				utility.showToast("School Tranport", $A.get("$Label.c.ETST_Customer_Error_Msg"), "error", "dismissible");
            })
        )	
    },
     showToastMessage : function(title,type,message) {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "type":title,
            "title":type,
            "message":message,
            "mode":"dismissible"
        });
        toastEvent.fire();
    },
})
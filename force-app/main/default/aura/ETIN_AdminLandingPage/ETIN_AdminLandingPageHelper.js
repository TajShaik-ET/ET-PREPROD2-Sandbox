({
    getCurrenetPageData:function(component, event, helper,start,pageSize) {
        
        component.set("v.paginationList", component.get('v.Insurancedata').slice(start,start+pageSize));
        
    },
    
    getSearchResult :function(component, event, helper) {
        
        var pageSize = component.get("v.pageSize");
        var RenewalBtn = component.get("v.EnableRenewalOptions");
        var hideBtn = '';
        if(component.get("v.hideClaimBtn")){
            hideBtn = false;
        }else {
            hideBtn = true;
        }
        
        //console.log('-----'+RenewalBtn);
        
        if(RenewalBtn){
            
            var actions = [
                {
                    'label': 'View',
                    'iconName': 'utility:preview',
                    'name': 'show_details',
                    
                },
                {
                    'label': 'Claim',
                    'iconName': 'standard:partner_fund_claim',
                    'name': 'Claim',
                    disabled: hideBtn
                    
                },
                {
                    'label': 'Correction',
                    'iconName': 'utility:edit',
                    'name': 'correction'
                },
                {
                    'label': 'Cancellation',
                    'iconName': 'utility:close',
                    'name': 'cancellation'
                },
                {
                    'label': 'Renewal',
                    'iconName': 'action:add_contact',
                    'name': 'Renewal'
                    
                }
                
            ];
            
        }else {
            var actions = [
                {
                    'label': 'View',
                    'iconName': 'utility:preview',
                    'name': 'show_details',
                    
                },
                {
                    'label': 'Claim',
                    'iconName': 'standard:partner_fund_claim',
                    'name': 'Claim',
                    disabled: hideBtn
                    
                },
                {
                    'label': 'Correction',
                    'iconName': 'utility:edit',
                    'name': 'correction'
                },
                {
                    'label': 'Cancellation',
                    'iconName': 'utility:close',
                    'name': 'cancellation'
                }
            ];
        }
        
        
        
        component.set('v.InsuranceColumns', [
            
            {label: 'Ref Number', fieldName: 'link2', type: 'url',typeAttributes: { label:  { fieldName: 'Name' }, target:'_blank'}},
            // {label: 'Emirates ID', fieldName: 'emiratesID', type: 'text'},
            {label: 'Card Number', fieldName: 'linkName', type: 'url',typeAttributes: { label:  { fieldName: 'Card_Number__c' }, target:'_blank'}},
            {label: 'Employee', fieldName: 'Emplink',type: 'url',typeAttributes: { label:  { fieldName: 'FulName' }, target:'_blank'}},
            {label: 'Emp ID', fieldName: 'Employee_ID__c',type: 'text' },
            {label: 'Name', fieldName: 'Member_Name__c',type: 'text' },
            {label: 'Plan', fieldName: 'Plan__c', type: 'text'},
            {label: 'Relation', fieldName: 'Relation', type: 'text'},
            {label: 'Effective Date', fieldName: 'Effective_Date__c', type: 'date'},
            {label: 'Expire Date', fieldName: 'Expiry_Date__c', type: 'date'},
            
            
            {label: 'Status', cellAttributes:{ iconName: { fieldName: 'StatusIcon' }, iconPosition: 'right' }},
            {label: 'Actions', type: 'action', typeAttributes: { rowActions: actions } }
            
        ]);
        var exeAction = component.get("c.getInsuranceDetails");
        exeAction.setParams({
            "policyNumber":component.get("v.cardNumber"),
            "EmpID": component.get("v.employeeID"),
            "firstName": component.get("v.firstName"),
            "lastName": component.get("v.lastName"),
            "emiratesID": component.get("v.emiratesId"),
            "plan":component.get("v.plan"),
            "Location":component.get("v.EmpLocation")
        });
        this.serverSideCall(component,exeAction).then(
            function(res) {
                //console.log(res);
                var records =res;
                records.forEach(function(record){
                    record.link2 = '/'+record.Id;
                    //record.emiratesID = record.EmployeeAcc__r.ET_Emirates_Id__c;
                    if(record.EmployeeAcc__c)
                        record.FulName = record.EmployeeAcc__r.Name;
                    if(record.EmployeeAcc__c)
                        record.dob = record.EmployeeAcc__r.PersonContact.Birthdate;
                    record.Relation = record.Relation__c;
                    if(record.Card_Number__c != null){
                        record.linkName = '/'+record.Id; }else
                        { record.linkName ='';}
                    //record.fullName = record.First_Name__c+' '+record.Last_Name__c;
                    if(record.EmployeeAcc__c){
                        record.Emplink = '/'+record.EmployeeAcc__c;
                    }else{
                        record.Emplink='';
                    }
                    
                    record.provenanceIconName = 'action:preview';
                    record.provenanceIconName2 = 'action:edit'; 
                    if(record.Insurance_Current_Status__c == 'Active'){
                        record.StatusIcon ="action:approval";}else{
                            record.StatusIcon ="action:close";  
                        }
                    
                });
                
                component.set('v.Insurancedata',res);
                component.set("v.totalSize", component.get("v.Insurancedata").length);
                
                //console.log(res);
                component.set("v.paginationList", res.slice(0,pageSize));
            }
        ).catch(
            function(error) {
                
                console.log('Error---'+JSON.stringify(error));
            }
        );
    }, 
    
    
    serverSideCall : function(component,action) {
        
        return new Promise(function(resolve, reject) { 
            action.setCallback(this, 
                               function(response) {
                                   
                                   var state = response.getState();
                                   // console.log(state);
                                   if (state === "SUCCESS") {
                                       resolve(response.getReturnValue());
                                   } else {
                                       reject(new Error(response.getError()));
                                   }
                               }); 
            $A.enqueueAction(action);
        });
    },
    
    
    getAttachmentList : function(component, event, helper) {  
        
        
        var exeAction = component.get("c.getAttachments");
        
        exeAction.setParams({ 
            "parentRecID": component.get("v.NewInsuRecId")       
        });
        this.serverSideCall(component,exeAction).then(
            function(res) {
                
                component.set('v.attachments', res);
            }
        ).catch(
            function(error) {
                
                console.log('Error---'+JSON.stringify(error));
            }
        );
        
    },
    
    getAttachmentListFamily : function(component, event, helper) {  
        
        
        var exeAction = component.get("c.getAttachments");
        
        exeAction.setParams({ 
            "parentRecID": component.get("v.NewInsuFamilyRecId")       
        });
        this.serverSideCall(component,exeAction).then(
            function(res) {
                
                component.set('v.attachments', res);
            }
        ).catch(
            function(error) {
                
                console.log('Error---'+JSON.stringify(error));
            }
        );
    },
    getCaseAttachmentList : function(component, event, helper) {  
        
        var exeAction = component.get("c.getAttachments");
        exeAction.setParams({ 
            "parentRecID": component.get("v.caseInsurId")       
        });
        this.serverSideCall(component,exeAction).then(
            function(res) {
                
                component.set('v.Caseattachments', res);
            }
        ).catch(
            function(error) {
                
                console.log('Error---'+JSON.stringify(error));
            }
        );
        
    },
    /* fetchPickListVal: function(component, fieldName, elementId) {
      
        var action = component.get("c.getselectOptions");
       
       action.setParams({
            "objObject":"Contact",
            "fld": fieldName
        }); 
        var opts = [];
        
        action.setCallback(this, function(response) {
            
           
            if (response.getState() == "SUCCESS") {
                var allValues = response.getReturnValue();
             
                if (allValues != undefined && allValues.length > 0) {
                    opts.push({
                        class: "optionClass",
                        label: "All",
                        value: ""
                    });
                }
                for (var i = 0; i < allValues.length; i++) {
                    opts.push({
                        class: "optionClass",
                        label: allValues[i],
                        value: allValues[i]
                    });
                }
                component.find("empDept").set("v.options", opts);
            }
        });
        $A.enqueueAction(action);
    },*/
    
    callBatchClsRenwPrcs : function(component, event, helper) {
        
        var exeAction = component.get("c.callBatchClsHealthRenewPrcs");
        
        exeAction.setParams({
            "PartnerId":component.get("v.selectedValue"),
            "Prcs":component.get("v.RenewValue")
        }); 
        
        
        this.serverSideCall(component,exeAction).then(
            function(res) {
                
                // console.log(res+'-----Batch-----'); 
                var interval = setInterval($A.getCallback(function () {
                    var jobStatus = component.get("c.getBatchJobStatus");
                    if(jobStatus != null){
                        jobStatus.setParams({ jobID : res});
                        jobStatus.setCallback(this, function(jobStatusResponse){
                            var state = jobStatus.getState();
                            if (state === "SUCCESS"){
                                var job = jobStatusResponse.getReturnValue();
                                component.set('v.apexJob',job);
                                var processedPercent = 0;
                                if(job.JobItemsProcessed != 0){
                                    processedPercent = (job.JobItemsProcessed / job.TotalJobItems) * 100;
                                }
                                var progress = component.get('v.progress');
                                component.set('v.progress', progress === 100 ? clearInterval(interval) :  processedPercent);
                                var sta =  component.get('v.apexJob.Status');
                                if(sta == 'Completed'){
                                    component.set("v.cnfrmBtn",false);
                                }
                                
                                
                            }
                        });
                        $A.enqueueAction(jobStatus);
                    }
                }), 2000);
                
            }
        ).catch(
            function(error) {
                
                console.log('Error---'+JSON.stringify(error));
            }
        );
        
        
    },
    
    getPartnerList : function(component, event, helper){
        
        
        var exeAction = component.get("c.getPartnerAccList");
        
        this.serverSideCall(component,exeAction).then(
            function(res) {
                //console.log('rec---'+JSON.stringify(res));
                component.set("v.PartnerList",res);
                
            }
        ).catch(
            function(error) {
                
                console.log('Error---'+JSON.stringify(error));
            }
        );
        
    },
    
    getRenewBtnHelper : function(component, event, helper){
        
        var exeAction = component.get("c.getRenewalButtonSettings");
        
        this.serverSideCall(component,exeAction).then(
            function(res) {
                console.log(res)
                //console.log('Renewal Custom Settings---->'+res[2].Visibility__c +'---'+res[0].Visibility__c);
                /*component.set("v.EnableRenewalOptions",res[1].Visibility__c);
                component.set("v.hideClaimBtn",res[0].Visibility__c);
                component.set("v.hideAddtnBtn",res[2].Visibility__c);
                component.set("v.displayModal",res[3].Visibility__c);*/
                res.forEach(item => {
                    if(item.Name == 'Renewal_Button')
                    component.set("v.EnableRenewalOptions", item.Visibility__c);
                    if(item.Name == 'Claim_Button')
                    component.set("v.hideClaimBtn", item.Visibility__c);
                    if(item.Name == 'New Addition Button')
                    component.set("v.hideAddtnBtn", item.Visibility__c);
                    if(item.Name == 'PopUp_Button')
                    component.set("v.displayModal", item.Visibility__c);
                });
                helper.getSearchResult(component, event, helper);
            }
        ).catch(
            function(error) {
                
                console.log('Error---'+JSON.stringify(error));
            }
        );
        
        
    },
    
    //Added by Arunsarathy 08.12.2022
    getPopupMsgHelper : function(component, event, helper){
        var action = component.get('c.getRenewalButtonSettings');
        action.setCallback(this, function(response) {
            var state = response.getState();
            var res = response.getReturnValue();        
            if (state === "SUCCESS") {                 
              
                res.forEach(function(item){
                    
                    if(item.Name == 'PopUp_Button' && item.Visibility__c){
                        
                        var toastReference = $A.get("e.force:showToast");
                        toastReference.setParams({
                            "type" : "warning",
                            "title" : "For Your Information",
                            "message" :item.Message__c,
                            "mode" : "sticky"
                        });
                        toastReference.fire();
                    }
                });
                
                
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
    
    getMasterPlanDet : function(component, event, helper){
        
        var exeAction = component.get("c.getInsMasterDetails");
        
        this.serverSideCall(component,exeAction).then(
            function(res) {
                
                component.set("v.MasterInsPlan",res);
                
                /* var reportResultData = JSON.parse(res);
               console.log('Master Ins Plans'+reportResultData.length); 
                
                for(var i=0; i < reportResultData.length; i++){
                    
                    console.log(reportResultData[i].Plans__c);                         
                } */
            }
       ).catch(
           function(error) {
               
               console.log('Error---'+JSON.stringify(error));
           }
       );
        
        
    },
    
    getDocumentUploadList : function(component, event, helper,emiratesName){
        
        var exeAction = component.get("c.getDocumentMasterDetails");
        
        exeAction.setParams({
            "Emirate":emiratesName
            
        }); 
        
        
        this.serverSideCall(component,exeAction).then(
            function(res) {
                console.log('--docs---'+JSON.stringify(res)); 
                component.set("v.MasterDocList",res);
                
            }
        ).catch(
            function(error) {
                
                console.log('Error---'+JSON.stringify(error));
            }
        );
        
        
    },
    
    getClaimDocDetails : function(component, event, helper){
        
        var exeAction = component.get("c.getInsClaimDetails");
        
        this.serverSideCall(component,exeAction).then(
            function(res) {
                //console.log('--docs---'+JSON.stringify(res)); 
                component.set("v.ClaimDocList",res);
                
            }
        ).catch(
            function(error) {
                
                console.log('Error---'+JSON.stringify(error));
            }
        );
        
    },
    
    getDefaultInsPartners : function(component, event, helper) {  
        
        var exeAction = component.get("c.getDefaultInsPartners");
        
        helper.serverSideCall(component,exeAction).then(
            function(res) {
                //console.log('----res--InsPart-'+res);
                component.set('v.DefaultInsPartnerList', res);
            }
        ).catch(
            function(error) {
                
                console.log('Error---'+JSON.stringify(error));
            }
        );
    },
    getCorrPicklistVal : function(component, event, helper) { 
        
        
        var exeAction = component.get("c.getselectOptions");
        exeAction.setParams({ 
            "objObject": "Case",
            "fld":"ETIN_Correction_for__c"
        });
        this.serverSideCall(component,exeAction).then(
            function(res) {
                console.log('res-pl-'+res);
                component.set('v.CorrPickList', res);
            }
        ).catch(
            function(error) {
                
                console.log('Error---'+JSON.stringify(error));
            }
        );
        
    },
    FamFilterSearchHelper :  function(component, event, helper) {
        
        var exeAction = component.get("c.getEmployeeFamilyDetails");
        component.set('v.FamilyColumns', [ 
            {label: 'Name', fieldName: 'link2', type: 'url',typeAttributes: { label:  { fieldName: 'fullName' }, target:'_blank'}},
            {label: 'Gender', fieldName: 'Gender__c', type: 'text'},
            {label: 'Relation', fieldName: 'Relation__c', type: 'text'},
            {label: 'Age', fieldName: 'Age__c', type: 'text'},
            {label: 'Employee ID', fieldName: 'Employee_ID__c', type: 'text'}
            
            //{label: 'Date Of Birth', fieldName: 'Date_Of_Birth__c', type: 'Date'}
            
        ]);
        
        exeAction.setParams({
            "EmpID":component.get("v.con_EmpID"),
            "firstName": component.get("v.con_firstName"),
            "lastName": component.get("v.con_Lastname")
            
        });
        helper.serverSideCall(component,exeAction).then(
            function(res) {
                
                var records =res;
                records.forEach(function(record){
                    record.link2 = '/'+record.Id;
                    if(record.First_Name__c){
                        record.fullName = record.First_Name__c+' '+record.Name;
                    }else {
                        record.fullName =record.Name;
                    }
                    
                    
                });
                
                console.log('Family Res'+JSON.stringify(res));
                component.set("v.FampaginationList",res);
            }
        ).catch(
            function(error) {
                
                console.log('Emp Search Error---'+JSON.stringify(error));
            }
        );
    },
    
    UpdateDocument : function(component, event, helper,documentId) {
        
        var selectedRecord = component.get("v.EmpSelectedRows");            
        var exeAction = component.get("c.UpdateFiles");  
        exeAction.setParams({
            "documenList":documentId,
            "EmpId":selectedRecord[0].ETIN_Employee_Id__c
            
        });  
        
        
        helper.serverSideCall(component,exeAction).then(
            function(res) { 
                
                
            });
    },
    getLoggedUserDetails : function(component, event, helper) {
        var exeAction = component.get("c.fetchUser");
        
        this.serverSideCall(component,exeAction).then(
            function(res) {
                
                if(res.Profile.Name == $A.get("$Label.c.INS_AdminProfileName") || res.Profile.Name=='System Administrator'){
                    
                    component.set('v.hideTabs', true); 
                }
                
                if(res.Profile.Name == 'ETIN_HealthInsuranceCord(Platform)'){
                    component.set('v.isCoordinator', true); 
                    component.set('v.hideTabs', false); 
                }
                if(res.UserRole.Name != 'Insurance Admin - Dubai'){
                    component.set('v.IsAbuDubaiAdmin', true);
                }
                /* if(res.Username == 'janardhan@et.com.prepr'){
                    
                    component.set("v.EmpLocation",'Dubai');
                    component.set("v.LocationPopup",false);
                    component.set("v.MainPage",true);
                    
                    helper.getSearchResult(component, event, helper);
                }*/
                
                
            }
         ).catch(
             function(error) {
                 
                 console.log('Error---'+JSON.stringify(error));
             }
         );
         
         
     },
    ErrorMsgHandler : function(msg,type) {
        
        var toastReference = $A.get("e.force:showToast");
        toastReference.setParams({
            "type" : type,
            "title" : type,
            "message" : msg,
            "mode" : "dismissible"
        });
        toastReference.fire();
        
    }
})
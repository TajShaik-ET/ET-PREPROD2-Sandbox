({
    doInit: function (component, event, helper) {         
        helper.getProfileName(component, event, helper);
        
        let currentYear = new Date().getFullYear();
        component.set("v.currentYear",currentYear);
        
        //component.set('v.salesAgreement', true);
        var today = $A.localizationService.formatDate(new Date(), "YYYY-MM-DD");
        var today1 = new Date();
        component.set('v.today', today);
        component.set('v.currentDate', today1.getFullYear());
        
        var action = component.get('c.getUserAccountDetails');
        action.setParams({
        });
        action.setCallback(this, function (a) {
            var state = a.getState(); // get the response state
            if (state == 'SUCCESS') {
                
                var result = a.getReturnValue();
                console.log('result'+JSON.stringify(result));
                component.set('v.businessWrapper', a.getReturnValue());
                console.log( JSON.stringify(component.get('v.businessWrapper.userInfo')));
                //added below code by janardhan - 27/03/23 -start
                let data  =  a.getReturnValue();
                let tabInfo = data.userInfo.Account.Business_Portal_Tabs__c;
                
                if(tabInfo ){
                    if(tabInfo.includes("Fleet Service Request")){
                        component.set("v.showSerReqTab", true);
                    }
                    if(tabInfo.includes("Traffic Fines")){
                        component.set("v.showTrafficFineTab", true);
                    }
                    if(tabInfo.includes("Accident History")){
                        component.set("v.showAccidentHisTab", true);
                    }
                    if(tabInfo.includes("Transportation Agreement")){
                        component.set("v.showTransAgreeTab", true);
                        helper.resetDashBoard(component);
                        component.set('v.salesAgreement', true);
                    }
                    if(tabInfo.includes("Maintenance Agreement")){
                        component.set("v.showMaintAgreeTab", true);
                        helper.resetDashBoard(component);
                        component.set('v.maintenanceAgreement', true);
                    }
                    if(tabInfo.includes("Variation Order")){
                        component.set("v.showVariationOrdTab", true);
                    }
                    if(tabInfo.includes("HSE Info")){
                        component.set("v.showHseInfoTab", true);
                    }
                    if(tabInfo.includes("Invoice")){
                        component.set("v.showInvoiceTab", true);
                    }
                    if(tabInfo.includes("Custom Dashboard")){
                        component.set("v.showDashboardTab", true);
                    } 
                    if(tabInfo.includes("Visits")){
                        component.set("v.showVisitsTab", true);
                    } 
                    if(tabInfo.includes("Standard Dashboard")){
                        component.set("v.showStdDashboard", true);
                    }
                    if(tabInfo.includes("Over Time Automation")){
                        component.set("v.showOverTimeInfoTab", true);
                    } 
                    if(tabInfo.includes("Fuel Consumption")){
                        component.set("v.showFuelConsumptionTab", true);
                    }
                    
                }else{
                    
                    component.set("v.noTabAccess", true); 
                }
                
                //for active sales aggrement
                var cntmap=0;
                for(var cnt in result.poList){
                    cntmap++;
                } 
                var custs=[];
                for ( var key in result.poList ) {
                    custs.push({value:result.poList[key], key:key});
                }
                
                //for active maintenance aggrement
                var cntmap1=0;
                for(var cnt in result.maintenancePoList){
                    cntmap1++;
                } 
                var custs1=[];                
                
                for ( var key in result.maintenancePoList ) {
                    custs1.push({value:result.maintenancePoList[key], key:key});
                }
                
                //other agreements
                var cntmap2=0;
                for(var cnt in result.otherPoList){
                    cntmap2++;
                } var custs2=[];
                for ( var key in result.otherPoList ) {
                    custs2.push({value:result.otherPoList[key], key:key});
                }
                
                var parentid=result.isParent;
                var acclist=[];
                
                if(parentid)
                {
                    let accId =  component.get("v.accountIdList");
                    for ( var key in result.AccountList ){
                        acclist.push({value:result.AccountList[key], key:key});
                        
                    }
                }
                
                component.set("v.isParent",result.isParent);
                component.set("v.poList", custs);
                //Jana- component.set("v.currentpoList", custs);
                component.set("v.activeSalesAgreements", cntmap);
                component.set("v.otherpoList", custs2);
                //Jana-component.set("v.currentCalloutList", custs2);
                
                //Jana- component.set("v.activeotherAgreements", cntmap2);
                console.log('acclist'+acclist);
                component.set("v.Accountdropdownlist", acclist);
                component.set('v.cumpercent', result.cumpercent);
                component.set('v.maintenencePOList', custs1);
                component.set('v.activeMaintenanceAgreements', cntmap1);
                
                component.set('v.activeInvoices', result.invCount); 
                component.set('v.activeSites', result.sitesCount);
                component.set('v.accountId', result.accRecord);
                component.set('v.accountName',result.accRecordName);
                component.set('v.currentaccountId', result.accRecord);
                component.set('v.isADNOC', result.isADNOC);
                //component.set("v.hsescores",result.lst_hsescore);
                component.set('v.opportunityList', result.opportunityList);
                component.set('v.hsescores', result.lst_hsescore);
                //console.log('opportunity list'+result.lst_hsescore);
                
                helper.getTrafficFineInfo(component, event, helper);
                helper.getSalesAgreements(component, event, helper);
                helper.getAccountVisits(component, event, helper);
                helper.getVehicleAccidents(component, event, helper);
                helper.getHSEInfoHelper(component, event, helper);
                
                
            }
        });
        $A.enqueueAction(action);
        
        
    },
    handleSortSites : function(component,event,helper){
        //alert('inside sort');
        var item=event.target.id;
        console.log('item'+item);
        var currentData=component.get('v.currentsiteData'); 
        
        var sortDirection = component.get("v.sortDirection");
        if(sortDirection == 'asc')
            component.set("v.sortDirection","desc");
        else
            component.set("v.sortDirection","asc");
        console.log('sortDirection--------'+sortDirection);
        //var currentData=component.get('v.SOAlist');
        if(item=='siteName')
        {
            if(sortDirection == 'asc')
                currentData.sort((a, b) => (a.Account.Name > b.Account.Name) ? 1 : -1);
            else
                currentData.sort((a, b) => (a.Account.Name > b.Account.Name) ? -1 : 1);
        }
        if(item=='siteLocation')
        {
            if(sortDirection == 'asc')
                currentData.sort((a, b) => (a.Account.ET_Preferred_Location__c > b.Account.ET_Preferred_Location__c) ? 1 : -1);
            else
                currentData.sort((a, b) => (a.Account.ET_Preferred_Location__c > b.Account.ET_Preferred_Location__c) ? -1 : 1);
        }
        if(item=='siteFirstName')
        {
            if(sortDirection == 'asc')
                currentData.sort((a, b) => (a.FirstName > b.FirstName) ? 1 : -1);
            else
                currentData.sort((a, b) => (a.FirstName > b.FirstName) ? -1 : 1);
        }
        if(item=='sitePhone')
        {
            if(sortDirection == 'asc')
                currentData.sort((a, b) => (a.Phone > b.Phone) ? 1 : -1);
            else
                currentData.sort((a, b) => (a.Phone > b.Phone) ? -1 : 1);
        }
        
        component.set('v.currentsiteData',currentData); 
    },
    OpenFile :function(component,event,helper){ 
        var rec_id = event.currentTarget.id;
        
        $A.get('e.lightning:openFiles').fire({
            //Lightning Openfiles event  
            recordIds: [rec_id] //file id  	
        });  
    },
    handleSortResources: function(component,event,helper){
        //alert('inside sort');
        var item=event.target.id;
        console.log('item'+item);
        var currentData=component.get('v.resourceList'); 
        var sortDirection = component.get("v.sortDirection");
        if(sortDirection == 'asc')
            component.set("v.sortDirection","desc");
        else
            component.set("v.sortDirection","asc");
        console.log('sortDirection--------'+sortDirection);
        if(item=='resName')
        {
            if(sortDirection == 'asc')
                currentData.sort((a, b) => (a.Name > b.Name) ? 1 : -1);
            else
                currentData.sort((a, b) => (a.Name > b.Name) ? -1 : 1);
        }
        if(item=='resSgName')
        {
            if(sortDirection == 'asc')
                currentData.sort((a, b) => (a.Sales_Agreement__r.Name > b.Sales_Agreement__r.Name) ? 1 : -1);
            else
                currentData.sort((a, b) => (a.Sales_Agreement__r.Name > b.Sales_Agreement__r.Name) ? -1 : 1);
        }
        if(item=='resStartDate')
        {
            if(sortDirection == 'asc')
                currentData.sort((a, b) => (a.Assign_Start_Date__c > b.Assign_Start_Date__c) ? 1 : -1);
            else
                currentData.sort((a, b) => (a.Assign_Start_Date__c > b.Assign_Start_Date__c) ? -1 : 1);
        }
        if(item=='resEndDate')
        {
            if(sortDirection == 'asc')
                currentData.sort((a, b) => (a.Assign_End_Date__c > b.Assign_End_Date__c) ? 1 : -1);
            else
                currentData.sort((a, b) => (a.Assign_End_Date__c > b.Assign_End_Date__c) ? -1 : 1);
        }
        
        component.set('v.currentresourceList',currentData); 
    },
    handleSortVehicles: function(component,event,helper){
        //alert('inside sort');
        var item=event.target.id;
        console.log('item'+item);
        var currentData=component.get('v.vehileList'); 
        var sortDirection = component.get("v.sortDirection");
        if(sortDirection == 'asc')
            component.set("v.sortDirection","desc");
        else
            component.set("v.sortDirection","asc");
        console.log('sortDirection--------'+sortDirection);
        if(item=='vehicleName')
        {
            if(sortDirection == 'asc')
                currentData.sort((a, b) => (a.Name > b.Name) ? 1 : -1);
            else
                currentData.sort((a, b) => (a.Name > b.Name) ? -1 : 1);
        }
        if(item=='vehicleNumber')
        {
            if(sortDirection == 'asc')
                currentData.sort((a, b) => (a.Vehicle_Number__c > b.Vehicle_Number__c) ? 1 : -1);
            else
                currentData.sort((a, b) => (a.Vehicle_Number__c > b.Vehicle_Number__c) ? -1 : 1);
        }
        if(item=='vehSAName')
        {
            if(sortDirection == 'asc')
                currentData.sort((a, b) => (a.Sales_Agreement__r.Name > b.Sales_Agreement__r.Name) ? 1 : -1);
            else
                currentData.sort((a, b) => (a.Sales_Agreement__r.Name > b.Sales_Agreement__r.Name) ? -1 : 1);
        }
        if(item=='vehStartDate')
        {
            if(sortDirection == 'asc')
                currentData.sort((a, b) => (a.Assign_Start_Date__c > b.Assign_Start_Date__c) ? 1 : -1);
            else
                currentData.sort((a, b) => (a.Assign_Start_Date__c > b.Assign_Start_Date__c) ? -1 : 1);
        }
        if(item=='vehEndDate')
        {
            if(sortDirection == 'asc')
                currentData.sort((a, b) => (a.Assign_End_Date__c > b.Assign_End_Date__c) ? 1 : -1);
            else
                currentData.sort((a, b) => (a.Assign_End_Date__c > b.Assign_End_Date__c) ? -1 : 1);
        }
        
        component.set('v.currentvehileList',currentData); 
    },
    handleSortInvoices: function(component,event,helper){
        //alert('inside sort');
        var item=event.target.id;
        console.log('item'+item);
        var currentData=component.get('v.currentInvoicesList'); 
        var sortDirection = component.get("v.sortDirection");
        if(sortDirection == 'asc')
            component.set("v.sortDirection","desc");
        else
            component.set("v.sortDirection","asc");
        console.log('sortDirection--------'+sortDirection);
        if(item=='invNumber')
        {
            if(sortDirection == 'asc')
                currentData.sort((a, b) => (a.Name > b.Name) ? 1 : -1);
            else
                currentData.sort((a, b) => (a.Name > b.Name) ? -1 : 1);
        }
        if(item=='invDate')
        {
            if(sortDirection == 'asc')
                currentData.sort((a, b) => (a.Invoice_Date__c > b.Invoice_Date__c) ? 1 : -1);
            else
                currentData.sort((a, b) => (a.Invoice_Date__c > b.Invoice_Date__c) ? -1 : 1);
        }
        if(item=='invAmount')
        {
            if(sortDirection == 'asc')
                currentData.sort((a, b) => (a.Invoice_Amount__c > b.Invoice_Amount__c) ? 1 : -1);
            else
                currentData.sort((a, b) => (a.Invoice_Amount__c > b.Invoice_Amount__c) ? -1 : 1);
        }
        if(item=='invDueAmount')
        {
            if(sortDirection == 'asc')
                currentData.sort((a, b) => (a.Due_Amount__c > b.Due_Amount__c) ? 1 : -1);
            else
                currentData.sort((a, b) => (a.Due_Amount__c > b.Due_Amount__c) ? -1 : 1);
        }
        if(item=='invSaleAggrement')
        {
            if(sortDirection == 'asc')
                currentData.sort((a, b) => (a.Sales_Agreement__r.Name > b.Sales_Agreement__r.Name) ? 1 : -1);
            else
                currentData.sort((a, b) => (a.Sales_Agreement__r.Name > b.Sales_Agreement__r.Name) ? -1 : 1);
        }
        
        component.set('v.currentInvoicesList',currentData); 
    },
    saveOpp: function(component, event, helper) {
        var allValid = component.find('form1').reduce(function (validSoFar, inputCmp) {
            inputCmp.reportValidity();
            return validSoFar && inputCmp.checkValidity();
        }, true);
        
        if (allValid) {
            console.log('valid');
            helper.saveOppHelper(component, event, helper);
        }
    },
    openMoreActionWindow: function(component, event, helper) {
        
        var item=event.getSource().get('v.value');
        component.set('v.currentPO',item);
        component.set('v.more', true); 
        //Added by Janardhan- 04/08/2022 -start
        component.set('v.addMore', true); 
        component.set('v.opp.Description', '');
        component.set('v.opp.No_of_Resources__c', '');
        component.set('v.opp.No_of_Vehicles__c', '');
        component.set('v.opp.Effective_From__c', '');
        component.set('v.opp.Effective_To__c', '');
        //Added for Case
        component.set('v.caseRecord.Preferred_Date__c', '');
        component.set('v.caseRecord.Description', '');
        component.set('v.caseRecord.Subject', '');
        component.set('v.caseRecord.Preferred_End_Date__c', '');
        component.set('v.caseRecord.No_of_Vehicle__c', '');
        component.set('v.caseRecord.No_Of_Resources__c', '');        
        
        component.set('v.uploadedFileList',[]);
        //end
        
    },
    closeModel: function(component, event, helper) {
        helper.resetFlags(component);
    },
    openAddMoreWindow: function(component, event, helper) {
        component.set('v.terminateRequest', false); 
        component.set('v.addMore', true); 
        component.set('v.terminateRequest', false); 
        component.set('v.offHire', false); 
        component.set('v.hold', false); 
        var myCmp = component.find("addReq");
        $A.util.addClass(myCmp, "activeTabClass");
        var myCmp = component.find("TerminateReq");
        $A.util.removeClass(myCmp, "activeTabClass");
        var myCmp = component.find("offHire");
        $A.util.removeClass(myCmp, "activeTabClass");
        var myCmp = component.find("holdButton");
        $A.util.removeClass(myCmp, "activeTabClass");
    }, 
    openOffHireWindow: function(component, event, helper) {
        component.set('v.terminateRequest', false); 
        component.set('v.addMore', false); 
        component.set('v.offHire', true); 
        component.set('v.hold', false); 
        
        console.log('inside openOffHireWindow');
        var myCmp = component.find("offHire");
        $A.util.addClass(myCmp, "activeTabClass");
        //var myCmp = component.find("addReq");
        //$A.util.addClass(myCmp, "activeTabClass");
        var myCmp = component.find("TerminateReq");
        $A.util.removeClass(myCmp, "activeTabClass");
        var myCmp = component.find("addReq");
        $A.util.removeClass(myCmp, "activeTabClass");
        var myCmp = component.find("holdButton");
        $A.util.removeClass(myCmp, "activeTabClass");
    }, 
    addMoreRequestController: function(component, event, helper) {
        component.set('v.addMoreRequest', true); 
    }, 
    openTerminateRequestController: function(component, event, helper) {
        component.set('v.caseRecord.Business_Request_Type__c',component.find('TerminateReq').get('v.value'));
        component.set('v.addMore', false); 
        component.set('v.terminateRequest', true); 
        component.set('v.offHire', false); 
        component.set('v.hold', false); 
        
        var myCmp = component.find("addReq");
        $A.util.removeClass(myCmp, "activeTabClass");
        var myCmp = component.find("TerminateReq");
        $A.util.addClass(myCmp, "activeTabClass");
        var myCmp = component.find("offHire");
        $A.util.removeClass(myCmp, "activeTabClass");
        var myCmp = component.find("holdButton");
        $A.util.removeClass(myCmp, "activeTabClass");
        
    }, 
    openHoldRequestController: function(component, event, helper) {
        component.set('v.caseRecord.Business_Request_Type__c',component.find('holdButton').get('v.value'));
        component.set('v.addMore', false); 
        component.set('v.terminateRequest', false); 
        component.set('v.offHire', false); 
        component.set('v.hold', true); 
        
        var myCmp = component.find("holdButton");
        $A.util.addClass(myCmp, "activeTabClass");
        
        var myCmp = component.find("addReq");
        $A.util.removeClass(myCmp, "activeTabClass");
        var myCmp = component.find("TerminateReq");
        $A.util.removeClass(myCmp, "activeTabClass");
        var myCmp = component.find("offHire");
        $A.util.removeClass(myCmp, "activeTabClass");
        
        
    }, 
    terminateRequestController : function(component, event, helper) {
        var allValid = component.find('form2').reduce(function (validSoFar, inputCmp) {
            inputCmp.reportValidity();
            return validSoFar && inputCmp.checkValidity();
        }, true);
        
        if (allValid) {
            helper.terminateRequestHelper(component, event, helper);
        }
    },
    holdRequestController : function(component, event, helper) {
        var allValid = component.find('form4').reduce(function (validSoFar, inputCmp) {
            inputCmp.reportValidity();
            return validSoFar && inputCmp.checkValidity();
        }, true);
        console.log('')
        if (allValid) {
            helper.holdRequestHelper(component, event, helper);
        }
    },
    offHireRequestController : function(component, event, helper) {
        console.log('inside offhire request controller');
        component.set('v.caseRecord.Business_Request_Type__c',component.find('offHire').get('v.value'));
        
        var allValid = component.find('form3').reduce(function (validSoFar, inputCmp) {
            inputCmp.reportValidity();
            return validSoFar && inputCmp.checkValidity();
        }, true);
        console.log('all valid'+allValid);
        if (allValid) {
            helper.offHireRequestHelper(component, event, helper);
        }
    },
    
    getchilddetails: function (component, event,helper) {
        
        component.set('v.salesAgreement', true);//Making default tab for every search btn click
        component.set('v.invoices', false);
        
        component.set('v.maintenanceAgreement', false);
        component.set('v.sites',false);
        component.set('v.assignResources', false);
        component.set('v.assignVehicles', false);
        component.set('v.students', false);
        component.set('v.assignMaintenanceWo', false);
        component.set('v.assignEstimation', false);
        component.set('v.assignActiveMaintenanceWo', false);
        component.set('v.assignMaintenanceVehicles', false);
        var today = $A.localizationService.formatDate(new Date(), "YYYY-MM-DD");
        var today1 = new Date();
        component.set('v.today', today);
        component.set('v.currentDate', today1.getFullYear());
        var accounti=component.find('InputSelectAccount').get('v.value'); 
        
        var action;
        if(accounti=='All'){
            component.set('v.showAll',true);
            action = component.get('c.getUserAccountDetails');
        }else{
            component.set('v.showAll',false);
            action = component.get('c.getUserAccountDetailsbyAccount');
            action.setParams({
                AccountId:  accounti
            });
        }
        action.setCallback(this, function (a) {
            var state = a.getState(); // get the response state
            if (state == 'SUCCESS') {
                console.log('success');
                var result = a.getReturnValue();
                component.set('v.businessWrapper', a.getReturnValue());
                
                //for active sales aggrement
                var cntmap=0;
                for(var cnt in result.poList){
                    cntmap++;
                } 
                var custs=[];
                for ( var key in result.poList ) {
                    custs.push({value:result.poList[key], key:key});
                }
                
                //for active maintenance aggrement
                var cntmap1=0;
                for(var cnt in result.maintenancePoList){
                    cntmap1++;
                } var custs1=[];
                for ( var key in result.maintenancePoList ) {
                    custs1.push({value:result.maintenancePoList[key], key:key});
                }
                //other agreements
                var cntmap2=0;
                for(var cnt in result.otherPoList){
                    cntmap2++;
                } var custs2=[];
                for ( var key in result.otherPoList ) {
                    custs2.push({value:result.otherPoList[key], key:key});
                }
                
                component.set("v.poList", custs);
                //Jana-component.set("v.currentpoList", custs);
                component.set("v.activeSalesAgreements", cntmap);
                
                component.set('v.maintenencePOList', custs1);
                component.set('v.activeMaintenanceAgreements', cntmap1);
                
                component.set("v.otherpoList", custs2);
                //component.set("v.activeotherAgreements", cntmap2);
                component.set('v.cumpercent', result.cumpercent);
                component.set('v.activeInvoices', result.invCount); 
                component.set('v.activeSites', result.sitesCount);
                //component.set('v.accountId', result.accRecord);
                component.set('v.currentaccountId', result.accRecord);
                console.log('Account='+result.accRecord);
                component.set('v.isADNOC', result.isADNOC);
                component.set('v.opportunityList', result.opportunityList);
                component.set('v.hsescores', result.lst_hsescore);
                console.log('opportunity list'+JSON.stringify(result));
                
                helper.getTrafficFineInfo(component, event, helper);
                helper.getSalesAgreements(component, event, helper);
                helper.getAccountVisits(component, event, helper);
                helper.getVehicleAccidents(component, event, helper);
                helper.getHSEInfoHelper(component, event, helper);
            }
        });
        
        $A.enqueueAction(action);
        
        
        
    },
    showCaseModal: function(component,event){
        var modalBody;
        var modalFooter;
        var idx = event.getSource().get("v.name");
        console.log(event.getSource().get("v.name")); 
        console.log('&&&&&&&&&&&INSIDECHILD'+idx);
        $A.createComponents([
            ["c:CaseB2BPopup",{
                "recordId": idx,
            }]
        ],
                            function(components, status){
                                console.log('&&&&&&&&&&&2'+status);
                                if (status === "SUCCESS") {
                                    modalBody = components[0];
                                    console.log('&&&&&&&&&&&3');
                                    component.find('overlayLib').showCustomModal({
                                        header: "Create Complaint",
                                        body: modalBody,
                                        footer: modalFooter,
                                        showCloseButton: true,
                                        cssClass: "my-modal,my-custom-class,my-other-class",
                                        closeCallback: function() {
                                        }
                                    });
                                }
                            });
        
        
    },
    handleApplicationEvent: function (component, event) {
        
        var myBusinessDashboard = event.getParam("salesAgreementDashboard");
        var sAg = event.getParam("salesAgreement");
        var assignRes = event.getParam("assignResources");
        var vehicle = event.getParam("assignVehicles");
        var inv = event.getParam("invoices");
        
        var agreementClick = event.getParam("salesAgreementClick");
        var resourceClick = event.getParam("assignResourcesClick");
        var vehicleClick = event.getParam("assignVehiclesClick");
        var invClick = event.getParam("invoicesClick");
        var govtSchool = event.getParam("govtSchool");
        
        component.set("v.salesAgreementDashboard", myBusinessDashboard);
        component.set("v.salesAgreement", sAg);
        component.set("v.assignResources", assignRes);
        component.set("v.assignVehicles", vehicle);
        component.set("v.invoices", inv);
        component.set("v.govtSchool", govtSchool);
        component.set("v.salesAgreementClick", agreementClick);
        component.set("v.assignResourcesClick", resourceClick);
        component.set("v.assignVehiclesClick", vehicleClick);
        component.set("v.invoiinvoicesClickces", invClick);
    },
    handleVehicleCount: function (component, event, helper) {
        helper.resetDashBoard(component);
        component.set("v.assignVehicles", true);
        var monthNo = event.target.id;
        console.log('monthNo'+monthNo);
        helper.showVehiclesHelper(component, event, helper,monthNo);
        
    }, 
    handleMaintenanceVehicleCount: function (component, event, helper) {
        helper.resetDashBoard(component);
        component.set("v.assignMaintenanceVehicles", true);
        var monthNo = event.target.id;
        helper.showMaintenanceVehiclesHelper(component, event, helper,monthNo);
        
    }, 
    handleMaintenanceWoCount: function (component, event, helper) {
        
        helper.resetDashBoard(component);
        component.set("v.assignMaintenanceWo", true);
        var monthNo = event.target.id;
        console.log('monthNo'+monthNo);
        helper.showMaintenanceWOHelper(component, event, helper,monthNo);
    },
    handleEstimationCount: function (component, event, helper) {
        helper.resetDashBoard(component);
        component.set("v.assignEstimation", true);
        var monthNo = event.target.id;
        console.log('monthNo'+monthNo);
        helper.showEstimationHelper(component, event, helper,monthNo);
    },
    handleActiveMaintenanceWoCount: function (component, event, helper) {
        helper.resetDashBoard(component);
        component.set("v.assignActiveMaintenanceWo", true);
        var monthNo = event.target.id;
        //console.log('monthNo'+monthNo);
        helper.showActiveMaintenanceWOHelper(component, event, helper,monthNo);
    },
    handleResourceCount: function (component, event, helper) {
        helper.resetDashBoard(component);
        component.set("v.assignResources", true);
        var monthNo = event.target.id;
        helper.showResourcesHelper(component, event, helper,monthNo);
        
    },
    handleSalesAgreementClick: function (component, event, helper) {
        var recId = event.target.id;
        helper.resetDashBoard(component);
        component.set("v.showRecordDetailModal", true);
        component.set("v.recordDetailId", recId);
        component.set("v.recordTypeName", "et-sales-agreement/");
        
    },
    handleHSEScoreClick: function (component, event, helper) {
        helper.resetDashBoard(component);
        component.set("v.isHSEDetail", true);
        
    },
    handleServicReqClick : function (component, event, helper) {
        // helper.getfleetReqt(component,helper,event);
        helper.getCustomerWorkstationInfo(component, event, helper);
        helper.getfleetReqt(component, event, helper);
        helper.resetDashBoard(component);
        component.set("v.isServiceReq", true);
    },
    handleSalesAgreementClickNew: function (component, event, helper) {
        var recId = event.target.id;
        component.set("v.recordDetailId", recId);
        component.set("v.objectApiName", "ET_Sales_Agreement__c");
        component.set("v.ObjectName", "Sales Agreement");
        component.set("v.recordName", "Customer_PO__c");
        
        component.set("v.fieldApiName1", "Customer_PO__c");
        component.set("v.fieldApiName2", "Contract_Status__c"); 
        component.set("v.fieldApiName3", "Contract_Start_Date__c");
        component.set("v.fieldApiName4", "Contract_End_Date__c");
        
        component.set("v.field1Label", "Customer PO No.");
        component.set("v.field2Label", "Contract Status");
        component.set("v.field3Label", "Contract Start Date");
        component.set("v.field4Label", "Contract End Date");
        
        component.set("v.showDetailCmp", true);
        
    },
    handleAssignedResourcesClick: function (component, event, helper) {
        
        var recId = event.target.id;
        //helper.resetDashBoard(component);
        //component.set("v.showRecordDetailModal", true);
        component.set("v.recordDetailId", recId);
        component.set("v.recordTypeName", "saline-assigned-resource/");
        
        $A.createComponent(
            "c:BusinessCommunityRecordDetailPopup",{
                showIFrame: true,
                recordDetailId:component.get("v.recordDetailId"),
                recordTypeName:component.get("v.recordTypeName")
            },
            function(newcomponent){
                if (component.isValid()) {
                    var body = component.get("v.body");
                    body.push(newcomponent);
                    component.set("v.body", body);             
                }
            }            
        );  
        
    },
    handleAssignedResourcesClickNew: function (component, event, helper) {
        var recId = event.target.id;
        component.set("v.recordDetailId", recId);
        component.set("v.objectApiName", "SALine_Assigned_Resource__c");
        component.set("v.ObjectName", "Assigned Resource");
        component.set("v.recordName", "Name");
        
        component.set("v.fieldApiName1", "Employee_ID__c");
        component.set("v.fieldApiName2", "Name"); 
        component.set("v.fieldApiName3", "Assign_Start_Date__c");
        component.set("v.fieldApiName4", "Assign_End_Date__c");
        
        component.set("v.field1Label", "Employee ID");
        component.set("v.field2Label", "Employee Name");
        component.set("v.field3Label", "Assign Start Date");
        component.set("v.field4Label", "Assign End Date");
        
        component.set("v.showDetailCmp", true);
        
    },
    handleAssignedVehiclesClick: function (component, event, helper) {
        
        var recId = event.target.id;
        helper.resetDashBoard(component);
        component.set("v.showRecordDetailModal", true);
        component.set("v.recordDetailId", recId);
        component.set("v.recordTypeName", "saline-assigned-vehicle/");
        
        $A.createComponent(
            "c:BusinessCommunityRecordDetailPopup",{
                showIFrame: true,
                recordDetailId:component.get("v.recordDetailId"),
                recordTypeName:component.get("v.recordTypeName")
            },
            function(newcomponent){
                if (component.isValid()) {
                    var body = component.get("v.body");
                    body.push(newcomponent);
                    component.set("v.body", body);             
                }
            }            
        );  
    },
    handleAssignedVehiclesClickNew: function (component, event, helper) {
        
        var recId = event.target.id;
        component.set("v.recordDetailId", recId);
        component.set("v.objectApiName", "SALine_Assigned_Vehicle__c");
        component.set("v.ObjectName", "Assigned Vehicle");
        component.set("v.recordName", "Name");
        
        component.set("v.fieldApiName1", "Name");
        component.set("v.fieldApiName2", "Vehicle_Number__c"); 
        component.set("v.fieldApiName3", "Assign_Start_Date__c");
        component.set("v.fieldApiName4", "Assign_End_Date__c");
        
        component.set("v.field1Label", "Associated Vehicle Name");
        component.set("v.field2Label", "Vehicle Number");
        component.set("v.field3Label", "Assign Start Date");
        component.set("v.field4Label", "Assign End Date");
        
        component.set("v.showDetailCmp", true);
    },
    vehicleMasterView :  function (component, event, helper) {
        
        var recId = event.target.id;
        component.set("v.recordDetailId", recId);
        component.set("v.objectApiName", "Vehicle_Master__c");
        component.set("v.ObjectName", "Vehicle Master");//to display in header
        component.set("v.recordName", "Name");      //to display in header 
        
        component.set("v.showDetailCmp", true);
        
    },
    accidentDetailView : function (component, event, helper) {
        
        var recId = event.target.id;
        component.set("v.recordDetailId", recId);
        component.set("v.objectApiName", "Vehicle_Accident__c");
        component.set("v.ObjectName", "Vehicle Accident Details");//to display in header
        component.set("v.recordName", "Name");      //to display in header 
        
        component.set("v.showDetailCmp", true);
        
        var tesv1 =component.get("v.objectApiName");
        console.log(tesv1);
        
        
    },
    handleinvoicesClick: function (component, event, helper) {
        
        var recId = event.target.id;
        helper.resetDashBoard(component);
        component.set("v.showRecordDetailModal", true);
        component.set("v.recordDetailId", recId);
        component.set("v.recordTypeName", "invoice/");
        
        $A.createComponent(
            "c:BusinessCommunityRecordDetailPopup",{
                showIFrame: true,
                recordDetailId:component.get("v.recordDetailId"),
                recordTypeName:component.get("v.recordTypeName")
            },
            function(newcomponent){
                if (component.isValid()) {
                    var body = component.get("v.body");
                    body.push(newcomponent);
                    component.set("v.body", body);             
                }
            }            
        );        
        
    },
    handleinvoicesClickNew: function (component, event, helper) {
        
        var recId = event.target.id;
        component.set("v.recordDetailId", recId);
        component.set("v.objectApiName", "Invoice__c");
        component.set("v.ObjectName", "Invoice");
        component.set("v.recordName", "Name");
        
        component.set("v.fieldApiName1", "Name");
        component.set("v.fieldApiName2", "Invoice_Number__c"); 
        component.set("v.fieldApiName3", "Invoice_Date__c");
        component.set("v.fieldApiName4", "Payment_Status__c");
        
        component.set("v.field1Label", "Name");
        component.set("v.field2Label", "Invoice Number");
        component.set("v.field3Label", "Invoice Date");
        component.set("v.field4Label", "Payment Status");
        
        component.set("v.showDetailCmp", true);
    },
    handleSitesClickDashboard: function (component, event, helper) {
        helper.resetDashBoard(component);
        component.set('v.sites',true);
        helper.getSiteDetailsHelper(component, event, helper);
    },
    
    handleSalesAgreementClickDashboard: function (component, event, helper) {
        helper.resetDashBoard(component);
        component.set('v.salesAgreement', true);
        
    },
    handleOtherAgreementClickDashboard: function (component, event, helper) {
        helper.resetDashBoard(component);
        component.set('v.otherAgreement', true);
        
    },
    handleMaintenanceAggrementClickDashboard: function (component, event, helper) {
        helper.resetDashBoard(component);
        component.set('v.maintenanceAgreement', true);
        
    },
    handleActiveResourceClickDashboard: function (component, event, helper) {
        helper.resetDashBoard(component);
        component.set('v.assignResources', true);
        
    },
    handleActiveVehiclesClickDashboard: function (component, event, helper) {
        helper.resetDashBoard(component);
        component.set('v.assignVehiclesClick', true);
        
    },
    handleActiveInvoicesClickDashboard: function (component, event, helper) {
        helper.getInvHelper(component, event, helper);
        helper.resetDashBoard(component);
        component.set('v.invoices', true);
        
    },
    trafficFinesHandler: function (component, event, helper) { //Added by Janardhan - 11/08/22
        
        helper.getTrafficFineInfo(component, event, helper);
        helper.resetDashBoard(component);
        component.set('v.isTrafficFines', true);
        
    },
    closeUploadModel: function(component, event, helper) {
        component.set('v.isUpload',false);
    },        
    
    openUploadPopup: function(component, event, helper) {
        component.set('v.isUpload',true);
        component.set('v.currentMonth',event.getSource().get('v.value'));
        component.set('v.timesheetURL','');
    },
    handleUploadFinished: function(component, event, helper) {
        
        var uploadedFiles = event.getParam("files");
        alert("Files uploaded : " + uploadedFiles.length);
        // Get the file name
        uploadedFiles.forEach(file => component.set('v.docId',file.documentId));
        uploadedFiles.forEach(file => component.set('v.fileName',file.name));
        var docList =[];
        var fileNameList =[];
        for(var item in uploadedFiles){
            docList.push(uploadedFiles[item].documentId);
            fileNameList.push(uploadedFiles[item].name);
        }
        console.log("docList " + docList);
        console.log("fileNameList " + fileNameList);
        component.set('v.docId',docList);
        component.set('v.fileName',fileNameList);
        helper.setUploadedFile(component, event, helper);
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "type": "success",
            "title": "Success!",
            "message": "Time sheet uploaded successfully."
        });
        toastEvent.fire();
        component.set('v.isUpload',false);
    },
    uploadTimesheetURL: function(component, event, helper) {
        var timesheetURL = component.get('v.timesheetURL');
        if(timesheetURL != ''){
            var action = component.get("c.insertTimesheet");
            action.setParams({ 
                "currentMonth" : component.get('v.currentMonth'),
                "accountId" : component.get('v.accountId'),
                "timesheetURL" : component.get('v.timesheetURL')
            });
            action.setCallback(this, function(response) {
                var state = response.getState();
                if (state === "SUCCESS") {
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        "type": "success",
                        "title": "Success!",
                        "message": "Time sheet URL updated successfully."
                    });
                    toastEvent.fire();
                    component.set('v.isUpload',false);
                }
                else if (state === "ERROR") {
                    var errors = response.getError();
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        "type": "error",
                        "title": "Error!",
                        "message": "Error in Time sheet upload."+errors[0].message
                    });
                    toastEvent.fire();
                    component.set('v.isUpload',false);
                }
            });
            $A.enqueueAction(action);
            
        }else{
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                "type": "error",
                "title": "Error!",
                "message": "Please enter timesheet URL."
            });
            toastEvent.fire();
        }
        
    },
    openViewPopup: function(component, event, helper) {
        component.set('v.selectedDocId',null);
        component.set('v.viewFile',true);
        component.set('v.currentMonth',event.getSource().get('v.value'));
        helper.getDocIdHelper(component, event, helper);
        helper.getTimesheetHelper(component, event, helper);
    },
    closeViewPopup: function(component, event, helper) {
        component.set('v.viewFile',false);
    },
    searchInvoices: function(component, event, helper) {
        var searchKey=component.get('v.searchText');
        console.log('searchKey-->'+searchKey);
        if(searchKey.length>2){
            var deliveryData = component.get('v.invoicesList');
            var fileredData =  deliveryData.filter(function(item) {
                return (item.Invoice_Number__c.toLowerCase().indexOf(searchKey.toLowerCase()) !== -1);
                // ||(item.Status.toLowerCase().indexOf(searchKey) !== -1);
            });
            
            component.set('v.currentInvoicesList',fileredData); 
        }else{
            component.set('v.currentInvoicesList',component.get('v.invoicesList'));  
        }
        
    },
    searchResources: function(component, event, helper) {
        var searchKey=component.get('v.searchText');
        console.log('searchKey-->'+searchKey);
        if(searchKey.length>2){
            var deliveryData = component.get('v.resourceList');
            var fileredData =  deliveryData.filter(function(item) {
                return (item.Name.toLowerCase().indexOf(searchKey.toLowerCase()) !== -1);
                // ||(item.Status.toLowerCase().indexOf(searchKey) !== -1);
            });
            
            component.set('v.currentresourceList',fileredData); 
        }else{
            component.set('v.currentresourceList',component.get('v.resourceList'));  
        }
        
    },
    searchVehicles: function(component, event, helper) {
        var searchKey=component.get('v.searchText');
        console.log('searchKey-->'+searchKey);
        if(searchKey.length>2){
            var deliveryData = component.get('v.vehileList');
            var fileredData =  deliveryData.filter(function(item) {
                return (item.Plate_Number__c.toLowerCase().indexOf(searchKey.toLowerCase()) !== -1);
                // ||(item.Status.toLowerCase().indexOf(searchKey) !== -1);
            });
            
            component.set('v.currentvehileList',fileredData); 
        }else{
            component.set('v.currentvehileList',component.get('v.vehileList'));  
        }
        
    },
    searchSites : function(component, event, helper) {
        var searchKey=component.get('v.searchText');
        console.log('searchKey-->'+searchKey);
        if(searchKey.length>2){
            var deliveryData = component.get('v.siteList');
            var fileredData =  deliveryData.filter(function(item) {
                return (item.Account.Name.toLowerCase().indexOf(searchKey.toLowerCase()) !== -1);
                // ||(item.Status.toLowerCase().indexOf(searchKey) !== -1);
            });
            
            component.set('v.currentsiteData',fileredData); 
        }else{
            component.set('v.currentsiteData',component.get('v.siteList'));  
        }
        
    },
    searchAgreements : function(component, event, helper) {
        var searchKey=component.get('v.searchText');
        
        if(searchKey.length>2){
            var deliveryData = component.get('v.currentpoList');
            
            var fileredData =  deliveryData.filter(function(item) {
                return (item.Customer_PO_No__c.toLowerCase().indexOf(searchKey.toLowerCase()) !== -1);
                // ||(item.Status.toLowerCase().indexOf(searchKey) !== -1);
            });
            
            component.set('v.salesAgreeFilterList',fileredData); 
        }else{
            component.set('v.salesAgreeFilterList',component.get('v.currentpoList'));  
        }
        
    },
    searchCallOuts :  function(component, event, helper) {
        var searchKey=component.get('v.searchText');
        console.log('searchKey-->'+searchKey);
        if(searchKey.length>2){
            let data = component.get('v.AllCalloutList'); 
            var fileredData =  data.filter(function(item) {
                return (item.Customer_PO_No__c.toLowerCase().indexOf(searchKey.toLowerCase()) !== -1);
                // ||(item.Status.toLowerCase().indexOf(searchKey) !== -1);
            });
            
            component.set('v.currentCalloutList',fileredData); 
            
        }else{
            component.set('v.currentCalloutList',component.get('v.AllCalloutList'));  
        }
        
    },
    
    searchTrafficFines : function(component, event, helper) { //Added by Janardhan 12/08/22
        let searchKey=component.get('v.searchText');
        //console.log(searchKey)
        if(searchKey.length>2){
            let data = component.get('v.trafficFineList');
            let filterData = data.filter(function(item) {
                console.log(item.Name)
                return (item.Name.toLowerCase().indexOf(searchKey.toLowerCase()) !== -1)  || (item.Assigned_Vehicle__r.Name.toLowerCase().indexOf(searchKey) !== -1);
                
            });
            component.set('v.trafficFineFilterList',filterData); 
            
        }else{
            component.set('v.trafficFineFilterList',component.get('v.trafficFineList'));  
        }
    },
    
    downloadInvoices :function(component, event, helper){
        
        var allResources=component.get("v.currentInvoicesList");
        var type='invoice';
        //component.set("v.finalListToAdd",allResources);
        //var finalListToDownload=component.get("v.finalListToAdd");
        var csv=helper.convertArrayOfObjectsToCSV(component,allResources,type,helper); 
        if(csv==null)
        {
            
            return ;
        }                         
        var elementLink=document.createElement('a');
        elementLink.href='data:text/csv;charset=utf-8,'+encodeURI(csv);
        elementLink.target='_self';
        elementLink.download='UnpaidInvoicesExportData.csv';
        document.body.appendChild(elementLink);
        elementLink.click();
        $A.get('e.force:refreshView').fire();   
    },
    downloadResources :function(component, event, helper){
        
        var allResources=component.get("v.resourceList");
        var type='resource';
        //component.set("v.finalListToAdd",allResources);
        //var finalListToDownload=component.get("v.finalListToAdd");
        var csv=helper.convertArrayOfObjectsToCSV(component,allResources,type,helper); 
        if(csv==null)
        {
            
            return ;
        }                         
        var elementLink=document.createElement('a');
        elementLink.href='data:text/csv;charset=utf-8,'+encodeURI(csv);
        elementLink.target='_self';
        elementLink.download='ResourceExportData.csv';
        document.body.appendChild(elementLink);
        elementLink.click();
        $A.get('e.force:refreshView').fire();   
    },
    downloadSites:function(component, event, helper){
        var type='site'; 
        var allResources=component.get("v.siteList");
        var csv=helper.convertArrayOfObjectsToCSV(component,allResources,type,helper); 
        if(csv==null)
        {
            
            return ;
        }                         
        var elementLink=document.createElement('a');
        elementLink.href='data:text/csv;charset=utf-8,'+encodeURI(csv);
        elementLink.target='_self';
        elementLink.download='SitesExportData.csv';
        document.body.appendChild(elementLink);
        elementLink.click();
        $A.get('e.force:refreshView').fire();   
    },
    downloadVehicles :function(component, event, helper){
        var type='vehicle';  
        var allResources=component.get("v.vehileList");
        //component.set("v.finalListToAdd",allResources);
        //var finalListToDownload=component.get("v.finalListToAdd");
        var csv=helper.convertArrayOfObjectsToCSV(component,allResources,type,helper); 
        if(csv==null)
        {
            
            return ;
        }                         
        var elementLink=document.createElement('a');
        elementLink.href='data:text/csv;charset=utf-8,'+encodeURI(csv);
        elementLink.target='_self';
        elementLink.download='VehiclesExportData.csv';
        document.body.appendChild(elementLink);
        elementLink.click();
        $A.get('e.force:refreshView').fire();   
    },
    //Maintenance Agreement Downloads
    downloadMaintenanceVehicles :function(component, event, helper){
        var type='vehicleMaintenance';  
        var allResources=component.get("v.vehicleMaintenanceList");
        var csv=helper.convertArrayOfObjectsToCSV(component,allResources,type,helper); 
        if(csv==null)
        {
            return ;
        }                         
        var elementLink=document.createElement('a');
        elementLink.href='data:text/csv;charset=utf-8,'+encodeURI(csv);
        elementLink.target='_self';
        elementLink.download='MaintenanceVehiclesExportData.csv';
        document.body.appendChild(elementLink);
        elementLink.click();
        $A.get('e.force:refreshView').fire();   
    },
    downloadMaintenanceWO :function(component, event, helper){
        var type='maintenanceWO';  
        var allResources=component.get("v.maintenanceWoList");
        //added by Janardhan-14/03/23 : replacing \n and # symbols
        allResources.forEach(function(item){
            
            item.Description__c = item.Description__c.replaceAll(/#|\n/g, " ");
        });
        //Ended 
        var csv=helper.convertArrayOfObjectsToCSV(component,allResources,type,helper); 
        if(csv==null)
        {
            return ;
        }                         
        var elementLink=document.createElement('a');
        elementLink.href='data:text/csv;charset=utf-8,'+encodeURI(csv);
        elementLink.target='_self';
        elementLink.download='MaintenanceWorkOrderExportData.csv';
        document.body.appendChild(elementLink);
        elementLink.click();
        $A.get('e.force:refreshView').fire();
    },
    downloadMaintenanceEstimation:function(component, event, helper){
        var type='maintenanceEstimation';  
        var allResources=component.get("v.maintenanceEstList");
        var csv=helper.convertArrayOfObjectsToCSV(component,allResources,type,helper); 
        if(csv==null)
        {
            return ;
        }                         
        var elementLink=document.createElement('a');
        elementLink.href='data:text/csv;charset=utf-8,'+encodeURI(csv);
        elementLink.target='_self';
        elementLink.download='EstimationExportData.csv';
        document.body.appendChild(elementLink);
        elementLink.click();
        $A.get('e.force:refreshView').fire();   
    },
    downloadActiveMaintenanceWO:function(component, event, helper){
        var type='activeMaintenanceWO';  
        var allResources=component.get("v.activeMaintenanceWoList");
        var csv=helper.convertArrayOfObjectsToCSV(component,allResources,type,helper); 
        if(csv==null)
        {
            return ;
        }                         
        var elementLink=document.createElement('a');
        elementLink.href='data:text/csv;charset=utf-8,'+encodeURI(csv);
        elementLink.target='_self';
        elementLink.download='EstimationExportData.csv';
        document.body.appendChild(elementLink);
        elementLink.click();
        $A.get('e.force:refreshView').fire();   
    },
    showSalesAggs: function (component, event, helper) {
        helper.showSalesAggsHelper(component, event, helper);
        /*component.set('v.isSalesAggs',true);
        var item=event.getSource().get('v.value');
        var action = component.get('c.getsalesAggsforPO');
        action.setParams({
            POName: item
        });
        action.setCallback(this, function (a) {
            var state = a.getState(); // get the response state
            if (state == 'SUCCESS') {
                var result = a.getReturnValue();
                component.set('v.salesAgreementList', result);
                
            }
        });
        $A.enqueueAction(action);*/
    },
    showOtherAggs: function (component, event, helper) {
        helper.showOtherAggsHelper(component, event, helper);
    },
    showMaintenanceAggs: function (component, event, helper) {
        helper.showMaintenanceAggsHelper(component, event, helper);
    },
    handleDateChange: function(component, event, helper){        
        if(component.get("v.opp.Effective_To__c") != undefined && component.get("v.opp.Effective_From__c") != undefined
           && component.get("v.opp.Effective_To__c") != '' && component.get("v.opp.Effective_From__c") != '' 
           //&& component.get("v.accountId") == $A.get("$Label.c.adnoc_account_id") 
          ){
            let dateTo = new Date(component.get("v.opp.Effective_To__c"));
            let dateFrom = new Date(component.get("v.opp.Effective_From__c"));
            let noOfMonths = dateTo.getMonth() - dateFrom.getMonth() + (12 * (dateTo.getFullYear() - dateFrom.getFullYear()));
            
            if(noOfMonths >= 0 && noOfMonths <= 6){
                component.set("v.opp.API_Service_Name__c", "Call out");
            }
            else if(noOfMonths > 6){
                component.set("v.opp.API_Service_Name__c", "Call off");
            }
            //alert(component.get("v.opp.API_Service_Name__c"));
        }
        
    },
    
    handleDeleteClick: function(component, event, helper){    
        var fileId = event.getSource().get('v.name');
        // alert('delete'+fileId);
        
        var action = component.get("c.deleteFile");
        action.setParams({ 
            fileId : fileId
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Success!",
                    "type":"success",
                    "message": "File deleted Successfully!"
                });
                toastEvent.fire();
                component.set('v.viewFile',false);
            }
            else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        "title": "Error!",
                        "type":"error",
                        "message": "Error in deleting file,"+errors[0].message
                    });
                    toastEvent.fire();
                } 
            }
        });
        $A.enqueueAction(action);
    },
    onchangeInvoiceType : function( component, event, helper )
    {
        var action1 = component.find('InputSelectSingle').get('v.value');
        
        if(action1=='Paid')
            component.set('v.currentInvoicesList', component.get('v.paidList'));
        else if (action1=='Not Paid')
            component.set('v.currentInvoicesList', component.get('v.unpaidList'));
            else if (action1=='All')
                component.set('v.currentInvoicesList', component.get('v.invoicesList'));
    },
    
    onFileUploaded : function( component, event, helper ){ //Added  by Janardhan 04/08/22
        try{
            var files = component.get("v.fileToBeUploaded");
            var fileUploadWrapper=component.get('v.uploadedFileList');
            
            for(var i=0; i < files[0].length; i++){
                var file = files[0][i];
                if(file.size < 2000000){
                    var reader = new FileReader();
                    reader.name = file.name;
                    reader.type = file.type;
                    
                    reader.onloadend = function(e) {
                        fileUploadWrapper.push({
                            'strFileName':e.target.name,
                            'strFileType':e.target.type,
                            'strBase64Data':reader.result
                            
                        });
                        
                        //console.log(fileUploadWrapper)
                        component.set('v.uploadedFileList',fileUploadWrapper);
                    }
                    reader.readAsDataURL(file);   
                    
                    
                }else{
                    
                    helper.showToast('warning','warning','Image size must be less than 2MB');
                }
            }
            
        }catch(e){
            
            console.log(e.message)
        }
    },
    removeImg : function(component, event, helper) { //Added  by Janardhan 04/08/22
        
        var index = event.target.dataset.index;
        var toremovefile = event.currentTarget.dataset.filename;
        var removefileToBeUploaded= component.get("v.uploadedFileList");
        removefileToBeUploaded.splice(index, 1);
        component.set("v.uploadedFileList", removefileToBeUploaded);
    },
    
    openViewDashboard: function(component, event, helper) { //Added by Janardhan 05/08/22
        
        var idVal = event.currentTarget.dataset.id;
        if(idVal == 'Standard'){
            var urlEvent = $A.get("e.force:navigateToURL");
            urlEvent.setParams({
                "url": "/Business/s/stdDashboard"
            });
            urlEvent.fire();
            // component.set("v.showStdDashComp",true);
        }
        if(idVal == 'Custom'){
            helper.resetDashBoard(component);
            component.set("v.showDashboard",true);
        }
    },
    openCaseLink : function(component, event, helper) { //Added by Janardhan 08/05/23
        var urlEvent = $A.get("e.force:navigateToURL");
        urlEvent.setParams({
            "url": "/Business/s/customer-care"
        });
        urlEvent.fire();
    },
    
    showResourceListHandler :function(component, event, helper) { //Added by Janardhan 29/08/22
        
        component.set("v.showResourceList",true);
        var recId = event.target.id;
        var agreeType = event.currentTarget.dataset.filename;
        
        if(agreeType == 'Fixed'){
            let data =  component.get("v.currentpoList");            
            
            data.forEach(function(item){
                if(item.Id==recId)           
                    component.set("v.currentResourceVal",item.Associated_Resources__r);
            });              
        }else{
            let data =  component.get("v.currentCalloutList");            
            
            data.forEach(function(item){
                if(item.Id==recId)           
                    component.set("v.currentResourceVal",item.Associated_Resources__r);
            });        
            
        }
        
    },
    closeShowResourcesList : function(component, event, helper){
        
        component.set("v.showResourceList",false);
    },
    
    showVehicleListHandler: function(component, event, helper) { //Added by Janardhan 29/08/22
        
        component.set("v.showVehicleList",true);
        var recId = event.target.id;
        var agreeType = event.currentTarget.dataset.filename;
        
        if(agreeType == 'Fixed'){
            let data =  component.get("v.currentpoList");            
            
            data.forEach(function(item){
                if(item.Id==recId)           
                    component.set("v.currentVehiclesVal",item.Associated_Vehicles__r);
            });   
            
        }else{
            
            let data =  component.get("v.currentCalloutList");            
            
            data.forEach(function(item){
                if(item.Id==recId)           
                    component.set("v.currentVehiclesVal",item.Associated_Vehicles__r);
            });  
            
        }
    },
    
    closeShowVehList :function(component, event, helper){
        
        component.set("v.showVehicleList",false);
    },
    
    showAccVisitsSection : function(component, event, helper){
        
        helper.resetDashBoard(component);
        component.set("v.isAccVisit", true);
    },
    filterAccVisits : function(component, event, helper){
        let searchKey=component.get('v.searchText');
        
        if(searchKey.length>2){
            let data = component.get('v.accVisitList');
            let filterData = data.filter(function(item) {
                
                return (item.Name.toLowerCase().indexOf(searchKey.toLowerCase()) !== -1)  || (item.Agreed_Actions__c.toLowerCase().indexOf(searchKey) !== -1) || (item.Purpose_of_Visit__c.toLowerCase().indexOf(searchKey) !== -1);
                
            });
            component.set('v.accVisitFilterList',filterData); 
            
        }else{
            component.set('v.accVisitFilterList',component.get('v.accVisitList'));  
        }
    },
    
    filterAccidents :  function(component, event, helper){
        let searchKey=component.get('v.searchText');
        
        if(searchKey.length>2){
            let data = component.get('v.accidentsList');
            let filterData = data.filter(function(item) {
                
                return (item.Name.toLowerCase().indexOf(searchKey.toLowerCase()) !== -1)  || (item.Vehicle__r.Plate_Number__c.toLowerCase().indexOf(searchKey) !== -1);
                
            });
            component.set('v.accidentsFilterList',filterData); 
            
        }else{
            component.set('v.accidentsFilterList',component.get('v.accidentsList'));  
        }
    },
    showVehAccidentSection : function(component, event, helper){
        
        helper.resetDashBoard(component);
        component.set("v.isVehAccident", true);
    },
    
    handleTabSelect : function(component, event, helper){
        
        let selectedId = event.getParam('id');        
        
    },
    OpenFile : function(component, event, helper){
        
        var rec_id = event.currentTarget.id;
        $A.get('e.lightning:openFiles').fire({
            //Lightning Openfiles event  
            recordIds: [rec_id] //file id  	
        }); 
    },
    showNewSerReq :function(component, event, helper){
        
        component.set('v.showNewSerReqPopup',true);
    },
    closeServiceReq :function(component, event, helper){
        component.set('v.showNewSerReqPopup',false);
    },
    handleOnSubmit :function(component, event, helper){
        
        component.set("v.disableSerReqSavebtn",true);
        //event.preventDefault();
        
    },
    handleOnError: function (cmp, event, helper) {
        //  alert('handleOnError errorMessage ');
        component.set("v.disableSerReqSavebtn",false);
        var error = event.getParams();
        
        // Get the error message
        var errorMessage = event.getParam("message");
        console.log(errorMessage);
        alert('errorMessage '+errorMessage);
    },
    handleOnSuccess : function(component, event, helper) {
        
        $A.get('e.force:showToast').setParams({
            "title": "Success",
            "message": "Request has been created successfully!",
            "type": "success",
        }).fire();
        component.set('v.showNewSerReqPopup',false);
        helper.getfleetReqt(component, event, helper);
        helper.resetDashBoard(component);
        component.set("v.isServiceReq", true);
    },
    //SK
    handleOverTimeClick: function (component, event, helper) {
        helper.resetDashBoard(component); 
        component.set("v.eT_overTimeAutoLWCcomp", true);
        //var testvar = component.get("v.eT_overTimeAutoLWCcomp");
        
    },  
    handleFuelConsumptionClick: function (component, event, helper) {
        // Reset the dashboard or any related UI state
        component.set('v.showSpinner',true);
        helper.resetDashBoard(component);
        helper.healperhandleFuelConsumptionClick(component);
        
    },
    onFuelValueChangeHandler : function(component, event, helper) { 
        let type = component.find('selectionItemFuel').get('v.value');
        //alert(type);
        if(type == 'Show All'){
            component.set('v.Fuelrecords', component.get('v.Allrecords'));
        }else if (type=='Current Month'){
            component.set('v.Fuelrecords', component.get('v.CurrentMonthrecords'));
        } else if (type === 'JANUARY') {
            component.set('v.Fuelrecords', component.get('v.janMonthRecs'));
        } else if (type === 'FEBRUARY') {
            component.set('v.Fuelrecords', component.get('v.febMonthRecs'));
        } else if (type === 'MARCH') {
            component.set('v.Fuelrecords', component.get('v.marMonthRecs'));
        } else if (type === 'APRIL') {
            component.set('v.Fuelrecords', component.get('v.aprMonthRecs'));
        } else if (type === 'MAY') {
            component.set('v.Fuelrecords', component.get('v.mayMonthRecs'));
        } else if (type === 'JUNE') {
            component.set('v.Fuelrecords', component.get('v.junMonthRecs'));
        } else if (type === 'JULY') {
            component.set('v.Fuelrecords', component.get('v.julMonthRecs'));
        } else if (type === 'AUGUST') {
            component.set('v.Fuelrecords', component.get('v.augMonthRecs'));
        } else if (type === 'SEPTEMBER') {
            component.set('v.Fuelrecords', component.get('v.sepMonthRecs'));
        } else if (type === 'OCTOBER') {
            component.set('v.Fuelrecords', component.get('v.octMonthRecs'));
        } else if (type === 'NOVEMBER') {
            component.set('v.Fuelrecords', component.get('v.novMonthRecs'));
        } else if (type === 'DECEMBER') {
            component.set('v.Fuelrecords', component.get('v.decMonthRecs'));
        }
        
        
    },
})
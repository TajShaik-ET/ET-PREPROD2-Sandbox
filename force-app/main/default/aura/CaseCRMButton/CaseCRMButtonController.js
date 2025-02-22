({
    toggle: function (component, event, helper) {
        
        var sel = component.find("mySelect");
        var nav = sel.get("v.value");
        console.log('----->'+nav);
        if (nav ==="Invoice") {
            console.log('--->inside invoice');	
            component.set("v.Invoices", true);
            
            
        }else if(nav ==="Assigned Vehicle"){
            component.set("v.Invoices", false);
            component.set("v.AssignedResource", false);
            component.set("v.AssignedVehicle", true);
            component.set("v.SalesAggrement", false);
            component.set("v.AssignedStud", false);
            
        }else if(nav == "Assigned Resource"){
            component.set("v.Invoices", false);
            component.set("v.AssignedResource", true);
            component.set("v.AssignedVehicle", false);
            component.set("v.SalesAggrement", false);
            component.set("v.AssignedStud", false);
            
        }
            else if(nav == "Students"){
                component.set("v.Invoices", false);
                component.set("v.AssignedResource", false);
                component.set("v.AssignedVehicle", false);
                component.set("v.SalesAggrement", false);
                component.set("v.AssignedStud", true);
                
            }
                else if(nav == "Sales Agreement"){
                    console.log('---->inside sales aggrment');
                    component.set("v.Invoices", false);
                    component.set("v.AssignedResource", false);
                    component.set("v.AssignedVehicle", false);
                    component.set("v.SalesAggrement", true);
                    component.set("v.AssignedStud", false);
                    
                }
                    else if(nav == "Others"){
                        console.log('---->inside others');
                        component.set("v.Invoices", false);
                        component.set("v.AssignedResource", false);
                        component.set("v.AssignedVehicle", false);
                        component.set("v.SalesAggrement", false);
                        component.set("v.Others", true);
                        component.set("v.AssignedStud", false);
                        
                    }
        
    },
    doInit : function(component, event, helper){
        
        var recId=component.get("v.recordId");
      //  component.set("v.casebusinessType" ,"Traffic Fine");
        console.log('&&&&&INSIDEMAIN'+recId); 
          
        if(recId.startsWith('a1Z')){
            component.find("mySelect").set("v.value", 'Assigned Resource');
            console.log('-------->InsideResource');
            component.set("v.AssignedResource", true);
            component.set("v.recType", 'Assigned Resource'); 
        }
        else if(recId.startsWith('001')){
            console.log('#####Inside Account#');
            component.set("v.recType",'Account'); 
            component.set("v.AccountRec", true);
        }
            else if(recId.startsWith('a1a')){
                component.find("mySelect").set("v.value", 'Assigned Vehicle');
                component.set("v.AssignedVehicle", true);
                component.set("v.recType", 'Assigned Vehicle'); 
            }
                else if(recId.startsWith('a1W')){
                    component.find("mySelect").set("v.value", 'Sales Agreement');
                    console.log('^^^^^^');
                    component.set("v.SalesAggrement", true);
                    component.set("v.recType", 'Sales Aggrement');   
                }
                    else if(recId.startsWith('a1Y')){
                        component.find("mySelect").set("v.value", 'Invoice');
                        component.set("v.Invoices", true);
                        component.set("v.recType", 'Invoices');
                    }
                        else if(recId.startsWith('a1R')){
                            component.find("mySelect").set("v.value", 'Students');
                            component.set("v.AssignedStud", true);
                            component.set("v.recType", 'Assigned Student');
                        }
        var action = component.get('c.getUserAccountDetailsCRM');
        action.setParams({ 
            currentId : recId,
            Type:component.get("v.recType")
        });
        action.setCallback(this, function(response) {
            //store state of response
            var result = response.getReturnValue();
            var state = response.getState();
            if (state === "SUCCESS") {
                //set response value in wrapperList attribute on component.
                console.log('result***'+result);
                console.log('accRecord***'+result.accRecord);
                console.log('vehicleRecord***'+result.vehicleRecord);
                console.log('salesRecord***'+result.salesRecord);
                console.log('accountSite***'+result.accountSite);
                component.set('v.AccountId', result.accRecord);
                component.set('v.asvehicleId', result.vehicleRecord);
                component.set('v.salesAggId', result.salesRecord);
                component.set('v.accountSiteId', result.accountSite);
                component.set('v.caseSource', result.caseSource);
                component.set('v.currentUserprofile', result.profilename);
                
            }
        });
        $A.enqueueAction(action);
        helper.getRecordTypes(component,event,helper);
    },
    optionSelected : function(component,event,helper){
        console.log('insideselected$$'+component.find("value"));
        var fNameCmp = component.find("value");
       
        var recordName = fNameCmp.get("v.value");
        component.set("v.selectedRecordtype",recordName);
         
        var recordTypes = component.get("v.availableRecordTypes");
        //  console.log('$$$$$$$$$selected$$'+recordName);
        for(var i=0;i<recordTypes.length;i++){
            //    console.log('$$$$$$$$$selected2$$'+recordTypes[i].value);
            if(recordName===recordTypes[i].value){	
                console.log('found match'+recordTypes[i].key);
                component.set("v.recordTypeIdvar",recordTypes[i].key);
                
                break;
            }
        }
    },
    optionbtype : function(component,event,helper){
        console.log('insideselected$$'+component.find("value"));
        var fNameCmp = component.find("value");
        var btype = component.find("businesstyp");
        console.log('#######@@'+btype);
        var btypeName = btype.get("v.value");
        console.log('#######@@'+btypeName);
        component.set("v.casebusinessType" ,btypeName);
        if(!$A.util.isEmpty(btypeName)){
            var recordName = fNameCmp.get("v.value") +' - '+btypeName;
        } 
        var recordTypes = component.get("v.availableRecordTypes");        
        //  console.log('$$$$$$$$$selected$$'+recordName);
        for(var i=0;i<recordTypes.length;i++){
            //   console.log('$$$$$$$$$selected2$$'+recordTypes[i].value);
            if(recordName===recordTypes[i].value){	
                console.log('found match'+recordTypes[i].key);
                component.set("v.recordTypeIdvar",recordTypes[i].key);
                break;
            }
        }
    },
    handleOnLoad : function(component, event, helper) {
        //  console.log('###########InsideRecID#');
        var recId=component.get("v.recordId");
        // console.log('###########InsideRecID#');  
        var caseSource = component.get("v.caseSource");
        console.log('############'+recId);
        if(recId.startsWith('a1Z')){
            component.find("assResId").set("v.value", recId);
            component.find("caseSource").set("v.value", caseSource);}
        else if(recId.startsWith('a1a')){
            component.find("assVehId").set("v.value", recId);
            component.find("caseSource").set("v.value", caseSource);
        }
            else if(recId.startsWith('a1W')){
                component.find("SaleAggId").set("v.value", recId);
                component.find("caseSource").set("v.value", caseSource);
            }
                else if(recId.startsWith('a1Y')){
                    component.find("InvoiceId").set("v.value", recId);
                    component.find("caseSource").set("v.value", caseSource);
                }
                    else if(recId.startsWith('a1R')){
                        component.find("assStudId").set("v.value", recId);
                        component.find("caseSource").set("v.value", caseSource);
                    }
                        else if(recId.startsWith('001')){
                            component.find("AccId").set("v.value", recId);
                            component.find("caseSource").set("v.value", caseSource);
                        }
    },
    handleOnSuccess : function(component, event, helper) {
        var payload = event.getParams().response;
        console.log('-----@@@inside success');
        $A.get("e.force:closeQuickAction").fire();
        $A.get('e.force:showToast').setParams({
            "title": "Success",
            "message": "Record has been saved!",
            "type": "success",
        }).fire();
        var navEvt = $A.get("e.force:navigateToSObject");
        navEvt.setParams({
            "recordId": payload.id,
            "slideDevName": "detail"
        });
        navEvt.fire();
    },
    
    handleOnSubmit : function(component, event, helper) {
        debugger;
      
        var hasError = false;
        console.log('-------inside submit');
        event.preventDefault(); //Prevent default submit 
       
        var eventFields = event.getParam("fields");
        
        console.log('-------inside recordtype@'+ component.get("v.recordTypeIdvar"));//get the fields
        eventFields["Status"] = 'New'; //Add Description field Value
       
        console.log('-------inside submit');
        console.log('-------inside submit2--'+component.get("v.AccountId"));
        
        if(component.get("v.AccountId")!=undefined){
            eventFields["AccountId"]=component.get("v.AccountId");
        }
        
        console.log('-------inside submit3'+component.get("v.salesAggId"));
        if(component.get("v.salesAggId")!=undefined){
            eventFields["Sales_Agreement__c"]=component.get("v.salesAggId");
        }

        console.log('-------inside submit4'+component.get("v.asvehicleId"));
        if(component.get("v.asvehicleId")!=undefined){
            eventFields["Assigned_Vehicle__c"]=component.get("v.asvehicleId");
        }

        console.log('-------inside submit5');
        console.log('-------accountSiteId----'+component.get("v.accountSiteId"));
        if(component.get("v.accountSiteId")!=undefined){
            eventFields["Account_Site__c"] = component.get("v.accountSiteId");
        }
     
        const username = component.get('v.CurrentUser')['Profile'].Name;
        console.log('username '+username);
       // var userprofilename=username;
       // component.set("v.profilename",userprofilename );
       /* traffic fine code starts here */
       
       var slectedRecordtype =  component.get("v.selectedRecordtype");
        
        
        if((slectedRecordtype=="ET Tyre")&&(username == 'ETT_Receptionist'||username == 'System Administrator'||username =='ETT_Sales Team'))
        {
           var trafficDate=component.find("TrafficDateId").get("v.value");
      //  var trafficDate=component.get("v.TrafficDateId");
      //  alert('trafficDate'+trafficDate);
        var today = $A.localizationService.formatDate(new Date(), "YYYY-MM-DD");
      //  alert('today'+today);
        var tyreFine=component.find("TyreFineId").get("v.value");
       // var tyreFine=component.get("v.TyreFineId");
       // alert('tyreFine'+tyreFine);
        
        var traffictotalFine=component.find("TrafficFineTotalId").get("v.value");
       // var traffictotalFine=component.get("v.TrafficFineTotalId");
        //alert('traffictotalFine'+traffictotalFine);  
        
        if(tyreFine<0){
            alert('Please enter positive value for Tyre Fine Amount');
             hasError = true;
        }
        if(traffictotalFine<0){
            alert('Please enter positive value for Traffic fine total Amount');
             hasError = true;
        }
        
   
            if(trafficDate>today)
        {
            alert('Traffic Fine date cannot be Future Date');
            hasError = true;
        }
        
        if(Number(tyreFine) > Number(traffictotalFine))
        {
            alert('Tyre Fine amount should be less than or equal to Traffic Fine total amount');
            hasError = true;
        }
         /* traffic fine code ends here */
        
       }
       
        
        if(!hasError){
            component.find('caseForm').submit(eventFields); //Submit Form
        }  
    },
    handleOnError : function(component, event, helper){
        console.log('--inside error---'+JSON.stringify(event.error));
    },
    cancelPage : function(component, event, helper){
        var dismissActionPanel = $A.get("e.force:closeQuickAction");
        dismissActionPanel.fire();
        
    }
    
    
})
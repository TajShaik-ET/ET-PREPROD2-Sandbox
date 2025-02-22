({
    doInit : function(component, event, helper) {
        debugger;
        helper.fetchCustomerQuoteLineItems(component, event, helper);
        helper.fetchSalesAgreementTypes(component, event, helper);       
    },
    
    addNewLine : function(component, event, helper){ 
        var targetedLine = event.target.getAttribute("id");
        console.log('-----targetedLine-----'+targetedLine);
        let contractLineList = component.get("v.contractLineList"); 
        if(contractLineList != undefined){
            let targetedLineItem = contractLineList[targetedLine];  
            var LineObj = new Object();
            LineObj.sobjectType = targetedLineItem.sobjectType;
            LineObj.ETSALES_Quote__c = targetedLineItem.ETSALES_Quote__c;
            LineObj.Sales_Agreement__c = targetedLineItem.Sales_Agreement__c;
            LineObj.Item__c = targetedLineItem.Item__c;
            LineObj.ItemDesc = targetedLineItem.ItemDesc;
            LineObj.serviceCode = targetedLineItem.serviceCode;
            LineObj.No_Of_Days__c = targetedLineItem.No_Of_Days__c;
            LineObj.taxRate = targetedLineItem.taxRate;
            LineObj.taxCode = targetedLineItem.taxCode;
            LineObj.totalAmount = targetedLineItem.totalAmount;
            LineObj.Contract_Start_Date__c = targetedLineItem.Contract_Start_Date__c;
            LineObj.Contract_End_Date__c = targetedLineItem.Contract_End_Date__c;
            LineObj.Effective_Date__c = targetedLineItem.Effective_Date__c;
            LineObj.Saturday__c = targetedLineItem.Saturday__c;
            LineObj.Sunday__c = targetedLineItem.Sunday__c;
            LineObj.Monday__c = targetedLineItem.Monday__c;
            LineObj.Tuesday__c = targetedLineItem.Tuesday__c;
            LineObj.Wednesday__c = targetedLineItem.Wednesday__c;
            LineObj.Thursday__c = targetedLineItem.Thursday__c;
            LineObj.Friday__c = targetedLineItem.Friday__c;
            LineObj.Route__c = targetedLineItem.Route__c;
            LineObj.Option__c = targetedLineItem.Option__c;
            LineObj.Service_Type__c = targetedLineItem.Service_Type__c;
            LineObj.No_of_Vehicles_Employee__c = targetedLineItem.No_of_Vehicles_Employee__c;
            LineObj.Rate_Type__c = targetedLineItem.Rate_Type__c;
            LineObj.Amount_Calcualted__c = targetedLineItem.Amount_Calcualted__c;
            LineObj.Rate_Day__c = targetedLineItem.Rate_Day__c;
            LineObj.Hours_per_Day__c = targetedLineItem.Hours_per_Day__c;
            LineObj.KM_per_Day__c = targetedLineItem.KM_per_Day__c;
            LineObj.Excess_Km__c = targetedLineItem.Excess_Km__c;
            LineObj.Excess_Hours__c = targetedLineItem.Excess_Hours__c;
            LineObj.Allow_Secondary__c = targetedLineItem.Allow_Secondary__c;
            LineObj.Driver_Count__c = targetedLineItem.Driver_Count__c;
            LineObj.Tax_Amount__c = targetedLineItem.Tax_Amount__c;
            LineObj.Line_Amount__c = targetedLineItem.Line_Amount__c;
            LineObj.Fuel_Collection_Basis__c = targetedLineItem.Fuel_Collection_Basis__c;
            LineObj.Toll_Included__c = targetedLineItem.Toll_Included__c;
            LineObj.Fuel_Included__c = targetedLineItem.Fuel_Included__c;
            LineObj.Toll_Collection_Basis__c = targetedLineItem.Toll_Collection_Basis__c;
            LineObj.Toll_Collection_Fee__c = targetedLineItem.Toll_Collection_Fee__c;
            LineObj.Traffic_Fine__c = targetedLineItem.Traffic_Fine__c;
            LineObj.Remarks__c = targetedLineItem.Remarks__c;
            LineObj.Vehicle_Description__c = targetedLineItem.Vehicle_Description__c;
            LineObj.Line_Number__c = contractLineList.length+1;
            contractLineList.push(LineObj);
        }       
        component.set("v.contractLineList",JSON.parse(JSON.stringify(contractLineList)));
    },
    
    //populate start and end date fields of line items
    onForceLoad : function(component, event, helper) {
        let data = component.get('v.record');
        if(data){
            if(data.Opportunity_Name__r.Contract_Start_Date__c != undefined && data.Opportunity_Name__r.Contract_End_Date__c != undefined){
                let conLines = component.get("v.contractLineList");
                let stDate =$A.localizationService.formatDateTimeUTC(new Date(data.Opportunity_Name__r.Contract_Start_Date__c+'T00:00:00Z'),'YYYY-MM-DDTHH:mm:ss.SSSZ');     
                let enDate =$A.localizationService.formatDateTimeUTC(new Date(data.Opportunity_Name__r.Contract_End_Date__c+'T23:59:00Z'),'YYYY-MM-DDTHH:mm:ss.SSSZ');
                conLines.forEach(conLine => {
                    conLine.Contract_Start_Date__c = stDate; //Setting 00:00
                    conLine.Contract_End_Date__c = enDate;//Setting 23:59
                    conLine.Effective_Date__c = stDate;
                    conLine.No_Of_Days__c=helper.calculateDays(stDate,enDate);
                });

                component.set("v.contractLineList",conLines);
            }
        }
    },   
    
    removeLine : function(component, event, helper){ 
        // console.log('---removeLine1--'+event.target.value);
        // var whichOne = event.target.getAttribute("id");
        var lineId = event.target.getAttribute("id");
        // console.log('---removeLine2--'+whichOne);
        // var index = event.getSource().get('v.value');
        console.log('---removeLine3--'+lineId);
        let contractLineList = component.get("v.contractLineList");

        // var arrayIndex = contractLineList.findIndex(x => x.Line_Number__c === lineId);
        // contractLineList.splice(arrayIndex, 1);
        contractLineList.splice(lineId, 1);
        // var newArray = contractLineList.slice(1, 1);
        // contractLineList[whichOne] = undefined;
        component.set("v.contractLineList", JSON.parse(JSON.stringify(contractLineList)));
        var AllRowsList1 = component.get("v.contractLineList");
        console.log('---AllRowsList1--'+AllRowsList1);
    },
    
    handleSave: function(component, event, helper){ 
        
        component.set("v.showSpinner",true);        
        component.find("conForm").submit();   
        
    },
    
    autoFillDataHandler : function(component, event, helper){         
        let params = event.getParam('arguments');
        if (params) {
            let index = params.index;
            console.log('----params.index----'+params.index);
            let recData =params.recordData;
            let identifier =params.identifier;            
            let data = component.get("v.contractLineList");
            if(data){               
                if(identifier =='Item__c'){
                    data[index].ItemDesc=recData[0].Item_Description__c;
                    component.set("v.contractLineList",data);
                }
                if(identifier == 'Service_Type__c'){
                    
                    data[index].serviceCode=recData[0].Service_Code__c;
                    data[index].taxCode=recData[0].Tax_Code__c;
                    data[index].taxRate=recData[0].Tax_Rate__c;
                    data[index].Tax_Amount__c=(recData[0].Tax_Rate__c* data[index].Line_Amount__c)/100;
                    data[index].totalAmount = data[index].Tax_Amount__c+data[index].Line_Amount__c;
                    component.set("v.contractLineList",data);
                    
                }                
            }
            
        }
    },
    contractDateHandler :  function(component, event, helper){
        
        let index = event.getSource().get('v.name');
        let value = event.getSource().get('v.value');
        let fieldName = event.getSource().getLocalId();
        let conLine = component.get("v.contractLineList");
        
        if(fieldName == 'Contract_Start_Date__c'){
            conLine[index].No_Of_Days__c= helper.calculateDays(value,conLine[index].Contract_End_Date__c);
            conLine[index].Effective_Date__c=value;
            conLine[index].Line_Amount__c = conLine[index].Rate_Day__c *conLine[index].No_Of_Days__c*conLine[index].No_of_Vehicles_Employee__c ;
            conLine[index].Tax_Amount__c=(conLine[index].taxRate* conLine[index].Line_Amount__c)/100;
            conLine[index].totalAmount=conLine[index].Tax_Amount__c+conLine[index].Line_Amount__c;
        }
        if(fieldName == 'Contract_End_Date__c'){
            conLine[index].No_Of_Days__c= helper.calculateDays(conLine[index].Contract_Start_Date__c,value);
            conLine[index].Line_Amount__c = conLine[index].Rate_Day__c *conLine[index].No_Of_Days__c*conLine[index].No_of_Vehicles_Employee__c ;
            conLine[index].Tax_Amount__c=(conLine[index].taxRate* conLine[index].Line_Amount__c)/100;
            conLine[index].totalAmount=conLine[index].Tax_Amount__c+conLine[index].Line_Amount__c;
            
        }
        component.set("v.contractLineList",conLine);
        
    },
    amountChangeHandler : function(component, event, helper){
        console.log('-amountChangeHandler--');
        let index = event.getSource().get('v.name');
        let value = event.getSource().get('v.value');
        let conLine = component.get("v.contractLineList");
        conLine[index].Rate_Day__c = helper.rateCalculator(conLine[index].Rate_Type__c,value,conLine[index].No_Of_Days__c);
        conLine[index].Line_Amount__c = conLine[index].Rate_Day__c *conLine[index].No_Of_Days__c*conLine[index].No_of_Vehicles_Employee__c ;
        conLine[index].Tax_Amount__c=(conLine[index].taxRate* conLine[index].Line_Amount__c)/100;
        component.set("v.contractLineList",conLine);
        
    },
    rateChangeHandler :function(component, event, helper){
        let index = event.getSource().get('v.name');
        let value = event.getSource().get('v.value');
        
        let conLine = component.get("v.contractLineList");
        conLine[index].Rate_Day__c = helper.rateCalculator(value,conLine[index].Amount_Calcualted__c,conLine[index].No_Of_Days__c);
        conLine[index].Line_Amount__c = conLine[index].Rate_Day__c*conLine[index].No_of_Vehicles_Employee__c*conLine[index].No_Of_Days__c;
        conLine[index].Tax_Amount__c=(conLine[index].taxRate* conLine[index].Line_Amount__c)/100;
        conLine[index].totalAmount=conLine[index].Tax_Amount__c+conLine[index].Line_Amount__c;
        
        component.set("v.contractLineList",conLine);
        
    },
    noOfVehEmpChangeHandler : function(component, event, helper){
        let index = event.getSource().get('v.name');
        let value = event.getSource().get('v.value');
        
        let conLine = component.get("v.contractLineList");
        conLine[index].Line_Amount__c = conLine[index].Rate_Day__c*value*conLine[index].No_Of_Days__c;
        conLine[index].Tax_Amount__c=(conLine[index].taxRate* conLine[index].Line_Amount__c)/100;
        conLine[index].totalAmount=conLine[index].Tax_Amount__c+conLine[index].Line_Amount__c;
        
        component.set("v.contractLineList",conLine);
        
    },
    
    dayCheckHandler :function(component, event, helper){
        
        let value = event.getSource().get('v.checked');
        let index = event.getSource().get('v.name');
        let fieldName = event.target.closest('[data-name]').dataset.name;
        let conLine = component.get("v.contractLineList");
        
        let count = helper.calculateDaysWithOutSelectedDay(component,parseInt(fieldName),index);
        if(value){            
            conLine[index].No_Of_Days__c= conLine[index].No_Of_Days__c+count;
            
        }else{
            conLine[index].No_Of_Days__c= conLine[index].No_Of_Days__c-count;
        }
        
        component.set("v.contractLineList",conLine);
    },
    
    OnCancel : function(component, event, helper){
        
        $A.get("e.force:closeQuickAction").fire();
    },  
    handleOnError : function(component, event, helper) {
        alert(error);
        console.log('error')
    },
    
    handleOnSuccess :function(component, event, helper) {
        
        var record = event.getParam("response");
        console.log('--handleOnSuccess--record---'+record);
        console.log(record);   
        var recordId = record.id; 
        component.set("v.salesAgreementId",recordId);
        let data  = component.get("v.contractLineList"); 
        component.set("v.tempLineList",data);
        data.forEach(con => {con.Sales_Agreement__c=recordId;
                             delete con.ItemDesc;
                             delete con.serviceCode; delete con.taxRate; delete con.taxCode;delete con.totalAmount;});
                             //console.log(data);    
        var action = component.get('c.createContractLines');                
        action.setParams({
            contractLines : data      
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            
            if (state === "SUCCESS") {  
                component.set("v.showSpinner",false);
                let data = response.getReturnValue();
                console.log('--handleOnSuccess--response--');
                console.log(response);
                helper.sendContractToERPHandler(component, event, helper);
                var toastReference = $A.get("e.force:showToast");
                toastReference.setParams({
                    "type":"Success",
                    "title":"Success",
                    "message":"Sales Agreements has been created successfully.",
                    "mode":"dismissible"
                });
                toastReference.fire();
                $A.get("e.force:closeQuickAction").fire();
            }
            else if (state === "ERROR") {
                component.set("v.showSpinner",false);
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error message: " + errors[0].message);
                        var toastReference = $A.get("e.force:showToast");
                        toastReference.setParams({
                            "type":"Error",
                            "title":"Error",
                            "message":"Please check with Admin-"+errors[0].message,
                            "mode":"dismissible"
                        });
                        toastReference.fire();
                        
                    }
                } else {
                    console.log("Unknown error");
                    
                }
            }
            
        }); 
        
        $A.enqueueAction(action);
        
    },
    
    handleOnLoad :function(component, event, helper) {    
        
    },
    
    handleOnSubmit  :function(component, event, helper) {
        console.log('--handleOnSubmit--');
    },
    
})
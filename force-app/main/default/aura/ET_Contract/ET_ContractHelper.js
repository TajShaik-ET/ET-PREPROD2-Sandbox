({
    
    calculateDays :  function(startDate,endDate){
        let difference = new Date(endDate) - new Date(startDate);
        let TotalDays = Math.ceil(difference / (1000 * 3600 * 24));
        return TotalDays;
    },
    
    calculateDaysWithOutSelectedDay :function(component,day,index){
        
        let conLine = component.get("v.contractLineList");
        let sdate = new Date($A.localizationService.formatDateTimeUTC(conLine[index].Contract_Start_Date__c));
        let fdate =new Date($A.localizationService.formatDateTimeUTC(conLine[index].Contract_End_Date__c));    
        let count =0;        
        let TotalDays = Math.ceil((fdate-sdate) / (1000 * 3600 * 24));
        let temp = sdate;      
        for(let i=0;i < TotalDays; i++){   
            if(temp.getDay() == day){
                count++;
            }
            temp.setDate(temp.getDate() + 1);
            
        }      
        
        return count;
        
    },
    
    rateCalculator : function(value,amount,noOfDays){
        
        if(value == '10')//Rate/Month-30 Days
            return amount/30;
        else if(value =='20') //Rate/Month-Actual
            return amount/noOfDays;
            else if(value == '30') //Rate/Year
                return (amount/12)/30;
                else if(value == '40') //Rate/Year total
                    return (amount/365);
                    else if(value == '50') //Manual
                        return (amount/noOfDays);
    },
    
    sendContractToERPHandler :function(component, event, helper) {
        
        var action = component.get('c.sendSalesAgreementToERP');               
        action.setParams({
            saId : component.get('v.salesAgreementId')      
        });
        
        action.setCallback(this, function(response) {
            var state = response.getState();
            
            if (state === "SUCCESS") {  
                component.set("v.showSpinner",false);
                let data = response.getReturnValue()
                console.log(data);
                if(data){
                    if(data.StatusFlag=='S'){
                        var toastReference = $A.get("e.force:showToast");
                        toastReference.setParams({
                            "type":"Success",
                            "title":"Success",
                            "message":"Contract has been created successfully in ERP -"+data.ContractNumber,
                            "mode":"dismissible"
                        });
                        toastReference.fire();
                        $A.get("e.force:closeQuickAction").fire();
                    }else{
                        var toastReference = $A.get("e.force:showToast");
                        toastReference.setParams({
                            "type":"Error",
                            "title":"Error",
                            "message":data.ErrorMsg,
                            "mode":"dismissible"
                        });
                        toastReference.fire();
                        component.set('v.contractLineList',component.get('v.tempLineList'));
                        
                        helper.removeSalesAggrement(component, event, helper);
                    }
                }
                
            }
            else if (state === "ERROR") {
                component.set("v.showSpinner",false);
                helper.removeSalesAggrement(component, event, helper);
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error message: " + errors[0].message);
                        var toastReference = $A.get("e.force:showToast");
                        toastReference.setParams({
                            "type":"Error",
                            "title":"Error",
                            "message":errors[0].message,
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
    
    removeSalesAggrement : function(component, event, helper) {
        
        var action = component.get('c.deleteSalesAggmnt');                
        action.setParams({
            recordId : component.get('v.tempContractId')      
        });
        
        action.setCallback(this, function(response) {
            var state = response.getState();
            
            if (state === "SUCCESS") {  
                
                
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
    
    fetchCustomerQuoteLineItems : function(component, event, helper) {
        var action = component.get('c.fetchCustomerQuoteLineItem');                
        action.setParams({
            cqId : component.get('v.recordId')      
        });
        
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {  
                let data =  response.getReturnValue();  
                console.log(data);
                component.set('v.customerVQIList', data);
                helper.populateDefaultsLines(component, event, helper);
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
    populateDefaultsLines : function(component, event, helper) {
        
        var customerVQIList = component.get("v.customerVQIList");
        console.log('----customerVQIList---');
        let contractLineList = component.get("v.contractLineList");
        for (let i = 0; i < customerVQIList.length; i++) {
            var LineObj = new Object();
            LineObj.Line_Number__c = i;
            LineObj.sobjectType = 'ET_Sales_Agreement_Sub_Line_Item__c';
            LineObj.ETSALES_Quote__c= component.get("v.recordId");
            LineObj.Sales_Agreement__c='';
            LineObj.Item__c='';
            LineObj.ItemDesc='';
            LineObj.serviceCode='';
            LineObj.taxRate='';
            LineObj.taxCode='';
            LineObj.No_Of_Days__c=0;
            LineObj.totalAmount=0;
            LineObj.Contract_Start_Date__c='';
            LineObj.Contract_End_Date__c='';
            LineObj.Effective_Date__c='';
            LineObj.Saturday__c= true;
            LineObj.Sunday__c= true;
            LineObj.Monday__c= true;
            LineObj.Tuesday__c= true;
            LineObj.Wednesday__c= true;
            LineObj.Thursday__c= true;
            LineObj.Friday__c= true;
            LineObj.No_of_Vehicles_Employee__c=0;
            LineObj.Rate_Type__c='10';
            LineObj.Amount_Calcualted__c=0;
            LineObj.Rate_Day__c= 0;
            LineObj.Route__c='';
            LineObj.Option__c='';
            LineObj.Service_Type__c='';
            LineObj.Hours_per_Day__c= 0;
            LineObj.KM_per_Day__c= 0;
            LineObj.Excess_Km__c= 0;
            LineObj.Excess_Hours__c= 0;
            LineObj.Allow_Secondary__c= false;
            LineObj.Driver_Count__c=0;
            LineObj.Tax_Amount__c=0;
            LineObj.Line_Amount__c=0;
            LineObj.Fuel_Collection_Basis__c='';
            LineObj.Toll_Included__c='No';
            LineObj.Fuel_Included__c='No';
            LineObj.Toll_Collection_Basis__c='';
            LineObj.Toll_Collection_Fee__c=0;
            LineObj.Traffic_Fine__c=0;
            LineObj.Remarks__c='';
            
            LineObj.Vehicle_Description__c = customerVQIList[i];
            
            contractLineList.push(LineObj);     
        }
        component.set("v.contractLineList",contractLineList);

    },

    fetchSalesAgreementTypes: function(component, event, helper){
        var action = component.get('c.fetchSalesAgreementTypes');                
        action.setParams({
            cqId : component.get('v.recordId')      
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {  
                let data =  response.getReturnValue();
                console.log(data);
                component.set('v.agreementTypeList', data);
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
    }
})
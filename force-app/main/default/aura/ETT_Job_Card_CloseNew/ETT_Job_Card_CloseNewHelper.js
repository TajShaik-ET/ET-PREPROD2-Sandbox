({
    getJobTypeHelper : function(component, event, helper){
        var action = component.get('c.getJobTypeValue');
        action.setParams({
            insCardId:component.get("v.jobCardInfo").ETT_Inspection_Card__c.toString()
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {  
                let data = response.getReturnValue();
                component.set("v.jobType",data);
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
    
    fetchEmployees: function(component, processName) {
        var action = component.get("c.getEmployeesByProcess");
        action.setParams({
            processName: processName
           
        });
        
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                // Handle the successful response from Apex
                var employees = response.getReturnValue();
                component.set("v.employeeList", employees);
                console.log('First Retrieved Employee: ' + JSON.stringify(employees));
                
            } else if (state === "ERROR") {
                // Handle any errors that occurred during the call
                var errors = response.getError();
                console.error("Error in fetching employees: ", errors);
            }
        });
        
        $A.enqueueAction(action);
    },
    
   /*
    fetchEmployees: function(component, processName) {
        debugger;
        var action = component.get("c.getEmployeesByProcess");
        action.setParams({
            processName: processName
        });
        
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                // Handle the successful response from Apex
                var employees = response.getReturnValue();
                component.set("v.employeeList", employees);
    
                // Initialize start and end times
                var startTime = null;
                var endTime = null;
    
                // Iterate over employees to find start and end times
                if (employees && employees.length > 0) {
                    // Assuming you want the times from the first employee, adjust as needed
                    startTime = employees[0].ETT_Start_time__c;
                    endTime = employees[0].ETT_End_time__c;
    
                    // Convert to Date objects
                    var endDateObj = new Date(endTime);
                    var startDateObj = new Date(startTime);
    
                    // Format the times
                    var options = {
                        hour: 'numeric',
                        minute: 'numeric',
                        hour12: true
                    };
                    endTime = endDateObj.toLocaleString('en-US', options);
                    startTime = startDateObj.toLocaleString('en-US', options);
                }
    
                // Set the formatted times
                component.set("v.startTime", startTime);
                component.set("v.endTime", endTime);
    
                console.log('First Retrieved Employee: ' + JSON.stringify(employees));
    
            } else if (state === "ERROR") {
                // Handle any errors that occurred during the call
                var errors = response.getError();
                console.error("Error in fetching employees: ", errors);
            }
        });
    
        $A.enqueueAction(action);
    },
    */
    fetchEmployeesUpdated: function(component, employeeId,rowIndex) {
        debugger;
        var action = component.get("c.getEmployeesByProcessUpdated");
        action.setParams({
            employeeId: employeeId ? employeeId.toString() : ''
        });
        
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
               
                // Handle the successful response from Apex
                var updatedEmployee  = response.getReturnValue();
                
                console.log('SQRQZ'+JSON.stringify(updatedEmployee));

                var employeeList = component.get("v.employeeList");

                // Update the specific employee in the list
                if (employeeList && employeeList.length > rowIndex) {
                    
                    employeeList[rowIndex].Tyre_Employee_Master__r = updatedEmployee[0]; 
                    component.set("v.employeeList", employeeList);

                }
              //  component.set('v.newJobCardCloseEmployees',employeeList);
                console.log(JSON.stringify(employeeList));
               // component.set("v.employeeList", employees);
            } else if (state === "ERROR") {
                // Handle any errors that occurred during the call
                var errors = response.getError();
                console.error("Error in fetching employees: ", errors);
            }
        });
        
        $A.enqueueAction(action);
    },
    
    getPicklistValueHelper :function(component, event, helper) {
        
        var action = component.get('c.getselectOptions');
        
        action.setParams({
            objObject:'ETT_Job_Card_Close_Lines__c',
            fld:'Job_Type__c'
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            
            if (state === "SUCCESS") {  
                
                let data = response.getReturnValue();
                var items = [];
                data.forEach(function(val){
                    var item = {
                        "label":val,
                        "value": val.toString()
                    };
                    items.push(item);
                });
                console.log('items '+items);
                component.set("v.options",items);
                //let processOptions = component.get("v.options");
                console.log('items value '+JSON.stringify(items));
                let jccEmployees = component.get("v.newJobCardCloseEmployees");
                let jccLines = component.get("v.newJobCardCloseLines");
                if(items){
                    console.log('items length '+items.length);
                    for(var i=0; i<items.length; i++){
                        console.log('item '+JSON.stringify(items[i]));
                        for(var j=0; j<1; j++){
                            let JClines = new Object();
                            JClines.sobjectType = 'ETT_JCC_Employee__c';
                            JClines.ETT_Emp_No__c = null;
                            JClines.ETT_Employee_Name__c = '';
                            JClines.ETT_Working_Date__c = null;
                            JClines.ETT_Start_Time__c = null;
                            JClines.ETT_End_Time__c =  null;
                            JClines.ETT_Job_Type__c = items[i].value;
                            jccEmployees.push(JClines);
                        }
                        
                        for(var j=0; j<5; j++){
                            let JClines = new Object();
                            JClines.sobjectType = 'ETT_Job_Card_Close_Lines__c';
                            JClines.Item_Name__c = '';
                            JClines.Issued_Quantity__c = null;
                            JClines.Job_Type__c = items[i].value;
                            //JClines.Unit_Cost__c = null;
                            //JClines.Cost__c = null;
                            JClines.UOM__c = null;
                            JClines.Available_Quantity__c = null;
                            //JClines.ETT_Unique_Code__c = null;
                            JClines.ETT_Item_Description__c = null;
                            jccLines.push(JClines);
                        }
                    }
                }
                
                console.log('jccLines length '+jccLines.length);
                component.set("v.newJobCardCloseEmployees",jccEmployees);
                component.set("v.newJobCardCloseLines",jccLines);
                
                //console.log(data)
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
    getAllUsedItemsHelper :function(component, event, helper) {
        
        var action = component.get('c.getAllUsedItems');
        
        action.setParams({
            JobCardId:component.get("v.jobCardId").toString()
            
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            
            if (state === "SUCCESS") {  
                
                let data = response.getReturnValue();
                component.set("v.allItemsList",data);
                console.log(data)
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
    showToastMsg :function(Type,Title,Msg) {
        
        var toastReference = $A.get("e.force:showToast");
        toastReference.setParams({
            "type":Type,
            "title":Title,
            "message":Msg,
            "mode":"dismissible"
        });
        toastReference.fire();
    },
    createJCcloseLinesUnderJCHelper : function(component, event, helper) {
        
        var params = event.getParams();        
        let jobCardCloseId = params.response.id;
        
        if(jobCardCloseId != null){
            var jobCardInfo = component.get("v.jobCardInfo");
            /*component.set("v.initialRemark", "");
            component.set("v.initialLife", "");*/
            jobCardInfo.Buffing_Tyre_Interior_Cuts__c = component.set("v.initialCut");
            jobCardInfo.Buffing_Cuts_Count__c = component.set("v.initialSideCut");
            jobCardInfo.Buff_Crown_Area_0_10mm_Cuts__c = component.get("v.initialCrownCut");
            jobCardInfo.ETT_Skiving_Technician_Rejection_Remarks__c = component.get("v.skivingRemark");
            jobCardInfo.ETT_Repair_Technician_Rejection_Remarks__c = component.get("v.repairRemark");
            jobCardInfo.ETT_Building_Technician_Reject_Remarks__c = component.get("v.buildingRemark");
            jobCardInfo.ETT_Buffing_Technician_Rejection_Remarks__c = component.get("v.buffingRemark");
            jobCardInfo.ETT_Tread_Width__c  = component.get("v.buffingWidth");
            jobCardInfo.ETT_Tread_Length__c  = component.get("v.buffingLength");
            jobCardInfo.ETT_Curing_Start_Time__c   = component.get("v.curingstartTime");
            jobCardInfo.ETT_Curing_Round_Number__c   = component.get("v.curingRound");
            jobCardInfo.ETT_Curing_Valve_No__c   = component.get("v.curingValue");
            jobCardInfo.ETT_Curing_End_Time__c   = component.get("v.curingendTime");
            
            
            
            jobCardInfo.ETT_Buffing_Technician_Rejection_Remarks__c = component.get("v.buffingLength");
            
            
            //component.set("v.buffingWidth", "");
            //component.set("v.buffingLength", "");
            jobCardInfo.ETT_Filling_Technician_Rejection_Remarks__c = component.get("v.filingRemark");
            jobCardInfo.ETT_Thread_Technician_Rejection_Remarks__c = component.get("v.treadRemark");
            jobCardInfo.ETT_Final_Inspection_Technician_Remarks__c = component.get("v.finalRemark");
            jobCardInfo.ETT_Final_Inspection_Technician_Remarks__c = component.get("v.curingDate");
            
            
            component.set("v.jobCardInfo", jobCardInfo);
            debugger;
        

            
           // console.log('newJobCardCloseLines==='+JSON.stringify(component.get("v.newJobCardCloseLines")))
           var action = component.get('c.createJCcloseLinesUnderJC');
            
            action.setParams({
                JCcloseLines : component.get("v.newJobCardCloseLines"),
                JCcloseEmployees : component.get("v.newJobCardCloseEmployees"),
                JCCloseId : jobCardCloseId.toString(),
                jccRejection : component.get("v.jccRejection"),
                jobCardInfo : component.get("v.jobCardInfo"),
            });
            action.setCallback(this, function(response) {
                var state = response.getState();
                
                if (state === "SUCCESS") {  
                    let data = response.getReturnValue();
                    var navEvt = $A.get("e.force:navigateToSObject");
                    navEvt.setParams({
                        "recordId": jobCardCloseId
                    });
                    navEvt.fire();
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
    },
    getEnvelopeDetails :function(component, event, helper) {
        
        var action = component.get('c.getEnvelopeInfo');
        
        action.setParams({
            jobCardId:component.get("v.jobCardId").toString()
            
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            
            if (state === "SUCCESS") {  
                
                let data = response.getReturnValue();
                component.set("v.envInfo",data);
                if(data){
                    component.set("v.curingValue", data[0].Vacuum_Valve__c);
                }
                //console.log(data)
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
    getCuringDetails :function(component, event, helper) {
        
        var action = component.get('c.getCuringInfo');
        
        action.setParams({
            jobCardId:component.get("v.jobCardId").toString()
            
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            
            if (state === "SUCCESS") {  
                alert('Cyuring info');
                let data = response.getReturnValue();
                component.set("v.curingInfo",data);
                if(data){
                    component.set("v.curingDate", data[0].ETT_Curing_Start_Time__c);
                    component.set("v.curingRound", data[0].ETT_Curing_Round_Number__c);
                }
                //console.log(data)
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
    getBuffingDetails :function(component, event, helper) {
        
        var action = component.get('c.getBuffingInfo');
        
        action.setParams({
            jobCardId:component.get("v.jobCardId").toString()
            
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            
            if (state === "SUCCESS") {  
                
                let data = response.getReturnValue();
                component.set("v.buffingInfo",data);
                //console.log(data)
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
    showErrorMessage: function(component, message) {
        component.set("v.isLoading", false);
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "type": "error",
            "message": message
        });
        toastEvent.fire();
    },

    validateFields: function(component, event, helper) {
        debugger;
        var allValid = true;
        var roundno = component.find('roundno');

        var roundnoVal = component.find('roundno').get('v.value');   
        if($A.util.isUndefinedOrNull(roundnoVal) || $A.util.isUndefined(roundnoVal) || $A.util.isEmpty(roundnoVal)){
                        roundno.set("v.errors",[{message:'Name is required'}]);
                allValid = false;
                    }else{
                    
                    roundno.set("v.errors",null);
                }  

        return allValid;
    },
    convertTimeToApexFormat: function(time) {
         // Assuming time is in the format "HH:MM AM/PM"
         var timeParts = time.split(' ');
         var timeValue = timeParts[0]; // "9:30"
         var period = timeParts[1]; // "AM" or "PM"
         
         // Split the time into hours and minutes
         var timeComponents = timeValue.split(':');
         var hours = parseInt(timeComponents[0], 10);
         var minutes = timeComponents[1];
 
         // Convert to 24-hour format
         if (period === 'PM' && hours < 12) {
             hours += 12;
         } else if (period === 'AM' && hours === 12) {
             hours = 0;
         }
 
         // Ensure hours are in two-digit format
         hours = hours < 10 ? '0' + hours : hours;
 
         // Construct the time in the "HH:MM:SS.000Z" format
         var formattedTime = hours + ':' + minutes + ':00.000Z';
         
         return formattedTime;
    
    }
    

})
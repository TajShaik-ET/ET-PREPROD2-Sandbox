({
    doInit : function(component, event, helper) {
          window.setTimeout(
            $A.getCallback(function() {
                component.set("v.isLoading", false);
            }), 2000
        );
        helper.getPicklistValueHelper(component, event, helper);
        component.set("v.selectedJobProcss",'Buffing');//set to default valueS
        //console.log(issuedQty+'='+toolMasterId+'='+selectedJobProcss)
        //console.log(jcclines)
        let rejection = new Object();
        rejection.sobjectType = 'ETT_JCC_Rejection_Analysis__c';
        rejection.ETT_Ply_Seperation__c = false;
        rejection.ETT_Bread_Area_Seperation__c = false;
        rejection.ETT_Belt_Seperation__c = false;
        rejection.ETT_Cut_Spot_Seperation__c = false;
        rejection.ETT_Tread_Seperation__c = false;
        rejection.ETT_Large_Cut__c = false;
        rejection.ETT_Excessive_Cuts__c = false;
        rejection.ETT_Scrap__c = false;
        rejection.ETT_Old_and_Dry_Casing__c = false;
        rejection.ETT_Total_Burst__c =  false;
        rejection.ETT_Steel_Cord_Visible__c = false;
        rejection.ETT_Body_Ply_Distortance__c = false;
        rejection.ETT_Excessive_Damage_on_Seat_Belt__c = false;
        rejection.ETT_Overall_Chipping__c = false;
        rejection.ETT_Oil_Choked_Tyres__c = false;
        rejection.ETT_Overall_Rust__c = false;
        rejection.ETT_Low_Base_Rubber__c = false;
        rejection.ETT_Bread_Area_Damage__c = false;
        rejection.ETT_Cut_Spot_Buckling__c = false;
        rejection.ETT_Side_Wall_Buckling__c = false;
        rejection.ETT_Price_not_Agreed__c = false;
        component.set("v.jccRejection",rejection);
    },
    handleChange: function(component, event, helper) {
        var fieldName = event.getSource().get("v.name");
        var isChecked = event.getSource().get("v.checked");
        //alert('f'+fieldName);
        //alert('C'+isChecked);
        console.log('fieldName '+fieldName);
        console.log('isChecked '+isChecked);
        var rejection = component.get("v.jccRejection");
        rejection[fieldName] = isChecked;
        //component.set("v.rejection", rejection);
        //alert('R'+JSON.stringify(rejection));
        console.log('rejection '+JSON.stringify(rejection));
    },
   
 /*   employeemasterChange: function(component, event, helper) {
        debugger;
        var action = component.get('c.getEmployeeMasterDetails');
        var employeeId = event.getSource().get("v.value")[0];
        console.log('employee id'+employeeId);
        var index = event.getSource().get("v.id");
        console.log('index'+index); // Get index from the data attribute

        action.setParams({
            recordId: employeeId
        });

        action.setCallback(this, function(response) {
            var state = response.getState();

            if (state === "SUCCESS") {
                var newJobCardCloseEmployees = component.get('v.newJobCardCloseEmployees');
                console.log(JSON.stringify(newJobCardCloseEmployees));
                var selectedJobType = component.get('v.selectedJobProcss');
                var updatedEmployeeName = response.getReturnValue().Employee_Name__c;

                // Map employees to the corresponding job type
                for (let i = 0; i < newJobCardCloseEmployees.length; i++) {
                    if (i == index && newJobCardCloseEmployees[i].ETT_Job_Type__c === selectedJobType) {
                        newJobCardCloseEmployees[i].ETT_Employee_Name__c = updatedEmployeeName;
                        break;
                    }
                }

                component.set('v.newJobCardCloseEmployees', newJobCardCloseEmployees);
                console.table(JSON.stringify(newJobCardCloseEmployees));
            } else {
                console.error('Failed to retrieve employee details: ' + response.getError());
            }
        });

        $A.enqueueAction(action);
    },
*/
employeemasterChange: function(component, event, helper) {
    debugger;
    var action = component.get('c.getEmployeeMasterDetails');
    var employeeId = event.getSource().get("v.value")[0]; // Directly access the value, assuming it's a string
    var index = event.getSource().get("v.id"); // Assuming `v.id` holds the correct index value
    
    // Ensure employeeId and index are valid
    if (employeeId && index !== undefined && index !== null) {
        action.setParams({
            recordId: employeeId
        });

        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var updatedEmployeeDetails = response.getReturnValue();
                var updatedEmployeeName = updatedEmployeeDetails.Employee_Name__c;
                var employeeList = component.get("v.employeeList");

                if (employeeList && employeeList.length > index) {
                    employeeList[index].Tyre_Employee_Master__r.Employee_Name__c = updatedEmployeeName;

                    

                    
                    component.set("v.employeeList", employeeList);
                }
            } else {
               
                console.error('Failed to retrieve employee details: ', response.getError());
            }
        });

        $A.enqueueAction(action);
    } else {
        console.error('Invalid employee ID or index.');
    }
},
    

        handleEmployeeChange:function(component, event, helper) {
           
            var employeeId = event.getSource().get("v.value");
            var rowIndex = event.getSource().get("v.id");
    
                helper.fetchEmployeesUpdated(component, employeeId, rowIndex);
          
          
           

        },


    getJobCardDetails :function(component, event, helper) {
        
        var action = component.get('c.getJobCardRealtedDetails');
        
        action.setParams({
            jobCardId:component.get("v.jobCardId").toString()
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            
            if (state === "SUCCESS") {  
                component.set("v.jobCardInfo",response.getReturnValue().lstJob);
                component.set("v.initialSideCut",response.getReturnValue().sidewallcut);
                component.set("v.initialCrownCut",response.getReturnValue().crownCut);
                
                var jobCardInfo = component.get("v.jobCardInfo");
               
                console.log(JSON.stringify(jobCardInfo));
                component.set("v.initialRemark", "");
                component.set("v.initialLife", jobCardInfo.ETT_Inspection_Card__r.Tyre_Life__c);
                component.set("v.initialCut", "");
                component.set("v.skivingRemark", jobCardInfo.ETT_Skiving_Technician_Rejection_Remarks__c);
                component.set("v.repairRemark", jobCardInfo.ETT_Repair_Technician_Rejection_Remarks__c);
                component.set("v.buildingRemark", jobCardInfo.ETT_Building_Technician_Reject_Remarks__c);
                component.set("v.buffingRemark", jobCardInfo.ETT_Buffing_Technician_Rejection_Remarks__c);
                component.set("v.buffingWidth", "");
                component.set("v.buffingLength", "");
                component.set("v.filingRemark", jobCardInfo.ETT_Filling_Technician_Rejection_Remarks__c);
                component.set("v.treadRemark", jobCardInfo.ETT_Thread_Technician_Rejection_Remarks__c);
                component.set("v.finalRemark", jobCardInfo.ETT_Final_Inspection_Technician_Remarks__c);
                
                helper.getJobTypeHelper(component, event, helper);
                helper.getAllUsedItemsHelper(component, event, helper);
                helper.getEnvelopeDetails(component, event, helper);
                helper.getCuringDetails(component, event, helper);
                helper.getBuffingDetails(component, event, helper);
                
                let data = response.getReturnValue();
                if(data){
                    
                    if((data.ETT_Overall_Status__c =='Accepted' || data.ETT_Overall_Status__c =='Rejected') && data.ETT_Stages__c=='Quality Control'){
                        component.set("v.ProdtnStatus", "Produced");
                    }else{
                        component.set("v.ProdtnStatus",'In Progress');
                    }
                }
                // console.log(data)
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
    handleChangeProcess : function(component, event, helper) {
        debugger;
        //var selectedOptionValue = event.getParam("value");
        var selectedOptionValue = event.currentTarget.id;
        console.log(selectedOptionValue)
        component.set("v.selectedJobProcss",selectedOptionValue);
        helper.fetchEmployees(component, selectedOptionValue);

        
        if(selectedOptionValue){
            let reqData =component.get("v.allItemsList");
            var tempdata= [];
            
            tempdata = reqData.filter(function(item){
                return (item.ETT_Job_Stage__c.indexOf(selectedOptionValue) !== -1)
            });
            if(tempdata){
                component.set("v.filterItemsList",tempdata);
            }
            
            let empData = component.get("v.allEmployeesList");
            var tempEmpdata= [];
            
            tempEmpdata = empData.filter(function(item){
                return (item.ETT_Job_Type__c.indexOf(selectedOptionValue) !== -1)
            });
            if(tempEmpdata){
                component.set("v.filterEmployeesList",tempEmpdata);
            }
        }
        //console.log(component.get("v.filterItemsList"))
        
    },
    handleAddItem : function(component, event, helper) {
        component.set("v.showModel",true);
        component.set("v.showEmployeeModel",false);
    },
    handleAddEmployee : function(component, event, helper) {
        component.set("v.showEmployeeModel",true);
        component.set("v.showModel",false);
    },
    closeModel : function(component, event, helper) {
        component.set("v.showModel",false);
        component.set("v.showEmployeeModel",false);
        //Set all values to null
        component.set("v.issuedQty",null);
        component.set("v.toolMasterId",null);
        component.set("v.empNo",null);
        component.set("v.empName",null);
        component.set("v.empWorkingDate",null);
        component.set("v.empStartTime",null);
        component.set("v.empEndTime",null);
        component.set("v.selectedJobProcss",'Buffing');//set to default value
    },
    saveJCCloseLine:function(component, event, helper) {

        
        let issuedQty = component.get("v.issuedQty");
        let toolMasterId = component.get("v.toolMasterId");
        let selectedJobProcss = component.get("v.selectedJobProcss");
        let jcclines = component.get("v.newJobCardCloseLines");
        let indUnitVal = component.get("v.tempIndiUnitVal");
        let cost = issuedQty*indUnitVal;
        //console.log(issuedQty+'='+toolMasterId+'='+selectedJobProcss)
        //console.log(jcclines)
        try{ 
            let JClines = new Object();
            JClines.sobjectType = 'ETT_Job_Card_Close_Lines__c';
            JClines.Item_Name__c = toolMasterId;
            JClines.Issued_Quantity__c = issuedQty;
            JClines.Job_Type__c=selectedJobProcss;
            JClines.Unit_Cost__c= indUnitVal;
            JClines.Cost__c=  ((cost !=null) ? cost : '0') ;
            JClines.UOM__c=  component.get("v.tempUOM");
            JClines.Available_Quantity__c=component.get("v.tempAvailQty");
            JClines.ETT_Unique_Code__c= component.get("v.tempItemCode");
            JClines.ETT_Item_Description__c= component.get("v.tempItemDesc");
            
            jcclines.push(JClines);
            
            component.set("v.newJobCardCloseLines",jcclines);
            //Set all values to null
            component.set("v.issuedQty",null);
            component.set("v.toolMasterId",null);
            component.set("v.selectedJobProcss",'Buffing');//set to default value
            component.set("v.showModel",false);
            
        }catch(e){
            console.log(e.message)
        }
    },
    saveJCCloseEmployee: function (component, event, helper) {
        // Retrieve employee list
        debugger;
        var employeeList = component.get("v.employeeList");
        var newJobCardCloseEmployees = component.get("v.newJobCardCloseEmployees") || [];
        var selectedProcess=component.get("v.selectedJobProcss");
    
        var rowIndex = event.getSource().get("v.value");
        // Update the employee data in newJobCardCloseEmployees
        if (rowIndex >= 0 && rowIndex < employeeList.length) {
            var employee = employeeList[rowIndex];

            // Create a new record or update existing one
            var updatedEmployee = {
                
                Employee_Master__c: employee.Tyre_Employee_Master__c,
                ETT_Employee_Name__c: employee.Tyre_Employee_Master__r.Employee_Name__c,
                ETT_End_Time__c: employee.ETT_End_time__c,
                ETT_Job_Type__c: employee.ETT_Work_Station__r.Name,
                ETT_Start_Time__c: employee.ETT_Start_time__c,
                sobjectType: 'ETT_JCC_Employee__c'
            };

            // Check if the record already exists in the array
            var index = newJobCardCloseEmployees.findIndex(record => record.Id === employee.Id);
            if (index > -1) {
                // Update existing record
                newJobCardCloseEmployees[index] = updatedEmployee;
            } else {
                // Add new record
                newJobCardCloseEmployees.push(updatedEmployee);
            }

            // Set the updated list back to the attribute
            component.set("v.newJobCardCloseEmployees", newJobCardCloseEmployees);

            console.table(JSON.stringify(newJobCardCloseEmployees));
        }
    },
    
    toolmasterChange : function(component, event, helper) {
        alert('1');
        
        //let toolMasterId = component.get("v.toolMasterId");
        var changedField = event.getSource().get("v.label");
        
        
        //var inputId = event.getSource().getLocalId();
        console.log('changedField '+changedField);
        //var inputIndex = changedField.substr(-1);
        //console.log('inputIndex '+inputIndex);
        // Get the new record ID
        var toolMasterId = event.getSource().get("v.value");
        //var index = component.get("v.index");
        console.log('toolMasterId '+toolMasterId);
        //console.log('index '+index);
        //console.log('index 1 '+event.target.dataset.index);
        //console.log('index 2 '+event.currentTarget.dataset.index);
        console.log('index 3 '+event.getSource().get("v.name"));
        console.log('index 4 '+event.getSource().get("v.data-selected-index"));
        //let toolMasterId = event.currentTarget.dataset.value;*/
        var action = component.get('c.getToolMasterInfo');
        
        action.setParams({
            toolMasId:toolMasterId.toString()
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            
            if (state === "SUCCESS") {  
                
                let data = response.getReturnValue();
                
                if(data && rowIndexFromChild != null){
                    //var index = event.currentTarget.dataset.index;
                    
                    let removeList = component.get("v.newJobCardCloseLines");
                    let record = removeList[rowIndexFromChild];
                    record.Item_Name__c = toolMasterId.toString();
                    if(data.UOM__c){
                        component.set("v.tempUOM",data.UOM__c);
                        record.UOM__c = data.UOM__c;
                    }else{
                        component.set("v.tempUOM",null);
                    }
                    
                    if(data.ETT_Main_Stock_Units__c){                      
                        component.set("v.tempAvailQty",data.ETT_Main_Stock_Units__c);
                    }else{
                        component.set("v.tempAvailQty",null);  
                    }
                    if(data.ETT_Unique_Code__c){
                        component.set("v.tempItemCode",data.ETT_Unique_Code__c);
                        record.ETT_Unique_Code__c = data.ETT_Unique_Code__c;
                    }else{
                        component.set("v.tempItemCode",null);  
                    }
                    if(data.ETT_Item_Description__c){
                        component.set("v.tempItemDesc",data.ETT_Item_Description__c);
                        record.ETT_Item_Description__c = data.ETT_Item_Description__c;
                    }else {
                        component.set("v.tempItemDesc",null);
                    }
                    if(data.ETT_Individual_Unit_Value__c){
                        component.set("v.tempIndiUnitVal",data.ETT_Individual_Unit_Value__c);
                    }else {
                        component.set("v.tempIndiUnitVal",null);
                    }
                    
                    //removeList.splice(index, 1);
                    console.log('removeList '+JSON.stringify(removeList));
                    component.set("v.newJobCardCloseLines",removeList);
                }
                
            }else if (state === "ERROR") {
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
    removeLine : function(component, event, helper) {
        
        var index = event.currentTarget.dataset.index;
        var removeList = component.get("v.newJobCardCloseLines");
        removeList.splice(index, 1);
        
        component.set("v.newJobCardCloseLines",removeList);
    },
    calculateTotalHours : function(component, event, helper) {
        var startTime = component.get("v.curingstartTime");
        var endTime = component.get("v.curingendTime");
        
        var startTimestamp = Date.parse(startTime);
        var endTimestamp = Date.parse(endTime);
        
        var timeDiff = endTimestamp - startTimestamp;
        var hours = timeDiff / (1000*60*60);
        
        component.set("v.curingtotalHours", hours);
    },
    removeEmployee : function(component, event, helper) {
        
        var index = event.currentTarget.dataset.index;
        var removeList = component.get("v.newJobCardCloseEmployees");
        removeList.splice(index, 1);
        
        component.set("v.newJobCardCloseEmployees",removeList);
    },
   
    
        handleSubmit: function(component, event, helper) {
            debugger;
            event.preventDefault();
            component.set("v.isLoading", true);
            var newJobCardCloseEmployees = component.get('v.newJobCardCloseEmployees');
            console.log(JSON.stringify(newJobCardCloseEmployees));
            var closeDate = component.get("v.closeDate");
            var jobinfo = component.get("v.jobCardInfo");
            var prodstatus = component.get("v.ProdtnStatus");
            var rejection = component.get("v.jccRejection");
            var jobCardId = component.get("v.jobCardId");
            var listofEmployee = component.get("v.newJobCardCloseEmployees");
            var curingValue = component.get("v.curingValue");
            var curingRound = component.get("v.curingRound");
            var curingstartTime = component.get("v.curingstartTime");
            var curingendTime = component.get("v.curingendTime");
            var curingChamber = component.get("v.curingChamber");
            //var curingTemp = component.get("v.jobCardInfo.ETT_Curing_Temperature__c");
            var jsonValues = Object.values(rejection);
            var newJobCardCloseLines = component.get("v.newJobCardCloseLines");
            var threadPatternField = component.find("threadPatternField").get("v.value");
            //console.log(JSON.stringify(newJobCardCloseLines));
           // console.log('newJobCardCloseLines:', newJobCardCloseLines);
            var allfalse = jsonValues.some(function(value) {
                return value === true;
            });

           
            // Basic validations
            if (!jobCardId) {
                helper.showErrorMessage(component, "Please select a job card");
                return;
            } 

            if (jobinfo.Job_Card_Status__c === 'Closed') {
                helper.showErrorMessage(component, "Job card status should not be closed");
                return;
            }
            
            if (jobinfo.Customer_Type__c === 'Internal' && prodstatus === 'Send Back') {
                helper.showErrorMessage(component, "Status should not be Send Back for Internal party type");
                return;
            }
            if (!closeDate) {
                helper.showErrorMessage(component, "Close Date is required");
                return;
            }
            if (!prodstatus || prodstatus === undefined) {
                helper.showErrorMessage(component, "Production Status is required");
                return;
            }
            if (threadPatternField === undefined && prodstatus === 'Produced'  && jobinfo.ETT_job_type_card__c != 'Repair') {
                helper.showErrorMessage(component, "Thread Pattern is required.");
                return;
            }
            
           
           
            
            if (!allfalse && jobinfo.Customer_Type__c === 'Supplier' && (prodstatus === 'Send Back' || prodstatus === 'Scrapped')) {
                helper.showErrorMessage(component, "Rejection Analysis Should not be blank, Please Select any one Field");
                return;
            }
            if (!allfalse && jobinfo.Customer_Type__c === 'Internal' && (prodstatus === 'Send Back' || prodstatus === 'Scrapped')) {
                helper.showErrorMessage(component, "Rejection Analysis Should not be blank, Please Select any one Field");
                return;
            }
            if (!allfalse && jobinfo.Customer_Type__c === 'Internal Private' && (prodstatus === 'Send Back' || prodstatus === 'Scrapped')) {
                helper.showErrorMessage(component, "Rejection Analysis Should not be blank, Please Select any one Field");
                return;
            }
            if (!allfalse && jobinfo.Customer_Type__c === 'Customer' && (prodstatus === 'Send Back' || prodstatus === 'Scrapped')) {
                helper.showErrorMessage(component, "Rejection Analysis Should not be blank, Please Select any one Field");
                return;
            }
            if (prodstatus === 'Produced' || prodstatus === 'In Progress') {
                const hasMaterial = newJobCardCloseLines.some(line => line.Item_Name__c);
                if (!hasMaterial) {
                    helper.showErrorMessage(component, "At least one material is required when Production Status is 'Produced'.");
                    return;
                }
    
                const issuedQuantityValid = newJobCardCloseLines.some(line => line.Issued_Quantity__c > 0);
                if (!issuedQuantityValid) {
                    helper.showErrorMessage(component, "Material quantity should not be negative or Empty.");
                    return;
                }
    
                for (let line of newJobCardCloseLines) {
                    if (line.Issued_Quantity__c > line.Factory_Stock__c) {
                        helper.showErrorMessage(component, "Issue quantity should not be more than factory stock.");
                        return;
                    }
                }


            }
            if($A.util.isEmpty(curingValue) && prodstatus === 'Produced'){
                helper.showErrorMessage(component, "Valve No is required value ..");
                return;
            }
            if($A.util.isEmpty(curingRound) && prodstatus === 'Produced'){
                helper.showErrorMessage(component, "Curing Round is required ..");
                return;
            }
            if($A.util.isUndefinedOrNull(curingstartTime) && prodstatus === 'Produced'){
                helper.showErrorMessage(component, "Curing start time is required");
                return;
            }
            if($A.util.isEmpty(curingChamber) && prodstatus === 'Produced'){
                helper.showErrorMessage(component, "Curing Chamber is required");
                return;
            }
            if($A.util.isUndefinedOrNull(curingendTime) && prodstatus === 'Produced'){
                helper.showErrorMessage(component, "Curing End Time is required");
                return;
            }
          /*  if (prodstatus === 'Produced' || prodstatus === 'In Progress') {
                const hasEmployee = listofEmployee.some(line => line.ETT_Employee_Name__c);
              if (!hasEmployee) {
              //      helper.showErrorMessage(component, "Please Select Employee For Process.");
              //      return;
             //   }

            }
             */

    
            // If no errors, submit the form
            
            component.find('JobCardCloseForm').submit();
        },
    
    
    
    HanldeJobCloseSuccess : function(component, event, helper) {
        helper.createJCcloseLinesUnderJCHelper(component, event, helper);
    },
    toolmasterChange : function(component, event, helper) {
        debugger;
        let toolMasterId = event.getSource().get("v.value")[0];
        let indexId = event.getSource().get("v.id");
        if(toolMasterId==undefined){
            var newJobCardCloseLines=component.get('v.newJobCardCloseLines');
            console.log('Data',newJobCardCloseLines);
            for(var i=0;i<newJobCardCloseLines.length;i++){
                if(i==indexId){
                    newJobCardCloseLines[i].ETT_Unique_Code__c='';
                    newJobCardCloseLines[i].ETT_Item_Description__c='';
                    newJobCardCloseLines[i].UOM__c='';
                    newJobCardCloseLines[i].Available_Quantity__c='';
                }
            }
            component.set('v.newJobCardCloseLines',newJobCardCloseLines);   
            
            return;
        }
        var action = component.get('c.getToolMasterInfo');
        
        action.setParams({
            toolMasId:toolMasterId.toString()
            
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            
            if (state === "SUCCESS") {  
                let data = response.getReturnValue();
                var newJobCardCloseLines=component.get('v.newJobCardCloseLines');
                //This line is used for Mapping 
                for(var i=0;i<newJobCardCloseLines.length;i++){
                    if(i==indexId){
                        newJobCardCloseLines[i].ETT_Unique_Code__c=data.ETT_Unique_Code__c;
                        newJobCardCloseLines[i].ETT_Item_Description__c=data.ETT_Item_Description__c;
                        newJobCardCloseLines[i].UOM__c=data.UOM__c;
                        newJobCardCloseLines[i].Available_Quantity__c=data.ETT_Main_Stock_Units__c;
                        newJobCardCloseLines[i].Factory_Stock__c=data.ETT_Allocated_Units__c;
                        newJobCardCloseLines[i].Unit_Cost__c=data.ETT_Individual_Unit_Value__c;
                      

                    }
                }
                component.set('v.newJobCardCloseLines',newJobCardCloseLines);   
               
                
            }else if (state === "ERROR") {
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
     showSpinner: function(component, event, helper) {
        // make Spinner attribute true for displaying loading spinner 
        component.set("v.spinner", true); 
    },
     
    // function automatic called by aura:doneWaiting event 
    hideSpinner : function(component,event,helper){
        // make Spinner attribute to false for hiding loading spinner    
        component.set("v.spinner", false);
    }
})
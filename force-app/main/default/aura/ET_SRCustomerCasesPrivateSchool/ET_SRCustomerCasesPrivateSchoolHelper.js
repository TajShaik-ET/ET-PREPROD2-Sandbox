({
      /*fetchCases: function(component, event, helper) {
        let action = component.get("c.");

        // Pass parameters from the client-side
        action.setParams({
            fieldNames: "Id, Subject, Status,CaseNumber,Status_Category__c,RecordType.Name,School_Code_Detail_Page__c,Description,Bus_Internal_Number__c,ESE_free_text__c,ETST_Student__c,SIS_Number__c,Grade__c,Parent_Name__c,Internal_Number_Of_Student__c,Disability_Type__c,Mobility_Ads__c,Sub_Request__c,LandMark__c,Delegated_Person_Names__c,Delegated_Person_Phone__c,Coordinator_Name__c,Phone_Number__c,CCM_Remarks__c,Request_Type__c,ID_number__c,Student_Companion_Name__c,Companion_ID_Number__c,Mode__c,No_of_Passengers__c,Students_Gender__c,Student_Division__c,Preferred_Date__c,Preferred_End_Date__c,Trip_Location__c,No_of_Disabled_Students__c,Escort_for_Disbaled_Students__c,Bus_Supervisor_Available__c,No_of_Attendance__c,Coordinator_Number__c,Awareness_Session_Location__c,Program_Type__c,No_of_Students__c,Zone_Type__c,Trip_Type__c,School_City__c", // Pass the fields dynamically
            recordTypeNames: [
                
            'Requests_for_trips_activities_events', 
            'Fleet_Growth_Request',
            'Special_Needs_Transportation_Request',
            'Special_Needs_Activities_and_Events_Request',
            'Global_Event_Request',
            'Handicap_Services_Transport_or_Nanny_Request',
            'Growth_Request',
            'Special_Needs_Companion_Request',
            'Request_for_the_awareness_sessions',
            'Request_for_the_Companian_Handicap_Transportation'
              
            ], // Pass the record type names dynamically
            limitValue: 4999 // Pass the limit dynamically
        });

        action.setCallback(this, function(response) {
            let state = response.getState();
            console.log('response of Ese USER '+JSON.stringify(response));      
            if (state === "SUCCESS") {
                let caseList = response.getReturnValue();
                component.set("v.caseListReport", caseList);
                console.log('response of Ese USER '+JSON.stringify(caseList));  
               
            } else {
                console.error("Error fetching cases: " + response.getError());
            }
        });

        $A.enqueueAction(action);
    },
*/
        getEseUserEmail: function(component, event, helper,status){
        var action = component.get('c.getuserDetails');
        action.setParams({
            
        });
        action.setCallback(this, function (a) {
             var state = a.getState();
            if (state == 'SUCCESS') {
                   var result=a.getReturnValue();
                component.set('v.userEmail', result.Email);
            }else{
                alert('++Error in getting User EMAIL');
            }
            
        });
         $A.enqueueAction(action); 
                           
    },
    getEseUserdepartmentdata: function(component, event, helper,status){
        
        var action = component.get('c.getEseDepartmentUserData');
        action.setParams({
        });
        action.setCallback(this, function (a) {
            var state = a.getState(); // get the response state
            // console.log(state);
            if (state == 'SUCCESS') {
                var response=a.getReturnValue();
                
                //console.log('response of Ese USER '+JSON.stringify(response));           
                component.set("v.eseUserList", response);              
                
            }else{
                alert('Error in getting User details');
            }
        });
        $A.enqueueAction(action);       
    },
getCaseDataAbudhabi: function (component, event, helper, status) {
    try {
        console.log('Status: ' + status);
        var user = component.get('v.userEmail');
        var action = component.get('c.getCaseDetails');

        action.setParams({
            status: status
        });

        action.setCallback(this, function (response) {
            var state = response.getState();
            if (state === 'SUCCESS') {
                var responseData = response.getReturnValue();
                console.log('Fetched case data: ', JSON.stringify(responseData));
                var filteredCases = [];

                // Special handling for Abu Dhabi
                if (user === 'malha.albreiki@ese.gov.ae') {
                    filteredCases = responseData.filter(function (caseItem) {
                        return (
                            caseItem.School_City__c === 'Abu Dhabi' &&
                            caseItem.Emirates__c === 'Abu Dhabi'
                        );
                    });

                    console.log('Filtered cases for Abu Dhabi: ', JSON.stringify(filteredCases));
                } else {
                    // No filtering for other users
                    filteredCases = responseData;
                }

                // Apply additional processing for visibility
                filteredCases.forEach(function (caseItem) {
                    caseItem.buttonVisblity = false; // Default visibility
                    var eseDetails = component.get('v.eseUserList');

                    eseDetails.forEach(function (ese) {
                        if (
                            caseItem.AccountId === ese.School_Department__r.School_Name__c &&
                            caseItem.Status_Category__c === ese.School_Department__r.Category__c
                        ) {
                            caseItem.buttonVisblity = true;
                        }
                    });
                });

                // Update component attributes
                component.set('v.caseList', filteredCases);
                component.set('v.currentData', filteredCases);
            } else {
                console.error('Failed to fetch case data. State: ', state);
            }
        });

        $A.enqueueAction(action);
    } catch (error) {
        console.error('Error in getCaseDataAbudhabi: ', error);
    }
},
    
    
    getCaseData : function(component, event, helper,status) {
        debugger;
        try {
        console.log('status'+status);
             var user =component.get('v.userEmail');
             var emirates =component.get('v.accEmirates');
       
        var action = component.get('c.getCaseDetails');     
        action.setParams({
            "status" : status
        });
        action.setCallback(this, function (a) {
            var state = a.getState(); // get the response state            
            if (state == 'SUCCESS') {
                var respose=a.getReturnValue();
                 console.log('Filtered case list for ABU DHABI: ' + JSON.stringify(respose));
                           
               
                component.set('v.caseList', respose);
                console.log('response of case Date  '+JSON.stringify(respose));  
                //component.set('v.currentData', respose);  
                              
                var esedetils = component.get('v.eseUserList');               
                respose.forEach(function(item){
                   // console.table(item.CaseNumber);
                    esedetils.forEach(function(ese){
                       // console.table(ese.School_Department__r.School_Name__c);
                       // console.table(ese.School_Department__r.Category__c);
                        //console.table(ese);
                        if(item.AccountId==ese.School_Department__r.School_Name__c && item.Status_Category__c==ese.School_Department__r.Category__c){
                            console.log('True visibility on ');
                            item.buttonVisblity= true;
                        }
                        else if(item.AccountId==ese.School_Department__r.School_Name__c==null && item.Status_Category__c==null){
                             console.log('True visibility off ');
                            item.buttonVisblity= false;                         
                        }
                         else if(item.AccountId==null){
                            console.log('false visibility off ');
                            item.buttonVisblity= true;     
                                              
                        }
                    });
                    
                });
                component.set('v.currentData', respose);
               // console.log('a.getReturnValue() '+JSON.stringify(component.get('v.currentData'))); 
            }
        });
        $A.enqueueAction(action);
        
          } catch (error2) {
       
    }
    },    
    getPrivateuserdata: function(component, event, helper,status){
      // debugger;
        var action = component.get('c.getprivateschoolUserData');
        action.setParams({
            
        });
        action.setCallback(this, function (a) {
            var state = a.getState(); // get the response state
            
            if (state == 'SUCCESS') {
                var respose=a.getReturnValue();
                console.log('respose11222 '+JSON.stringify(respose));
                component.set('v.userParentProfileWrap', respose);          
            }else{
                alert('Error in getting User details');
            }
        });
        $A.enqueueAction(action);       
    },
    
     getEmiratesdata: function(component, event, helper,status){
      // debugger;
        var action = component.get('c.getUserEmiratess');
        action.setParams({
            
        });
        action.setCallback(this, function (a) {
            var state = a.getState(); // get the response state
              if (state == 'SUCCESS') {
                var respose=a.getReturnValue();
                console.log('emirates '+JSON.stringify(respose));
                component.set('v.accEmirates', respose);          
            }else{
                alert('Error in getting User details');
            }
        });
        $A.enqueueAction(action);       
    },
    
  
    
    approveCaseHelper : function (component, event,helper,recId){
          
        try{
         let caseVal = component.get('v.case');
          
         let reqType = caseVal?caseVal.Request_Type__c:''
        // alert(reqType);
         let reqTypearbic = caseVal?caseVal.Request_Type_AR__c:''
         //  alert(reqType);
        //var RequestType = component.find("requestId").get("v.value");
        var action = component.get('c.approveMOECase'); 
       
        action.setParams({           
            recId : recId,
            caseComments : component.get("v.comments"),
            requestType: reqType,
            emailsofeseuser: component.get('v.userEmail'),
            requestTypeArabic: reqTypearbic
        });        
        action.setCallback(this, function (a) {
           var state = a.getState();
           
            if (state == 'SUCCESS') {                
                $A.get('e.force:showToast').setParams({
                    "title": "Success",
                    "message": "Case is approved succesfully!",
                    "type": "success",
                }).fire();
                
                location.reload();
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
    }catch(e){
      alert(e.message)
}
    },
    rejectCaseHelper : function (component, event,helper,recId){     
       
        var action = component.get('c.rejectMOECase');
        action.setParams({
            recId : recId,
            caseComments : component.get("v.comments")
        });
        action.setCallback(this, function (a) {
            //console.log(a.getReturnValue());
            var state = a.getState(); // get the response state
            if (state == 'SUCCESS') {
                $A.get('e.force:showToast').setParams({
                    "title": "Success",
                    "message": "Case is rejected succesfully!",
                    "type": "success",
                }).fire();
                location.reload();
            }
        });
        $A.enqueueAction(action);
    },
    //Added SrihariKoyila-//
     feedBackCaseHelper : function (component, event,helper,recId){     
       
        var action = component.get('c.MOECaseFeedBack');
        action.setParams({
            recId : recId
        });
        action.setCallback(this, function (a) {
            //alert(a.getReturnValue());
            console.log(a.getReturnValue());
            var state = a.getState(); // get the response state
            if (state == 'SUCCESS') {
                $A.get('e.force:showToast').setParams({
                    "title": "Success",
                    "message": "Case FeedBack is Sent succesfully!",
                    "type": "success",
                }).fire();
                location.reload();
            }
        });
        $A.enqueueAction(action);
    },
    //-//
    deleteCaseHelper : function (component, event,helper,recId){     
       
        var action = component.get('c.deleteMOECase');
        action.setParams({
            recId : recId
        });
        action.setCallback(this, function (a) {
            console.log(a.getReturnValue());
            var state = a.getState(); // get the response state
            if (state == 'SUCCESS') {
                $A.get('e.force:showToast').setParams({
                    "title": "Success",
                    "message": "Case is deleted succesfully!",
                    "type": "success",
                }).fire();
                location.reload();
            }
        });
        $A.enqueueAction(action);
    },
    closeCaseHelper : function (component, event,helper,recId){   
       
        var action = component.get('c.closeMOECase');
        action.setParams({
            recId : recId,
            caseComments : component.get("v.comments")
        });
        action.setCallback(this, function (a) {
            console.log(a.getReturnValue());
            var state = a.getState(); // get the response state
            if (state == 'SUCCESS') {
                
                $A.get('e.force:showToast').setParams({
                    "title": "Success",
                    "message": "Case is closed succesfully!",
                    "type": "success",
                }).fire();
                location.reload();
            }else{
                alert('error');
            }
        });
        $A.enqueueAction(action);
    },
   
   
    cancelCaseHelper : function (component, event,helper,recId){   
        var action = component.get('c.cancelMOECase');
        action.setParams({
            recId : recId,
            caseComments : component.get("v.comments")
        });
        action.setCallback(this, function (a) {
            console.log(a.getReturnValue());
            var state = a.getState(); // get the response state
            if (state == 'SUCCESS') {
                
                $A.get('e.force:showToast').setParams({
                    "title": "Success",
                    "message": "Case is cancel  succesfully!",
                    "type": "success",
                }).fire();
               location.reload();
            }else{
                alert('error');
            }
        });
        $A.enqueueAction(action);
    },
    
    eseHandlelineCase : function(component, event, helper,recId) 
    {
        var ESEList = component.get("c.getESEReqLineList");
        console.log('id'+recId);
        
        ESEList.setParams
        ({
            recordId: recId
        });
        
        ESEList.setCallback(this, function(response) {
            var state = response.getState();
              var res = response.getReturnValue()
              
            if (state === "SUCCESS") {  
                //console.log(state);
                component.set("v.ESERequestList", res);   
 
             
              
                
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
         
        $A.enqueueAction(ESEList); 
    },
    
  
    
    getPicklistValues: function(component, event) {
        var action = component.get("c.getEnglisValue");
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var result = response.getReturnValue();
                 var fieldMap = [];
                for(var key in result){
                    fieldMap.push({key: key, value: result[key]});
                }
                component.set("v.fieldMap", fieldMap);
             
                }
             });
        $A.enqueueAction(action);
    },
   
      getArabicValue: function(component, event) {
        var action = component.get("c.getArabicFieldValue");
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var result = response.getReturnValue();
                var fieldMap = [];
                for(var key in result){
                    fieldMap.push({key: key, value: result[key]});
                }
                 
                component.set("v.fieldMap", fieldMap);
            }
           
        });
        $A.enqueueAction(action);
    }, 
      //Added by Arunsarathy on 09.05.2023 for case detail view based on record type
    getRecordType: function(component,event,helper){
          
        var action = component.get('c.getRecordTypeName');
        action.setParams({
            caseId : component.get('v.recordsID')
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {  
                var res = response.getReturnValue();
                console.log('Recordtt=='+res);
                component.set('v.caseRecordTypeName',res)
            }
            else if (state === "ERROR") {
                alert(response.getError())
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
 
     getcaseCommentsbyUser: function(component,event,helper,recId){
        debugger;
        var action = component.get('c.getCaseComments');
        var idofcase = component.get('v.recordsID');
        
        var caseIDlookup=component.get('v.recordsID').toString();
        action.setParams({
            caseId : caseIDlookup
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") { 
                var caseCommnetsDetails = response.getReturnValue();  
                // Format the CreatedDate
                caseCommnetsDetails.forEach(function(comment) {
                    var createdDate = new Date(comment.CreatedDate);
                    var formattedTime = createdDate.toLocaleString('en-US', { year: 'numeric', month: 'numeric', day: 'numeric', hour: 'numeric', minute: 'numeric', second: 'numeric', hour12: true });
                    comment.formattedTime = formattedTime;
                });
                
                // Set the formatted response in the Lightning component attribute
                component.set("v.caseCommentslist", caseCommnetsDetails);
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
    getSelectedFields: function(caseType) {
        var fieldMapping = {
            'Companian - Handicap Transportation': ['CaseNumber', 'Grade__c'],
            'Special Needs Services Transport or Nanny Request': ['CaseNumber', 'Grade__c'],
            // Add more mappings for other case types
        };
        return fieldMapping[caseType] || [];
    },
   /*
      convertOfCaseListToCSV : function(component,objRecords) {
        debugger;
        var csvStringResult, counter, keys, lineDivider, columnDivider;
        if (objRecords == null || !objRecords.length) {
            return null;
        }
        var recordType = objRecords[0].RecordType ? objRecords[0].RecordType.Name : null;
        if (recordType === 'Special Needs Services Transport or Nanny Request') {
            keys = ['CaseNumber', 'RecordType','School_Code_Detail_Page__c', 'School_Area__c','School_City__c',
                    'Account','ETST_Student__c', 'SIS_Number__c','Grade__c','Parent_Name__c','Internal_Number_Of_Student__c','Disability_Type__c',
                    'Mobility_Ads__c','Sub_Request__c','ESE_free_text__c','LandMark__c','Delegated_Person_Names__c',
                    'Delegated_Person_Phone__c','Coordinator_Name__c','Phone_Number__c','CCM_Remarks__c','Request_Type__c']; // Adjust the fields as needed
        } else if(recordType === 'Companian - Handicap Transportation') {
            keys = ['CaseNumber', 'RecordType','School_Code_Detail_Page__c','School_Area__c','School_City__c','Account','Name','ETST_Student__c','Grade__c','ID_number__c',
                    'Student_Companion_Name__c','Companion_ID_Number__c'];
        }else if(recordType === 'Activities and Events Requests') {
            keys = ['CaseNumber', 'RecordType','School_Code_Detail_Page__c','School_Area__c','School_City__c','AccountId','Trip_Type__c','ESE_free_text__c','Mode__c','No_of_Passengers__c','Students_Gender__c ','Student_Division__c','Preferred_Date__c','Preferred_End_Date__c','Trip_Location__c','No_of_Disabled_Students__c','Escort_for_Disbaled_Students__c','Bus_Supervisor_Available__c','Coordinator_Name__c','Phone_Number__c','CCM_Remarks__c'];
        }else if(recordType === 'Students Awareness Session Request') {
            keys = ['School_Code_Detail_Page__c','School_Area__c','School_City__c','AccountId','No_of_Attendance__c','Preferred_Date__c','Preferred_End_Date__c','Coordinator_Name__c',
                    'Coordinator_Number__c','Awareness_Session_Location__c','LandMark__c','Program_Type__c','CCM_Remarks__c'];
        }else if(recordType === 'Growth Requests for Vehicle,Nanny and Coordinator') {
            keys = ['School_Code_Detail_Page__c','School_Area__c','School_City__c','AccountId','No_of_Students__c','Students_Gender__c','Zone_Type__c',
                     'Coordinator_Name__c','Phone_Number__c','Bus_Internal_Number__c','Description'];
        }
            else {
              alert('No data available  for export');
                keys = ['', ''];
            }
        columnDivider = ',';
        lineDivider = '\n';
        csvStringResult = '';
        csvStringResult += keys.join(columnDivider);
        csvStringResult += lineDivider;
          for (var i = 0; i < objRecords.length; i++) {
              counter = 0;
              for (var sTempkey in keys) {
                  var skey = keys[sTempkey];
                  
                  if (counter > 0) {
                      csvStringResult += columnDivider;
                  }
                  
                  var cellValue = objRecords[i][skey];
                  
                  if (typeof cellValue === 'object' && cellValue !== null) {
                      if (skey === 'RecordType') {
                          csvStringResult += '"' + cellValue.Name + '"';
                      } else if (skey === 'Account') {
                          csvStringResult += '"' + cellValue.Name + '"';
                      } else if (skey === 'ETST_Student__r') {
                          csvStringResult += '"' + cellValue.Name + '"';
                      } else {
                          // Handle other object types if needed
                          csvStringResult += '""'; // Empty value for unsupported object types
                      }
                  } else {
                      // Check for undefined or null values
                      cellValue = cellValue === undefined || cellValue === null ? '' : cellValue;
                      csvStringResult += '"' + cellValue + '"';
                  }
                  
                  counter++;
              }
              
              csvStringResult += lineDivider;
          }
          

    return csvStringResult;
    },
    */
    
    convertCaseListToCSV: function (component, records) {
        debugger;
        if (!records || !records.length) {
            return null;
        }

        const recordType = records[0].RecordType ? records[0].RecordType.Name : null;
        let keys;

        switch (recordType) {
            case 'Special Needs Services Transport or Nanny Request':
                keys = [
                    'CaseNumber', 'RecordType', 'School_Code_Detail_Page__c', 'School_Area__c', 'School_City__c',
                    'Account', 'ETST_Student__c', 'SIS_Number__c', 'Grade__c', 'Parent_Name__c','Status','Case_Type_AR__c',
                    'Status_Category_AR__c','Sub_Status_AR__c','Coordinator_Name__c','Status_Category__c','Parent_Name_Student__c','ESE_free_text__c',
                    'Internal_Number_Of_Student__c', 'Disability_Type__c', 'Mobility_Ads__c', 'Sub_Request__c','Grade__c','Bus_Supervisor_Available__c',
                    'ESE_free_text__c', 'LandMark__c', 'Delegated_Person_Names__c', 'Delegated_Person_Phone__c',
                    'Coordinator_Name__c', 'Phone_Number__c', 'CCM_Remarks__c', 'Request_Type__c'
                ];
                break;

            case 'Companian - Handicap Transportation':
                keys = [
                    'CaseNumber', 'RecordType', 'School_Code_Detail_Page__c', 'School_Area__c', 'School_City__c',
                    'Account', 'Name', 'ETST_Student__c', 'Grade__c', 'ID_number__c',
                    'Student_Companion_Name__c', 'Companion_ID_Number__c','Sub_Status_AR__c','Status_Category_AR__c'
                ];
                break;

            case 'Activities and Events Requests':
                keys = [
                    'CaseNumber', 'RecordType', 'School_Code_Detail_Page__c', 'School_Area__c', 'School_City__c',
                    'Account', 'Trip_Type__c', 'ESE_free_text__c', 'Mode__c', 'No_of_Passengers__c',
                    'Students_Gender__c', 'Student_Division__c', 'Preferred_Date__c', 'Preferred_End_Date__c',
                    'Trip_Location__c', 'No_of_Disabled_Students__c', 'Escort_for_Disbaled_Students__c',
                    'Bus_Supervisor_Available__c', 'Coordinator_Name__c', 'Phone_Number__c', 'CCM_Remarks__c'
                ];
                break;

            case 'Growth Requests for Vehicle,Nanny and Coordinator':
                keys = [
                   'CaseNumber', 'School_Code_Detail_Page__c', 'School_Area__c', 'School_City__c', 'AccountId',
                    'No_of_Students__c', 'Students_Gender__c', 'Zone_Type__c', 'Coordinator_Name__c',
                    'Phone_Number__c', 'Bus_Internal_Number__c', 'Description'
                ];
                break;
             case 'Students Awareness Session Request':
                keys = [
                   'CaseNumber', 'School_Code_Detail_Page__c', 'School_Area__c', 'School_City__c', 'AccountId','Emirates__c',
                    'No_of_Attendance__c', 'Awareness_Session_Location__c', 'Coordinator_Name__c', 'Preferred_Date__c',
                    'Preferred_End_Date__c', 'Bus_Supervisor_Available__c', 'No_of_Attendance__c','Coordinator_Number__c',
                    'Awareness_Session_Location__c','LandMark__c','Program_Type__c',
                ];
                break;

            default:
                alert('No valid record type for export.');
                return null;
        }

        const columnDivider = ',';
        const lineDivider = '\n';

        // Construct CSV header
        let csvStringResult = keys.join(columnDivider) + lineDivider;

        // Construct CSV rows
        records.forEach(record => {
            const row = keys.map(key => {
            let cellValue = record[key];
            
            if (typeof cellValue === 'object' && cellValue !== null) {
            if (key === 'RecordType') {
            return '"' + (cellValue.Name || '') + '"';
        }
                        if (key === 'Account') {
               return '"' + (cellValue.Name || '') + '"';
        }
      
        return '""';
    }
    
    cellValue = cellValue === undefined || cellValue === null ? '' : cellValue;
    return '"' + cellValue + '"';
});

            csvStringResult += row.join(columnDivider) + lineDivider;
        });

        return csvStringResult;
    },
    
 showToast: function(title, message, type) {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "title": title,
            "message": message,
            "type": type
        });
        toastEvent.fire();
    },
    getDefaultDepartment: function(selectedDepartMents) {
        // Implement logic to determine the default department based on the selected case type
        // This is a simplified example; adjust based on your actual data model
        var returnCaseType = {
            'Pending Hemam for Inclusive Education services': 'Special Needs Services Transport or Nanny Request',
            'Pending with Inclusive Education Department in ESE': 'Special Needs Services Transport or Nanny Request',
            'Pending with Department Of School Services': 'Special Needs Services Transport or Nanny Request',
            'Pending with Operation Manager': 'Companian - Handicap Transportation',
            'Pending with Operation Supervisors': 'Companian - Handicap Transportation',
            'Pending with Department Of School Activities': 'Activities and Events Requests',
            'Pending with MOE - Personnel Affairs': '',
            'Pending with Head of Safety Unit': 'Students Awareness Session Request'
            // Add more mappings for other case types
        };

        return returnCaseType[selectedDepartMents] || null;
    },
        getCancelbtnlogic: function(component, event, helper) {
            debugger;
      
        var allCaseData = component.get('v.currentData');
       // console.log("json data "+JSON.stringify(allCaseData));
        // Adding forEach loop
        allCaseData.forEach(function(caseItem) {
            var createdTime = new Date(caseItem.CreatedDate);
            var currentTime = new Date();
            var timeDifference = currentTime - createdTime;
            var timeDifferenceInHours = timeDifference / (1000 * 60);
            
            // Display the time difference
           
            if (timeDifferenceInHours > 5) {
                component.set("v.showCancelButton", true);
                console.log("Cancel button should be visible now");
            } else {
                component.set("v.showCancelButton", false);
                console.log("Cancel button should be hidden initially");
            }
        });
        
    },
    
    
})
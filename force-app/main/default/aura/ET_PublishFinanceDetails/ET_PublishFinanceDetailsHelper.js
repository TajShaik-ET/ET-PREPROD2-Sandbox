({
    doInit : function(component, event, helper)  {
        component.set('v.loaded',false);
        var exeAction = component.get("c.getZoneList");
        exeAction.setParams({
            // "policyNumber":component.get("v.cardNumber")
            
        });
        this.serverSideCall(component,exeAction).then(
            function(res) {
                component.set('v.zoneList',res.zoneList);
                component.set('v.activityList',res.activityList);
                component.set('v.loaded',true);
            }
        ).catch(
            function(error) {
                component.set('v.loaded',true);
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
    getLocations: function(component, event, helper)  {
        component.set('v.loaded',false);
        var exeAction = component.get("c.getZoneLocations");
        exeAction.setParams({
            "zone":component.get("v.selectedZone")
            
        });
        this.serverSideCall(component,exeAction).then(
            function(res) {
                component.set('v.locationList',res);
                component.set('v.loaded',true);
            }
        ).catch(
            function(error) {
                component.set('v.loaded',true);
                console.log('Error---'+JSON.stringify(error));
            }
        );
    },
    getInvoiceDetailsHelper: function(component, event, helper)  {
        var spinner = component.find("mySpinner");
        $A.util.removeClass(spinner, "slds-hide");
        component.set('v.loaded',false);
        var exeAction = component.get("c.getInvoiceByLoc");
        exeAction.setParams({
            "zone":component.get("v.selectedZone"),
            "location":component.get("v.selectedLocation"),
            "activity":component.get("v.selectedActivity"),
            "type":component.get("v.selectedPaymentType"),
            "startDate":component.get("v.selectedStartDate"),
            "endDate":component.get("v.selectedEndDate")    
            
        });
        this.serverSideCall(component,exeAction).then(
            function(res) {
                /*component.set('v.columns', [
             // {label: 'Coordinator Name', fieldName: 'coordinatorName', sortable : true,type: 'text'},
              {label: 'Total Amount', fieldName: 'totalAmount', sortable : true,type: 'text'}, 
              {label: 'Count', fieldName: 'invCount', sortable : true,type: 'text'} 
        ]); */
                $A.util.addClass(spinner, "slds-hide");
                var invoiceList = [];
                for (var key in res) {
                    invoiceList.push({"key":key, "value":res[key]});
                }
                console.log('invoiceList',invoiceList);
                component.set('v.invoiceList',invoiceList);
                component.set('v.loaded',true);
            }
        ).catch(
            function(error) {
                component.set('v.loaded',true);
                console.log('91Error---'+JSON.stringify(error));
            }
        );
    },
    getInvoiceListHelper: function(component, event, helper, coordinator, schoolname)  { //Added by Sreelakshmi SK --22 Mar 2023 (schoolname)
        component.set('v.loaded',false);
        console.log('Helper School Name:'+schoolname);
        var exeAction = component.get("c.getReceiptDetails");
        exeAction.setParams({
            "coordinator":coordinator,
            "type":component.get("v.selectedPaymentType"),
            "SchoolName":schoolname,
        });
        this.serverSideCall(component,exeAction).then(
            function(res) {
                console.log('res:'+JSON.stringify(res));
                component.set('v.columns', [
                     {label: 'Ref. No.', fieldName: 'refurl', type: 'url', typeAttributes: { label: { fieldName: 'Name' }, target: '_blank' }},
                    {label: 'SID', fieldName: 'SID', sortable : true,type: 'text'},
                    {label: 'School', fieldName: 'schoolName', sortable : true,type: 'text'},
                    {label: 'Service Type', fieldName: 'service', sortable : true,type: 'text'},
                    {label: 'Transport Type', fieldName: 'type', sortable : true,type: 'text'},
                    {label: 'Duration Start', fieldName: 'startDt', sortable : true,type: 'Date',
                     typeAttributes:{month: "2-digit",day: "2-digit",year: "numeric"}} ,
                    {label: 'Duration End', fieldName: 'endDt', sortable : true,type: 'Date',
                     typeAttributes:{month: "2-digit",day: "2-digit",year: "numeric"}}, 
                    {label: 'Student Name', fieldName: 'studentName', sortable : true,type: 'text'},
                    {label: 'Parent Name', fieldName: 'parentName', sortable : true,type: 'text'},
                    {label: 'Mobile No.', fieldName: 'mobile', sortable : true,type: 'text'},
                    {label: 'Total Amount', fieldName: 'ET_Amount__c', sortable : true,type: 'number'}, 
                    {label: 'Payment Mode', fieldName: 'Payment_Mode__c', sortable : true,type: 'text'}, 
                    {label: 'Auth. Code', fieldName: 'AuthCode', sortable : true,type: 'text'}, 
                    {label: 'createdDate', fieldName: 'CreatedDate', sortable : true,type: 'Date',
                     typeAttributes:{month: "2-digit",day: "2-digit",year: "numeric"}} 
                ]); 
                console.log('res1:'+JSON.stringify(res));
                console.log('res.length:'+res.length);
                for (var i = 0; i < res.length; i++) { 
                    console.log('Entered for loop');
                    console.log('res[i]:'+JSON.stringify(res[i])); 
                    var row = res[i]; 
                    console.log('row.ET_Payment__r:'+row.ET_Payment__r);
                    row.refurl='/'+row.Id;
                    if (row.ET_Service_Request__r) { 
                        console.log('Entered if loop 1');
                        row.service = row.ET_Service_Request__r.ETST_Service_Type__c;
                        row.type = row.ET_Service_Request__r.ETST_Transport_Type__c;
                        row.startDt = row.ET_Service_Request__r.ETST_Pick_Up_Start_Date__c;
                        row.endDt = row.ET_Service_Request__r.ETST_Pick_Up_End_Date__c;
                        
                    }
                    if (row.ET_Service_Request__r.ETST_Student__r) { 
                        console.log('Entered if loop 2');
                        row.studentName =  row.ET_Service_Request__r.ETST_Student__r.ETST_First_Name__c+' '+row.ET_Service_Request__r.ETST_Student__r.Name;
                        console.log('row.studentName:'+row.studentName);
                        row.SID =  row.ET_Service_Request__r.ETST_Student__r.ETST_Student_Id__c;
                        console.log('row.SID:'+row.SID);
                        row.parentName = row.ET_Service_Request__r.ET_Account__r.Name;
                        console.log('row.parentName:'+row.parentName);
                        row.mobile = row.ET_Service_Request__r.ETST_Student__r.ETST_Phone__c;
                        console.log('row.mobile:'+row.mobile);
                        row.schoolName=row.ET_Service_Request__r.ETST_Student__r.ETST_Student_School__c;
                        console.log('row.schoolName:'+row.schoolName);
                        
                        console.log('row.ET_Payment__r:'+row.ET_Payment__r);
                    }
                    console.log('row.ET_Payment__r:'+row.ET_Payment__r);
                    if (row.ET_Payment__r) { 
                        console.log('Entered if loop 3');
                        row.AuthCode =  row.ET_Payment__r.ETST_AuthorizationCode__c;
                      }
                  console.log('res---'+JSON.stringify(res));  
                }
               
                console.log('res---'+JSON.stringify(res));
                component.set('v.invoicesDetails',res);
                component.set('v.loaded',true);
            }
        ).catch(
            function(error) {
                
                component.set('v.loaded',true);
                console.log('Error1---'+JSON.stringify(error));
            }
        );
    },
    publishFinDetailsHelper: function(component, event, helper,coordinator, schoolname){ // coordinator and schoolname- added by Sreelakshmi SK 31/3/2023
        var spinner = component.find("mySpinner1");
        $A.util.removeClass(spinner, "slds-hide");
        var exeAction = component.get("c.saveFinanceDocument");
        exeAction.setParams({
            "zone": component.get("v.selectedZone"),
            "location": component.get("v.selectedLocation"),
            "activity": component.get("v.selectedActivity"),
            "type": component.get("v.selectedPaymentType"),
            "lines": JSON.stringify(component.get('v.invoiceList')),
            "StartDate":component.get("v.selectedStartDate"), //added by Sreelakshmi SK 2/5/2023
            "EndDate":component.get("v.selectedEndDate"), //added by Sreelakshmi SK 2/5/2023
            //"coordinator":coordinator, //added by Sreelakshmi SK 31/3/2023
           // "SchoolName":schoolname //added by Sreelakshmi SK 31/3/2023
        });
        this.serverSideCall(component,exeAction).then(
            function(res) {
                    /*var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        "title": "Success!",
                        "type": "succcess",
                        "message": "This Document is submitted successfully."+res.Id
                    });
                    toastEvent.fire();*/
              /*  var urlEvent = $A.get("e.force:navigateToURL");
                urlEvent.setParams({
                    "url": "/"+res.Id
                });
                urlEvent.fire();
                */
                    $A.util.addClass(spinner, "slds-hide");
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        "title": "Success",
                        "message": "Finance Document has been published successfully.",
                        "type": "success"
                    });
                    toastEvent.fire();
                // $A.get("e.force:refreshView").fire();
            }
        ).catch(
            function(error) {
                console.log('Error---'+JSON.stringify(error));
            }
        );
    },
    validateForm : function(component) {
        var mandatoryFieldsList = component.get("v.mandatoryFields");
        var mandatoryFieldsCmps = [];
        var allValid=false;
        for(var id in mandatoryFieldsList){
            mandatoryFieldsCmps.push(component.find(mandatoryFieldsList[id]));
        }
        if(mandatoryFieldsList.length!=undefined && mandatoryFieldsList.length > 0){
            allValid =mandatoryFieldsCmps.reduce(function (validSoFar, inputCmp) {
                inputCmp.showHelpMessageIfInvalid();
                return validSoFar && !inputCmp.get('v.validity').valueMissing;
            }, true);
        }
        console.log('allValid'+allValid);
        return allValid;
    },
     convertArrayOfObjectsToCSV : function(component,objRecords,type) {
        
        var csvStringResult,counter,keys,lineDivider,columnDivider;
        if(objRecords==null || !objRecords.length)
        {
            return null;         
        }
        columnDivider=',';
        lineDivider='\n';
        keys=['Name','SID','schoolName','service','type','startDt','endDt',
              'studentName','parentName','mobile','AuthCode','ET_Amount__c','Payment_Mode__c',
             'CreatedDate'];
        
        
        csvStringResult='';
        //csvStringResult+=keys.join(columnDivider);
        csvStringResult+=['Ref. No.','SID','School Name','Service Type','Transport Type',
                          'Duration Start','Duration End','Student Name','Parent Name','Mobile No.','Auth. Code',
                         'Amount','Payment mode','Created Date'];
        csvStringResult+=lineDivider;
        
        for(var i=0;i<objRecords.length;i++)
        {
            
            counter=0;
            for(var tempKey in keys)
            {
                var skey=keys[tempKey];
                
                if(counter>0)
                {
                    csvStringResult+=columnDivider;
                }
                // Querying standard related object field
                if(typeof objRecords[i][skey]==='object' && skey==='RecordType'){
                    csvStringResult+='"'+objRecords[i][skey].Name+'"';
                    counter ++;
                }
                // Querying custom related object field
                else if(typeof objRecords[i][skey]==='object' && (skey==='ETST_Student__r')){
                    csvStringResult+='"'+objRecords[i][skey].ETST_Student_School__c+'"';
                    csvStringResult+=columnDivider;
                    csvStringResult+='"'+objRecords[i][skey].ETST_Phone__c+'"'; 
                }  
                else if(typeof objRecords[i][skey]==='object' && (skey==='ET_Payment__r')){
                    csvStringResult+='"'+objRecords[i][skey].ETST_AuthorizationCode__c+'"';
                    csvStringResult+=columnDivider; 
                }
                // Querying same object field
                    else{
                        csvStringResult+='"'+objRecords[i][skey]+'"';
                        counter ++;
                    }
                
            }
            csvStringResult+=lineDivider;
            
        }
        
        return csvStringResult;
    },
})
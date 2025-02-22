({
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
    
    getSearchResult :function(component, event, helper) {
        component.set("v.showSpinner2",true);
        component.set('v.InsuranceColumns', [
            
            {label: 'Ref Number', fieldName: 'link2', type: 'url',sortable:true,typeAttributes: { label:  { fieldName: 'Name' }, target:'_blank'}},
            // {label: 'Emirates ID', fieldName: 'emiratesID', type: 'text'},
            //{label: 'Card Number', fieldName: 'Card_Number__c'},
            {label: 'Employee', fieldName: 'Emplink',type: 'url',sortable:true,typeAttributes: { label:  { fieldName: 'FulName' }, target:'_blank'}},
            {label: 'Emp ID', fieldName: 'Employee_ID__c',type: 'text',sortable:true },
            {label: 'Gender', fieldName: 'ETIN_Gender__c',type: 'text' }, 
            {label: 'Marital Status', fieldName: 'Marital_Status__c', type: 'text',sortable:true},
            {label: 'Relation', fieldName: 'Relation__c', type: 'text',sortable:true},
            {label: 'Name', fieldName: 'Member_Name__c',type: 'text',sortable:true },
            {label: 'Location', fieldName: 'Location__c', type: 'text',sortable:true},
            {label: 'ETIN Employee Zone', fieldName: 'ETIN_Employee_Zone__c', type: 'text',sortable:true},
            {label: 'Plan', fieldName: 'Plan__c', type: 'text',sortable:true},           
            /*{label: 'Effective Date', fieldName: 'Effective_Date__c', type: 'date'},
             {label: 'Expire Date', fieldName: 'Expiry_Date__c', type: 'date'}  */
            {label: 'Created By', fieldName: 'CreatedByName', type: 'text',sortable:true}
            
            
          ]);
        
        var exeAction = component.get("c.getInsuranceDetails");
        exeAction.setParams({
            "Location":component.get("v.locationVal")
            
        });
        exeAction.setCallback(this, function(response) {
            
            var state = response.getState();
            if (state === "SUCCESS") {  
                
                var records=response.getReturnValue();
                
                records.forEach(function(record){
                    record.link2 = '/'+record.Id;
                    //record.emiratesID = record.EmployeeAcc__r.ET_Emirates_Id__c;
                    record.FulName = record.EmployeeAcc__r.Name;  
                    record.CreatedByName =  record.CreatedBy.Name;
                    
                    if(record.EmployeeAcc__c){
                        record.Emplink = '/'+record.EmployeeAcc__c;
                    }else{
                        record.Emplink='';
                    }
                });
                component.set('v.Insurancedata',response.getReturnValue());
                component.set("v.showSpinner2",false);
                console.log('--data--')
            }else if (state === "ERROR") {
                component.set("v.showSpinner2",false);
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error message: " + errors[0].message);
                        var toastReference = $A.get("e.force:showToast");
                        toastReference.setParams({
                            "type":"Error",
                            "title":"Error",
                            "message":'Please check with System admin'+errors[0].message,
                            "mode":"sticky"
                        });
                        toastReference.fire();
                    }
                } else {
                    component.set("v.showSpinner2",false);
                    console.log("Unknown error");
                    
                    
                }
            }
        });
        
        $A.enqueueAction(exeAction); 
    },
    
    getPartnerEmailDetails : function(component, event, helper) {
        
        var exeAction = component.get("c.getEmailDetails");
        console.log('locationVal'+component.get("v.locationVal"))
        exeAction.setParams({
            "Location":component.get("v.locationVal")
            
        });
        this.serverSideCall(component,exeAction).then(
            function(res) { 
                console.log('--emails--'+res);
                
                component.set("v.ServerEmailVal",res.toString());  
            });
        
        
    },
    
    SendEmailToPartner :function(component, event, helper) {
        
        
        component.set("v.showSpinner", true);
        console.log(component.get("v.finalFileList"))
        var exeAction = component.get("c.sendEmailWithDocs");
        exeAction.setParams({
            "toAdd":component.get("v.emailVal"),
            "Subject":component.get("v.subject"),
            "Body":component.get("v.body"),
            "InsList":component.get("v.SelectedRecordlist"),
            "extraDocs":component.get("v.SelectedDocList"),
            "ApiStringRes": JSON.stringify(component.get("v.ApifieldsString")),
            "HeaderLabelsRes": JSON.stringify(component.get("v.HeaderLabels")),
            "fileUpload":component.get("v.finalFileList")?JSON.stringify(component.get("v.finalFileList")):''
        });
        
        exeAction.setCallback(this, function(response) {
            let state = response.getState();
            if (state === "SUCCESS") {
                // Process server success response
                component.set("v.selectedRows",[]);            
                component.set("v.showSpinner", false);
                helper.showToastMsg(component, event, helper,'success','success','Email has been sent successfully');
                helper.closePopupHelper(component, event, helper);
                helper.getSearchResult(component, event, helper);
                
                $A.get("e.force:closeQuickAction").fire();
                //$A.get('e.force:refreshView').fire(); //commented by Janardhan -04/07/22
                
            }
            else if (state === "ERROR") {
                let errors = response.getError();
                component.set("v.showSpinner", false);
                console.log('Error---'+errors[0].message);
                helper.showToastMsg(component, event, helper,'error','error','Please check with system admin - '+errors[0].message);
                
            }
                else {
                    // Handle other reponse states
                }
            
        });
        $A.enqueueAction(exeAction);
        
       /* this.serverSideCall(component,exeAction).then(
            function(res) { 
            
               
                
            }).catch(
            function(error) {
                
               
            }
        );*/
              
    },
    
    showToastMsg : function(component, event, helper,msgType,title,msg) {
        
        var toastReference = $A.get("e.force:showToast");
        toastReference.setParams({
            "type":msgType,
            "title":title,
            "message":msg,
            "mode":"dismissible"
        });
        toastReference.fire();
    },
    
    getInsRelatedLibraryFiles : function(component, event, helper) {
        
          component.set('v.ContentDocDataColumns', [
          
           {label: 'Title', fieldName: 'Title', type: 'text'},
           {label: 'File Type', fieldName: 'FileType',type: 'text'}
           
              ]);
        
         var exeAction = component.get("c.getInsLibraryFiles");
         exeAction.setCallback(this, function(response) {
            let state = response.getState();
             if (state === "SUCCESS") {
                 
                 component.set("v.ContentDocData",response.getReturnValue());
             } 
         
         });
        $A.enqueueAction(exeAction);
    },
    
     closePopupHelper : function(component, event, helper) {
        
        component.set("v.showPopup",false);
        component.set("v.emailVal", null);
        component.set("v.subject", null);
        component.set("v.body", null);
        component.set("v.finalFileList", null);
        
    },
    
   getReportGenerateFile : function(component, event, helper){
        
                      
    var exeAction = component.get("c.getreportDetails");
         exeAction.setParams({
            "Location":component.get("v.locationVal")
           
        });
       
       this.serverSideCall(component,exeAction).then(
            function(res) {
             
               var reportResultData = JSON.parse(res);
              //console.log('reportResultData'+JSON.stringify(reportResultData));
                
                var reportHeaderLabels =[];
                var reportHeaderLabelsWOspace =[];
                var rowLength = reportResultData.factMap['T!T'].rows.length;
                var HeaderLeng  =  reportResultData.reportExtendedMetadata.detailColumnInfo;
                
               
                 var detailColumn =  reportResultData.reportMetadata.detailColumns;
                
                var CsvString = [];
                for(var i=0; i < detailColumn.length; i++){
                var extension = detailColumn[i].substr(detailColumn[i].lastIndexOf(".") + 1);
                   CsvString.push(extension.replace('CUST_NAME','NAME'));
                }
               component.set("v.ApifieldsString",CsvString);
               
                
                for(var i=0; i < detailColumn.length; i++){
                    
                    var det = detailColumn[i];                 
                    reportHeaderLabels.push(HeaderLeng[det].label);
                    var ss = HeaderLeng[det].label.replace(/\s/g, '');
                    reportHeaderLabelsWOspace.push(ss);
                }
                             
                component.set("v.HeaderLabels",reportHeaderLabels);
                console.log('--reports--')
                
              /*  var dataCellLength = reportResultData.factMap['T!T'].rows[0].dataCells.length;
                
                var chartData = [];
                
                for(var i=0; i < rowLength; i++){
                    
                    var chartLabels = {};   
                    var tempval ='';
                    for(var j=0; j < dataCellLength; j++){
                        
                        var datacellval = reportResultData.factMap['T!T'].rows[i].dataCells[j].label;
                        
                        var sss = reportHeaderLabels[j];
                        var st = sss.replace(/\s/g, '');
                        //console.log(st);
                        
                        Object.assign(chartLabels, {[st]:datacellval });                   
                        
                    }
                  
                   //console.log('chartLabels--'+JSON.stringify(chartLabels));
               
						chartData.push(chartLabels);                 
                }
                 
                  //console.log('chardata--'+JSON.stringify(chartData));
                 // component.set("v.reportData",chartData);   
                
                var csvStringResult, counter, keys, keys1,columnDivider, lineDivider;
                columnDivider = ',';
                lineDivider =  '\n';
                
                keys = reportHeaderLabelsWOspace;
               keys1 = reportHeaderLabels;
              
                csvStringResult = '';
                csvStringResult += keys1.join(columnDivider);
                csvStringResult += lineDivider;
                 
                for(var i=0; i < chartData.length; i++){ 
                    
                   counter = 0;
                    for(var sTempkey in keys) {
                        var skey = keys[sTempkey] ; 
                        if(counter > 0){ 
                            csvStringResult += columnDivider; 
                        }  
                        csvStringResult += '"'+ chartData[i][skey]+'"'; 
                        
                        counter++;
                        
                    }
                     csvStringResult += lineDivider;
                    
                }
                     */         
            //component.set("v.csvResultString",csvStringResult);
                          
                
            }
        ).catch(
            function(error) {
                
                alert('Error - while generating report, Please check respective reports has data.')
                
               console.log('Error--getReportGenerateFile'+JSON.stringify(error));
            }
        );
        
           
    },
    
    
    upload: function(component, file, base64Data, callback) {
        var Filelist=[];
        var finalFileList = component.get("v.finalFileList");
        
        finalFileList.push({name :file.name,base64Data:base64Data,contentType: file.type});
        
        component.set("v.finalFileList",finalFileList);        
        //console.log('---'+file.type);
        
    },
    
    sortData: function (component, fieldName, sortDirection) {
        var fname = fieldName;
        var data = component.get("v.Insurancedata");
        var reverse = sortDirection !== 'asc';
        data.sort(this.sortByfield(fieldName, reverse))
        component.set("v.Insurancedata", data);
    },
    
    sortByfield: function (field, reverse) {
        var key = function(x) {return x[field]};
        reverse = !reverse ? 1 : -1;
        return function (a, b) {
            return a = key(a), b = key(b), reverse * ((a > b) - (b > a));
        }
    },
    
    //Added by Arunsarathy on 14.12.2022
    getUserDetails: function (component,event, helper){

       var action = component.get('c.currentUserDetailMethod');
		
        action.setCallback(this, function(response) {
            var state = response.getState();
			var res = response.getReturnValue();
            
            if (state === "SUCCESS") {  
                component.set("v.userDetails", res);
               
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
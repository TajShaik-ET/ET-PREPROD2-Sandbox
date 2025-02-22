({
    doInit : function(component, event, helper) {
        component.set('v.columns', [
            {label: 'Name', fieldName: 'navUrl', sortable : true,type: 'url', 
             typeAttributes: {label:{ fieldName: 'Name'},target:'_blank'} 
             },
            {label: 'Student Name', fieldName: 'studentUrl', sortable : true, type: 'url', 
             typeAttributes: {label:{ fieldName: 'ETST_Student_Name__c'},target:'_blank'} 
             },
            {label: 'School', fieldName: 'schoolName', sortable : true,type: 'text'},
            //{label: 'Student Id', fieldName: 'studentId', sortable : true,type: 'text'},
            {label: 'Phone', fieldName: 'studentPhone', sortable : true,type: 'text'},
            //{label: 'Zone', fieldName: 'ETST_Area_Zone__c', sortable : true,type: 'text'}, 
            //{label: 'Payee', fieldName: 'ETST_Payee__c', sortable : true,type: 'text'}, 
            {label: 'Pickup', fieldName: 'ETST_Pick_Up_From__c', sortable : true,type: 'text'},
            {label: 'Drop Off', fieldName: 'ETST_Drop_Off_To__c', sortable : true,type: 'text'},
             {label: 'Start Date', fieldName: 'ETST_Pick_Up_Start_Date__c',sortable : true, type: 'date', typeAttributes: {  
                            day: 'numeric',  
                            month: 'numeric',  
                            year: 'numeric',  
                            hour: '2-digit',  
                            minute: '2-digit',  
                            timeZone: "Asia/Dubai",
                            hour12: false}},
            {label: 'Expiry Date', fieldName: 'ETST_Pick_Up_End_Date__c',sortable : true, type: 'date', typeAttributes: {  
                            day: 'numeric',  
                            month: 'numeric',  
                            year: 'numeric',  
                            hour: '2-digit',  
                            minute: '2-digit',  
                            timeZone: "Asia/Dubai",
                            hour12: false}},
            {label: 'Fare', fieldName: 'ETST_Fare_Charges__c',sortable : true, type: 'number',
             typeAttributes: { maximumFractionDigits: '2' }},
            {label: 'Status', fieldName: 'ETST_Status__c',sortable : true, type: 'text'},
            {label: 'Comments', fieldName: 'ETST_Coordinator_Comments__c',sortable : true, type: 'text'}
        ]); 
        helper.doInit(component, event, helper);
    },
    setFilterRequests: function(component, event, helper) {
        var filterVal=event.getSource().get('v.value');
        if(filterVal==1){
            component.set('v.filterBySchool',event.getSource().get('v.checked'));
            if(!component.get('v.filterBySchool')){
                component.set("v.selectedSchool",'');
                helper.getData(component, event, helper);
            }
        }else if(filterVal==2){
            component.set('v.filterByPayee',event.getSource().get('v.checked'));
             if(!component.get('v.filterByPayee')){
                component.set("v.selectedPayee",'');
                 helper.getData(component, event, helper);
            }
        }else if(filterVal==3){
            component.set('v.filterByStatus',event.getSource().get('v.checked'));
             if(!component.get('v.filterByStatus')){
                component.set("v.selectedStatus",'');
                 helper.getData(component, event, helper);
            }
        }
    },
    filterRequests: function(component, event, helper) {
        if(component.get('v.selectedStatus')==$A.get("$Label.c.ETST_Under_Review")){
             component.set("v.hideCheckbox",false);
        }else{
           component.set("v.hideCheckbox",true); 
        }
          helper.getData(component, event, helper);
    },
    handleLoadMore:  function(component, event, helper) {
        //event.getSource().set("v.isLoading", true);        
        var pageNo=component.get("v.pageNo");
        component.set("v.pageNo",pageNo+1);
        helper.getData(component, event, helper);
        
    },
    handleSort : function(component,event,helper){
        var sortBy = event.getParam("fieldName");
        var sortDirection = event.getParam("sortDirection");
        component.set("v.sortBy",sortBy);
        component.set("v.sortDirection",sortDirection);
        helper.sortData(component,sortBy,sortDirection);
    },
    openConfirmModal: function(component,event,helper){
         var status=event.getSource().get('v.value');
         component.set("v.status",status);
        var records=component.get("v.serviceRecordIds");
        if(records==null || records==''){
            alert('Please select atleast a record!');
        }else{
         component.set("v.confirmFlag",true);
        }
    },
    closeConfirmModal: function(component,event,helper){
         component.set("v.confirmFlag",false);
    },
    changeStatus: function(component,event,helper){
         component.set("v.confirmFlag",false);
         
         helper.updateTransportRequestStatus(component,event,helper); 
     
         
    },
    updateSelectedRecords: function(component,event,helper){
         var selectedRows = event.getParam('selectedRows');
         var setRows = [];
         for ( var i = 0; i < selectedRows.length; i++ ) {
            
            setRows.push(selectedRows[i].Id);

         }
        component.set("v.serviceRecordIds", setRows);
        
        // helper.updateTransportRequestStatus(component,event,helper,selectedRows);
    },
    searchRequest: function(component, event, helper) {
        var searchKey=component.get('v.searchText'); 
        if(searchKey.length>2){
            var data = component.get('v.data'); 
            console.log('data'+JSON.stringify(data));
            var fileredData =  data.filter(function(item) {
                return (item.Name.indexOf(searchKey) !== -1)||
                 (item.ETST_Student__r.Name.toLowerCase().indexOf(searchKey.toLowerCase()) !== -1)||
                 (item.ETST_Student__r.ETST_Student_Id__c.indexOf(searchKey) !== -1)||
                 (item.ETST_Student__r.ETST_Phone__c.indexOf(searchKey) !== -1)||
                (item.ETST_Student__r.ETST_School_Name__r.Name.toLowerCase().indexOf(searchKey.toLowerCase()) !== -1);
            });
              component.set('v.currentData',fileredData);
             console.log('currentData'+JSON.stringify(fileredData));
            //component.set('v.totalRecords',fileredData.size); 
        }else{
            component.set("v.currentData",component.get("v.data"));
        }
    
    },
    downloadData :function(component, event, helper){
         
        var allResources=component.get("v.currentData");
        var csv=helper.convertArrayOfObjectsToCSV(component,allResources); 
        if(csv==null)
        {
			return ;
        }                         
        var elementLink=document.createElement('a');
        elementLink.href='data:text/csv;charset=utf-8,'+encodeURI(csv);
        elementLink.target='_self';
        elementLink.download='TransportRequests.csv';
        document.body.appendChild(elementLink);
        elementLink.click();
        $A.get('e.force:refreshView').fire();   
    },
})
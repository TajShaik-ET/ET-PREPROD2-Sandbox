({
    doInit : function(component, event, helper) {
        component.set('v.columns', [
            {label: 'Case Number', fieldName: 'navUrl', sortable : true,type: 'url', 
             typeAttributes: {label:{ fieldName: 'CaseNumber'},target:'_blank'} 
            },
            {label: 'Status', fieldName: 'Status', sortable : true,type: 'text'},
            {label: 'Recent Activity', fieldName: 'Sub_Status__c', sortable : true,type: 'text'},
            {label: 'Next Activity', fieldName: 'Status_Category__c', sortable : true,type: 'text'},
            {label: 'Subject', fieldName: 'Subject', sortable : true,type: 'text'}, 
            {label: 'Created Date', fieldName: 'CreatedDate',sortable : true, type: 'date', 
             typeAttributes: {  
                 day: 'numeric',  
                 month: 'numeric',  
                 year: 'numeric',  
                 hour: '2-digit',  
                 minute: '2-digit',  
                 timeZone: "Asia/Dubai",
                 hour12: false}}
        ]); 
        helper.getCaseData(component, event, helper);
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
        if(component.get('v.selectedStatus')=='Pending with Coordinator'){
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
        component.set("v.caseCommentsRequired", false);
        var status=event.getSource().get('v.value');
        component.set("v.status",status);   
        var records=component.get("v.caseIds");
        if(status === 'Reject' || status === 'Reply'){
            component.set("v.caseCommentsRequired", true);
        }
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
        var status=component.get("v.status");
        var ccmRemarks=component.get("v.ccmRemarks");
        var Solution=component.get("v.Solution");
        var comments = component.get("v.comments"); 
        if((status == 'Reject' || status == 'Reply') && comments !=null && comments !=''){
            helper.updateCaseStatus(component,event,helper);
        } else{
            helper.updateCaseStatus(component,event,helper);
        }
    },
    updateSelectedRecords: function(component,event,helper){
        var selectedRows = event.getParam('selectedRows');
        var setRows = [];
        for ( var i = 0; i < selectedRows.length; i++ ) {
            setRows.push(selectedRows[i].Id);
        }
        component.set("v.caseIds", setRows);
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
        
    }
})
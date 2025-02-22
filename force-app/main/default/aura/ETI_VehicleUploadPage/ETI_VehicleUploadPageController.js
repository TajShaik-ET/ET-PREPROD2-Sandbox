({
	doInit : function(component, event, helper) {
         var actions = [
            { label: 'Download', name: 'Download' },
            { label: 'Upload', name: 'upload' }
        ];
        component.set('v.columns', [
            /*{label: 'User Name', fieldName: 'userName', sortable : true,type: 'url', 
             typeAttributes: {label:{ fieldName: 'userName'},target:'_blank'} 
             },*/
           {label: 'User Name', fieldName: 'userName',sortable : true, type: 'text'},
           {label: 'File Name', fieldName: 'ETI_File_Name__c',sortable : true, type: 'text'},
           {label: 'Created Date', fieldName: 'CreatedDate',sortable : true, type: 'date', typeAttributes: {  
                            day: 'numeric',  
                            month: 'numeric',  
                            year: 'numeric',  
                            hour: '2-digit',  
                            minute: '2-digit',  
                            timeZone: "Asia/Dubai",
                            hour12: false}}, 
          { type: 'action', typeAttributes: { rowActions: actions } }
  
        ]); 
		helper.doInit(component, event, helper);
	},
    handleRowAction: function (component, event, helper) {
        var action = event.getParam('action');
        var row = event.getParam('row');

        switch (action.name) {
            case 'Download':
                helper.viewDocument(component, row, helper);
                break;
            case 'upload':
                helper.uploadDocument(component, row, helper);
                break;
        }
    },
     handleLoadMore:  function(component, event, helper) {
        //event.getSource().set("v.isLoading", true);        
        var pageNo=component.get("v.pageNo");
        component.set("v.pageNo",pageNo+1);
        //helper.getData(component, event, helper);
        
    },
    handleSort : function(component,event,helper){
        var sortBy = event.getParam("fieldName");
        var sortDirection = event.getParam("sortDirection");
        component.set("v.sortBy",sortBy);
        component.set("v.sortDirection",sortDirection);
        //helper.sortData(component,sortBy,sortDirection);
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
    
    }
})
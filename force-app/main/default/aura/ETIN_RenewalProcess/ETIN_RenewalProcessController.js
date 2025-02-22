({
	doInit : function(component, event, helper) {
        
		helper.getCurrentInsuranceRecords(component, event, helper);
        helper.getTotalNumberOfRecords(component);
        helper.getLoggedUserDetails(component, event, helper);
	},
    
    handleLoadMoreRecords: function (component, event, helper) {
     
       if(component.get('v.data').length != component.get('v.totalNumberOfRows'))
         
        event.getSource().set("v.isLoading", true);
        component.set('v.loadMoreStatus', 'Loading....');
        helper.getMoreRecords(component, component.get('v.rowsToLoad')).then($A.getCallback(function (data) {
            if (component.get('v.data').length == component.get('v.totalNumberOfRows')) {
                component.set('v.enableInfiniteLoading', false);
                component.set('v.loadMoreStatus', 'No more data to load');
                
            } else {
                var currentData = component.get('v.data');
                var newData = currentData.concat(data);
                component.set('v.data', newData);
                component.set('v.loadMoreStatus', 'Please scroll down to load more data');
            }
            event.getSource().set("v.isLoading", false);
        }));
    },
    
    handleColumnSorting: function (component, event, helper) {
       
        var fieldName = event.getParam('fieldName');
        var sortDirection = event.getParam('sortDirection');
        component.set("v.sortedBy", fieldName);
        component.set("v.sortedDirection", sortDirection);
        helper.sortData(component, fieldName, sortDirection);
    },
    
    handleSelectedRow: function(component, event, helper){
        var selectedRows = event.getParam('selectedRows');
               
        component.set("v.selectedRowsCount", selectedRows.length);
        let obj =[] ; 
        let error = [];
        for (var i = 0; i < selectedRows.length; i++){
            obj.push({Name:selectedRows[i].Name});
            if(selectedRows[i].showClass == 'redcolor'){
                error.push(selectedRows[i].showClass);
            }
           
        }
         component.set("v.errList",error);         
        component.set("v.selectedRowsDetails", JSON.stringify(obj) );
        component.set("v.selectedRowsList", event.getParam('selectedRows'));
        
    },
    handleRowAction: function (component, event, helper) {
        var action = event.getParam('action');
        switch (action.name) {
            case 'dependent':
                helper.addDependentDetails(component, event);
                break;
                
            case 'emp':
                helper.editEmpDetails(component, event);
                break;
            
        }
    },
    handleSaveEdition : function (component, event, helper) {
        var draftValues = event.getParam('draftValues');
        console.log(draftValues);
        
        var action = component.get("c.updateInsurance");
        action.setParams({"acc" : draftValues});
        action.setCallback(this, function(response) {
            var state = response.getState();
            //$A.get('e.force:refreshView').fire();
            helper.getCurrentInsuranceRecords(component, event, helper);
        });
        $A.enqueueAction(action);
    },
    bulkRenewProcess :function (component, event,helper){
    
      var selectedRows =  component.get("v.selectedRowsList");
        
        if(selectedRows.length >= 1){
            
            if(component.get("v.errList").length >= 1){
                
                 helper.errorHandler(component, event,'Please unselect all the records highlighted in red');
            }else{
                 helper.HandleRenewalProcess(component, event,helper);
            }
            
           
        }else {
            
            helper.errorHandler(component, event,'Please select at least one record');
        }
            
    },
    
    closeEmpPopup : function (component, event,helper){
        
         component.set("v.showEmpPopup",false);
    },
    closeFamPopup :function (component, event,helper){
        component.set("v.showFamilyPopup",false);
    },
    handleSubmitEmp :function (component, event,helper){},
    handleSuccessEmp:function (component, event,helper){
         helper.getCurrentInsuranceRecords(component, event, helper);
         component.set("v.showEmpPopup",false);
    },
    handleSubmitFam :function (component, event,helper){},
    
    handleSuccessFam:function (component, event,helper){
        helper.getCurrentInsuranceRecords(component, event, helper);
         component.set("v.showFamilyPopup",false);
    },
        
})
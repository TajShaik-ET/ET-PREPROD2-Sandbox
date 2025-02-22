({
    searchField : function(component, event, helper) {
        
        var currentText = event.getSource().get("v.value");
        var resultBox = component.find('resultBox');      
              
        component.set("v.LoadingText", true);
        
        if(currentText.length > 0) {
            $A.util.addClass(resultBox, 'slds-is-open');
        }else {
            $A.util.removeClass(resultBox, 'slds-is-open');
        }
        try{
            if(currentText.length >1) {
                let timeOutId = component.get("v.timeOutId");
                window.clearTimeout(timeOutId); 
                
                timeOutId =  window.setTimeout(
                    $A.getCallback(function() {
                        helper.getSerchResults(component, event, helper,currentText)
                    }), 
                    500
                );
                component.set("v.timeOutId",timeOutId); 
            }            
            
        }catch(e){
            console.log(e.message)
        }
    },   
    
    setSelectedRecord : function(component, event, helper) { 
        var currentText = event.currentTarget.id;
        var resultBox = component.find('resultBox');
        $A.util.removeClass(resultBox, 'slds-is-open');
        var objectName = component.get("v.objectName");
       // alert(objectName);
        component.set("v.selectRecordName", event.currentTarget.dataset.name);
        component.set("v.selectRecordId", currentText);
        component.find('userinput').set("v.readonly", false);
        
        //To get complete Record Infomration
        let data = component.get("v.searchRecords");
        const result = data.filter(item => item.Id == currentText);
        component.set("v.selectedRecordInfo",result);
        
        //Calling Parent Component Method : ET_contract.cmp and passing required Info
        var parentComponent = component.get("v.callParentMethod");                         
        parentComponent.AutoFillData(component.get("v.rowIndex"),result,component.get("v.objectName"));
        
    }, 
    
    resetData : function(component, event, helper) {
        component.set("v.selectRecordName", "");
        component.set("v.selectRecordId", "");
        component.find('userinput').set("v.readonly", false);
    }
})
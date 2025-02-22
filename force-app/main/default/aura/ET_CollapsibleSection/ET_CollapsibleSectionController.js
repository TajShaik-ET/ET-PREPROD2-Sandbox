({
    handleSectionHeaderClick : function(component, event, helper) {
        var button = event.getSource();
        button.set('v.state', !button.get('v.state'));
        
        var sectionContainer = component.find('collapsibleSectionContainer');
        $A.util.toggleClass(sectionContainer, "slds-is-open");
    },
    handleRemove : function(component, event, helper) {
        $A.util.toggleClass(component.find('ConfirmDialog1'), 'slds-hide');
        
    },
    handleNo:function(component, event, helper){
        $A.util.toggleClass(component.find('ConfirmDialog1'), 'slds-hide');
    },
    handleYes:function(component, event, helper){
        $A.util.toggleClass(component.find('ConfirmDialog1'), 'slds-hide');
        var notifyRequirementTab = component.getEvent("notifyRequirementTab");
        //alert('in collapsible cmp :'+ component.get("v.lineItemNumber"));
        notifyRequirementTab.setParam(
                    "deletedlineItemNumber",component.get("v.lineItemNumber"));
        notifyRequirementTab.fire();
        component.destroy();
    },
    
    collaspseAll: function(component, event, helper){
        
        var button =  component.find('collapsibleBttn');
        //var addVehicleButton =  component.find('addVehicleBttn');
        
        if(!button.get('v.state')){
            button.set('v.state', !button.get('v.state'));
            
            var sectionContainer = component.find('collapsibleSectionContainer');
            $A.util.toggleClass(sectionContainer, "slds-is-open");
        }
        
    },
    expandSection: function(component, event, helper){
        var button =  component.find('collapsibleBttn');
        if(button.get('v.state')){
            button.set('v.state', !button.get('v.state'));
            
            var sectionContainer = component.find('collapsibleSectionContainer');
            $A.util.toggleClass(sectionContainer, "slds-is-open");
        }
    }

})
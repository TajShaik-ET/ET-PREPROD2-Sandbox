({
    doInit : function(component, event, helper) {
        helper.getLoctionValueHelper(component, event, helper);
        helper.getTypesHelper(component, event, helper);
    },
    saveOpp: function(component, event, helper) {
       
      var allValid=false;
        var location=component.find("LocationId").get("v.value");
        var description=component.find("DescriptionId").get("v.value");
        console.log('location -- '+location);
        console.log('description -- '+description);
        if(location!='' && description!=''){
            allValid=true;
        }
        if(allValid){
            helper.saveOppHelper(component, event, helper);
        }
        else{
            alert('Please fill all mandatory fields');
        }
       
    },
    openTransportModel : function(component, event, helper) {
        component.set('v.isOpenModel',true);
        component.set('v.type',event.getSource().get('v.value'));
      //  var desc = event.getSource().get('v.value') +' - ';
      //  component.set('v.opp.Description',desc); 
        //alert('tt'+event.getSource().get('v.value'));
        //helper.doInit(component, event, helper,'Transport and lease');
    },
    /*openMaintenanceModel : function(component, event, helper) {
		component.set('v.isOpenModel',true);
        helper.doInit(component, event, helper,'Maintenance');
	},*/
    closeModel: function(component, event, helper) {
        component.set('v.isOpenModel',false);
    },
    selectoptionvalue: function(component, event, helper) {
        var isSelected=event.getSource().get("v.value");
        //  alert('isSelected=== '+isSelected);
        var selectedVal=event.getSource().get("v.text");
        //  alert('selectedVal=== '+selectedVal);
        var selected=component.get('v.selectedCheckBoxes');
        for(var item in selected ){
            console.log('item=== '+item);
            console.log('selecteditem=== '+selected[item]);
            if(selected[item] == selectedVal && !isSelected){
                console.log('actual index=== '+item);
                selected.splice(item, 1);
            }
        }
        if(isSelected){
            selected.push(selectedVal);   
        }
        console.log('selected== '+selected);
        component.set('v.selectedCheckBoxes',selected); 
        /*  if(isSelected){
         selected.push(selectedVal);   
        }else{
            var index = selected.indexOf(selectedVal);
            if (index > -1) {
                selected.splice(index, 1); 
            }
        }
        */
        // component.set('v.selectedCheckBoxes',selected); 
        console.log('selected checkboxes-->'+component.get('v.selectedCheckBoxes'));
        helper.getServiceTypesHelper(component, event, helper);
    },
})
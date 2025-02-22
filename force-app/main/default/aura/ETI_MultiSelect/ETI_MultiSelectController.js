({
    /**
     * This function will be called on component initialization
     * Attaching a document listner to detect clicks on the page
     * 1. Handle logic when click on dropdown/picklist button itself
     * 2. Handle logic when picklist option is clicked
     * 3. Handle logic when anywhere within picklist is clicked
     * 4. Handle logic if clicked anywhere else * */
    doInit : function(component, event, helper) {
        console.log('selectedServices doInit>> '+JSON.stringify(component.get("v.selectedServices")));
        console.log('servicesList doInit>> '+JSON.stringify(component.get("v.servicesList")));
    },
    onRender : function(component, event, helper) {
        if(!component.get("v.initializationCompleted")){
            console.log('selectedServices INN>> '+JSON.stringify(component.get("v.selectedServices")));
            if(component.get("v.selectedServices")!='' && component.get("v.selectedServices")!=undefined){
                component.set("v.selectedOptions",[]);
                var myOptions=component.get("v.selectedServices").toString().split(';');
                component.set("v.selectedOptions", myOptions);
            }
            //Attaching document listener to detect clicks
            component.getElement().addEventListener("click", function(event){
                //handle click component
                helper.handleClick(component, event, 'component');
            });
            //Document listner to detect click outside multi select component
            document.addEventListener("click", function(event){
                helper.handleClick(component, event, 'document');
            });
            //Marking initializationCompleted property true
            component.set("v.initializationCompleted", true);
            //Set picklist name
            helper.setPickListName(component, component.get("v.selectedOptions"));
        }else {
            var myOptions=component.get("v.selectedServices").toString().split(';');
            for(var i = 0; i < myOptions.length; i++){
                Array.from(document.querySelectorAll('li')).forEach(function(node){
                    if(node.getAttribute('data-id')==myOptions[i])
                        node.classList.add('slds-is-selected');
                });
            }
       }
        
    },
        
    /** This function will be called when input box value change * */
    onInputChange : function(component, event, helper) {
        //get input box's value
        var inputText = event.target.value;
        //Filter options
        helper.filterDropDownValues(component, inputText);
    },
    
    /** This function will be called when refresh button is clicked
     * This will clear all selections from picklist and rebuild a fresh picklist * */
    onRefreshClick : function(component, event, helper) {
        //clear selected options
        component.set("v.selectedOptions", []);
        var bookingRecords = component.get("v.bookingWrp");
        var idx = component.get("v.selectedRowIndex");
        component.set("v.isFullPaintSelected",false);
        component.set("v.isColorChangeSelected",false);
        component.set("v.newColor",'');
        bookingRecords[idx].isColorChange=false;
        component.set("v.isVehicleTypeChangeSelected",false);
        component.set("v.newVehicleType",'');
        bookingRecords[idx].isVehicleTypeChange=false;
        component.set("v.locations",[]);
        //component.set("v.bookingWrp",bookingRecords);
        //Clear check mark from drop down items
        helper.rebuildPicklist(component);
        //Set picklist name
        helper.setPickListName(component, component.get("v.selectedOptions"));
    },
    
    /** This function will be called when clear button is clicked
     * This will clear any current filters in place * */
    onClearClick : function(component, event, helper) {
        //clear filter input box
        component.getElement().querySelector('#ms-filter-input').value = '';
        //reset filter
        helper.resetAllFilters(component);
    },
})
({
    /** This function will close all multi-select drop down on the page * */
    closeAllDropDown: function() {
        //Close drop down by removing slds class
        Array.from(document.querySelectorAll('#ms-picklist-dropdown')).forEach(function(node){
            node.classList.remove('slds-is-open');
        });
        //component.get("v.isColorChangeSelected");
        //component.get("v.isVehicleTypeChangeSelected");
        /*var bookingRecords = component.get("v.bookingWrp");
        console.log('bnkg1--'+JSON.stringify(bookingRecords));
        var idx = component.get("v.selectedRowIndex");
        bookingRecords[idx].isColorChange=component.get("v.isColorChangeSelected");
        bookingRecords[idx].isVehicleTypeChange=component.get("v.isVehicleTypeChangeSelected");
        component.set("v.bookingWrp",bookingRecords);
		console.log('bnkg1 final--'+JSON.stringify(bookingRecords));*/
    },
    
    
    /** This function will be called on drop down button click
     * It will be used to show or hide the drop down * */
    onDropDownClick: function(dropDownDiv) {
        //Getting classlist from component
        var classList = Array.from(dropDownDiv.classList);
        if(!classList.includes("slds-is-open")){
            //First close all drp down
            this.closeAllDropDown();
            //Open dropdown by adding slds class
            dropDownDiv.classList.add('slds-is-open');
        } else{
            //Close all drp down
            this.closeAllDropDown();
        }
        
    },
    
    /** This function will handle clicks on within and outside the component * */
    handleClick: function(component, event, where) {
        //getting target element of mouse click
        var tempElement = event.target;
        var outsideComponent = true;
        //click indicator
        //1. Drop-Down is clicked
        //2. Option item within dropdown is clicked
        //3. Clicked outside drop-down
        //loop through all parent element
        while(tempElement){
            if(tempElement.id === 'ms-list-item'){
                //2. Handle logic when picklist option is clicked
                //Handling option click in helper function
                if(where === 'component'){
                    this.onOptionClick(component, event.target);
                }
                outsideComponent = false;
                break;
            } else if(tempElement.id === 'ms-dropdown-items'){
                //3. Clicked somewher within dropdown which does not need to be handled
                //Break the loop here
                outsideComponent = false;
                break;
            } else if(tempElement.id === 'ms-picklist-dropdown'){
                //1. Handle logic when dropdown is clicked
                if(where === 'component'){
                    this.onDropDownClick(tempElement);
                }
                outsideComponent = false;
                break;
            }
            //get parent node
            tempElement = tempElement.parentNode;
        }
        if(outsideComponent){
            this.closeAllDropDown();
        }
    },
    
    /** This function will be used to filter options based on input box value */
    rebuildPicklist: function(component) {
        var allSelectElements = component.getElement().querySelectorAll("li");
        Array.from(allSelectElements).forEach(function(node){
            node.classList.remove('slds-is-selected');
        });
    },
    
    /** This function will be used to filter options based on input box value * */
    filterDropDownValues: function(component, inputText) {
        var allSelectElements = component.getElement().querySelectorAll("li");
        Array.from(allSelectElements).forEach(function(node){
            if(!inputText){
                node.style.display = "block";
            }
            else if(node.dataset.name.toString().toLowerCase().indexOf(inputText.toString().trim().toLowerCase()) != -1){
                node.style.display = "block";
            } else{
                node.style.display = "none";
            }
        }); 
    },
    
    /** This function clear the filters */
    resetAllFilters : function(component) {
        this.filterDropDownValues(component, '');
    },
    
    setPickListName : function(component, selectedOptions) {
        console.log('setPickListName 11>> '+selectedOptions);
        const maxSelectionShow = component.get("v.maxSelectedShow");
        //Set drop-down name based on selected value
        var selections1 = '';
        component.set("v.selectedServices",'');
        selectedOptions.forEach(option => {
            selections1 += option+';';
        });
        component.set("v.selectedServices", selections1.slice(0, -1));  
        if(selectedOptions.length < 1){
            component.set("v.selectedLabel", component.get("v.msname"));
        } else if(selectedOptions.length > maxSelectionShow){
            component.set("v.selectedLabel", selectedOptions.length+' Options Selected');
        } else{
            var selections = '';
            selectedOptions.forEach(option => {
            	selections += option+',';
        	});
            //component.set("v.selectedLabel", selections.slice(0, -1));
            //new changes 10/11/20
            var servicesList=component.get("v.servicesList");
            console.log('servicesList...' + JSON.stringify(servicesList));
            var selectedLabel='';
            var resultArray = selections.toString().split(',');
            console.log('resultArray...' + resultArray);
            for (var i = 0; i < servicesList.length; i++){
                for(var j = 0; j < resultArray.length; j++){
                    if(servicesList[i].id==resultArray[j])  {
            			selectedLabel += servicesList[i].name+',';
        			}  
                }
            }
            console.log('selectedLabel...' + selectedLabel);
            component.set("v.selectedLabel", selectedLabel.slice(0, -1));
            //end
        }
       if(component.get("v.isWalkinBooking")){
            var serviceLineItemsObj=component.get("v.wrapperObj.serviceLineItems");
            console.log('serviceLineItemsObj length '+serviceLineItemsObj.length);
            if(serviceLineItemsObj.length>0){
            	component.set("v.isCertificatesChanged",true);
                component.set('v.wrapperObj.totalFee',null);
                component.set('v.wrapperObj.totalTax',null);
                component.set('v.wrapperObj.totalAmount',null);
                if(selectedOptions.length>0){
                    var lstServiceItem=[];
                    for (var i = 0; i < serviceLineItemsObj.length; i++){
                        for (var j = 0; j < selectedOptions.length; j++){
                            if(serviceLineItemsObj[i].serviceCode==selectedOptions[j])
            					lstServiceItem.push(serviceLineItemsObj[i]);
                        }
                    }
 					console.log('lstServiceItem '+JSON.stringify(lstServiceItem));
            		component.set('v.wrapperObj.serviceLineItems',lstServiceItem);
                }else {
                    component.set('v.wrapperObj.serviceLineItems',[]);
                }
        	}
            console.log('wrapperObj-- '+JSON.stringify(component.get("v.wrapperObj")));
        }
     },
            
     /**
     * This function will be called when an option is clicked from the drop down
     * It will be used to check or uncheck drop down items and adding them to selected option list
     * Also to set selected item value in input box
     * */
     onOptionClick: function(component, ddOption) {
         console.log('ddOption 11>> '+ddOption);
         //get clicked option id-name pair
         var clickedValue = ddOption.closest("li").getAttribute('data-id');
         //Get all selected options
         var selectedOptions = component.get("v.selectedOptions");
         //Boolean to indicate if value is alredy present
         var alreadySelected = false;
         //Looping through all selected option to check if clicked value is already present
         selectedOptions.forEach((option,index) => {
             if(option === clickedValue){
                 //Clicked value already present in the set
                 selectedOptions.splice(index, 1);
                 //Make already selected variable true	
                 alreadySelected = true;
                 console.log('clickedValue--false '+clickedValue);
             	 if(clickedValue=='23' || clickedValue=='36' || clickedValue=='30'){
                     component.set("v.isFullPaintSelected",false);
             	 }
                 if(clickedValue=='19' || clickedValue=='27' || clickedValue=='33'){
                     component.set("v.isColorChangeSelected",false);
                     component.set("v.newColor",'');
             	 }
                 if(clickedValue=='20' || clickedValue=='26' || clickedValue=='32'){
                     component.set("v.isVehicleTypeChangeSelected",false);
                     component.set("v.newVehicleType",'');
                 }
             //remove check mark for the list item
             ddOption.closest("li").classList.remove('slds-is-selected');
     		}
        });
        //If not already selected, add the element to the list
        if(!alreadySelected){
            selectedOptions.push(clickedValue);
            console.log('clickedValue--true '+clickedValue);
            if(clickedValue=='23' || clickedValue=='36' || clickedValue=='30'){
                component.set("v.isFullPaintSelected",true);
            }
            if(clickedValue=='19' || clickedValue=='27' || clickedValue=='33'){
                component.set("v.isColorChangeSelected",true);
            }
            if(clickedValue=='20' || clickedValue=='26' || clickedValue=='32'){
                component.set("v.isVehicleTypeChangeSelected",true);
            }
            //Add check mark for the list item
            ddOption.closest("li").classList.add('slds-is-selected');
        }
        console.log('selectedOptions-- '+selectedOptions);
        //Set picklist label
        this.setPickListName(component, selectedOptions);
        if(selectedOptions==undefined || selectedOptions=='')
            component.set("v.locations",[]);
    },
    
})
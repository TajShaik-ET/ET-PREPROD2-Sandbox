({
	searchHelper : function(component,event,getInputkeyWord) {
	  // call the apex class method 
	   console.log("helper getInputkeyWord***"+getInputkeyWord);
       console.log("searckKey***"+component.find("lookupField"));
       console.log('lang 123***'+component.get("v.lang"));
        console.log("currentValue***"+component.find("v.currentValue"));
       console.log('studentType***'+component.get("v.studentType"));
     var action = component.get("c.fetchLookUpValues");
      // set param to method  
      //alert(getInputkeyWord + '@@ ' + component.get("v.objectAPIName")  + '@@@  '+component.get("v.studentType") + '@@@  ' +  component.get("v.currentValue"))
        action.setParams({
            'searchKeyWord': getInputkeyWord,
            'ObjectName' : component.get("v.objectAPIName"),
            'studentType' : component.get("v.studentType"),
            "currentValue" : component.get("v.currentValue"),
            'lang' : component.get("v.clLang")
          });
      // set a callBack    
        action.setCallback(this, function(response) {
            console.log("response***"+JSON.stringify(response));
          $A.util.removeClass(component.find("mySpinner"), "slds-show");
            var state = response.getState();
            if (state === "SUCCESS") {
                var storeResponse = response.getReturnValue();
                console.log('storeResponse***'+JSON.stringify(storeResponse));
              // if storeResponse size is equal 0 ,display No Result Found... message on screen.                }
                if (storeResponse.length == 0) {
                    component.set("v.Message", 'No Result Found...');
                } else {
                    component.set("v.Message", '');
                }
                // set searchResult list with return value from server.
                
                component.set("v.listOfSearchRecords", storeResponse);
            }
 
        });
      // enqueue the Action  
        $A.enqueueAction(action);
	},
})
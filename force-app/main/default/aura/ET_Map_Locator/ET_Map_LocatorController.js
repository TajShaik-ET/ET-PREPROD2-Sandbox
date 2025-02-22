({
    init: function (cmp, event, helper) {
        var showETLocation = cmp.get('v.showETLocations');
        if(showETLocation)
        	helper.readETData(cmp,event);
        else
           helper.readData(cmp,event); 
    }
    
});
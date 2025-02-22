({
    doInit : function(component, event, helper) {
       
    },
    
    onForceLoad : function(component, event, helper) {
        let opp = component.get("v.record");
      
        if(opp && opp.Account.AccountNumber){
            component.set("v.ErrorMsg","Account is already created in Oracle");
            component.set("v.hasError",true);
        }else if(opp && opp.Account.RecordType.Name!='Person (B2C)'){
            
            component.set("v.ErrorMsg","Opportunity's account must be person account.");
            component.set("v.hasError",true);
           
        }else if(opp && opp.RecordType.DeveloperName == 'Automotive_Service_CenterBodyShop'){
           
           helper.createAccInOracle(component, event, helper,opp.AccountId);
            
        }else {
            component.set("v.ErrorMsg","Opportunity record type should be Automotive Service");
            component.set("v.hasError",true);
            
        }
    },
    closeModel : function(component, event, helper) {        
      $A.get("e.force:closeQuickAction").fire();
    }
})
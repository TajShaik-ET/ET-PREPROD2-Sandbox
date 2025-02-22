({
	doInit : function(component, event, helper) {

        helper.getCheckInDetails(component, event, helper);
        //helper.setImageURLforMarking(component);
	},
    
    openCheckInForm : function(component, event, helper) {
        component.set("v.recordStatus",'New');
        component.set("v.toggleListViewPage",false);
        component.set("v.toggleCheckInPage",true);
        
    },
    
    goToListView  :function(component, event, helper) {
        
        component.set("v.toggleCheckInPage",false);
        component.set("v.toggleListViewPage",true);
        helper.getCheckInDetails(component, event, helper);
        
    },
    
    viewCheckInForm : function(component, event, helper) {
      
        var id = event.target.dataset.index;
        var status = event.currentTarget.dataset.filename;
        
       component.set("v.recordStatus",status);
       component.set("v.recordId",id);
       component.set("v.toggleListViewPage",false);
       component.set("v.toggleCheckInPage",true);
    },
    
    sortCheckInList: function(component, event, helper) {
        
        let keyword = event.getSource().get("v.value")
        const searchKey = keyword.toLowerCase()
        try{
        if(searchKey.length>2){
            var realData =component.get("v.checkInInfo")
                      
           let tempdata = realData.filter(function(item){
                    if(item.Plate_No__c) 
                    return (  item.Plate_No__c.toLowerCase().indexOf(searchKey) !== -1 )
                });
           //||item.Internal_No__r.Name.toLowerCase().indexOf(searchKey) !== -1
           //item.Plate_No__c.indexOf(searchKey)
            
            if(tempdata){
                component.set("v.checkInfilterInfo",tempdata)
                
            }else{
                
                component.set("v.checkInfilterInfo",realData)
            }
        }else{
             component.set("v.checkInfilterInfo",component.get("v.checkInInfo"))
        }    
            
        }catch(e){
            console.error('--err--'+e.message);
        } 
        
    }
    
   
   
})
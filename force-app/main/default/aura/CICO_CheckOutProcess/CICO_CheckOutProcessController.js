({
	doInit : function(component, event, helper) {
   
        helper.getCheckOutDetails(component, event, helper);
       
        //helper.setImageURLforMarking(component);
	},
    
    openCheckOutForm : function(component, event, helper) {
         
        component.set("v.recordStatus",'New');
        component.set("v.toggleListViewPage",false);
        component.set("v.toggleCheckOutPage",true);
       
    },
    goToListView  :function(component, event, helper) {
        
        component.set("v.toggleCheckOutPage",false);
        component.set("v.toggleListViewPage",true);
        helper.getCheckOutDetails(component, event, helper);
       
    },
    
    viewCheckOutForm : function(component, event, helper) {
               
         var id = event.target.dataset.index;
        var status = event.currentTarget.dataset.filename;
       
        
        component.set("v.recordStatus",status);
        component.set("v.recordId",id);
        component.set("v.toggleListViewPage",false);
        component.set("v.toggleCheckOutPage",true);
        
       
       
        
    },
    
    sortCheckOutList: function(component, event, helper) {
        
        let keyword = event.getSource().get("v.value")
        const searchKey = keyword.toLowerCase()
        try{
        if(searchKey.length>=2){
            var realData =component.get("v.checkOutInfo")
                       
           let tempdata = realData.filter(function(item){
               if(item.Plate_No__c)                   
               return (item.Plate_No__c.toLowerCase().indexOf(searchKey) !== -1 )
                });
           //|| item.Plate_No__c.toLowerCase().indexOf(searchKey) !== -1
           //item.Internal_No__r.Name.toLowerCase().indexOf(searchKey) 
            
            if(tempdata){
                component.set("v.checkOutfilterInfo",tempdata)
                
            }else{
                
                component.set("v.checkOutfilterInfo",realData)
            }
        }else{
             component.set("v.checkOutfilterInfo",component.get("v.checkOutInfo"))
        }    
            
        }catch(e){
            console.error(e.message);
        } 
        
    }
    
   
   
})
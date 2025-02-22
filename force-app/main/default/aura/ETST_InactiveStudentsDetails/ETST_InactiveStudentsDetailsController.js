({
    doInit : function(component, event, helper) {
        helper.doInit(component, event, helper);
             
    },
     
   openCreateSerivceModal : function(component, event, helper) {
        var item=event.getSource().get('v.value');
         component.set('v.serviceRecord.ETST_Student__c',item.Id);
         component.set('v.studentRecord.ETST_School_Name__c',item.ETST_School_Name__c);
         //helper.getStudentSchoolAreas(component, event, helper);
         component.set('v.addServiceModal',true);
         
    },
    closeModel: function(component, event, helper) {
        component.set('v.addServiceModal',false);
       
    },
    getPreviousList: function(component, event, helper) {
        var corousalSize=component.get('v.corousalSize'); 
        var start=component.get('v.start'); 
        start-=corousalSize;
        var studentList=component.get('v.studentList'); 
        component.set('v.studentCourosalList',studentList.slice(start,start+corousalSize)); 
        component.set('v.start',start);
        
     },
     getNextList: function(component, event, helper) {
        var corousalSize=component.get('v.corousalSize'); 
        var start=component.get('v.start'); 
        start+=corousalSize;
        var studentList=component.get('v.studentList'); 
        component.set('v.studentCourosalList',studentList.slice(start,start+corousalSize)); 
        component.set('v.start',start); 
    }
})
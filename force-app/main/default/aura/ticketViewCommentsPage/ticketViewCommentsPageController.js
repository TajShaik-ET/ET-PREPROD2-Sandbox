({
    doInit : function(component, event, helper){
        helper.queryCommentsHistory(component, event, helper);
    },

    closeModel: function(component, event, helper) {
        component.set('v.isViewCommentsModal',false);
        
    },

})
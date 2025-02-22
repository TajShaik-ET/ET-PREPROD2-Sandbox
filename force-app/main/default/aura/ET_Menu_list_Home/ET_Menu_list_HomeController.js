({
    taskHandler : function(component, event, helper) {
        var appEvent = $A.get("e.c:ET_EmployeeTabNavigation");
        appEvent.setParams({
            "showTask" : true,
            "showHome" : false,
            "showLeave" : false,
            "showSalary" : false,
            "showInsurance" : false,
            "showSupport" : false
        });
        appEvent.fire();
        var cmpTarget = component.find('taskBtn');
        $A.util.addClass(cmpTarget, 'active');
        var cmpTarget2 = component.find('homeBtn');
        $A.util.removeClass(cmpTarget2, 'active');
        var cmpTarget3 = component.find('insBtn');
        $A.util.removeClass(cmpTarget3, 'active'); 
        var cmpTarget4 = component.find('supBtn');
        $A.util.removeClass(cmpTarget4, 'active'); 
    },
    homeHandler : function(component, event, helper) {
        var appEvent = $A.get("e.c:ET_EmployeeTabNavigation");
        appEvent.setParams({
            "showTask" : false,
            "showHome" : true,
            "showLeave" : false,
            "showSalary" : false,
            "showInsurance" : false,
            "showSupport" : false
        });
        appEvent.fire();
        var cmpTarget = component.find('homeBtn');
        $A.util.addClass(cmpTarget, 'active');
        var cmpTarget2 = component.find('taskBtn');
        $A.util.removeClass(cmpTarget2, 'active');
        var cmpTarget3 = component.find('insBtn');
        $A.util.removeClass(cmpTarget3, 'active');
        var cmpTarget4 = component.find('supBtn');
        $A.util.removeClass(cmpTarget4, 'active');
        
    },
    
    /* LeavesHandler : function(component, event, helper) {
        var appEvent = $A.get("e.c:ET_EmployeeTabNavigation");
        appEvent.setParams({
            "showTask" : false,
            "showHome" : false,
            "showLeave" : true,
            "showSalary" : false,
            "showInsurance" : false,
            "showSupport" : false
        });
        appEvent.fire();
         var cmpTarget = cmp.find('changeBtn');
       $A.util.toggleClass(cmpTarget, 'active');
        
    },
    salaryHandler : function(component, event, helper) {
        var appEvent = $A.get("e.c:ET_EmployeeTabNavigation");
        appEvent.setParams({
            "showTask" : false,
            "showHome" : false,
            "showLeave" : false,
            "showSalary" : true,
            "showInsurance" : false,
            "showSupport" : false
        });
        appEvent.fire();
        
    },*/
    insuranceHandler : function(component, event, helper) {
        var appEvent = $A.get("e.c:ET_EmployeeTabNavigation");
        appEvent.setParams({
            "showTask" : false,
            "showHome" : false,
            "showLeave" : false,
            "showSalary" : false,
            "showInsurance" : true,
            "showSupport" : false
        });
        appEvent.fire();
        var cmpTarget = component.find('insBtn');
        $A.util.addClass(cmpTarget, 'active');
        var cmpTarget2 = component.find('homeBtn');
        $A.util.removeClass(cmpTarget2, 'active');
        var cmpTarget3 = component.find('taskBtn');
        $A.util.removeClass(cmpTarget3, 'active');  
        var cmpTarget4 = component.find('supBtn');
        $A.util.removeClass(cmpTarget4, 'active');
    },
    supportHandler : function(component, event, helper) {
        var appEvent = $A.get("e.c:ET_EmployeeTabNavigation");
        appEvent.setParams({
            "showTask" : false,
            "showHome" : false,
            "showLeave" : false,
            "showSalary" : false,
            "showInsurance" : false,
            "showSupport" : true
        });
        appEvent.fire();
        var cmpTarget = component.find('supBtn');
        $A.util.addClass(cmpTarget, 'active');
        var cmpTarget2 = component.find('homeBtn');
        $A.util.removeClass(cmpTarget2, 'active');
        var cmpTarget3 = component.find('taskBtn');
        $A.util.removeClass(cmpTarget3, 'active');  
        var cmpTarget4 = component.find('insBtn');
        $A.util.removeClass(cmpTarget4, 'active'); 
    },
    
    
    handleLogout : function(component, event, helper) {
         window.location.replace('https://icrm.my.site.com/Employee/s/login/?ec=302&startURL=%2FEmployee%2Fs%2F') //redirect to login
    }
})
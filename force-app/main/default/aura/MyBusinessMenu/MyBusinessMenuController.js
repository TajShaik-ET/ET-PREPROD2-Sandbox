({
    handleSelect: function(component, event, helper) {
        var selected = event.getParam('name');
        if (selected === 'Sales_Agreement') {
            
            var appEvent = $A.get("e.c:MyBusinessEvent");
            appEvent.setParams({
                "salesAgreement" : true,
                "salesAgreementDashboard" : false,
                "assignResources" : false,
                "assignVehicles" : false,
                "invoices" : false,
                "salesAgreementClick" : false,
                "assignResourcesClick" : false,
                "assignVehiclesClick" : false,
                "invoicesClick" : false,
                "schoolsClick" : false,
                "studentsClick" : false,
                "schools" : false,
                "students" : false,
                "govtSchool":component.get('v.govtSchool')
            });
            appEvent.fire();
        } else if(selected === 'Assign_Resources'){
            var appEvent = $A.get("e.c:MyBusinessEvent");
            appEvent.setParams({
                "salesAgreement" : false,
                "salesAgreementDashboard" : false,
                "assignResources" : true,
                "assignVehicles" : false,
                "invoices" : false,
                "salesAgreementClick" : false,
                "assignResourcesClick" : false,
                "assignVehiclesClick" : false,
                "invoicesClick" : false,
                "schoolsClick" : false,
                "studentsClick" : false,
                "schools" : false,
                "students" : false,
                "govtSchool":component.get('v.govtSchool')
                
            });
            appEvent.fire();
        }else if(selected === 'Assign_Vehicles'){
            var appEvent = $A.get("e.c:MyBusinessEvent");
            appEvent.setParams({
                "salesAgreement" : false,
                "salesAgreementDashboard" : false,
                "assignResources" : false,
                "assignVehicles" : true,
                "invoices" : false,
                "salesAgreementClick" : false,
                "assignResourcesClick" : false,
                "assignVehiclesClick" : false,
                "invoicesClick" : false,                
                "schoolsClick" : false,
                "studentsClick" : false,
                "schools" : false,
                "students" : false,
                "govtSchool":component.get('v.govtSchool')
            });
            appEvent.fire();
            
        }else if(selected === 'Invoices'){
            var appEvent = $A.get("e.c:MyBusinessEvent");
            appEvent.setParams({
                "salesAgreement" : false,
                "salesAgreementDashboard" : false,
                "assignResources" : false,
                "assignVehicles" : false,
                "invoices" : true,
                "salesAgreementClick" : false,
                "assignResourcesClick" : false,
                "assignVehiclesClick" : false,
                "invoicesClick" : false,                
                "schoolsClick" : false,
                "studentsClick" : false,
                "schools" : false,
                "students" : false,
                "govtSchool":component.get('v.govtSchool')
            });
            appEvent.fire();
            
        }else if(selected === 'schools'){
            var appEvent = $A.get("e.c:MyBusinessEvent");
            appEvent.setParams({
                "salesAgreement" : false,
                "salesAgreementDashboard" : false,
                "assignResources" : false,
                "assignVehicles" : false,
                "invoices" : false,
                "salesAgreementClick" : false,
                "assignResourcesClick" : false,
                "assignVehiclesClick" : false,
                "invoicesClick" : false,                
                "schoolsClick" : false,
                "studentsClick" : false,
                "schools" : true,
                "students" : false,
                "govtSchool":component.get('v.govtSchool')
            });
            appEvent.fire();
            
        }else if(selected === 'students'){
            var appEvent = $A.get("e.c:MyBusinessEvent");
            appEvent.setParams({
                "salesAgreement" : false,
                "salesAgreementDashboard" : false,
                "assignResources" : false,
                "assignVehicles" : false,
                "invoices" : false,
                "salesAgreementClick" : false,
                "assignResourcesClick" : false,
                "assignVehiclesClick" : false,
                "invoicesClick" : false,                
                "schoolsClick" : false,
                "studentsClick" : false,
                "schools" : false,
                "students" : true,
                "govtSchool":component.get('v.govtSchool')
            });
            appEvent.fire();
            
        }
    },
   doInit : function(component, event, helper) {
		helper.doInit(component, event, helper);
	}, 
})
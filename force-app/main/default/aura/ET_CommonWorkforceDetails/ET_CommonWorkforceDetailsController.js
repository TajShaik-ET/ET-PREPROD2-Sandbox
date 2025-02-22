({
    doInit: function(component,event,helper){
        var salaryMap = component.get("v.workforceSalaryDetailMap");
        debugger;
        console.log('salaryMap = '+ JSON.stringify(salaryMap));
        if(salaryMap){
            var commonWorkForceRecord = component.get("v.commonWorkForceRecord");
            if(salaryMap['basicSalary']){
                commonWorkForceRecord.ET_Specific_Base_Salary__c = salaryMap['basicSalary'];
            }
            if(salaryMap['grossSalary']){
                commonWorkForceRecord.ET_Specific_Gross_Salary__c = salaryMap['grossSalary'];
            }
            if(salaryMap['workForceMaster']){
                console.log('salaryMap workForceMaster = '+ salaryMap['workForceMaster']);
                component.set("v.workForceMaster", salaryMap['workForceMaster']);
                commonWorkForceRecord.Housing_Allowance__c = salaryMap['workForceMaster'].Housing_Allowance__c;
                commonWorkForceRecord.Transport_Allowance__c = salaryMap['workForceMaster'].Transport_Allowance__c;
                commonWorkForceRecord.Additional_Transport_Allowance__c = salaryMap['workForceMaster'].Additional_Transport_Allowance__c;
                commonWorkForceRecord.Other_Allowance__c = salaryMap['workForceMaster'].Other_Allowance__c;
                commonWorkForceRecord.Social_Allowance__c = salaryMap['workForceMaster'].Social_Allowance__c;
                
            }
            
            component.set("v.commonWorkForceRecord", commonWorkForceRecord);
            
        }
		helper.getSRCommonDetails(component,event,helper);
	},


	setAlreadyStoredData: function(component,event,helper){
		var params = event.getParam('arguments');
        if(params){
            var existingData = params.commonDataToBeSet;
            if(existingData != undefined ){
				component.set("v.commonWorkForceRecord", existingData);
			}
		}
	}
})
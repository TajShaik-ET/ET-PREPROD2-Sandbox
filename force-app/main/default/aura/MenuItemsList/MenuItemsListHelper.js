({
	hideActiveClaass : function(component, event, helper) {
		$A.util.removeClass(component.find("home"), 'active1');
        $A.util.removeClass(component.find("business"), 'active1');
        $A.util.removeClass(component.find("explore"), 'active1');
        $A.util.removeClass(component.find("care"), 'active1');
        $A.util.removeClass(component.find("specialReq"), 'active1');
         $A.util.removeClass(component.find("SpecialDashboard"), 'active1');
	},
    doInit : function(component, event, helper) {
        var action = component.get('c.getProfileDetails');
        action.setParams({
        });
        action.setCallback(this, function (a) {
            var state = a.getState(); // get the response state
            if (state == 'SUCCESS') {
                console.log('user details');
                var result = a.getReturnValue();
                //  component.set('v.userName',result.Account.Name);
                component.set('v.profileName',result.Profile.Name);
                console.log('profile '+result.Profile.Name);
                var pro =result.Profile.Name;
                console.log('pro '+pro);
                 console.log('profile name '+pro);
                  if(pro.includes('MOE') || pro.includes('Govt') || pro.includes('ESE')){
                    console.log('test');
                    component.set('v.MOEprofileName',true);
                   
                     
                }
                else if(pro.includes('ESE')){
                      
                    component.set('v.profileName',pro);
                    
                }
            }
        });
        $A.enqueueAction(action);
    }
})
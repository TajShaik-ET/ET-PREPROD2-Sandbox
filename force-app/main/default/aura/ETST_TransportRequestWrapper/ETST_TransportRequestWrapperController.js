({
    doInit : function(component, event, helper) {
        /*navigator.geolocation.getCurrentPosition(
                (position) => {
                    alert('success'+position.coords.latitude);
                },
                    (error) => {alert('error'+JSON.stringify(error.message))},
                { enableHighAccuracy: false, timeout: 5000}
            );*/
        var url = $A.get('$Resource.ETSTBgLogo');
        component.set('v.backgroundImageURL', url);
        helper.doInit(component, event, helper);
        helper.profileData(component, event,helper);
    },
    setLanguage: function(component, event, helper) {
        var url= window.location.pathname;
        component.set('v.lang',event.getParam("lang"));
        var urlEvent = $A.get("e.force:navigateToURL");
        urlEvent.setParams({
            "url": url+'&lang='+event.getParam("lang")
            
        });
        urlEvent.fire();
        //alert('lang-->'+component.get('v.lang'));
        // $A.get('e.force:refreshView').fire();
    },
    urlClickHandler : function(component, event, helper) {
        
        component.set('v.isModalOpen',true);
        //component.set('v.url','https://icrm.my.salesforce.com/sfc/p/3z000000eGDP/a/3z000000pQUp/eWPJeB_NfO4MGnkJsBtWBDUPX7dVMCuUpYGJYzPbvhY')
        
        
        /* component.get('v.lang');
        if(component.get('v.lang')!='ar'){
            window.open('https://icrm.my.salesforce.com/sfc/p/3z000000eGDP/a/3z000000pQUp/eWPJeB_NfO4MGnkJsBtWBDUPX7dVMCuUpYGJYzPbvhY', "_blank");
        }
        else{
            window.open('https://icrm.my.salesforce.com/sfc/p/3z000000eGDP/a/3z000000pQUp/eWPJeB_NfO4MGnkJsBtWBDUPX7dVMCuUpYGJYzPbvhY', "_blank");
        }*/
        
        
    },
    
    //for terms and conditions Modal
    closeModal: function(component, event, helper)
    {
        component.set('v.termCondCheck',false);
        component.set('v.isModalOpen',false);
    },
    
    onAccept: function(component, event, helper){
        component.set('v.termCondCheck',true);
        component.set('v.isModalOpen',false);
    },
    
    closeModel: function(component, event, helper) {
        component.set('v.needMoreInfo',false);
        var urlEvent = $A.get("e.force:navigateToURL");
        urlEvent.setParams({
            "url": '/'
            
        });
        urlEvent.fire();
    },
    SubmitDetails: function(component, event, helper) {
        var e1=component.get('v.eid1');
        var e2=component.get('v.eid2');
        var e3=component.get('v.eid3');
        var phone=component.get('v.Phone');
        
        var eid='784-'+e1+'-'+e2+'-'+e3;
        if(e1!=null && e2!=null && e3!=null)
        { 
            if(e1.length==4 && e2.length==7 && e3.length==1)
            {
                component.set('v.EID', eid);
            }
            
        }
        
        if(!phone.includes("+971"))
        {
            phone='+971'+phone;
            
        }
        
        if(component.get('v.EID')==null){
            var toastReference = $A.get("e.force:showToast");
            toastReference.setParams({
                "type":"Warning",
                "title":"Warning",
                "message":"Please enter the Emirates Id to proceed",
                "mode":"dismissible"
            });
            toastReference.fire();
        }
        
        if(component.get('v.EID')!=null && phone!=null && phone.length==13){
            component.set('v.Phone',phone);
            
            if(component.get('v.govParent')){
                
                if(component.get('v.EID')!=component.get('v.EtEid')){
                    var toastReference = $A.get("e.force:showToast");
                    toastReference.setParams({
                        "type":"Warning",
                        "title":"Warning",
                        "message":"Please enter the registered Emirates Id",
                        "mode":"dismissible"
                    });
                    toastReference.fire();
                }
                
                else if(component.get('v.termCondCheck')){
                    helper.updateProfile(component, event, helper);
                }else{
                    var toastReference = $A.get("e.force:showToast");
                    toastReference.setParams({
                        "type":"Warning",
                        "title":"Warning",
                        "message":"Please check Terms & conditions.",
                        "mode":"dismissible"
                    });
                    toastReference.fire();
                    
                }
                
            }else{
                helper.updateProfile(component, event, helper);
            }
        }        
        /*else{
            alert('Please enter valid details');
        }*/
        
    }, 
    
    changeFocus1: function(component, event, helper) {
        var e1=component.get('v.eid1');
        if(e1.length==4)
            component.find("eid2").focus();
        
    },
    changeFocus2: function(component, event, helper) {
        
        var e2=component.get('v.eid2');
        if(e2.length==7)
            component.find("eid3").focus();
        
    },
})
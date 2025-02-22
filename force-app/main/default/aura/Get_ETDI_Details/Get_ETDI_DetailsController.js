({
    doInit : function(component,event,helper) {
        var sPageURL = decodeURIComponent(window.location.search.substring(1)); //You get the whole decoded URL of the page.
        var sURLVariables = sPageURL.split('&'); //Split by & so that you get the key value pairs separately in a list
        var sParameterName;
        var i;
        console.log(i);
    
        helper.getInitData(component, event,helper);
    },
    
    handleClick : function(component,event,helper){
        var recId = window.location.href.substring(window.location.href.lastIndexOf('/') + 1);
       // window.location = '/apex/activateContractByTC?id=' + recId;
        //window.location = 'https://icrm--preprod.lightning.force.com/lightning/r/Account/'+recId+'/view';
        window.location = 'https://icrm.lightning.force.com/lightning/r/Account/'+recId+'/view';
                
    }

})
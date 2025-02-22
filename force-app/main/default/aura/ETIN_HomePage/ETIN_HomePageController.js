({
	doInit : function(component, event, helper) {
        var userId = $A.get( "$SObjectType.CurrentUser.Id" );
        component.set('v.userId',userId);
        component.set('v.profileUrl','/employeeportal/s/profile/'+userId);
	    var url= window.location.pathname;  
        
	},
    
    LogoutFunction :function(component, event, helper) {
     
        var myWindow = window.open('/servlet/networks/switch?startURL=%2Fsecur%2Flogout.jsp',"_self");
       /* if(myWindow){ // if its null means the 1 one is not opened hence second //will not open
            setTimeout(function(){ 
                window.open('https://www.w3schools.com/html/');
            }, 1000);
    } */
    }   
})
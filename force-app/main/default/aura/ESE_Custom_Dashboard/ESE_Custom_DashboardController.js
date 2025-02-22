({
    
    doInit : function(component, event, helper) {  
        
      
        //No filter Methods
        helper.getTotalStuWhatsappReqInfo(component, event, helper);
        helper.getSchoolInfo(component, event, helper);
        helper.getSeatOccupiedInfo(component, event, helper);
        
        //Filter Methods
        helper.getExecutedTripsData(component, event, helper);
       
        helper.getTripsMoreThanBeforeInfo(component, event, helper);
        helper.getKGTripsMoreThan45Info(component, event, helper);
        helper.getTripsDuration60_75Info(component, event, helper);
        helper.getTripsDurationMore75Info(component, event, helper);
        helper.getTotalStudentRegInfo(component, event, helper);
        helper.getBusCountFromTripsInfo(component, event, helper);
        
    },
    
    schoolChangeHandler : function(component, event, helper) {          
        
        helper.emptyAllValues(component, event, helper);
        let schName = component.get("v.selectedSchName");
        let emptyArr = [];
        component.set("v.selectedSchList",emptyArr); 
        component.set("v.selectedCode",'All'); 
        
         if(schName == 'All')
           component.set("v.showAll",true); 
        else
          component.set("v.showAll",false);
        helper.getExecutedTripsData(component, event, helper);
        helper.getTripsMoreThanBeforeInfo(component, event, helper);
        helper.getKGTripsMoreThan45Info(component, event, helper);
        helper.getTripsDuration60_75Info(component, event, helper);
        helper.getTripsDurationMore75Info(component, event, helper); 
        helper.getTotalStudentRegInfo(component, event, helper);
        helper.getBusCountFromTripsInfo(component, event, helper);
       
                
        
    },
    
    stationCodeChangeHandler :  function(component, event, helper){ 
        
        helper.emptyAllValues(component, event, helper);
        let stationCode = component.get("v.selectedCode");
        let schoolList = component.get("v.schoolList");
        let selectedSchList =[];
        schoolList.forEach(function(item){
            if(item.Station_Code__c== stationCode)
                selectedSchList.push(item.Name);
        });
        component.set("v.selectedSchName", null); 
        if(stationCode=='All')
        component.set("v.selectedSchName", 'All'); 
        component.set("v.selectedSchList",selectedSchList);
                    
        helper.getExecutedTripsData(component, event, helper);
        helper.getTripsMoreThanBeforeInfo(component, event, helper);
        helper.getKGTripsMoreThan45Info(component, event, helper);
        helper.getTripsDuration60_75Info(component, event, helper);
        helper.getTripsDurationMore75Info(component, event, helper); 
        helper.getTotalStudentRegInfo(component, event, helper);
        helper.getBusCountFromTripsInfo(component, event, helper);
        
    },
    waiting :function(component, event, helper){ 
     component.set("v.HideSpinner", false); 
    },
    doneWaiting : function(component, event, helper){ 
        component.set("v.HideSpinner", true);    
    
    },
    dateChangeHandelr :  function(component, event, helper){ 
        let fromDate = component.get("v.fromDate");
        let toDate = component.get("v.toDate");
       
       helper.getTripsMoreThanBeforeInfo(component, event, helper);
       helper.getKGTripsMoreThan45Info(component, event, helper);
       helper.getTripsDuration60_75Info(component, event, helper);
       helper.getTripsDurationMore75Info(component, event, helper);
       helper.getExecutedTripsData(component, event, helper); 
       helper.getBusCountFromTripsInfo(component, event, helper); 
       helper.getTotalStuWhatsappReqInfo(component, event, helper);
       
             
    }
    
})
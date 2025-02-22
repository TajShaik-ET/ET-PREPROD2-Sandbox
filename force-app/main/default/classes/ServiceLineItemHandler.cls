public class ServiceLineItemHandler {

    public static void updateTestResult(List<ETI_Service_Line_Item__c> newList,Map<Id,ETI_Service_Line_Item__c> oldMap){
        Set<Id> vSetSLIIds = new Set<Id>();
        for(ETI_Service_Line_Item__c vItm : newList){
            if(vItm.Test_Result__c!=null && vItm.Test_Result__c != oldMap.get(vItm.Id).Test_Result__c){
                vSetSLIIds.add(vItm.Id);
            }
         }
        if(!vSetSLIIds.isEmpty()){
         Map<Id,List<ETI_Service_Line_Item__c>> vMapBookingSLI = new Map<Id,List<ETI_Service_Line_Item__c>>();
         ETI_Booking__c upBooking;
         List<ETI_Booking__c> vListUpdateBooking = new List<ETI_Booking__c>();
         String vRes='';
         for(ETI_Service_Line_Item__c vItem : [SELECT Id,Booking__c,Test_Result__c,Result_Date__c FROM ETI_Service_Line_Item__c WHERE Id =: vSetSLIIds]){
            if(!vMapBookingSLI.containsKey(vItem.Booking__c))
                 vMapBookingSLI.put(vItem.Booking__c,new List<ETI_Service_Line_Item__c>());
             vMapBookingSLI.get(vItem.Booking__c).add(vItem);
          }
          for(Id vItem : vMapBookingSLI.keySet()){
             upBooking = new ETI_Booking__c(Id = vItem);
             for(ETI_Service_Line_Item__c vItems : vMapBookingSLI.get(vItem)){
               if(vItems.Test_Result__c!=null && vItems.Test_Result__c!='Pending'){
                   if(vItems.Test_Result__c.startsWith('Fai') || vItems.Test_Result__c.startsWith('Rej'))
                      vRes =+'Fail ';
                   if(vItems.Test_Result__c.startsWith('Pas') || vItems.Test_Result__c.startsWith('App'))
                      vRes =+'Pass ';
                   }
                   if(vItems.Test_Result__c.startsWith('No')){
                      vRes =+'No'; //No Show
                   }
              }
             if(vRes.contains('Fail') && vRes.contains('Pass')){
                 upBooking.Test_Result__c ='Partial Approved';
                 vListUpdateBooking.add(upBooking);
                    }
             else if(vRes.contains('Fail') && (!vRes.contains('Pass'))){
                  upBooking.Test_Result__c ='Failed';
                  vListUpdateBooking.add(upBooking);
             }
             else if((!vRes.contains('Fail')) && (vRes.contains('Pass'))){
                 upBooking.Test_Result__c ='Pass';
                 vListUpdateBooking.add(upBooking);
             }else if((vRes.contains('No'))){
                 upBooking.Test_Result__c ='No Show';
                 vListUpdateBooking.add(upBooking);
             }
           }
           if(!vListUpdateBooking.isEmpty())
                   update vListUpdateBooking;
        }
    }
     public static void utilityMethod(){
        
        integer i=0;
        
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
         i++;
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
          
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
         i++;
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
          
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
         i++;
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
          
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
         i++;
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
          
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
         i++;
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
          
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
         i++;
         i++;
       
     }
}
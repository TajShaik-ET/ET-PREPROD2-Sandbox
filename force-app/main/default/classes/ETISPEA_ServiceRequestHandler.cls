/* Class       : ETISPEA_ServiceRequestHandler
Description    : Triggers when Payment status on 'Vehicle_Inspection' service Request Changed and updated to 'Payment Success' 
                 and when associated Vehicle Booking does not have workorders.

To Create work order for Vehicle Booking when Payment is sucessful for associated 'Service Request.
If Bookings related to Service Request - already has workorder, duplicate work orders won't be created again.
For any issues in creation of workorder - errors logged in 'ET_Error_Logs__c' for Tracking purpose.
** At a Time only workorder can be there for one Vehicle Booking.
*/


public class ETISPEA_ServiceRequestHandler {
    Public static void createWorkOrder(Map<Id, ET_Service_Request__c> newMap, Map<Id,ET_Service_Request__c> oldMap){
        id B2BRecordtypeId = Schema.getGlobalDescribe().get('Account').getDescribe().getRecordTypeInfosByDeveloperName().get(Label.ETI_Business_B2B_Inspection).getRecordTypeId();
        List<ETI_Booking__c> bookingList = new List<ETI_Booking__c>();
        set<id> srIds = new set<id>();
        system.debug('New values - service Request = '+ Json.serializePretty(newMap));
        system.debug('Old values - service Request = '+ Json.serializePretty(oldMap));
        try{
            Id srRecordTypeId = Schema.SObjectType.ET_Service_Request__c.getRecordTypeInfosByDeveloperName().get('Vehicle_Inspection').getRecordTypeId();
            if(srRecordTypeId !=null){
                for(ET_Service_Request__c sr: newMap.values()){
                    if(sr.RecordTypeId ==srRecordTypeId && newMap.get(sr.Id).Payment_Status__c != oldMap.get(sr.Id).Payment_Status__c && sr.Payment_Status__c == 'Payment Success'){
                        system.debug('Conditions Matched to create workorder');
                        srIds.add(sr.Id);
                    }
                }
                system.debug('serviceReq Ids = '+ srIds);
                if(srIds != null && !srIds.isEmpty()){
                    List<workOrder> workorderList = new List<workOrder>();
                    Id recordTypeId = Schema.SObjectType.WorkOrder.getRecordTypeInfosByDeveloperName().get('Inspection_Work_Order').getRecordTypeId();
                    // Initilizations
                    List<ServiceReportLayout> layout=new List<ServiceReportLayout>();
                    List<WorkType> wtype = new List<WorkType>();
                    
                    layout=[select id , developername from ServiceReportLayout where developername ='Inspection Template'] ;
                    wtype = [select id ,Name FROM WorkType where Name ='Inspection'];
                    String workTypeId;
                    String layoutId;
                    if(wtype != null && wtype.size() > 0){
                        workTypeId = wtype[0].id;
                    }
                    if(layout != null && layout.size() > 0){
                        layoutId = layout[0].id;
                    }
                    system.debug('layoutId = '+layoutId);
                    system.debug('workTypeId = '+workTypeId);
                    for(ETI_Booking__c bkng: [Select id,Name,Payment_Status__c,Service_Request__c,Booking_Date_Time__c,User__r.recordtypeid,User__r.ETI_Service_Territory__c,
                                              ET_Location__r.Name,Service_Request__r.Payment_Status__c,User__c,Longitude__c,Latitude__c,ETI_Pick_Up_Location__c,CreatedBy.ContactId,ETI_Schedule_Appointment__c,
                                              (select id from Work_Orders__r)
                                              From ETI_Booking__c Where Service_Request__c IN: srIds]){
                                                  System.debug('Status....'+bkng.Service_Request__r.Payment_Status__c);
                                                  if(bkng.ET_Location__r.Name== 'Sharjah Spea Inspection Centre' ){
                                                      system.debug('Booking location Name = '+ bkng.ET_Location__r.Name);
                                                      system.debug('work orders for Booking = '+ bkng.Work_Orders__r);
                                                      // allow to create workorder only when current Booking doesnot have any workorders- to avoid duplicates..
                                                      if(bkng.Work_Orders__r.isempty()){
                                                          system.debug('workorder creation started');
                                                          WorkOrder wo = new WorkOrder();
                                                          // service Territory is copied from Account to Work order
                                                          wo.ServiceTerritoryId = bkng.User__r.ETI_Service_Territory__c;
                                                          wo.recordTypeId = recordTypeId;
                                                          wo.AccountId = bkng.User__c; 
                                                          wo.ServiceReportTemplateId = layoutId;
                                                          // Start Time is - Date and Time - when Customer needs Service
                                                          wo.StartDate = bkng.Booking_Date_Time__c; 
                                                          wo.Subject = 'Inspection';
                                                          wo.Booking__c = bkng.Id; 
                                                          wo.WorkTypeId = workTypeId;
                                                          wo.ContactId = bkng.CreatedBy.ContactId;
                                                          // This boolean is to control - to auto assign Service appointment to an available Service Resource...
                                                          if(wo.ServiceTerritoryId != null){
                                                              wo.ETI_Schedule_Appointment__c = bkng.ETI_Schedule_Appointment__c;
                                                          }
                                                          else{
                                                              wo.ETI_Schedule_Appointment__c = false;
                                                          }
                                                          
                                                          // work order address - where work need to be performed
                                                          wo.Street = bkng.ETI_Pick_Up_Location__c;
                                                          wo.City = 'Sharjah';
                                                          wo.Country ='United Arab Emirates';
                                                          workorderList.add(wo);
                                                      }
                                                  }
                                                  
                                              }
                    system.debug('work orders = '+ JSON.serializePretty(workorderList));
                    if(workorderList != null &&  !workorderList.isEmpty())
                    {
                        insert workorderList;
                        system.debug('work orders created');
                    }
  
                }
            }
        }catch(exception e){
            System.debug('Exception '+e.getMessage());
            System.debug('Exception line '+e.getLineNumber());
            system.debug('Trace = '+ e.getStackTraceString());
            logException(e, 'Inspection FSL');
        }
        
    }
    
    /** Method     :logException
    Description: To log Apex Exceptions in Custom object 'ET_Error_Logs__c'
    **/
    Public static void logException(Exception e , String module){
        ET_Error_Logs__c err = new ET_Error_Logs__c();
        err.ET_Exception_Message__c = e.getMessage();
        err.ET_Exception_Trace__c = e.getStackTraceString();
        err.ET_Exception_Line_Number__c = String.valueOf(e.getLineNumber());
        err.ET_Exception_Type__c = e.getTypeName();
        err.ET_Module__c = module; 
        try{
            insert err;
        }
        catch(Exception exc){
            system.debug('exception  ='+ exc.getMessage());
            system.debug('Trace = '+ exc.getStackTraceString());
        }
    }
    
}
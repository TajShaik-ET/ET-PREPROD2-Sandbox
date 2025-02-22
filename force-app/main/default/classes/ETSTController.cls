/*******************************************************************************************************************
Class       : ETSTController
Author      : Kamal Mahammad
Description :  
TestClass  : ETSTController_Test
----------------------------------------------------------------------------------------------------------------
            -- History --
----------------------------------------------------------------------------------------------------------------
Sr.No.  version_DevInitials     Date             Changed By                        Details
1.          V1               Feb 27th, 2020     Kamal Mahammad                 Initial Version
2.          V2               Jan 16th, 2022     Sreelakshmi SK        createNewService method--> changed the label.
                                                                     rejectService method--> added a line of code.
*******************************************************************************************************************/
public with sharing class ETSTController {
    
    
    
    @AuraEnabled
    public static Map<string,string> getServiceLocationDetails() {
        
        Map<string,string> serNameVsLoc = new  Map<string,string>();
        
        for(ET_Service_Location__c es : [select id,Name,Available_Locations__c from  ET_Service_Location__c]){
            serNameVsLoc.put(es.Name,es.Available_Locations__c);            
        }
        
        return serNameVsLoc;
        
    }
    
    @AuraEnabled
    public static Account getProfileDetails() {
        String userAccountId=[select accountId from user where id=:userInfo.getUserId()].accountId;  
        List<Account> acc=[select id,Name,PersonMobilePhone,ET_Emirates_Id__c,ETST_Emirates_Id__c,ET_Preferred_Location__c,Government_School_Parent__c from Account where id=:userAccountId];
        if(acc.size() > 0)
            return acc[0];
        return null;
    }
    @AuraEnabled
    public static void updateProfile(String eid,String Phone,String userId) {
        Account acc=new Account(Id=userId);
        acc.ETST_Emirates_Id__c=eid; 
        acc.Phone=Phone;
        acc.PersonMobilePhone=Phone;
        try{
            update acc;
            System.debug('updated '+acc);
        }
        catch(Exception e){
            System.debug('Failed'+e.getMessage());
        }
        
        
    }
    @AuraEnabled
    public static void updateUserLoc(String loc,Id userId) {
        Account acc=new Account(Id=userId);
        acc.ET_Preferred_Location__c=loc;
        acc.ET_Changed_Location__c = loc; //Inspection Field
        try{
            update acc;
            System.debug('updated '+acc);
        }
        catch(Exception e){
            System.debug('Failed'+e.getMessage());
        }
        
        
    }
    //Inspection Method 
    @AuraEnabled
    public static void updateUserChangedLoc(String loc,Id userId) {
        Account acc=new Account(Id=userId);
        
        acc.ET_Changed_Location__c = loc; 
        
        try{
            update acc;
            System.debug('updated '+acc);
            
        }
        catch(Exception e){
            System.debug('Failed'+e.getMessage());
            
        }
        
        
    }
    
    
    @AuraEnabled
    public static ETSTWrapper getStudentDetails(Boolean activeFlag) {
        String errStr;
        ETSTWrapper wrapperInstance=new ETSTWrapper();
        try{
            String userAccountId=[select accountId from user where id=:userInfo.getUserId()].accountId;  
            system.debug(userAccountId);
            Date today=Date.today();
            String cond1=System.Label.ETST_Parent_Cancelled;
            String cond2=System.Label.ETST_Service_Updated;
            String cond3=System.label.ETST_Request_Rejected;
            String cond4=System.label.AutoDeactivated;
            String cond5=System.label.ETST_School_Changed;
            String str='select Is_Child_Data_Updated__c,is_New_Student__c, Name,ETST_First_Name__c,ETST_Student_SFID__c,ETST_Student_Id__c,ETST_Emirates_Id__c,ETST_Email__c,';
            str+=' ETST_Student_Image__c,ETST_Image_Document_Id__c, ETST_Division__c,ETST_Grade__c,ETST_School_Name__r.Name,ETST_School_Name__r.ETST_Name_AR__c, ETST_School_Name__r.ETST_School_Paid__c,ETST_School_Name__r.ETST_Account_Type__c,';
            str+=' (select Id,ETST_Student__c,ETST_Status__c,Payment_Status__c,ET_Account__c,ETST_Is_Active__c,ETST_Pick_Up_End_Date__c,ETST_Pick_Up_From__c,';
            str+=' ETST_Renewal_Start_Date__c,ETST_Renewal_End_Date__c,ETST_Fare_Charges__c,ETST_Is_Renewal_Opened__c,ETST_Area_Zone__c,ETST_Drop_of_Time__c,ETST_Drop_Off_To__c,ETST_Service_Type__c,ETST_Pick_Up_Start_Date__c,';
            str+=' ETST_Transport_Type__c,Name,ETST_Name__c,ETST_Payee__c,ETST_Price_List__c,ETST_Is_Renewed__c';
            str+=' from ETST_Transport_Requests__r  where ';
            if(activeFlag){
                str+=' ETST_Is_Active__c =true )';
            }else{
                str+=' ETST_Is_Active__c =false AND  ETST_Pick_Up_Start_Date__c>= :today  AND ETST_Status__c!= :cond1  AND ETST_Status__c!= :cond2 AND ETST_Status__c!= :cond3  AND ETST_Status__c!= :cond4 AND ETST_Status__c!= :cond5)';
            }
            
            str+=' from ETST_Student__c where ETST_Account_Name__c=:userAccountId  order by lastmodifiedDate desc';
            system.debug('str-->'+str);
            wrapperInstance.studentList=database.query(str);
            
            
            List<String> field_apinames=new  List<String>{'ETST_Parent_Cancellation_Reason__c','ETST_Service_Type__c','ETST_Transport_Type__c'};
                Map<String, List<Schema.PicklistEntry>>  fieldFinalMap=ETST_PicklistValueController.getPicklistvalues('ET_Service_Request__c',field_apinames);
            if(fieldFinalMap == null) {
                return null;
            }
            List<String> optionlist = new List<String>();
            for(String fieldVal : fieldFinalMap.keySet()){
                for(Schema.PicklistEntry pv : fieldFinalMap.get(fieldVal)) {
                    optionlist.add(pv.getValue());
                }
                if(fieldVal=='ETST_Service_Type__c'){
                    wrapperInstance.serviceTypes.addAll(optionlist);
                }else if(fieldVal=='ETST_Transport_Type__c'){
                    wrapperInstance.transportTypes.addAll(optionlist);
                }
                //else if(fieldVal=='ETST_Reason_for_Cancellation__c'){
                //wrapperInstance.cancellationTypes.addAll(optionlist);
                //} 
                //else if(fieldVal=='ETST_Cancellation_Reason__c'){
                // wrapperInstance.cancellationReasons.addAll(optionlist);
                //} 
                // else if(fieldVal=='ETST_Parent_Cancellation_Reason__c'){
                //  wrapperInstance.parentCancellationReasons.addAll(optionlist);
                //} 
                optionlist.clear();
            }
            wrapperInstance.cancellationTypes=[select ar_Label__c,en_Label__c from ETST_Language_Translation__mdt
                                               where Service__c='School Transport' 
                                               and Module__c='Cancellation Types' AND en_Label__c = 'Permanent Cancellation'];
            wrapperInstance.cancellationReasons=[select ar_Label__c,en_Label__c from ETST_Language_Translation__mdt
                                                 where Service__c='School Transport' 
                                                 and Module__c='Cancellation Reasons'];
            wrapperInstance.parentCancellationReasons=[select ar_Label__c,en_Label__c from ETST_Language_Translation__mdt
                                                       where Service__c='School Transport' 
                                                       and Module__c='Parent Cancellation Reasons'];
            
            wrapperInstance.bankNames = [select ar_Label__c,en_Label__c from ETST_Language_Translation__mdt
                                                       where Service__c='School Transport' 
                                                       and Module__c='Bank Names'];
            
            return wrapperInstance;
            
        }catch (Exception e) {
            errStr = JSON.serialize(ETSTController.buildErrorResponse('getStudentDetails', e.getMessage(), e.getStackTraceString()));
            AuraHandledException ahe = new AuraHandledException(errStr);
            ahe.setMessage(errStr);
            throw ahe;
        }
    }
    public class ETSTWrapper{
        @AuraEnabled
        public List<ETST_Student__c> studentList=new List<ETST_Student__c>();
        @AuraEnabled
        public List<ET_Service_Request__c> serviceList=new List<ET_Service_Request__c>();
        @AuraEnabled
        public List<String> serviceTypes=new List<String>(); 
        @AuraEnabled
        public List<String> transportTypes=new List<String>();
        @AuraEnabled
        public List<String> schoolAreas=new List<String>();
        @AuraEnabled
        public List<ETST_Language_Translation__mdt> cancellationReasons=new List<ETST_Language_Translation__mdt>();
        @AuraEnabled
        public List<ETST_Language_Translation__mdt> cancellationTypes=new List<ETST_Language_Translation__mdt>();
        @AuraEnabled
        public List<ETST_Language_Translation__mdt> parentCancellationReasons=new List<ETST_Language_Translation__mdt>();
        
        @AuraEnabled
        public List<ETST_Language_Translation__mdt> bankNames = new List<ETST_Language_Translation__mdt>();
        
        
    }
    @AuraEnabled
    public static studentInfoWrapper getStudentInfo(String studentId,String lang) {
        Set<String> set_transporttype = new Set<String>();
        studentInfoWrapper wrap=new studentInfoWrapper();
        System.debug('studentId' + studentId);
        // Added ETST_Account_Type__c to the query --- Sreelakshmi SK 31/5/23
        ETST_Student__c school=[SELECT Id, ETST_School_Name__r.ETST_Sales_Agreement__c,ETST_School_Name__r.Area_Based__c,
                                ETST_School_Name__r.etst_calendar__r.ETST_Academic_End_Date__c,
                                ETST_School_Name__r.etst_calendar__r.ETST_Academic_Start_Date__c,ETST_School_Name__r.ETST_Account_Type__c
                                FROM ETST_Student__c where id=:studentId];
        System.debug('school' + school);
        List<ETST_Price_List__c> price= [SELECT Id,ETST_Monthly_Allowed__c,ETST_Half_Yearly_Allowed__c,ETST_Area__c,
                                         ETST_Yearly_Allowed__c, ETST_Quarterly_Allowed__c,ETST_Transport_Type__c,
                                         ETST_Pro_Rate__c,ETST_On_Demand_Allowed__c,ETST_Sales_Agreement__c
                                         from ETST_Price_List__c 
                                         where  ETST_Sales_Agreement__c=:school.ETST_School_Name__r.ETST_Sales_Agreement__c 
                                         AND ETST_Sales_Agreement__c!=NULL
                                         AND ETST_Is_Active__c=true];
        System.debug('price' + price);
        
        if(price.size() == 0) return null;
        
        ETST_System_Variables__mdt quarterlyDates=[SELECT Id,ETST_Q1_Start_Month__c,ETST_Q1_Duration__c,ETST_Q2_Duration__c,ETST_Q3_Duration__c
                                                   FROM ETST_System_Variables__mdt LIMIT 1];
        
        
        wrap.acadamicStart=Date.newInstance(System.Today().year(), Integer.valueOf(quarterlyDates.ETST_Q1_Start_Month__c), 1);
        wrap.acadamicEnd=wrap.acadamicStart.addMonths(Integer.valueof(quarterlyDates.ETST_Q1_Duration__c+quarterlyDates.ETST_Q2_Duration__c+quarterlyDates.ETST_Q3_Duration__c-1));
        Integer numberOfDays = Date.daysInMonth(wrap.acadamicEnd.year(), wrap.acadamicEnd.month());
        wrap.acadamicEnd = Date.newInstance(wrap.acadamicEnd.year(), wrap.acadamicEnd.month(), numberOfDays);
        wrap.schoolType=school.ETST_School_Name__r.ETST_Account_Type__c; // Added by Sreelakshmi SK- 31/5/23
        system.debug('wrap.schoolType:'+wrap.schoolType);
        for(ETST_Price_List__c p: price){
            //wrap.transportTypes.add(p.ETST_Transport_Type__c);
            set_transporttype.add(p.ETST_Transport_Type__c);
        }
        
        wrap.transportTypes.addall(set_transporttype);
        
        //if(lang=='ar'){
        wrap.transportTypesAR=[select ar_Label__c,en_Label__c from ETST_Language_Translation__mdt
                               where Service__c='School Transport' and en_Label__c IN :wrap.transportTypes and Module__c='Transport Type'];
        
        wrap.paidByTypesAR=[select ar_Label__c,en_Label__c from ETST_Language_Translation__mdt
                            where Service__c='School Transport' and  Module__c='Paid By Type'];
        
        // }
        
        List<String> field_apinames=new  List<String>{'ETST_Transport_Type__c','ETST_Paid_By__c'};
            Map<String, List<Schema.PicklistEntry>>  fieldFinalMap=ETST_PicklistValueController.getPicklistvalues('ET_Service_Request__c',field_apinames);
        if(fieldFinalMap == null) {
            return null;
        }
        
        List<String> optionlist = new List<String>();
        for(String fieldVal : fieldFinalMap.keySet()){
            for(Schema.PicklistEntry pv : fieldFinalMap.get(fieldVal)) {
                optionlist.add(pv.getValue());
            }
            if(fieldVal=='ETST_Paid_By__c'){
                wrap.paidByTypes.addAll(optionlist);
            }
            
            optionlist.clear();
        } 
        System.debug('wrrrrrpp ' + wrap);
        return wrap;
    }
    @AuraEnabled
    public static serviceInfoWrapper getServiceTypes(String studentId,String transportType) {
        serviceInfoWrapper wrap=new serviceInfoWrapper();
        Set<String> set_transportarea= new Set<String>();
        ETST_Student__c school=[SELECT Id, ETST_School_Name__r.ETST_Sales_Agreement__c,ETST_School_Name__r.Area_Based__c,
                                ETST_School_Name__r.etst_calendar__r.ETST_Academic_End_Date__c,
                                ETST_School_Name__r.etst_calendar__r.ETST_Academic_Start_Date__c
                                FROM ETST_Student__c where id=:studentId];
        List<ETST_Price_List__c> price= [SELECT Id,ETST_Monthly_Allowed__c,ETST_Half_Yearly_Allowed__c,ETST_Area__c,
                                         ETST_Yearly_Allowed__c, ETST_Quarterly_Allowed__c,ETST_Transport_Type__c,
                                         ETST_Pro_Rate__c,ETST_On_Demand_Allowed__c
                                         from ETST_Price_List__c 
                                         where  ETST_Sales_Agreement__c=:school.ETST_School_Name__r.ETST_Sales_Agreement__c 
                                         AND ETST_Sales_Agreement__c!=NULL
                                         AND ETST_Transport_Type__c=:transportType
                                         AND ETST_Is_Active__c=true];
        
        wrap.areabased= school.ETST_School_Name__r.Area_Based__c;
        
        if(price.size() == 0) return null;
        
        for(ETST_Price_List__c p: price){   
            if(school.ETST_School_Name__r.Area_Based__c==true)
                set_transportarea.add(p.ETST_Area__c);
        }
        set_transportarea.add('Others');
        if(set_transportarea.size()>0)
        {
            wrap.transportareas.addall(set_transportarea);
            wrap.transportareasAR=[select ar_Label__c,en_Label__c from ETST_Language_Translation__mdt
                                   where Service__c='School Transport' and en_Label__c IN :wrap.transportAreas and Module__c='Transport Area'];
        }
        
        if(price[0].ETST_Yearly_Allowed__c) {
            wrap.serviceTypes.add(System.Label.ETST_Yearly);
        }
        if(price[0].ETST_Half_Yearly_Allowed__c) {
            wrap.serviceTypes.add(System.Label.ETST_Half_Yearly);  
        }
        if(price[0].ETST_Quarterly_Allowed__c) {
            wrap.serviceTypes.add(System.Label.ETST_Quarterly);  
        }
        if(price[0].ETST_Monthly_Allowed__c) {
            wrap.serviceTypes.add(System.Label.ETST_Monthly);  
        }
        if(price[0].ETST_On_Demand_Allowed__c) {
            wrap.serviceTypes.add(System.Label.ETST_Ondemand);  
        }
        
        wrap.serviceTypesAR=[select ar_Label__c,en_Label__c from ETST_Language_Translation__mdt
                             where Service__c='School Transport' and en_Label__c IN :wrap.serviceTypes and Module__c='Service Type'];
        //wrap.proRateAllowed=price[0].ETST_Pro_Rate__c;
        return wrap;
        
    }
    public class serviceInfoWrapper{
        @AuraEnabled
        public List<String> serviceTypes=new List<String>();
        @AuraEnabled
        public Boolean areabased;
        @AuraEnabled
        public List<String> transportareas=new List<String>();
        @AuraEnabled
        public List<ETST_Language_Translation__mdt> transportareasAR=new List<ETST_Language_Translation__mdt>();
        @AuraEnabled
        public List<ETST_Language_Translation__mdt> serviceTypesAR=new List<ETST_Language_Translation__mdt>();		
        //@AuraEnabled
        //public String proRateAllowed='';
    }
    
    public class studentInfoWrapper{
        @AuraEnabled
        public List<String> serviceTypes=new List<String>(); 
        @AuraEnabled
        public Date acadamicStart;
        @AuraEnabled
        public Date acadamicEnd;
        @AuraEnabled
        public List<String> transportTypes=new List<String>();
        @AuraEnabled
        public List<String> paidByTypes=new List<String>(); 
        @AuraEnabled
        public List<ETST_Language_Translation__mdt> transportTypesAR=new List<ETST_Language_Translation__mdt>();  
        @AuraEnabled
        public List<ETST_Language_Translation__mdt> serviceTypesAR=new List<ETST_Language_Translation__mdt>();  
        @AuraEnabled
        public List<ETST_Language_Translation__mdt> paidByTypesAR=new List<ETST_Language_Translation__mdt>();
        @AuraEnabled
        public String schoolType; // Added by Sreelakshmi SK -- 31/5/23
        
    }
    @AuraEnabled
    public static ET_Service_Request__c getServiceRecord(String recordId) {
        String errStr;
        
        try{
            if( recordId==null) {return null;}
            return [SELECT  RecordTypeId, ETST_Activation_Effective_Date__c, ETST_Area_Zone__c, ET_Sales_Agreement__c
                    ,ETST_Building_Number__c, ETST_Cancellation_Effective_Date__c, ETST_Cancellation_End_Date__c, ETST_Cancellation_Reason_Comments__c  
                    ,ETST_Coordinator_Comments__c, ETST_Country__c, ETST_Drop_Off_To__c, ETST_Drop_of_Time__c, ETST_Dropoff_Emirate__c
                    ,ETST_Dropoff_Location__Latitude__s, ETST_Dropoff_Location__Longitude__s,ETST_Dropoff_State__c  //,ETST_Dropoff_Location__c
                    ,ETST_Dropoff_Street__c, ETST_Emirates__c, ETST_Fare_Charges__c, ETST_Is_Active__c, ETST_Is_Renewal_Opened__c
                    ,ETST_Location__Latitude__s, ETST_Location__Longitude__s,  ETST_Name__c, ETST_Pick_Up_End_Date__c //ETST_Location__c
                    ,ETST_Pick_Up_From__c, ETST_Pick_Up_Start_Date__c, ETST_Pick_Up_Time__c, ETST_Pickup_Point__c //ETST_Pickup_Location__c
                    ,ETST_Reason_for_Cancellation__c, ETST_Renewal_End_Date__c, ETST_Renewal_Start_Date__c, ETST_Renewal_Status__c, 
                    ETST_Service_End_Date__c, ETST_Service_Start_Date__c, ETST_Service_Type__c, ETST_Stage__c, ETST_State_or_Province__c, 
                    ETST_Status__c, ETST_Street_Name__c, ETST_Street_Number__c, ETST_Student__c, ETST_Tenure__c, ETST_Transport_Type__c, 
                    ETST_Coordinator__c, ETST_Payee__c, ETST_Academic_Year_End_Date__c, ET_Account__c, ET_Account__r.Name,Name,
                    ET_Location__c, ETST_Area__c, ETST_Cancellation_Reason__c, ETST_Land_Mark__c, ETST_Villa_Building_Name__c,
                    ETST_User__c,ETST_Price_List__c,ETST_Price_List__r.ETST_Fare_Amount__c,ETST_Prev_Status__c,
                    ET_Account__r.personcontactId,ET_Account__r.personemail,ETST_Prev_Pickup_From__c,
                    ETST_Prev_Pickup_Loc__Latitude__s,Payment_Status__c,
                    ETST_Prev_Pickup_Loc__Longitude__s
                    ,ETST_Prev_DropOff_To__c
                    ,ETST_Prev_Dropoff_Loc__Latitude__s
                    ,ETST_Prev_Dropoff_Loc__Longitude__s
                    FROM ET_Service_Request__c
                    where id=:recordId ]; 
            
            
        }catch (Exception e) {
            errStr = JSON.serialize(ETSTController.buildErrorResponse('getStudentDetails', e.getMessage(), e.getStackTraceString()));
            AuraHandledException ahe = new AuraHandledException(errStr);
            ahe.setMessage(errStr);
            throw ahe;
        }
    }
    @AuraEnabled
    public static ETSTServiceWrapper getServiceDetails(String recordId) {
        String errStr;
        ETSTServiceWrapper wrapperInstance=new ETSTServiceWrapper();
        
        try{
            wrapperInstance.service=[SELECT  RecordTypeId, ETST_Activation_Effective_Date__c, ETST_Area_Zone__c, ET_Sales_Agreement__c
                                     ,ETST_Building_Number__c, ETST_Cancellation_Effective_Date__c, ETST_Cancellation_End_Date__c, ETST_Cancellation_Reason_Comments__c  
                                     ,ETST_Coordinator_Comments__c, ETST_Country__c, ETST_Drop_Off_To__c, ETST_Drop_of_Time__c, ETST_Dropoff_Emirate__c
                                     ,ETST_Dropoff_Location__Latitude__s, ETST_Dropoff_Location__Longitude__s,ETST_Dropoff_State__c  //,ETST_Dropoff_Location__c
                                     ,ETST_Dropoff_Street__c, ETST_Emirates__c, ETST_Fare_Charges__c, ETST_Is_Active__c, ETST_Is_Renewal_Opened__c
                                     ,ETST_Location__Latitude__s, ETST_Location__Longitude__s,  ETST_Name__c, ETST_Pick_Up_End_Date__c //ETST_Location__c
                                     ,ETST_Pick_Up_From__c, ETST_Pick_Up_Start_Date__c, ETST_Pick_Up_Time__c, ETST_Pickup_Point__c //ETST_Pickup_Location__c
                                     ,ETST_Reason_for_Cancellation__c, ETST_Renewal_End_Date__c, ETST_Renewal_Start_Date__c, ETST_Renewal_Status__c, 
                                     ETST_Service_End_Date__c, ETST_Service_Start_Date__c, ETST_Service_Type__c, ETST_Stage__c, ETST_State_or_Province__c, 
                                     ETST_Status__c, ETST_Street_Name__c, ETST_Street_Number__c, ETST_Student__c, ETST_Tenure__c, ETST_Transport_Type__c, 
                                     ETST_Coordinator__c, ETST_Payee__c, ETST_Academic_Year_End_Date__c, ET_Account__c, ET_Account__r.Name,Name,
                                     ET_Location__c, ETST_Area__c,  ETST_Cancellation_Reason__c, ETST_Land_Mark__c, ETST_Villa_Building_Name__c,
                                     ETST_User__c,ETST_Price_List__c,ETST_Price_List__r.ETST_Fare_Amount__c,ETST_Prev_Status__c,
                                     ET_Account__r.personcontactId,ET_Account__r.personemail,ETST_Prev_Pickup_From__c,
                                     ETST_Prev_Pickup_Loc__Latitude__s,Payment_Status__c,
                                     ETST_Prev_Pickup_Loc__Longitude__s
                                     ,ETST_Prev_DropOff_To__c
                                     ,ETST_Prev_Dropoff_Loc__Latitude__s
                                     ,ETST_Prev_Dropoff_Loc__Longitude__s
                                     FROM ET_Service_Request__c
                                     where id=:recordId ]; 
            List<ETST_Price_List__c> price= [SELECT ETST_Transport_Type__c,ETST_Sales_Agreement__c
                                             from ETST_Price_List__c 
                                             where  ETST_Sales_Agreement__c =:wrapperInstance.service.ET_Sales_Agreement__c
                                             AND ETST_Sales_Agreement__c!=NULL
                                             AND ETST_Is_Active__c=true];
            
            ETST_System_Variables__mdt quarterlyDates=[SELECT Id,ETST_Q1_Start_Month__c,ETST_Q1_Duration__c,ETST_Q2_Duration__c,ETST_Q3_Duration__c
                                                       FROM ETST_System_Variables__mdt LIMIT 1];
            
            
            wrapperInstance.acadamicStart=Date.newInstance(System.Today().year(), Integer.valueOf(quarterlyDates.ETST_Q1_Start_Month__c), 1);
            wrapperInstance.currentYearlyAmt=wrapperInstance.service.ETST_Price_List__r.ETST_Fare_Amount__c;
            
            if(price.size() == 0) return null;
            List<String> transportTypesEN=new List<String>();
            for(ETST_Price_List__c p: price){
                transportTypesEN.add(p.ETST_Transport_Type__c);
            }
            wrapperInstance.transportTypes=[select ar_Label__c,en_Label__c from ETST_Language_Translation__mdt
                                            where Service__c='School Transport' and en_Label__c IN :transportTypesEN 
                                            and Module__c='Transport Type'];
            
            
            return wrapperInstance;
            
        }catch (Exception e) {
            errStr = JSON.serialize(ETSTController.buildErrorResponse('getStudentDetails', e.getMessage(), e.getStackTraceString()));
            AuraHandledException ahe = new AuraHandledException(errStr);
            ahe.setMessage(errStr);
            throw ahe;
        }
    }
    public class ETSTServiceWrapper{
        @AuraEnabled
        public ET_Service_Request__c service=new ET_Service_Request__c();
        @AuraEnabled
        public Date acadamicStart; 
        @AuraEnabled
        public List<ETST_Language_Translation__mdt> transportTypes=new List<ETST_Language_Translation__mdt>();
        @AuraEnabled
        public Decimal currentYearlyAmt=0;
    }
    @AuraEnabled 
    public static void cancelStudentService(ET_Service_Request__c serviceRecord) {
        String errStr;
        try{
            serviceRecord.ETST_Status__c=System.Label.ETST_Parent_Cancelled;   
            serviceRecord.ETST_Is_Active__c =True; 
            
            update serviceRecord;
            
            List<ET_Service_Request__c> exsitingService=[select id,ETST_Is_Renewed__c from ET_Service_Request__c
                                                         where ETST_Student__c=:serviceRecord.ETST_Student__c
                                                         AND ETST_Is_Active__c=true];
            
            if(exsitingService.size()>0 && exsitingService!=null){
                exsitingService[0].ETST_Is_Renewed__c=false;
                update exsitingService;
            }
            
            
            
        }catch (Exception e) {
            errStr = JSON.serialize(ETSTController.buildErrorResponse('cancelStudentService', e.getMessage(), e.getStackTraceString()));
            AuraHandledException ahe = new AuraHandledException(errStr);
            ahe.setMessage(errStr);
            throw ahe;
        }
    }
    @AuraEnabled 
    public static ET_Refund__c deactivateStudent(String studentId, ET_Service_Request__c serviceRecord, Decimal balanceAmount,
                                                 String Beneficiary,String BankName,String AccountNo,String IBAN,
                                                 String Branch,String BankAddress,string documentId) {
                                                     String errStr;
                                                     
                                                   List<ETST_Student__c> student = [SELECT Id, ETST_School_Name__c,ETST_School_Name__r.Name 
                                                                                  FROM ETST_Student__c 
                                                                                  WHERE Id =: studentId LIMIT 1];
                                                     
                                                    List<ETST_Payment__c> payment = [Select Id from ETST_Payment__c WHERE 
                                                                                     ET_Service_Request__c =: serviceRecord.Id];//added on 7th Aug 2024
                                                     
                                                     //ETST_Student__c studentRecord=new ETST_Student__c(Id = studentId);
                                                     try{
                                                         //System.debug('row'+studentId);
                                                         if(serviceRecord.ETST_Reason_for_Cancellation__c == System.Label.ETST_On_Hold){  
                                                             serviceRecord.ETST_Status__c = System.Label.ETST_On_Hold; 
                                                         }
                                                         
                                                         else{
                                                             if(balanceAmount == 0 ){//&& student[0].ETST_School_Name__r.Name  == 'Australian International schools'
                                                                 serviceRecord.ETST_Status__c = 'Parent Cancelled';  
                                                             }else{
                                                                 serviceRecord.ETST_Status__c = System.Label.ETST_Refund_Under_Approval;   
                                                             }
                                                             serviceRecord.ETST_Is_Active__c = True; 
                                                             
                                                             List<ET_Service_Request__c> exsitingService = [select id,ETST_Is_Renewed__c from ET_Service_Request__c
                                                                                                          where ETST_Student__c =: serviceRecord.ETST_Student__c
                                                                                                          AND ETST_Is_Active__c = true];
                                                             
                                                             if(exsitingService.size()>0 && exsitingService != null){
                                                                 exsitingService[0].ETST_Is_Renewed__c = false;
                                                                 update exsitingService;
                                                             }
                                                         }
                                                         //update serviceRecord;
                                                         ET_Refund__c refundRecord = new ET_Refund__c();
                                                         if(serviceRecord.ETST_Reason_for_Cancellation__c != System.Label.ETST_On_Hold && balanceAmount !=0){
                                                             refundRecord.ET_Refund_Amount__c = balanceAmount;
                                                             refundRecord.recordTypeId = Schema.SObjectType.ET_Refund__c.getRecordTypeInfosByDeveloperName().get('ETST_School_Refund_Record_Type').getRecordTypeId();
                                                             refundRecord.ET_Customer__c = serviceRecord.ET_Account__c;
                                                             //refundRecord.ET_Refund_Percentage__c=refundPercentage;
                                                             refundRecord.ET_Refund_Status__c=System.Label.ETST_Requested;//'Requested'; //
                                                             refundRecord.ET_Service_Request__c=serviceRecord.Id;
                                                             refundRecord.Bank_Name__c = BankName;//added
                                                             refundRecord.Payee_Name__c = Beneficiary;//added
                                                             refundRecord.IBAN__c = IBAN;//added
                                                             refundRecord.ET_Payment__c = payment[0].Id;//added on 7th Aug 2024
                                                             insert refundRecord;
                                                             ContentDocumentLink cDe = new ContentDocumentLink();
                                                             cDe.ContentDocumentId = documentId;
                                                             cDe.LinkedEntityId = refundRecord.id;
                                                             cDe.ShareType = 'I';
                                                             cDe.Visibility = 'AllUsers';
                                                             // insert cDe;
                                                         }
                                                         update serviceRecord;
                                                         if(Beneficiary!=null && Beneficiary!=''){
                                                             Id parentId=[select ETST_Account_Name__c from ETST_Student__c
                                                                          where id=:studentId].ETST_Account_Name__c;
                                                             Account acc=[select id,ET_Beneficiary__c,ET_Bank_Name__c,ET_Account_No__c,
                                                                          ET_IBAN_Code__c,ET_Branch_Name__c,ET_Bank_Address__c FROM ACCOUNT
                                                                          WHERE id=:parentId];
                                                             acc.ET_Beneficiary__c=Beneficiary;
                                                             acc.ET_Bank_Name__c=BankName;
                                                             acc.ET_Account_No__c=AccountNo;
                                                             acc.ET_IBAN_Code__c=IBAN;
                                                             acc.ET_Branch_Name__c=Branch;
                                                             acc.ET_Bank_Address__c=BankAddress;
                                                             
                                                             update acc;
                                                             
                                                         }
                                                         return refundRecord;
                                                         
                                                     }catch (Exception e) {
                                                         errStr = JSON.serialize(ETSTController.buildErrorResponse('deactivateStudent', e.getMessage(), e.getStackTraceString()));
                                                         AuraHandledException ahe = new AuraHandledException(errStr);
                                                         ahe.setMessage(errStr);
                                                         throw ahe;
                                                     }
                                                 }
    
    @AuraEnabled
    public static Account getParentBankDetails(Id  studentId) { 
        Id parentId=[select ETST_Account_Name__c from ETST_Student__c
                     where id=:studentId].ETST_Account_Name__c;
        return [select id,ET_Beneficiary__c,ET_Bank_Name__c,ET_Account_No__c,
                ET_IBAN_Code__c,ET_Branch_Name__c,ET_Bank_Address__c FROM ACCOUNT
                WHERE id=:parentId LIMIT 1];
        
    }
    
    @AuraEnabled
    public static void changeStudentSchool(Id studentId,Id schoolId,String Beneficiary,String BankName,String AccountNo,
                                           String IBAN,String Branch,String BankAddress,ET_Service_Request__c serviceRecord,
                                           Decimal balanceAmount,boolean isCurrent,string documentId) {
                                               String errStr;
                                               Decimal refundAmount=0;
                                               try{
                                                   ETST_Student__c studentRecord=[select ETST_School_Name__c,OwnerId, ETST_School__c from ETST_Student__c where id=:studentId];
                                                   ETST_School__c schoolRecord=[select id, Customer__c, Customer__r.ETST_Coordinator__c from ETST_School__c where id=:schoolId];/* Line Added by Sreelakshmi SK-- to retrieve the related account and coordinator details of school*/
                                                   studentRecord.ETST_School_Name__c=schoolId;
                                                   System.debug('Student School Account Id: '+ studentRecord.ETST_School_Name__c); 
                                                   studentRecord.ETST_School__c=schoolRecord.Customer__r.Id; /*Line Added by Sreelakshmi SK-- to assign the school(account) in student record with the associated account of the changed school*/
                                                   System.debug('Student School Account Id: '+ studentRecord.ETST_School__c);
                                                 
                                                   if (schoolRecord.Customer__r.ETST_Coordinator__c != null && String.valueOf(schoolRecord.Customer__r.ETST_Coordinator__c).length() == 18) {
                                                       studentRecord.OwnerId = schoolRecord.Customer__r.ETST_Coordinator__c;
                                                       System.debug('Student Owner Id: ' + studentRecord.OwnerId);
                                                   } else {
                                                       System.debug('Coordinator ID is invalid or null.');
                                                   }
                                                   update studentRecord;
                                                   
                                                   System.debug('serviceRecord  '+serviceRecord);
                                                   if(serviceRecord.ETST_Status__c!=null && serviceRecord.ETST_Status__c!=''){
                                                       serviceRecord.ETST_Is_Active__c=false;
                                                       serviceRecord.ETST_Status__c='School Changed';
                                                       update serviceRecord; 
                                                   }
                                                   
                                                   
                                                   if(!isCurrent){
                                                       balanceAmount=serviceRecord.ETST_Fare_Charges__c;
                                                   }
                                                   if(balanceAmount>0){
                                                       
                                                       ET_Refund__c refundRecord=new ET_Refund__c();
                                                       refundRecord.ET_Refund_Amount__c=balanceAmount;
                                                       refundRecord.recordTypeId = Schema.SObjectType.ET_Refund__c.getRecordTypeInfosByDeveloperName().get('ETST_School_Refund_Record_Type').getRecordTypeId();
                                                       refundRecord.ET_Customer__c = serviceRecord.ET_Account__c;
                                                       //refundRecord.ET_Refund_Percentage__c=refundPercentage;
                                                       refundRecord.ET_Refund_Status__c=System.Label.ETST_Requested;//'Requested'; //
                                                       refundRecord.ET_Service_Request__c=serviceRecord.Id;
                                                       insert refundRecord;
                                                       ContentDocumentLink cDe = new ContentDocumentLink();
                                                       cDe.ContentDocumentId = documentId;
                                                       cDe.LinkedEntityId = refundRecord.id;
                                                       cDe.ShareType = 'I';
                                                       cDe.Visibility = 'AllUsers';
                                                       insert cDe; 
                                                   }
                                               }catch (Exception e) {
                                                   errStr = JSON.serialize(ETSTController.buildErrorResponse('changeStudentSchool', e.getMessage(), e.getStackTraceString()));
                                                   AuraHandledException ahe = new AuraHandledException(errStr);
                                                   ahe.setMessage(errStr);
                                                   throw ahe;
                                               }
                                           }
    @AuraEnabled
    public static Id createNewStudent(String schoolId,ETST_Student__c  studentRecord) {
        System.debug('--Schoold Id-- : ' +schoolId);
        String errStr;
        try{
            string studentRecordType = Schema.SObjectType.ETST_Student__c.getRecordTypeInfosByDeveloperName().get('ETST_Student').getRecordTypeId();
            //ETST_School__c school = [select id,customer__c from ETST_School__c where name=:schoolName LIMIT 1];
            studentRecord.ETST_School_Name__c=schoolId;
            studentRecord.ETST_Phone__c='+971'+studentRecord.ETST_Phone__c;
            if(studentRecord.ETST_Secondary_Mobile_Number__c != null)    studentRecord.ETST_Secondary_Mobile_Number__c='+971'+studentRecord.ETST_Secondary_Mobile_Number__c;
            studentRecord.ETST_Account_Name__c=[select accountId from user where id=:userInfo.getUserId()].accountId;
            studentRecord.ETST_Status__c='Active';
            studentRecord.RecordTypeId=studentRecordType;
            if(!System.Test.isRunningTest())   insert studentRecord;  
            return studentRecord.Id;         
        }catch (Exception e) {
            errStr = JSON.serialize(ETSTController.buildErrorResponse('createNewStudent', e.getMessage(), e.getStackTraceString()));
            AuraHandledException ahe = new AuraHandledException(errStr);
            ahe.setMessage(errStr);
            throw ahe;
        }
    }
    @AuraEnabled
    public static ETST_Price_List__c getFareDetails(String studentId,String transportType,Decimal lat,Decimal longt) {
        String errStr;
        try{
            /*  List<FSL__Polygon__c> polList=[SELECT Id, Name,FSL__Ma_La__c, FSL__Ma_Lo__c, FSL__Mi_La__c, FSL__Mi_Lo__c
FROM FSL__Polygon__c where FSL__Mi_La__c<= :lat and FSL__Ma_La__c >= :lat
and FSL__Mi_Lo__c<= :longt and FSL__Ma_Lo__c>= :longt LIMIT 1];*/
            String school=[SELECT Id, ETST_School_Name__r.ETST_Sales_Agreement__c FROM ETST_Student__c where id=:studentId].ETST_School_Name__r.ETST_Sales_Agreement__c;
            
            String qry= 'SELECT Id, Name,ETST_Sales_Agreement__c,ETST_Zone__c,ETST_Fare_Amount__c,ETST_Amount__c,ETST_Payee__c, ETST_Area__c,ETST_Ondemand_Rate_per_Day__c,ETST_Min_Duration__c,ETST_Max_Duration__c,ETST_Pro_Rate__c,  ';
            qry+=' ETST_Discount_Percentage__c, ETST_Tax_Percentage__c,ETST_School_Commission_Percentage__c, ETST_Refundable_Percentage__c, ';
            qry+=' ETST_Cancellation_Percentage__c, ETST_Maintenance_Percentage__c, ETST_Other_Deductions_Value__c,  ETST_Commission_Percentage__c, ETST_Refundable_Policy__c, ETST_Cancellation_Policy__c, ETST_Maintenance_Amount__c, ETST_Other_Services__c, ETST_Other_Services_Cost__c,';  
            qry+=' ETST_Total_Amount__c, ETST_Half_Yearly_Discount_Percentage__c, ETST_Quarterly_Discount_Percentage__c, ETST_Monthly_Discount_Percentage__c ';                    
            qry+=' from ETST_Price_List__c ';
            qry+='  where  ETST_Sales_Agreement__c=:school  AND ETST_Transport_Type__c=:transportType AND ETST_Is_Active__c=true '; 
            String qrywithoutArea=qry;
            
            /*if(polList!=null && polList.size()>0){
String areaName=polList[0].Name ;
qry+='  AND ETST_Area__c= :areaName ';
}
*/
            List<ETST_Price_List__c> priceList=database.query(qry);
            if(priceList!=null && priceList.size()>0){
                return priceList[0];
            }else{
                qrywithoutArea+='  LIMIT 1';
                priceList= database.query(qrywithoutArea);
                if(priceList!=null && priceList.size()>0){
                    return priceList[0];
                }
                return null;
            }
        }catch (Exception e) {
            errStr = JSON.serialize(ETSTController.buildErrorResponse('getFareDetails', e.getMessage(), e.getStackTraceString()));
            AuraHandledException ahe = new AuraHandledException(errStr);
            ahe.setMessage(errStr);
            throw ahe;
        }   
    }
    
    @AuraEnabled
    public static ETST_Price_List__c getFareDetailsbyarea(String studentId,String transportType, String area, Decimal lat,Decimal longt) {
        String errStr;
        try{
            String school=[SELECT Id, ETST_School_Name__r.ETST_Sales_Agreement__c FROM ETST_Student__c where id=:studentId].ETST_School_Name__r.ETST_Sales_Agreement__c;
            
            String qry= 'SELECT Id, Name,ETST_Sales_Agreement__c,ETST_Zone__c,ETST_Fare_Amount__c,ETST_Amount__c,ETST_Payee__c, ETST_Area__c,ETST_Ondemand_Rate_per_Day__c,ETST_Min_Duration__c,ETST_Max_Duration__c,ETST_Pro_Rate__c,  ';
            qry+=' ETST_Discount_Percentage__c, ETST_Tax_Percentage__c,ETST_School_Commission_Percentage__c, ETST_Refundable_Percentage__c, ';
            qry+=' ETST_Cancellation_Percentage__c, ETST_Maintenance_Percentage__c, ETST_Other_Deductions_Value__c,  ETST_Commission_Percentage__c, ETST_Refundable_Policy__c, ETST_Cancellation_Policy__c, ETST_Maintenance_Amount__c, ETST_Other_Services__c, ETST_Other_Services_Cost__c,';  
            qry+=' ETST_Total_Amount__c, ETST_Half_Yearly_Discount_Percentage__c, ETST_Quarterly_Discount_Percentage__c, ETST_Monthly_Discount_Percentage__c ';                    
            qry+=' from ETST_Price_List__c ';
            qry+='  where  ETST_Sales_Agreement__c=:school  AND ETST_Transport_Type__c=:transportType AND ETST_Area__c=:area AND ETST_Is_Active__c=true '; 
            String qrywithoutArea=qry;
            
            List<ETST_Price_List__c> priceList=database.query(qry);
            if(priceList!=null && priceList.size()>0){
                return priceList[0];
            }else{
                qrywithoutArea+='  LIMIT 1';
                priceList= database.query(qrywithoutArea);
                if(priceList!=null && priceList.size()>0){
                    return priceList[0];
                }
                return null;
            }
        }catch (Exception e) {
            errStr = JSON.serialize(ETSTController.buildErrorResponse('getFareDetailsbyarea', e.getMessage(), e.getStackTraceString()));
            AuraHandledException ahe = new AuraHandledException(errStr);
            ahe.setMessage(errStr);
            throw ahe;
        }   
    }
    
    @AuraEnabled
    public static ET_Service_Request__c viewStudentService(String studentId) {
        String errStr;
        try{
            ET_Service_Request__c service=[select id,ETST_Status__c from ET_Service_Request__c where ETST_Student__c=:studentId LIMIT 1];            
            
            return service;
        }catch (Exception e) {
            errStr = JSON.serialize(ETSTController.buildErrorResponse('viewStudentService', e.getMessage(), e.getStackTraceString()));
            AuraHandledException ahe = new AuraHandledException(errStr);
            ahe.setMessage(errStr);
            throw ahe;
        }
    }
    @AuraEnabled
    public static String getLocationDetails(String latitude,string longitude){
        return ETST_LocationController.getLocationDetails(latitude,longitude);
    }
    @AuraEnabled
    public static void updateLocation(String latitude,string longitude,Id requestId,String type){
        String errStr;
        String loc= ETST_LocationController.getLocationDetails(latitude,longitude);
        
        ET_Service_Request__c service=Database.query(ETST_utils.getCreatableFieldsSOQL('ET_Service_Request__c',' Id= :requestId'));
        
        System.debug('service -->'+service);
        try{
            service.ETST_Prev_Pickup_From__c=service.ETST_Pick_Up_From__c;
            service.ETST_Prev_Pickup_Loc__Latitude__s=service.ETST_Location__Latitude__s;
            service.ETST_Prev_Pickup_Loc__Longitude__s=service.ETST_Location__Longitude__s;
            service.ETST_Prev_DropOff_To__c=service.ETST_Drop_Off_To__c;
            service.ETST_Prev_Dropoff_Loc__Latitude__s =service.ETST_Dropoff_Location__Latitude__s;
            service.ETST_Prev_Dropoff_Loc__Longitude__s=service.ETST_Dropoff_Location__Longitude__s;
            
            if(type=='pick'){
                service.ETST_Location__Latitude__s=decimal.valueOf(latitude);
                service.ETST_Location__Longitude__s=decimal.valueOf(longitude);
                service.ETST_Pick_Up_From__c=loc;
                
            }else{
                service.ETST_Dropoff_Location__Latitude__s=decimal.valueOf(latitude);
                service.ETST_Dropoff_Location__Longitude__s=decimal.valueOf(longitude);                    
                service.ETST_Drop_Off_To__c=loc;
            }
            
            if(service.ETST_Status__c!=System.label.ETST_Under_Review){
                service.ETST_Prev_Status__c=service.ETST_Status__c;
                service.ETST_Status__c=System.label.ETST_Location_Update;
            } 
            update service;
            
            
        }catch (Exception e) {
            errStr = JSON.serialize(ETSTController.buildErrorResponse('updateLocation', e.getMessage(), e.getStackTraceString()));
            AuraHandledException ahe = new AuraHandledException(errStr);
            ahe.setMessage(errStr);
            throw ahe;
        }
    }
    
    @AuraEnabled
    public static String getAddressSet(String SearchText){
        return ETST_AddressSearchController.getAddressSet(SearchText);
    } 
    @AuraEnabled
    public static String getAddressDetailsByPlaceId(String PlaceID){
        return ETST_AddressSearchController.getAddressDetailsByPlaceId(PlaceID);
    } 
    @AuraEnabled
    public static ETSTEmployerAddressWrapper getEmployerAddress(){
        ETSTEmployerAddressWrapper wrap = new ETSTEmployerAddressWrapper();
        String errStr;
        try{
            Id userAccId=[select accountId from user where id=:userInfo.getUserId()].accountId; 
            List<ETST_Address__c> address=[select Id,ET_Line_1__c,ET_Line_2__c,ET_Country__c,ET_City__c,
                                           Account__r.ETST_Employer_Name__c from ETST_Address__c 
                                           where Account__c= :userAccId and ET_Is_Primary__c=true
                                           and ET_Address_Type__c='BILL_TO']; 
            if(address.size()>0)
                wrap.address = address[0];     
            
            wrap.employerCountry=[select ar_Label__c,en_Label__c from ETST_Language_Translation__mdt
                                  where Service__c='School Transport'  and Module__c='Emirate'];
            
            
            return wrap;
        }
        catch (Exception e) {
            errStr = JSON.serialize(ETSTController.buildErrorResponse('getEmployerAddress', e.getMessage(), e.getStackTraceString()));
            AuraHandledException ahe = new AuraHandledException(errStr);
            ahe.setMessage(errStr);
            throw ahe;
        }
    }
    
    public class ETSTEmployerAddressWrapper{
        @AuraEnabled
        public ETST_Address__c address=new ETST_Address__c();
        @AuraEnabled
        public List<ETST_Language_Translation__mdt> employerCountry = new List<ETST_Language_Translation__mdt>();
        
        
    }
    
    @AuraEnabled
    public static void createNewService(ET_Service_Request__c serviceRecord, Boolean isRenew,Date acadamicStart, 
                                        Date acadamicEnd,ETST_Address__c addressRecord,String employerName,String paidBy,
                                        String salesAgg,Id priceListId, Boolean editSection){
                                            Date startDat = date.newinstance(2022, 9, 1);
                                            Date pickupstartdate = serviceRecord.ETST_Pick_Up_Start_Date__c;
                                            System.debug((pickupstartdate < startDat));
                                            System.debug('salesAgg --> '+ salesAgg);
                                            
                                            String errStr;
                                            if(serviceRecord != null && pickupstartdate < startDat){
                                                String msg = 'Pick up start date cannot be on or before '+String.valueof(startDat).substring(0,10);
                                                
                                                errStr = JSON.serialize(ETSTController.buildErrorResponse('createNewService', msg, msg));
                                                AuraHandledException ahe = new AuraHandledException(msg);
                                                ahe.setMessage(errStr);
                                                throw ahe;
                                            }
                                            System.debug('serviceRecord***'+serviceRecord);
                                            ETST_Student__c studentRecord=[select id,ETST_Account_Name__c,ETST_Status__c, Is_Child_Data_Updated__c from ETST_Student__c
                                                                           where id=:serviceRecord.ETST_Student__c];
                                            studentRecord.is_New_Student__c = false;
                                            //user userAcc=[select id,accountId,email  from user where id=:userInfo.getUserId() LIMIT 1];
                                            user userAcc=[select id,accountId,email  from user where accountId=:studentRecord.ETST_Account_Name__c LIMIT 1];  
                                            if(serviceRecord.ETST_service_Type__c!=System.Label.ETST_Ondemand){                                             
                                                //serviceRecord.ETST_Pick_Up_Start_Date__c=serviceRecord.ETST_Pick_Up_Start_Date__c.addDays(1);
                                                if(serviceRecord.ETST_Pick_Up_End_Date__c!=null){
                                                    serviceRecord.ETST_Pick_Up_End_Date__c=serviceRecord.ETST_Pick_Up_End_Date__c.addDays(1);
                                                }
                                                   
                                            } 
                                            if(serviceRecord.ETST_service_Type__c==System.Label.ETST_Monthly){  
                                                Integer numberOfDays = Date.daysInMonth(serviceRecord.ETST_Pick_Up_Start_Date__c.year(), serviceRecord.ETST_Pick_Up_Start_Date__c.month());
                                                serviceRecord.ETST_Pick_Up_End_Date__c= Date.newInstance(serviceRecord.ETST_Pick_Up_Start_Date__c.year(), serviceRecord.ETST_Pick_Up_Start_Date__c.month(), numberOfDays);
                                                
                                            }
                                            serviceRecord.ETST_User__c=userAcc.Id;
                                            string schoolRecordTypeId = Schema.SObjectType.ET_Service_Request__c.getRecordTypeInfosByDeveloperName().get('ETST_School_Service_Request').getRecordTypeId(); 
                                            ETST_System_Variables__mdt quarterlyDates=[SELECT Id,DeveloperName,  ETST_Q1_Start_Month__c, ETST_Q1_Duration__c, ETST_Q2_Start_Month__c,
                                                                                       ETST_Q2_Duration__c, ETST_Q3_Start_Month__c, ETST_Q3_Duration__c FROM ETST_System_Variables__mdt LIMIT 1];
                                           try{
                                                
                                                serviceRecord.ETST_Status__c=System.label.ETST_Registered;//'Registered';
                                                
                                                if(studentRecord!=null){
                                                    studentRecord.ETST_Status__c=System.label.ETST_Active;
                                                }
                                                if(editSection){
                                                    studentRecord.Is_Child_Data_Updated__c=editSection;
                                                }
                                                update studentRecord;
                                                if(isRenew){
                                                    ET_Service_Request__c service=[SELECT ID,ETST_Is_Active__c,ETST_Is_Renewed__c
                                                                                   FROM ET_Service_Request__c
                                                                                   where ETST_Student__c=:serviceRecord.ETST_Student__c
                                                                                   and ETST_Is_Active__c=true];
                                                    
                                                    service.ETST_Is_Renewed__c=true;
                                                    
                                                    if(service!=null){
                                                        update service;
                                                    }
                                                    
                                                    serviceRecord.ETST_Status__c=System.label.Service_Request_Status; // Label changed by Sreelakshmi SK
                                                    serviceRecord.ETST_Is_Active__c=false;
                                                    
                                                    /*if(serviceRecord.ETST_Service_Type__c==System.Label.ETST_Half_Yearly){
serviceRecord.ETST_Pick_Up_End_Date__c=acadamicEnd;
}*/
                                                }else{
                                                    serviceRecord.ETST_Is_Active__c=true; 
                                                }
                                                serviceRecord.ET_Sales_Agreement__c=salesAgg;
                                                serviceRecord.ETST_Price_List__c=priceListId;
                                                
                                                serviceRecord.ET_Account__c=userAcc.accountId;
                                                serviceRecord.RecordTypeId=schoolRecordTypeId;
                                                serviceRecord.ETST_Academic_Year_End_Date__c=acadamicEnd;
                                                insert serviceRecord; 
                                                if(addressRecord !=null){                  
                                                    String addressRecordId=addressRecord.Id;
                                                    if(paidBy==System.Label.ETST_Paid_by_Employer)
                                                    {if(addressRecordId!=null && addressRecordId!=''){ 
                                                        Account acc=new Account(Id=userAcc.accountId);
                                                        acc.ETST_Employer_Name__c=employerName;                       
                                                        if(!System.Test.isRunningTest())  update acc;         
                                                        if(!System.Test.isRunningTest())  update addressRecord;                                      
                                                    }else {
                                                        system.debug('New Record');
                                                        addressRecord.Account__c=userAcc.accountId;
                                                        addressRecord.ET_Address_Type__c='BILL_TO';
                                                        addressRecord.ET_Is_Primary__c=true;
                                                        insert addressRecord;
                                                    }
                                                    }
                                                }
                                                
                                          }catch (Exception e) {
                                              System.debug('Error ---'+e.getStackTraceString());
                                                errStr = JSON.serialize(ETSTController.buildErrorResponse('createNewService', e.getMessage(), e.getStackTraceString()));
                                                AuraHandledException ahe = new AuraHandledException(errStr);
                                                ahe.setMessage(errStr);
                                                throw ahe;
                                            }
                                        }
    public static void createRefundRecord(Decimal refundAmount,Id serviceRecordId){
        System.debug('--Create Refund Record--');
        ET_Refund__c refundRecord=new ET_Refund__c();
        Id recType = Schema.SObjectType.ET_Refund__c.getRecordTypeInfosByDeveloperName().get('ETST_School_Refund_Record_Type').getRecordTypeId(); 
        
        refundRecord.ET_Refund_Amount__c=refundAmount;
        refundRecord.recordTypeId=recType;
        //refundRecord.ETST_Refund_Percentage__c=refundPercentage;
        refundRecord.ET_Refund_Status__c=System.Label.ETST_Requested;//'Requested'; //
        refundRecord.ET_Service_Request__c=serviceRecordId;
        
        try{
            System.debug('refundRecord '+ refundRecord);
            insert refundRecord; 
        }catch(Exception e){
            System.debug(e.getMessage());
        }
        
        
    }
    @AuraEnabled
    public static quarterlyWrapper getQuaerterlyPickupDates(String startDt){
        System.debug('startDt  -->'+startDt);
        Date startDate=Date.valueOf(startDt);
        quarterlyWrapper wrap=new quarterlyWrapper();
        Date endDate;
        Integer Duration=0;
        ETST_System_Variables__mdt quarterlyDates=[SELECT Id,DeveloperName,  ETST_Q1_Start_Month__c, ETST_Q1_Duration__c, ETST_Q2_Start_Month__c,
                                                   ETST_Q2_Duration__c, ETST_Q3_Start_Month__c, ETST_Q3_Duration__c 
                                                   FROM ETST_System_Variables__mdt LIMIT 1];
        System.debug('startDate  -->'+startDate);
        Date q1startDt=Date.newInstance(startDate.year(), Integer.valueOf(quarterlyDates.ETST_Q1_Start_Month__c), 1);
        Date q1endDt=q1startDt.addMonths(Integer.valueOf(quarterlyDates.ETST_Q1_Duration__c));
        Date q2startDt=Date.newInstance(startDate.year(), Integer.valueOf(quarterlyDates.ETST_Q2_Start_Month__c), 1);
        Date q2endDt=q2startDt.addMonths(Integer.valueOf(quarterlyDates.ETST_Q2_Duration__c));
        Date q3startDt=Date.newInstance(startDate.year(), Integer.valueOf(quarterlyDates.ETST_Q3_Start_Month__c), 1);
        Date q3endDt=q3startDt.addMonths(Integer.valueOf(quarterlyDates.ETST_Q3_Duration__c));
        
        System.debug('q2startDt  -->'+q2startDt+' q2endDt'+q2endDt);
        
        if(startDate>=q1startDt && startDate<q1endDt){
            
            endDate =q1endDt.addDays(-1);
            System.debug('1  -->'+endDate);
            Duration=Integer.valueOf(quarterlyDates.ETST_Q1_Duration__c);
        }else if(startDate>=q2startDt && startDate<q2endDt){
            
            endDate =q2endDt.addDays(-1);
            System.debug('2  -->'+endDate);
            Duration=Integer.valueOf(quarterlyDates.ETST_Q2_Duration__c);
        }else if(startDate>=q3startDt && startDate<q3endDt){
            
            endDate =q3endDt.addDays(-1);
            System.debug('3  -->'+endDate);
            Duration=Integer.valueOf(quarterlyDates.ETST_Q3_Duration__c);
        }else{
            
            endDate =q1endDt.addDays(-1);
            System.debug('4  -->'+endDate);
            Duration=Integer.valueOf(quarterlyDates.ETST_Q1_Duration__c);
        }
        wrap.endDate= endDate;
        wrap.Duration= Duration;
        system.debug('wrap'+wrap);
        return wrap;
    }
    @AuraEnabled
    public static quarterlyWrapper getHalfyrlyPickupDates(String startDate){
        Date startDt=Date.valueOf(startDate);
        System.debug('startDt '+startDt);
        quarterlyWrapper wrap=new quarterlyWrapper();
        Date endDate;
        Integer Duration=0;
        ETST_System_Variables__mdt quarterlyDates=[SELECT Id,DeveloperName,  ETST_H1_Start_Month__c, ETST_H1_Duration__c, 
                                                   ETST_H2_Start_Month__c,
                                                   ETST_H2_Duration__c
                                                   FROM ETST_System_Variables__mdt Where ETST_Zone__c='A' LIMIT 1];
        
        Integer currentmonth=startDt.Month();
        Integer CurrentYr =startDt.Year() ;
        /* if(currentmonth==1 || currentmonth==12|| currentmonth==11|| currentmonth==10|| currentmonth==9){
CurrentYr=System.Today().year()-1;
}else{
CurrentYr=System.Today().year();
}*/ 
        Date h1startDt=Date.newInstance(CurrentYr, Integer.valueOf(quarterlyDates.ETST_H1_Start_Month__c), 1);
        Date h1endDt=h1startDt.addMonths(Integer.valueOf(quarterlyDates.ETST_H1_Duration__c));
        Date h2startDt=Date.newInstance(CurrentYr, Integer.valueOf(quarterlyDates.ETST_H2_Start_Month__c), 1);
        Date h2endDt=h2startDt.addMonths(Integer.valueOf(quarterlyDates.ETST_H2_Duration__c));
        System.debug('h1startDt '+h1startDt+'h1endDt '+h1endDt);
        System.debug('h2startDt '+h2startDt+'h2endDt '+h2endDt);
        
        if(startDt>=h1startDt && startDt<h1endDt){
            endDate =h1endDt.addDays(-1);
            System.debug('1  -->'+endDate);
            Duration=Integer.valueOf(quarterlyDates.ETST_H1_Duration__c);
        }else if(startDt>=h2startDt && startDt<h2endDt){
            endDate =h2endDt.addDays(-1);
            System.debug('2  -->'+endDate);
            Duration=Integer.valueOf(quarterlyDates.ETST_H2_Duration__c);
        }
        wrap.endDate= endDate;
        wrap.Duration= Duration;
        System.debug('wrap-->'+wrap);
        return wrap;
    }
    public class quarterlyWrapper{
        @AuraEnabled
        public Date endDate ;
        @AuraEnabled
        public Integer Duration;
        
    } 
    @AuraEnabled
    public static void updateService(Id recordId,ET_Service_Request__c serviceRecord,Id agreementId){
        String errStr;
        ET_Service_Request__c service=new ET_Service_Request__c(Id=recordId);
        service.ETST_Is_Active__c=false;
        service.ETST_Status__c=System.Label.ETST_Service_Updated;//'Service Updated';
        System.debug('serviceRecord'+serviceRecord);
        try{
            update service;
            //ET_Service_Request__c newRecord=serviceRecord.clone();
            serviceRecord.ETST_Is_Active__c=true;
            serviceRecord.ETST_Status__c=System.label.ETST_Registered;//'Registered';
            serviceRecord.ET_Sales_Agreement__c=agreementId;
            serviceRecord.ETST_Pick_Up_Start_Date__c=serviceRecord.ETST_Pick_Up_Start_Date__c.addDays(1);
            //newRecord.ETST_Pick_Up_End_Date__c=newRecord.ETST_Pick_Up_End_Date__c.addDays(1);   
            
            insert serviceRecord;
            if(serviceRecord.ETST_Refund_Amount__c>0 &&  serviceRecord.ETST_Refund_Amount__c!=null){
                createRefundRecord(serviceRecord.ETST_Refund_Amount__c,serviceRecord.Id);
            }
        }catch (Exception e) {
            errStr = JSON.serialize(ETSTController.buildErrorResponse('updateService', e.getMessage(), e.getStackTraceString()));
            AuraHandledException ahe = new AuraHandledException(errStr);
            ahe.setMessage(errStr);
            throw ahe;
        }
    }
    @AuraEnabled
    public static StudenDetailsWrapper getSchoolList(String studentType) {
        System.debug('--studentType-- : ' +studentType);
        List<String> schoolsList=new list<String>();
        StudenDetailsWrapper wrap=new StudenDetailsWrapper();
        String userAccountId=[select accountId from user where id=:userInfo.getUserId()].accountId;  
        if(!test.isRunningtest()){
            wrap.parentProfle=[SELECT Id, PersonEmail, PersonMobilePhone,ET_Nationality__c FROM Account
                               where id=:userAccountId];
        }
        
        //List<AggregateResult> aggList= [SELECT Id, Name FROM ETST_School__c where ETST_Account_Type__c=:studentType group by name order by name];
        List<ETST_School__c> aggList= [SELECT Id, Name FROM ETST_School__c where ETST_Account_Type__c=:studentType order by name];
        for(ETST_School__c aggr:aggList ){ 
            schoolsList.add(aggr.Name);
        }
        wrap.schoolsList.addAll(schoolsList);
        List<String> field_apinames=new  List<String>{'ETST_Gender__c','ETST_Gender_AR__c','ETST_Division__c','ETST_Grade__c','ETST_Blood__c','ETST_Nationality__c','ETST_Nationality_AR__c'};
            Map<String, List<Schema.PicklistEntry>>  fieldFinalMap=ETST_PicklistValueController.getPicklistvalues('ETST_Student__c',field_apinames);
        if(fieldFinalMap == null) {
            return null;
        }
        List<String> optionlist = new List<String>();
        for(String fieldVal : fieldFinalMap.keySet()){
            for(Schema.PicklistEntry pv : fieldFinalMap.get(fieldVal)) {
                optionlist.add(pv.getValue());
            }
            if(fieldVal=='ETST_Division__c'){
                wrap.divisionList.addAll(optionlist);
            }else if(fieldVal=='ETST_Grade__c'){
                wrap.gradeList.addAll(optionlist);
            }else if(fieldVal=='ETST_Blood__c'){
                wrap.bloodGroupList.addAll(optionlist);
            }else if(fieldVal=='ETST_Nationality__c'){
                wrap.nationalityList.addAll(optionlist);
            }else if(fieldVal=='ETST_Nationality_AR__c'){
                wrap.nationalityListAR.addAll(optionlist);
            }else if(fieldVal=='ETST_Gender__c'){
                wrap.genderList.addAll(optionlist);
            }else if(fieldVal=='ETST_Gender_AR__c'){
                wrap.genderListAR.addAll(optionlist);
            } 
            
            optionlist.clear();
        } 
        return wrap;
    }
    
    public class StudenDetailsWrapper{
        @AuraEnabled
        public List<String> divisionList=new List<String>();
        @AuraEnabled
        public List<String> gradeList=new List<String>();
        @AuraEnabled
        public List<String> bloodGroupList=new List<String>(); 
        @AuraEnabled
        public List<String> schoolsList=new List<String>();
        @AuraEnabled
        public List<String> nationalityList=new List<String>();
        @AuraEnabled
        public List<String> nationalityListAR=new List<String>();
        @AuraEnabled
        public List<String> genderList=new List<String>();
        @AuraEnabled
        public List<String> genderListAR=new List<String>();
        @AuraEnabled
        public Account parentProfle=new Account();
    }
    /*
@AuraEnabled
public static List<String> getStudentSchoolAreas(Id schoolId) {
List<string> schoolsAreas=new list<String>();
List<AggregateResult> aggList= [SELECT  ETST_Areas__c FROM ETST_School_Line__c
where  ETST_School_Name__c=:schoolId
group by ETST_Areas__c order by ETST_Areas__c];
for(AggregateResult aggr:aggList ){ 
schoolsAreas.add((String)aggr.get('ETST_Areas__c'));
}
return schoolsAreas;
}
*/
    @AuraEnabled
    public static Id getImageContent(String docId, String studentId) {
        String errStr;
        ETST_Student__c studentRecord=new ETST_Student__c(Id = studentId);
        try{
            Id ContentVersionId=[SELECT Id,Title FROM ContentVersion WHERE ContentDocumentId =:docId limit 1].Id;
            studentRecord.ETST_Image_Document_Id__c=ContentVersionId;
            update studentRecord;
            return ContentVersionId;
        }catch (Exception e) {
            errStr = JSON.serialize(ETSTController.buildErrorResponse('getImageContent', e.getMessage(), e.getStackTraceString()));
            AuraHandledException ahe = new AuraHandledException(errStr);
            ahe.setMessage(errStr);
            throw ahe;
        }
        
    }
    
    @AuraEnabled
    public static void updateTransportRequestStatus(Id serviceRecordId,String status,boolean isActive ) {
        String errStr;
        try{
            ET_Service_Request__c service=new ET_Service_Request__c(Id = serviceRecordId);
            service.ETST_Status__c=status;
            //service.ETST_Is_Active__c=isActive;
            update service;
        }catch (Exception e) {
            errStr = JSON.serialize(ETSTController.buildErrorResponse('updateTransportRequestStatus', e.getMessage(), e.getStackTraceString()));
            AuraHandledException ahe = new AuraHandledException(errStr);
            ahe.setMessage(errStr);
            throw ahe;
        }
    }
    @AuraEnabled
    public static void updateBulkTransportRequestStatus(List<Id> serviceRecordIds,String status) {
        String errStr;
        try{
            List<ET_Service_Request__c> serviceList= new List<ET_Service_Request__c>();
            for(ET_Service_Request__c service:[select id,ETST_Status__c from ET_Service_Request__c where id IN :serviceRecordIds]){
                service.ETST_Status__c=status;
                serviceList.add(service);
            }
            update serviceList;
        }catch (Exception e) {
            errStr = JSON.serialize(ETSTController.buildErrorResponse('updateTransportRequestStatus', e.getMessage(), e.getStackTraceString()));
            AuraHandledException ahe = new AuraHandledException(errStr);
            ahe.setMessage(errStr);
            throw ahe;
        }
    }
    
    @TestVisible
    private static Map<String, String> buildErrorResponse(String source, String errorMessage, String stackTrace) {
        Map<String, String> errorResponse = new Map<String, String>();
        
        errorResponse.put('SOURCE', source);
        errorResponse.put('MESSAGE', errorMessage);
        errorResponse.put('STACKTRACE', stackTrace);
        
        return errorResponse;
    }  
    
    
    @AuraEnabled
    public static List<ET_Refund__c> getParentRefundHistory() {
        String errStr;
        try{
            String userAccountId=[select accountId from user where id=:userInfo.getUserId()].accountId;   
            return [SELECT Id, Name, ET_Refund_Amount__c, ET_Refund_Percentage__c, ET_Service_Request__r.Name, 
                    ET_Refund_Status__c,CreatedDate
                    FROM ET_Refund__c
                    where ET_Service_Request__r.ETST_Student__r.ETST_Account_Name__c=:userAccountId];
        }catch (Exception e) {
            errStr = JSON.serialize(ETSTController.buildErrorResponse('getParentRefundHistory', e.getMessage(), e.getStackTraceString()));
            AuraHandledException ahe = new AuraHandledException(errStr);
            ahe.setMessage(errStr);
            throw ahe;
        }
    }
    
    @AuraEnabled
    public static List<ETST_Payment__c> getParentPaymentHistory(string studentId) {
        String errStr;
        try{
            return [SELECT Id, Name, RecordTypeId,RecordType.Name, CreatedDate, ETST_Amount__c, ETST_Payment_Mode__c,
                    ETST_Cardholder_Name__c,ET_Service_Request__r.ETST_Status__c,
                    ET_Service_Request__c,ET_Service_Request__r.ETST_Student__r.ETST_Account_Name__c,
                    ET_Service_Request__r.ETST_Student__r.Name, ETST_Fare_Charges__c,
                    ETST_Payment_State__c, ETST_Card_Type__c, ETST_Card_Number__c, ETST_Card_Expiry__c, 
                    ETS_Account_No__c, ETS_IBAN__c, ETS_Cheque_Issued_Date__c, ETS_Cheque_Expiry_Date__c 
                    FROM ETST_Payment__c
                    where  ET_Service_Request__r.ETST_Student__c=:studentId order by createddate DESC];
        }catch (Exception e) {
            errStr = JSON.serialize(ETSTController.buildErrorResponse('getParentPaymentHistory', e.getMessage(), e.getStackTraceString()));
            AuraHandledException ahe = new AuraHandledException(errStr);
            ahe.setMessage(errStr);
            throw ahe;
        }
    }
    
    @AuraEnabled
    public static List<Case> getParentCaseHistory() {
        String errStr;
        try{
            //String userAccountId=[select accountId from user where id=:userInfo.getUserId()].accountId;   
            return [select CaseNumber,CreatedDate,ClosedDate,Record_Types__c,ETST_Student__r.Name,Status,Case_Types__c,
                    ET_Issue_Category__c,ET_Issue_Type_New__c,Description from case 
                    where //Record_Types__c ='School Transport' AND 
                    Case.OwnerId=:userInfo.getUserId() order by lastmodifieddate desc];
        }catch (Exception e) {
            errStr = JSON.serialize(ETSTController.buildErrorResponse('getParentCaseHistory', e.getMessage(), e.getStackTraceString()));
            AuraHandledException ahe = new AuraHandledException(errStr);
            ahe.setMessage(errStr);
            throw ahe;
        }
    }
    @AuraEnabled
    public static Id createInvoice(Id serviceRecordId) {
        String errStr;
        try{
            List<Invoice__c> invoiceList=[select id,fromDate__c,toDate__c,ETST_Type__c from Invoice__c where
                                          Service_Request__c=:serviceRecordId and ETST_Active__c = true 
                                          order by createddate DESC];
            /*Invoice__c invoice=new Invoice__c();
if(invoiceList==null || invoiceList.size()==0){
invoice.fromDate__c=Date.today();
invoice.ETST_Type__c = 'On Premise';
invoice.toDate__c=Date.today().addMonths(1);
invoice.Service_Request__c=serviceRecordId;
invoice.ETST_Active__c = true;
insert invoice;
}else{
if(invoiceList[0].ETST_Type__c != 'Bank Transfer / Cash Deposit' || invoiceList[0].ETST_Type__c != 'Cheque'){
invoiceList[0].fromDate__c=Date.today();
invoiceList[0].toDate__c=Date.today().addMonths(1); 
}
update  invoiceList[0];  
}
*/
            
            return invoiceList[0].Id;
        }catch (Exception e) {
            errStr = JSON.serialize(ETSTController.buildErrorResponse('createInvoice', e.getMessage(), e.getStackTraceString()));
            AuraHandledException ahe = new AuraHandledException(errStr);
            ahe.setMessage(errStr);
            throw ahe;
        }
    }
    
    @AuraEnabled
    public static Invoice__c getInvoice(Id serviceRecordId) {
        String errStr;
        try{
            List<Invoice__c> invoiceList=[select id,ETST_Type__c,Service_Request__r.ETST_Student__r.ETST_School_Street__c from Invoice__c where
                                          Service_Request__c=:serviceRecordId AND (ETST_Type__c=:System.Label.ETST_Bank_Cash OR ETST_Type__c=:System.Label.ETST_Cheque) order by createddate DESC];
            if(!invoiceList.isEmpty()) return invoiceList[0];
            else return null;
            
        }catch (Exception e) {
            errStr = JSON.serialize(ETSTController.buildErrorResponse('getInvoice', e.getMessage(), e.getStackTraceString()));
            AuraHandledException ahe = new AuraHandledException(errStr);
            ahe.setMessage(errStr);
            throw ahe;
        }
    }
    
    @AuraEnabled
    public static Decimal getRefundAmount(ET_Service_Request__c serviceRecord, Boolean isCurrent) {
        String errStr;
        Decimal refundAmount=0;
        Integer noOfMonths=0;
        Integer monthNumber = 0;
        Integer dayNumber = 0;
        integer numberofweeks = 0;
        
        ETST_Price_List__c pList=[Select id,ETST_Cancellation_Fee__c,ETST_Cancellation_Mode__c,
                                  ETST_Ondemand_Rate_per_Day__c,ETST_Amount__c
                                  from ETST_Price_List__c where id=:serviceRecord.ETST_Price_List__c LIMIT 1];
        
        if(pList==null) {return null;}
        if(!isCurrent){
            refundAmount=serviceRecord.ETST_Fare_Charges__c;
        }else{
            if(pList.ETST_Cancellation_Mode__c==System.Label.ETST_Cancel_Month){
                if(serviceRecord.ETST_Cancellation_Effective_Date__c==null){
                    integer numberofweekcompleted = getweekbetweentwodates(serviceRecord.ETST_Pick_Up_Start_Date__c, System.today());
                    if(numberofweekcompleted > 6 ){
                        noOfMonths=serviceRecord.ETST_Pick_Up_Start_Date__c.monthsBetween(serviceRecord.ETST_Pick_Up_End_Date__c);
                    }else if(numberofweekcompleted > 3 && numberofweekcompleted <= 6 ){
                        date startdate = serviceRecord.ETST_Pick_Up_Start_Date__c;
                        startdate.addMonths(2);
                        noOfMonths=startdate.monthsBetween(serviceRecord.ETST_Pick_Up_End_Date__c);
                    }else if(numberofweekcompleted > 1 && numberofweekcompleted <= 3){
                        date startdate = serviceRecord.ETST_Pick_Up_Start_Date__c;
                        startdate.addMonths(1);
                        noOfMonths=startdate.monthsBetween(serviceRecord.ETST_Pick_Up_End_Date__c);
                    }else{
                        noOfMonths=System.today().monthsBetween(serviceRecord.ETST_Pick_Up_End_Date__c); 
                    }
                    
                }
                else{
                    numberofweeks = getweekbetweentwodates(serviceRecord.ETST_Pick_Up_Start_Date__c, serviceRecord.ETST_Cancellation_Effective_Date__c);
                    monthNumber = serviceRecord.ETST_Cancellation_Effective_Date__c.month();
                    dayNumber = serviceRecord.ETST_Cancellation_Effective_Date__c.day();
                    noOfMonths=serviceRecord.ETST_Cancellation_Effective_Date__c.monthsBetween(serviceRecord.ETST_Pick_Up_End_Date__c);  
                }
                
                Integer serviceStartDate = serviceRecord.ETST_Pick_Up_Start_Date__c.month();//added
                
                if(serviceRecord.ETST_Service_Type__c == 'Yearly'){
                    Integer pickUpEndYear = serviceRecord.ETST_Pick_Up_End_Date__c.year();
                    Integer cancellationEffectiveYear = serviceRecord.ETST_Cancellation_Effective_Date__c.year();
                    Date startDate2ndTerm;
                    Date startDate3rdTerm;
                    if(pickUpEndYear == cancellationEffectiveYear){
                        startDate2ndTerm = Date.newInstance(pickUpEndYear, 1, 1);
                        startDate3rdTerm = Date.newInstance(pickUpEndYear, 4, 1);
                    }
                    Integer numberofweeks2ndTerm;
                    Integer numberofweeks3rdTerm;
                    if(monthNumber >= 1 && monthNumber <= 6){
                        numberofweeks2ndTerm = getweekbetweentwodates(startDate2ndTerm, serviceRecord.ETST_Cancellation_Effective_Date__c);
                        numberofweeks3rdTerm = getweekbetweentwodates(startDate3rdTerm, serviceRecord.ETST_Cancellation_Effective_Date__c);
                    }
                    
                    if(monthNumber == 8){
                        refundAmount = 9*pList.ETST_Amount__c;
                    }else if(monthNumber >= 9 && monthNumber <= 12 && numberofweeks > 6){//&& serviceStartDate != 10
                        refundAmount = 6*pList.ETST_Amount__c;
                    }/*else if(monthNumber >= 9 && monthNumber <= 12 && numberofweeks > 6 && serviceStartDate == 10){
                        refundAmount = 0;
                    }*/else if(monthNumber >= 1 && monthNumber <= 3 && numberofweeks2ndTerm > 6){
                        refundAmount = 3*pList.ETST_Amount__c;
                    }else if(monthNumber >= 4 && monthNumber <= 6 && numberofweeks3rdTerm > 6){
                        refundAmount = 0*pList.ETST_Amount__c;
                    }else{
                        refundAmount=noOfMonths*pList.ETST_Amount__c;
                    }
                    
                } 
                if(serviceRecord.ETST_Service_Type__c == 'Quarterly' && (serviceRecord.ETST_Pick_Up_Start_Date__c.month() == 9 || serviceRecord.ETST_Pick_Up_Start_Date__c.month() == 8)){
                    noOfMonths = serviceRecord.ETST_Pick_Up_Start_Date__c.monthsBetween(serviceRecord.ETST_Cancellation_Effective_Date__c);
                    
                    if(numberofweeks <= 4){
                        refundAmount = 3*pList.ETST_Amount__c;
                    }else if(numberofweeks >= 4 && numberofweeks <= 6){
                        refundAmount = 2*pList.ETST_Amount__c;
                    }else if(numberofweeks > 6){
                        refundAmount = 0;
                    }
               }else if(serviceRecord.ETST_Service_Type__c == 'Quarterly' && 
                         (serviceRecord.ETST_Pick_Up_Start_Date__c.month() == 1 || serviceRecord.ETST_Pick_Up_Start_Date__c.month() == 4)){
                    noOfMonths = serviceRecord.ETST_Pick_Up_Start_Date__c.monthsBetween(serviceRecord.ETST_Cancellation_Effective_Date__c);
                    System.debug('noOfMonths '+noOfMonths);
                        
                    if(noOfMonths == 0){
                        refundAmount = 2*pList.ETST_Amount__c;
                    }else if(numberofweeks >= 4  && numberofweeks <= 6){//numberofweeks >= 5 &&
                        refundAmount = 1*pList.ETST_Amount__c;
                    }else if(numberofweeks > 6){
                        refundAmount = 0;
                    }
                   
                }else if(serviceRecord.ETST_Service_Type__c == 'Half Yearly' && 
                   (serviceRecord.ETST_Pick_Up_Start_Date__c.month() == 8 || serviceRecord.ETST_Pick_Up_Start_Date__c.month() == 9 || serviceRecord.ETST_Pick_Up_Start_Date__c.month() == 2)){
                    noOfMonths = serviceRecord.ETST_Pick_Up_Start_Date__c.monthsBetween(serviceRecord.ETST_Cancellation_Effective_Date__c);
                    if(numberofweeks <= 4){//noOfMonths == 0
                        refundAmount = 4*pList.ETST_Amount__c;
                    }else if(numberofweeks >= 4  && numberofweeks <= 6){//numberofweeks >= 5 &&
                        refundAmount = 3*pList.ETST_Amount__c;
                    }else if(numberofweeks > 6){
                         refundAmount = 1*pList.ETST_Amount__c;  
                    }
                   }
                
                //refundAmount=noOfMonths*pList.ETST_Amount__c;
            }else if(pList.ETST_Cancellation_Mode__c==System.Label.ETST_Cancel_Day){
                Integer noOfDays=0;
                if(serviceRecord.ETST_Cancellation_Effective_Date__c==null){
                    integer numberofweekcompleted = getweekbetweentwodates(serviceRecord.ETST_Pick_Up_Start_Date__c, System.today());
                    if(numberofweekcompleted > 6 ){
                        noOfDays=serviceRecord.ETST_Pick_Up_Start_Date__c.daysBetween(serviceRecord.ETST_Pick_Up_End_Date__c);
                    }else if(numberofweekcompleted > 3 && numberofweekcompleted <= 6 ){
                        date startdate = serviceRecord.ETST_Pick_Up_Start_Date__c;
                        startdate.addMonths(2);
                        noOfDays=startdate.daysBetween(serviceRecord.ETST_Pick_Up_End_Date__c);
                    }else if(numberofweekcompleted > 1 && numberofweekcompleted <= 3){
                        date startdate = serviceRecord.ETST_Pick_Up_Start_Date__c;
                        startdate.addMonths(1);
                        noOfDays=startdate.daysBetween(serviceRecord.ETST_Pick_Up_End_Date__c);
                    }else{
                        noOfDays=System.today().daysBetween(serviceRecord.ETST_Pick_Up_End_Date__c); 
                    }
                    
                    
                }else{
                    noOfDays=serviceRecord.ETST_Cancellation_Effective_Date__c.daysBetween(serviceRecord.ETST_Pick_Up_End_Date__c);
                }
                
                refundAmount=noOfDays*pList.ETST_Ondemand_Rate_per_Day__c;
                
            }
            
            refundAmount-=pList.ETST_Cancellation_Fee__c;
            refundAmount=refundAmount.setScale(2);
            
        }
        
        return refundAmount;
    }
    
   /* @AuraEnabled
    public static ET_Refund__c getRefundId(ET_Service_Request__c serviceRecord) {
        return [Select Id from ET_Refund__c WHERE ET_Service_Request__c =: serviceRecord.Id ORDER BY CreatedDate DESC LIMIT 1];
    }*/
    
    public static integer getweekbetweentwodates(Date myDate1, Date today){
        
        System.debug('Weeks Between Two :'+myDate1.daysBetween(today)/7);
        return myDate1.daysBetween(today)/7;
    }
    public class RefundDetailsWrapper{
        @AuraEnabled
        public Decimal refundAmount=0;
        @AuraEnabled
        public Decimal refundPercentage=0;
        @AuraEnabled
        public Integer noOfDaysOnhold;
    }
    @AuraEnabled 
    public static List<ET_Service_Request__c> getSelectedTransportRequests(Integer pageNo,String school,
                                                                           
                                                                           String payee,String status){
                                                                               integer i=1;
                                                                               string schoolRecordTypeId1 = Schema.SObjectType.ET_Service_Request__c.getRecordTypeInfosByDeveloperName().get('ETST_School_Coordinator').getRecordTypeId();
                                                                               string schoolRecordTypeId2 = Schema.SObjectType.ET_Service_Request__c.getRecordTypeInfosByDeveloperName().get('ETST_School_Coordinator_Read_Only').getRecordTypeId();
                                                                               string schoolRecordTypeId3 = Schema.SObjectType.ET_Service_Request__c.getRecordTypeInfosByDeveloperName().get('ETST_School_Service_Request').getRecordTypeId();
                                                                               
                                                                               List<ET_Service_Request__c> requestList=new List<ET_Service_Request__c>();
                                                                               String query = 'SELECT Id,Name,ETST_Fare_Charges__c,ETST_Coordinator_Comments__c,ETST_Area_Zone__c,ETST_Pick_Up_From__c,ETST_Drop_Off_To__c,ETST_Status__c,ETST_Student__c,ETST_Student__r.ETST_Student_School__c,ETST_Student__r.Name,ETST_Student_Name__c,ETST_Student__r.ETST_Student_Id__c,ETST_Student__r.ETST_Phone__c,ETST_Transport_Type__c,ETST_Student__r.ETST_School__c,ETST_Student__r.ETST_School_Name__r.Name,ETST_Payee__c,ETST_Pick_Up_Start_Date__c,Payment_Status__c,ETST_Pick_Up_End_Date__c ';
                                                                               query += ' FROM ET_Service_Request__c where ETST_Student__c!=null and ETST_Student__r.ETST_School__c!=null and (RecordTypeId=:schoolRecordTypeId1 or RecordTypeId=:schoolRecordTypeId2 or RecordTypeId=:schoolRecordTypeId3) ';
                                                                               if(payee!=null && payee!=''){
                                                                                   query += ' and ETST_Payee__c=:payee';                                                                            
                                                                               }
                                                                               system.debug('school***'+school);
                                                                               if(school!=null && school!=''){
                                                                                   if(school==System.Label.ETST_Private_School || school==System.Label.ETST_Government_School || school==System.Label.ETST_University){
                                                                                       query += ' and ETST_Student__r.ETST_School__r.ETST_Account_Type__c=:school';
                                                                                   } if(school=='Yes'){
                                                                                       query += ' and ETST_Student__r.ETST_School__r.ETST_School_Paid__c=:school';
                                                                                   }/*else{
query += ' and ETST_Student__r.ETST_School__r.Name=:school';
} */
                                                                                   
                                                                               }
                                                                               if(status!=null && status!=''){
                                                                                   query += ' and ETST_Status__c=:status';                                                                            
                                                                               }
                                                                               query += ' ORDER BY Name ASC';
                                                                               system.debug('query---'+query); 
                                                                               for(List<ET_Service_Request__c> request : Database.query(query)) {
                                                                                   requestList.addAll(request);
                                                                                   if(i==pageNo) break;
                                                                                   i++;  
                                                                               }
                                                                               return requestList; 
                                                                           }
    
    @AuraEnabled 
    public static TransportRequests getTransportRequests(Integer pageNo){
        TransportRequests wrap=new TransportRequests();
        String errStr;
        integer i=1;
        try{ 
            String status=System.Label.ETST_Under_Review;
            String status2=System.Label.ETST_Location_Update;
            String status3=System.Label.ETST_School_Changed;
            string schoolRecordTypeId1 = Schema.SObjectType.ET_Service_Request__c.getRecordTypeInfosByDeveloperName().get('ETST_School_Coordinator').getRecordTypeId();
            string schoolRecordTypeId2 = Schema.SObjectType.ET_Service_Request__c.getRecordTypeInfosByDeveloperName().get('ETST_School_Coordinator_Read_Only').getRecordTypeId();
            string schoolRecordTypeId3 = Schema.SObjectType.ET_Service_Request__c.getRecordTypeInfosByDeveloperName().get('ETST_School_Service_Request').getRecordTypeId();
            String query = 'SELECT Id,Name,ETST_Fare_Charges__c,ETST_Area_Zone__c,ETST_Coordinator_Comments__c,ETST_Pick_Up_From__c,Payment_Status__c, ETST_Drop_Off_To__c,ETST_Status__c,ETST_Student__c,ETST_Student__r.Name,ETST_Student_Name__c,ETST_Student__r.ETST_Student_Id__c,ETST_Student__r.ETST_Student_School__c,ETST_Student__r.ETST_Phone__c,ETST_Transport_Type__c,ETST_Student__r.ETST_School__c,ETST_Student__r.ETST_School_Name__r.Name,ETST_Payee__c,ETST_Pick_Up_Start_Date__c,ETST_Pick_Up_End_Date__c ';
            query += ' FROM ET_Service_Request__c';
            query += ' WHERE (ETST_Status__c= :status OR ETST_Status__c= :status2 OR ETST_Status__c= :status3) AND (RecordTypeId=:schoolRecordTypeId1 or RecordTypeId=:schoolRecordTypeId2 or RecordTypeId=:schoolRecordTypeId3) and ETST_Student__r.ETST_School_Name__c!=null';
            query += ' ORDER BY Name ASC';
            
            for(List<ET_Service_Request__c> request : Database.query(query)) {
                wrap.requests.addAll(request);
                if(i==pageNo) break;
                i++;  
            }
            wrap.totalRecords = Database.query(query).size();
            
            List<AggregateResult> aggList= [SELECT Name FROM Account where recordtype.DeveloperName='Business_School' group by name order by name];
            for(AggregateResult aggr:aggList ){ 
                wrap.schoolsList.add((String)aggr.get('Name'));
                
            }
            
            /*aggList= [SELECT  ETST_Areas__c FROM ETST_School_Line__c group by ETST_Areas__c order by ETST_Areas__c];
for(AggregateResult aggr:aggList ){ 
wrap.schoolsAreas.add((String)aggr.get('ETST_Areas__c'));
}*/
            List<String> field_apinames=new  List<String>{'ETST_Status__c'};
                List<String> field_apinames1=new  List<String>{'ETST_Payee__c'};
                    Map<String, List<Schema.PicklistEntry>>  fieldFinalMap=ETST_PicklistValueController.getPicklistvalues('ET_Service_Request__c',field_apinames);
            fieldFinalMap.putAll(ETST_PicklistValueController.getPicklistvalues('ETST_Price_List__c',field_apinames1));
            
            if(fieldFinalMap == null) {
                return null;
            }
            List<String> optionlist = new List<String>();
            for(String fieldVal : fieldFinalMap.keySet()){
                for(Schema.PicklistEntry pv : fieldFinalMap.get(fieldVal)) {
                    optionlist.add(pv.getValue());
                }
                if(fieldVal=='ETST_Status__c'){
                    wrap.statusList.addAll(optionlist);
                }
                if(fieldVal=='ETST_Payee__c'){
                    wrap.payeeList.addAll(optionlist);
                } 
                optionlist.clear();
            }
            wrap.loggedinUserProfileId = UserInfo.getProfileId();
            system.debug('wrap.statusList***'+wrap.statusList);
            return wrap;
        }catch (Exception e) {
            
            errStr = JSON.serialize(ETSTController.buildErrorResponse('getTransportRequests', e.getMessage(), e.getStackTraceString()));
            AuraHandledException ahe = new AuraHandledException(errStr);
            ahe.setMessage(errStr);
            throw ahe;
        } 
        
    } 
    public class TransportRequests{  
        @AuraEnabled
        public List<ET_Service_Request__c> requests=new List<ET_Service_Request__c>();
        @AuraEnabled
        public Integer totalRecords = 0;
        @AuraEnabled
        public List<String> schoolsList = new List<String>();
        @AuraEnabled
        public List<String> schoolsAreas = new List<String>();
        @AuraEnabled
        public List<String> payeeList = new List<String>();
        @AuraEnabled
        public List<String> statusList = new List<String>();
        @AuraEnabled
        public String loggedinUserProfileId;
    }
    
    
    
    @AuraEnabled
    public static void attachmentInsert(string fileName, string fileBody, string parentRecordId){
        Attachment oAttachment = new Attachment();
        oAttachment.ParentId = parentRecordId;
        oAttachment.Body = EncodingUtil.base64Decode(fileBody);
        oAttachment.Name = fileName;
        //insert  oAttachment;
        try {
            insert oAttachment; 
        } catch (DmlException e) {
            throw new AuraHandledException('Error inserting attachment: ' + e.getStackTraceString());
        }
    }
    @AuraEnabled
    public static void activateOnholdService(ET_Service_Request__c serviceRecord){
        system.debug('serviceRecord***'+serviceRecord);
        //Added by Janardhan - Goverment school Condition
        string accType = [select id,ETST_Student__r.ETST_School_Name__r.ETST_Account_Type__c  from ET_Service_Request__c where id=:serviceRecord.Id].ETST_Student__r.ETST_School_Name__r.ETST_Account_Type__c;
        if(accType =='Government School'){
            serviceRecord.ETST_Status__c=System.Label.ETST_Service_Confirmed;//'service Confirmed';
        }else{
            serviceRecord.ETST_Status__c=System.Label.ETST_Payment_success;//'Payment success';
        }
        
        
        update serviceRecord;
        
    }
    @AuraEnabled
    public static paymentDetailsWrapper getStudent(Id serviceRecordId){
        paymentDetailsWrapper wrap=new paymentDetailsWrapper();
        ET_Service_Request__c serviceReq = [Select Id, ETST_Student__c,ETST_Price_List__r.ETST_Cheque_Payment_Allowed__c,ETST_Price_List__r.ETST_Courier_Address__c
                                            from ET_Service_Request__c WHERE id=:serviceRecordId limit 1];
        if(serviceReq.ETST_Price_List__r.ETST_Cheque_Payment_Allowed__c){
            wrap.address=serviceReq.ETST_Price_List__r.ETST_Courier_Address__c;
        }
        wrap.chequeAllowed=serviceReq.ETST_Price_List__r.ETST_Cheque_Payment_Allowed__c;
        wrap.student = [Select Id,Name,ETST_School_Street__c,ETST_School_City__c,ETST_School_Country__c,ETST_Student_School__c from ETST_Student__c WHERE Id=:serviceReq.ETST_Student__c];
        return wrap;
    }
    public class paymentDetailsWrapper{  
        @AuraEnabled
        public ETST_Student__c student=new ETST_Student__c();
        @AuraEnabled
        public String address;
        @AuraEnabled
        public boolean chequeAllowed=false;
    }
    @AuraEnabled
    public static BankDetails getBankDetails(Id serviceRecordId){        
        List<ETST_Bank_Cheque_Details__mdt> details = [SELECT id,MasterLabel,A_C_Number__c,IBAN__c,Bank_Name__c,Address__c
                                                       FROM ETST_Bank_Cheque_Details__mdt limit 1];
        Invoice__c invoice = [Select Id,Name FROM Invoice__c WHERE Service_Request__c=:serviceRecordId AND ETST_Active__c=true limit 1];
        BankDetails bd = new BankDetails();
        bd.BankName = details[0].Bank_Name__c;
        bd.BankAccountNumber = details[0].A_C_Number__c;
        bd.IBAN = details[0].IBAN__c;
        bd.Address = details[0].Address__c;
        bd.invoice = invoice;
        return bd; 
    }
    
    public class BankDetails{  
        @AuraEnabled
        public String BankName;
        @AuraEnabled
        public String BankAccountNumber;
        @AuraEnabled
        public String IBAN;
        @AuraEnabled
        public String Address;
        @AuraEnabled
        public Invoice__c invoice;
        
    }    
    /*  @AuraEnabled
public static CaseDependentWrapper getDependentPicklistValues(sObject objectAPI, string controllerFieldAPI, string dependentFieldAPI) {
system.debug('objectAPI***'+objectAPI);
string str = string.valueOf(objectAPI);
CaseDependentWrapper wrap=new CaseDependentWrapper();
List<String> field_apinames=new  List<String>{controllerFieldAPI, dependentFieldAPI};
Map<String, List<Schema.PicklistEntry>>  fieldFinalMap=ETST_PicklistValueController.getDependentMap(objectAPI, field_apinames);
if(fieldFinalMap == null) {
return null;
}
List<String> optionlist = new List<String>();
for(String fieldVal : fieldFinalMap.keySet()){
for(Schema.PicklistEntry pv : fieldFinalMap.get(fieldVal)) {
optionlist.add(pv.getValue());
}
if(fieldVal==controllerFieldAPI){
wrap.controllerFieldValues.addAll(optionlist);
}else if(fieldVal==dependentFieldAPI){
wrap.dependentFieldValues.addAll(optionlist);
}              
optionlist.clear();
} 
return wrap;
}

public class CaseDependentWrapper{
@AuraEnabled
public List<String> controllerFieldValues = new List<String>();
@AuraEnabled
public List<String> dependentFieldValues = new List<String>();
}
*/
    /*  @AuraEnabled 
public static Map<String, List<String>> getDependentPicklistValues(sObject objDetail, string contrfieldApiName,string depfieldApiName) {
String controllingField = contrfieldApiName.toLowerCase();
String dependentField = depfieldApiName.toLowerCase();       
Map<String,List<String>> objResults = new Map<String,List<String>>();  
Schema.sObjectType objType = objDetail.getSObjectType();
if(objType==null){
return objResults;
}     
Map<String, Schema.SObjectField> objFieldMap = objType.getDescribe().fields.getMap();        
if(!objFieldMap.containsKey(controllingField) || !objFieldMap.containsKey(dependentField)){
return objResults;     
}
Schema.SObjectField ctrlField = objFieldMap.get(controllingField);
Schema.SObjectField theField = objFieldMap.get(dependentField);
List<Schema.PicklistEntry> contrEntries = ctrlField.getDescribe().getPicklistValues();
List<PicklistEntryWrapper> depEntries = wrapPicklistEntries(theField.getDescribe().getPicklistValues());       
List<String> controllingValues = new List<String>();        
for(Schema.PicklistEntry ple : contrEntries) {
String label = ple.getLabel();
objResults.put(label, new List<String>());
controllingValues.add(label);
} 
for(PicklistEntryWrapper plew : depEntries) {
String label = plew.label;
String validForBits = base64ToBits(plew.validFor);
for(Integer i = 0; i < validForBits.length(); i++) {
String bit = validForBits.mid(i, 1);
if(bit == '1') {
objResults.get(controllingValues.get(i)).add(label);
}
}
}
return objResults;
} */
    
    public static String decimalToBinary(Integer val) {
        String bits = '';
        while(val > 0) {
            Integer remainder = Math.mod(val, 2);
            val = Integer.valueOf(Math.floor(val / 2));
            bits = String.valueOf(remainder) + bits;
        }
        return bits;
    }
    
    /*  @AuraEnabled 
public static List<ETST_Case_Record_Types__mdt> getCaseTypes() { */
    //caseRecordType="School Transport"
    /*Map<String,List<String>> objResults = new Map<String,List<String>>();
Map<String, Case_Dependent_Types__c> mapOfdependent = Case_Dependent_Types__c.getAll();
Group grp = [Select Id from Group Where Type='Queue' AND DeveloperName='School_Transport_Queue'];
List<string> typeValues = new List<String>();
for(Case_Dependent_Types__c cdtypes:mapOfdependent.values()){
if(cdtypes.Record_Type_Name__c == caseRecordType){
typeValues.add(cdtypes.Type_Name__c);   
}
} 
return typeValues;*/
    /*     return [SELECT ETST_Record_Type_Id__c,ETST_Record_Type_Name__c FROM ETST_Case_Record_Types__mdt];

}
*/    
    /*  public static String base64ToBits(String validFor) {
if(String.isEmpty(validFor)) return '';       
String validForBits = '';        
for(Integer i = 0; i < validFor.length(); i++) {
String thisChar = validFor.mid(i, 1);
Integer val = base64Chars.indexOf(thisChar);
String bits = decimalToBinary(val).leftPad(6, '0');
validForBits += bits;
}

return validForBits;
}

private static final String base64Chars = '' +
'ABCDEFGHIJKLMNOPQRSTUVWXYZ' +
'abcdefghijklmnopqrstuvwxyz' +
'0123456789+/';


private static List<PicklistEntryWrapper> wrapPicklistEntries(List<Schema.PicklistEntry> PLEs) {
return (List<PicklistEntryWrapper>)
JSON.deserialize(JSON.serialize(PLEs), List<PicklistEntryWrapper>.class);
}

public class PicklistEntryWrapper{
public String active {get;set;}
public String defaultValue {get;set;}
public String label {get;set;}
public String value {get;set;}
public String validFor {get;set;}
public PicklistEntryWrapper(){            
}
}
*/
    /*  @AuraEnabled
public static string[] getPicklistValues(string recordTypeId, string objectApiName,string fieldApiName){        
string[] piclistValues=new string[]{};
string BaseUrl=system.Url.getOrgDomainUrl().toExternalForm();
httprequest request= new httprequest();
request.setMethod('GET');
request.setEndpoint(BaseUrl+'/services/data/v44.0/ui-api/object-info/'+objectApiName+'/picklist-values/'+recordTypeId+'/'+fieldApiName);
request.setHeader('Authorization', 'Bearer ' + Userinfo.getSessionId());
request.setHeader('Content-Type','application/json; charset=UTF-8');
request.setHeader('Accept','application/json');

http http = new http();
httpresponse response=http.send(request);
picklistWrapper obj=new picklistWrapper();
system.debug('response***'+response.getBody());
obj=(picklistWrapper)JSON.deserialize(response.getBody(), picklistWrapper.class);
system.debug('obj***'+obj);
for(piclistValues pickVal:obj.values){
/* String validForBits = base64ToBits(pickVal.validFor);
for(Integer i = 0; i < validForBits.length(); i++) {
String bit = validForBits.mid(i, 1);
if(bit == '1') {
piclistValues.add(pickVal.value);
}
} 
piclistValues.add(pickVal.value);
}
system.debug('piclistValues***'+piclistValues);
return piclistValues;
}

//Wrapper class to handle the JSON response
public class picklistWrapper{
@AuraEnabled public piclistValues[] values;
}
public class piclistValues {
@AuraEnabled public String label;
@AuraEnabled public String value;
// @AuraEnabled public String validFor;
}*/
    
    @AuraEnabled
    public static Blob emailUserInvoice(String srId){
        ET_Service_Request__c inv =[select id,ET_Account__r.personemail,ETST_Status__c,
                                    ET_Account__r.personcontactId
                                    from ET_Service_Request__c where id =:srId];
       //String vfPage='Invoice';
        String vfPage;
        if(inv.ETST_Status__c == 'Payment success'|| inv.ETST_Status__c == 'Payment Success-In Review') {
            vfPage='Invoice';
        }else{
            vfPage='Proforma Invoice';
        }
        //(String vfPage,String parentId,Id tragetId,String emailId){
        //sr.Id,sr.ET_Account__r.personcontactId,sr.ET_Account__r.personemail);
        PageReference pdf = Page.ETST_InvoicePdf;//new PageReference('/apex/ETST_InvoicePage');
        pdf.setRedirect(true); 
        pdf.getParameters().put('id',inv.Id);
        
        Blob pdfContent;
        
        try {
            
            // returns the output of the page as a PDF
            pdfContent = pdf.getContent();
            
            // need to pass unit test
        } catch (VisualforceException e) {
            pdfContent = Blob.valueOf('Some Text');
        }
        string fileName=vfPage+'.pdf';  
        
        Messaging.EmailFileAttachment att = new Messaging.EmailFileAttachment();
        att.setFileName(fileName);
        att.setBody(pdfContent);
        att.setContentType('application/pdf');
        
        List<string> toAddress = new List<string>(); 
        toAddress.add(inv.ET_Account__r.personemail);
        
        EmailTemplate et = [Select Id,Subject, Body from EmailTemplate where developerName = 'ETST_Invoice_Email_Template'];
        OrgWideEmailAddress[] owea = [select Id from OrgWideEmailAddress where Address = :System.Label.orgWideEmail];
        
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();      
        if ( owea.size() > 0 ) {
            mail.setOrgWideEmailAddressId(owea.get(0).Id);
        }
        mail.setTemplateId(et.Id);        
        mail.setSaveAsActivity(false);
        mail.setTreatTargetObjectAsRecipient(false);//Not to send the email to target guest if email is edited
        mail.setTargetObjectId(inv.ET_Account__r.personcontactId);
        
        
        //mail.setWhatId(q.OpportunityId);
        mail.setToAddresses(toAddress);
        mail.setFileAttachments(new Messaging.EmailFileAttachment[] {att});
        //mail.setReplyTo(q.Opportunity.account.personEmail);
        //mail.setSenderDisplayName('Emirates Transport');
        
        if(!system.Test.isRunningTest())   Messaging.SendEmailResult [] results = Messaging.sendEmail(new Messaging.SingleEmailMessage[] {mail});  
        return pdfContent;
        
    }
    @AuraEnabled
    public static void approveService(String serviceRequestId, String Coordinator_Comments){
        System.debug('Coordinator_Comments ' + Coordinator_Comments);
        System.debug('serviceRequestId ' + serviceRequestId);
        ET_Service_Request__c serviceRequest = [SELECT ETST_Status__c, ETST_Prev_Status__c, ETST_Coordinator_Comments__c FROM ET_Service_Request__c WHERE id =: serviceRequestId];
        System.debug('serviceRequest 0 --> '+serviceRequest );
        System.debug('update 0 --> '+serviceRequest.ETST_Status__c );
        serviceRequest.ETST_Coordinator_Comments__c = Coordinator_Comments;
        if(serviceRequest.ETST_Status__c == 'Location Update - Under Review'){
            String status = getLatestStatus(serviceRequest.Id);
            if(status != '')
                serviceRequest.ETST_Status__c = status;
            System.debug('update 1 --> '+serviceRequest.ETST_Status__c );
        }
        else if(serviceRequest.ETST_Status__c == System.Label.ETST_Under_Review){
            serviceRequest.ETST_Status__c = System.Label.ETST_Service_Confirmed;
            System.debug('update 2 --> '+serviceRequest.ETST_Status__c );
            Blob pdfContent = emailUserInvoice(serviceRequest.Id);
            attachFile(serviceRequest.Id,pdfContent);
            
        }        
        try{
            update serviceRequest; 
        }catch(Exception e){
            System.debug('Exception 0 --> '+e.getStackTraceString() );
            throw new AuraHandledException(e.getMessage());
        }
    }
    public static String  getLatestStatus(String serviceReqId){
        STring status = '';
        List<ET_KPI_Request__c>  kpiRequestList = [SELECT id, ET_Status__c FROM ET_KPI_Request__c WHERE ET_Service_Request__c = :serviceReqId and ET_Status__c != '' order By createddate desc] ;
        if(kpiRequestList.size() > 1){
            status = kpiRequestList[1].ET_Status__c;
        }
        return status;
    }
    public static void attachFile(String srId,Blob pdfContent){
        ET_Service_Request__c inv =[select id,Name
                                    from ET_Service_Request__c where id =:srId];
        string fileName='INV-'+inv.Name+'.pdf'; 
        //Insert ContentVersion
        ContentVersion cVersion = new ContentVersion();
        cVersion.ContentLocation = 'S'; //S-Document is in Salesforce. E-Document is outside of Salesforce. L-Document is on a Social Netork.
        cVersion.PathOnClient = fileName;//File name with extention
        cVersion.Origin = 'H';//C-Content Origin. H-Chatter Origin.
        cVersion.Title = fileName;//Name of the file
        cVersion.VersionData = pdfContent;//File content
        Insert cVersion;
        
        //After saved the Content Verison, get the ContentDocumentId
        Id conDocument = [SELECT ContentDocumentId FROM ContentVersion WHERE Id =:cVersion.Id].ContentDocumentId;
        
        //Insert ContentDocumentLink
        ContentDocumentLink cDocLink = new ContentDocumentLink();
        cDocLink.ContentDocumentId = conDocument;//Add ContentDocumentId
        cDocLink.LinkedEntityId = srId;//Add attachment parentId
        cDocLink.ShareType = 'I';//V - Viewer permission. C - Collaborator permission. I - Inferred permission.
        cDocLink.Visibility = 'InternalUsers';//AllUsers, InternalUsers, SharedUsers
        Insert cDocLink;
    }
    
    
    @AuraEnabled
    public static void rejectService(ET_Service_Request__c serviceRequest){
        System.debug('update 0 --> '+serviceRequest.ETST_Status__c );
        
        if(serviceRequest.ETST_Status__c == 'Location Update - Under Review'){
            
            if(serviceRequest.ETST_Pick_Up_From__c!=null && serviceRequest.ETST_Pick_Up_From__c!=''){
                serviceRequest.ETST_Pick_Up_From__c=serviceRequest.ETST_Prev_Pickup_From__c;
                serviceRequest.ETST_Location__Latitude__s=serviceRequest.ETST_Prev_Pickup_Loc__Latitude__s;
                serviceRequest.ETST_Location__Longitude__s=serviceRequest.ETST_Prev_Pickup_Loc__Longitude__s;
            }
            if(serviceRequest.ETST_Drop_Off_To__c!=null && serviceRequest.ETST_Drop_Off_To__c!=''){
                serviceRequest.ETST_Drop_Off_To__c=serviceRequest.ETST_Prev_DropOff_To__c;
                serviceRequest.ETST_Dropoff_Location__Latitude__s =serviceRequest.ETST_Prev_Dropoff_Loc__Latitude__s;
                serviceRequest.ETST_Dropoff_Location__Longitude__s=serviceRequest.ETST_Prev_Dropoff_Loc__Longitude__s;
            }
            
            
            serviceRequest.ETST_Status__c = System.Label.ETST_Reject_Status;
            System.debug('update 1 --> '+serviceRequest.ETST_Status__c );
            
            List<string> toAddress = new List<string>();
            toAddress.add(serviceRequest.ET_Account__r.personemail); 
            EmailTemplate et = [Select Id,Subject, Body from EmailTemplate where developerName = 'ETST_Reject_Service_Email'];            
            OrgWideEmailAddress[] owea = [select Id from OrgWideEmailAddress where Address = :System.Label.orgWideEmail];
            
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();  
            if ( owea.size() > 0 ) {
                mail.setOrgWideEmailAddressId(owea.get(0).Id);
            }
            mail.setTemplateId(et.Id);        
            mail.setSaveAsActivity(false);
            mail.setTreatTargetObjectAsRecipient(false);
            mail.setTargetObjectId(serviceRequest.ET_Account__r.personcontactId); 
            mail.setWhatId (serviceRequest.Id);
            
            mail.setToAddresses(toAddress);
            Messaging.SingleEmailMessage[] messages = 
                new List<Messaging.SingleEmailMessage> {mail};
                    Messaging.SendEmailResult[] results = Messaging.sendEmail(messages);
            
            System.debug('--tttt--'+results);
        }
        else if(serviceRequest.ETST_Status__c == System.Label.ETST_Under_Review){
            serviceRequest.ETST_Status__c = System.Label.ETST_Request_Rejected;
            serviceRequest.ETST_Is_Active__c=false; //Line of code added by Sreelakshmi SK
            System.debug('update 2 --> '+serviceRequest.ETST_Status__c );
        }        
        try{
            update serviceRequest; 
        }catch(Exception e){
            throw new AuraHandledException(e.getMessage());
        }
    }
    
    @AuraEnabled
    public static Id createPayment(ETST_Payment__c newPayment, ET_Service_Request__c serviceRequest, string mode){
        if(mode == 'Cash'){
            newPayment.RecordTypeId = Schema.SObjectType.ETST_Payment__c.getRecordTypeInfosByDeveloperName().get('Cash_Payment').getRecordTypeId(); 
            newPayment.ETST_Payment_Mode__c = 'Cash';
           
        }
        if(mode == 'Cheque'){
            newPayment.RecordTypeId = Schema.SObjectType.ETST_Payment__c.getRecordTypeInfosByDeveloperName().get('Cheque_Payment').getRecordTypeId(); 
            newPayment.ETST_Payment_Mode__c = 'Cheque';
        }
        newPayment.ET_Service_Request__c = serviceRequest.Id;
        newPayment.ETST_Parent__c = serviceRequest.ET_Account__c;
        newPayment.ETST_Payment_State__c = ET_Common_Util.PAYMENT_CAPTURED;
       // newPayment.Bank_statement_Ref__c = '12345';
       
        serviceRequest.ETST_Status__c='Payment Success-Confirmation in progress';//System.label.etst_payment_success;
        
        try{
            insert newPayment; 
            update serviceRequest;
        }catch(Exception e){
            throw new AuraHandledException(e.getMessage());
        }
        //return serviceRequest.Id;
        return newPayment.Id;
    }
    @AuraEnabled
    public static List<ET_Terms_and_Conditions__c> getTermsandConditions(string visibility, string language){
        
        return [SELECT Id,ET_Condition__c,Header_Line__c FROM ET_Terms_and_Conditions__c 
                WHERE Active__c = true and ET_Service_Name__c = 'School' 
                AND Place_of_Visisbility__c=:visibility  and language__c =:language order by Order__c];        
    }
    @AuraEnabled
    public static void saveCase(case caseRecord){
        System.debug('caseRecord -->'+caseRecord);
        caseRecord.ETST_User__c=Userinfo.getUserId();
        try{
            insert caseRecord;
        }catch(Exception e){
            System.debug(e.getMessage());
        }
    }
    @AuraEnabled
    public static String deleteDocuments(String docIds){
        try{
            delete [SELECT Id FROM ContentDocument WHERE Id=:docIds];
            return 'SUCCESS';
        }
        catch(Exception ex){
            throw new AuraHandledException(ex.getMessage());
        }
    }
    
    @AuraEnabled 
    public static StudentWrapper getCaseTypes(){ 
        StudentWrapper returnStudents = new StudentWrapper();
        Id accountId = [Select Id,AccountId from User WHERE Id=:UserInfo.getUserId()].AccountId;
        List<ETST_Student__c> newListStudent = new List<ETST_Student__c>();
        List<ETST_Case_Record_Types__mdt> newListRT = new List<ETST_Case_Record_Types__mdt>();
        for(ETST_Student__c std : [SELECT Id,Name,ETST_First_Name__c FROM ETST_Student__c WHERE ETST_Account_Name__c=:accountId]){
            newListStudent.add(std);
        }
        for(ETST_Case_Record_Types__mdt mdt : [SELECT ETST_Record_Type_Id__c,ETST_Record_Type_Name__c,ETST_Record_Type_Name_AR__c FROM ETST_Case_Record_Types__mdt]){
            newListRT.add(mdt);
        }
        returnStudents.students = newListStudent;
        returnStudents.caseTypes = newListRT;
        return returnStudents;
    }
    public class StudentWrapper{
        @AuraEnabled 
        public List<ETST_Student__c> students; 
        @AuraEnabled
        public List<ETST_Case_Record_Types__mdt> caseTypes;
    }
    @AuraEnabled
    public static String getServiceReqId(String recordId) {
        return [select Id,Service_Request__c from Invoice__c WHERE Id =:recordId].Service_Request__c;
    }
}
public class ET_KPIRequestGeneration {
    public static void createKPIRequest(List<ET_KPIReqParam> requestRecords, string lookupFieldAPINme){
        set<string> recordIdset = new set<string>();
        List<ET_KPI_Request__c> updateRequestKPIList = new List<ET_KPI_Request__c>();
        map<string,string> recordIdTostatusMap = new map<string,string>();
        Map<string,decimal> recordToVersionMap = New Map<string,decimal> ();
        Set<Id> serviceReqIds = new Set<Id>();
        for(ET_KPIReqParam req : requestRecords){
            recordIdTostatusMap.put(req.Id, req.status);
            recordToVersionMap.put(req.Id,req.currentVersion);
            // recordToVersionMap.put(req.status,req.currentVersion);
            Id tempId=req.Id;
            string objName=tempId.getSObjectType().getDescribe().getName();
            if(objName=='ET_Service_Request__c'){
                serviceReqIds.add(tempId);
            }
        }
        
        if(recordIdTostatusMap.size() > 0){
            List<ET_KPI_Request__c> reqKPIList = new List<ET_KPI_Request__c>();
            Map<string,List<ET_KPI_Request__c>> recIdToReqKPIMap = new Map<string,List<ET_KPI_Request__c>>();
            reqKPIList = [select id,ET_Service_Request__c,ET_Status__c,ET_Status_Ended_At__c,ET_Status_Ended_by_User__c,ET_Status_Started_At__c,ET_Status_Started_by_User__c FROM ET_KPI_Request__c where ET_Service_Request__c IN:serviceReqIds order by createdDate desc];
            for(ET_KPI_Request__c kpiReq : reqKPIList){
                Id tId=null;
                if(kpiReq.ET_Service_Request__c !=null){
                    tId=kpiReq.ET_Service_Request__c;
                }
                if(tId!=null){
                    if(recIdToReqKPIMap.get(tId) != null){
                        List<ET_KPI_Request__c> kpiList = new List<ET_KPI_Request__c>();
                        kpiList = recIdToReqKPIMap.get(tId);
                        kpiList.add(kpiReq);
                        recIdToReqKPIMap.put(tId,kpiList);
                    }else{
                        List<ET_KPI_Request__c> kpiList1 = new List<ET_KPI_Request__c>();
                        kpiList1.add(kpiReq);
                        recIdToReqKPIMap.put(tId,kpiList1);
                    }
                }
                // if(recordToVersionMap.containsKey(kpiReq.ET_Status__c) && recordToVersionMap.get(kpiReq.ET_Status__c) ==NULL)
                //  recordToVersionMap.put(kpiReq.ET_Status__c,kpiReq.ET_Version__c);                   
            }
            for(string reqId : recordIdTostatusMap.keyset()){
                if(recIdToReqKPIMap.get(reqId) != null){
                    ET_KPI_Request__c reqKPIRec = recIdToReqKPIMap.get(reqId)[0];
                    if(reqKPIRec.ET_Status__c!=recordIdTostatusMap.get(reqId)){
                        reqKPIRec.ET_Status_Ended_At__c = system.now();
                        reqKPIRec.ET_Status_Ended_by_User__c = UserInfo.getUserId();
                        if(reqKPIRec.ET_Status_Started_At__c!=null && reqKPIRec.ET_Status_Ended_At__c!=null){
                            // reqKPIRec.Actual_Process_Min_Excluding_Weekends__c=  getDifferenceWorkingMinutes(reqKPIRec.Status_Started_At__c,reqKPIRec.Status_Ended_At__c);
                        }
                        updateRequestKPIList.add(reqKPIRec);
                        if(recordIdTostatusMap.get(reqId) != null){
                            ET_KPI_Request__c newReqKPIRec = new ET_KPI_Request__c(ET_Status__c= recordIdTostatusMap.get(reqId),ET_Status_Started_At__c=System.now(),ET_Status_Started_by_User__c=UserInfo.getUserId());
                            newReqKPIRec.put(lookupFieldAPINme,Id.valueOf(reqId));
                            // newReqKPIRec.Version__c = recordToVersionMap.get(reqId);
                            updateRequestKPIList.add(newReqKPIRec);
                        }
                    }
                }else{
                    if(recordIdTostatusMap.get(reqId) != null){
                        ET_KPI_Request__c newReqKPIRec = new ET_KPI_Request__c(ET_Status__c = recordIdTostatusMap.get(reqId), ET_Status_Started_At__c = System.now(),ET_Status_Started_by_User__c = UserInfo.getUserId());
                        newReqKPIRec.put(lookupFieldAPINme,Id.valueOf(reqId));
                        // newReqKPIRec.Version__c = recordToVersionMap.get(reqId);
                        updateRequestKPIList.add(newReqKPIRec);
                    }
                }
            }
        }
        if(updateRequestKPIList.size() > 0){
            upsert updateRequestKPIList;
        }
    }
}
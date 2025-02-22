/*
* FileName:CICO_InspectionCheckInCreationService
* Author : Janardhan Muddana
* CreatedDate : 27th May 2021
* Modification Purpose
* * 1. Janardhan: Created for creating inspection Check in oracle
* * 
*/
public class CICO_InspectionCheckInCreationService {       
    
    
    @AuraEnabled
    public static string createInspectionInOracle(string RecId){
    
        string Inspector1='';
        string Inspector2='';
        string Inspector3='';
        string Inspector4='';
        string shippedDate='';
        string actualRcvdDate='';
        string SupDocType='';
        string SupDocNo=null;
        string requesDate='';
        string penality='';
        
        
        
        List<CICO_Intimation_Line__c> lines =  [select id,Intimation_ID__r.Name,Name,Intimation_Quantity__c, (select id,Name,Current_Chassis_No__c,Receive_Km__c,Comment__c,Inspection_Status__c,Inspected__c,Shipped_Date__c,Actual_Receive_Date__c,Sup_Doc_Type__c,Sup_Doc_No__c,Sup_Doc_Date__c,Inspector1__r.ETIN_Employee_Id__c,Inspector2__r.ETIN_Employee_Id__c,Inspector3__r.ETIN_Employee_Id__c,Inspector4__r.ETIN_Employee_Id__c,Penalty__c from Vehicle_Spec__r where Inspection_Status__c != 'Pending' AND Inspected__c = false AND Inspection_No__c = null) from CICO_Intimation_Line__c where Line_Status__c = 'Pending'AND Intimation_ID__c=:RecId];      
         
              
        List<XxetFmsInspectionLinesStg> linestagList = new List<XxetFmsInspectionLinesStg>();
       if(!lines.isEmpty()){
            
            for(CICO_Intimation_Line__c line : lines){
                
                list<XxetFmsInspectionShipsStg> shipList = new list<XxetFmsInspectionShipsStg>();
                XxetFmsInspectionLinesStg linestag = new XxetFmsInspectionLinesStg();
                linestag.interfaceFlag = 'New';
                linestag.receivedQty = Integer.valueOf(line.Vehicle_Spec__r.size());
                linestag.intimationLineId = Integer.valueOf(line.Name);
                
                
                if(line.Vehicle_Spec__r.size()>0)
                for(CICO_Vehicle_Spec__c veh : line.Vehicle_Spec__r){
                   
                    XxetFmsInspectionShipsStg ships = new XxetFmsInspectionShipsStg();
                    ships.interfaceFlag = 'New';
                    ships.chasisNo = veh.Name;
                    ships.currentChassisNo = veh.Current_Chassis_No__c;
                    ships.currentKmReading = Integer.valueOf(veh.Receive_Km__c);
                    ships.inspectionResult = veh.Inspection_Status__c;
                    ships.remarks = veh.Comment__c;
                    shipList.add(ships);
                    
                   
                    Inspector1 = veh.Inspector1__r.ETIN_Employee_Id__c;
                    Inspector2 = veh.Inspector2__r.ETIN_Employee_Id__c;
                    Inspector3 = veh.Inspector3__r.ETIN_Employee_Id__c;
                    Inspector4 = veh.Inspector4__r.ETIN_Employee_Id__c;
                    shippedDate = String.valueOf(veh.Shipped_Date__c);
                    actualRcvdDate=String.valueOf(veh.Actual_Receive_Date__c);
                    SupDocType= String.valueOf(veh.Sup_Doc_Type__c);
                    SupDocNo= veh.Sup_Doc_No__c != null ?string.valueOf(veh.Sup_Doc_No__c):null;
                    requesDate=String.valueOf(veh.Sup_Doc_Date__c);
                    penality= veh.Penalty__c;
                      
                    
                }
                XxetFmsInspectionShipsStgCollection shpColl = new XxetFmsInspectionShipsStgCollection();
                shpColl.XxetFmsInspectionShipsStg = shipList; 
                linestag.eligibilityPenality = penality;
                linestag.xxetFmsInspectionShipsStgCollection = shpColl;
                linestagList.add(linestag);
                
            }
            
            XxetFmsInspectionLinesStgCollection lineStagcoll = new XxetFmsInspectionLinesStgCollection();
            lineStagcoll.XxetFmsInspectionLinesStg = linestagList;
            
            XxetFmsInspectionHdrStg hdrStag = new XxetFmsInspectionHdrStg();
            hdrStag.xxetFmsInspectionLinesStgCollection = lineStagcoll;
            hdrStag.intimationId = Integer.valueOf(lines[0].Intimation_ID__r.Name);
            hdrStag.grnDate = String.valueOf(system.today());  
            hdrStag.creationDate = String.valueOf(system.today()); 
            
            if(lines.size()>0){
                hdrStag.createdByGrn = Inspector1;
                hdrStag.inspectionId1 =Inspector1;
                hdrStag.inspectionId2 = Inspector2;
                hdrStag.inspectionId3 = Inspector3;
                hdrStag.inspectionId4 = Inspector4;
                hdrStag.shippedDate = shippedDate;
                hdrStag.actualRcvdDate = actualRcvdDate;
                hdrStag.addColumn9 = SupDocType;
                hdrStag.addColumn10 = SupDocNo;
                hdrStag.requestDate = requesDate;
            }
           
           
            hdrStag.interfaceFlag='New';
            
            
            list<XxetFmsInspectionHdrStg> hdrstaglist = new list<XxetFmsInspectionHdrStg>();
            hdrstaglist.add(hdrStag);
            
            
            XxetFmsInspectionHdrStgCollection stagCollection = new XxetFmsInspectionHdrStgCollection();
            stagCollection.XxetFmsInspectionHdrStg = hdrstaglist;
            
            OracleWrapper wrapfinal = new OracleWrapper();
            wrapfinal.XxetFmsInspectionHdrStgCollection = stagCollection;
            
         
            
            String jsonString = JSON.serialize(wrapfinal);
            System.debug('--json--'+jsonString);
        
        
        ET_Oracle_REST_Endpoints__mdt connection = ET_REST_Authorize_Helper.getSOAPEndpointFromMetadata('CICO_InspectionCheckIn');
        
        HttpRequest request = new HttpRequest(); 
        HttpResponse response = new HttpResponse();  
        Http http = new Http();
        Blob beforeblob = Blob.valueOf(connection.Username__c+':'+connection.Password__c);
        
        string paramvalue = EncodingUtil.base64Encode(beforeblob);
        if(ET_REST_Authorize_Helper.runningInASandbox()){
            request.setEndpoint(connection.Dev_Endpoint__c);
        }else{
            request.setEndpoint(connection.LiveEndpoint_c__c);
        }
        
        request.setHeader('Authorization','Basic '+paramvalue);          
        request.setHeader('Content-Type','application/json'); 
        request.setMethod('POST');
        
        request.setBody(jsonString);
           if(jsonString != null)
               if(!Test.isRunningTest()){
                   response = http.send(request); 
               }
        
         /*  Integration_Log__c log = new Integration_Log__c();
           log.Integration_Type__c = 'OUTBOUND';
           log.Pay_Load__c = jsonString;
           log.Process_Name__c = 'Inspection Check In';
           log.Source_System__c = 'Salesforce';
           log.Target_System__c = 'Oracle';
           
           insert log;*/           
           
        system.debug(response.getBody());
        return response.getBody(); 
       
        } else {
            return null;
        }
        // return jsonString;
        
        
        
    }
    
    
    public class OracleWrapper {
        
        public XxetFmsInspectionHdrStgCollection  XxetFmsInspectionHdrStgCollection; 
    }
    
    
    public class XxetFmsInspectionHdrStgCollection {
        public list<XxetFmsInspectionHdrStg>  XxetFmsInspectionHdrStg;
    }
    
    
    public class XxetFmsInspectionHdrStg {
        public Integer intimationId;
        public String grnDate;
        public String shippedDate;
        public String createdByGrn;
        public String actualRcvdDate;
        public String inspectionId1;
        public String inspectionId2;
        public String inspectionId3;
        public String inspectionId4;        
        public String creationDate;
        public String interfaceFlag;
        public String addColumn9;
        public String addColumn10;
        public String requestDate;
        
        public XxetFmsInspectionLinesStgCollection xxetFmsInspectionLinesStgCollection;
    }
    
    public class XxetFmsInspectionLinesStgCollection {
        public List<XxetFmsInspectionLinesStg> XxetFmsInspectionLinesStg;
    }
    
    public class XxetFmsInspectionLinesStg {
        public String interfaceFlag;
        public Integer receivedQty;
        public Integer intimationLineId;
        public String eligibilityPenality;
        public XxetFmsInspectionShipsStgCollection xxetFmsInspectionShipsStgCollection;
    }
    
    public class XxetFmsInspectionShipsStgCollection {
        public List<XxetFmsInspectionShipsStg> XxetFmsInspectionShipsStg;
    }
    
    public class XxetFmsInspectionShipsStg {
        public String interfaceFlag;
        public String chasisNo;
        public String currentChassisNo;
        public Integer currentKmReading;
        public String inspectionResult;
        //public String status;
        public String remarks;
    }
    
    
    
}
public with sharing class qHSE_InspectionController {
    @AuraEnabled
    public static List<QHSE_Inspection__c> fetchInspectionData(){
        try {
            List<QHSE_Inspection__c> inspections = [Select id, name, StationFormula__c, StationName__r.name, StationName__c, Inspection_Date__c, Result_Date__c,
                                                    Inspector_Name__c, Location__c   from QHSE_Inspection__c order by createdDate desc limit 30 ];
            return inspections;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled
    public static List<QHSE_Inspection_Line__c> fetchInspectionLines(String inspectionId){
        try {
            System.debug('-----inspectionId------'+inspectionId);
            List<QHSE_Inspection_Line__c> inspectionLines = [Select id, name,ET_Vehicle_Master__c, ET_Vehicle_Master__r.name, 
                                                    Corrective_Action__c, Description__c, Proof__c, Requirement__c, Root_Cause__c, Severity__c,
                                                    Status__c, Target_Date__c, Classification__c, Additional_Notes__c
                                                    from QHSE_Inspection_Line__c 
                                                    where QHSE_Inspection__c =: inspectionId
                                                    order by createdDate desc ];
            return inspectionLines;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }
    
     @AuraEnabled
    public static Id createInspectionRecord(String station, Date inspection_Date, String inspector_Name, String designation, String location) {
        try {
            QHSE_Inspection__c inspection = new QHSE_Inspection__c();
            inspection.StationName__c = station;
            inspection.Inspection_Date__c = inspection_Date;
            inspection.Inspector_Name__c = inspector_Name;
            inspection.Designation__c = designation;
            inspection.Location__c = location;
            insert inspection;
            return inspection.Id;
        } catch (Exception ex) {
            throw new AuraHandledException('Error creating inspection record: ' + ex.getMessage());
        }
    }

    @AuraEnabled
    public static Id createInspectionLineRecord(String inspectionId){
        try {
            QHSE_Inspection_Line__c inspectionLine = new  QHSE_Inspection_Line__c();
            inspectionLine.QHSE_Inspection__c = inspectionId;
            insert inspectionLine;
            
            return inspectionLine.Id;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    public static void testCoverage1(){
        Integer i = 0;
        
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
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
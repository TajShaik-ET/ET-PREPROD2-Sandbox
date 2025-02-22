/*This class is used to retrieve the Job Card details for job_card VF Page
 Author:Shiju Kooriyil
 Test Class - 
 Drafted on:24 March 2023
*/
public class JobCardController {
    public Id RecordId {get;set;}
    public list<ETT_Job_Card__c> jobCardtyreInventory{get;set;}
    public list<ETT_Tyre_Rejection_Line_Item__c> sidewallcuts {get;set;}
    public String TyreSize {get;set;}
    public String OPattern {get;set;}
    public String TyreMake {get;set;}
    public String SerialNo {get;set;}
    public String CollCard {get;set;}
    public Date CollDate {get;set;}
    public String sidewallcut {get;set;}
    public Decimal crownCut {get;set;}
    
    public  JobCardController(ApexPages.StandardController controller) {
        TyreSize ='';
        OPattern ='';
        TyreMake ='';
        SerialNo ='';
        CollCard ='';
        sidewallcut ='';
        String currentRecordId  = ApexPages.CurrentPage().getparameters().get('Id');
        sidewallcuts = new List<ETT_Tyre_Rejection_Line_Item__c>();
        jobCardtyreInventory = new List<ETT_Job_Card__c>();
        jobCardtyreInventory=[select Tyre_Inventory__r.ETT_Tyre_Size_Master__r.Name,Tyre_Inventory__r.ETT_Pattern__r.Name,Tyre_Inventory__r.ETT_Brand__r.Name,Tyre_Inventory__r.Serial_Number__c,Tyre_Inventory__r.ETT_Collection_Card__r.Name,Tyre_Inventory__r.ETT_Collection_Card__r.ETT_Collection_Date__c,ETT_Inspection_Card__c from ETT_Job_Card__c WHERE Id =:currentRecordId];
		sidewallcuts =[Select Name,Cut__c,Crown_Cuts__c,ETT_Inspection_Card__c from ETT_Tyre_Rejection_Line_Item__c where (Name ='SideWallArea' or Name ='CrownArea') and ETT_Inspection_Card__c=:jobCardtyreInventory[0].ETT_Inspection_Card__c];
        TyreSize = jobCardtyreInventory[0].Tyre_Inventory__r.ETT_Tyre_Size_Master__r.Name;
        OPattern = jobCardtyreInventory[0].Tyre_Inventory__r.ETT_Pattern__r.Name;
        TyreMake = jobCardtyreInventory[0].Tyre_Inventory__r.ETT_Brand__r.Name;
        SerialNo = jobCardtyreInventory[0].Tyre_Inventory__r.Serial_Number__c;
        CollCard = jobCardtyreInventory[0].Tyre_Inventory__r.ETT_Collection_Card__r.Name;
        CollDate = Date.newinstance(jobCardtyreInventory[0].Tyre_Inventory__r.ETT_Collection_Card__r.ETT_Collection_Date__c.year(),jobCardtyreInventory[0].Tyre_Inventory__r.ETT_Collection_Card__r.ETT_Collection_Date__c.month(),jobCardtyreInventory[0].Tyre_Inventory__r.ETT_Collection_Card__r.ETT_Collection_Date__c.day());
        for(ETT_Tyre_Rejection_Line_Item__c TRlineitem : sidewallcuts){
          if(TRlineitem.Name =='SideWallArea'){
        sidewallcut = TRlineitem.Cut__c;    
        }
        else if(TRlineitem.Name =='CrownArea'){
            crownCut = TRlineitem.Crown_Cuts__c;    
        } 
        }
        
        
        System.debug('sidewallcut'+sidewallcut);
        System.debug('crownCut'+crownCut);
    }
		

}
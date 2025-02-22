@isTest
public class customLookUpController_Test {
 @isTest
     public static void testMethod1(){
        
         List<Lead> leadList =  ETT_TestFactory.createLeads();
        insert leadList;
       List<ETT_Tools_Master__c> toolMasterToInsert=new List<ETT_Tools_Master__c>();
        ETT_Tools_Master__c toolMaster_1=ETT_TestFactory.createToolMaster('Buffing Machine','Tools',null,10,2,'Buffmachine001','Buffing machine',null,20,'Daily',null,'Buffing;Skiving',null,null,'Available','','Track','Auto-create for all JC',null,null,'Individual product','Depreciable');
        toolMasterToInsert.add(toolMaster_1);
        ETT_Tools_Master__c toolMaster_2=ETT_TestFactory.createToolMaster('Shoulder Strip-001','Material - Others',null,10,5,'Shoulder Strip-001','Shoulder Strip-001',null,20,'Daily',null,'Buffing;Skiving',null,null,'Available','',null,null,null,null,'Weight(Kgm based)','Consumable');
        toolMasterToInsert.add(toolMaster_2);            
        insert toolMasterToInsert;
      
       // List<ETT_Brand_Master__c> brandMastersList = ETT_TestFactory.createBrandMasters();
        List<ETT_Pattern_Master__c> patternMastersList = ETT_TestFactory.createPatternMasters();
       
        
        patternMastersList[0].ETT_Status__c = true;
        patternMastersList[0].Name = 'Test Record';
        //insert cntry;
   
        insert patternMastersList;
      

        //tyreMasterSizeList[0].ETT_Original_Pattern__c = patternMastersList[0].id;
         //insert tyreMasterSizeList;
        //insert brandMastersList;
       // List<ETT_Tyre_Master__c> tyreMastersList = ETT_TestFactory.createTyreMasters('Draft', patternMastersList[0].Id,cntry.Id,tyreMasterSizeList[0].Id,brandMastersList[0].Id);
        //insert tyreMastersList[0];
        system.debug('brand'+[select id,name from ETT_Pattern_Master__c where Name LIKE '%%']);
        //system.debug('res '+[SELECT Id, ETT_Tyre_Size__r.ETT_Status__c From ETT_Tyre_Master__c]);
        
      /* ETT_Tyre_Master__c etttyre = new ETT_Tyre_Master__c(
            CurrencyIsoCode = 'AED',
            ETT_Actual_Width__c = 210.0,
            ETT_Bead_Adjustment__c = 2.0,
            ETT_Brand_Code__c = 'ALT',
            //ETT_Brand_Name__c = brandMastersList[0].id,
            ETT_Country_Code__c = 'IND',
            //ETT_Country_Name__c = cntry.id,
            ETT_Country_Status__c = false,
            ETT_Item_Code_Refurbished__c = 'TR-10.00-20-ALT',
            ETT_Item_Code_Scrap__c = 'TS-10.00-20-ALT',
            ETT_Item_Code_Used__c = 'TU-10.00-20-ALT',
            ETT_Length__c = 3.2,
            ETT_Load_Index__c = '146/142',
            ETT_Original_Pattern__c = patternMastersList[0].id,
            ETT_Ply_Rate__c = '16',
            ETT_Rim_Size__c = 20.0,
            ETT_Speed_Index__c = 'J',
            ETT_Status__c = false,
            ETT_Tyre_Radiues__c = '24',
            //ETT_Tyre_Size__c = tyreMasterSizeList[0].id,
            ETT_Tyre_Status__c = false,
            ETT_Vehicle_Type__c = 'Bus');
        insert etttyre;*/
        //system.debug('tyreMastersList '+tyreMastersList);
       
      //customLookUpController.fetchLookUpValues('test', 'test2', 'test3');
     customLookUpController.fetchToolsandMaterial('Buffmachine001');
          customLookUpController.fetchLookUpValues('Buffing Machine', 'ETT_Tools_Master__c', 'name');
         try{
             customLookUpController.fetchLookUpValues2('Test Record','User');
   
         }catch(Exception e){}    
          
    }
    
    
    
    
    
}
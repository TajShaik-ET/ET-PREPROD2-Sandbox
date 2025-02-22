/*
Developer Name - Srihari Koyila
Developed Date - 20 June 2023
Class          - LookupLWCController
Test Class     - LookupLWCControllerTest  
****************************************************************************************************************/
@isTest
public class LookupLWCControllerTest {
    @isTest
    private static void testLookupLog(){
        
        List<Id> selectedIds = new List<Id>();
        selectedIds.add('a6m8E000000twI8QAI');
		selectedIds.add('a6m8E000000twIDQAY');
		selectedIds.add('a6m8E000000u61gQAA');
        Test.StartTest();
        try{
        LookupLWCController.searchRecords('Honda','Vehicle_Brand_Master__c',selectedIds,'');     
        }catch(Exception e){
          
        }    
          
        test.stoptest();
        
      
    }
		
    
}
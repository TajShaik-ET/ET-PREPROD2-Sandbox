@isTest
public class ETT_MaterialReturnNoteControllerTest {

    @testSetup
    static void setupTestData() {
        // Create a test Goods Issue Note
        ETT_Goods_Issue_Note__c testGIN = new ETT_Goods_Issue_Note__c(
            Issue_Type__c='Factory',
            Transaction_Date__c=date.today()
           
        );
        insert testGIN;
          
        ETT_Tools_Master__c tool = new ETT_Tools_Master__c(Name = 'Tool A');
        insert tool;
        
        // Create test Goods Issue Lines
        List<ETT_Goods_Issue_Lines__c> testGoodsIssueLines = new List<ETT_Goods_Issue_Lines__c>();
        for (Integer i = 0; i < 3; i++) {
            ETT_Goods_Issue_Lines__c goodsIssueLine = new ETT_Goods_Issue_Lines__c(
                Goods_Issue_Note__c = testGIN.Id,
                Process_Name__c = 'General',
                Issued_Quantity__c = 10 + i,
                Tool_Material_Name__c=tool.id
               
            );
            testGoodsIssueLines.add(goodsIssueLine);
        }
        insert testGoodsIssueLines;

        // Create a test Material Return Note
        ETT_Material_Return_Note__c testReturnNote = new ETT_Material_Return_Note__c(
           
            Return_Type__c='Factory',
            GIN__c=testGIN.Id,
            Status__c='Pending'
        
        );
        insert testReturnNote;
    }

    @isTest
    static void testGetGoodsIssueLines() {
        // Fetch test data
        ETT_Goods_Issue_Note__c testGIN = [SELECT Id FROM ETT_Goods_Issue_Note__c LIMIT 1];
        
        // Test the getGoodsIssueLines method
        Test.startTest();
        List<ETT_Goods_Issue_Lines__c> result = ETT_MaterialReturnNoteController.getGoodsIssueLines(testGIN.Id);
        Test.stopTest();
    }

    @isTest
    static void testCreateMaterialReturnLines() {
        // Fetch test data
        ETT_Goods_Issue_Lines__c goodsLine = [SELECT Id FROM ETT_Goods_Issue_Lines__c LIMIT 1];
        ETT_Material_Return_Note__c returnNote = [SELECT Id FROM ETT_Material_Return_Note__c LIMIT 1];
        
        // Prepare input data
        List<Map<String, Object>> goodsIssueLineData = new List<Map<String, Object>>();
        Map<String, Object> lineData = new Map<String, Object>{
            'id' => goodsLine.Id,
            'quantity' => 5
        };
        goodsIssueLineData.add(lineData);

        // Test the createMaterialReturnLines method
        Test.startTest();
        ETT_MaterialReturnNoteController.createMaterialReturnLines(goodsIssueLineData, returnNote.Id);
        Test.stopTest();

        // Verify the return lines were created
        List<Material_Return_Lines__c> returnLines = [SELECT Id, Return_Qty__c, Goods_Issue_Lines__c, Material_Return_Note__c 
                                                      FROM Material_Return_Lines__c 
                                                      WHERE Material_Return_Note__c = :returnNote.Id];
      
    }

   }
@isTest
public class ETT_Goods_Note_Issue_Details_Test {
    
       
    @testSetup
    static void setupTestData() {
        // Create a mock Tool_Material record
        ETT_Tools_Master__c toolMaterial = new ETT_Tools_Master__c(
            Name = 'TREAD',
            ETT_Allocated_Units__c=100.00,
           // ETT_Status__='Available',
            Main_Stock_Average_Price__c = 100.00
           
        );
        insert toolMaterial;

        // Create a mock Goods Issue Note record
        ETT_Goods_Issue_Note__c goodsIssueNote = new ETT_Goods_Issue_Note__c(
           // Name = 'Test Goods Issue Note',
            Issue_Type__c = 'Factory',
            Status__c='Approved',
            Transaction_Date__c = Date.today()
            
        );
        insert goodsIssueNote;
        
        // Create mock Goods Issue Lines related to the Goods Issue Note
        List<ETT_Goods_Issue_Lines__c> issueLines = new List<ETT_Goods_Issue_Lines__c>();
        issueLines.add(new ETT_Goods_Issue_Lines__c(
            Goods_Issue_Note__c = goodsIssueNote.Id,
            //Name = 'Test Line 1',
            Issued_Quantity__c = 10,
            Tool_Material_Name__c = toolMaterial.Id
        ));
        issueLines.add(new ETT_Goods_Issue_Lines__c(
            Goods_Issue_Note__c = goodsIssueNote.Id,
           // Name = 'Test Line 2',
            Issued_Quantity__c = 5,
            Tool_Material_Name__c = toolMaterial.Id
        ));
        insert issueLines;
    }
    
    @isTest
    static void testGoodsNoteIssueDetails() {
        // Fetch the Goods Issue Note record created in the test setup
        ETT_Goods_Issue_Note__c goodsIssueNote = [SELECT Id FROM ETT_Goods_Issue_Note__c LIMIT 1];
        
        // Instantiate the StandardController with the Goods Issue Note record
        ApexPages.StandardController sc = new ApexPages.StandardController(goodsIssueNote);
        
        // Instantiate the ETT_Goods_Note_Issue_Details class
        ETT_Goods_Note_Issue_Details controller = new ETT_Goods_Note_Issue_Details(sc);
        
        // Verify that the correct goods issue note was fetched
        System.assertNotEquals(null, controller.goodsNoteIssue, 'Goods Issue Note should not be null');
        System.assertEquals(goodsIssueNote.Id, controller.goodsNoteIssue.Id, 'The fetched Goods Issue Note should match the one created in test data');
        
        // Verify the goods issue lines were fetched
        System.assertNotEquals(null, controller.goodsIssueLines, 'Goods Issue Lines should not be null');
        System.assertEquals(2, controller.goodsIssueLines.size(), 'There should be 2 Goods Issue Lines fetched');
        
        // Verify the totals were calculated correctly
        System.assertEquals(15, controller.totalIssuedQuantity, 'Total issued quantity should be 15');
        System.assertEquals(1500, controller.totalPrice, 'Total price should be 1500 (100 * 10 + 100 * 5)');
    }

}
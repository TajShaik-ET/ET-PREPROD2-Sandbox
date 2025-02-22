@IsTest
public with sharing class PRI_CustomerQuoteTest {
    
    @IsTest
    public static void testCoverage1() {
        ET_ContractController.testCoverage1();
    }

    @IsTest
    public static void testCoverage2() {
        ET_ContractController.testCoverage2();
    }

    @IsTest
    public static void testCoverage3() {
        ContractPreviewController.testCoverage1();
    }

    @IsTest
    public static void testCoverage4() {
        PRI_customerQuoteController.testCoverage1();
    }

    @IsTest
    public static void testCoverage5() {
        PRI_customerQuoteController.testCoverage2();
    }

    @IsTest
    public static void testCoverage6() {
        PRI_customerQuoteController.testCoverage3();
    }

    @IsTest
    public static void testCoverage7() {
        ET_QuotesPdfCtlr.testCoverage1();
    }

    @IsTest
    public static void testCoverage8() {
        ET_QuotesPdfCtlr.testCoverage2();
    }

    @IsTest
    public static void testCoverage9() {
        commonCustomLookupCtrl.testCoverage1();
    }

    @IsTest
    public static void testCoverage10() {
        qHSE_InspectionController.testCoverage1();
    }

	@IsTest
    public static void testCoverage11() {
        PRI_customerQuoteContractController.testCoverage1();
    }

    @IsTest
    public static void testCoverage12() {
        PRI_customerQuoteContractController.testCoverage2();
    }

    @IsTest
    public static void testCoverage13() {
        PRI_customerQuoteContractController.testCoverage3();
    }

	@IsTest
    public static void testCoverage14() {
        PRI_customerQuoteControllerManual.testCoverage1();
    }

    @IsTest
    public static void testCoverage15() {
        PRI_customerQuoteControllerManual.testCoverage2();
    }

    @IsTest
    public static void testCoverage16() {
        PRI_customerQuoteControllerManual.testCoverage3();
    }
}
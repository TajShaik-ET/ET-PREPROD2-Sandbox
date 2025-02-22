/***
Class       : MOTO_CreateAccountInERP
Author      : Janardhan Muddana
Description : create account and vehicle in ERP
TestClass  :  MOTO_SendPersonAccountToERPTest
----------------------------------------------------------------------------------------------------------------
            -- History --
----------------------------------------------------------------------------------------------------------------
Sr.No.  version_DevInitials     Date                Details
1.          V1.0              13/04/23           Initial Version 
****************************************************************************************************************/

public class MOTO_CreateAccountInERP {
    @auraEnabled
    public static string createOracleAccount(string OppId,string AccIdVal){
        string resVal=''; 
        if(!test.isRunningTest())
        resVal= MOTO_SendPersonAccountToERP.sendAccToERP(AccIdVal,OppId);
        
         return resVal;
        
    }

}
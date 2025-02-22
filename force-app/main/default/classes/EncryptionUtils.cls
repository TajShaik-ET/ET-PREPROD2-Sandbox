/*******************************************************************************************************************
Class       : EncryptionUtils
Author      : Taj Shaik
Description : To Encrypt and Dycrypt data 
TestClass   : EncryptionUtilsTest
----------------------------------------------------------------------------------------------------------------
-- History --
----------------------------------------------------------------------------------------------------------------
Sr.No.  version_DevInitials     Date                Details
1.      V1.0_SH                 Jul 23, 2024        Initial Version
*******************************************************************************************************************/
public with sharing class EncryptionUtils {
    public static String encryptString(String text) {
        Blob cryptoKey = Blob.valueOf(System.Label.EncryptionKey); //PrivateKey123456PrivateKey123456
        Blob data = Blob.valueOf(text);
        Blob encryptedData = Crypto.encryptWithManagedIV('AES256', cryptoKey, data);
        String encryptedString = EncodingUtil.base64encode(encryptedData);
        System.debug('encryptedString: '+encryptedString);
        return encryptedString;
    }
    public static String decryptString(String encryptedString) {
        Blob cryptoKey = Blob.valueOf(System.Label.EncryptionKey); //PrivateKey123456PrivateKey123456
        Blob encryptedData = EncodingUtil.base64Decode(encryptedString);
        Blob decryptedData = Crypto.decryptWithManagedIV('AES256', cryptoKey, encryptedData);
        String decryptedString = decryptedData.toString();
        System.debug('decryptedString: '+decryptedString);
        return decryptedString;
    }
}
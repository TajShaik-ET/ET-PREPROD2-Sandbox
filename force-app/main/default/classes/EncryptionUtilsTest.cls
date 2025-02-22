@IsTest
private class EncryptionUtilsTest {
    
    @TestSetup
    static void setup() {
        // Setup the required data, if any.
        // You can also mock or setup labels if needed.
    }
    
    @IsTest
    static void testEncryptionDecryption() {
        // Test case 1: Basic encryption and decryption
        String originalText = 'Test1234';
        String encryptedText = EncryptionUtils.encryptString(originalText);
        System.assertNotEquals(originalText, encryptedText, 'Encrypted text should not be the same as the original text.');
        
        String decryptedText = EncryptionUtils.decryptString(encryptedText);
        System.assertEquals(originalText, decryptedText, 'Decrypted text should match the original text.');
        
        // Test case 2: Empty string
        originalText = '';
        encryptedText = EncryptionUtils.encryptString(originalText);
        decryptedText = EncryptionUtils.decryptString(encryptedText);
        System.assertEquals(originalText, decryptedText, 'Decrypted text for an empty string should match the original empty string.');
        
        // Test case 3: Special characters
        originalText = 'Hello, World! @#$%^&*()';
        encryptedText = EncryptionUtils.encryptString(originalText);
        decryptedText = EncryptionUtils.decryptString(encryptedText);
        System.assertEquals(originalText, decryptedText, 'Decrypted text with special characters should match the original text.');
        
        // Test case 4: Null input (expecting an exception)
        try {
            encryptedText = EncryptionUtils.encryptString(null);
            System.assert(false, 'Encryption should throw an exception for null input.');
        } catch (NullPointerException e) {
            System.assert(true, 'NullPointerException expected for null input.');
        }
        
        // Similarly, test decryption with null (expecting an exception)
        try {
            decryptedText = EncryptionUtils.decryptString(null);
            System.assert(false, 'Decryption should throw an exception for null input.');
        } catch (NullPointerException e) {
            System.assert(true, 'NullPointerException expected for null input.');
        }
    }
    
    @IsTest
    static void testEdgeCases() {
        // Test case 5: Long string
        String longText = 'A'.repeat(5000); // Create a long string
        String encryptedText = EncryptionUtils.encryptString(longText);
        String decryptedText = EncryptionUtils.decryptString(encryptedText);
        System.assertEquals(longText, decryptedText, 'Decrypted text should match the original long text.');
    }
    
}
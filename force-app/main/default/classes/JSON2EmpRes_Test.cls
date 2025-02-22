@IsTest
public class JSON2EmpRes_Test {
    
    static testMethod void testParse() {
        String json = '{'+
        '  \"Status\" : \"E\",'+
        '  \"Message\" : \"Could not derive employee information from HRMS\"'+
        '}';
        JSON2EmpSyncRes obj = JSON2EmpSyncRes.parse(json);
        System.assert(obj != null);
    }
}
@IsTest
public class CreateCaseParser_Test {
    static testMethod void testParse() {
        String json = '['+
        '   {'+
        '      \"type\":\"\",'+
        '      \"assignedVehicle\":\"\",'+
        '      \"driverName\":\"\",'+
        '      \"activityLocation\":\"\",'+
        '      \"description\":\"\"'+
        '   }'+
        ']';
        List<CreateCaseParser> r = CreateCaseParser.parse(json);
        System.assert(r != null);

        json = '{\"TestAMissingObject\": { \"TestAMissingArray\": [ { \"TestAMissingProperty\": \"Some Value\" } ] } }';
        CreateCaseParser objCreateCaseParser = new CreateCaseParser(System.JSON.createParser(json));
        System.assert(objCreateCaseParser != null);
        System.assert(objCreateCaseParser.type == null);
        System.assert(objCreateCaseParser.assignedVehicle == null);
        System.assert(objCreateCaseParser.driverName == null);
        System.assert(objCreateCaseParser.activityLocation == null);
        System.assert(objCreateCaseParser.description == null);
    }
}
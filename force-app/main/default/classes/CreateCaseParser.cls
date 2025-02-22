public class CreateCaseParser {
    public String type {get;set;} 
    public String assignedVehicle {get;set;} 
    public String driverName {get;set;}
    public String origin {get;set;}
    public String activityLocation {get;set;} 
    public String description {get;set;} 
    public String arkaniIncidentId {get;set;} 
    public String devicetype {get;set;} 
    public String currentLocation {get;set;} 
    public String contactPerson {get;set;} 
    public String contactNumber {get;set;} 
    public CreateCaseParser(JSONParser parser) {
        while (parser.nextToken() != System.JSONToken.END_OBJECT) {
            if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
                String text = parser.getText();
                if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
                    if (text == 'type') {
                        type = parser.getText();
                    } else if (text == 'assignedVehicle') {
                        assignedVehicle = parser.getText();
                    } else if (text == 'driverName') {
                        driverName = parser.getText();
                    }else if (text == 'origin') {
                        origin = parser.getText();
                    }else if (text == 'activityLocation') {
                        activityLocation = parser.getText();
                    } else if (text == 'description') {
                        description = parser.getText();
                    }else if (text == 'arkaniIncidentId') {
                        arkaniIncidentId = parser.getText();
                    }
                    else if (text == 'deviceType') {
                        devicetype = parser.getText();
                    } 
                    else if (text == 'currentLocation') {
                        currentLocation = parser.getText();
                    }
                    else if (text == 'contactPerson') {
                        contactPerson = parser.getText();
                    }
                    else if (text == 'contactNumber') {
                        contactNumber = parser.getText();
                    }
                    else {
                        System.debug(LoggingLevel.WARN, 'CreateCaseParser consuming unrecognized property: '+text);
                        consumeObject(parser);
                    }
                }
            }
        }
    }
    public static List<CreateCaseParser> parse(String json) {
        System.JSONParser parser = System.JSON.createParser(json);
        return arrayOfCreateCaseParser(parser);
    }
    public static void consumeObject(System.JSONParser parser) {
        Integer depth = 0;
        do {
            System.JSONToken curr = parser.getCurrentToken();
            if (curr == System.JSONToken.START_OBJECT || 
                curr == System.JSONToken.START_ARRAY) {
                    depth++;
                } else if (curr == System.JSONToken.END_OBJECT ||
                           curr == System.JSONToken.END_ARRAY) {
                               depth--;
                           }
        } while (depth > 0 && parser.nextToken() != null);
    }
    private static List<CreateCaseParser> arrayOfCreateCaseParser(System.JSONParser p) {
        List<CreateCaseParser> res = new List<CreateCaseParser>();
        if (p.getCurrentToken() == null) p.nextToken();
        while (p.nextToken() != System.JSONToken.END_ARRAY) {
            res.add(new CreateCaseParser(p));
        }
        return res;
    }
}
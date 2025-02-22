/* Author-Janardhan
 * Description - this handler is created to update activity,Dept,location and Project details from codes
 * 
 */
public class ETVIN_VehicleMasterTrgHandler {

    public static void updateGLDetails(list<Vehicle_Master__c> trgVal){
        
        map<string,string> GLActivityCodeVsName = new map<string,string>();
        map<string,string> GLDeptCodeVsName = new map<string,string>();
        map<string,string> GLLocCodeVsName = new map<string,string>();
        map<string,string> GLLocCodeVsZone = new map<string,string>();
        map<string,string> GLProjCodeVsName = new map<string,string>();
        
        for(GL_Activity__c act : [select id,Name,GL_Activity_Code__c from GL_Activity__c]){
             GLActivityCodeVsName.put(act.GL_Activity_Code__c,act.Name);
        }
        for(ETSALES_Department__c dept : [select id,Name,Department_Code__c from ETSALES_Department__c]){
             GLDeptCodeVsName.put(dept.Department_Code__c,dept.Name);
        }
        for(ETSALES_Location__c loc : [select id,Name,Location_Code__c,GL_Zone__c from ETSALES_Location__c]){
             GLLocCodeVsName.put(loc.Location_Code__c,loc.Name);
             GLLocCodeVsZone.put(loc.Location_Code__c,loc.GL_Zone__c);
        }
         for(GL_Project__c pro : [select id,Name,Project_Code__c from GL_Project__c]){
             GLProjCodeVsName.put(pro.Project_Code__c,pro.Name);
        }
        
        
        
        for(Vehicle_Master__c vm : trgVal){
            
            vm.Activity_Center__c = GLActivityCodeVsName.containsKey(vm.Activity_Center_code__c)?GLActivityCodeVsName.get(vm.Activity_Center_code__c):'None';
            vm.Department__c = GLDeptCodeVsName.containsKey(vm.Department_Code__c)?GLDeptCodeVsName.get(vm.Department_Code__c):'None';
            vm.Location__c = GLLocCodeVsName.containsKey(vm.Location_Code__c)?GLLocCodeVsName.get(vm.Location_Code__c):'None';
            vm.Zone__c = GLLocCodeVsZone.containsKey(vm.Location_Code__c)?GLLocCodeVsZone.get(vm.Location_Code__c):'None';
            vm.Project__c = GLProjCodeVsName.containsKey(vm.Project_Code__c)?GLProjCodeVsName.get(vm.Project_Code__c):'None';
            
        }
     
    }
    
}
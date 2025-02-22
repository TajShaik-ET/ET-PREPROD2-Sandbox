/* Author: Janardhan
 * Date: 17/01/2021
 * Description: This class is created to update GL details(Activity,Dept,Location,Project) names automatically based on GL codes
 */
public class ETIN_UpdateEmployeeGLDetails {

    public static void updateGLDetails(list<Account> trgVal){ 
          
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
    
         //Updating Contact GL Info
    
        for(Account vm : trgVal){
            
            vm.ETIN_Activity_Center__c = GLActivityCodeVsName.containsKey(vm.ETIN_Activity_Center_Code__c)?GLActivityCodeVsName.get(vm.ETIN_Activity_Center_Code__c):'';
            vm.PersonDepartment = GLDeptCodeVsName.containsKey(vm.ETIN_Department_Code__c)?GLDeptCodeVsName.get(vm.ETIN_Department_Code__c):'';
            vm.ETIN_Location__c = GLLocCodeVsName.containsKey(vm.ETIN_Location_Code__c)?GLLocCodeVsName.get(vm.ETIN_Location_Code__c):'';
            vm.ETIN_Employee_Zone__c = GLLocCodeVsZone.containsKey(vm.ETIN_Location_Code__c)?GLLocCodeVsZone.get(vm.ETIN_Location_Code__c):'';
            vm.ETIN_Project__c = GLProjCodeVsName.containsKey(vm.ETIN_Project_Code__c)?GLProjCodeVsName.get(vm.ETIN_Project_Code__c):'';
            
        }
        }
    
   

}
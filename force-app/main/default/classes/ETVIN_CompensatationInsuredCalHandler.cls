/*Author -Janardhan Muddana
 *Description- this is used to calculate compenstation value and insured value for vehicle insurance
 * 
 * 
 */

public class ETVIN_CompensatationInsuredCalHandler {

    
    public static void calculateInsuredAndCompenstationVal(list<ETIN_Claim__c> trgVal, map<id,ETIN_Claim__c> newMap,map<id,ETIN_Claim__c> oldMap){
        
       set<id> claimIds = new set<id>();
       
      /* map<string,Insurance_Rule_Master__c> mapIDvsRow = new  map<string,Insurance_Rule_Master__c>();
           
        for(Insurance_Rule_Master__c rule : [select id,name,AC_NonAC__c,Applied_Date__c,Total_Loss__c,Depreciation_Years__c,Insurance_Floor_Value__c,Insurance_Limit__c,Type_Description__c,Type_ID__c from Insurance_Rule_Master__c]){
            if(rule.Type_Description__c != null)
            mapIDvsRow.put(rule.Type_Description__c.toLowercase(),rule);
        }
         
      
        Id ClaimrecordTypeId =   Schema.SObjectType.ETIN_Claim__c.getRecordTypeInfosByDeveloperName().get('Vehicle_Insurance').getRecordTypeId();
        //[select id,name,RecordTypeId,Purchase_Date__c,Accident_Date__c,Insured_Value__c,Child_Bill_Value__c,Purchase_Value__c,VehicleMasterkey__c from ETIN_Claim__c where id=:newMap.keySet() ]){
            
        for(ETIN_Claim__c cl : trgVal){
            
            
            if(ClaimrecordTypeId == cl.RecordTypeId){
                
                if(cl.Accident_Date__c!= null && cl.VehicleMasterkey__c != null && cl.Purchase_Value__c != null && cl.Purchase_Date__c != null){
                    date accidentDate = cl.Accident_Date__c;
                    date accidentYearModDate = date.newInstance(accidentDate.year(), 1, 1); //consider 1st month and 1st date at accident year
                    integer noOfmonthsAsofAccident = cl.Purchase_Date__c.monthsBetween(accidentYearModDate);
                   
                    //system.debug('--Mod'+accidentYearModDate);
                    //system.debug('--no of months'+noOfmonthsAsofAccident);
                    
                    if(mapIDvsRow.containskey(cl.VehicleMasterkey__c.toLowercase())){
                       //Insured value calculations 
                        decimal lifeOfMonths  = mapIDvsRow.get(cl.VehicleMasterkey__c.toLowercase()).Depreciation_Years__c*12;
                        system.debug('--life'+lifeOfMonths);
                        decimal monthlyInsurance = cl.Purchase_Value__c/lifeOfMonths;
                        system.debug('--monthIns'+monthlyInsurance);
                        
                         decimal remaingLifeMonths =  lifeOfMonths - noOfmonthsAsofAccident;
                         decimal childBill;
                        if(remaingLifeMonths >= 0 && monthlyInsurance != null){
                            if( cl.Child_Bill_Value__c != null){
                               childBill = cl.Child_Bill_Value__c;
                            }else {
                                childBill = 0;
                            }
                            
                            decimal insuredValue = (monthlyInsurance*remaingLifeMonths)+ childBill;
                            system.debug('-insval-'+insuredValue);
                            
                            if(insuredValue <= mapIDvsRow.get(cl.VehicleMasterkey__c.toLowercase()).Insurance_Floor_Value__c){
                                
                                 cl.Insured_Value__c = mapIDvsRow.get(cl.VehicleMasterkey__c.toLowercase()).Insurance_Floor_Value__c;
                                
                            }else {
                                
                                 cl.Insured_Value__c = insuredValue.setscale(3);
                                
                            }
                            //compenstation Calculation
                            decimal daysbwAccmodAcc = accidentYearModDate.daysBetween(cl.Accident_Date__c);
                            decimal depPercentage = mapIDvsRow.get(cl.VehicleMasterkey__c.toLowercase()).Total_Loss__c;
                            
                            system.debug('--daysbwAccmodAcc*'+daysbwAccmodAcc);
                            system.debug('--depPercentage'+depPercentage);
                           
                            decimal compenstationval = insuredValue - ((daysbwAccmodAcc/365)*insuredValue*depPercentage);
                            
                            cl.Claim_Amount__c = compenstationval.setscale(3);
                        }
                        
                        
                    }
                    
                }
                
                
            }
            
           
        }*/
         
    }
}
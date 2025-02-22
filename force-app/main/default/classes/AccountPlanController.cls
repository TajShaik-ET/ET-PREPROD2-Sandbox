public class AccountPlanController {
    
    @AuraEnabled
    public static List<csvDataTableWrapper> saveFile(String base64Data) {
        String data = JSON.deserializeUntyped(base64Data).toString();
        System.debug('Cdata'+data);
        list<ETSALES_Account_Plan__c> lstCCToInsert = new list<ETSALES_Account_Plan__c>();
        List<csvDataTableWrapper> wrapperList = new List<csvDataTableWrapper>();
       
        list<String> lstCSVLines = data.split('\n');
        lstCSVLines.remove(0);
        System.debug('lstCSVLines 1 === '+lstCSVLines);
        System.debug('lstCSVLines 0 === '+lstCSVLines[0]);
        List<List<String>> lstCSVLine2=new List<List<String>>();
        List<ETSALES_Account_Plan__c> acntPlaneList=new List<ETSALES_Account_Plan__c>();
        List<ETSALES_Account_Plan__c> acntPlaneListtoBeInserted=new List<ETSALES_Account_Plan__c>();
        
        Integer recordNotInserted;
        for(Integer i=0;i<lstCSVLines.size();i++){
            List<String> sortedCsvList= lstCSVLines[i].split(',');
            system.debug('data2'+sortedCsvList[0]);
            List<Account> actList=[select id,name from Account where name=:sortedCsvList[0] limit 1];
            if(!actList.isEmpty()){
                List<String> dateSplit=sortedCsvList[1].split('-');
                List<ETSALES_Account_Plan__c> acntPlaneListnew=[select id from ETSALES_Account_Plan__c where ETSALES_Account__c=:actList[0].Id and ETSALES_Year__c=: dateSplit[2]  limit 1 ];
                if(acntPlaneListnew.isEmpty())
                {
                    
                    lstCSVLine2.add(lstCSVLines[i].split(','));
                    ETSALES_Account_Plan__c AccPlan = new ETSALES_Account_Plan__c();
                    AccPlan.ETSALES_Account__c = actList[0].Id;
                    AccPlan.ETSALES_Year__c=dateSplit[2];
                    acntPlaneList.add(AccPlan);
                    upsert AccPlan;
                    acntPlaneListtoBeInserted.add(AccPlan);
                }
                else{
                    lstCSVLine2.add(lstCSVLines[i].split(','));
                    acntPlaneList.add(acntPlaneListnew[0]);
                }
            }
        }
      //  Database.upsert(acntPlaneListtoBeInserted,false);
        Map<String,String> customerSectorName = new Map<String,String>{
            'Abu Dhabi Airport Taxi(Trans Ad)'=>'B2C/Managed for Cash',
                'Abu Dhabi City Taxi'=>'B2C/Managed for Cash',
                'Ajman Taxi'=>'B2C/Managed for Cash',
                'Driving School'=>'B2C/Managed for Cash',
                'Limo Services'=>'B2C/Managed for Cash',
                'Last Mile'=>'Digital',
                'Abu Dhabi Technical Services' => 'MRO',
                'Al Wataneyah Auction Center '=>'MRO',
                'Body Shop Unit '=>'MRO',
                'Dry Wash Unit '=>'MRO',
                'East Coast Technical Service '=>'MRO',
                'Emirates Moto '=>'MRO',
                'Emirates Technical service Center '=>'MRO',
                'EO Technical Service '=>'MRO',
                'Luxury Vehicles Maintenance Unit '=>'MRO',
                'RAK Technical service'=>'MRO',
                'Road Side Assistance '=>'MRO',
                'UCNG '=>'MRO',
                'Vehicle inspection Center '=>'MRO',
                'ESE Contract(School Services) '=>'School Transportation (Private and Government)',
                'ESE Contract(Transport)'=>'School Transportation (Private and Government)',
                'Government School Center '=>'School Transportation (Private and Government)',
                'MOE Contract(School Services) '=>'School Transportation (Private and Government)',
                'MOE Contract(Transport) '=>'School Transportation (Private and Government)',
                'Private School Transportation Center '=>'School Transportation (Private and Government)',
                'School Services Center '=>'School Transportation (Private and Government)',
                'Universities and Colleges '=>'Transport and Lease',
                'Abu Dhabi Transport and Leasing '=>'Transport and Lease',
                'Car Rental Services '=>'Transport and Lease',
                'East Coast Transport and Leasing '=>'Transport and Lease',
                'Electric Cars '=>'Transport and Lease',
                'Emirates Transport and Leasing '=>'Transport and Lease',
                'EO Transport and Rental '=>'Transport and Lease',
                'Government Transport '=>'Transport and Lease',
                'Rak Transport and Leasing '=>'Transport and Lease',
                'Transportation and Leasing Division '=>'Transport and Lease',
                'Valet Parking and Motorcycles Rental Center '=>'Transport and Lease'               
                };
        List<Customer_Sector__c> customerSectorList=new List<Customer_Sector__c>();
        List<Customer_Sector__c> customerSectorListTobeInsert=new List<Customer_Sector__c>();
        if(!acntPlaneList.isEmpty()){
            for(Integer i=0;i<lstCSVLine2.size();i++){
                System.debug('list'+customerSectorName.get(lstCSVLine2[i][2])+' '+acntPlaneList[i].Id);
                String customerSectorNameStr=customerSectorName.get(lstCSVLine2[i][2]);
                csvDataTableWrapper cdtw = new csvDataTableWrapper();
                	cdtw.CustomerName = lstCSVLine2[i][0];
                    cdtw.DOCDate = lstCSVLine2[i][1];
                    cdtw.ActivityCustomer = lstCSVLine2[i][2];
                    cdtw.Budget = lstCSVLine2[i][3];
                    cdtw.Actual = lstCSVLine2[i][4];
                    cdtw.CustomerNumber=lstCSVLine2[i][5];
                	wrapperList.add(cdtw);
                List<Customer_Sector__c> customerSectorList2=[select id,name from Customer_Sector__c where name=:customerSectorNameStr  limit 1];
                System.debug('custmer Sector '+customerSectorList2);
                if(customerSectorList2.isEmpty() ){
                    
                    Customer_Sector__c customerSector=new Customer_Sector__c();
                    customerSector.Name=customerSectorName.get(lstCSVLine2[i][2]);
                    customerSector.Account_Revenue__c=acntPlaneList[i].Id;
                    customerSector.Customer_Sector__c=customerSectorName.get(lstCSVLine2[i][2]);
                    customerSectorList.add(customerSector);
                    customerSectorListTobeInsert.add(customerSector);
                }
                else{
                    customerSectorList.add(customerSectorList2[0]);
                }
            }
            Database.upsert(customerSectorListTobeInsert,false);
            Map<Integer,String> monthNames = new Map<Integer,String>{
                1 => 'Jan',
                    2 => 'Feb',
                    3 => 'Mar',
                    4 => 'Apr',
                    5 => 'May',
                    6 => 'Jun',
                    7 => 'Jul',
                    8 => 'Aug',
                    9 => 'Sept',
                    10 => 'Oct',
                    11 => 'Nov',
                    12 => 'Dec'
                    };
                  Map<Integer,String> monthNamesFull = new Map<Integer,String>{
                                1 => 'January',
                                    2 => 'February',
                                    3 => 'March',
                                    4 => 'April',
                                    5 => 'May',
                                    6 => 'June',
                                    7 => 'July',
                                    8 => 'August',
                                    9 => 'September',
                                    10 => 'October',
                                    11 => 'November',
                                    12 => 'December'
                                    };  
                                    
                                    
           List<Budget_vs_Actual__c>budgetVsActualList=new List<Budget_vs_Actual__c>();
            for(Integer i=0;i<lstCSVLine2.size();i++){
                List<String> dateSplit=lstCSVLine2[i][1].split('-');
                String nameData=dateSplit[0] +' '+monthNames.get(Integer.valueOf(dateSplit[1]));
                List<Budget_vs_Actual__c> budgetVsActualList2=new list<Budget_vs_Actual__c>();
              
                budgetVsActualList2=[select id,Name from Budget_vs_Actual__c where name=:nameData and Customer_Sector__c=:customerSectorList[i].Id   limit 1];
              
                if(budgetVsActualList2.isEmpty()){
                    Budget_vs_Actual__c budgetVsActual=new 	Budget_vs_Actual__c();
                    budgetVsActual.Name=dateSplit[1] +' '+monthNames.get(Integer.valueOf(dateSplit[0]));
                    budgetVsActual.Customer_Sector__c=customerSectorList[i].Id;
                    budgetVsActual.Month__c=monthNamesFull.get(Integer.valueOf(dateSplit[1]));
                    String newDate=lstCSVLine2[i][1].replaceAll('-','/');
                    budgetVsActual.Start_Date__c=Date.parse(newDate);
                    budgetVsActual.End_Date__c=Date.parse(newDate);
                    String str=lstCSVLine2[i][4].replaceAll('\r','');
                 
                    budgetVsActual.Budget_Amount__c=Decimal.valueOf(lstCSVLine2[i][3].replaceAll('\n',''));
                    budgetVsActual.Actual_Amount__c=Decimal.valueOf(lstCSVLine2[i][4].replaceAll('\r',''));
                    budgetVsActualList.add(budgetVsActual);
                }
                else{
                    budgetVsActualList2[0].Budget_Amount__c=Decimal.valueOf(lstCSVLine2[i][3].replaceAll('\n',''));
                    budgetVsActualList2[0].Actual_Amount__c=Decimal.valueOf(lstCSVLine2[i][4].replaceAll('\r',''));
                    budgetVsActualList.add(budgetVsActualList2[0]);
                }
            }
            Database.upsert(budgetVsActualList,false);
        }
        System.debug('1 '+lstCSVLines.size()+'2 '+acntPlaneListtoBeInserted.size());
        //recordNotInserted=lstCSVLines.size()-acntPlaneListtoBeInserted.size();
        return wrapperList;
    }
    
    public class csvDataTableWrapper{
        @AuraEnabled public String CustomerName{get;set;}
       
        @AuraEnabled public String DOCDate{get;set;}
        @AuraEnabled public String ActivityCustomer{get;set;}
        @AuraEnabled public String Budget{get;set;}
        @AuraEnabled public String Actual{get;set;}
        @AuraEnabled public String CustomerNumber{get;set;}
    }
    
    
    
    
}
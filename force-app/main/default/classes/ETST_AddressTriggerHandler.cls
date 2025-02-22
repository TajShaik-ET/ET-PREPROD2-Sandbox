/*
* File Name:ETST_AddressTriggerHandler
* Author : Sagar Kambli
* CreatedDate : 10th May 2020
* Modification Purpose
* * 1. Sagar: Handler created to manage addresses on trigger
* * 2.
*/
public class ETST_AddressTriggerHandler {
    
    public static void updatePrimaryAddressForAccount(List<ETST_Address__c> addresses){
        Map<Id, List<ETST_Address__c>> customerMap = new Map<Id, List<ETST_Address__c>>();
        
        for(ETST_Address__c addr: addresses){
            
            if(addr.ET_Is_Primary__c && (addr.ET_Address_Type__c == ET_Common_Util.BILLTO || addr.ET_Address_Type__c == ET_Common_Util.SHIPTO)){
                if(customerMap.get(addr.Account__c) == null)
                    customerMap.put(addr.Account__c, new List<ETST_Address__c>{addr});
                else {
                    customerMap.get(addr.Account__c).add(addr);
                }    
            }
        }
        
        List<Account> customerList = [select id,BillingStreet, BillingCity, BillingState, BillingPostalCode, BillingCountry, ShippingStreet, 
                                      ShippingCity, ShippingState, ShippingPostalCode, 
                                      ShippingCountry from Account where Id in:customerMap.keyset()];
        
        List<Account> customerAddressUpdate = new List<Account>();                            
        
        for(Account customer: customerList){
            Id customerKey = customer.Id;
            if(customerMap.get(customerKey)!=null){
                for(ETST_Address__c addr: customerMap.get(customerKey)){
                    if(addr.ET_Address_Type__c == ET_Common_Util.BILLTO){
                        if(addr.ET_City__c!=null)
                            customer.BillingCity = addr.ET_City__c;
                        if(addr.ET_Line_1__c!=null)
                        {
                            string street = '';
                            street = addr.ET_Line_1__c;
                            customer.BillingStreet = addr.ET_Line_1__c;
                            if(addr.ET_Line_2__c!=null && addr.ET_Line_2__c!=''){
                                street += addr.ET_Line_2__c;
                            }
                            customer.BillingStreet = street;
                        }
                        if(addr.ET_Country__c!=null)
                        {
                            if(addr.ET_Country__c == 'AE')
                                customer.BillingCountry = 'UAE';
                            if(addr.ET_Country__c == 'SA')
                                customer.BillingCountry = 'Saudi Arabia';
                            if(addr.ET_Country__c == 'OM')
                                customer.BillingCountry = 'Oman';
                        }
                    }
                    
                    if(addr.ET_Address_Type__c == ET_Common_Util.SHIPTO){
                        if(addr.ET_City__c!=null)
                            customer.ShippingCity = addr.ET_City__c;
                        if(addr.ET_Line_1__c!=null)
                        {
                            string street = '';
                            street = addr.ET_Line_1__c;
                            customer.ShippingStreet = addr.ET_Line_1__c;
                            if(addr.ET_Line_2__c!=null && addr.ET_Line_2__c!=''){
                                street += addr.ET_Line_2__c;
                            }
                            customer.ShippingStreet = street;
                        }
                        if(addr.ET_Country__c!=null)
                        {
                            if(addr.ET_Country__c == 'AE')
                                customer.ShippingCountry = 'UAE';
                            if(addr.ET_Country__c == 'SA')
                                customer.ShippingCountry = 'Saudi Arabia';
                            if(addr.ET_Country__c == 'OM')
                                customer.ShippingCountry = 'Oman';
                        }
                    }
                }
                customerAddressUpdate.add(customer);
            }
        }
        
        if(customerAddressUpdate.size() > 0)
            update customerAddressUpdate;
    }
    
    public static void updatePrimaryAddressForAccountOnDelete(Map<Id,ETST_Address__c> oldAddressMap){
        Map<Id, List<ETST_Address__c>> customerMap = new Map<Id, List<ETST_Address__c>>();
        for(String addrKey: oldAddressMap.keyset()){
            ETST_Address__c del_Address = oldAddressMap.get(addrKey);
            if(del_Address.ET_Is_Primary__c && (del_Address.ET_Address_Type__c == ET_Common_Util.BILLTO || del_Address.ET_Address_Type__c == ET_Common_Util.SHIPTO)){
                if(customerMap.get(del_Address.Account__c) == null)
                    customerMap.put(del_Address.Account__c, new List<ETST_Address__c>{del_Address});
                else {
                    customerMap.get(del_Address.Account__c).add(del_Address);
                }  
            }
        }
        
        List<Account> customerList = [select id,BillingStreet, BillingCity, BillingState, BillingPostalCode, BillingCountry, ShippingStreet, 
                                      ShippingCity, ShippingState, ShippingPostalCode, 
                                      ShippingCountry from Account where Id in:customerMap.keyset()];
        
        List<Account> customerAddressUpdate = new List<Account>();                            
        for(Account customer: customerList){
            Id customerKey = customer.Id;
            if(customerMap.get(customerKey)!=null){
                for(ETST_Address__c addr: customerMap.get(customerKey)){
                    if(addr.ET_Address_Type__c == ET_Common_Util.BILLTO){
                        customer.BillingCity = '';
                        customer.BillingStreet = '';
                        customer.BillingCountry = '';
                        customer.BillingPostalCode = '';
                        customer.BillingState = '';
                    }
                    
                    if(addr.ET_Address_Type__c == ET_Common_Util.SHIPTO){
                        customer.ShippingCity = '';
                        customer.ShippingStreet = '';
                        customer.ShippingCountry = '';
                        customer.ShippingPostalCode = '';
                        customer.ShippingState = '';
                    }
                }
                customerAddressUpdate.add(customer);
            }
        }
        
        if(customerAddressUpdate.size() > 0)
            update customerAddressUpdate;
    }
    
}
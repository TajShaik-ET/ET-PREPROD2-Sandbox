/*
* File Name:ET_Vehicle_Iterable
* Author : Sagar Kambli
* CreatedDate :  20 May 20200
* Modification Purpose
* * 1. Sagar: Custom Iterator to iterate through all vehicle details.
* * 2.
*/ 
global class ET_Vehicle_Iterable implements Iterable<ET_ERPVehicle.XxetVehicleMasterDetMv>, Iterator<ET_ERPVehicle.XxetVehicleMasterDetMv>{ 
   
    List<ET_ERPVehicle.XxetVehicleMasterDetMv> vehicleList {get; set;} 
    Integer i {get; set;}
    Integer totalSize = 0; 
    
    public Iterator<ET_ERPVehicle.XxetVehicleMasterDetMv> iterator() { return this; }
    
    public ET_Vehicle_Iterable(List<ET_ERPVehicle.XxetVehicleMasterDetMv> vehicleList){ 
        this.vehicleList = vehicleList;
        i = 0; 
        totalSize = vehicleList.size();
    }   
    
    global boolean hasNext(){ 
        if(i >= vehicleList.size()) 
            return false; 
        else 
            return true; 
    }    
    
     global ET_ERPVehicle.XxetVehicleMasterDetMv next(){  
         if(i == totalSize){return null;}  i++;  return vehicleList[i-1];
     }
    
}
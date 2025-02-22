public class ET_MotoWrapperClass {
 
public List<EstimationSQLOutput> EstimationSQLOutput {get;set;}  
    
	public class EstimationSQLOutput  {
         
		public String internal_number{get;set;}
		public String estimate_no{get;set;}
		public String work_order_no{get;set;}
		public Integer service_no{get;set;}
		public String work_description{get;set;}
		public String current_status{get;set;}
		public String service_location{get;set;}
        public String estimator{get;set;}
		public decimal total_labor_charge{get;set;}
		public decimal total_material_charge{get;set;}
		public decimal total_other_charge{get;set;}
		public decimal net_amount{get;set;}
		public Decimal vat_amount{get;set;}
		public Decimal total_amount{get;set;}
		public String is_invoiced{get;set;}
		public String is_invoice_paid{get;set;}
		public String plate_number{get;set;}
        public String document;
	}
   
    public static ET_MotoWrapperClass parse(String json) {
        return (ET_MotoWrapperClass) System.JSON.deserialize(json, ET_MotoWrapperClass.class);
    }
	
	//public static ET_MotoWrapperClass parse(String json) {
		//return (ET_MotoWrapperClass) System.JSON.deserialize(json, ET_MotoWrapperClass.class);
	//}/
}
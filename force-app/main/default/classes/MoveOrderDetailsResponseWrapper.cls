public class MoveOrderDetailsResponseWrapper{
	public String Status;	//S
	public String Message;	//Move Order Found
	public cls_GetMoveOrderResponse GetMoveOrderResponse;
	public class cls_GetMoveOrderResponse {
		public cls_GetMoveOrderResponseDetail[] GetMoveOrderResponseDetail;
	}
	public class cls_GetMoveOrderResponseDetail {
		public String requestNumber;	//2282938
		public String moveOrderDescription;	//17607/17608/17609
		public Integer organizationId;	//345
		public String moveOrderTypeName;	//Requisition
		public String fromSubinventoryCode;	//DXB-QKS-W
		public String transactionTypeName;	//ET Trnsfr Used Tyres to Factory
		public String item;	//TU-165/65R14-SML
		public String itemDescription;	//USED TYRES - SMALL TYRES
		public cls_toSubinventoryCode toSubinventoryCode;
		public Integer quantity;	//8
		public Integer quantityDelivered;	//8
		public String moveOrderStatus;	//Approved
		public Integer createdBy;	//2407
		public String creationDate;	//2019-10-27T12:38:08.000+04:00
	}
	public class cls_toSubinventoryCode {
	}
	public static MoveOrderDetailsResponseWrapper parse(String json){
		return (MoveOrderDetailsResponseWrapper) System.JSON.deserialize(json, MoveOrderDetailsResponseWrapper.class);
	}
}
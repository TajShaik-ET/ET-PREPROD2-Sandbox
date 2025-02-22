@isTest
public class MoveOrderDetailsResponseWrapper_Test {
	public static testMethod void testParse() {
		String json='{'+
		'    "Status": "S",'+
		'    "Message": "Move Order Found",'+
		'    "GetMoveOrderResponse": {'+
		'        "GetMoveOrderResponseDetail": ['+
		'            {'+
		'                "requestNumber": "2282938",'+
		'                "moveOrderDescription": "17607/17608/17609",'+
		'                "organizationId": 345,'+
		'                "moveOrderTypeName": "Requisition",'+
		'                "fromSubinventoryCode": "DXB-QKS-W",'+
		'                "transactionTypeName": "ET Trnsfr Used Tyres to Factory",'+
		'                "item": "TU-165/65R14-SML",'+
		'                "itemDescription": "USED TYRES - SMALL TYRES",'+
		'                "toSubinventoryCode": null,'+
		'                "quantity": 8,'+
		'                "quantityDelivered": 8,'+
		'                "moveOrderStatus": "Approved",'+
		'                "createdBy": 2407,'+
		'                "creationDate": "2019-10-27T12:38:08.000+04:00"'+
		'            },'+
		'            {'+
		'                "requestNumber": "2282938",'+
		'                "moveOrderDescription": "17607/17608/17609",'+
		'                "organizationId": 345,'+
		'                "moveOrderTypeName": "Requisition",'+
		'                "fromSubinventoryCode": "DXB-QKS-W",'+
		'                "transactionTypeName": "ET Trnsfr Used Tyres to Factory",'+
		'                "item": "TU-175/65R14-SML",'+
		'                "itemDescription": "USED TYRES - SMALL TYRES",'+
		'                "toSubinventoryCode": null,'+
		'                "quantity": 13,'+
		'                "quantityDelivered": 13,'+
		'                "moveOrderStatus": "Approved",'+
		'                "createdBy": 2407,'+
		'                "creationDate": "2019-10-27T12:38:08.000+04:00"'+
		'            }'+
		'        ]'+
		'    }'+
		'}';
		MoveOrderDetailsResponseWrapper obj = MoveOrderDetailsResponseWrapper.parse(json);
		System.assert(obj != null);
	}
}
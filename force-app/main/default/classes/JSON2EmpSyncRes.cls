public class JSON2EmpSyncRes {

	public String Status;
	public String Message;

	
	public static JSON2EmpSyncRes parse(String json) {
		return (JSON2EmpSyncRes) System.JSON.deserialize(json, JSON2EmpSyncRes.class);
	}
}
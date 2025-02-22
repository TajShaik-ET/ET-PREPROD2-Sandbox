public class ETST_GoogleMap_Controller {
    public String latit{get;set;}
    public String longit{get;set;}
    public ETST_GoogleMap_Controller(){
      latit= apexpages.currentpage().getparameters().get('lat');
      longit= apexpages.currentpage().getparameters().get('long');

    }
}
({
    getParamsfromURL : function(component, event, helper){
        var url = new URL(window.location.href);
        var search_params = url.searchParams.get('id');
        alert(search_params);
    }
})
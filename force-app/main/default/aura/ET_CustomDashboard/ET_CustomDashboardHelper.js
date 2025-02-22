({
	/*createGraph : function(cmp, temp) {
        
        var dataMap = {"chartLabels": Object.keys(temp),
                       "chartData": Object.values(temp)
                       };
        
        var el = cmp.find('barChart').getElement();
        var ctx = el.getContext('2d');
        
        new Chart(ctx, {
            type: 'bar',
            data: {
                labels: dataMap.chartLabels,
                datasets: [
                    {
                        label: "Payments History",
                        backgroundColor: "rgba(153,255,51,0.5)",
                        data: dataMap.chartData
                    }
                ]
            }
        });
	},
    createLineGraph : function(cmp, temp) {
        
        var label = [];
        var firstValue = [];
        var secondValue = [];
        
        for(var a=0; a< temp.length; a++){
            console.debug(temp[a]["label"]);
            label.push(temp[a]["label"]);
            firstValue.push(temp[a]["firstValue"]);
            secondValue.push(temp[a]["secondValue"]);                     
        }    
        var el = cmp.find('lineChart').getElement();
        var ctx = el.getContext('2d');
        
        new Chart(ctx, {
            type: 'line',
            data: {
                    labels: label,
                    datasets: [{
                      label: 'USD Sent',
                      data: firstValue,
                      backgroundColor: "rgba(153,255,51,0.4)"
                    }, {
                      label: 'USD Recieved',
                      data: secondValue,
                      backgroundColor: "rgba(255,153,0,0.4)"
                    }]
                  }
        });
        
	}
    */
    casesBySchool:function(component, event, caseBySchoolVar){
        var labelset=[] ;
        var dataset=[] ;
        caseBySchoolVar.forEach(function(key) {
            labelset.push(key.label) ; 
            dataset.push(key.count) ; 
        });
        new Chart(document.getElementById("school-chart"), {
            type: 'pie',
            data: {
                labels:labelset,
                datasets: [{
                    label: "Count of Case",
                    backgroundColor: ["#3e95cd", "#8e5ea2","#3cba9f","#e8c3b9"],
                    data: dataset
                }]
            },
            options: {
                title: {
                    display: true,
                    text: 'Cases Per School'
                }
            }
        });
        
    },
    casesByStatus:function(component, event, caseByStatusVar){
        var labelset=[] ;
        var dataset=[] ;
        caseByStatusVar.forEach(function(key) {
            labelset.push(key.label) ; 
            dataset.push(key.count) ; 
        });
        new Chart(document.getElementById("status-chart"), {
            type: 'pie',
            data: {
                labels:labelset,
                datasets: [{
                    label: "Count of Case",
                    backgroundColor: ["#3e95cd", "#8e5ea2","#3cba9f","#e8c3b9"],
                    data: dataset
                }]
            },
            options: {
                title: {
                    display: true,
                    text: 'Total Cases by Status'
                }
            }
        });
        
    },
    casesByType:function(component, event, casesByType){
        var labelset=[] ;
        var dataset=[] ;
        casesByType.forEach(function(key) {
            labelset.push(key.label) ; 
            dataset.push(key.count) ; 
        });
        new Chart(document.getElementById("type-chart"), {
            type: 'pie',
            data: {
                labels:labelset,
                datasets: [{
                    label: "Count of Case",
                    backgroundColor: ["#3e95cd", "#8e5ea2","#3cba9f","#e8c3b9"],
                    data: dataset
                }]
            },
            options: {
                title: {
                    display: true,
                    text: 'Total Cases by Type'
                }
            }
        });
    }
})
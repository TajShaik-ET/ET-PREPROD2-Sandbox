({
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
        console.log('status>>>>>'+caseByStatusVar);
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
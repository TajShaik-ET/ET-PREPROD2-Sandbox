({
	  doInit: function(component, event, helper) {
          let recordId = component.get("v.recordId");
        if (!recordId) {
            console.error("No recordId found!");
            return;
        }
        // Detect if in Community or Internal Salesforce
        const urlString = window.location.href;
        let vfUrl;
        if (urlString.includes("my.site.com")) { // Community User
            const communityBaseURL = urlString.split('/s/')[0];
            vfUrl = `${communityBaseURL}/apex/DriverChecklistPDF?Id=${recordId}`;
        } else { // Internal Salesforce User
            vfUrl = `/apex/DriverChecklistPDF?Id=${recordId}`;
        }
        // Open the VF page in a new tab and trigger the print dialog
       
      //  let pdfWindow = window.open(vfUrl, "_Blank");
       const popupWindow = window.open(vfUrl, 'PDF Preview', 'width=700,height=500,scrollbars=yes,resizable=yes');
        setTimeout(() => {
            popupWindow.focus();
           // pdfWindow.print(); // Trigger print after the page loads
        }, 2000); // Delay to ensure the PDF is loaded before printing
        $A.get("e.force:closeQuickAction").fire();
    }
})
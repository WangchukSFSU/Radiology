
   
 //show saved report after form is entered
     function displayReportAfterReportSubmitted() {
     jq('#patientCompletedOrders').show();
     jq("#activeOrdersWithNoLinkBreadCrumb").hide();
     jq("#activeOrdersWithLinkBreadCrumb").show();
     jq("#orderDetailBreadCrumb").show();
     jq('#orderDetailDiv').empty();
     jq("#orderDetailDiv").show();
     jq("#activeOrderTableDiv").hide();
     var radiologyorderId = localStorage.getItem("radiologyorderId");
     continueOrderDetail(radiologyorderId);

     }



     //display order details when click on the active order
     function viewOrderDetail(el) {
     localStorage.clear();
     jq(el).addClass("highlight").css("background-color", "#CCCCCC");
     jq('#patientCompletedOrders').show();
     jq("#activeOrdersWithNoLinkBreadCrumb").hide();
     jq("#activeOrdersWithLinkBreadCrumb").show();
     jq("#orderDetailBreadCrumb").show();
     jq('#orderDetailDiv').empty();
     jq("#orderDetailDiv").show();
     jq("#activeOrderTableDiv").hide();
     //get the order id
     jq(el).addClass('selected').siblings().removeClass('selected');
     var value = jq(el).closest('tr').find('td:first').text();
     var orderId = parseInt(value, 10);
     continueOrderDetail(orderId);

     }

  
     
     //click cancel btn on the order detail page
     function cancelBtn() {
     location.reload();
     }

     //click cancel btn on the htmlform
     function CancelForm() {
     jq('#formDialogDiv').dialog('close');
     }

     //delete saved report
     function cancelReport() {
     jq("#reportDeletelDialogMessage").dialog("open");
     }

     //if click yes on the cancel report dialog box, continue with the cancellation
     function continueCancelReport() {
     var radiologyorderId = localStorage.getItem("radiologyorderId");
       jq.getJSON('${ ui.actionLink("CancelSavedReport") }', {
     'radiologyorderId': radiologyorderId
     })
     .error(function(xhr, status, err) {
     alert('AJAX error ' + err);
     })
     .success(function(ret) {
     jq('#orderDetailBreadCrumb').hide();
     jq('#activeOrdersWithLinkBreadCrumb').hide();
     jq('#activeOrdersWithNoLinkBreadCrumb').show();
     jq('#showReportsDiv').hide();

     jq("#patientCompletedOrders").hide();
     jq('.order').hide();
     jq('#orderDetailDiv').hide();
     jq('#CancelReportUpdatedDiv').show();
     jq('#CancelReportUpdatedDiv').empty();
     emr.successMessage("Report deleted successfully");
     jq("<h1></h1>").text("ACTIVE RADIOLOGY ORDERS").appendTo('#CancelReportUpdatedDiv');
     jq('#CancelReportUpdatedDiv').append('<table></table>');
     jq('#CancelReportUpdatedDiv table').attr('id', 'cancepReportUpdatedDatatable');
     var cancelReportUpdatedTable = jq('#CancelReportUpdatedDiv table');
     cancelReportUpdatedTable.append('<thead><tr><th>Order</th><th>Patient Name</th><th>MRN</th><th>OrderStartDate</th><th>OrderPriority</th><th>SavedReport</th></tr></thead><tbody>');
     for (var i = 0; i < ret.length; i++) {
     var studyname = ret[i].study.studyname;
     var dateCreated = ret[i].dateCreated;
     var urgency = ret[i].urgency;
     var patientName = ret[i].patient.personName;
     var patientIdentifier = ret[i].patient.patientIdentifier;
     var anOrderId = ret[i].orderId;
     var patientIdentifier = ret[i].patient.patientIdentifier.Identifier;
     var OrderencounterId = ret[i].study.studyReportSavedEncounterId;
     if (OrderencounterId) {
                       cancelReportUpdatedTable.append('<tr><td><a id="studyLinkId" href=' + studyname + ' class="studyLinkId" onclick="viewOrderDetail(this); return false;"><p style="display:none;">' + anOrderId + '</p>' + studyname + ' </a></td><td>' + patientName + '</td><td>' + patientIdentifier + '</td><td>' + dateCreated + '</td><td>' + urgency + '</td><td>Yes</td></tr>');
     } else {
                       cancelReportUpdatedTable.append('<tr><td><a id="studyLinkId" href=' + studyname + ' class="studyLinkId" onclick="viewOrderDetail(this); return false;"><p style="display:none;">' + anOrderId + '</p>' + studyname + ' </a></td><td>' + patientName + '</td><td>' + patientIdentifier + '</td><td>' + dateCreated + '</td><td>' + urgency + '</td><td>No</td></tr>');
     }
     }

      cancelReportUpdatedTable.append("</tbody>");
     jq('#cancepReportUpdatedDatatable').dataTable({
     "sPaginationType": "full_numbers",
     "bPaginate": true,
     "bAutoWidth": false,
     "bLengthChange": true,
     "bSort": true,
     "bJQueryUI": true,
     "iDisplayLength": 5,
     "aLengthMenu": [[5, 10, 25, 50, 75, -1], [5, 10, 25, 50, 75, "All"]],
     "aaSorting": [
     [3, "desc"]
     ] // Sort by first column descending,
     });
     })
     }

     //Submit report and order is no available in the active order list. This order is made avaiable to referring physician to view obs.
     function submitBtn() {
     var radiologyorderId = localStorage.getItem("radiologyorderId");
     jq.getJSON('${ ui.actionLink("updateActiveOrders") }', {
     'radiologyorderId': radiologyorderId
     })
     .error(function(xhr, status, err) {
     alert('AJAX error ' + err);
     })
     .success(function(ret) {
     jq('#orderDetailBreadCrumb').hide();
     jq('#activeOrdersWithLinkBreadCrumb').hide();
     jq('#activeOrdersWithNoLinkBreadCrumb').show();
     jq('#showReportsDiv').hide();
     jq("#patientCompletedOrders").hide();
     jq("#orderDetailDiv").hide();
     jq('#activeOrderTableDiv').show();
     jq('#activeOrderTableDiv').empty();
      emr.successMessage("Report submitted successfully");
     jq("<h1></h1>").text("ACTIVE RADIOLOGY ORDERS").appendTo('#activeOrderTableDiv');
     jq('#activeOrderTableDiv').append('<table></table>');
     jq('#activeOrderTableDiv table').attr('id', 'updateActiveOrderDatatable');
     var activeOrderTableRow = jq('#activeOrderTableDiv table');
     activeOrderTableRow.append('<thead><tr><th>Order</th><th>Patient Name</th><th>MRN</th><th>OrderStartDate</th><th>OrderPriority</th><th>SavedReport</th></tr></thead><tbody>');
     for (var i = 0; i < ret.length; i++) {
     var anOrderId = ret[i].orderId;
     var studyname = ret[i].study.studyname;
     var dateCreated = ret[i].dateCreated;
     var urgency = ret[i].urgency;
     var patientName = ret[i].patient.personName;
     var patientIdentifier = ret[i].patient.patientIdentifier.Identifier;
     var OrderencounterId = ret[i].study.studyReportSavedEncounterId;
     if (OrderencounterId) {
                       activeOrderTableRow.append('<tr><td><a id="studyLinkId" href=' + studyname + ' class="studyLinkId" onclick="viewOrderDetail(this); return false;"><p style="display:none;">' + anOrderId + '</p>' + studyname + ' </a></td><td>' + patientName + '</td><td>' + patientIdentifier + '</td><td>' + dateCreated + '</td><td>' + urgency + '</td><td>Yes</td></tr>');
     } else {
                       activeOrderTableRow.append('<tr><td><a id="studyLinkId" href=' + studyname + ' class="studyLinkId" onclick="viewOrderDetail(this); return false;"><p style="display:none;">' + anOrderId + '</p>' + studyname + ' </a></td><td>' + patientName + '</td><td>' + patientIdentifier + '</td><td>' + dateCreated + '</td><td>' + urgency + '</td><td>No</td></tr>');
     }
     }
     activeOrderTableRow.append("</tbody>");
     jq('#updateActiveOrderDatatable').dataTable({
     "sPaginationType": "full_numbers",
     "bPaginate": true,
     "bAutoWidth": false,
     "bLengthChange": true,
     "bSort": true,
     "bJQueryUI": true,
     "iDisplayLength": 5,
     "aLengthMenu": [[5, 10, 25, 50, 75, -1], [5, 10, 25, 50, 75, "All"]],
     "aaSorting": [
     [3, "desc"]
     ] // Sort by first column descending,
     });
     })
     }


     //view reports of the past orders
     function viewReport(OrderencounterId) {
       jq.getJSON('${ ui.actionLink("getEncounterIdObs") }', {
     'encounterId': OrderencounterId
     })
     .error(function(xhr, status, err) {
     alert('AJAX error ' + err);
     })
     .success(function(ret) {
     jq('#obsDialogBoxText').empty();
     jq('#obsDialogBoxText').append('<table></table>');
     jq('#obsDialogBoxText table').attr('id', 'obsDialogBoxTextDatatable');
     jq("#obsDialogBoxText table").addClass("obsDialogBoxTextclass");
     var obsDialogBoxTextTable = jq('#obsDialogBoxText table');
     obsDialogBoxTextTable.append('<thead><tr><th>Concept</th><th>Value Text/Numbers</th></tr></thead><tbody>');
     for (var i = 0; i < ret.length; i++) {
     var concept = ret[i].Concept;
     var valueText = ret[i].valueText;
     var valueNumeric = ret[i].valueNumeric;
     if(valueText) {
                   obsDialogBoxTextTable.append('<tr><td>' + concept + '</td><td>' + valueText + '</td></tr>');
     } else {
                   obsDialogBoxTextTable.append('<tr><td>' + concept + '</td><td>' + valueNumeric + '</td></tr>');
     }

     }
     obsDialogBoxTextTable.append("</tbody>");
     jq("#obsDialogBox").dialog("open");
     })
     }

     //display htmlform in the dialog box
     function openForm(obj) {
     jq("div#content").css({
     'font-size': 16
     });
     jq('input#closeAfterSubmission').next().empty();
     var formNameArray = JSON.parse(localStorage.getItem("formNameArray"));
     var formNameHtmlToDisplayArray = JSON.parse(localStorage.getItem("formNameHtmlToDisplayArray"));
     var patientIdArray = JSON.parse(localStorage.getItem("patientIdArray"));
     var HtmlFormIdArray = JSON.parse(localStorage.getItem("HtmlFormIdArray"));
     var radiologyorderId = localStorage.getItem("radiologyorderId");
     var returnUrl = localStorage.getItem("ReturnUrl");
     var formModifiedTimestamp = localStorage.getItem("FormModifiedTimestamp");
     var text = jq(obj).text();
     var firstColumnFormName = text.replace('Form', '');
     var firstColumnFormName = firstColumnFormName.replace('SavedReport', '');
     var formNameHtmlToDisplayt;
     var patientIdt;
     var HtmlFormIdt;

     //matches the form cicked and assign it for display
     for (var i = 0; i < formNameArray.length; i++) {

     if (jq.trim(firstColumnFormName) == formNameArray[i]) {
     formNameHtmlToDisplayt = formNameHtmlToDisplayArray[i];
     patientIdt = patientIdArray[i];
     HtmlFormIdt = HtmlFormIdArray[i];
     }
     }

     var returnUrl = localStorage.getItem("returnUrl");
     var formModifiedTimestamp = localStorage.getItem("formModifiedTimestamp");
     jq("#formDialogDiv").dialog("open");
     jq('#personId').val(patientIdt);
     jq('#htmlFormId').val(HtmlFormIdt);
     jq('#returnUrl').val(returnUrl);
     jq('#radiologyOrderId').val(radiologyorderId);
     jq('input#closeAfterSubmission').after(formNameHtmlToDisplayt);
     }




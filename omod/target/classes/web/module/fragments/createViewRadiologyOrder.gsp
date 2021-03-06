<%
ui.decorateWith("appui", "standardEmrPage")
ui.includeJavascript("uicommons", "datatables/jquery.dataTables.min.js")
ui.includeCss("uicommons", "datatables/dataTables_jui.css")
%>
<% ui.includeCss("radiology", "createViewRadiologyOrder.css") %>
<% ui.includeCss("radiology", "jquery-ui.css") %>
<%
def conceptStudyClass = config.requireStudyClass   
%>
<%
def conceptDiagnosisClass = config.requireDiagnosisClass  
%>   


<script type="text/javascript">
var locationName = "${ sessionContext.sessionLocation }"; 
var locationId = "${ sessionContext.sessionLocation.id }"; 

</script>

<script>
     jq = jQuery;
     jq(document).ready(function() {
     


     jq('input.priority').on('change', function() {
     jq('input.priority').not(this).prop('checked', false);  

     });

     jq("#manageOrderWithLinkBreadCrumb").hide();
     jq("#messagePatientBreadCrumb").hide();
     jq("#addOrderBreadCrumb").hide();
     jq("#orderDetailBreadCrumb").hide();
     jq("#addRadiologyOrderForm").hide();
     jq("#contactPatientDiv").hide();
     jq("#performedStatusInProgressOrder").hide();
     jq("#radiologyOrderDetailsDiv").hide();
     jq("#contactRadiologist").hide();
     jq("#performedStatusCompletedOrder").show();

     //performedStatus Completed Order  dataTable
     jq('#performedStatusCompletedOrderTable').dataTable({
     "sPaginationType": "full_numbers",
     "fnDrawCallback": function(){
     console.log("fnDrawCallback");
     },
     "bPaginate": true,
     "bAutoWidth": false,
     "bLengthChange": true,
     "bSort": true,
     "bJQueryUI": true,
     "iDisplayLength": 5,
     "aLengthMenu": [[5, 10, 25, 50, 75, -1], [5, 10, 25, 50, 75, "All"]],
     "aaSorting": [
     [4, "desc"]
     ] // Sort by first column descending,
     });
     //reload page if click on cancel btn
     jq("#cancelmessage").click(function() {
     location.reload();
     });



     jq( "#recipient" ).change(function() {

     var recipient = jq("#recipient").val();
     if(recipient == "") {

     jq("#recipientSpan").text("Please enter recipient");
     return false;
     }

     var domain = recipient.substr(recipient.length - 10);

     if(domain != "@localhost") {

     jq("#recipientSpan").text("Please enter correct domain");
     return false;
     }

     jq("#recipientSpan").text(" ");
     jq("#mailerror").text(" ");
     });


     jq( "#sender" ).change(function() {

     var sender = jq("#sender").val();
     if(sender == "") {

     jq("#senderSpan").text("Please enter sender");
     return false;
     }

     var domain = sender.substr(sender.length - 10);
   
     if(domain != "@localhost") {

     jq("#senderSpan").text("Please enter correct domain");
     return false;
     }

     jq("#senderSpan").text(" ");
     });


     jq( "#subject" ).change(function() {

     var subject = jq("#subject").val();
     if(subject == "") {

     jq("#subjectSpan").text("Please enter subject");
     return false;
     }

     jq("#subjectSpan").text(" ");
     });


   
 
        
              
      
    





     //contact patient
     jq("#sendEmail").click(function() {
     event.preventDefault();
     var recipient = jq("#recipient").val();
     var subject = jq("#subject").val();
     var message = jq("#message").val();
     var sender = jq("#sender").val();


     if(message == "") {

     jq("#messageSpan").text("Please enter message");
     return false;
     } else {
  jq("#messageSpan").text(" ");
     }



     jq.ajax({
     type: "POST",
            url: "${ ui.actionLink('contactPatient') }",
     data: {
     'recipient': recipient,
     'subject': subject,
     'message': message,
     'sender': sender
     },
     cache: false,
     error: function (xhr, ajaxOptions, thrownError) {
     jq("#mailerror").text("Please correct recipient address");
     return false;
     },
     success: function(data) {

     emr.successMessage("Email sent successfully");
     location.reload();
     }

     });
     });
     
     
     
     
     //cancel radiology order
     jq("#cancelForm").click(function() {
     location.reload();
     });

     //get in progress orders
     jq("#InProgressOrdersList").click(function() {
     jq("#performedStatusCompletedOrder").hide();
     jq("#performedStatusInProgressOrder").empty();
     jq("#performedStatusInProgressOrder").show();
     jq("#completedOrderHeader").children("h1").remove();
     jq("#radiologyOrderDetailsDiv").hide();
     var patient = jq("#patientId p").text();
     var patientId = patient.substr(patient.indexOf("#") + 1)
        jq.getJSON('${ ui.actionLink("getInProgressRadiologyOrders") }', {
     'patientId': patientId,
     })
     .error(function(xhr, status, err) {
     alert('AJAX error ' + err);
     })
     .success(function(ret) {
                jq("<h1></h1>").text("IN PROGRESS RADIOLOGY ORDERS").appendTo('#performedStatusInProgressOrder');
                jq('#performedStatusInProgressOrder').append('<table></table>');
     jq('#performedStatusInProgressOrder table').attr('id', 'patientCompletedOrdersDatatable');
     jq("#performedStatusInProgressOrder table").addClass("patientCompletedOrdersClass");
     var patientCompletedOrdersTable = jq('#performedStatusInProgressOrder table');
                patientCompletedOrdersTable.append('<thead><tr><th>Study</th><th>Provider</th><th>Priority</th><th> Diagnosis</th><th> StartDate</th><th> OrderStatus</th><th> Instructions </th><th> DeleteOrder</th></thead><tbody>');
     for (var i = 0; i < ret.length; i++) {
     var studyName = ret[i].study.studyname;
     var dateCreated = ret[i].dateCreated;
     var scheduledStatus = ret[i].study.scheduledStatus;
     var performedStatus = ret[i].study.performedStatus; 
     var orderId = ret[i].orderId; 
     var instructions = ret[i].instructions; 
     var orderdiagnosis = ret[i].orderdiagnosis;
      var provider = ret[i].orderer.name;
       var urgency = ret[i].urgency;
     if(scheduledStatus == 'STARTED') { 
                     patientCompletedOrdersTable.append('<tr><td> ' + studyName + ' </td><td> ' + provider + ' </td><td> ' + urgency + ' </td><td> ' + orderdiagnosis + '</td><td> ' + dateCreated + '</td><td> COMPLETED </td><td> ' + instructions + '</td><td><p style="display:none;">No</p></td></tr>');
     } else {
                    patientCompletedOrdersTable.append('<tr><td> ' + studyName + ' </td><td> ' + provider + ' </td><td> ' + urgency + ' </td><td> ' + orderdiagnosis + '</td><td> ' + dateCreated + '</td><td> ' + scheduledStatus + '</td><td> ' + instructions + '</td><td><a href=' + studyName + ' onclick="clickOrder(' + orderId + '); return false;" > <img  class="img-circle" src=" ${ ui.resourceLink ("/images/ic_cancel_2x.png") }"/> </a></td></tr>');
     }
     }
                patientCompletedOrdersTable.append("</tbody>");
     jq('#patientCompletedOrdersDatatable').DataTable({
     "sPaginationType": "full_numbers",
     "bPaginate": true,
     "bAutoWidth": false,
     "bLengthChange": true,
     "bSort": true,
     "bJQueryUI": true,
     "iDisplayLength": 5,
     "aLengthMenu": [[5, 10, 25, 50, 75, -1], [5, 10, 25, 50, 75, "All"]],
     "aaSorting": [
     [4, "desc"]
     ] // Sort by first column descending,
     });
     })
     });
     jq("#contactRadiologistDialogBox").dialog({
     autoOpen: false,
     modal: false,
     title: 'Contact Radiologist',
     width: 550,
     height: 350,
     });

     jq("#obsDialogBox").dialog({
     autoOpen: false,
     modal: false,
     title: 'View Report',
     width: 550,
     height: 500,
     buttons: {
     "Ok": function() {
     jq(this).dialog('close');
     }
     },
     });





     //get completed report ready orders
     jq("#CompletedOrdersList").click(function() {
     jq("#performedStatusCompletedOrder").show();
     jq("#performedStatusInProgressOrder").hide();
     jq("#completedOrderHeader").children("h1").remove();
     jq('#radiologyOrderDetailsDiv').children("h1").remove();
     jq('#radiologyOrderDetailsDiv').children("h1").remove();
     jq("#radiologyOrderDetailsDiv").hide();
     });

     jq( "#orderInstruction" ).change(function() {
     jq("#instructionSpan").text("");
     });

     //create new radiology order and save in database and Pacs
     jq("#submitForm").click(function() {
        var pat = "${patient}".split("#");
     var patient = pat[1];
     var studyOrder = jq("#studyTags").val();
     var diagnosisOrder = jq("#diagnosisTags").val();
     var instructionOrder = jq("#orderInstruction").val();
     if (jq('#routine').is(":checked"))
     {
     var priorityOrder = jq('#routine').val();
     } else {
     var priorityOrder = jq('#stat').val();
     }




     var emptyStudy = false; 
     var emptyDiagnosis = false; 
     var emptyInstruction = false; 
     var notMatchStudy = true;
     var notMatchDiagnosis = true;

     if(studyOrder == "") {

     jq("#studySpan").text("Please enter study");
     }
     if(diagnosisOrder == "") {
     jq("#diagnosisSpan").text("Please enter diagnosis");
     } 
     if(instructionOrder == "") {
     jq("#instructionSpan").text("Please add instruction");
     }





        jq.getJSON('${ ui.actionLink("placeRadiologyOrder") }', {
     'patient': patient,
     'study': studyOrder,
     'diagnosis': diagnosisOrder,
     'instruction': instructionOrder,
     'priority': priorityOrder,
     'locationName': locationName,
     'locationId' : locationId
     })

     .success(function(ret) {
     jq("#messagePatientBreadCrumb").hide();
     jq("#addOrderBreadCrumb").hide();
     jq("#orderDetailBreadCrumb").hide();
     jq("#completedOrderHeader").show();
     emr.successMessage("Radiology Order Submitted Successfully");
     jq("#addRadiologyOrderForm").hide();
     jq("#contactPatientDiv").hide();
     jq("#performedStatusInProgressOrder").hide();
     jq("#radiologyOrderDetailsDiv").hide();
     jq("#contactRadiologist").hide();
     jq("#performedStatusCompletedOrder").show();
     jq("#InProgressOrdersList").click();
     })
     });
     //create new radiology order
     jq("#addRadiologyOrderBtn").click(function() {
     jq("#completedOrderHeader").hide();
     jq("#performedStatusCompletedOrder").hide();
     jq("#contactPatientDiv").hide();
     jq("#performedStatusInProgressOrder").hide();
     jq("#radiologyOrderDetailsDiv").hide();
     jq("#addRadiologyOrderForm").show();
     jq("#studyTags").val('');
     jq("#diagnosisTags").val('');
     jq("#orderInstruction").val('');
     jq("#manageOrderWithNoLinkBreadCrumb").hide();
     jq("#manageOrderWithLinkBreadCrumb").show();
     jq("#messagePatientBreadCrumb").hide();
     jq("#addOrderBreadCrumb").show();
     jq("#orderDetailBreadCrumb").hide();
     });
     //message patient
     jq("#emailform").click(function() {
     jq("#performedStatusCompletedOrder").hide();
     jq("#performedStatusInProgressOrder").hide();
     jq("#radiologyOrderDetailsDiv").hide();
     jq("#contactPatientDiv").show();
     jq("#addRadiologyOrderForm").hide();
     jq("#contactRadiologist").hide();
     jq("#completedOrderHeader").hide();
     jq("#message").val('');
     jq("#manageOrderWithNoLinkBreadCrumb").hide();
     jq("#manageOrderWithLinkBreadCrumb").show();
     jq("#messagePatientBreadCrumb").show();
     jq("#addOrderBreadCrumb").hide();
     jq("#orderDetailBreadCrumb").hide();
     });

     //get order detail of the order
     jq("#performedStatusCompletedOrderTable").delegate("tbody tr", "click", function (event) {
     jq("#manageOrderWithNoLinkBreadCrumb").hide();
     jq("#manageOrderWithLinkBreadCrumb").show();
     jq("#messagePatientBreadCrumb").hide();
     jq("#addOrderBreadCrumb").hide();
     jq("#orderDetailBreadCrumb").show();
     //get the order id
     jq(this).addClass('selected').siblings().removeClass('selected');
     var value = jq(this).find('td:first').html();
        var splitvalue = value.split('>');     
        jq("#radiologyOrderDetailsDiv > h1").remove();
     jq("#radiologyOrderDetailsDiv").show();
     jq("#performedStatusCompletedOrder").hide();     
        jq("#completedOrderHeader > h1").remove();
     ordervalue = splitvalue[1];
     var orderId = ordervalue.substr(0, ordervalue.indexOf('<'));
     
     //var orderId = ordervalue.substr(0, 2);
     jq('#radiologyOrderDetailsTableId').empty();
     <% if (radiologyOrders) { %>
     <% radiologyOrders.each { anOrder -> %>
        var radiologyorderId = ${ anOrder.orderId };
     if (orderId == radiologyorderId) {
  
            var orderencounterId = ${ anOrder.study.studyReportSavedEncounterId };
          
            jq('#radiologyOrderDetailsDiv').append("<h1 class='order'  id= 'orderDetailHeading'>RADIOLOGY ORDER DETAILS -ReportReady Date :   ${ anOrder.study.reportCompletedDate }  </h1>");
     jq('#radiologyOrderDetailsDiv').append(jq('#radiologyOrderDetailsTableId'));
     localStorage.setItem("orderencounterId", orderencounterId);
     localStorage.setItem("orderId", orderId);

            jq('#radiologyOrderDetailsTableId').append('<thead><tr><th> Report</th><th> Radiologist</th><th> Instructions </th><th> Diagnosis</th><th> Study</th><th>ViewStudy</th><th> ContactRadiologist</th></tr></thead>');      
     <% if (oviyamStatus == "") { %>
                 jq('#radiologyOrderDetailsTableId').append('<tbody><tr><td><a onclick="ViewReport();"> Obs</a> </td><td> ${anOrder.study.studyReportRadiologist}</td><td> ${anOrder.instructions} </td><td> ${anOrder.orderdiagnosis}</td><td>${anOrder.study.studyname}</td><td><a id="studyLink" class="studyLink" target="_blank" href="${ dicomViewerWeasisUrladdress + "studyUID=" + anOrder.study.studyInstanceUid + "&patientID=" +  anOrder.patient.patientIdentifier }" >ViewStudy</a></td><td><a href="mailto:<indicate recipients address>?Subject=${subject}&body=StudyName%20:%20${anOrder.study.studyname}%0DPatientId%20:%20${anOrder.patient.patientIdentifier}%0DDiagnosis%20:%20${anOrder.orderdiagnosis}%0DInstruction%20:%20${anOrder.instructions}%0DDate%20Completed%20:%20${anOrder.study.reportCompletedDate}" target="_top">ContactRadiologist</a></td></tr></tbody>');
     <% } %>
     <% if (weasisStatus == null) { %>
                 jq('#radiologyOrderDetailsTableId').append('<tbody><tr><td><a onclick="ViewReport();"> Obs</a> </td><td> ${anOrder.study.studyReportRadiologist}</td><td> ${anOrder.instructions} </td><td> ${anOrder.orderdiagnosis}</td><td>${anOrder.study.studyname}</td><td><a id="studyLink" class="studyLink" target="_blank" href="${ dicomViewerUrladdress + "studyUID=" + anOrder.study.studyInstanceUid + "&patientID=" +  anOrder.patient.patientIdentifier }" >ViewStudy</a></td><td><a href="mailto:<indicate recipients address>?Subject=${subject}&body=StudyName%20:%20${anOrder.study.studyname}%0DPatientId%20:%20${anOrder.patient.patientIdentifier}%0DDiagnosis%20:%20${anOrder.orderdiagnosis}%0DInstruction%20:%20${anOrder.instructions}%0DDate%20Completed%20:%20${anOrder.study.reportCompletedDate}" target="_top">ContactRadiologist</a></td></tr></tbody>');
     <% } %>
     <% if ((weasisStatus != null) && (oviyamStatus != "")) { %>
                 jq('#radiologyOrderDetailsTableId').append('<tbody><tr><td><a onclick="ViewReport();"> Obs</a> </td><td> ${anOrder.study.studyReportRadiologist}</td><td> ${anOrder.instructions} </td><td> ${anOrder.orderdiagnosis}</td><td>${anOrder.study.studyname}</td><td><a id="studyLink" class="studyLink" target="_blank" href="${ dicomViewerUrladdress + "studyUID=" + anOrder.study.studyInstanceUid + "&patientID=" +  anOrder.patient.patientIdentifier }" >Oviyam</a><br><a id="studyLink" class="studyLink" target="_blank" href="${ dicomViewerWeasisUrladdress + "studyUID=" + "1.3.6.1.4.1.5962.1.1.0.0.0.1168612284.20369.0.1" + "&patientID=" +  "TEST2351267" }" >Weasis</a></td><td><a href="mailto:<indicate recipients address>?Subject=${subject}&body=StudyName%20:%20${anOrder.study.studyname}%0DPatientId%20:%20${anOrder.patient.patientIdentifier}%0DDiagnosis%20:%20${anOrder.orderdiagnosis}%0DInstruction%20:%20${anOrder.instructions}%0DDate%20Completed%20:%20${anOrder.study.reportCompletedDate}" target="_top">ContactRadiologist</a></td></tr></tbody>');

     <% } %> 
     }
     <% } %>
     <% } %>
     });
     //clear radiologist message
     jq("#clearMessage").click(function() {
     jq('#contactRadiologistDialogBox').dialog('close');
     });

     
     
     
      jq( "#recipientRadio" ).change(function() {
   
      
        var recipient = jq("#recipientRadio").val();
     if(recipient == "") {

     jq("#recipientSpanRadio").text("Please enter recipient");
     return false;
     }
     
      var domain = recipient.substr(recipient.length - 10);

     if(domain != "@localhost") {

     jq("#recipientSpanRadio").text("Please enter correct domain");
     return false;
     }
     
        jq("#recipientSpanRadio").text(" ");
     jq("#mailerrorradio").text(" ");
     
      
      });
     
          jq( "#senderRadio" ).change(function() {

     var sender = jq("#senderRadio").val();
     if(sender == "") {

     jq("#senderSpanRadio").text("Please enter sender");
     return false;
     }

     var domain = sender.substr(sender.length - 10);
   
     if(domain != "@localhost") {

     jq("#senderSpanRadio").text("Please enter correct domain");
     return false;
     }

     jq("#senderSpanRadio").text(" ");
     });


     jq( "#subjectRadio" ).change(function() {

     var subject = jq("#subjectRadio").val();
     if(subject == "") {

     jq("#subjectSpanRadio").text("Please enter subject");
     return false;
     }

     jq("#subjectSpanRadio").text(" ");
     });
     
     
     
     //send email to radiologist
     jq("#sendEmailRadiologist").click(function() {
     
     event.preventDefault();
     
         var recipient = jq("#recipientRadio").val();
     var subject = jq("#subjectRadio").val();
   
     var sender = jq("#senderRadio").val();
     var message = jq("#messageRadiologist").val();



     jq.ajax({
     type: "POST",
            url: "${ ui.actionLink('contactRadiologist') }",
     data: {
     'recipient': recipient,
     'subject': subject,
     'message': message,
     'sender': sender
     },
     cache: false,
      error: function (xhr, ajaxOptions, thrownError) {
     jq("#mailerrorradio").text("Please correct recipient address");
     return false;
     },
     success: function(data) {
     jq('#contactRadiologistDialogBox').dialog('close');
     emr.successMessage("Email sent successfully");
      location.reload();
     }
     });
     });
     });
     //click any active order
     function clickOrder(el) {
     jq.getJSON('${ ui.actionLink("deleteOrder") }', {
     'orderId': el
     })
     .error(function(xhr, status, err) {
     alert('AJAX error ' + err);
     })
     .success(function(ret) {
     emr.successMessage("Deleted order successfully");
     jq("#InProgressOrdersList").click();

     })

     }
     //view report based on the report encounterId in the dialog box
     function ViewReport() {
     var orderencounterId = localStorage.getItem("orderencounterId");
    
    jq.getJSON('${ ui.actionLink("getEncounterIdObs") }', {
     'encounterId': orderencounterId
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
     var loopOnce = true;

     for (var i = 0; i < (ret.length-1); i++) {
     var concept = ret[i].Concept;
     var valueText = ret[i].valueText;
     var valueNumeric = ret[i].valueNumeric;
     var obsLocation = ret[i].Encounter.Location;
     var obsDateTime = ret[i].Encounter.EncounterDatetime;
     var obsGivenName = ret[i].Encounter.Provider.PersonName;



     if(loopOnce) {

                obsDialogBoxTextTable.append('<tr><td>Location</td><td>' + obsLocation + '</td></tr>');
                obsDialogBoxTextTable.append('<tr><td>Date</td><td>' + obsDateTime + '</td></tr>');
                obsDialogBoxTextTable.append('<tr><td>Provider</td><td>' + obsGivenName + '</td></tr>');
     loopOnce = false;
     }
     if(valueText) {
                obsDialogBoxTextTable.append('<tr><td>' + concept + '</td><td style="white-space:pre-wrap">' + valueText + '</textarea></td></tr>');
     } else {
                obsDialogBoxTextTable.append('<tr><td>' + concept + '</td><td style="white-space:pre-wrap">' + valueNumeric + '</td></tr>');
     }
     }
            obsDialogBoxTextTable.append("</tbody>");
     jq("#obsDialogBox").dialog("open");
     })
     }
     //autofill the radiologist email with the patient and order info
     function contactRadiologist() {
     jq("#contactRadiologist").show();
     var orderId = localStorage.getItem("orderId");
     jq('#messageRadiologist').val('foobar');
     <% radiologyOrders.each { anOrder -> %>
    var radiologyorderId = ${ anOrder.orderId };
     if (orderId == radiologyorderId) {
     jq('#messageRadiologist').val('StudyName  :');
        jq('#messageRadiologist').val(jq('#messageRadiologist').val() + '${anOrder.study.studyname}');
     jq('#messageRadiologist').val(jq('#messageRadiologist').val() + "\\r");
     jq('#messageRadiologist').val(jq('#messageRadiologist').val() + 'PatientId   :');
        jq('#messageRadiologist').val(jq('#messageRadiologist').val() + '${anOrder.patient.patientIdentifier}');
     jq('#messageRadiologist').val(jq('#messageRadiologist').val() + "\\r");
     jq('#messageRadiologist').val(jq('#messageRadiologist').val() + 'Diagnosis   :');
        jq('#messageRadiologist').val(jq('#messageRadiologist').val() + '${anOrder.orderdiagnosis}');
     jq('#messageRadiologist').val(jq('#messageRadiologist').val() + "\\r");
     jq('#messageRadiologist').val(jq('#messageRadiologist').val() + 'Instruction   :');
        jq('#messageRadiologist').val(jq('#messageRadiologist').val() + '${anOrder.instructions}');
     }
     <% } %>
     jq("#contactRadiologistDialogBox").dialog("open");
     }
</script>
<script>
     jq(function() {
     //get study list for autocomlete feature
     jq("#studyTags").autocomplete({
     source: function(request, response) {
     var results = [];
                jq.getJSON('${ ui.actionLink("getStudyAutocomplete") }', {
     'query': request.term,
     'conceptStudyClass': "<%= conceptStudyClass %>"
     })
     .success(function(data) {
     for (index in data) {
     var item = data[index];
     results.push(item.name);
     }
     if(results.length == 0) {
     jq("#studySpan").text("Please select study from list");

     jq('input#submitForm[type="button"]').attr('disabled','disabled');

     } else {
     response(results); 

     jq('input#submitForm[type="button"]').removeAttr('disabled');


     }
     })
     .error(function(xhr, status, err) {
     alert('AJAX error ' + err);
     });
     },
     select: function(event, ui) { 

     if (ui.item) {

     jq("#studySpan").text("");
     jq('input#submitForm[type="button"]').removeAttr('disabled');

     } 

     },








     })
     //get diagnosis list for autocomlete feature
     jq("#diagnosisTags").autocomplete({
     source: function(request, response) {
     var results = [];
                jq.getJSON('${ ui.actionLink("getDiagnosisAutocomplete") }', {
     'query': request.term,
     'conceptDiagnosisClass': "<%= conceptDiagnosisClass %>"
     })
     .success(function(data) {
     for (index in data) {
     var item = data[index];
     results.push(item.name);
     }
     if(results.length == 0) {
     jq("#diagnosisSpan").text("Please select diagnosis from list");

     jq('input#submitForm[type="button"]').attr('disabled','disabled');

     } else {
     response(results); 

     jq('input#submitForm[type="button"]').removeAttr('disabled');


     }
     })
     .error(function(xhr, status, err) {
     alert('AJAX error ' + err);
     });
     },
     select: function(event, ui) { 

     if (ui.item) {

     jq("#diagnosisSpan").text("");
     jq('input#submitForm[type="button"]').removeAttr('disabled');

     } 

     }


     })
     });
</script>

<!-- breadcrumbs -->
<div class="breadcrumbradiologyorder">
     <ul id="breadcrumbs" class="radiologyorderbreadcrumb">
          <li>
               <a href="/openmrs/index.htm">    
                    <i class="icon-home small"></i>  
               </a>       
          </li>
          <li id="patientNameBreadCrumb">  
               <i class="icon-chevron-right link"></i>
               <a href="/openmrs/coreapps/clinicianfacing/patient.page?patientId=${patient.person.uuid}&">    
                    <i >${patient.familyName + ', ' + patient.givenName}</i>  
               </a> 
          </li>
          <li id="manageOrderWithNoLinkBreadCrumb">  
               <i class="icon-chevron-right link"></i>
               Manage Radiology Order         
          </li>
          <li id="manageOrderWithLinkBreadCrumb">
               <i class="icon-chevron-right link"></i>
               <a href="/openmrs/radiology/referringPhysician.page?patientId=${patient.person.uuid}&returnUrl="> 
                    Manage Radiology Order
               </a> 
          </li>
          <li id="messagePatientBreadCrumb">  
               <i class="icon-chevron-right link"></i>
               Message Patient
          </li>
          <li id="addOrderBreadCrumb">  
               <i class="icon-chevron-right link"></i>
               Add Radiology Order
          </li>
          <li id="orderDetailBreadCrumb">  
               <i class="icon-chevron-right link"></i>
               Radiology Order Detail
          </li>
     </ul>
</div>
<!-- completed radiology order table header -->
<div id="completedOrderDiv">
     <div id="completedOrderHeader" class="performedStatusesContainer">
          <span class="left"><button type="button" id="CompletedOrdersList">ReportReady</button></span>
          <span class="left"><button type="button" id="InProgressOrdersList">InProgress</button></span>
          <span class="right"><button type="button" id="addRadiologyOrderBtn">Add Radiology Order</button></span>
        
</span>
     </div>
 <!-- completed radiology order table -->
     <div id="performedStatusCompletedOrder">
          <h1>CLICK REPORT READY RADIOLOGY ORDERS TO VIEW OBS</h1>
          <table id="performedStatusCompletedOrderTable">
               <thead>
                    <tr>
                         <th>Study</th>
                         <th>Diagnosis</th>
                         <th>Instructions</th>
                         <th>Radiologist</th>
                         <th>OrderCompletedDate</th>
                    </tr>
               </thead>
               <tbody>
                    <% radiologyOrders.each { anOrder -> %>
                    <tr>
                         <td> <p style="display:none;">${ anOrder.orderId }</p>
                              ${anOrder.study.studyname}</td>
                         <td> ${anOrder.orderdiagnosis}</td> 
                         <td> ${anOrder.instructions}</td>
                        <td> ${anOrder.study.studyReportRadiologist}</td>
                         <td>${ ui.format(anOrder.study.reportCompletedDate) } </td>
                    </tr>
                    <% } %>  
               </tbody>
          </table>
     </div>
</div>
<!-- in progress radiology order table -->
<div id="performedStatusInProgressOrder">
</div>


<!-- radiology order detail table -->
<div id = "radiologyOrderDetailsDiv">
     <table id="radiologyOrderDetailsTableId">
     </table>
</div>

<!-- add radiology order -->
<div id="addRadiologyOrderForm">
     <h2> ADD RADIOLOGY ORDER</h2>
     <div class="studyfieldclass">
          <label for="tags" class="formLabel">Study </label>
          <input id="studyTags"><span id="studySpan" class="formSpan"></span>
     </div>

     <div class="fieldclass">
          <label for="tags" class="formLabel">Diagnosis </label>
          <input id="diagnosisTags"><span id="diagnosisSpan" class="formSpan"></span>
     </div>

     <div class="fieldclass"><label class="formLabel">Instruction </label>
          <textarea  name="orderInstruction" id="orderInstruction" rows="1" cols="50">  </textarea><span id="instructionSpan" class="formSpan"></span>
     </div>

     <div class="fieldclass"><label >Priority </label>


          <input type="checkbox"  class ="priority" name ="priority" id= "routine" value="ROUTINE">ROUTINE
          <input type="checkbox" class = "priority" name ="priority" id="stat" value="STAT" checked> STAT

     </div>
     <input class="fields" id="submitForm" type="button" value="Submit" />
     <input class="fields" id="cancelForm" type="button" value="Cancel" />
</div>
<!-- obs dialog box -->
<div id="obsDialogBox" title="View Obs" style="display:none;">
     <div id="obsDialogBoxText" width="550" height="350"></div>
</div>





<div id="patientId">
     <p style="display:none;">${ patient }</p>
</div>
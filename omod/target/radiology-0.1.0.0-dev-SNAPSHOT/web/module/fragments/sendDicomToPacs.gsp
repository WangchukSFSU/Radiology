<% ui.includeCss("radiology", "sendDicomToPacs.css") %>
<% ui.includeCss("radiology", "jquery-ui.css") %>


<script>
     jq = jQuery;
     jq(document).ready(function() {

     jq('#sendImageToPACLinkBreadCrumb').hide();
     jq('#sendDicomToPACBreadCrumb').hide();
     //active orders datatable
     jq('#inProgressRadiologyOrderTable').dataTable({
     "sPaginationType": "full_numbers",
     "bPaginate": true,
     "bAutoWidth": false,
     "bLengthChange": true,
     "bSort": true,
     "bJQueryUI": true,
     "iDisplayLength": 5,
     "aLengthMenu": [[5, 10, 25, 50, 75, -1], [5, 10, 25, 50, 75, "All"]],
     "aaSorting": [
     [1, "desc"]
     ] // Sort by first column descending,

     });

     });

     //click any active order
     function clickOrder(el) {
     jq(el).addClass("highlight").css("background-color", "#CCCCCC");
     jq('#sendDicomToPACBreadCrumb').show();
     jq('#sendImageToPACLinkBreadCrumb').show();
     jq('#sendImageToPACNoLinkBreadCrumb').hide();
     //get the order id
     jq(el).addClass('selected').siblings().removeClass('selected');
     var value = jq(el).closest('tr').find('td:first').text();
     var orderId = parseInt(value, 10);
     jq("#inProgressRadiologyOrderDiv").hide();
     var splitvalue = value.split('');
     ordervalue = splitvalue[1];

     <% inProgressRadiologyOrders.each { anOrder -> %>
        var radiologyorderId = ${ anOrder.orderId };
     if (orderId == radiologyorderId) {
     localStorage.setItem("radiologyorderId", orderId);
     jq('#tableDiv').empty();
     //create dicom table
     jq('#tableDiv').append('<table></table>');
     jq('#tableDiv table').attr('id', 'tableId');
     jq("#tableDiv table").addClass("tableClass");
     var tableRow = jq('#tableDiv').children();
     tableRow.append('<thead><tr><th>Study/Associated Files</th><th>Start Date</th><th>PatientName</th><th>PatientId</th></tr></thead><tbody>');

    tableRow.append('<tr><td>${anOrder.study.studyname}</td><td>${anOrder.dateCreated}</td><td>${anOrder.patient.person.personName}</td><td>${ anOrder.patient.patientIdentifier }</td></tr>');

     <% dicomFolderNameFiles.each { hm -> %> 
     <% patientA = "${ anOrder.patient.patientIdentifier }" %>
     <% patientB = hm.key %>
     <% if (patientA == patientB) { %>
     <% hm.value.each { dicom -> %>
  tableRow.append('<tr><td style="text-indent: 50px;"> ${dicom}</td></tr>');
     <% } %> 
     <% } %> 
 <% } %> 

            tableRow.append('<tr>  <td> <a href="javascript: void(0)" id="linkActButton" onclick="sendDicomFiles(); return false;">Send</a></td></tr>');
            tableRow.append("</tbody>");


     }

     <% } %>

     }

     //send dicom files
     function sendDicomFiles() {
     var radiologyorderId = localStorage.getItem("radiologyorderId");
        jq.getJSON('${ ui.actionLink("updateActiveOrders") }', {
     'radiologyorderId': radiologyorderId
     })
     .error(function(xhr, status, err) {
     alert('AJAX error ' + err);
     })
     .success(function(ret) {
     jq('#sendDicomToPACBreadCrumb').hide();
     jq('#sendImageToPACLinkBreadCrumb').hide();
     jq('#sendImageToPACNoLinkBreadCrumb').show();
     jq('#tableDiv').empty();
     //dicom files send to PACS and update the active orders
               // jq("<h1></h1>").text("dicom files(s) sent successfully").appendTo('#tableDiv');
     emr.successMessage("dicom files(s) sent successfull");
                jq("<h1></h1>").text("CLICK RADIOLOGY ORDER TO SEND IMAGE TO PAC").appendTo('#tableDiv');
                jq('#tableDiv').append('<table></table>');
     jq('#tableDiv table').attr('id', 'updateActiveOrderDatatable');
     jq("#tableDiv table").addClass("updateActiveOrderTableClass");
     var tableRow = jq('#tableDiv table');
                tableRow.append('<thead><tr><th>PatientName</th><th>Order</th><th>OrderStartDate</th><th>OrderPriority</th><th>PatientID</th></tr></thead><tbody>');
     for (var i = 0; i < ret.length; i++) {
     var anOrderId = ret[i].orderId;
     var studyname = ret[i].study.studyname;
     var dateCreated = ret[i].dateCreated;
     var urgency = ret[i].urgency;
     var personName = ret[i].patient.person.personName;
     var patientIdentifier = ret[i].patient.patientIdentifier.Identifier;

     tableRow.append('<tr><td>'+ personName +'</td><td><a id="studyNameLink" href=' + studyname + ' class="studyNameLink" onclick="clickOrder(this); return false;" ><p style="display:none;">' + anOrderId + '</p>' + studyname + ' </a></td><td>' + dateCreated + '</td><td>' + urgency + '</td><td>'+ patientIdentifier +'</td></tr>');

     }

                tableRow.append("</tbody>");
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
     [1, "desc"]
     ] // Sort by first column descending,

     });

     })

     }


</script>
<!-- technician breadcrumbs -->
<div class="breadcrumbsactiveorders">
     <ul id="breadcrumbs">
          <li>
               <a href="/openmrs/index.htm">    
                    <i class="icon-home small"></i>  
               </a>       
          </li>
          <li id="sendImageToPACLinkBreadCrumb">
               <i class="icon-chevron-right link"></i> 
               <a href='/openmrs/radiology/technician.page'> RadiologyOrdersToSendImageToPAC</a>         
          </li>
          <li id="sendImageToPACNoLinkBreadCrumb">  
               <i class="icon-chevron-right link"></i> 
               RadiologyOrdersToSendImageToPAC 
          </li>
          <li id="sendDicomToPACBreadCrumb">  
               <i class="icon-chevron-right link"></i> 
               SendDicomToPAC 
          </li>
     </ul>
</div>
<!-- Active radiology orders -->
<div id="inProgressRadiologyOrderDiv">
     <h1>CLICK RADIOLOGY ORDER TO SEND IMAGE TO PAC</h1>
     <table id="inProgressRadiologyOrderTable">
          <thead>
               <tr>
                    <th>PatientName</th>
                    <th>Order</th>
                    <th>OrderStartDate</th>
                    <th>OrderPriority</th>
                    <th>PatientID</th>

               </tr>
          </thead>
          <tbody>
               <% inProgressRadiologyOrders.each { anOrder -> %>
               <tr>
                    <td><p style="display:none;">${ anOrder.orderId }</p> ${ anOrder.patient.person.personName }</td>
                    <td><a id="studyNameLink" href='+ studyname +' class="studyNameLink" onclick="clickOrder(this); return false;"><p style="display:none;">${ anOrder.orderId }</p>
                              ${anOrder.study.studyname}</a></td>
                    <td>${ anOrder.dateCreated } </td>
                    <td>${ anOrder.urgency }</td>
                    <td>${ anOrder.patient.patientIdentifier }</td>

               </tr>
               <% } %>  
          </tbody>
     </table>
</div>

<!-- dicom files table -->
<div id = "tableDiv">
</div>





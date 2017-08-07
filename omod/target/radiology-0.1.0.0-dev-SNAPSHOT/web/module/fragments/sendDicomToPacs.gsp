<% ui.includeCss("radiology", "sendDicomToPacs.css") %>
<% ui.includeCss("radiology", "jquery-ui.css") %>


<script>
     jq = jQuery;
     jq(document).ready(function() {

     jq("#file-form").submit(function(event){
     event.preventDefault();
     var form = document.getElementById('file-form');
     var fileSelect = document.getElementById('file-select');
     var uploadButton = document.getElementById('upload-button');

     jq('#inputSpan').text(" ");

     var files = fileSelect.files;
     var formData = new FormData();

     if (files.length <= 0) { 
     jq('#inputSpan').text("File is not selected");
     return false;

     } 

     // Loop through each of the selected files.
     for (var i = 0; i < files.length; i++) {
     var file = files[i];

     var extension = (files[i].name).split('.').pop().toUpperCase();
     if (extension != "DCM") {
     jq('#inputSpan').text("Select dcm files only");
     return false;
     }

     // Add the file to the request.
     formData.append('photos[]', file, file.name);
     }

     var other_data = jq('form').serialize();
     // Set up the request.
     var xhr = new XMLHttpRequest(); 
     // Open the connection.
        xhr.open('POST', '${ ui.actionLink("sendDicomToPAC") }' + other_data, true);

     // Set up a handler for when the request finishes.
     xhr.onload = function () {
     if (xhr.status === 200) {
     // File(s) uploaded.
     emr.successMessage("dicom files(s) sent successfull");
     location.reload();
     } else {
     //alert('An error occurred!');
     }
     };
     // Send the Data.
     xhr.send(formData);

     });

     //active orders datatable
     jq('#inProgressRadiologyOrderTable').dataTable({
     "iDisplayLength": 5,
     "sPaginationType": "full_numbers",
     "bPaginate": true,
     "bAutoWidth": false,
     "bLengthChange": false,
     "bSort": true,
     "bJQueryUI": true,
     "aLengthMenu": [[5, 10, 25, 50, 75, -1], [5, 10, 25, 50, 75, "All"]],
     "aaSorting": [
     [2, "desc"]
     ] // Sort by first column descending,

     });

     jq('#sendImageToPACLinkBreadCrumb').hide();
     jq('#sendDicomToPACBreadCrumb').hide();

     });

     function updateList(){
     jq('#inputSpan').text(" ");
     var input = document.getElementById('file-select');
     var output = document.getElementById('inputFile');
     output.innerHTML = '<ul>';
     for (var i = 0; i < input.files.length; ++i) {

      output.innerHTML += '<li>' + input.files.item(i).name + '</li>';

     var extension = (input.files.item(i).name).split('.').pop().toUpperCase();
     if (extension != "DCM") {
     jq('#inputSpan').text("Select dcm files only");
     return false;
     } 


     }
  output.innerHTML += '</ul>';

     }



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
     tableRow.append('<thead><tr><th>Study/Associated Files</th><th>Start Date</th><th>PatientName</th><th>PatientId</th><th>Diagnosis</th><th>Instructions</th></tr></thead><tbody>');

    tableRow.append('<tr><td>${anOrder.study.studyname}</td><td>${anOrder.dateCreated}</td><td>${anOrder.patient.person.personName}</td><td>${ anOrder.patient.patientIdentifier }</td><td>${anOrder.orderdiagnosis}</td><td>${anOrder.instructions}</td></tr>');
    tableRow.append('<tr><td style="text-indent: 50px;"> <input type="file" id="file-select" name="photos[]" multiple onchange="updateList()"/> <span id="inputSpan"></span><span id="inputFile" style = "display:inline;"></span><input type="hidden" value='+ ${ anOrder.orderId } +' name="userid" /> </td></tr>');
    tableRow.append('<tr>  <td>   <button type="submit" id="upload-button">Send</button></td></tr>');

    tableRow.append("</tbody>");


     }

     <% } %>

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


<form id="file-form" method="POST" enctype="multipart/form-data">
  <!-- dicom files table -->
     <div id = "tableDiv">
     </div>
</form>


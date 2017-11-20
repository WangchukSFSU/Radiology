<%
ui.decorateWith("appui", "standardEmrPage")
ui.includeJavascript("uicommons", "datatables/jquery.dataTables.min.js")
ui.includeCss("uicommons", "datatables/dataTables_jui.css")
%>

<% ui.includeCss("radiology", "viewOrderDetail.css") %>
<% ui.includeCss("radiology", "jquery-ui.css") %>

<script>
     jq = jQuery;
     jq(document).ready(function() {

    jq('#findPatientLinkBreadCrumb').show();
     jq('#findPatientNoLinkBreadCrumb').hide();
     jq('#patientOrderDetailBreadCrumb').show();
 
     
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
     
     })


</script>

<!-- breadcrumbs -->
<div class="breadcrumbsactiveorders">
     <ul id="breadcrumbs">
          <li>
               <a href="/openmrs/index.htm">    
                    <i class="icon-home small"></i>  
               </a>       
          </li>
          <li id="findPatientLinkBreadCrumb">
               <i class="icon-chevron-right link"></i> 
               <a href='/openmrs/radiology/findRadiologyOrdersForPatient.page'> FindPatient</a>         
          </li>
          <li id="findPatientNoLinkBreadCrumb">  
               <i class="icon-chevron-right link"></i> 
               FindPatient 
          </li>
          <li id="patientOrderDetailBreadCrumb">  
               <i class="icon-chevron-right link"></i> 
               PatientOrderDetail 
          </li>
     </ul>
</div>

<!-- Active radiology orders -->
<div id="inProgressRadiologyOrderDiv">
     <h1>Radiology Order Detail for : ${patientName}</h1>
     <table id="inProgressRadiologyOrderTable">
          <thead>
               <tr>
                    
                    <th>Study</th>
                    <th>OrderStartDate</th>
                    <th>OrderPriority</th>
                     <th>PatientID</th>
                     <th>Diagnosis</th>
                     <th>Instructions</th>
               
               </tr>
          </thead>
          <tbody>
               <% inProgressRadiologyOrders.each { anOrder -> %>
               <tr>
                    
                    <td>${anOrder.study.studyname}</td>
                    <td>${ anOrder.dateCreated } </td>
                    <td>${ anOrder.urgency }</td>
                    <td>${ anOrder.patient.patientIdentifier }</td>
                    <td>${ anOrder.orderdiagnosis }</td>
                    <td>${ anOrder.instructions }</td>
                    
               </tr>
               <% } %>  
          </tbody>
     </table>
</div>
        



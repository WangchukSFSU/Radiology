
<% ui.includeCss("radiology", "viewOrderDetail.css") %>
<% ui.includeCss("radiology", "jquery-ui.css") %>
<%
def conceptPatientClass = config.requirePatientClass  
%>   


<script>
     jq = jQuery;
     jq(document).ready(function() {

     jq('#findPatientLinkBreadCrumb').hide();
     jq('#patientOrderDetailBreadCrumb').hide();

     //get patients for autocomlete feature
     jq("#patientTags").autocomplete({
     source: function(request, response) {
     var results = [];
                jq.getJSON('${ ui.actionLink("getPatientAutocomplete") }', {
     'query': request.term,
     'conceptPatientClass': "<%= conceptPatientClass %>"
     })
     .success(function(data) {

     jq('#patientInfo').empty();
     jq('#patientInfo').append('<table></table>');
     jq('#patientInfo table').attr('id', 'patientInfoDatatable');
     var patientInfoTable = jq('#patientInfo table');
     patientInfoTable.append('<thead><tr><th> Identifier</th><th> Name</th><th> Gender</th><th> Age </th><th> Birthdate</th></tr></thead><tbody>');      
     for (index in data) {
     var item = data[index];
     results.push(item.personName);
     var personName = item.personName;
     var patientIdentifier = item.patientIdentifier.Identifier;
     var gender = item.gender;
     var age = item.age;
     var birthdate = item.birthdate;

     patientInfoTable.append('<tr><td> ' + patientIdentifier + '</td><td> ' + personName + '</td><td> ' + gender + ' </td><td> ' + age + '</td><td> '+ birthdate +'</td></tr>');                    
     }
     patientInfoTable.append("</tbody>");
     jq('#patientInfoDatatable').DataTable({
     "sPaginationType": "full_numbers",
     "bPaginate": true,
     "bAutoWidth": false,
     "bLengthChange": false,
     "bSort": false,
     "bJQueryUI": false,
     "bFilter": false,

     });
     })
     .error(function(xhr, status, err) {
     alert('AJAX error ' + err);
     });
     }
     })

     //get PatientOrderDetails
     jq("#patientInfo").delegate("tbody tr", "click", function (event) {
     var value = jq('#patientInfoDatatable td').eq(1).text();
     jq('#patientInfo').remove();
     jq('#patient-search-form').remove();

     jq.getJSON('${ ui.actionLink("getPatientOrderDetails") }', 
     {'patientId': value })
     .error(function(xhr, status, err) {
     alert('AJAX error ' + err);
     })
     .success(function(ret) {
     jq('#findPatientLinkBreadCrumb').show();
     jq('#findPatientNoLinkBreadCrumb').hide();
     jq('#patientOrderDetailBreadCrumb').show();

     jq('#orderDetailDiv').empty();
     for (var i = 0; i < 1; i++) {
     var personName = ret[i].patient.personName;
     }
     jq("<h1></h1>").text("Radiology Order Detail for :  " +  personName ).appendTo('#orderDetailDiv');
     jq('#orderDetailDiv').append('<table></table>');
     jq('#orderDetailDiv table').attr('id', 'orderDetailDivTableid');
     var orderDetailDivTable = jq('#orderDetailDiv table');

     orderDetailDivTable.append('<thead><tr><th>OrderId </th><th>StudyName</th><th>StudyInstanceUid</th><th>DateCreated</th><th>Urgency</th></tr></thead><tbody>');      

     for (var i = 0; i < ret.length; i++) {
     var personName = ret[i].patient.personName;
     var patientIdentifier = ret[i].patient.patientIdentifier.Identifier;
     var studyname = ret[i].study.studyname;
     var dateCreated = ret[i].dateCreated;
     var urgency = ret[i].urgency;
     var gender = ret[i].patient.gender;
     var orderId = ret[i].orderId;
     var age = ret[i].patient.age;
     var Orderer = ret[i].Orderer;
     var Orderdiagnosis = ret[i].Orderdiagnosis;
     var Instructions = ret[i].Instructions;
     var studyInstanceUid = ret[i].study.studyInstanceUid;
     var birthdate = ret[i].patient.birthdate;

     orderDetailDivTable.append('<tr><td> ' + orderId + '</td><td> ' + studyname + '</td><td> ' + studyInstanceUid + ' </td><td> ' + dateCreated + '</td><td> '+ urgency +'</td></tr>');                    

     }

     orderDetailDivTable.append("</tbody>");   
     jq('#orderDetailDivTableid').dataTable({
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
               <a href='/openmrs/radiology/technicianViewOrderDetail.page'> FindPatient</a>         
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

<!-- Find Patient -->
<form method="get" id="patient-search-form" onsubmit="return false">
     <label for="tags">Find Patient </label>
     <input id="patientTags" placeholder="Search by ID or Name">
</form>


<!-- display patient Info -->
<div id = "patientInfo">
</div>


<!-- display order detail for the patient -->
<div id = "orderDetailDiv">
</div>













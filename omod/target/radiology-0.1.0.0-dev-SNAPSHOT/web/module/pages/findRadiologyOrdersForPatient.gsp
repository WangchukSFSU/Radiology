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

     jq('#findPatientLinkBreadCrumb').hide();
     jq('#patientOrderDetailBreadCrumb').hide();
 
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

<div>
<h1>Find Patient</h1>
</div>

${ ui.includeFragment("coreapps", "patientsearch/patientSearchWidget", 
[afterSelectedUrl: "/radiology/myPatientSearch.page?patientId=\u007B\u007B patientId \u007D\u007D",
showLastViewedPatients: true]) }








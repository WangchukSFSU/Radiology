<% ui.includeCss("radiology", "addEditObservation.css") %>
<% ui.includeCss("radiology", "jquery-ui.css") %>
<script type="text/javascript" src="/${ contextPath }/moduleResources/htmlformentry/htmlFormEntry.js"></script>
<link href="/${ contextPath }/moduleResources/htmlformentry/htmlFormEntry.css" type="text/css" rel="stylesheet" />


<script>
     jq = jQuery;
     jq(document).ready(function() {

  jq('#activeOrderTable').dataTable({
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
     
     jq("#orderDetailDiv").hide();
     jq("#activeOrdersWithLinkBreadCrumb").hide();
     jq("#orderDetailBreadCrumb").hide();   
      jq('#patientCompletedOrders').hide();
      jq('#htmlFormDiv').hide();
      
      
       //delete saved report dialog message
     jq("#reportDeletelDialogMessage").dialog({
     autoOpen: false,
     modal: false,
     title: 'Delete Report',
     width: 400,
     buttons: {
     "No": function() {
     jq(this).dialog('close');
     },
     "Yes": function() {
     continueCancelReport();
     jq(this).dialog('close');
     }
     },

     }).css("font-size", "16px");

     //display htmlform in the dialog box
     jq("#formDialogDiv").dialog({
     autoOpen: false,
     modal: false,
     draggable: true,
     resizable: true,
     show: 'blind',
     hide: 'blind',
     width: 900,
     dialogClass: 'ui-dialog-osx',

     });

     jq('#patientCompletedOrders').hide();
     jq('#activeOrdersWithLinkBreadCrumb').hide();
     jq("#orderDetailBreadCrumb").hide();

     jq("#obsDialogBox").dialog({
     autoOpen: false,
     modal: true,
     title: 'View Report',
     width: 550,
     height: 350,
     buttons: {
     "Ok": function() {
     jq(this).dialog('close');
     }
     },

     }).css("font-size", "16px");
  
     
});



</script>




<!-- breadcrumbs -->
<div class="breadcrumbsactiveorders">
     <ul id="breadcrumbs" class="apple">
          <li>
               <a href="/openmrs/index.htm">    
                    <i class="icon-home small"></i>  
               </a>       
          </li>
          <li id="activeOrdersWithNoLinkBreadCrumb">
               <i class="icon-chevron-right link"></i>
               Radiology Active Orders
          </li>
          <li id="activeOrdersWithLinkBreadCrumb">
               <i class="icon-chevron-right link"></i>
               <a href='/openmrs/radiology/radiologist.page'> Radiology Active Orders
               </a>
          </li>
            <li id="orderDetailBreadCrumb">  
               <i class="icon-chevron-right link"></i>
               Radiology Order Detail
          </li>
     </ul>
</div>
<!-- active radiology orders -->
<div id="activeOrderTableDiv">
     <h1>ACTIVE RADIOLOGY ORDERS</h1>
     <table id="activeOrderTable">
          <thead>
               <tr>
                    <th>Order</th>
                    <th>Patient Name</th>
                    <th>PatientID</th>
                    <th>OrderStartDate</th>
                    <th>OrderPriority</th>
                    <th>SavedReport</th>
               </tr>
          </thead>
          <tbody>
               <% performedStatusCompletedOrders.each { anOrder -> %>
               <tr>
                    <td><a id="studyLinkId" href='+ studyname +' class="studyLinkId" onclick="viewOrderDetail(this); return false;"><p style="display:none;">${ anOrder.orderId }</p>
                              ${anOrder.study.studyname}</a></td>
                    <td>${ anOrder.patient.personName } </td>
                    <td>${ anOrder.patient.patientIdentifier } </td>
                    <td>${ ui.format(anOrder.dateCreated) } </td>
                    <td>${ anOrder.urgency }</td>
                    <% if(anOrder.study.studyReportSavedEncounterId) { %>
                    <td>Yes</td>
                    <% } else { %>
                    <td>No</td>
                    <% } %>
               </tr>
               <% } %>  
          </tbody>
     </table>
</div>



<!-- display order detail on the order clicked in the active orders -->
<div id = "orderDetailDiv">
</div>

<!-- display previous completed orders -->
<div id = "patientCompletedOrders">
</div>

<!-- update order detail after the saved report is cancelled -->
<div id = "CancelReportUpdatedDiv">
</div>



<!-- observation dialog box -->
<div id="obsDialogBox" title="View Obs" style="display:none;">
     <div id="obsDialogBoxText" width="550" height="350"></div>
</div>

<div id="htmlFormDiv">
<!-- htmlform view in a dialog box -->
<div id="formDialogDiv" title="Fill Report">
     <span class="error" style="display: none" id="general-form-error"></span>
     <form id="htmlform" method="post" action="${ ui.actionLink("submit") }" onSubmit="submitHtmlForm(); return false;">
          <input type="hidden" id = "personId" name="personId" value=""/>
          <input type="hidden" id = "htmlFormId" name="htmlFormId" value=""/>
          <input type="hidden" id = "createVisit" name="createVisit" value=""/>
          <input type="hidden" id = "radiologyOrderId" name="radiologyOrderId" value=""/>
          <input type="hidden" id = "formModifiedTimestamp" name="formModifiedTimestamp" value=""/>
          <input type="hidden" id = "encounterModifiedTimestamp" name="encounterModifiedTimestamp" value=""/>
          <input type="hidden" id = "encounterId" name="encounterId" value=""/>
          <input type="hidden" id = "visitId" name="visitId" value=""/>
          <input type="hidden" id = "returnUrl" name="returnUrl" value=""/>
          <input type="hidden" id = "closeAfterSubmission" name="closeAfterSubmission" value=""/>
          <div id="passwordPopup" style="position: absolute; z-axis: 1; bottom: 25px; background-color: #ffff00; border: 2px black solid; display: none; padding: 10px">
               <center>
                    <table>
                         <tr>
                              <td colspan="2"><b>${ ui.message("htmlformentry.loginAgainMessage") }</b></td>
                         </tr>
                         <tr>
                              <td align="right"><b>${ ui.message("coreapps.user.username") }:</b></td>
                              <td><input type="text" id="passwordPopupUsername"/></td>
                         </tr>
                         <tr>
                              <td align="right"><b>${ ui.message("coreapps.user.password") }:</b></td>
                              <td><input type="password" id="passwordPopupPassword"/></td>
                         </tr>
                         <tr>
                              <td colspan="2" align="center"><input type="button" value="Submit" onClick="loginThenSubmitHtmlForm()"/></td>
                         </tr>
                    </table>
               </center>
          </div>
     </form>
</div>

</div>

<!-- delete saved report dialog message -->
<div id="reportDeletelDialogMessage" style="width:430px" title="Delete Report"> Are you sure you want to delete Report </div>




<script type="text/javascript">
     //javascript codes are copied from htmlformentryui module
     // for now we just expose these in the global scope for compatibility with htmlFormEntry.js and legacy forms
     function submitHtmlForm() {
     htmlForm.submitHtmlForm();
     //close dialog box after form is entered
     jq('#formDialogDiv').dialog('close');
     emr.successMessage("Entered Form Successfully");
     return false;
     }

     function showDiv(id) {
     htmlForm.showDiv(id);
     }

     function hideDiv(id) {
     htmlForm.hideDiv(id);
     }

     function getValueIfLegal(idAndProperty) {
     htmlForm.getValueIfLegal(idAndProperty);
     }

     function loginThenSubmitHtmlForm() {
     htmlForm.loginThenSubmitHtmlForm();
     }

     var beforeSubmit = htmlForm.getBeforeSubmit();
     var beforeValidation = htmlForm.getBeforeValidation();
     var propertyAccessorInfo = htmlForm.getPropertyAccessorInfo();

     jq(document).ready(function() {
     jQuery.each(jq("htmlform").find('input'), function(){
     jq(this).bind('keypress', function(e){
     if (e.keyCode == 13) {
     if (!jq(this).hasClass("submitButton")) {
     e.preventDefault(); 
     }
     }
     });
     });
     });

</script>


<script>
     //javascript codes are copied from htmlformentryui module
     // expects to extend htmlForm defined in the core HFE module
     (function( htmlForm, jq, undefined) {

     // individual forms can define their own functions to execute before a form validation or submission by adding them to these lists
     // if any function returns false, no further functions are called and the validation or submission is cancelled
     var beforeValidation = new Array();     // a list of functions that will be executed before the validation of a form
     var beforeSubmit = new Array(); 		// a list of functions that will be executed before the submission of a form
     var propertyAccessorInfo = new Array();

     var whenObsHasValueThenDisplaySection = { };

     var tryingToSubmit = false;

     var returnUrl = '';

     var successFunction = function(result) {
     displayReportAfterReportSubmitted();
     }

     var disableSubmitButton = function() {
     jq('.submitButton.confirm').attr('disabled', 'disabled');
     jq('.submitButton.confirm').addClass("disabled");
     if (tryingToSubmit) {
     jq('.submitButton.confirm .icon-spin').css('display', 'inline-block');
     }
     }

     var enableSubmitButton = function() {
     jq('.submitButton.confirm').removeAttr('disabled', 'disabled');
     jq('.submitButton.confirm').removeClass("disabled");
     jq('.submitButton.confirm .icon-spin').css('display', 'none');
     }

     var submitButtonIsDisabled = function() {
     return jq(".submitButton.confirm").is(":disabled");
     }

     var findAndHighlightErrors = function() {
     /* see if there are error fields */
     var containError = false
     var ary = jq(".autoCompleteHidden");
     jq.each(ary, function(index, value){
     if(value.value == "ERROR"){
     if(!containError){

     alert("Autocomplete answer not valid");
                    // alert("${ ui.message("htmlformentry.error.autoCompleteAnswerNotValid") }");
     var id = value.id;
     id = id.substring(0,id.length-4);
     jq("#"+id).focus();
     }
     containError=true;
     }
     });
     return containError;
     }

     /*
     It seems the logic of  showAuthenticateDialog and
     findAndHighlightErrors should be in the same callback function.
     i.e. only authenticated user can see the error msg of
     */
     var checkIfLoggedInAndErrorsCallback = function(isLoggedIn) {

     var state_beforeValidation=true;

     if (!isLoggedIn) {
     showAuthenticateDialog();
     }else{

     // first call any beforeValidation functions that may have been defined by the html form
     if (beforeValidation.length > 0){
     for (var i=0, l = beforeValidation.length; i < l; i++){
     if (state_beforeValidation){
     var fncn=beforeValidation[i];
     state_beforeValidation=fncn.call(htmlForm);
     }
     else{
     // forces the end of the loop
     i=l;
     }
     }
     }

     // only do the validation if all the beforeValidation functions returned "true"
     if (state_beforeValidation) {
     var anyErrors = findAndHighlightErrors();

     if (anyErrors) {
     tryingToSubmit = false;
     return;
     } else {
     doSubmitHtmlForm();
     }
     }
     else {
     tryingToSubmit = false;
     }
     }
     }

     var showAuthenticateDialog = function() {
     jq('#passwordPopup').show();
     tryingToSubmit = false;
     }

     // if an encounter id is passed in, that is appended to the return string
     var goToReturnUrl = function(encounterId) {
     if (returnUrl) {
     location.href = returnUrl
     + (encounterId ? (returnUrl.indexOf('?') != -1 ? '&' : '?') +"encounterId=" + encounterId : '');
     }
     else {
     if (typeof(parent) !== 'undefined') {
     parent.location.reload();
     } else {
     location.reload();
     }
     }
     }

     var doSubmitHtmlForm = function() {

     // first call any beforeSubmit functions that may have been defined by the form
     var state_beforeSubmit=true;
        if (beforeSubmit.length > 0){
     for (var i=0, l = beforeSubmit.length; i < l; i++){
     if (state_beforeSubmit){
     var fncn=beforeSubmit[i];
     state_beforeSubmit=fncn();
     }
     else{
     // forces the end of the loop
     i=l;
     }
     }
     }

     // only do the submit if all the beforeSubmit functions returned "true"
     // also, hack to double check to  disallow form submittal if submit button is disabled (prevent multiple submits)
     if (state_beforeSubmit && !submitButtonIsDisabled()){
     disableSubmitButton();
     var form = jq('#htmlform');
     jq(".error", form).text(""); //clear errors
     //ui.openLoadingDialog('Submitting Form');
     jq.post(form.attr('action'), form.serialize(), function(result) {
     if (result.success) {
     tryingToSubmit = false;
     successFunction(result);

     }
     else {
     //ui.closeLoadingDialog();
     enableSubmitButton();
     tryingToSubmit = false;
     for (key in result.errors) {
     showError(key, result.errors[key]);
     }
     // scroll to one of the errors
     // TODO there must be a more efficient way to do this!
     for (key in result.errors) {
     jq(document).scrollTop(jq('#' + key).offset().top - 100);
     break;
     }

     //ui.enableConfirmBeforeNavigating();
     }
     }, 'json')
     .error(function(jqXHR, textStatus, errorThrown) {
     //ui.closeLoadingDialog();
     //ui.enableConfirmBeforeNavigating();

     emr.errorAlert('Unexpected error, please contact your System Administrator: ' + textStatus);
     });
     }
     else {
     tryingToSubmit = false;
     }


     };

     htmlForm.submitHtmlForm = function()  {
     if (!tryingToSubmit) {    // don't allow form submittal if submit button is disabled (disallows multiple submits)
     tryingToSubmit = true;
     jq.getJSON(emr.fragmentActionLink('htmlformentryui', 'htmlform/enterHtmlForm', 'checkIfLoggedIn'), function(result) {
     checkIfLoggedInAndErrorsCallback(result.isLoggedIn);
     });
     }

     };

     htmlForm.loginThenSubmitHtmlForm = function() {
     jq('#passwordPopup').hide();
     var username = jq('#passwordPopupUsername').val();
     var password = jq('#passwordPopupPassword').val();
     jq('#passwordPopupUsername').val('');
     jq('#passwordPopupPassword').val('');
     jq.getJSON(emr.fragmentActionLink('htmlformentryui', 'htmlform/enterHtmlForm', 'authenticate', { user: username, pass: password }), submitHtmlForm);
     };

     htmlForm.cancel = function() {
     goToReturnUrl();
     };

     htmlForm.getValueIfLegal = function(idAndProperty) {
     var jqField = getField(idAndProperty);
     if (jqField && jqField.hasClass('illegalValue')) {
     return null;
     }
     return getValue(idAndProperty);
     };

     htmlForm.getPropertyAccessorInfo = function() {
     return propertyAccessorInfo;
     };

     htmlForm.getBeforeSubmit = function() {
     return beforeSubmit;
     };

     htmlForm.getBeforeValidation = function() {
     return beforeValidation;
     };

     htmlForm.setReturnUrl = function(url) {
     returnUrl = url;
     };

     htmlForm.setSuccessFunction = function(fn) {
     successFunction = fn;
     };


     htmlForm.setEncounterStartDateRange = function(date) {
     if (getField('encounterDate.value')) {
     getField('encounterDate.value').datepicker('option', 'minDate', date);
     }
     };

     htmlForm.setEncounterStopDateRange = function(date) {
     if (getField('encounterDate.value')) {
     getField('encounterDate.value').datepicker('option', 'maxDate', date);
     }
     };

     htmlForm.setEncounterDate = function(date) {
     if (getField('encounterDate.value')) {
     getField('encounterDate.value').datepicker('setDate', date);
     }
     };

     htmlForm.disableEncounterDateManualEntry = function() {
     if (getField('encounterDate.value')) {
     getField('encounterDate.value').attr( 'readOnly' , 'true' );
     }
     };

     htmlForm.showDiv = function(id) {
     var div = document.getElementById(id);
     if ( div ) { div.style.display = ""; }
     };

     htmlForm.hideDiv = function(id) {
     var div = document.getElementById(id);
     if ( div ) { div.style.display = "none"; }
     }

     htmlForm.disableSubmitButton = function() {
     disableSubmitButton();
     }

     htmlForm.enableSubmitButton = function() {
     // don't allow the submit button to be enabled if trying to submit
     if (!tryingToSubmit) {
     enableSubmitButton();
     }
     }
     }( window.htmlForm = window.htmlForm || {}, jQuery ));

</script>

<script>

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
     
     function continueOrderDetail(orderId) {
      <% if (performedStatusCompletedOrders) { %>
     <% performedStatusCompletedOrders.each { anOrder -> %>
     var radiologyorderId = ${ anOrder.orderId };
     if (orderId == radiologyorderId) {
     localStorage.setItem("radiologyorderId", radiologyorderId);
     //get the report saved encounter id of the order
     jq.getJSON('${ ui.actionLink("getReportSavedEncounterId") }', 
     {'radiologyorderId': radiologyorderId })
     .error(function(xhr, status, err) {
     alert('AJAX error ' + err);
     })
     .success(function(ret) {
     for (var i = 0; i < ret.length; i++) {
     var updatedOrderencounterId = ret[i].study.studyReportSavedEncounterId;
     localStorage.setItem("updatedOrderencounterId", updatedOrderencounterId);
     }
     })

           jq('#orderDetailDiv').append("<div class='order'  id= 'orderDetailHeading'>RADIOLOGY ORDER DETAILS  :  <a target='_blank' href=${ patientClinicianUrl + anOrder.patient.person.uuid } >${ anOrder.patient.personName }</a>  ${ anOrder.patient.patientIdentifier }, ${anOrder.study.studyname} </div>");
           jq('#orderDetailDiv').append("<div class='order'  id= 'orderDetailProvider'>Provider  :  ${anOrder.creator.username} ,  StartDate  : ${ anOrder.dateCreated } </div>");
           jq('#orderDetailDiv').append("<div class='order'  id= 'orderDetailDiagnosis'>Diagnosis  : ${anOrder.orderdiagnosis} </div>");
           jq('#orderDetailDiv').append("<div class='order'  id= 'orderDetailDiagnosis'>Instructions  : ${anOrder.instructions} </div>");         

     <% if (oviyamStatus == "") { %>
           jq('#orderDetailDiv').append("<div class='order'  id= 'viewStudyId1'><a id = 'viewStudyLink' class='viewStudyLink' target='_blank' href='${ dicomViewerWeasisUrladdress + "studyUID=" + anOrder.study.studyInstanceUid + "&patientID=" + anOrder.patient.patientIdentifier   }'>ViewStudy</a> </div>");
     <% } %>
     <% if (weasisStatus == null) { %>
           jq('#orderDetailDiv').append("<div class='order'  id= 'viewStudyId2'><a id = 'viewStudyLink2' class='viewStudyLink' target='_blank' href='${ dicomViewerUrladdress + "studyUID=" + anOrder.study.studyInstanceUid + "&patientID=" + anOrder.patient.patientIdentifier   }'>ViewStudy</a> </div>");
     <% } %>
     <% if ((weasisStatus != null) && (oviyamStatus != "")) { %>
           jq('#orderDetailDiv').append("<span class='order'  id= 'viewStudyText'>ViewStudy  :  </span>");         
           jq('#orderDetailDiv').append("<a  id = 'viewstudyid2' class='order' target='_blank' href='${ dicomViewerUrladdress + "studyUID=" + anOrder.study.studyInstanceUid + "&patientID=" + anOrder.patient.patientIdentifier   }'>Oviyam   &nbsp;</a> ");
           jq('#orderDetailDiv').append("<a id = 'viewStudyId' class='order' target='_blank' href='${ dicomViewerWeasisUrladdress + "studyUID=" + anOrder.study.studyInstanceUid + "&patientID=" + anOrder.patient.patientIdentifier   }'>Weasis</a> <br>");
     <% } %>


     //get form
           jq.getJSON('${ ui.actionLink("getForm") }', {
     'radiologyorderId': radiologyorderId
     })
     .error(function(xhr, status, err) {
     alert('AJAX error ' + err);
     })
     .success(function(ret) {
     var formNameArray = [];
     var formNameHtmlToDisplayArray = [];
     var patientIdArray = [];
     var HtmlFormIdArray = [];
     for (var i = 0; i < ret.length; i++) {
     var formNameHtmlToDisplay = ret[i].HtmlToDisplay;
     formNameHtmlToDisplayArray[i] = formNameHtmlToDisplay;
     var patientId = ret[i].Patient.PatientId;
     patientIdArray[i] = patientId;
     var HtmlFormId = ret[i].HtmlFormId;
     HtmlFormIdArray[i] = HtmlFormId;
     var FormModifiedTimestamp = ret[i].FormModifiedTimestamp;
     var ReturnUrl = ret[i].ReturnUrl;
     var FormName = ret[i].FormName;
     formNameArray[i] = FormName;

     localStorage.setItem("patientIdForCompletedOrderList", patientId);
     var radiologyorderId = localStorage.getItem("radiologyorderId");
     var updatedOrderencounterId = localStorage.getItem("updatedOrderencounterId");
     if (updatedOrderencounterId == "null") {
          jq("#orderDetailDiv").append('<a>' + FormName + ' Form  </a>');

     } else {
          jq("#orderDetailDiv").append('<a id="pep"> SavedReport <p style="display:none;"> ' + FormName + ' </p> </a>');
     }

     jq('#orderDetailDiv #viewStudyId').next().attr('id', 'formid');
     jq('#orderDetailDiv a').last().attr('id', 'formid');
     jq('#orderDetailDiv #viewStudyId').next().addClass("order");
     jq('#orderDetailDiv a').next().addClass("order");
     jq('#orderDetailDiv #formid').attr('onclick', onclick = "openForm(this); return false;");
     jq("#orderDetailDiv").append('&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;');

     }

     if (updatedOrderencounterId != "null") {
     jq("#orderDetailDiv").append('<a><img id="reportCancelId" class = "reportCancelClass" src=" ${ ui.resourceLink ("/images/ic_cancel_2x.png") }" /></a>');
     jq('#orderDetailDiv #formid').last().next().attr('id', 'reportCancelIcon');
     jq('#orderDetailDiv #formid').last().next().addClass("order");
     jq('#orderDetailDiv #reportCancelIcon').attr('onclick', onclick = "cancelReport(); return false;");
     }

     localStorage.setItem("FormModifiedTimestamp", FormModifiedTimestamp);
     localStorage.setItem("ReturnUrl", ReturnUrl);
     localStorage.setItem("formNameArray", JSON.stringify(formNameArray));
     localStorage.setItem("formNameHtmlToDisplayArray", JSON.stringify(formNameHtmlToDisplayArray));
     localStorage.setItem("patientIdArray", JSON.stringify(patientIdArray));
     localStorage.setItem("HtmlFormIdArray", JSON.stringify(HtmlFormIdArray));

     var cancelSubmitButton = jq('<div class="order" id= "cancelbtnDivId"><input type="button" id = "cancelbtnId" onclick="cancelBtn();" value="Process Another Order" /><input type="button" onclick="submitBtn();" value="Submit" /></div>');
     cancelSubmitButton.appendTo(jq('#orderDetailDiv'));
     var patientIdForCompletedOrderList = localStorage.getItem("patientIdForCompletedOrderList");

     jq.getJSON('${ ui.actionLink("getPatientReportReadyOrder") }', {
     'patientId': patientIdForCompletedOrderList
     })
     .error(function(xhr, status, err) {
     alert('AJAX error ' + err);
     })
     .success(function(ret) {
     jq('#CancelReportUpdatedDiv').hide();
     jq('#patientCompletedOrders').empty();
          jq("<h1></h1>").text("PREVIOUS RADIOLOGY ORDERS FOR :"+ ' ${ anOrder.patient.personName} ').appendTo('#patientCompletedOrders');
          jq('#patientCompletedOrders').append('<table></table>');
     jq('#patientCompletedOrders table').attr('id', 'patientCompletedOrdersDatatable');
     var patientCompletedOrdersTable = jq('#patientCompletedOrders table');
     patientCompletedOrdersTable.append('<thead><tr><th> Report</th><th> StartDate</th><th> Provider</th><th> Instructions </th><th> Diagnosis</th><th> Study</th></tr></thead><tbody>');
                
     for (var i = 0; i < ret.length; i++) {
     var provider = ret[i].orderer.name;
     var instructions = ret[i].instructions;
     var patientId = ret[i].patient.patientIdentifier.Identifier;
     var orderdiagnosis = ret[i].orderdiagnosis;
     var studyname = ret[i].study.studyname;
     var studyInstanceUid = ret[i].study.studyInstanceUid;
     var DateCreated = ret[i].DateCreated;
     var OrderencounterId = ret[i].study.studyReportSavedEncounterId;
     
       <% if (oviyamStatus == "") { %>     
         patientCompletedOrdersTable.append('<tr><td><a onclick="viewReport(' + OrderencounterId + ');"> Obs</a> </td><td> ' + DateCreated + '</td><td> ' + provider + '</td><td> ' + instructions + ' </td><td> ' + orderdiagnosis + '</td><td id="studyColumnId"><a id="viewStudyLink" class="viewStudyLink" target="_blank" href="${ dicomViewerWeasisUrladdress + "studyUID=" }'+ studyInstanceUid +'&patientID='+ patientId +' " >' + studyname + '</a></td></tr>');
       <% } %>
       <% if (weasisStatus == null) { %>
         patientCompletedOrdersTable.append('<tr><td><a onclick="viewReport(' + OrderencounterId + ');"> Obs</a> </td><td> ' + DateCreated + '</td><td> ' + provider + '</td><td> ' + instructions + ' </td><td> ' + orderdiagnosis + '</td><td id="studyColumnId"><a id="viewStudyLink" class="viewStudyLink" target="_blank" href="${ dicomViewerUrladdress + "studyUID=" }'+ studyInstanceUid +'&patientID='+ patientId +' " >' + studyname + '</a></td></tr>');
       <% } %>
       <% if ((weasisStatus != null) && (oviyamStatus != "")) { %>
          patientCompletedOrdersTable.append('<tr><td><a onclick="viewReport(' + OrderencounterId + ');"> Obs</a> </td><td> ' + DateCreated + '</td><td> ' + provider + '</td><td> ' + instructions + ' </td><td> ' + orderdiagnosis + '</td><td id="studyColumnId"><a id="studyLink" class="studyLink" target="_blank" href="${ dicomViewerUrladdress + "studyUID=" + anOrder.study.studyInstanceUid + "&patientID=" +  anOrder.patient.patientIdentifier }" >Oviyam</a><br><a id="studyLink" class="studyLink" target="_blank" href="${ dicomViewerWeasisUrladdress + "studyUID=" + anOrder.study.studyInstanceUid + "&patientID=" +  anOrder.patient.patientIdentifier }" >Weasis</a></td></td></tr>');
       <% } %>                     
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
     [1, "desc"]
     ] // Sort by first column descending,

     });

     })

     })

     }

     <% } %>
     <% } %>
     
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

</script>



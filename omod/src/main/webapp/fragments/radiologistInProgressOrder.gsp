<% ui.includeCss("radiology", "radiologistInProgressOrder.css") %>
<% ui.includeCss("radiology", "jquery-ui.css") %>
<% ui.includeCss("radiology", "jquery.dataTables.min.css") %>


<%
// config supports style (css style on div around form)
// config supports cssClass (css class on div around form)

// assumes jquery and jquery-ui from emr module
ui.includeJavascript("uicommons", "handlebars/handlebars.min.js", Integer.MAX_VALUE - 1);
ui.includeJavascript("htmlformentryui", "dwr-util.js")
ui.includeJavascript("htmlformentryui", "htmlForm.js")
ui.includeJavascript("uicommons", "emr.js")
ui.includeJavascript("uicommons", "moment.js")
// TODO setup "confirm before navigating" functionality
%>

<script type="text/javascript" src="/${ contextPath }/moduleResources/htmlformentry/htmlFormEntry.js"></script>
<script type="text/javascript" src="/${ contextPath }/moduleResources/htmlformentry/htmlForm.js"></script>
<link href="/${ contextPath }/moduleResources/htmlformentry/htmlFormEntry.css" type="text/css" rel="stylesheet" />

<script type="text/javascript">

    // for now we just expose these in the global scope for compatibility with htmlFormEntry.js and legacy forms
    function submitHtmlForm() {
    alert("0000000");
    htmlForm.submitHtmlForm();
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


        htmlForm.setReturnUrl('${ returnUrl }');




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
    jq = jQuery;
    jq(document).ready(function() {



jq("#ReportDeletelDialog").dialog({
autoOpen: false,
              modal: true,
             title: 'Delete Report',
             width: 400,
            buttons : {
                  "Yes": function () { 
            continuecancelReport();
            jq(this).dialog('close'); 
         },
        "No": function () { 
           
            jq(this).dialog('close'); 
         }
            },

        });
        
        
    jq("#dialog-message").dialog({
    autoOpen: false,
    modal: false,
    draggable: true,
    resizable: true,
    show: 'blind',
    hide: 'blind',
    width: 900,
    dialogClass: 'ui-dialog-osx',
    buttons: {
    "Cancel": function() {

    jq(this).dialog("close");


    }
    }
    });

    });

    function displayReport(el) {
    localStorage.clear();
    jq(el).addClass("highlight").css("background-color","#CCCCCC");
    alert("33333");
    jq('#patientCompletedOrders').show();
    jq("#activeorders").hide();
    jq("#activeorderswithLink").show();
    jq("#orderdetails").show();
    jq('#eee').show();
    jq('#performedStatusInProgressOrderDetail').empty();

    jq(el).addClass('selected').siblings().removeClass('selected');  
    var value= jq(el).closest('tr').find('td:first').text();
    // var value=jq(el).find('td:first').html();

    alert(value); 
    var orderId = parseInt(value, 10);
    
    jq("#performedStatusInProgressOrderDetail").show();
    jq("#performedStatusInProgressOrder").hide();
   

    alert("orderId" +orderId);



    <% if (inProgressRadiologyOrders) { %>
    alert("yess");
    <% inProgressRadiologyOrders.each { anOrder -> %>

    var radiologyorderId = ${anOrder.orderId} ;

    if(orderId == radiologyorderId) {

    alert("orderId same" +orderId);
   

    localStorage.setItem("radiologyorderId", radiologyorderId);
 
       
        jq.getJSON('${ ui.actionLink("getUpdatedEncounterId") }',
    { 'radiologyorderId': radiologyorderId
    })
    .error(function(xhr, status, err) {
    alert('AJAX error ' + err);
    })
    .success(function(ret) {
    alert("encounter id  " + ret.length);
    alert("bbbb");
      for (var i = 0; i < ret.length; i++) {
      var updatedOrderencounterId = ret[i].study.OrderencounterId;
      alert("updatedOrderencounterId   iiiiiiii");
      alert(updatedOrderencounterId);
      localStorage.setItem("updatedOrderencounterId", updatedOrderencounterId);
    }


    })


 jq('#performedStatusInProgressOrderDetail').append("<div class='order'  id= 'orderDetailHeading'>RADIOLOGY ORDER DETAILS  :   ${ anOrder.patient.personName }, ${ anOrder.patient.patientIdentifier }, ${anOrder.study.studyname} </div>");
jq('#performedStatusInProgressOrderDetail').append("<div class='order'  id= 'orderDetailProvider'>Provider  :  ${anOrder.creator.username} ,  StartDate  : ${ anOrder.dateCreated } </div>");
 jq('#performedStatusInProgressOrderDetail').append("<div class='order'  id= 'orderDetailDiagnosis'>Diagnosis  : ${anOrder.orderdiagnosis} </div>");
jq('#performedStatusInProgressOrderDetail').append("<div class='order'  id= 'orderDetailDiagnosis'>Instructions  : ${anOrder.instructions} </div>");



jq('#performedStatusInProgressOrderDetail').append("<div class='order'  id= 'viewstudyid'><a id = 'tiger' class='tiger' href=${ dicomViewerUrladdress + "studyUID=" + anOrder.study.studyInstanceUid + "&patientID=" + anOrder.patient.patientIdentifier } onclick='loadImages(); return false;'>ViewStudy</a> </div>");


    alert("jiiji");

    jq.getJSON('${ ui.actionLink("getForm") }',
    { 'radiologyorderId': radiologyorderId
    })
    .error(function(xhr, status, err) {
    alert('AJAX error ' + err);
    })
    .success(function(ret) {
    alert("succsss");

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

    alert(FormName);

    localStorage.setItem("patientIdForCompletedOrderList", patientId);

    var radiologyorderId = localStorage.getItem("radiologyorderId");

   
    var updatedOrderencounterId = localStorage.getItem("updatedOrderencounterId");
    
    alert("updatedOrderencounterId oooooooooo");
      alert(updatedOrderencounterId);
      
      if(updatedOrderencounterId == "null") {
      alert(" null  "  );
 jq("#performedStatusInProgressOrderDetail").append('<a>'+ FormName +' Report Form  </a>');
       
      } else {
      alert(" not null");
      jq("#performedStatusInProgressOrderDetail").append('<a> SavedReport : '+ FormName +' Report Form </a>');
     
      }
      
      

    
    jq('#performedStatusInProgressOrderDetail #viewstudyid').next().attr('id', 'formid');
    jq('#performedStatusInProgressOrderDetail a').next().attr('id', 'formid');
    jq('#performedStatusInProgressOrderDetail #viewstudyid').next().addClass("order");
    jq('#performedStatusInProgressOrderDetail a').next().addClass("order");
    jq('#performedStatusInProgressOrderDetail #formid').attr('onclick', onclick="loadttt(this); return false;");
    jq("#performedStatusInProgressOrderDetail").append('&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;'); 



    }

 if(updatedOrderencounterId != "null") {
  jq("#performedStatusInProgressOrderDetail").append('<a><img id="reportCancelId" class = "reportCancelClass" src=" ${ ui.resourceLink ("/images/ic_cancel_2x.png") }" /></a>');
    jq('#performedStatusInProgressOrderDetail #formid').next().attr('id', 'reportCancelIcon');
    jq('#performedStatusInProgressOrderDetail #formid').next().addClass("order");
    jq('#performedStatusInProgressOrderDetail #reportCancelIcon').attr('onclick', onclick="cancelReport(); return false;");
    }


    localStorage.setItem("FormModifiedTimestamp", FormModifiedTimestamp);
    localStorage.setItem("ReturnUrl", ReturnUrl);
    localStorage.setItem("formNameArray", JSON.stringify(formNameArray));
    localStorage.setItem("formNameHtmlToDisplayArray", JSON.stringify(formNameHtmlToDisplayArray));
    localStorage.setItem("patientIdArray", JSON.stringify(patientIdArray));
    localStorage.setItem("HtmlFormIdArray", JSON.stringify(HtmlFormIdArray));



    jq('#performedStatusInProgressOrderDetail').append("<div class='order'  id= 'cancelbtnDivId'> <input type='button' id='cancelbtn' value='Cancel' /> <input type='button' id ='submitbtn' value='Submit' /></div>");

    var patientIdForCompletedOrderList = localStorage.getItem("patientIdForCompletedOrderList");

     jq.getJSON('${ ui.actionLink("getPatientCompletedOrder") }',
    { 'patientId': patientIdForCompletedOrderList
    })
    .error(function(xhr, status, err) {
    alert('AJAX error ' + err);
    })
    .success(function(ret) {
    jq('#CancepReportUpdatedDiv').hide();
    jq('#patientCompletedOrders').empty();
    jq("<h1></h1>").text("PREVIOUS RADIOLOGY ORDERS").appendTo('#patientCompletedOrders');
         jq('#patientCompletedOrders').append('<table></table>');
    jq('#patientCompletedOrders table').attr('id','patientCompletedOrdersDatatable');
    jq("#patientCompletedOrders table").addClass("reporttableclass");
    var patientCompletedOrdersTable = jq('#patientCompletedOrders table');
    
  patientCompletedOrdersTable.append( '<thead><tr><th> Report</th><th> StartDate</th><th> Provider</th><th> Instructions </th><th> Diagnosis</th><th> Study</th></tr></thead><tbody>' );
   
    for (var i = 0; i < ret.length; i++) {
    var provider = ret[i].orderer.name;
    var instructions = ret[i].instructions;
    var patientId = ret[i].Patient.PatientId;
    var orderdiagnosis = ret[i].orderdiagnosis;
    var studyname = ret[i].study.studyname;
    var studyInstanceUid = ret[i].study.studyInstanceUid;
    var DateCreated = ret[i].DateCreated;
    var OrderencounterId = ret[i].study.OrderencounterId;

   patientCompletedOrdersTable.append( '<tr><td><a onclick="runMyFunction();"> Obs</a> </td><td> '+ DateCreated +'</td><td> '+ provider +'</td><td> '+ instructions +' </td><td> '+ orderdiagnosis +'</td><td id="dogdog" href="ddasdas"><a id="tiger" class="tiger" href="${ dicomViewerUrladdress + "studyUID=" + '+ studyInstanceUid +' + "&patientID=" + '+ patientId +' }" onclick="loadImages(); return false;" >'+ studyname +'</a></td></tr>' );


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
    "aaSorting": [[ 1, "desc" ]] // Sort by first column descending,

    });
    
    })


    })






    }



    <% } %>
    <% } %> 


    }


    
    function UpdatedEncounter() {
      alert("bbbb  start");

    
    
    }

    function cancelReport() {
    alert("cancelReport");


jq( "#ReportDeletelDialog" ).dialog( "open" );

}

function continuecancelReport() {

    var radiologyorderId = localStorage.getItem("radiologyorderId");
       jq.getJSON('${ ui.actionLink("CancelReportUpdate") }',
    { 'radiologyorderId': radiologyorderId
    })
    .error(function(xhr, status, err) {
    alert('AJAX error ' + err);
    })
    .success(function(ret) {
    alert("CancelReportUpdate");

    jq('#orderdetails').hide();
    jq('#activeorderswithLink').hide();
    jq('#activeorders').show();
    jq('#showReportsDiv').hide();


    jq("#patientCompletedOrders").hide();
    jq('.order').hide();
    jq('#CancepReportUpdatedDiv').show();
    jq('#CancepReportUpdatedDiv').empty();
    jq("<h1></h1>").text("Report deleted successfully").appendTo('#CancepReportUpdatedDiv');
    jq("<h1></h1>").text("ACTIVE RADIOLOGY ORDERS").appendTo('#CancepReportUpdatedDiv');

      jq('#CancepReportUpdatedDiv').append('<table></table>');
    jq('#CancepReportUpdatedDiv table').attr('id','cancepReportUpdatedDatatable');
    jq("#CancepReportUpdatedDiv table").addClass("reporttableclass");
    var cancepReportUpdatedTable = jq('#CancepReportUpdatedDiv table');
    cancepReportUpdatedTable.append( '<thead><tr><th>Order</th><th>Patient Name</th><th>MRN</th><th>OrderStartDate</th><th>OrderPriority</th></tr></thead><tbody>' );
    alert("COOL");

    for (var i = 0; i < ret.length; i++) {

    var studyname = ret[i].study.studyname;
    var dateCreated = ret[i].dateCreated;
    var urgency = ret[i].urgency;
    var patientName = ret[i].patient.personName;
    var patientIdentifier = ret[i].patient.patientIdentifier;
    var anOrderId = ret[i].orderId;



     cancepReportUpdatedTable.append( '<tr><td><a id="fillreport" href='+ studyname +' class="fillreport" onclick="displayReport(this); return false;"><p style="display:none;">'+ anOrderId +'</p>'+ studyname +' </a></td><td>'+ patientName +'</td><td>'+ patientIdentifier +'</td><td>'+ dateCreated +'</td><td>'+ urgency +'</td></tr>' );
    }

   cancepReportUpdatedTable.append("</tbody>");
    jq('#cancepReportUpdatedDatatable').dataTable({
    "sPaginationType": "full_numbers",
    "bPaginate": true,
    "bAutoWidth": false,
    "bLengthChange": true,
    "bSort": true,
    "bJQueryUI": true,

    "iDisplayLength": 5,
    "aaSorting": [[ 3, "desc" ]] // Sort by first column descending,


    });

    })



    }

    function loadttt(obj) {

    alert("loadImages");
    jq("div#content").css({'font-size':16}); 
    jq('input#closeAfterSubmission').next().empty();

    var formNameArray = JSON.parse(localStorage.getItem("formNameArray"));
    var formNameHtmlToDisplayArray = JSON.parse(localStorage.getItem("formNameHtmlToDisplayArray"));
    var patientIdArray = JSON.parse(localStorage.getItem("patientIdArray"));
    var HtmlFormIdArray = JSON.parse(localStorage.getItem("HtmlFormIdArray"));


    var radiologyorderId = localStorage.getItem("radiologyorderId");
    var returnUrl = localStorage.getItem("ReturnUrl");
    var formModifiedTimestamp = localStorage.getItem("FormModifiedTimestamp");

    var text = jq(obj).text();
    alert(text);

    var firstColumnFormName = text.replace('Report Form','');
    var firstColumnFormName = firstColumnFormName.replace('SavedReport :','');

    alert(firstColumnFormName);

    var formNameHtmlToDisplayt;
    var patientIdt;
    var HtmlFormIdt;

    //matches the form cicked and assign it for display
    for (var i=0;i<formNameArray.length;i++){

    if(jq.trim(firstColumnFormName) == formNameArray[i]) {

    formNameHtmlToDisplayt = formNameHtmlToDisplayArray[i];
    patientIdt = patientIdArray[i];
    HtmlFormIdt = HtmlFormIdArray[i];
    }

    }




    var returnUrl = localStorage.getItem("returnUrl");

    var formModifiedTimestamp = localStorage.getItem("formModifiedTimestamp");

    jq( "#dialog-message" ).dialog( "open" );
    jq('#personId').val(patientIdt);
    jq('#htmlFormId').val(HtmlFormIdt);
    jq('#returnUrl').val(returnUrl);
    jq('#radiologyOrderId').val(radiologyorderId);



    jq('input#closeAfterSubmission').after(formNameHtmlToDisplayt);


    }









</script>



<script>
    jq = jQuery;
    jq(document).ready(function() {

    jq('#patientCompletedOrders').hide();


    jq('#activeorderswithLink').hide();
    jq("#orderdetails").hide();




    jq('#performedStatusInProgressOrderTable').dataTable({
    "sPaginationType": "full_numbers",
    "bPaginate": true,
    "bAutoWidth": false,
    "bLengthChange": true,
    "bSort": true,

    "bJQueryUI": true,

    "iDisplayLength": 5,
    "aaSorting": [[ 3, "desc" ]] // Sort by first column descending,


    });
    jq("#performedStatusInProgressOrderDetail").hide(); 


    jq("#test").click(function() {
    alert("dsdads");
    jq("#somediv").load('/openmrs/radiology/radiologistActiveOrders.page').dialog({modal:true}); 
    });  


    });




    function submitObs() {
    alert("YESS");
    var radiologyorderId = localStorage.getItem("radiologyorderId");

    alert("radiologyorderId " + radiologyorderId);

    jq.getJSON('${ ui.actionLink("updateActiveOrders") }',
    { 'radiologyorderId': radiologyorderId
    })
    .error(function(xhr, status, err) {
    alert('AJAX error ' + err);
    })
    .success(function(ret) {
    alert("COOL");

    jq('#orderdetails').hide();
    jq('#activeorderswithLink').hide();
    jq('#activeorders').show();
    jq('#showReportsDiv').hide();


    jq("#performedStatusInProgressOrderDetail").hide();
    jq('#performedStatusInProgressOrder').show();
    jq('#performedStatusInProgressOrder').empty();
    jq("<h1></h1>").text("Report sent successfully").appendTo('#performedStatusInProgressOrder');
    jq("<h1></h1>").text("ACTIVE RADIOLOGY ORDERS").appendTo('#performedStatusInProgressOrder');

      jq('#performedStatusInProgressOrder').append('<table></table>');
    jq('#performedStatusInProgressOrder table').attr('id','updateActiveOrderDatatable');
    jq("#performedStatusInProgressOrder table").addClass("reporttableclass");
    var dicomtablelist = jq('#performedStatusInProgressOrder table');
    dicomtablelist.append( '<thead><tr><th>Order</th><th>Patient Name</th><th>OrderStartDate</th><th>OrderPriority</th></tr></thead><tbody>' );
    alert("COOL");

    for (var i = 0; i < ret.length; i++) {
    var anOrderId = ret[i].orderId;
    var studyname = ret[i].study.studyname;
    var dateCreated = ret[i].dateCreated;
    var urgency = ret[i].urgency;
    var patientName = ret[i].patient.personName;

     dicomtablelist.append( '<tr><td><a id="fillreport" href='+ studyname +' class="fillreport" onclick="displayReport(this); return false;"><p style="display:none;">'+ anOrderId +'</p>'+ studyname +' </a></td><td>'+ patientName +'</td><td>'+ dateCreated +'</td><td>'+ urgency +'</td></tr>' );



    }
     dicomtablelist.append("</tbody>");
    jq('#updateActiveOrderDatatable').dataTable({
    "sPaginationType": "full_numbers",
    "bPaginate": true,
    "bAutoWidth": false,
    "bLengthChange": true,
    "bSort": true,
    "bJQueryUI": true,

    "iDisplayLength": 5,
    "aaSorting": [[ 2, "desc" ]] // Sort by first column descending,


    });


    })

    }



    function fillReport(selected) {


    //var addressValue = selected.attr("href");
    // var addressValue = jq('#listreport').attr("href");
    // alert("addressValue"  + addressValue);

    jq("#thedialogreport").attr('src', selected);
    // jq("#thedialogreport").attr('src', jq('.listreport').attr("href"));
    jq("#somedivreport").dialog({
    width: 600,
    height: 450,
    modal: false,
    close: function () {
    jq("#thedialogreport").attr('src', "about:blank");
    }
    });
    return false;


    }

    function loadImages() {

    var addressValue = jq('.tiger').attr("href");
    alert(addressValue );

    jq("#thedialog").attr('src', jq('.tiger').attr("href"));
    jq("#somediv").dialog({
    width: 400,
    height: 450,
    modal: false,
    close: function () {
    jq("#thedialog").attr('src', "about:blank");
    }
    });
    return false;


    }

    function runMyFunction() {
    alert("run my function");




    }

    function contactRadiologist() {
    alert("run my contactRadiologist");

    jq("#ContactRadiologist").show();


    }
    function openDialog(url)    {
    jq('#breadcrumbs').remove();
        jq('<div/>').dialog({
    modal: true,
    open: function ()
    {
    if (jq(this).is(':empty')) {
    jq(this).load(url);
    }
    },         
    height: 600,
    width: 950,
    title:"Report"
    });


    }







</script>


<div class="breadcrumbsactiveorders">
    <ul id="breadcrumbs" class="apple">
        <li>
            <a href="/openmrs/index.htm">    
                <i class="icon-home small"></i>  
            </a>       
        </li>
        <li id="activeorders">
            <i class="icon-chevron-right link"></i>
            Radiology Active Orders


        </li>
        <li id="activeorderswithLink">
            <i class="icon-chevron-right link"></i>

            <a href='/openmrs/radiology/radiologistActiveOrders.page'> Radiology Active Orders
            </a>

        </li>

        <li id="orderdetails">  
            <i class="icon-chevron-right link"></i>
            Radiology Order Detail
        </li>

    </ul>
</div>




<div id="performedStatusInProgressOrder">

    <h1>ACTIVE RADIOLOGY ORDERS</h1>

    <table id="performedStatusInProgressOrderTable">
        <thead>
            <tr>

                <th>Order</th>
                <th>Patient Name</th>
                <th>MRN</th>
                <th>OrderStartDate</th>
                <th>OrderPriority</th>

            </tr>
        </thead>
        <tbody>
            <% inProgressRadiologyOrders.each { anOrder -> %>
            <tr>
                <td><a id="fillreport" href='+ studyname +' class="fillreport" onclick="displayReport(this); return false;"><p style="display:none;">${ anOrder.orderId }</p>
                        ${anOrder.study.studyname}</a></td>
                <td>${ anOrder.patient.personName } </td>
                <td>${ anOrder.patient.patientIdentifier } </td>
                <td>${ anOrder.dateCreated } </td>
                <td>${ anOrder.urgency }</td>

            </tr>
            <% } %>  
        </tbody>
    </table>
</div>





<div id = "performedStatusInProgressOrderDetail">


</div>

<div id = "patientCompletedOrders">

   
</div>

<div id = "CancepReportUpdatedDiv">

   



    </table>

</div>

<div id="somediv" title="View Study Image" style="display:none;">
    <iframe id="thedialog" width="550" height="350"></iframe>
</div>

<a id="linkForForm" class="linkForForm" value = "?" onclick="loadttt(); return false;"></a>

<div id="dialog-message" title="Important information">

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



<div id="ReportDeletelDialog" style="width:430px" title="reportHTMLForm"> Are you sure you want to delete Report </div>

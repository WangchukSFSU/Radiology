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
 
   jq("#ContactRadiologist").hide(); 
 
 
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
    
    
    function displayReport(el) {
   jq(el).addClass("highlight").css("background-color","#CCCCCC");
   alert("33333");
   
jq("#activeorders").hide();
   jq("#activeorderswithLink").show();
   jq("#orderdetails").show();
   jq('#eee').show();
   
 
   
    jq(el).addClass('selected').siblings().removeClass('selected');  
var value= jq(el).closest('tr').find('td:first').text();
   // var value=jq(el).find('td:first').html();
    
    alert(value); 
    var orderId = parseInt(value, 10);
alert(orderId);
    jq("#performedStatusInProgressOrderDetail").show();
      jq("#performedStatusInProgressOrder").hide();
    var splitvalue = value.split('');
    alert("otertertetete " +splitvalue);
    ordervalue = splitvalue[1];
    alert("ordervalue" +ordervalue);
 
      alert("orderId" +orderId);
      
      
      
     <% if (inProgressRadiologyOrders) { %>
   alert("yess");
    <% inProgressRadiologyOrders.each { anOrder -> %>
    
    var radiologyorderId = ${anOrder.orderId} ;

    if(orderId == radiologyorderId) {
    
    alert("orderId" +orderId);
    
  localStorage.setItem("radiologyorderId", radiologyorderId);


 jq('#performedStatusInProgressOrderDetail').append("<div class='newbox'  id= 'viewstudyid'>RADIOLOGY ORDER DETAILS  :   ${ anOrder.patient.personName }, ${ anOrder.patient.patientIdentifier }, ${anOrder.study.studyname} </div>");
jq('#performedStatusInProgressOrderDetail').append("<div class='nnn'  id= 'nnn'>Provider  :  ${anOrder.creator.username} ,  StartDate  : ${ anOrder.dateCreated } </div>");
 jq('#performedStatusInProgressOrderDetail').append("<div class='newbox'  id= 'viewstudyid'>Diagnosis  : ${anOrder.orderdiagnosis} </div>");
jq('#performedStatusInProgressOrderDetail').append("<div class='nnn'  id= 'nnn'>Instructions  : ${anOrder.instructions} </div>");



jq('#performedStatusInProgressOrderDetail').append("<div class='nnn'  id= 'viewstudyid'><a id = 'tiger' class='tiger' href=${ dicomViewerUrladdress + "studyUID=" + anOrder.study.studyInstanceUid + "&patientID=" + anOrder.patient.patientIdentifier } onclick='loadImages(); return false;'>ViewStudy</a> </div>");


<% if (anOrder.study.orderencounterId) { %>
alert("yess");

<% } else { %>
alert("noooo");


    jq.getJSON('${ ui.actionLink("getForm") }',
    { 'radiologyorderId': radiologyorderId
    })
    .error(function(xhr, status, err) {
    alert('AJAX error ' + err);
    })
    .success(function(ret) {
    alert("succsss");
    for (var i = 0; i < ret.length; i++) {

    var formNameHtmlToDisplay = ret[i].HtmlToDisplay;
    var patientId = ret[i].Patient.PatientId;
    var HtmlFormId = ret[i].HtmlFormId;
    var FormModifiedTimestamp = ret[i].FormModifiedTimestamp;
    var ReturnUrl = ret[i].ReturnUrl;
    
     localStorage.setItem("patientId", patientId);
     localStorage.setItem("HtmlFormId", HtmlFormId);
      localStorage.setItem("FormModifiedTimestamp", FormModifiedTimestamp);
     localStorage.setItem("formNameHtmlToDisplay", formNameHtmlToDisplay);
     
  


     
     
     

    }
    
    
 
    
    
    })
     jq('#performedStatusInProgressOrderDetail').append("<div class='bbb'  id= 'bbb'><a id = 'ttt' class='ttt'  onclick='loadttt(); return false;'>Vttt</a> </div>");

     jq('#linkForForm').text("tsooot");
   jq('#performedStatusInProgressOrderDetail').append(jq('#linkForForm'));

//jq('#performedStatusInProgressOrderDetail').append('<h1>hi</hi>');
     

   
   
<% }  %>


}
  

    
   <% } %>
    <% } %> 
    
    
    
    
    
     
    
    
    
    }
    
 
   
  
    function showReports() {
    alert("show report");
    jq('#showReportsDiv').show();
    var radiologyorderId = localStorage.getItem("radiologyorderId");
    jq('#showReportsDiv').empty();
       jq('#showReportsDiv').append('<table></table>');
    jq('#showReportsDiv table').attr('id','listReportstable');
    jq("#showReportsDiv table").addClass("reporttable");
    var reporttablelistchild = jq('#showReportsDiv table');
    reporttablelistchild.append( '<thead><tr><th>Form</th></tr></thead><tbody>' );
     alert("COOL");
     
       <% if (inProgressRadiologyOrders) { %>
   alert("yess");
    <% inProgressRadiologyOrders.each { anOrder -> %>
    
    var orderId = ${anOrder.orderId} ;

    if(orderId == radiologyorderId) {
    
    alert("orderId" +orderId);
    
     reporttablelistchild.append( '<tr><td><a id="listreport" class="listreport" href="${ domain + anOrder.patient.uuid + visitform + anOrder.study.studyHtmlFormUUID + returnurl }" onclick="fillReport(this.href); return false;" > ${anOrder.study.studyname} </a></td> </tr>' );
  reporttablelistchild.append( '<tr><td><a id="listreportgeneric" class="listreportgeneric" href="${ domain + anOrder.patient.uuid + visitform + anOrder.study.studyGenericHTMLFormUUID + returnurl }" onclick="fillReport(this.href); return false;" > Generic ${anOrder.study.studyname} </a></td> </tr>' );
 
     
     }
     <% } %>
    <% } %> 
     
reporttablelistchild.append("</tbody>");

    
    }
   
</script>
<script>
     jq = jQuery;
       jq(document).ready(function() {
       
       jq("#dialog-message").dialog({
       autoOpen: false,
    modal: false,
    draggable: true,
    resizable: true,
    position: ['center', 'top'],
    show: 'blind',
    hide: 'blind',
    width: 900,
    dialogClass: 'ui-dialog-osx',
    buttons: {
        "I've read and understand this": function() {
            jq(this).dialog("close");
        }
    }
});



  jq(".linkForForm").click(function() {
  alert("jiiji");

 
    });

       
       });
       
         function loadttt() {
    alert("ttt");
      var patientId = localStorage.getItem("patientId");
 var returnUrl = localStorage.getItem("returnUrl");
  var HtmlFormId = localStorage.getItem("HtmlFormId");
   var formModifiedTimestamp = localStorage.getItem("formModifiedTimestamp");
  var formNameHtmlToDisplay = localStorage.getItem("formNameHtmlToDisplay");
  
  alert(formNameHtmlToDisplay);
  jq( "#dialog-message" ).dialog( "open" );
      jq('#personId').val(patientId);
       jq('#htmlFormId').val(HtmlFormId);
       jq('#returnUrl').val(ReturnUrl);
       
      
  jq('input#closeAfterSubmission').after(formNameHtmlToDisplay);
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
            <th>Medical Record Number</th>
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



<div id = "showReportsDiv">
    

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



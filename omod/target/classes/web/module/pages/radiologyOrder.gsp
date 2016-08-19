

<%
ui.decorateWith("appui", "standardEmrPage")

ui.includeJavascript("uicommons", "datatables/jquery.dataTables.min.js")
ui.includeCss("uicommons", "datatables/dataTables_jui.css")
%>
<% ui.includeCss("radiology", "radiologyOrder.css") %>
    
<% ui.includeCss("radiology", "performedStatusCompletedOrder.css") %>
   
<script type="text/javascript">
    var breadcrumbs = [
    { icon: "icon-home", link: '/' + OPENMRS_CONTEXT_PATH + '/index.htm' },
        { label: "${ ui.escapeJs(patient.familyName + ', ' + patient.givenName ) }" , link: '${ui.escapeJs(returnUrl)}'},
    { label: "RadiologyOrder" }

    ];
var ret = "${returnUrl}";
    var x = 1;
</script>

<script>
    jq = jQuery;
    jq(document).ready(function() { 
    jq("#AddRadiologyOrderForm").hide();
    jq("#EmailForm").hide();
    jq("#performedStatusInProgressOrder").hide();
    jq("#performedStatusCompletedObsSelect").hide();
    jq("#HTMLFORM").hide();
    jq("#ContactRadiologist").hide();
    jq("#performedStatusCompletedOrder").show();
    


    jq("#addRadiologyOrderBtn").click(function(){
    jq("#performedStatusCompletedOrder").hide();
    jq("#EmailForm").hide();
    jq("#performedStatusInProgressOrder").hide();
    jq("#performedStatusCompletedObsSelect").hide();
    jq("#ContactRadiologist").hide(); 
    jq("#AddRadiologyOrderForm").show();
    });

    jq("#emailform").click(function(){
    jq("#performedStatusCompletedOrder").hide();
    jq("#performedStatusInProgressOrder").hide();
    jq("#performedStatusCompletedObsSelect").hide();
    jq("#EmailForm").show();
    jq("#AddRadiologyOrderForm").hide();
    jq("#ContactRadiologist").hide(); 
    });


    
   jq("#table tr").click(function(){
    jq(this).addClass('selected').siblings().removeClass('selected');    
    var value=jq(this).find('td:first').html();
    alert(value); 
    var splitvalue = value.split(',');
     jq("#performedStatusCompletedObsSelect").show();
     jq("#performedStatusCompletedOrder").hide();
    ordervalue = splitvalue[0];
   var orderId = ordervalue.substr(8);
     <% if (radiologyOrders) { %>
   
    <% radiologyOrders.each { anOrder -> %>
    
    var radiologyorderId = ${anOrder.orderId} ;
  
    if(orderId == radiologyorderId) {
 
  jq('#completedOrderObs').append( '<tr><td> Observation</td><td> Provider</td><td> Instructions </td><td> Diagnosis</td><td> Study</td><td> ViewStudy</td><td> ContactRadiologist</td></tr>' );
  jq('#completedOrderObs').append( '<tr><td><a onclick="runMyFunction();"> Obs</a> </td><td> ${anOrder.orderer.name}</td><td> ${anOrder.instructions} </td><td> ${anOrder.orderdiagnosis}</td><td> ${anOrder.study.studyname}</td><td> <a>ViewStudy</a></td><td><a onclick="contactRadiologist();"> ContactRadiologist</td></a></tr>' );

  }
    
    
   <% } %>
    <% } %> 
    
 
    
    
    
    
    });
    
    });


function runMyFunction() {
  alert("run my function");
  jq("#HTMLFORM").show(); 
   jq("#ContactRadiologist").hide(); 
 
 
}
function contactRadiologist() {
  alert("run my contactRadiologist");
  jq("#HTMLFORM").hide(); 
  jq("#ContactRadiologist").show();
 
}

    function selectFunction(selectedValue) {

    if(selectedValue == "COMPLETED") {
  
    jq("#performedStatusCompletedOrder").show();
  
    jq("#EmailForm").hide();
    jq("#performedStatusInProgressOrder").hide();
    jq("#AddRadiologyOrderForm").hide();
    jq("#performedStatusCompletedObsSelect").hide();
    
    }  
   
     if(selectedValue == "IN_PROGRESS") {
    
    jq("#performedStatusCompletedOrder").hide();
    jq("#EmailForm").hide();
    jq("#performedStatusInProgressOrder").show();
    jq("#AddRadiologyOrderForm").hide();
    jq("#performedStatusCompletedObsSelect").hide();
    
    
    alert("jiiii progress" + selectedValue);
    } 
    
    }
</script>

<div>
    <div id="performedStatusesDropdown" class="performedStatusesContainer">
        <span>
            <select name="performedStatuses" id="performedStatuses" onchange="selectFunction(this.value)">
                <option name="performedStatuses" selected="selected" value="${performedStatuses.value}">COMPLETED</option>
                <% performedStatuses.each { performedStatuses -> %>
                <option name="performedStatuses" value="${performedStatuses.value}">${performedStatuses.value}</option>
                <% } %>
            </select>        
        </span>

        <span class="right"><button type="button" id="addRadiologyOrderBtn">Add Radiology Order</button></span>
        <span class="right"><button type="button" id="emailform">Message Patient</button></span>

    </div>


   

     <div id="performedStatusInProgressOrder">
        ${ ui.includeFragment("radiology", "performedStatusInProgressOrder",[ returnUrl: '${returnUrl}',
        patient: '${patient}'
        ]) }

    </div>
    

    <div id="AddRadiologyOrderForm">
        ${ ui.includeFragment("radiology", "addRadiologyOrderForm",[ returnUrl: '${returnUrl}',
        patient: '${patient}'
        ]) }
    </div>



    <div id="EmailForm">
        ${ ui.includeFragment("radiology", "contactPatient",[ returnUrl: '${returnUrl}',
        patient: '${patient}'
        ]) }
    </div>


    
    <div id="performedStatusCompletedOrder">
  
<h1>COMPLETED RADIOLOGY ORDERS</h1>
<table id="table">
    <thead>
        <tr>
            <th>Order</th>
            <th>OrderStartDate</th>
            <th>DatePictureTaken</th>
        </tr>
    </thead>
    <% radiologyOrders.each { anOrder -> %>
    <tr>
        <td>orderid#${anOrder.orderId},
            ${anOrder.patient}
            ${anOrder.study.studyname}</td>
        <td>${ anOrder.dateCreated } </td>
        <td></td>

    </tr>
    <% } %>  

</table>
</div>


<div id = "performedStatusCompletedObsSelect">
    
  <h1>RADIOLOGY ORDER OBSERVATION</h1>
  
<table id="completedOrderObs">
   
    

</table>

</div>
    
    <div id="HTMLFORM" width="50%">
        ${ ui.includeFragment("radiology", "reportObs",[ returnUrl: '${returnUrl}',
        patient: '${patient}'
        ]) }
    </div>

       <div id="ContactRadiologist" width="50%">
        ${ ui.includeFragment("radiology", "contactRadiologist",[ returnUrl: '${returnUrl}',
        patient: '${patient}'
        ]) }
    </div>
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
     
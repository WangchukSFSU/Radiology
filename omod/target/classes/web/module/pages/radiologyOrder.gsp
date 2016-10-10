<%
ui.decorateWith("appui", "standardEmrPage")
ui.includeJavascript("uicommons", "datatables/jquery.dataTables.min.js")
ui.includeCss("uicommons", "datatables/dataTables_jui.css")
%>


<% ui.includeCss("radiology", "radiologyOrder.css") %>
    

   



    
<script>
    jq = jQuery;
    jq(document).ready(function() { 

 
    
   
    jq("#orders").hide();
    jq("#messagepatient").hide();
    jq("#addorder").hide();
    jq("#orderdetail").hide();
  
   jq("#performedStatusCompletedReport").hide();
   
    
    jq("#AddRadiologyOrderForm").hide();
    jq("#EmailForm").hide();
    jq("#performedStatusInProgressOrder").hide();
    jq("#performedStatusCompletedObsSelect").hide();
    jq("#HTMLFORM").hide();
    jq("#ContactRadiologist").hide();
    jq("#performedStatusCompletedOrder").show();
    
    jq("#addRadiologyOrderBtn").click(function(){
        jq("#performedStatusesDropdown").hide();
    jq("#performedStatusCompletedOrder").hide();
    jq("#EmailForm").hide();
    jq("#HTMLFORM").hide(); 
    jq("#performedStatusInProgressOrder").hide();
    jq("#performedStatusCompletedObsSelect").hide();
    jq("#ContactRadiologist").hide(); 
    jq("#AddRadiologyOrderForm").show();
    jq("#performedStatusCompletedReport").hide();
    

     
    jq("#ordernolink").hide();
    jq("#orders").show();
   
    jq("#messagepatient").hide();
    jq("#addorder").show();
    jq("#orderdetail").hide();
    });
    
    
    jq("#emailform").click(function(){
    jq("#performedStatusCompletedOrder").hide();
    jq("#performedStatusInProgressOrder").hide();
    jq("#performedStatusCompletedObsSelect").hide();
    jq("#EmailForm").show();
    jq("#AddRadiologyOrderForm").hide();
    jq("#ContactRadiologist").hide(); 
    jq("#HTMLFORM").hide(); 
    jq("#performedStatusCompletedReport").hide(); 

    jq("#performedStatusesDropdown").hide();
    
    
     jq("#ordernolink").hide();
    jq("#orders").show();
   
    jq("#messagepatient").show();
    jq("#addorder").hide();
    jq("#orderdetail").hide();
    });
    
    
     jq('.test').click(function(){
    alert(jq(this).attr('href'));
   
  });
    
    
   jq("#performedStatusCompletedOrderTable tr").click(function(){

   jq("#ordernolink").hide();
    jq("#orders").show();
   
    jq("#messagepatient").hide();
    jq("#addorder").hide();
    jq("#orderdetail").show();
   jq("#HTMLFORM").hide(); 
   jq("#performedStatusCompletedReport").hide();
    jq(this).addClass('selected').siblings().removeClass('selected');    
    var value=jq(this).find('td:first').html();
    alert(value); 
    var splitvalue = value.split('>');
     jq("#performedStatusCompletedObsSelect").show();
     jq("#performedStatusCompletedOrder").hide();
    ordervalue = splitvalue[1];
    alert(ordervalue);
    var orderId= ordervalue.substr(0, ordervalue.indexOf('<'));
   //var orderId = ordervalue.substr(0, 2);
   jq('#completedOrderObs').empty();
  alert(orderId);
     <% if (radiologyOrders) { %>
   
    <% radiologyOrders.each { anOrder -> %>
    
    var radiologyorderId = ${anOrder.orderId} ;
  
    if(orderId == radiologyorderId) {
    
    var orderencounterId = ${anOrder.study.orderencounterId} ;
    
    alert("orderencounterId" + orderencounterId);
localStorage.setItem("orderencounterId", orderencounterId);
 
  jq('#completedOrderObs').append( '<thead><tr><th> Report</th><th> Provider</th><th> Instructions </th><th> Diagnosis</th><th> Study</th><th>ViewStudy</th><th> ContactRadiologist</th></tr></thead>' );


jq('#completedOrderObs').append( '<tbody><tr><td><a onclick="runMyFunction();"> Obs</a> </td><td> ${anOrder.orderer.name}</td><td> ${anOrder.instructions} </td><td> ${anOrder.orderdiagnosis}</td><td>${anOrder.study.studyname}</td><td id="dogdog" href="ddasdas"><a id="tiger" class="tiger" href="${ dicomViewerUrladdress + "studyUID=" + anOrder.study.studyInstanceUid + "&patientID=" + patient.patientIdentifier }" onclick="loadImages(); return false;" >ViewStudy</a></td><td><a onclick="contactRadiologist();"> ContactRadiologist</a></td></tr></tbody>' );
  
}
    
    
   <% } %>
    <% } %> 
    
 jq('#completedOrderObs').dataTable({
            "sPaginationType": "full_numbers",
            "bPaginate": true,
            "bAutoWidth": false,
            "bLengthChange": true,
            "bSort": true,
            "bJQueryUI": true,
             "iDisplayLength": 5,
    
        });
    
    });
    
    });
    
   function loadImages() {
 
        var addressValue = jq('.tiger').attr("href");
        alert(addressValue );
        
         jq("#thedialog").attr('src', jq('.tiger').attr("href"));
        jq("#somediv").dialog({
            width: 400,
            height: 450,
            modal: true,
            close: function () {
                jq("#thedialog").attr('src', "about:blank");
            }
        });
        return false;
        
       
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
    
function runMyFunction() {

 jq("#performedStatusCompletedReport").show();
 var orderencounterId = localStorage.getItem("orderencounterId");
jq('#completedOrderReport').empty();
   jq("#ContactRadiologist").hide(); 

               // jq('#completedOrderReport').append( '<thead><tr><th> Report</th><th> Provider</th></tr></thead>');
    
   <% if (getObs) { %>
   
    <% getObs.each { obs -> %>
    var obsId = ${ obs.personId };
     var obsIdCompare = ${ obs.encounter.id };
   
    if(orderencounterId == obsIdCompare) {
    alert("radiologyorderId");
    alert(orderencounterId);
     alert("obsIdCompare");
    alert(obsIdCompare);

    jq('#completedOrderReport').append( '<tbody><tr><td>${obs.concept.getFullySpecifiedName(Locale.ENGLISH)} </td><td>${obs.valueText}</td></tr></tbody>' );
    
    
   // return false;
    }
    
       <% } %>
    <% } %>
   
   
 
 
}






function contactRadiologist() {
  alert("run my contactRadiologist");
  jq("#HTMLFORM").hide(); 
  jq("#ContactRadiologist").show();
  jq("#performedStatusCompletedReport").hide();
 
}
    function selectFunction(selectedValue) {
   
    jq("#ordernolink").show();
    jq("#orders").hide();
   
    jq("#messagepatient").hide();
    jq("#addorder").hide();
    jq("#orderdetail").hide();
     jq("#ContactRadiologist").hide(); 
    jq("#HTMLFORM").hide();

  
    
    if(selectedValue == "COMPLETED") {
    
    jq("#performedStatusCompletedOrder").show();
  jq("#HTMLFORM").hide(); 
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
    
    jq("#ordernolink").show();
    jq("#orders").hide();
    jq("#messagepatient").hide();
    jq("#addorder").hide();
    jq("#orderdetail").hide();
    
    alert("jiiii progress" + selectedValue);
    } 
    
    }
</script>
<script>
jq = jQuery;
     
jq(function() { 

      jq('#performedStatusCompletedOrderTable').dataTable({
            "sPaginationType": "full_numbers",
            "bPaginate": true,
            "bAutoWidth": false,
            "bLengthChange": true,
            "bSort": true,
            "bJQueryUI": true,
            
             "iDisplayLength": 5,
    "aaSorting": [[ 1, "desc" ]] // Sort by first column descending,
    
            
        });
        
      
       

   
        
      
        
        
        
        
        
});
</script>

   <div class="breadcrumbradiologyorder">
 <ul id="breadcrumbs" class="radiologyorderbreadcrumb">
    <li>
        <a href="/openmrs/index.htm">    
        <i class="icon-home small"></i>  
        </a>       
    </li>
     <li id="patientname">  
         
       <i class="icon-chevron-right link"></i>
         
           <a href="/openmrs/coreapps/clinicianfacing/patient.page?patientId=${patient.person.uuid}&">    
        <i >${patient.familyName + ', ' + patient.givenName}</i>  
        </a> 
        
        
    </li>
     <li id="ordernolink">  
        <i class="icon-chevron-right link"></i>
        Manage Radiology Order         
    </li>
    <li id="orders">
       <i class="icon-chevron-right link"></i>
        <a href="/openmrs/radiology/radiologyOrder.page?patientId=${patient.person.uuid}&returnUrl="> 
        Manage Radiology Order
          </a> 
    </li>
   
    <li id="messagepatient">  
       <i class="icon-chevron-right link"></i>
         Message Patient
    </li>
    <li id="addorder">  
        <i class="icon-chevron-right link"></i>
         Add Radiology Order
         
    </li>
    <li id="orderdetail">  
        <i class="icon-chevron-right link"></i>
         Radiology Order Detail
         
    </li>
   
</ul>
</div>




<div>
    <div id="performedStatusesDropdown" class="performedStatusesContainer">
        <span class="dropdown1">
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
        patient: '${patient}', requireClass: 'Diagnosis'
        ]) }
    </div>



    <div id="EmailForm">
        ${ ui.includeFragment("radiology", "contactPatient",[ returnUrl: '${returnUrl}',
        patient: '${patient}'
        ]) }
    </div>


  


<div id = "performedStatusCompletedObsSelect">
    
  <h1>RADIOLOGY ORDER DETAILS</h1>
  
<table id="completedOrderObs">
   
    

</table>

</div>
    
<div id = "performedStatusCompletedReport">
    
  <h1>RADIOLOGY ORDER REPORT</h1>
  
<table id="completedOrderReport">
   
    

</table>

</div>

    

       <div id="ContactRadiologist" width="50%">
        ${ ui.includeFragment("radiology", "contactRadiologist",[ returnUrl: '${returnUrl}',
        patient: '${patient}'
        ]) }
    </div>
    
    <div id="performedStatusCompletedOrder">
        <h1>COMPLETED RADIOLOGY ORDERS</h1>
    <table id="performedStatusCompletedOrderTable">
    <thead>
        <tr>
            <th>Order</th>
            <th>OrderCompletedDate</th>
            
        </tr>
    </thead>
     <tbody>
    <% radiologyOrders.each { anOrder -> %>
    <tr>
        <td> <p style="display:none;">${ anOrder.orderId }</p>
            ${anOrder.study.studyname}</td>
        <td>${ anOrder.dateCreated } </td>
        

    </tr>
    <% } %>  
</tbody>
</table>
 </div>

  
  <div id="HTMLFORM" width="50%">
        ${ ui.includeFragment("radiology", "reportObs",[ returnUrl: '${returnUrl}',
        patient: '${patient}'
        ]) }
    </div>
        
    
    
    
    
    




<script>
    jq = jQuery;
    
 jq(function(){
 

     jq('a #apple').on('click', function(e){
        e.preventDefault();
         jq('<div/>', {'class':'myDlgClass', 'id':'link-'+( jq(this).index()+1)})
        .html( jq('<iframe/>', {
            'src' :  jq(this).attr('href'),
            'style' :'width:100%; height:100%;border:none;'
        })).appendTo('body')
        .dialog({
            'title' :  jq(this).text(),
            'width' : 400,
            'height' :250,
            buttons: [ { 
                    text: "Close",
                    click: function() {  jq( this ).dialog( "close" ); } 
                } ]
        });
    });
});
    
    </script>



<div id="somediv" title="View Study Image" style="display:none;">
    <iframe id="thedialog" width="350" height="350"></iframe>
</div>







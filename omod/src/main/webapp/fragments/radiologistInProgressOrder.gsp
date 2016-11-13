<% ui.includeCss("radiology", "radiologistInProgressOrder.css") %>
<% ui.includeCss("radiology", "jquery-ui.css") %>
<% ui.includeCss("radiology", "jquery.dataTables.min.css") %>



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
    "aaSorting": [[ 2, "desc" ]] // Sort by first column descending,
    
            
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
      
      jq('#completedOrderObs').empty();
      
     <% if (inProgressRadiologyOrders) { %>
   alert("yess");
    <% inProgressRadiologyOrders.each { anOrder -> %>
    
    var radiologyorderId = ${anOrder.orderId} ;

    if(orderId == radiologyorderId) {
    
    alert("orderId" +orderId);
    
  localStorage.setItem("radiologyorderId", radiologyorderId);

  jq('#completedOrderObs').append( '<thead><tr><th> Report</th><th>Patient Name</th><th> Provider</th><th> Instructions </th><th> Diagnosis</th><th> Study</th><th>ViewStudy</th><th>SubmitObs</th></thead>' );
jq('#completedOrderObs').append( '<tbody><tr><td><a id="fillreportTT" class="fillreportTT"  onclick="showReports(); return false;" >Obs </a></td><td>${ anOrder.patient.personName } </td><td> ${anOrder.creator.username}</td><td> ${anOrder.instructions} </td><td> ${anOrder.orderdiagnosis}</td><td>${anOrder.study.studyname}</td><td id="dogdog" href="ddasdas"><a id="tiger" class="tiger" href="${ dicomViewerUrladdress + "studyUID=" + anOrder.study.studyInstanceUid + "&patientID=" + anOrder.patient.patientIdentifier }" onclick="loadImages(); return false;" >ViewStudy</a></td><td><a href="javascript: void(0)" id="linkActButton" onclick="submitObs(); return false;">Submit</a></td></tr></tbody>' );
  

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
        <td>${ anOrder.dateCreated } </td>
        <td>${ anOrder.urgency }</td>
       
    </tr>
    <% } %>  
</tbody>
</table>
</div>




<div id = "performedStatusInProgressOrderDetail">
    
  <h1>RADIOLOGY ORDER DETAILS</h1>
  
<table id="completedOrderObs">
  
    

</table>

</div>

<div id = "showReportsDiv">
    

</div>
<div id="somedivreport" title="Fill Report" style="display:none;">
    <iframe id="thedialogreport" width="1250" height="550"></iframe>
</div>



<div id="somediv" title="View Study Image" style="display:none;">
    <iframe id="thedialog" width="550" height="350"></iframe>
</div>







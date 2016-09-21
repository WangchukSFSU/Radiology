
<% ui.includeCss("radiology", "radiologistInProgressOrder.css") %>


<script>
    jq = jQuery;
    jq(document).ready(function() {
    
   

    
      jq('#performedStatusInProgressOrderTable').dataTable({
            "sPaginationType": "full_numbers",
            "bPaginate": true,
            "bAutoWidth": false,
            "bLengthChange": true,
            "bSort": true,
            "bJQueryUI": true,
            
             "iDisplayLength": 5,
    "aaSorting": [[ 1, "desc" ]] // Sort by first column descending,
    
            
        });

 jq("#performedStatusInProgressOrderDetail").hide(); 
 
  

    
   jq("#performedStatusInProgressOrderTable tr").click(function(){
   
   
   
   
    jq("#activeorders").html("<li><i ></i><a href='/openmrs/radiology/radiologistActiveOrders.page'> Radiology Active Orders</li>");
jq("#activeorders li i").addClass("icon-chevron-right link");


jq("#orderdetails").html("<li><i ></i> Radiology Order Detail</li>");
jq("#orderdetails li i").addClass("icon-chevron-right link");


   
    jq(this).addClass('selected').siblings().removeClass('selected');    
    var value=jq(this).find('td:first').html();
    alert(value); 
    jq("#performedStatusInProgressOrderDetail").show();
      jq("#performedStatusInProgressOrder").hide();
    var splitvalue = value.split('>');
    
    ordervalue = splitvalue[1];
    alert("ordervalue" +ordervalue);
   var orderId = ordervalue.substr(0, 2);
      alert("orderId" +orderId);
     <% if (inProgressRadiologyOrders) { %>
   
    <% inProgressRadiologyOrders.each { anOrder -> %>
    
    var radiologyorderId = ${anOrder.orderId} ;
  
   
  
    if(orderId == radiologyorderId) {
    alert("NJSDSD " + radiologyorderId);
  localStorage.setItem("radiologyorderId", radiologyorderId);
    
    
    alert("YYEYYEYYEYEE");

  
  jq('#completedOrderObs').append( '<thead><tr><th> Report</th><th> Provider</th><th> Instructions </th><th> Diagnosis</th><th> Study</th><th>ViewStudy</th><th>SubmitObs</th></thead>' );


jq('#completedOrderObs').append( '<tbody><tr><td><a id="fillreport" class="fillreport" href="${anOrder.study.studyreporturl  }" onclick="fillReport(); return false;" >Obs </a></td><td> ${anOrder.creator.username}</td><td> ${anOrder.instructions} </td><td> ${anOrder.orderdiagnosis}</td><td>${anOrder.study.studyname}</td><td id="dogdog" href="ddasdas"><a id="tiger" class="tiger" href="${ dicomViewerUrladdress + "studyUID=" + anOrder.study.studyInstanceUid + "&patientID=" + anOrder.patient.patientIdentifier }" onclick="loadImages(); return false;" >ViewStudy</a></td><td><a href="javascript: void(0)" id="linkActButton" onclick="submitObs(); return false;">Submit</a></td></tr></tbody>' );
  

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
    
    
    
    
    
  
    
    
     
    
 


jq("#test").click(function() {
alert("dsdads");
jq("#somediv").load('/openmrs/radiology/radiologistActiveOrders.page').dialog({modal:true}); 
    });  
    
    
    });

    
  
    function submitObs() {
    
   
 
    alert("YESS");
   var radiologyorderId = localStorage.getItem("radiologyorderId");
   
   alert("radiologyorderId " + radiologyorderId);
   
   jq.ajax({
    type: "POST",
    url: "${ ui.actionLink('updateActiveOrders') }",
    data : { 'radiologyorderId': radiologyorderId},
    cache: false,
    success: function(data){
    
alert("COOL");
    }
    });
   
    }
    
    
    
       function fillReport() {
 
        var addressValue = jq('.fillreport').attr("href");
        alert(addressValue );
        
         jq("#thedialogreport").attr('src', jq('.fillreport').attr("href"));
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
        
        Active Radiology Orders
         
    </li>
    <li id="orderdetails">  
       
         
    </li>
   
</ul>
</div>
    
 


    <div id="performedStatusInProgressOrder">
  
        <h1>ACTIVE RADIOLOGY ORDERS</h1>
<table id="performedStatusInProgressOrderTable">
    <thead>
        <tr>
            <th>Order</th>
            <th>OrderStartDate</th>
            <th>OrderPriority</th>
        </tr>
    </thead>
    <tbody>
    <% inProgressRadiologyOrders.each { anOrder -> %>
    <tr>
        <td><p style="display:none;">${ anOrder.orderId }</p>
            ${anOrder.study.studyname}</td>
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


<div id="somedivreport" title="Fill Report" style="display:none;">
    <iframe id="thedialogreport" width="550" height="350"></iframe>
</div>



<div id="somediv" title="View Study Image" style="display:none;">
    <iframe id="thedialog" width="550" height="350"></iframe>
</div>


















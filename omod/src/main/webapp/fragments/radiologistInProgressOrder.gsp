
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
   
   
    jq("#activeorders").html("<li><i ></i><a href='/openmrs/radiology/radiologistActiveOrders.page'> Active Order</li>");
jq("#activeorders li i").addClass("icon-chevron-right link");


jq("#orderdetails").html("<li><i ></i> Order Detail</li>");
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
   
    
    
    alert("YYEYYEYYEYEE");

  
  jq('#completedOrderObs').append( '<thead><tr><th> Report</th><th> Provider</th><th> Instructions </th><th> Diagnosis</th><th> Study</th><th>Save</th><th>Submit</th></thead>' );


jq('#completedOrderObs').append( '<tbody><tr><td><a href=${ anOrder.study.studyreporturl} >Obs</a></td><td> ${anOrder.orderer.name}</td><td> ${anOrder.instructions} </td><td> ${anOrder.orderdiagnosis}</td><td><a> ${anOrder.study.studyname}</a></td><td><input type="radio"></input></td><td><input type="radio"></input></td></tr></tbody>' );
  

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

function runMyFunction() {
  alert("run my function");
 
   jq("#ContactRadiologist").hide(); 
 
 
}
function contactRadiologist() {
  alert("run my contactRadiologist");
   
  jq("#ContactRadiologist").show();
 
 
}


   
</script>

   <div class="breadcrumbsactiveorders">
 <ul id="breadcrumbs">
    <li>
        <a href="/openmrs/index.htm">    
        <i class="icon-home small"></i>  
        </a>       
    </li>
    <li id="activeorders">
       <i class="icon-chevron-right link"></i>
        
        Active Orders
         
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



     
  
   
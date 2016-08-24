



<script>
    jq = jQuery;
    jq(document).ready(function() { 

 jq("#performedStatusInProgressOrderDetail").hide(); 
  jq("#ContactRadiologist").hide();
   jq("#performedStatusInProgressOrder").show();
  

    
   jq("#table tr").click(function(){
    jq(this).addClass('selected').siblings().removeClass('selected');    
    var value=jq(this).find('td:first').html();
    alert(value); 
    var splitvalue = value.split(',');
    
   jq("#performedStatusInProgressOrderDetail").show(); 
   
  jq("#ContactRadiologist").hide();
  jq("#performedStatusInProgressOrder").show();
   
    ordervalue = splitvalue[0];
   var orderId = ordervalue.substr(8);
     <% if (inProgressRadiologyOrders) { %>
   
    <% inProgressRadiologyOrders.each { anOrder -> %>
    
    var radiologyorderId = ${anOrder.orderId} ;
  
    if(orderId == radiologyorderId) {
 jq('#completedOrderObs').empty();
  jq('#completedOrderObs').append( '<tr><td> Observation</td><td> Provider</td><td> Instructions </td><td> Diagnosis</td><td> Study</td><td> ViewStudy</td><td> ContactRadiologist</td><td>Submit</td></tr>' );
  jq('#completedOrderObs').append( '<tr><td><a onclick="runMyFunction();"> Obs</a> </td><td> ${anOrder.orderer.name}</td><td> ${anOrder.instructions} </td><td> ${anOrder.orderdiagnosis}</td><td> ${anOrder.study.studyname}</td><td> <a>ViewStudy</a></td><td><a onclick="contactRadiologist();"> ContactRadiologist</td></a><td>radio</td></tr>' );

  }
    
    
   <% } %>
    <% } %> 
    
 
    
    
    
    
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


    

    <div id="performedStatusInProgressOrder">
  
        <h1>ACTIVE RADIOLOGY ORDERS</h1>
<table id="table">
    <thead>
        <tr>
            <th>Order</th>
            <th>OrderStartDate</th>
            <th>OrderPriority</th>
        </tr>
    </thead>
    <% inProgressRadiologyOrders.each { anOrder -> %>
    <tr>
        <td>orderid#${anOrder.orderId},
            ${anOrder.patient}
            ${anOrder.study.studyname}</td>
        <td>${ anOrder.dateCreated } </td>
        <td>${ anOrder.urgency }</td>

    </tr>
    <% } %>  

</table>
</div>


<div id = "performedStatusInProgressOrderDetail">
    
  <h1>RADIOLOGY ORDER DETAILS</h1>
  
<table id="completedOrderObs">
   
    

</table>

</div>



       <div id="ContactRadiologist" width="50%">
        ${ ui.includeFragment("radiology", "contactRadiologist",[ returnUrl: '${returnUrl}',
        patient: '${patient}'
        ]) }
    </div>
    
    
   
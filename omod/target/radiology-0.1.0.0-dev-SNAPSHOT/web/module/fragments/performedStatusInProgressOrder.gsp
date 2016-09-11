    
    <script>
jq = jQuery;
 

jq(function() { 

      jq('#performedStatusInprogressOrder').dataTable({
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
    
    
<h1>IN PROGRESS RADIOLOGY ORDERS</h1>
<table id="performedStatusInprogressOrder">
    <thead>
        <tr>
            <th>Order</th>
            <th>OrderStartDate</th>
            <th>OrderStatus</th>
        </tr>
    </thead>
    <% inProgressRadiologyOrders.each { anOrder -> %>
    <tr>
        <td>
            
            ${anOrder.study.studyname}</td>
        <td>${ anOrder.dateCreated } </td>
        <td>${anOrder.study.performedStatus}</td>

    </tr>
    <% } %>  

</table>

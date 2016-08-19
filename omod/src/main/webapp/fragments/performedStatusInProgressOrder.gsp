    
<h1>IN PROGRESS RADIOLOGY ORDERS</h1>
<table id="table">
    <thead>
        <tr>
            <th>Order</th>
            <th>OrderStartDate</th>
            <th>OrderStatus</th>
        </tr>
    </thead>
    <% inProgressRadiologyOrders.each { anOrder -> %>
    <tr>
        <td>orderid#${anOrder.orderId},
            ${anOrder.patient}
            ${anOrder.study.studyname}</td>
        <td>${ anOrder.dateCreated } </td>
        <td>${anOrder.study.scheduledStatus}</td>

    </tr>
    <% } %>  

</table>

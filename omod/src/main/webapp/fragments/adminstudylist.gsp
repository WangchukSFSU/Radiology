
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
   
    
            
        });

 
        
        
    });
   
</script>

  

        

 
 
 


    <div id="performedStatusInProgressOrder">
  
       
<table id="performedStatusInProgressOrderTable">
    <thead>
        <tr>
            <th>Studies Available</th>
           
           
        </tr>
    </thead>
    <tbody>
     
   <% modalityconceptnamelist.each { modalityname -> %>
    <tr>
        <td>
            ${modalityname}</td>
       
       

    </tr>
    <% } %>  
</tbody>
</table>
</div>






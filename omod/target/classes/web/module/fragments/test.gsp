
<% ui.includeCss("radiology", "radiologistInProgressOrder.css") %>







<script>
    jq = jQuery;
    jq(document).ready(function() {
    
   
jq("#deletebtn").live ('click', function ()
 {
 
    jq(this).closest ('tr').remove();
 });
    
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
            <th>Studies</th>
            <th>Report Available</th>
           
           
           
        </tr>
    </thead>
    <tbody>
     
   <% modalityconceptnamelist.each { modalityname -> %>
    <tr>
        <td>
            ${modalityname.studyName}</td>
         <td>
             <a href='+ ${modalityname.studyReporturl} +'>  ${modalityname.studyName} </a> 
           </td>
           
        
       
       

    </tr>
    <% } %>  
</tbody>
</table>
</div>






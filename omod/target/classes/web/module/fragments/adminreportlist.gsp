
<% ui.includeCss("radiology", "radiologistInProgressOrder.css") %>







<script>
    jq = jQuery;
    jq(document).ready(function() {
    
   
jq("#deletebtn").live ('click', function ()
 {
    jq(this).closest ('tr').remove ();
 });
    
      jq('#performedStatusInProgressOrderTableReport').dataTable({
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

  

        

 
 
 


    <div id="performedStatusInProgressOrderReport">
  
       
<table id="performedStatusInProgressOrderTableReport">
    <thead>
        <tr>
            <th>Studies</th>
            <th>Report Available</th>
            <th>Action</th>
           
           
        </tr>
    </thead>
    <tbody>
     
   <% liststudystudy.each { modalityname -> %>
    <tr>
        <td>
            ${modalityname.studyName}</td>
         <td>
             <a href='+ ${modalityname.studyReporturl} +'>  ${modalityname.studyName} </a> 
           </td>
           
           <td>
               <a id="editbtn" href='+ ${modalityname.studyReporturl} +'><img  class="img-circle" src=" ${ ui.resourceLink ("/images/ic_edit_black_24dp.png") }"/></a>  
               </td>
       
       

    </tr>
    
    
    <% } %> 

 
    
    
</tbody>
</table>
</div>






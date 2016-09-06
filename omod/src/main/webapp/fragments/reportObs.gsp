  

<script>
jq = jQuery;
 

        
        


      jq('#reportObsTable').dataTable({
            "sPaginationType": "full_numbers",
            "bPaginate": true,
            "bAutoWidth": false,
            "bLengthChange": true,
            "bSort": true,
            "bJQueryUI": true,
 
    
            
        });
        
      
       

   
        
      
        
        
        
        
        

</script>


<h1>RADIOLOGY ORDER REPORT</h1>
<table id="reportObsTable">
    
    <% getObs.each { observation -> %>
    <tr>
        <td>${observation.concept.getFullySpecifiedName(Locale.ENGLISH)}</td>
  <td>${observation.valueText}</td>
          
      

    </tr>
    <% } %>  

</table>

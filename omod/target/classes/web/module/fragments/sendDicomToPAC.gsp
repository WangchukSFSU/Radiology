<script>
    jq = jQuery;
    jq(document).ready(function() {
    
    

   
    
    
     jq("#clearmessage").click(function(){
    
      jq("#message").val('');
 
    });
    
     jq("#sendEmail").click(function(){     

   jq.ajax({
    type: "POST",
    url: "${ ui.actionLink('sendDicomToPACS') }",
    data : { },
    cache: false,
    success: function(data){
    
    alert("Sent email");
  
    }
   });
     });
    });
    
    </script>  

<center>
        <h1>Send Dicom To PAC System</h1>
        <form method = "POST" >
            <table border="0" width="80%">
          
    <thead>
        <tr>
            <th>Dicom Files From Modality</th>
           
        </tr>
    </thead>
    <tbody>
    <% apo.each { apoo -> %>
    <tr>
     
        <td>${ apoo }</td>

    </tr>
    <% } %>  
    
    <tr>
                    <td colspan="2" align="center">
                        <input type="submit" id ="sendEmail" value="Send " />
                      
                    </td>
                </tr>
    
</tbody>
</table>
        </form>
    </center>

   
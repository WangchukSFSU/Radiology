<script>
    jq = jQuery;
    jq(document).ready(function() {
    
    jq("#cancelmessage").click(function(){
    alert("canel");
          jq("#message").val('');
     
 
    });
    
     jq("#sendEmail").click(function(){     
var recipient = jq("#recipient").val();
var  subject = jq("#subject").val();
 
var  message = jq("#message").val();
   jq.ajax({
    type: "POST",
    url: "${ ui.actionLink('sendEmailToPatient') }",
    data : { 'recipient': recipient, 'subject': subject, 'message': message},
    cache: false,
    success: function(data){
    
    alert("Sent email");
  
    }
   });
     });
    });
    
    </script>  

<center>
        <h1>CONTACT PATIENT</h1>
        
            <table border="0" width="80%">
                <tr>
                    <td>To:</td>
                    <td><input type="text" id ="recipient"  name="recipient" size="65" value=" ${patientemailaddress}" /></td>
                </tr>
                <tr>
                    <td>Subject:</td>

                    <td><input type="text" id ="subject" name="subject" size="65" value=" ${subject}" /></td>
                </tr>
                <tr>
                    <td>Message:</td>
                    <td><textarea cols="50" id ="message" rows="10" name="message">


                        </textarea></td>
                </tr>               
                <tr>
                    <td colspan="2" align="center">
                        <input type="submit" id ="sendEmail" value="Send E-mail" />
                        <input  class="fields2" id="cancelmessage" type="button" value="Cancel" />
                    </td>
                </tr>
            </table>
       
    </center>
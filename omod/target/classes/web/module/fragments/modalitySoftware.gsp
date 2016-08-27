
<% ui.includeCss("radiology", "modalitySoftware.css") %>
<% ui.includeJavascript("jquery.js") %>
<% ui.includeJavascript("jquery-ui.js") %>
<% ui.includeJavascript("jquery-ui.css") %>



 

      
<script>
    jq = jQuery;
  jq(document).ready(function() {
  
 
   jq(document).on('click', '#softwareavailablehelp', function() { 

    alert("IMPORTANT NOTES FOR CREATING CONCEPT:"+"\\n"+"1) Select modality as class from the dropdown menu."+"\\n"+ "2) Select text as datatype from the dropdown menu." );
    
    });
    
   
            jq( "#dialog-2" ).dialog({
               autoOpen: false, 
               buttons: {
                  OK: function() {jq(this).dialog("close");}
               },
               title: "Software Modality Availability",
               position: {
                  my: "left center",
                  at: "left center"
               }
            });
            jq( "#opener-2" ).click(function() {
               jq( "#dialog-2" ).dialog( "open" );
            });
       
         
         
        });
</script>


<div class="modality-header" >    
    <label id=modality-label for modality-software> <h2>Modality Software Availability :</h2> </label>
    <input type="radio" name="modality-sofware" id="modality" value="Modality Software Available">  
    <label id=modality-label for modality-software-available> Yes </label>
    <input type="radio" name="modality-sofware" id="modality" value="Modality Software Not Available">
    <label id=modality-label for modality-software-unavailable> No </label>
     <input type="button" id="opener-2" class="opener-2" value = "?" >
</div>

<br>

<div id="dialog-2" title="Software Modality Availability">If the software connecting the modality to the PACS system is available then selects “Yes”. <br> If the software connecting the modality to the PACS system is not available then selects “No”. </div>
      
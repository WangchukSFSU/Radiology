
<% ui.includeCss("radiology", "modalitySoftware.css") %>

<script>
    jq = jQuery;
  jq(document).ready(function() {
  jq("#modalitysoftwareavailablehelp").hide();
  
jq("#modalitysoftwareavailable").click(function(){
jq("#modalitysoftwareavailablehelp").show();
});
  
});
    
    
    </script>



<div class="modality-header" >    
    <label id=modality-label for modality-software> <h2>Modality Software Availability :</h2> </label>
    <input type="button" id="modalitysoftwareavailable" class="modalitysoftwareavailable" value = "?" >
    
    <div id="modalitysoftwareavailablehelp">
<select name="modalitysoftwareavailabledropdown" id="modalitysoftwareavailabledropdown" onchange="studyFunction(this.value)">
             <option name="modalitysoftwareavailableyesno" selected="selected" value="modalitysoftwareavailableyesno">Select One</option>
          <option value="Yes">Yes</option>
  <option value="No">No</option>
        </select>  
        </div>
 </div>
 
  

</div>

<br>

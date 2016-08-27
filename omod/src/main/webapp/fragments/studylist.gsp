<% ui.includeCss("radiology", "modalitylist.css") %>
<% ui.includeJavascript("jquery.js") %>





<div id ="modalitySoftware"  >
${ ui.includeFragment("radiology", "modalitySoftware") }
</div>


<div class="modality">
    <div class="form-group">
    <label id="modality-concept-message" for modality-concept-label> Please Add Modality not appearing in list to Concept Dictionary and Refresh: <a id="modalityconceptmessage" href="http://localhost:8080/openmrs/dictionary/concept.form"> Click here to Concept Dictionary </a></label>
    <input type="button" id="modalityhelp" class="modalityhelp" value = "?" >
    <input type="button" name="modality-refresh" onclick="location.href='/openmrs/pages/radiology/adminInitialize.page'" id="modality-refresh" value="Refresh">
     
</div>

  </div>
  
  


<script>
   jq = jQuery;
    jq(document).ready(function() {
   
jq("#deletebtn").live ('click', function ()
 {
    jq(this).closest ('tr').remove ();
 });


 
 jq("#continuebtn").click(function() {
   alert("continue");
});



jq("#Savebtn").click(function() {
var arr = [];
jq("#tableformodality tr").each(function(){
    arr.push(jq(this).find("td:first").text());
});
for (i=0;i<arr.length;i++)
{
alert(arr[i]);

}
arr.shift();
jq.ajax({
    type: "POST",
    url: "${ ui.actionLink('saveModality') }",
    data : { modalityList: arr },
    cache: false,
    success: function(data){
 alert("Modality Saved");
    }
    });



}); 


});


    
    </script>
    
<div id="modalitytable">
<table id="tableformodality">
    <thead>
        <tr>
            <th>Modalities available</th>
         
            <th>Action</th>
        </tr>
    </thead>
   <% modalityconceptnamelist.each { modalityname -> %>
  
    <tr>
        <td> 
            ${modalityname}
            </td>
            
       
        <td><input type="button" id="deletebtn" value="Delete" >
            </td>

    </tr>
  
    <% } %>

</table>
<div class="modalitybtn">
<input type="button" id="Savebtn" value="Save" >
<input type="button" id="continuebtn" value="Continue" >

</div>

</div>
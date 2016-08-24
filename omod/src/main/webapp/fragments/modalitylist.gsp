<% ui.includeCss("radiology", "modalitylist.css") %>
<% ui.includeJavascript("jquery.js") %>


<script>
    jq = jQuery;
    jq(document).ready(function() {
   
    jq(document).on('click', '#modalityhelp', function() { 

    alert("IMPORTANT NOTES FOR CREATING CONCEPT:"+"\\n"+"1) A concept must have at least one fully-specified name."+"\\n"+ "2) A concept description must be clear and concise."+"\\n"+ "3) Select modality as class from the dropdown menu."+"\\n"+ "4) Select text as datatype from the dropdown menu." );
    
    });
    
    
   jq(document).on('click', '.save-report', function() {      
       saverReport = [];
   jq('#unorderedlist li input:checked').each(function() {
    saverReport.push(jq(this).val());
    });
  
   
    jq.ajax({
    type: "POST",
    url: "${ ui.actionLink('saveReport') }",
    data : { reportList: saverReport },
    cache: false,
    success: function(data){
  
    }
    });
    });
    
    
    
    
    
    
    jq(document).on('click', '.delete-report', function() {
  
    
    jq('#unorderedlist li input:checkbox[name=studyList]').each(function() {
    
    jq(this).parent().remove();
 
    });
    });
    
    
      jq(document).on('click', '.select-report', function() {
    
    jq('div#modality-label-list li input:checkbox[name=studyList]').each(function() 
    {    
    if(jq(this).is(':checked')){
    myFunction(jq(this).val());
    }
    });
    });
    
    jq(document).on('click', '.modality-help', function() {
    alert("IMPORTANT NOTES FOR CREATING REPORT:"+"\\n"+"1) Create new HTML form."+"\\n"+ "2) Create Radiology encounter type ."+"\\n"+ "3) Get the relavent HTML source code from radreport.org based on the study ."+"\\n"+ "4) Create concepts for all the observations."+"\\n"+ "5) Update the HTML source code with all the concepts and click save to generate HTML Form for the study ." );
    
    
    });
    
    
    jq(document).on('click', '.save-study', function() {
    var resultSave=jq('input[name="studyList"]:checked');
   if(resultSave.length > 0) {
    saveStudy = [];
    
    resultSave.each(function() {
    saveStudy.push(jq(this).val());
    });
   alert("SASASASASAS" + saveStudy);
    }
    else {
    alert("Nothing is checked");
    }
    
    jq.ajax({
    type: "POST",
    url: "${ ui.actionLink('saveStudy') }",
    data : { studyList: saveStudy },
    cache: false,
    success: function(data){
    
    alert("SAVE STUDY");
    
    jq("#modality-list").empty();
    jq("#modality-list").html("Studies"); 
   jq("#modalityhelp").hide();
    jq('.modalityhelp').after(jq('<input type="button" class = "modality-help" value="?">'));
    jq("#modalityconceptmessage").text("Please Create Reports not appearing in the list then refresh");
     jq("#modalityconceptmessage").attr("href", "http://localhost:8080/openmrs/module/htmlformentry/htmlForms.list");
    jq("#delete-modality").empty();
    jq("#delete-modality").val("Select Study to View Report"); 
    jq("#delete-modality").removeClass('select-modality').addClass('select-report');
    jq("#view-study").empty();
    jq("#view-study").val("Delete Selected Reports"); 
    jq("#view-study").removeClass('delete-study').addClass('delete-report');
    jq("#Save").empty();
    jq("#Save").val("Save Report"); 
    jq("#Save").removeClass('save-study').addClass('save-report');
    jq("#modality-label-list").empty();
 jq('#unorderedlist li :checked').closest('li').appendTo('#modality-label-list');
 jq("#header ul").empty();
   jq('input:checkbox[name=studyList]').each(function() 
    {    
    if(jq(this).is(':checked')){
    
    myFunction(jq(this).val());
    }
    });
 
 
 
    }
    });
    });
  
  
    jq(document).on('click', '.delete-study', function() {
   
    var resultDelete=jq('input[name="studyList"]:checked');
  if(resultDelete.length > 0) {
    resultDelete.each(function() {
    jq(this).parent().remove();
    });
   
    }
    else {
    alert("Nothing is checked");
    }
    });
    jq(document).on('click', '.select-modality', function() {
    jq('input:checkbox[name=modlist]').each(function() 
    {    
    if(jq(this).is(':checked')){
    myFunction(jq(this).val());
    }
    });
    });
    jq(document).on('click', '.view-study', function() {
    if(jq('#Save').data('clicked')) {
    jq("#modalitySoftware").hide();
   
    jq("#modalityconceptmessage").text("Please add studies not appearing in list to concept dictionary then refresh");
    jq('input:checkbox[name=modlist]').each(function() 
    {    
    if(jq(this).is(':checked')){
    jq("#delete-modality").empty();
    jq("#delete-modality").val("Select Modality to View Study"); 
    jq("#delete-modality").removeClass('delete-modality').addClass('select-modality');
    jq("#view-study").empty();
    jq("#view-study").val("Delete Selected Studies"); 
    jq("#view-study").removeClass('view-study').addClass('delete-study');
    jq("#Save").empty();
    jq("#Save").val("Save Study"); 
    jq("#Save").removeClass('Save').addClass('save-study');
    myFunction(jq(this).val());
    }
    });
    }
    else
    {
    alert("Please Click Save Modality");
    
  
         
    }
    });
    function myFunction(selectedValue) {
 alert("SSSSSSSSSS TTTT"+selectedValue);
    if (selectedValue != "empty") {
        jq.getJSON('${ ui.actionLink("getStudyConcepts") }',
    {
    'studyconceptclass': selectedValue
    })
    .error(function(xhr, status, err) {
    alert('AJAX error ' + err);
    })
    .success(function(ret) {
    jq("#header ul").empty();
    for (var i = 0; i < ret.length; i++) {
    var conId = ret[i].conceptId;
    var conName = ret[i].displayString;
jq("#header ul").append(jq("<li>").html('<input type="checkbox"  value="' + conId + '" name="studyList" id="id' + i + '"><label for="id' + i + '">' + conName + '</label>'));
    }
    });
    }
    };
    });
</script>



<script> 
    jq(function() {
    jq(document).ready(function() {
    jq(document).on('click', '.delete-modality', function() {
    var resultDelete=jq('input[type="checkbox"]:checked');
    if(resultDelete.length > 0) {
    resultDelete.each(function() {
    jq(this).parent().remove();
    });
    }
    else {
    alert("Nothing is checked");
    }
    });
    
    
    jq(document).on('click', '.Save', function() { 
    alert("uuuuuu");
    jq(this).data('clicked', true);
    var resultSave=jq('input[type="checkbox"]:checked');
    
   if(resultSave.length > 0) {
   alert("Please select one");
    saveModality = [];
    resultSave.each(function() {
    saveModality.push(jq(this).val());
    });
  
    var resultDeletet=jq("input:checkbox:not(:checked)");
    if(resultDeletet.length > 0) {

 resultDeletet.each(function() {
 
    jq(this).parent().remove();
    });

}
    
  
    
    
    
    
    
    }
    else {
    alert("Nothing is checked");
    }
    jq.ajax({
    type: "POST",
    url: "${ ui.actionLink('saveModality') }",
    data : { modalityList: saveModality },
    cache: false,
    success: function(data){
 
    }
    });
    });
    });
    });
</script>

<div id ="modalitySoftware"  >
${ ui.includeFragment("radiology", "modalitySoftware") }
</div>


<div class="modality">
    <label id="modality-concept-message" for modality-concept-label> Please add Modality not appearing in list to concept dictionary and refresh: <a id="modalityconceptmessage" href="http://localhost:8080/openmrs/dictionary/concept.form"> Click here to Concept Dictionary </a></label>
    <input type="button" name="modality-refresh" onclick="location.href='/openmrs/pages/radiology/adminInitialize.page'" id="modality-refresh" value="Refresh">
 <input type="button" id="modalityhelp" class="modalityhelp" value = "?" >

    <label id="modality-list" for modality-check> Modalities available </label>
    
    
    <div class="list-modality">
        <div id="modality-label-list" style="width:50%; float:left">
            <% modality_list.each { modalityname -> %>
            <label class="checkbox">
                <input id="modlist" name ="modlist" value="$modalityname"  type="checkbox">  ${ ui.format(modalityname) } 
                <input type="hidden" name="modlist" >  </label>
            <br>
            <% } %>
        </div>

        <div id="header" style="width:50%; float:right">  
            <ul id="unorderedlist">

            </ul>
        </div>

        <div class="modality-list-btn">

            <input type="button" name="delete-modality" class="delete-modality" id="delete-modality" value="Delete Selected Modality">
            <input type="submit" id="Save" class="Save" value="Save Modality">
            <input type="button" name="view-study" class="view-study" id="view-study" value="View Studies">
        </div>
    </div>

    
  
 



<script>
   jq = jQuery;
    jq(document).ready(function() {
    
jq("#deletebtn").live ('click', function ()
 {
    jq(this).closest ('tr').remove ();
 });


 
 jq('button').click(function() {
    jq(this).parent().siblings(':first').each(function() {
        alert('index ' + this.cellIndex + ': ' + jq(this).text());
    });
});
 

});


    
    </script>
<h1>Modality list</h1>
<table id="table">
    <thead>
        <tr>
            <th>Name</th>
            <th>Description</th>
            <th>Action</th>
        </tr>
    </thead>
   <% aps.each { modalitylist -> %>
  
    <tr>
        <td> 
            ${modalitylist.key}
            </td>
            
        <td> ${modalitylist.value}  
             </td>
        <td><input type="button" id="deletebtn" value="Delete" >
            <button>Save</button></td>

    </tr>
  
    <% } %>

</table>

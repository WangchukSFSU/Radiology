<% ui.includeCss("radiology", "modalitylist.css") %>
<% ui.includeJavascript("jquery.js") %>


<script>
    jq = jQuery;
    jq(document).ready(function() {
   
    
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
    jq("#modality-concept-message").empty();
    jq("#modality-concept-message").text("Please Create Reports not appearing in the list then refresh");
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
    
    jq("#modality-concept-message").empty();
    jq("#modality-concept-message").text("Please add studies not appearing in list to concept dictionary then refresh");
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
    jq(this).data('clicked', true);
    var resultSave=jq('input[type="checkbox"]:checked');
   if(resultSave.length > 0) {
    saveModality = [];
    resultSave.each(function() {
    saveModality.push(jq(this).val());
    });
  
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


<div class="modality">

    <label id="modality-list" for modality-check> Modalities </label>
    <label id="modality-concept-message" for modality-concept-label> Please add Modality not appearing in list to concept dictionary and refresh  </label>
    <input type="button" name="modality-refresh" onclick="location.href='/openmrs/pages/radiology/adminInitialize.page'" id="modality-refresh" value="Refresh">

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

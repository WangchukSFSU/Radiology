<% ui.includeCss("radiology", "modalitylist.css") %>

<% ui.includeJavascript("jquery.js") %>
<% ui.includeJavascript("jquery-ui.js") %>
<% ui.includeJavascript("jquery-ui.css") %>

<script>
    jq = jQuery;
    jq(document).ready(function() {
   
    jq(document).on('click', '#modalityhelp', function() { 

    alert("IMPORTANT NOTES FOR CREATING CONCEPT:"+"\\n"+"1) Select modality as class from the dropdown menu."+"\\n"+ "2) Select text as datatype from the dropdown menu." );
    
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


  
  


<script>
   jq = jQuery;
    jq(document).ready(function() {
   jq("#items").hide();
    jq(".studygroup").hide();
  jq(".studybtn").hide();
  jq(".breadcrumbs").show();
 jq(".reportgroup").hide();
   jq(".reportbtn").hide();
   
      jq( "#modalityConceptDictionaryNotes" ).dialog({
               autoOpen: false, 
               buttons: {
                  OK: function() {jq(this).dialog("close");}
               },
               title: "Concept Dictionary",
               position: {
                  my: "left center",
                  at: "left center"
               }
            });
            jq( "#modalityConceptDictionary" ).click(function() {
               jq( "#modalityConceptDictionaryNotes" ).dialog( "open" );
            });
   
   
   
    jq( "#continuetext" ).dialog({
               autoOpen: false, 
               buttons: {
                  OK: function() {jq(this).dialog("close");}
               },
               title: "Important Message",
               position: {
                  my: "left center",
                  at: "left center"
               }
            });
   
            
              jq( "#studycontinuetext" ).dialog({
               autoOpen: false, 
               buttons: {
                  OK: function() {jq(this).dialog("close");}
               },
               title: "Important Message",
               position: {
                  my: "left center",
                  at: "left center"
               }
            });
            
                  jq( "#studysaved" ).dialog({
               autoOpen: false, 
               buttons: {
                  OK: function() {jq(this).dialog("close");}
               },
               title: "Important Message",
               position: {
                  my: "left center",
                  at: "left center"
               }
            });
            
                  jq( "#modalitysaved" ).dialog({
               autoOpen: false, 
               buttons: {
                  OK: function() {jq(this).dialog("close");}
               },
               title: "Important Message",
               position: {
                  my: "left center",
                  at: "left center"
               }
            });
            
             
                  jq( "#reportsaved" ).dialog({
               autoOpen: false, 
               buttons: {
                  OK: function() {jq(this).dialog("close");}
               },
               title: "Important Message",
               position: {
                  my: "left center",
                  at: "left center"
               }
            });
   
    jq( "#studyconceptmessage" ).dialog({
               autoOpen: false, 
               buttons: {
                  OK: function() {jq(this).dialog("close");}
               },
               title: "Concept Dictionary",
               position: {
                  my: "left center",
                  at: "left center"
               }
            });
    
       jq( "#reportHTMLFormMessage" ).dialog({
               autoOpen: false, 
               buttons: {
                  OK: function() {jq(this).dialog("close");}
               },
               title: "HTMLForm",
               position: {
                  my: "left center",
                  at: "left center"
               }
            });       
            
            
            
jq("#deletebtn").live ('click', function ()
 {
    jq(this).closest ('tr').remove ();
 });

  jq("#studyrefresh").click(function() { 
  alert("zzzzzzz");
  
  var selected = jq( "#selectlabtest1 option:selected" ).text();
  jq("#dynamictable tr").remove();
   myFunctionT(selected);
 
  });
 
 jq("#reportrefresh").click(function() { 
  alert("zzzzzzz");
  
  var selected = jq( "#selectlabtest1 option:selected" ).text();
  jq("#dynamictable tr").remove();
   myFunctionT(selected);
 
  });
  
 jq("#continuebtn").click(function() {
  
jq(this).data('clicked', true);
 
 if(jq('#Savebtn').data('clicked')) {

   jq("#modalitySoftware").hide();
  jq("#items").show();
jq(".studygroup").show();
jq(".modality").hide();
jq(".studybtn").show(); 
  jq(".modalitybtn").hide();
  
  
 
  
  

 jq("#manageradiology").html("<li><i ></i><a href='/openmrs/radiology/adminInitialize.page'> Manage Radiology Module</li>");
jq("#manageradiology li i").addClass("icon-chevron-right link");


jq("#managestudy").html("<li><i ></i> Add Study</li>");
jq("#managestudy li i").addClass("icon-chevron-right link");




  
   
   
     var arr = [];
jq("#tableformodality tr").each(function(){
    arr.push(jq(this).find("td:first").text());
});

var arrayfirst = arr[1];



myFunctionT(arrayfirst);

for (var i=1;i<arr.length;i++){

   jq('<option/>').val(arr[i]).html(arr[i]).appendTo('#items select');
}
 
 } 
 
 else {
 
 
           
               jq( "#continuetext" ).dialog( "open" );
        
            
            
 }
   
});





jq("#studycontinuebtn").click(function() {
  jq(this).data('clicked', true);
 if(jq('#studysavebtn').data('clicked')) {
 alert("YES");
 jq("#modalitySoftware").hide();
  
jq(".studygroup").hide();
jq(".modality").hide();
jq(".studybtn").hide(); 
  jq(".modalitybtn").hide();
  jq(".reportgroup").show();
  jq(".reportbtn").show();
  
  jq("#selectlabtest1").empty();

 
jq("#managestudy").html("<li><i ></i> Add Report</li>");
jq("#managestudy li i").addClass("icon-chevron-right link");



     
     var arr = [];
jq("#dynamictable table tr").each(function(){
    arr.push(jq(this).find("td:first").text());
});

var arrayfirst = arr[1];
alert("POTPOTPOTPOT "+arrayfirst);


myFunctionT(arrayfirst);

for (var i=1;i<arr.length;i++){

  alert(arr[i]);
  
  jq('<option/>').val(arr[i]).html(arr[i]).appendTo('#items select');
}
 
 } 




 else {
 jq( "#studycontinuetext" ).dialog( "open" );
 
 }
 
 });

 

 
  jq("#reportsavebtn").click(function() { 
 
 
 var arr = [];
jq("#dynamictable tr").each(function(){
    arr.push(jq(this).find("td:first").text());
});
for (i=0;i<arr.length;i++)
{
alert(arr[i]);

}

arr.shift();

jq.ajax({
    type: "POST",
    url: "${ ui.actionLink('saveReport') }",
    data : { reportList: arr },
    cache: false,
    success: function(data){




 jq( "#reportsaved" ).dialog( "open" );
 }
 });
 
 });
 
 
 
 
 jq("#studysavebtn").click(function() { 
 jq(this).data('clicked', true);
 
 var arr = [];
jq("#dynamictable tr").each(function(){
    arr.push(jq(this).find("td:first").text());
});
for (i=0;i<arr.length;i++)
{
alert(arr[i]);

}

arr.shift();

jq.ajax({
    type: "POST",
    url: "${ ui.actionLink('saveStudy') }",
    data : { studyList: arr },
    cache: false,
    success: function(data){




 jq( "#studysaved" ).dialog( "open" );
 }
 });
 
 });
 
 
jq("#reportHTMLForm").click(function() {

jq( "#reportHTMLFormMessage" ).dialog( "open" );


});

jq("#studyConceptDictionary").click(function() {

jq( "#studyconceptmessage" ).dialog( "open" );


});


jq("#Savebtn").click(function() {
  jq(this).data('clicked', true);
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
    
 jq( "#modalitysaved" ).dialog( "open" );
    }
    });



}); 


});

function myFunctionT(selectedValue) {

 
  jq.getJSON('${ ui.actionLink("getStudyConcepts") }',
           {
             'studyconceptclass': selectedValue
            })
       .error(function(xhr, status, err) {
            alert('AJAX error ' + err);
        })
        .success(function(ret) {
                  alert("goog"); 
var tablemodality = document.getElementById("tableformodality");
                                for (var i = tablemodality.rows.length; i > 0; i--) {
                                    document.getElementById("tableformodality").deleteRow(i - 1);
                                }

if(jq('#continuebtn').data('clicked')){
alert("inside study conitnueeeeee");
jq('#dynamictable').empty();
jq('#dynamictable').append('<table></table>');
jq("#dynamictable table").addClass("studyclass");
var table = jq('#dynamictable').children();    
table.append("<tr><td>Studies available</td><td>Action</td></tr>");

}

if(jq('#studycontinuebtn').data('clicked')){
alert("inside report conitnueeeeee");
jq('#dynamictable').empty();
jq('#dynamictable').append('<table></table>');
jq("#dynamictable table").addClass("studyclass");
var table = jq('#dynamictable').children();    
table.append("<tr><td>Report available</td><td>Action</td></tr>");

}



alert("ret.length" + ret.length);
            for (var i = 0; i < ret.length; i++) {
            var conId = ret[i].conceptId;
            var conName = ret[i].displayString;
 

table.append( '<tr><td>' +  conName + '</td> <td><input type="button" id="deletebtn" value="Delete" > </td></tr>' );

}

});

 }
    
    </script>
    
    
    
    
    
    
   <div class="breadcrumbs">
 <ul id="breadcrumbs">
    <li>
        <a href="/openmrs/index.htm">    
        <i class="icon-home small"></i>  
        </a>       
    </li>
    <li>
       <i class="icon-chevron-right link"></i>
        <a href="/openmrs/coreapps/systemadministration/systemAdministration.page"> 
        System Administration
        </a>   
    </li>
    <li id="manageradiology">  
        <i class="icon-chevron-right link"></i>
        Manage Radiology Module   
    </li>
     <li id="managestudy"> 
         </li>
         <li id="managereport"> 
         </li>
</ul>
</div>
        






    <div id ="modalitySoftware"  >
${ ui.includeFragment("radiology", "modalitySoftware") }
</div>






<div class="modality">
    <div class="form-group">
    <label id="modality-concept-message" for modality-concept-label> Please Add Modality not appearing in list to Concept Dictionary and Refresh: <a id="modalityconceptmessage" href="http://localhost:8080/openmrs/dictionary/concept.form"> Click here to Concept Dictionary </a></label>
    <input type="button" id="modalityConceptDictionary" class="modalityConceptDictionary" value = "?" >
    <input type="button" name="modality-refresh" onclick="location.href='/openmrs/pages/radiology/adminInitialize.page'" id="modality-refresh" value="Refresh">
     
     </div>
</div>


<div class="studygroup">
    <div class="form-group">
    <label id="study-concept-message" for modality-concept-label> Select Modality from the dropdown to show the studies available. Please Add Study not appearing in list to Concept Dictionary and Refresh: <a id="modalityconceptmessage" href="http://localhost:8080/openmrs/dictionary/concept.form"> Click here to Concept Dictionary </a></label>
    <input type="button" id="studyConceptDictionary" class="studyConceptDictionary" value = "?" >
    <input type="button" name="studyrefresh" id="studyrefresh" value="Refresh">
     
     </div>
</div>

<div class="reportgroup">
    <div class="form-group">
    <label id="report-concept-message" for report-concept-label> Select Study from the dropdown to show the reports available. Please Create Report not appearing in list and Refresh: <a id="modalityconceptmessage" href="http://localhost:8080/openmrs/module/htmlformentry/htmlForm.form"> Click here to create HTMLForm  </a></label>
    <input type="button" id="reportHTMLForm" class="reportHTMLForm" value = "?" >
    <input type="button" name="reportrefresh" id="reportrefresh" value="Refresh">
     
     </div>
</div>


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

<div id='items' style="width:36%; height:234px; margin-top: 24px; float:left">
 
  <select name="labtest" id="selectlabtest1" onchange="myFunctionT(this.value)">
 
  </select>
</div>

 <div id="dynamictable" style="width:64%; float:right">  
       
 </div>

<div class="modalitybtn">
<input type="button" id="Savebtn" class="Savebtn" value="Save" >
<input type="button" id="continuebtn" class="continuebtn" value="Continue" >

</div>

<div class="studybtn">
<input type="button" id="studysavebtn" class="studysavebtn" value="Save" >
<input type="button" id="studycontinuebtn" class="studycontinuebtn" value="Continue" >
</div>

<div class="reportbtn">
<input type="button" id="reportsavebtn" class="reportsavebtn" value="Save" >

</div>



<div id="modalityConceptDictionaryNotes" title="Modality Concept Dictionary Notes">IMPORTANT NOTES FOR CREATING CONCEPT: <br> 1) Select modality as class from the dropdown menu.<br> 2) Select text as datatype from the dropdown menu. </div>
  <div id="continuetext" title="Continue">  Please Click Save to save the modality before continue </div>
 <div id="studyconceptmessage" title="studyconceptmessage"> IMPORTANT NOTES FOR CREATING CONCEPT: <br> 1) Select modality study as class from the dropdown menu. <br> 2) Select text as datatype from the dropdown menu." </div>
<div id="studycontinuetext" title="Continue">  Please Click Save to save the study before continue </div>
<div id="modalitysaved" title="Continue">  Modality Saved </div>
<div id="studysaved" title="Continue">  Study Saved </div>
<div id="reportHTMLFormMessage" title="reportHTMLForm"> HOW TO CREATE HTMLFORM: <br> 1) Select Radiology Order Encounter type. <br> 2) Select an HTML source code based on the study from http://www.radreport.org. <br> 3)All the observations are stored in concepts therefore create concepts for each observation. <br> 4) Save the uuid of the HTML Form created with the study " </div>
<div id="reportsaved" title="Continue">  Report Saved </div>



<% ui.includeCss("radiology", "addRadiologyOrderForm.css") %>

 
<script>
jq = jQuery;
  jq(document).ready(function() {
  jq("#diagnosislistSelect").hide();
  jq("#studySelect").hide();
  
jq("#diagnosisnamebtn").click(function(){
jq("#diagnosislistSelect").show();


});
  
jq("#studybtn").click(function(){
jq("#studySelect").show();
});
});

function diagnosislistFunction(diagnosis) {
var text = jq('#diagnosisname');
        text.val(diagnosis);
}

function studyFunction(study) {

var text = jq('#studyname');
        text.val(study);
}


function autoCompleteStudy(study){

var study = study.slice(1, -1);
 var list = study.split(',');

    console.log(list);
    
    jq("#studyname").autocomplete({
       source : list
    });
    
  
}


function autoCompleteDiagnosis(diagnosis){
 var list = diagnosis.split(',');
    console.log(list);
    
    jq("#diagnosisname").autocomplete({
       source : list
    });
}

</script>

<script>
    jq = jQuery;
    jq(document).ready(function() {

     jq("#submitForm").click(function(){     

 var pat = "${patient}".split("#");
     var patient = pat[1];

var modalityOrder = jq('select[name=modalityConceptName]').val();
var  studyOrder = jq("#studyname").val();
 
var  diagnosisOrder = jq("#diagnosisname").val();
var  instructionOrder = jq("#orderInstruction").val();
var priorityOrder = jq('select[name=priority]').val();

alert("Sutyd " + studyOrder);
   jq.ajax({
    type: "POST",
    url: "${ ui.actionLink('placeRadiologyOrder') }",
    data : { 'patient': patient, 'modalityname': modalityOrder, 'studyname': studyOrder, 'diagnosisname': diagnosisOrder, 'instructionname':instructionOrder, 'priorityname':priorityOrder},
    cache: false,
    success: function(data){
    
  
    jq("#studyname").val('');
    jq("#diagnosisname").val('');
    jq("#orderInstruction").val('');
    
    alert("JOJOJOJOJ");
  
    }
   });
     });
    });
    
    </script>
    



     
 <div class="fields"><label>Modality </label>
  <span>
        <select name="modalityConceptName" id="modalityConceptName">
             <option name="modalityConceptName" selected="selected" value="modalityName">Select One</option>
           <% modalityConceptNameList.each { modalityName -> %>
                <option name="modalityConceptName" value="$modalityName">${modalityName}</option>
            <% } %>
        </select>        
        </span>
</div>


 <div class="fields"><label>Study </label>
<input id="studyname" type="text" autocomplete="on" oninput="autoCompleteStudy('${studyConceptNameList}')" name="studyname"/>
<input id="studybtn" type="button" value="?" />

<div id="studySelect">
<select name="studyConceptNameList" id="studyConceptNameList" onchange="studyFunction(this.value)">
             <option name="studyConceptNameList" selected="selected" value="studyConceptNameList">Select One</option>
           <% studyConceptNameList.each { studyConceptNameList -> %>
                <option name="studyConceptNameList" value="$studyConceptNameList">${studyConceptNameList}</option>
            <% } %>
        </select>  
        </div>
 </div>



 <div class="fields"><label>Diagnosis </label>
<input id="diagnosisname" type="text" autocomplete="on" oninput="autoCompleteDiagnosis('${diagnosislist}')" name="diagnosisname"/>
<input id="diagnosisnamebtn" type="button" value="?" />

<div id="diagnosislistSelect">
<select name="diagnosislist" id="diagnosislist" onchange="diagnosislistFunction(this.value)">
             <option name="diagnosislist" selected="selected" value="diagnosislist">Select One</option>
           <% diagnosislist.each { diagnosislist -> %>
                <option name="diagnosislist" value="$diagnosislist">${diagnosislist}</option>
            <% } %>
        </select>  
        </div>
 </div>

 
 <div class="fields"><label>Instruction </label>
<input id="orderInstruction" type="text" name="orderInstruction"/>
</div>


 <div class="fields"><label>Priority </label>
  <span>
        <select name="priority" id="priority"">
             <option name="priority" selected="selected" value="priority">Select One</option>
           <% urgencies.each { urgencies -> %>
                <option name="priority" value="$urgencies">${urgencies}</option>
            <% } %>
        </select>        
        </span>
</div>

<input class="fields" id="submitForm" type="button" value="Submit" />



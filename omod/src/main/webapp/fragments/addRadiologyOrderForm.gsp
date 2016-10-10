<% ui.includeCss("radiology", "addRadiologyOrderForm.css") %>

   
      <!-- Javascript -->
 
<script>
jq = jQuery;
  jq(document).ready(function() {
  
  
  
       jq( "#ordersaved" ).dialog({
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
            
            
  jq("#diagnosislistSelect").hide();
  jq("#studySelect").hide();
  
jq("#diagnosisnamebtn").click(function(){
jq("#diagnosislistSelect").show();
});
  
jq("#studybtn").click(function(){
jq("#studySelect").show();
});
});
function modalityFunction(selectedvalue) {
alert("innnn");
jq.getJSON('${ ui.actionLink("getStudyConceptsAnswerFromModality") }',
           {
             'modalityselected': selectedvalue
            })
       .error(function(xhr, status, err) {
            alert('AJAX error ' + err);
        })
        .success(function(ret) {
                  alert("googd"); 
 jq('#studyConceptNameList').empty();
            
             jq("#studyConceptNameList").append('<option >Select one</option>');
             
           
  var availableTutorials = [
               
            ];
  
alert("ret.length KKKKKK" + ret.length);
            for (var i = 0; i < ret.length; i++) {
            var conId = ret[i].id;
             var conName = ret[i].studyName;
            var conNameReporturl = ret[i].studyReporturl;
            
            alert("conId" + conId);
             alert("conName" + conName);
           
           availableTutorials.push(conName);
            
             jq("#studyConceptNameList").append('<option >'+ conName +'</option>');
             
             }
             autoCompleteStudy(availableTutorials);
             
        });     
      
             
}
function diagnosislistFunction(diagnosis) {
var text = jq('#diagnosisname');
        text.val(diagnosis);
}
function studyFunction(study) {
var text = jq('#studyname');
        text.val(study);
}
function autoCompleteStudy(study){
alert("9999999"+study);
//var study = study.slice(1, -1);
//alert("55555555"+study);
 var list = study.toString().split(",");
 alert("333333333"+list);
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
    
    
    jq("#cancelForm").click(function(){
    
      jq("#studyname").val('');
    jq("#diagnosisname").val('');
    jq("#orderInstruction").val('');
    });
    
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
    
    jq( "#ordersaved" ).dialog( "open" );
  
  location.reload();
    
    alert("JOJOJOJOJ");
    
     
  
    }
   });
     });
    });
    
    </script>
    



     
 


 <div class="fields"><label for="automplete-2">Study </label>
<input id="studyname" type="text" autocomplete="on" name="studyname"/>
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
     <textarea  name="orderInstruction" id="orderInstruction" rows="1" cols="50">  </textarea>

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
<input class="fields" id="cancelForm" type="button" value="Cancel" />
<div id="ordersaved" title="Continue">  Order Saved </div>












 

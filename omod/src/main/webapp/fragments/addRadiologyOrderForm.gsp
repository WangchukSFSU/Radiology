<% ui.includeCss("radiology", "addRadiologyOrderForm.css") %>
<%
 
    def conceptStudyClass = config.requireStudyClass
    
%>
<%
 
    def conceptDiagnosisClass = config.requireDiagnosisClass
    
%>
   
      <!-- Javascript -->
   <script>
  jq( function() {
    jq( "#studytags" ).autocomplete({
      source: function( request, response ) {
        var results = [];
        jq.getJSON('${ ui.actionLink("getStudyAutocomplete") }',
            {
              'query': request.term, 
              'conceptStudyClass': "<%= conceptStudyClass %>"
            })
        .success(function(data) {
            for (index in data) {
                var item = data[index];
                results.push(item.name);
                }
            response( results );
        })
       .error(function(xhr, status, err) {
            alert('AJAX error ' + err);
        });
      }
    } )
    
    
        jq( "#diagnosistags" ).autocomplete({
      source: function( request, response ) {
        var results = [];
        jq.getJSON('${ ui.actionLink("getDiagnosisAutocomplete") }',
            {
              'query': request.term, 
              'conceptDiagnosisClass': "<%= conceptDiagnosisClass %>"
            })
        .success(function(data) {
            for (index in data) {
                var item = data[index];
                results.push(item.name);
                }
            response( results );
        })
       .error(function(xhr, status, err) {
            alert('AJAX error ' + err);
        });
      }
    } )
});
  </script>
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
    
    jq("#ordersaved").hide();
    jq("#cancelForm").click(function(){
    
      jq("#studytags").val('');
    jq("#diagnosistags").val('');
    jq("#orderInstruction").val('');
    });
    
     jq("#submitForm").click(function(){     
 var pat = "${patient}".split("#");
     var patient = pat[1];
//var modalityOrder = jq('select[name=modalityConceptName]').val();
var  studyOrder = jq("#studytags").val();
 
var  diagnosisOrder = jq("#diagnosistags").val();
var  instructionOrder = jq("#orderInstruction").val();
var priorityOrder = jq('select[name=priority]').val();
alert("Sutyd " + studyOrder);
   jq.ajax({
    type: "POST",
    url: "${ ui.actionLink('placeRadiologyOrder') }",
    data : { 'patient': patient, 'studyname': studyOrder, 'diagnosisname': diagnosisOrder, 'instructionname':instructionOrder, 'priorityname':priorityOrder},
    cache: false,
    success: function(data){
    
    jq( "#ordersaved" ).show();
  
  location.reload();
    
    alert("JOJOJOJOJ");
    
     
  
    }
   });
     });
    });
    
    </script>
    


<div id="ordersaved" title="Continue">  Order Saved </div>
     
 
<h2> ADD RADIOLOGY ORDER</h2>

<div class="studyfieldclass">
  <label for="tags">Study </label>
  <input id="studytags">
</div>


<div class="fieldclass">
  <label for="tags">Diagnosis </label>
  <input id="diagnosistags">
</div>


 
 <div class="fieldclass"><label>Instruction </label>
     <textarea  name="orderInstruction" id="orderInstruction" rows="1" cols="50">  </textarea>

</div>


 <div class="fieldclass"><label>Priority </label>
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




















 

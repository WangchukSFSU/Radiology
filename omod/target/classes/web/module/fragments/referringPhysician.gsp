


<% ui.includeCss("radiology", "radiologyOrder.css") %>
 <% ui.includeCss("radiology", "referringphysician.css") %>
 <% ui.includeCss("radiology", "jquery-ui.css") %>
<% ui.includeCss("radiology", "jquery.dataTables.min.css") %>
<%
 
    def conceptStudyClass = config.requireStudyClass
    
%>
<%
 
    def conceptDiagnosisClass = config.requireDiagnosisClass
    
%>   

   

<script>
    jq = jQuery;
    jq(document).ready(function() { 

 
    
   
    jq("#orders").hide();
    jq("#messagepatient").hide();
    jq("#addorder").hide();
    jq("#orderdetail").hide();
  
   jq("#performedStatusCompletedReport").hide();
    jq("#SentConfirmation").hide();
    
    jq("#AddRadiologyOrderForm").hide();
    jq("#EmailForm").hide();
    jq("#performedStatusInProgressOrder").hide();
    jq("#performedStatusCompletedObsSelect").hide();
    jq("#HTMLFORM").hide();
    jq("#ContactRadiologist").hide();
    jq("#performedStatusCompletedOrder").show();
    
    
    
    
    
    
    jq("#addRadiologyOrderBtn").click(function(){
  
        jq("#performedStatusesDropdown").hide();
    jq("#performedStatusCompletedOrder").hide();
    jq("#EmailForm").hide();
    jq("#HTMLFORM").hide(); 
    jq("#performedStatusInProgressOrder").hide();
    jq("#performedStatusCompletedObsSelect").hide();
  
    jq("#AddRadiologyOrderForm").show();
    jq("#performedStatusCompletedReport").hide();
    jq("#studytags").val(''); 
 jq("#diagnosistags").val('');
 jq("#orderInstruction").val('');
    
    
     
    jq("#ordernolink").hide();
    jq("#orders").show();
   
    jq("#messagepatient").hide();
    jq("#addorder").show();
    jq("#orderdetail").hide();
    });
    
    
    jq("#emailform").click(function(){
    
    jq("#performedStatusCompletedOrder").hide();
    jq("#performedStatusInProgressOrder").hide();
    jq("#performedStatusCompletedObsSelect").hide();
    jq("#EmailForm").show();
    jq("#AddRadiologyOrderForm").hide();
    jq("#ContactRadiologist").hide(); 
    jq("#HTMLFORM").hide(); 
    jq("#performedStatusCompletedReport").hide(); 

    jq("#performedStatusesDropdown").hide();
    
    jq("#message").val('');
     jq("#ordernolink").hide();
    jq("#orders").show();
   
    jq("#messagepatient").show();
    jq("#addorder").hide();
    jq("#orderdetail").hide();
    });
    
    
     jq('.test').click(function(){
    alert(jq(this).attr('href'));
   
  });
    
    
   jq("#performedStatusCompletedOrderTable tr").click(function(){

   jq("#ordernolink").hide();
    jq("#orders").show();
   
    jq("#messagepatient").hide();
    jq("#addorder").hide();
    jq("#orderdetail").show();
   jq("#HTMLFORM").hide(); 
   jq("#performedStatusCompletedReport").hide();
    jq(this).addClass('selected').siblings().removeClass('selected');    
    var value=jq(this).find('td:first').html();
    alert(value); 
    var splitvalue = value.split('>');
     jq("#performedStatusCompletedObsSelect").show();
     jq("#performedStatusCompletedOrder").hide();
     
     jq("#performedStatusesDropdown > h1").remove();
     

    ordervalue = splitvalue[1];
    alert(ordervalue);
    var orderId= ordervalue.substr(0, ordervalue.indexOf('<'));
   //var orderId = ordervalue.substr(0, 2);
   jq('#completedOrderObs').empty();
  alert(orderId);
     <% if (radiologyOrders) { %>
   
    <% radiologyOrders.each { anOrder -> %>
    
    var radiologyorderId = ${anOrder.orderId} ;
  
    if(orderId == radiologyorderId) {
    
    var orderencounterId = ${anOrder.study.orderencounterId} ;
    
    jq('#performedStatusCompletedObsSelect').append("<h1 class='order'  id= 'orderDetailHeading'>RADIOLOGY ORDER DETAILS - CompletedDate :   ${ anOrder.dateCreated }  </h1>");
     jq('#performedStatusCompletedObsSelect').append( jq('#completedOrderObs'));
    alert("orderencounterId" + orderencounterId);
localStorage.setItem("orderencounterId", orderencounterId);
 localStorage.setItem("orderId", orderId);
  jq('#completedOrderObs').append( '<thead><tr><th> Report</th><th> Radiologist</th><th> Instructions </th><th> Diagnosis</th><th> Study</th><th>ViewStudy</th><th> ContactRadiologist</th></tr></thead>' );


jq('#completedOrderObs').append( '<tbody><tr><td><a onclick="runMyFunction();"> Obs</a> </td><td> ${anOrder.orderer.name}</td><td> ${anOrder.instructions} </td><td> ${anOrder.orderdiagnosis}</td><td>${anOrder.study.studyname}</td><td id="dogdog" href="ddasdas"><a id="tiger" class="tiger" href="${ dicomViewerUrladdress + "studyUID=" + anOrder.study.studyInstanceUid + "&patientID=" + patient.patientIdentifier }" onclick="loadImages(); return false;" >ViewStudy</a></td><td><a onclick="contactRadiologist();"> ContactRadiologist</a></td></tr></tbody>' );
  
}
    
    
   <% } %>
    <% } %> 
    

    
    });
    
    
     jq("#clearmessage").click(function(){
     alert("111111 ");

    
    
       jq('#contactRadiologistDialogBox').dialog('close');

 
    });
    
     jq("#sendEmailRadiologist").click(function(){     
var recipient = jq("#recipientRadiologist").val();
var  subject = jq("#subjectRadiologist").val();
 alert(subject);
 
var  message = jq("#messageRadiologist").val();
alert(message);
   jq.ajax({
    type: "POST",
    url: "${ ui.actionLink('sendEmailToRadiologistA') }",
    data : { 'recipient': recipient, 'subject': subject, 'message': message},
    cache: false,
    success: function(data){
  
    
   
    alert("999ppp");
    jq('#contactRadiologistDialogBox').dialog('close');
     jq( "<h1>Email sent successfully</h1>" ).insertBefore( jq('#performedStatusCompletedObsSelect h1') );
    
    }
 
   });
    
   
   
     });
    
    
    
    });
    
   function loadImages() {
 alert("addressValue" );
        var addressValue = jq('.tiger').attr("href");
        alert(addressValue );
        
         jq("#thedialog").attr('src', jq('.tiger').attr("href"));
        jq("#somediv").dialog({
            width: 400,
            height: 450,
            modal: true,
            close: function () {
                jq("#thedialog").attr('src', "about:blank");
            }
        });
        return false;
        
       
   }
    
     function openDialog(url)    {
 jq('#breadcrumbs').remove();
        jq('<div/>').dialog({
            modal: true,
            open: function ()
            {
            if (jq(this).is(':empty')) {
                jq(this).load(url);
                }
            },         
            height: 600,
            width: 950,
            title:"Report"
        });
        
        
    }
    
function runMyFunction() {


 var orderencounterId = localStorage.getItem("orderencounterId");
 

jq.getJSON('${ ui.actionLink("getEncounterIdObs") }',
    { 'encounterId': orderencounterId
    })
    .error(function(xhr, status, err) {
    alert('AJAX error ' + err);
    })
    .success(function(ret) {
    
    jq('#obsDialogBoxText').append('<table></table>');
    jq('#obsDialogBoxText table').attr('id','obsDialogBoxTextDatatable');
    jq("#obsDialogBoxText table").addClass("obsDialogBoxTextclass");
    var obsDialogBoxTextTable = jq('#obsDialogBoxText table');
    obsDialogBoxTextTable.append( '<thead><tr><th>Concept</th><th>Value Text</th></tr></thead><tbody>' );
   
for (var i = 0; i < ret.length; i++) {
    var concept = ret[i].Concept;
    var valueText = ret[i].valueText;
    alert("concept");
    alert(concept);
    
    
    obsDialogBoxTextTable.append( '<tr><td>'+ concept +'</td><td>'+ valueText +'</td></tr>' );

    
    }
    obsDialogBoxTextTable.append("</tbody>");
    jq( "#obsDialogBox" ).dialog( "open" );

    })
    

   
   
 
 
}




function contactRadiologist() {
  alert("run my contactRadiologist");
  jq("#HTMLFORM").hide(); 
  jq("#ContactRadiologist").show();
  jq("#performedStatusCompletedReport").hide();
  var orderId = localStorage.getItem("orderId");
  alert("orderId" + orderId);
  jq('#messageRadiologist').val('foobar');
  
  
 
   
    <% radiologyOrders.each { anOrder -> %>
    
    var radiologyorderId = ${anOrder.orderId} ;
   // var radiologyorderinstructions = ${anOrder.instructions}; 
   // var radiologyorderdiagnosis = ${anOrder.orderdiagnosis};
    //var radiologyorderstudyname = ${anOrder.study.studyname};
  
    if(orderId == radiologyorderId) {
    
    jq('#messageRadiologist').val('StudyName  :');
  jq('#messageRadiologist').val(jq('#messageRadiologist').val() + '${anOrder.study.studyname}');
  jq('#messageRadiologist').val(jq('#messageRadiologist').val() + "\\r");
  jq('#messageRadiologist').val(jq('#messageRadiologist').val() + 'Diagnosis   :');
    jq('#messageRadiologist').val(jq('#messageRadiologist').val() + '${anOrder.orderdiagnosis}');
    jq('#messageRadiologist').val(jq('#messageRadiologist').val() + "\\r");
    jq('#messageRadiologist').val(jq('#messageRadiologist').val() + 'Instruction   :');
   jq('#messageRadiologist').val(jq('#messageRadiologist').val() + '${anOrder.instructions}');

    
    }
    
    <% } %>
 jq( "#contactRadiologistDialogBox" ).dialog( "open" );
}
    
</script>

    

<script>
jq = jQuery;
     
jq(function() { 

      jq('#performedStatusCompletedOrderTable').dataTable({
            "sPaginationType": "full_numbers",
            "bPaginate": true,
            "bAutoWidth": false,
            "bLengthChange": true,
            "bSort": true,
            "bJQueryUI": true,
            
             "iDisplayLength": 5,
    "aaSorting": [[ 2, "desc" ]] // Sort by first column descending,
    
            
        });
        
      
       

   
        
      
        
        
        
        
        
});
</script>

   
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
    
    jq("#cancelmessage").click(function(){
    alert("canel");
          location.reload();
     
 
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
    
     //jq("#orders").hide();
    jq("#messagepatient").hide();
    jq("#orders").show();
    jq("#orderlink").hide();
    
   
    alert("000000000");
    
    jq("#EmailForm").hide();
   
    jq("#performedStatusesDropdown").show();
    jq("#performedStatusesDropdown").children("h1").remove();
    jq("<h1></h1>").text("Email sent successfully").appendTo('#performedStatusesDropdown');
    jq("#AddRadiologyOrderForm").hide();
   
    jq("#performedStatusInProgressOrder").hide();
    jq("#performedStatusCompletedObsSelect").hide();
    
    jq("#ContactRadiologist").hide();
    jq("#performedStatusCompletedOrder").show();
  
    }
   });
     });
    });
    
    </script> 
<script>
    jq = jQuery;
    jq(document).ready(function() {
    
    jq("#ordersaved").hide();
    jq("#cancelForm").click(function(){
    
      location.reload();
    });
    
     jq("#InProgressOrdersList").click(function(){
    
    alert("InProgressOrdersList");
     jq("#performedStatusCompletedOrder").hide();
     jq("#performedStatusInProgressOrder").show();
     jq("#performedStatusesDropdown").children("h1").remove();
    
     jq("#performedStatusCompletedObsSelect").hide();
    
    });
    
    
    jq("#contactRadiologistDialogBox").dialog({
autoOpen: false,
              modal: false,
             title: 'Contact Radiologist',
             width: 550,
             height: 350,
        

        });
        
    jq("#obsDialogBox").dialog({
autoOpen: false,
              modal: false,
             title: 'View Report',
             width: 550,
             height: 350,
            buttons : {
             
        "Ok": function () { 
           
            jq(this).dialog('close'); 
         }
            },

        });
    
    jq("#CompletedOrdersList").click(function(){
    
    alert("CompletedOrdersList");
     jq("#performedStatusCompletedOrder").show();
     jq("#performedStatusInProgressOrder").hide();
     jq("#performedStatusesDropdown").children("h1").remove();
    
     jq("#performedStatusCompletedObsSelect").hide();
     
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

jq.getJSON('${ ui.actionLink("placeRadiologyOrder") }',
    { 'patient': patient, 'studyname': studyOrder, 'diagnosisname': diagnosisOrder, 'instructionname':instructionOrder, 'priorityname':priorityOrder
    })
    .error(function(xhr, status, err) {
    alert('AJAX error ' + err);
    })
    .success(function(ret) {

  //jq("#orders").hide();
    jq("#messagepatient").hide();
    jq("#addorder").hide();
    jq("#orderdetail").hide();
    
   
    alert("000000000");
    
    jq("#performedStatusCompletedReport").hide();
   
    jq("#performedStatusesDropdown").show();
    jq("#performedStatusesDropdown").children("h1").remove();
    jq("<h1></h1>").text("Radiology order sent successfully").appendTo('#performedStatusesDropdown');
    jq("#AddRadiologyOrderForm").hide();
    jq("#EmailForm").hide();
    jq("#performedStatusInProgressOrder").hide();
    jq("#performedStatusCompletedObsSelect").hide();
    jq("#HTMLFORM").hide();
    jq("#ContactRadiologist").hide();
    jq("#performedStatusCompletedOrder").show();
    
    
     
  
    })
   });
     });
 
    
    </script>
  

   <div class="breadcrumbradiologyorder">
 <ul id="breadcrumbs" class="radiologyorderbreadcrumb">
    <li>
        <a href="/openmrs/index.htm">    
        <i class="icon-home small"></i>  
        </a>       
    </li>
     <li id="patientname">  
         
       <i class="icon-chevron-right link"></i>
         
           <a href="/openmrs/coreapps/clinicianfacing/patient.page?patientId=${patient.person.uuid}&">    
        <i >${patient.familyName + ', ' + patient.givenName}</i>  
        </a> 
        
        
    </li>
     <li id="ordernolink">  
        <i class="icon-chevron-right link"></i>
        Manage Radiology Order         
    </li>
    <li id="orders">
       <i class="icon-chevron-right link"></i>
        <a href="/openmrs/radiology/radiologyOrder.page?patientId=${patient.person.uuid}&returnUrl="> 
        Manage Radiology Order
          </a> 
    </li>
   
    <li id="messagepatient">  
       <i class="icon-chevron-right link"></i>
         Message Patient
    </li>
    <li id="addorder">  
        <i class="icon-chevron-right link"></i>
         Add Radiology Order
         
    </li>
    <li id="orderdetail">  
        <i class="icon-chevron-right link"></i>
         Radiology Order Detail
         
    </li>
   
</ul>
</div>




<div id="completedOrderlist">
    <div id="performedStatusesDropdown" class="performedStatusesContainer">
        
        <span class="left"><button type="button" id="CompletedOrdersList">Completed</button></span>
        <span class="left"><button type="button" id="InProgressOrdersList">InProgress</button></span>
        <span class="right"><button type="button" id="addRadiologyOrderBtn">Add Radiology Order</button></span>
        <span class="right"><button type="button" id="emailform">Message Patient</button></span>

    </div>

    <div id="performedStatusCompletedOrder">
        <div id="SentConfirmation">  <h1> Send </h1> </div>
        <h1>COMPLETED RADIOLOGY ORDERS</h1>
    <table id="performedStatusCompletedOrderTable">
    <thead>
        <tr>
            <th>Order</th>
            <th>Radiologist</th>
            <th>OrderCompletedDate</th>
            
        </tr>
    </thead>
     <tbody>
    <% radiologyOrders.each { anOrder -> %>
    <tr>
        <td> <p style="display:none;">${ anOrder.orderId }</p>
            ${anOrder.study.studyname}</td>
        <td> ${anOrder.orderer.name}</td>
        <td>${ anOrder.dateCreated } </td>
        

    </tr>
    <% } %>  
</tbody>
</table>
 </div>
       

     <div id="performedStatusInProgressOrder">
        ${ ui.includeFragment("radiology", "performedStatusInProgressOrder") }

    </div>
  

  



    <div id="EmailForm">
       <center>
        <h1>CONTACT PATIENT</h1>
        
            <table border="0" width="80%">
                <tr>
                    <td>To:</td>
                    <td><input type="text" id ="recipient"  name="recipient" size="65" value=" ${patientemailaddress}" /></td>
                </tr>
                <tr>
                    <td>Subject:</td>

                    <td><input type="text" id ="subject" name="subject" size="65" value=" ${subjectPatient}" /></td>
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
    </div>


    


<div id = "performedStatusCompletedObsSelect">
    
 
<table id="completedOrderObs">
   
    

</table>

</div>
    
<div id = "performedStatusCompletedReport">
    
  <h1>RADIOLOGY ORDER REPORT</h1>
  
<table id="completedOrderReport">
   
    

</table>

</div>

</div>

    

 
    


  
  <div id="HTMLFORM" width="50%">
        ${ ui.includeFragment("radiology", "reportObs",[ returnUrl: '${returnUrl}',
        patient: '${patient}'
        ]) }
    </div>
        
    
<div id="somediv" title="View Study Image" style="display:none;">
    <iframe id="thedialog" width="550" height="350"></iframe>
</div>
    
      <div id="AddRadiologyOrderForm">
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

        
    </div>

    
    
    
   
    
    
    
    <div id="obsDialogBox" title="View Obs" style="display:none;">
    <div id="obsDialogBoxText" width="550" height="350"></div>
</div>
    

 <div id="contactRadiologistDialogBox" title="ContactRadiologist" style="display:none;">
    <div id="ContactRadiologist" width="550" height="350"></div>

           <center>
        <h1>CONTACT RADIOLOGIST</h1>
       
            <table border="0" width="80%">
                <tr>
                    <td>To:</td>
                    <td><input type="text" id ="recipientRadiologist"  name="recipient" size="65" value =" radiologistemailaddress" /></td>
                </tr>
                <tr>
                    <td>Subject:</td>

                    <td><input type="text" id ="subjectRadiologist" name="subject" size="65" value=" ${subject}"/></td>
                </tr>
                <tr>
                    <td>Message:</td>
                    <td><textarea cols="50" id ="messageRadiologist" rows="10" name="message">
                        </textarea></td>
                </tr>               
                <tr>
                    <td colspan="2" align="center">
                        <input type="submit" id ="sendEmailRadiologist" value="Send E-mail" />
                        <input class="fields" id="clearmessage" type="button" value="Cancel" />
                    </td>
                </tr>
            </table>
     
    </center>
    </div>



  


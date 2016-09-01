<% ui.includeCss("radiology", "modalitylist.css") %>

<% ui.includeJavascript("jquery.js") %>
<% ui.includeJavascript("jquery-ui.js") %>




<script>
   jq = jQuery;
   
  
    jq(document).ready(function() {
    
   
    
   jq("#items").hide();
    jq(".studygroup").hide();
  jq(".studybtn").hide();
  jq(".breadcrumbs").show();
 jq(".reportgroup").hide();
   jq(".reportbtn").hide();
   jq("#reportsavebtn").hide();
   
   jq("#modalityselect").hide();

   jq("#reportmodalityselect").hide();
   jq("#reportstudyselect").hide();
   jq("#reporttable").hide();
 
   


   
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
               title: "USER GUIDE",
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
  
  jq(this).data('clicked', true);
  alert("zzzzzzz");
  
  var selected = jq( "#selectlabtest1 option:selected" ).text();
  jq("#dynamictable tr").remove();
   myFunctionT(selected);
 
  });
 
 jq("#reportrefresh").click(function() { 
 
 jq(this).data('clicked', true);
 jq("#studycontinuebtn").click();
  alert("zzzzzzz");
  
  //var selected = jq( "#reportstudyselectdropdown option:selected" ).text();
  //jq("#dynamictable tr").remove();
   //myFunctionT(selected);
 
  });
  
 jq("#continuebtn").click(function() {
  
jq(this).data('clicked', true);
 
 if(jq('#Savebtn').data('clicked')) {
 
alert("CLCICLCLCLCLCCLC");
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




  
   
   
     var arrcontinuebtn = [];
jq("#tableformodality tr").each(function(){
    arrcontinuebtn.push(jq(this).find("td:first").text());
});

var arrayfirst = arrcontinuebtn[1];
localStorage.setItem("arrayfirst", arrayfirst);





myFunctionT(arrayfirst);

for (var i=1;i<arrcontinuebtn.length;i++){
alert("MODALITY " + arrcontinuebtn[i]);
localStorage.setItem("arrcontinuebtn", JSON.stringify(arrcontinuebtn));
   jq('<option/>').val(arrcontinuebtn[i]).html(arrcontinuebtn[i]).appendTo('#items select');
}
 
 } 
 
 else {
 
 
           
               jq( "#continuetext" ).dialog( "open" );
         
    jq(".ui-dialog").addClass("customclass");
            
            
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
  jq("#reportsavebtn").show();
  jq("#selectlabtest1").empty();
  
  jq("#items").css("width", "30%");
jq("#dynamictable").css("width", "40%");
  jq("#modalityselect").hide();
  jq("#items").hide();
  
  jq("#reportmodalityselect").show();
  jq("#reportstudyselect").hide();
  
   jq("#dynamictable").hide();
  jq("#reporttable").show();
  
  

   jq("#managestudy").html("<li><i ></i><a href='javascript:void(0);' onClick='a_onClick()'> Add Study</li>");
jq("#managestudy li i").addClass("icon-chevron-right link");
jq("#managestudy li a").addClass("addstudylink");


jq("#managereport").html("<li><i ></i> Add Report</li>");
jq("#managereport li i").addClass("icon-chevron-right link");



     
     var arr = [];
jq("#dynamictable table tr").each(function(){
    arr.push(jq(this).find("td:first").text());
});

var arrayfirst = arr[1];
alert("POTPOTPOTPOT "+arrayfirst);


//myFunctionT(arrayfirst);


for (var i=1;i<arr.length;i++){
alert("SUNN");

  alert(arr[i]);
  
  jq('<option/>').val(arr[i]).html(arr[i]).appendTo('#items select');
}

var arr2 = JSON.parse(localStorage.getItem("arrcontinuebtn"));

alert("MMMMMMMMMM arr2 "+arr2);
for (var i=1;i<arr2.length;i++){

   jq('<option/>').val(arr2[i]).html(arr2[i]).appendTo('#modalityselect select');
}





jq("#reportmodalityselect select").empty();



var arr22 = JSON.parse(localStorage.getItem("arrcontinuebtn"));
for (var i=1;i<arr22.length;i++){

alert("modality storage " + arr22[i]);

   jq('<option/>').val(arr22[i]).html(arr22[i]).appendTo('#reportmodalityselect select');
}




var reportmodalityfirstlist = arr22[1];


alert("reportmodalityfirstlist "+reportmodalityfirstlist);

jq.getJSON('${ ui.actionLink("getStudyConceptsAnswerFromModality") }',
           {
             'studyconceptclass': reportmodalityfirstlist
            })
       .error(function(xhr, status, err) {
            alert('AJAX error ' + err);
        })
        .success(function(ret) {
                  alert("goog"); 
                  
                  
  
                  for (var i = 0; i < ret.length; i++) {
            var conId = ret[i].conceptId;
            var conNamed = ret[i].displayString;
            alert("conName" +conNamed);
            
          //localStorage.setItem("reportfirstmodalitystudylist", JSON.stringify(conName));
            
          
          
          
          
          
           // }
               

  
                  
                  
               //   });

   


jq('#reportstudyselectdropdown').empty();


//var arrstudycontinuebtnarr = JSON.parse(localStorage.getItem("arrstudycontinuebtn"));
//var arrstudycontinuebtnarr = JSON.parse(localStorage.getItem("reportfirstmodalitystudylist"));
//arrstudycontinuebtnarr.shift();
//for (var i=0;i<arrstudycontinuebtnarr.length;i++){



   
//}


//alert("MMMMMMMMMM "+arrstudycontinuebtnarr);


//var sat = arrstudycontinuebtnarr[0]
   
 jq('#reporttable').empty();
jq('#reporttable').append('<table></table>');
jq("#reporttable table").addClass("reportclass");
var table = jq('#reporttable').children();
table.append("<tr><td>Studies available</td><td id='tablesecondcolumn' >Report Available</td><td>Action</td></tr>");



jq.getJSON('${ ui.actionLink("getReportConcepts") }',
           {
             'studyconceptclass': conNamed
            })
       .error(function(xhr, status, err) {
            alert('AJAX error ' + err);
        })
        .success(function(ret) {
                  alert("googd"); 



    
   


  
  
  
alert("ret.length KKKKKK" + ret.length);
            for (var i = 0; i < ret.length; i++) {
            var conId = ret[i].id;
             var conName = ret[i].studyName;
            var conNameReporturl = ret[i].studyReporturl;
            
            alert("conId" + conId);
             alert("conName" + conName);
            
      
if(conNameReporturl) {

            
table.append( '<tr><td>'+ conName +'</td><td><a href='+ conNameReporturl +'> '+ conName +'</a> </td> <td> <a id="editbtn" href='+ conNameReporturl +'><img  class="img-circle" src=" ${ ui.resourceLink ("/images/ic_edit_black_24dp.png") }"/></a> <a id="deletebtn" ><img  class="img-circle" src=" ${ ui.resourceLink ("/images/ic_cancel_2x.png") }"/></a> </td></tr>' );


  }
else {

table.append( '<tr><td>'+ conName +'</td><td>'+ conNameReporturl +' </td> <td><a id="addbtn" href="http://localhost:8080/openmrs/module/htmlformentry/htmlForm.form"><img  class="img-circle" src=" ${ ui.resourceLink ("/images/ic_control_point_2x.png") }"/></a> <a id="editbtn" href='+ conNameReporturl +'><img  class="img-circle" src=" ${ ui.resourceLink ("/images/ic_edit_black_24dp.png") }"/></a> <a id="deletebtn" ><img  class="img-circle" src=" ${ ui.resourceLink ("/images/ic_cancel_2x.png") }"/></a> </td></tr>' );


}
 
  
         


  
            
}

 

});


   
   
}
});







jq("#selectlabtest1").css( { marginLeft : "-32px" } );


 
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

alert("locastorage test studysavebtn");
alert(arr[i]);
localStorage.setItem("arrstudycontinuebtn", JSON.stringify(arr));

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
jq("#reportHTMLFormMessage").dialog( "option", "width", 460 );
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

function a_onClick() {

a_onClick.called = true;

   alert('a_onClick');
   
  jq('#studysavebtn').data('clicked', false);
   jq(".reportgroup").hide();
   jq('#dynamictable').empty();
    
    jq("#reportsavebtn").hide();
  
    jq("#managereport").empty();
    jq("#modalityselect").hide();
   jq("#dynamictable").show();
  jq("#items").show();
  jq("#items select").empty();
jq(".studygroup").show();

   jq("#reportmodalityselect").hide();
   jq("#reportstudyselect").hide();

jq("#selectlabtest1").css( { marginLeft : "32px" } );

jq(".studybtn").show();
jq("#reporttable").hide();

 jq("#items").css("width", "36%");
jq("#dynamictable").css("width", "64%");
  
  
var someVarName = localStorage.getItem("arrayfirst");
var arr1 = JSON.parse(localStorage.getItem("arrcontinuebtn"));
alert("LKLKLLKLKLK "+someVarName);
alert("MMMMMMMMMM "+arr1);
for (var i=1;i<arr1.length;i++){

   jq('<option/>').val(arr1[i]).html(arr1[i]).appendTo('#items select');
}


myFunctionT(someVarName);

  }


function myFunctionT(selectedValue) {

  myFunctionT.called = true;
  
 
  
  jq.getJSON('${ ui.actionLink("getStudyConceptsAnswerFromModality") }',
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

                                
                                jq('#dynamictable').empty();
jq('#dynamictable').append('<table></table>');
jq("#dynamictable table").addClass("studyclass");
var table = jq('#dynamictable').children();





 if(myFunctionT.called) {
 myFunctionT.called = false;
 table.append("<tr><td>Studies available</td><td>Action</td></tr>");
 } else if((jq('#studyrefresh').data('clicked'))){
alert("1");
jq('#studyrefresh').data('clicked', false);
alert("inside study conitnueeeeee");
    
table.append("<tr><td>Studies available</td><td>Action</td></tr>");

}else if(jq('#reportrefresh').data('clicked') ) {
jq('#reportrefresh').data('clicked', false);
alert("inside report conitnueeeeee");
alert("2");
    
table.append("<tr><td>Report available</td><td>Action</td></tr>");

} else if(jq('#studysavebtn').data('clicked') ) {
jq('#studysavebtn').data('clicked', false);
alert("inside report conitnueeeeee");
alert("3");
    
table.append("<tr><td>Report available</td><td>Action</td></tr>");

} else if((jq('#continuebtn').data('clicked'))||(a_onClick.called)){

jq('#continuebtn').data('clicked', false);
a_onClick.called = false;
alert("inside study conitnueeeeee");
alert("4");
    
table.append("<tr><td>Studies available</td><td>Action</td></tr>");

}
else if((jq('#continuebtn').data('clicked'))) {
jq('#continuebtn').data('clicked', false);
alert("inside study conitnueeeeee");
    alert("5");
table.append("<tr><td>Studies available</td><td>Action</td></tr>");

}
else if((jq('#studycontinuebtn').data('clicked'))) {
jq('#studycontinuebtn').data('clicked', false);
alert("inside report conitnueeeeee");
alert("6");
    
table.append("<tr><td>Report available</td><td>Action</td></tr>");

}
else {
alert("7");
table.append("<tr><td>Studies available</td><td>Action</td></tr>");
}




alert("ret.length" + ret.length);
            for (var i = 0; i < ret.length; i++) {
            var conId = ret[i].conceptId;
            var conName = ret[i].displayString;
 if((conName == "Cardiac MRI Adenosine Stress Protocol Report")|| (conName == "Cardiac MRI Right Heart Failure Report")) {

table.append( '<tr><td>' +  conName + ' <a href="http://localhost:8080/openmrs/htmlformentryui/htmlform/enterHtmlFormWithStandardUi.page?patientId=5486b0af-8591-40d1-84b9-afab423fd55d&visitId=&formUuid=9e414151-e2d0-4693-9548-b6beb916b213&returnUrl=%2Fopenmrs%2Fcoreapps%2Fclinicianfacing%2Fpatient.page%3FpatientId%3D5486b0af-8591-40d1-84b9-afab423fd55d%26">( Right Click to view Sample Form)</a></td> <td><input type="button" id="deletebtn" value="Delete" > </td></tr>' );

} else {
table.append( '<tr><td>' +  conName + '</td> <td><input type="button" id="deletebtn" value="Delete" > </td></tr>' );

}

}

});

 }
 
 
 

   function myFunctionreportmodality(select) {
   
   
   jq.getJSON('${ ui.actionLink("getStudyConceptsAnswerFromModality") }',
           {
             'studyconceptclass': select
            })
       .error(function(xhr, status, err) {
            alert('AJAX error ' + err);
        })
        .success(function(ret) {
                  alert("goog"); 
                  
                  
  
                  for (var i = 0; i < ret.length; i++) {
            var conId = ret[i].conceptId;
            var conNamed = ret[i].displayString;
            alert("conName" +conNamed);
            
          //localStorage.setItem("reportfirstmodalitystudylist", JSON.stringify(conName));
            
          
          
          
          
          
           // }
               

  
                  
                  
               //   });

   


jq('#reportstudyselectdropdown').empty();


//var arrstudycontinuebtnarr = JSON.parse(localStorage.getItem("arrstudycontinuebtn"));
//var arrstudycontinuebtnarr = JSON.parse(localStorage.getItem("reportfirstmodalitystudylist"));
//arrstudycontinuebtnarr.shift();
//for (var i=0;i<arrstudycontinuebtnarr.length;i++){



   
//}


//alert("MMMMMMMMMM "+arrstudycontinuebtnarr);


//var sat = arrstudycontinuebtnarr[0]
   
 jq('#reporttable').empty();
jq('#reporttable').append('<table></table>');
jq("#reporttable table").addClass("reportclass");
var table = jq('#reporttable').children();
table.append("<tr><td>Studies available</td><td id='tablesecondcolumn'>Report Available</td><td>Action</td></tr>");



jq.getJSON('${ ui.actionLink("getReportConcepts") }',
           {
             'studyconceptclass': conNamed
            })
       .error(function(xhr, status, err) {
            alert('AJAX error ' + err);
        })
        .success(function(ret) {
                  alert("googd"); 



    
   


  
  
  
alert("ret.length KKKKKK" + ret.length);
            for (var i = 0; i < ret.length; i++) {
            var conId = ret[i].id;
             var conName = ret[i].studyName;
            var conNameReporturl = ret[i].studyReporturl;
            
            alert("conId" + conId);
             alert("conName" + conName);
            
      
if(conNameReporturl) {

            
table.append( '<tr><td>'+ conName +'</td><td> <a href='+ conNameReporturl +'> '+ conName +'</a> </td> <td> <a id="editbtn" href='+ conNameReporturl +'><img  class="img-circle" src=" ${ ui.resourceLink ("/images/ic_edit_black_24dp.png") }"/></a> <a id="deletebtn" ><img  class="img-circle" src=" ${ ui.resourceLink ("/images/ic_cancel_2x.png") }"/></a> </td></tr>' );

   
  }
else {

table.append( '<tr><td>'+ conName +'</td><td>'+ conNameReporturl +' </td> <td><a id="addbtn" href="http://localhost:8080/openmrs/module/htmlformentry/htmlForm.form"><img  class="img-circle" src=" ${ ui.resourceLink ("/images/ic_control_point_2x.png") }"/></a> <a id="editbtn" href='+ conNameReporturl +'><img  class="img-circle" src=" ${ ui.resourceLink ("/images/ic_edit_black_24dp.png") }"/></a> <a id="deletebtn" ><img  class="img-circle" src=" ${ ui.resourceLink ("/images/ic_cancel_2x.png") }"/></a> </td></tr>' );


}
 
  
         


  
            
}

 

});


   
   
}
});


   
   
   }

 
 
  function modalitystudyfunction(selectedValue) {


    
 
  jq.getJSON('${ ui.actionLink("getReportConcepts") }',
           {
             'studyconceptclass': selectedValue
            })
       .error(function(xhr, status, err) {
            alert('AJAX error ' + err);
        })
        .success(function(ret) {
                  alert("goog"); 

 jq('#reporttable').empty();
jq('#reporttable').append('<table></table>');
jq("#reporttable table").addClass("reportclass");
var table = jq('#reporttable').children();
     
 
    table.append("<tr><td>Studies available</td><td>Report Available</td><td>Action</td></tr>");
    
   


  
  
  
alert("ret.length" + ret.length);
            for (var i = 0; i < ret.length; i++) {
            var conId = ret[i].id;
             var conName = ret[i].studyName;
            var conNameReporturl = ret[i].studyReporturl;
            
            alert("conId" + conId);
             alert("conName" + conName);
            
      
if(conNameReporturl) {

            
table.append( '<tr><td>'+ conName +'</td><td><a href='+ conNameReporturl +'>'+ conName +'</a> </td> <td><a id="modalityconceptmessage" href="http://localhost:8080/openmrs/module/htmlformentry/htmlForm.form">   <input type="button" id="addbtn" value="Add" ></a> <a href='+ conNameReporturl +'><input type="button" id="editbtn" value="Edit" ></a><input type="button" id="deletebtn" value="Delete" > </td></tr>' );

   
  }
else {

table.append( '<tr><td>'+ conName +'</td><td>'+ conNameReporturl +' </td> <td><input type="button" id="addbtn" value="Add" ><input type="button" id="editbtn" value="Edit" ><input type="button" id="deletebtn" value="Delete" > </td></tr>' );


}
 
  
         


  
            
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
    <label id="report-concept-message" for report-concept-label> Select Modality from the dropdown to show the studies and reports available. Please Create Report not appearing in list and Refresh: <a id="modalityconceptmessage" href="http://localhost:8080/openmrs/module/htmlformentry/htmlForm.form"> Click here to create HTMLForm  </a></label>
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

<div id='modalityselect' style="width:30%; height:234px; margin-top: 24px; float:left">
 
  <select name="modalityselectdropdown" id="modalityselectdropdown" onchange="myFunctionT(this.value)">
 
  </select>
</div>


<div id='items' style="width:36%; height:234px; margin-top: 24px; float:left">
 
  <select name="labtest" id="selectlabtest1" onchange="myFunctionT(this.value)">
 
  </select>
</div>





<div id='reportmodalityselect' style="width:30%; height:234px; margin-top: 24px; float:left">
 
  <select name="reportmodalityselectdropdown" id="reportmodalityselectdropdown" onchange="myFunctionreportmodality(this.value)">
 
  </select>
</div>




 <div id="dynamictable" style="width:64%; float:right">  
       
 </div>
  <div id="reporttable" style="width:70%; float:right">  
       
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
<div id="reportHTMLFormMessage" style="width:430px" title="reportHTMLForm"> See radiology user guide for directions on creating report </div>





<div id="reportsaved" title="Continue">  Report Saved </div>




  

 

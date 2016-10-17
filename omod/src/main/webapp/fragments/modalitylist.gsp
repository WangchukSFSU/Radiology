<% ui.includeCss("radiology", "modalitylist.css") %>

<% ui.includeJavascript("uicommons", "datatables/jquery.dataTables.min.js") %>

  

  <link rel="stylesheet" type="text/css" href="http://ajax.aspnetcdn.com/ajax/jquery.dataTables/1.9.4/css/jquery.dataTables.css">


<script>
   jq = jQuery;
   
  
    jq(document).ready(function() {
    
 
jq('#tableformodality').DataTable({
           "sPaginationType": "full_numbers",
            "bPaginate": true,
            "bAutoWidth": false,
            "bLengthChange": true,
            "bSort": true,
            "bJQueryUI": true,
             "iDisplayLength": 5,   
        });
    


    jq(".studygroup").hide();
  jq(".studybtn").hide();
  jq(".breadcrumbs").show();
 jq(".reportgroup").hide();


   
 
   jq("#reportstudyselect").hide();
   jq("#reporttable").hide();
 jq("#studytable").hide();
   


   
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
  jq("#studytable").hide();
  jq(this).data('clicked', true);
  alert("zzzzzzz");
 jq("#continuebtn").click();
   //myFunctionT(selected);
 
  });
 
 jq("#reportrefresh").click(function() { 
 jq("#reporttable").hide();
 jq(this).data('clicked', true);
 jq("#studycontinuebtn").click();
  alert("zzzzzzz");
   // jq("#reporttable").hide();
 
  
  //var selected = jq( "#reportstudyselectdropdown option:selected" ).text();
  //jq("#dynamictable tr").remove();
   //myFunctionT(selected);
 //jq("#reporttable").show();
  });
  
  
  
  
  
  
 jq("#continuebtn").click(function() {
  
jq(this).data('clicked', true);
 
 //if(jq('#Savebtn').data('clicked')) {
 
alert("CLCICLCLCLCLCCLC");
   jq("#modalitySoftware").hide();

jq(".studygroup").show();
jq(".modality").hide();
jq(".studybtn").show(); 
  jq(".modalitybtn").hide();
 
   jq("#performedStatusInProgressOrder").hide();
  
 
  
  

 jq("#manageradiology").html("<li><i ></i><a href='/openmrs/radiology/adminInitialize.page'> Manage Modalities</li>");
jq("#manageradiology li i").addClass("icon-chevron-right link");


jq("#managestudy").html("<li><i ></i> Manage Studies</li>");
jq("#managestudy li i").addClass("icon-chevron-right link");



            

  
 
   



myFunctionStudyList();


 
 
   
});



jq("#studycontinuebtn").click(function() {
  jq(this).data('clicked', true);
 
 alert("YES");
 jq("#modalitySoftware").hide();
  
jq(".studygroup").hide();
jq(".modality").hide();
jq(".studybtn").hide(); 
  jq(".modalitybtn").hide();
  jq(".reportgroup").show();

 

  jq("#selectlabtest1").empty();
  
 

  jq("#reportstudyselect").hide();
  
   jq("#studytable").hide();
  
   
  

   jq("#managestudy").html("<li><i ></i><a href='javascript:void(0);' onClick='a_onClick()'> Manage Studies</li>");
jq("#managestudy li i").addClass("icon-chevron-right link");
jq("#managestudy li a").addClass("addstudylink");


jq("#managereport").html("<li><i ></i> Manage Reports</li>");
jq("#managereport li i").addClass("icon-chevron-right link");



  


functionreportlist();






 
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
  
  
  
    jq("#managereport").empty();
 


jq(".studygroup").show();



jq(".studybtn").show();


 


jq("#reporttable").hide();

//jq("#studytable").show();
  
  myFunctionStudyList();
  
  
 //jq("#studycontinuebtn").click();


//myFunctionT(someVarName);

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
 table.append("<thead><tr><td>Studies available</td></tr></thead>");
 } else if((jq('#studyrefresh').data('clicked'))){
alert("1");
jq('#studyrefresh').data('clicked', false);
alert("inside study conitnueeeeee");
    
table.append("<thead><tr><td>Studies available</td></tr></thead>");

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
    
table.append("<thead><tr><td>Studies available</td></tr></thead>");

}
else if((jq('#continuebtn').data('clicked'))) {
jq('#continuebtn').data('clicked', false);
alert("inside study conitnueeeeee");
    alert("5");
table.append("<thead><tr><td>Studies available</td></tr></thead>");

}
else if((jq('#studycontinuebtn').data('clicked'))) {
jq('#studycontinuebtn').data('clicked', false);
alert("inside report conitnueeeeee");
alert("6");
    
table.append("<tr><td>Report available</td><td>Action</td></tr>");

}
else {
alert("7");
table.append("<thead><tr><td>Studies available</td></tr></thead>");
}




alert("ret.length" + ret.length);
            for (var i = 0; i < ret.length; i++) {
            var conId = ret[i].conceptId;
            var conName = ret[i].displayString;
 if((conName == "Cardiac MRI Adenosine Stress Protocol Report")|| (conName == "Cardiac MRI Right Heart Failure Report")) {

table.append( '<tr><td>' +  conName + ' <a href="http://localhost:8080/openmrs/htmlformentryui/htmlform/enterHtmlFormWithStandardUi.page?patientId=5486b0af-8591-40d1-84b9-afab423fd55d&visitId=&formUuid=9e414151-e2d0-4693-9548-b6beb916b213&returnUrl=%2Fopenmrs%2Fcoreapps%2Fclinicianfacing%2Fpatient.page%3FpatientId%3D5486b0af-8591-40d1-84b9-afab423fd55d%26">( Right Click to view Sample Form)</a></td> <td><input type="button" id="deletebtn" value="Delete" > </td></tr>' );

} else {
table.append( '<tbody><tr><td>' +  conName + '</td> </tr></tbody>' );


}



}

  

});

 }
 
 
 
 function myFunctionStudyList() {

  //myFunctionT.called = true;
  jq("#studytable").show();
    jq('#studytable').empty();
jq('#studytable').append('<table></table>');
jq('#studytable table').attr('id','studytablelistid');
jq("#studytable table").addClass("studyclass");
var studytablelist = jq('#studytable').children();
  
  
  
  jq.getJSON('${ ui.actionLink("getStudyConceptsAnswerFromModality") }',
           {
             
            })
       .error(function(xhr, status, err) {
            alert('AJAX error ' + err);
        })
        .success(function(ret) {
                  alert("goog"); 
                  
                  
                  
               
                  
                  
                  
studytablelist.append( '<thead><tr><th> Studies Available</th></thead><tbody>' );


          

                                  
                                
                                
alert("ret.length" + ret.length);
            for (var i = 0; i < ret.length; i++) {
            var conId = ret[i].conceptId;
            var conName = ret[i].displayString;
 
studytablelist.append( '<tr><td>' +  conName + '</td> </tr>' );


}

studytablelist.append( '</tbody>' );
jq('#studytablelistid').dataTable({
            "sPaginationType": "full_numbers",
            "bPaginate": true,
            "bAutoWidth": false,
            "bLengthChange": true,
            "bSort": true,
            "bJQueryUI": true,
             "iDisplayLength": 5,   
        });
 

  

})
            


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
            //alert("conName" +conNamed);
            
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
            
           // alert("conId" + conId);
            // alert("conName" + conName);
            
      
if(conNameReporturl) {

            
table.append( '<tr><td>'+ conName +'</td><td> <a href='+ conNameReporturl +'> '+ conName +'</a> </td> <td> <a id="editbtn" href="http://localhost:8080/openmrs/module/htmlformentry/htmlForms.list"><img  class="img-circle" src=" ${ ui.resourceLink ("/images/ic_edit_black_24dp.png") }"/></a> <a id="deletebtn" ><img  class="img-circle" src=" ${ ui.resourceLink ("/images/ic_cancel_2x.png") }"/></a> </td></tr>' );

   
  }
else {

table.append( '<tr><td>'+ conName +'</td><td>'+ conNameReporturl +' </td> <td><a id="addbtn" href="http://localhost:8080/openmrs/module/htmlformentry/htmlForm.form"><img  class="img-circle" src=" ${ ui.resourceLink ("/images/ic_control_point_2x.png") }"/></a> <a id="editbtn" href="http://localhost:8080/openmrs/module/htmlformentry/htmlForms.list"><img  class="img-circle" src=" ${ ui.resourceLink ("/images/ic_edit_black_24dp.png") }"/></a> <a id="deletebtn" ><img  class="img-circle" src=" ${ ui.resourceLink ("/images/ic_cancel_2x.png") }"/></a> </td></tr>' );


}
 
            
}

 

})





   
}
});


   
   
   }

 
 
  function functionreportlist() {

   
                                
    jq('#reporttable').empty();
jq('#reporttable').append('<table></table>');
jq('#reporttable table').attr('id','reporttablelistid');
jq("#reporttable table").addClass("reportclass");
var reporttablelist = jq('#reporttable').children();
  
  
alert("report ");
    
 
  jq.getJSON('${ ui.actionLink("getReportConcepts") }',
           {
        
            })
       .error(function(xhr, status, err) {
            alert('AJAX error ' + err);
        })
        .success(function(ret) {
                  alert("report goog"); 


                  
     reporttablelist.append("<thead><tr><td>Studies</td><td>Report Available</td><td>Action</td></tr></thead><tbody>");
    

alert("ret.length" + ret.length);
            for (var i = 0; i < ret.length; i++) {
            var conId = ret[i].id;
             var conName = ret[i].studyName;
            var conNameReporturl = ret[i].studyReporturl;
            
            //alert("conId" + conId);
            // alert("conName" + conName);

      
if(conNameReporturl) {

            
 reporttablelist.append( '<tr><td>'+ conName +'</td><td><a href='+ conNameReporturl +'>'+ conName +'</a> </td> <td><a id="editbtn" href="http://localhost:8080/openmrs/module/htmlformentry/htmlForms.list"><img  class="img-circle" src=" ${ ui.resourceLink ("/images/ic_edit_black_24dp.png") }"/></a>  </td></tr>' );

   
  }

 
       
}


    
 
 
 
})

 

  jq.getJSON('${ ui.actionLink("getStudyConcepts") }',
           {
        
            })
       .error(function(xhr, status, err) {
            alert('AJAX error ' + err);
        })
        .success(function(ret) {
                  alert("report goog"); 

  jq("#reporttable").show();

alert("ret.length" + ret.length);
            for (var i = 0; i < ret.length; i++) {
            var conId = ret[i].id;
            var conName = ret[i].name;
            
          
            
           // alert("conId study" + conId);
            //alert("conId conName" + conName);
 reporttablelist.append( '<tr><td> '+ conName +' </td><td> </td> <td><a id="addbtn" href="http://localhost:8080/openmrs/module/htmlformentry/htmlForm.form"><img  class="img-circle" src=" ${ ui.resourceLink ("/images/ic_control_point_2x.png") }"/></a><a id<img  class="img-circle" src=" ${ ui.resourceLink ("/images/ic_control_point_2x.png") }"/></a>  </td></tr>' );

      
}
    
  jq('#reporttablelist').append("</tbody>");
 jq('#reporttablelistid').dataTable({
 destroy: true,
            "sPaginationType": "full_numbers",
            "bPaginate": true,
            "bAutoWidth": false,
            "bLengthChange": true,
            "bSort": true,
            "bJQueryUI": true,
             "iDisplayLength": 5,   
        });
 
})
 




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
        Manage Modalities   
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
    <label id="study-concept-message" for modality-concept-label> Please Add Study not appearing in list to Concept Dictionary and Refresh: <a id="modalityconceptmessage" href="http://localhost:8080/openmrs/dictionary/concept.form"> Click here to Concept Dictionary </a></label>
    <input type="button" id="studyConceptDictionary" class="studyConceptDictionary" value = "?" >
    <input type="button" name="studyrefresh" id="studyrefresh" value="Refresh">
     
     </div>
</div>

<div class="reportgroup">
    <div class="form-group">
    <label id="report-concept-message" for report-concept-label>  Please Create Report not appearing in list and Refresh: <a id="modalityconceptmessage" href="http://localhost:8080/openmrs/module/htmlformentry/htmlForm.form"> Click here to create HTMLForm  </a></label>
    <input type="button" id="reportHTMLForm" class="reportHTMLForm" value = "?" >
    
    <input type="button" name="reportrefresh" id="reportrefresh" value="Refresh">
     
     </div>
</div>





    <div id="performedStatusInProgressOrder">
  
<table id="tableformodality">
    <thead>
        <tr>
            <th>Modality Available</th>
           
           
        </tr>
    </thead>
    <tbody>
     
   <% mmm.each { modalityname -> %>
    <tr>
        <td>
            ${modalityname}</td>
       
       

    </tr>
    <% } %>  
</tbody>
</table>
</div>





















 <div id="studytable" >  
 


       
 </div>
 
 
  <div id="reporttable" >  
  
    
 </div>

 
 
 
 
 
 
 
<div class="modalitybtn">

<input type="button" id="continuebtn" class="continuebtn" value="Continue" >


</div>

<div class="studybtn">

<input type="button" id="studycontinuebtn" class="studycontinuebtn" value="Continue" >
</div>





<div id="modalityConceptDictionaryNotes" title="Modality Concept Dictionary Notes">IMPORTANT NOTES FOR CREATING MODALITY CONCEPT: <br> 1) Select Radiology Imaging/Procedure as class from the dropdown menu.<br> 2) Select N/A as datatype from the dropdown menu.<br> 3) Add newly created modality concept to Imaging modalitites ConvSet in the concept dictionary." </div>
  <div id="continuetext" title="Continue">  Please Click Save to save the modality before continue </div>
  <div id="studyconceptmessage" title="studyconceptmessage"> IMPORTANT NOTES FOR CREATING STUDY CONCEPT: <br> 1) Select Radiology Imaging/Procedure  as class from the dropdown menu. <br> 2) Select N/A as datatype from the dropdown menu. <br> 3)  Include the newly created study concept to modality set using concept dictionary.  " </div>
<div id="studycontinuetext" title="Continue">  Please Click Save to save the study before continue </div>
<div id="modalitysaved" title="Continue">  Modality Saved </div>
<div id="studysaved" title="Continue">  Study Saved </div>
<div id="reportHTMLFormMessage" style="width:430px" title="reportHTMLForm"> See radiology user guide for directions on creating report </div>





<div id="reportsaved" title="Continue">  Report Saved </div>



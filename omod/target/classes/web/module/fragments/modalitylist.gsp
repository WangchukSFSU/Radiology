<% ui.includeCss("radiology", "modalitylist.css") %>

<% ui.includeJavascript("uicommons", "datatables/jquery.dataTables.min.js") %>

<% ui.includeCss("radiology", "jquery.dataTables.css") %>
  
  <link rel="stylesheet" type="text/css" href="http://ajax.aspnetcdn.com/ajax/jquery.dataTables/1.9.4/css/jquery.dataTables.css">



<script>
   jq = jQuery;
   
  
    jq(document).ready(function() {
    
 
jq('#tableformodality').dataTable({
           "sPaginationType": "full_numbers",
            "bPaginate": true,
            "bAutoWidth": false,
            "bLengthChange": true,
            "bSort": true,
            "bJQueryUI": true,
             "iDisplayLength": 5,   
        });
    
   
       jq('#example').DataTable( {
          "bPaginate": false,
    "sScrollY": "250px",
    "bAutoWidth": false,
    "bScrollCollapse": true,
    "fnInitComplete": function() {
      this.css("visibility", "visible");
    },
    "bLengthChange": false
    } );

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
  
  jq(this).data('clicked', true);
  alert("zzzzzzz");
  jq("#dynamictable").hide();
 
  jq("#dynamictable").show();
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
  
 
  
  

 jq("#manageradiology").html("<li><i ></i><a href='/openmrs/radiology/adminInitialize.page'> Manage Radiology Module</li>");
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
 
   jq("#dynamictable").show();

jq(".studygroup").show();



jq(".studybtn").show();
jq("#reporttable").hide();


  
  



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
  
  jq.getJSON('${ ui.actionLink("getStudyConceptsAnswerFromModality") }',
           {
             
            })
       .error(function(xhr, status, err) {
            alert('AJAX error ' + err);
        })
        .success(function(ret) {
                  alert("goog"); 
jq('#studytablelist').append( '<thead><tr><th> Studies Available</th></thead><tbody>' );


          

                                  
                                
                                
alert("ret.length" + ret.length);
            for (var i = 0; i < ret.length; i++) {
            var conId = ret[i].conceptId;
            var conName = ret[i].displayString;
 
 jq('#studytablelist').append( '<tr><td>' +  conName + '</td> </tr>' );


}

jq('#studytablelist').append( '</tbody>' );
jq('#studytablelist').dataTable({
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

 

})





   
}
});


   
   
   }

 
 
  function functionreportlist() {

 
  
  
alert("report ");
    
 
  jq.getJSON('${ ui.actionLink("getReportConcepts") }',
           {
        
            })
       .error(function(xhr, status, err) {
            alert('AJAX error ' + err);
        })
        .success(function(ret) {
                  alert("report goog"); 

 
     jq('#reporttablelist').append("<thead><tr><td>Studies</td><td>Report Available</td><td>Action</td></tr></thead><tbody>");
    

alert("ret.length" + ret.length);
            for (var i = 0; i < ret.length; i++) {
            var conId = ret[i].id;
             var conName = ret[i].studyName;
            var conNameReporturl = ret[i].studyReporturl;
            
            alert("conId" + conId);
             alert("conName" + conName);

      
if(conNameReporturl) {

            
 jq('#reporttablelist').append( '<tr><td>'+ conName +'</td><td><a href='+ conNameReporturl +'>'+ conName +'</a> </td> <td><a id="editbtn" href='+ conNameReporturl +'><img  class="img-circle" src=" ${ ui.resourceLink ("/images/ic_edit_black_24dp.png") }"/></a>  </td></tr>' );

   
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
            
            
            alert("conId study" + conId);
            alert("conId conName" + conName);
 jq('#reporttablelist').append( '<tr><td> '+ conName +' </td><td> </td> <td><a id="addbtn" href="http://localhost:8080/openmrs/module/htmlformentry/htmlForm.form"><img  class="img-circle" src=" ${ ui.resourceLink ("/images/ic_control_point_2x.png") }"/></a><a id<img  class="img-circle" src=" ${ ui.resourceLink ("/images/ic_control_point_2x.png") }"/></a>  </td></tr>' );

      
}
    
  jq('#reporttablelist').append("</tbody>");
 jq('#reporttablelist').dataTable({
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
 
<table id ="studytablelist">
    
    
    </table>

       
 </div>
 
 
  <div id="reporttable" >  
  
      <table id ="reporttablelist">
    
    
    </table> 
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



<table id="example" class="display" cellspacing="0" width="100%">
        <thead>
            <tr>
                <th>Name</th>
                <th>Position</th>
                <th>Office</th>
                <th>Age</th>
                <th>Start date</th>
                <th>Salary</th>
            </tr>
        </thead>
 
        <tfoot>
            <tr>
                <th>Name</th>
                <th>Position</th>
                <th>Office</th>
                <th>Age</th>
                <th>Start date</th>
                <th>Salary</th>
            </tr>
        </tfoot>
 
        <tbody>
            <tr>
                <td>Tiger Nixon</td>
                <td>System Architect</td>
                <td>Edinburgh</td>
                <td>61</td>
                <td>2011/04/25</td>
                <td>320,800</td>
            </tr>
            <tr>
                <td>Garrett Winters</td>
                <td>Accountant</td>
                <td>Tokyo</td>
                <td>63</td>
                <td>2011/07/25</td>
                <td>170,750</td>
            </tr>
            <tr>
                <td>Ashton Cox</td>
                <td>Junior Technical Author</td>
                <td>San Francisco</td>
                <td>66</td>
                <td>2009/01/12</td>
                <td>86,000</td>
            </tr>
            <tr>
                <td>Cedric Kelly</td>
                <td>Senior Javascript Developer</td>
                <td>Edinburgh</td>
                <td>22</td>
                <td>2012/03/29</td>
                <td>433,060</td>
            </tr>
            <tr>
                <td>Airi Satou</td>
                <td>Accountant</td>
                <td>Tokyo</td>
                <td>33</td>
                <td>2008/11/28</td>
                <td>162,700</td>
            </tr>
         
            <tr>
                <td>Rhona Davidson</td>
                <td>Integration Specialist</td>
                <td>Tokyo</td>
                <td>55</td>
                <td>2010/10/14</td>
                <td>327,900</td>
            </tr>
           
          
            <tr>
                <td>Charde Marshall</td>
                <td>Regional Director</td>
                <td>San Francisco</td>
                <td>36</td>
                <td>2008/10/16</td>
                <td>470,600</td>
            </tr>
            <tr>
                <td>Haley Kennedy</td>
                <td>Senior Marketing Designer</td>
                <td>London</td>
                <td>43</td>
                <td>2012/12/18</td>
                <td>313,500</td>
            </tr>
            <tr>
                <td>Tatyana Fitzpatrick</td>
                <td>Regional Director</td>
                <td>London</td>
                <td>19</td>
                <td>2010/03/17</td>
                <td>385,750</td>
            </tr>
            <tr>
                <td>Michael Silva</td>
                <td>Marketing Designer</td>
                <td>London</td>
                <td>66</td>
                <td>2012/11/27</td>
                <td>198,500</td>
            </tr>
            <tr>
                <td>Paul Byrd</td>
                <td>Chief Financial Officer (CFO)</td>
                <td>New York</td>
                <td>64</td>
                <td>2010/06/09</td>
                <td>725,000</td>
            </tr>
            <tr>
                <td>Gloria Little</td>
                <td>Systems Administrator</td>
                <td>New York</td>
                <td>59</td>
                <td>2009/04/10</td>
                <td>237,500</td>
            </tr>
            <tr>
                <td>Bradley Greer</td>
                <td>Software Engineer</td>
                <td>London</td>
                <td>41</td>
                <td>2012/10/13</td>
                <td>132,000</td>
            </tr>
            <tr>
                <td>Dai Rios</td>
                <td>Personnel Lead</td>
                <td>Edinburgh</td>
                <td>35</td>
                <td>2012/09/26</td>
                <td>217,500</td>
            </tr>
            <tr>
                <td>Jenette Caldwell</td>
                <td>Development Lead</td>
                <td>New York</td>
                <td>30</td>
                <td>2011/09/03</td>
                <td>345,000</td>
            </tr>
            <tr>
                <td>Yuri Berry</td>
                <td>Chief Marketing Officer (CMO)</td>
                <td>New York</td>
                <td>40</td>
                <td>2009/06/25</td>
                <td>675,000</td>
            </tr>
            <tr>
                <td>Caesar Vance</td>
                <td>Pre-Sales Support</td>
                <td>New York</td>
                <td>21</td>
                <td>2011/12/12</td>
                <td>106,450</td>
            </tr>
            <tr>
                <td>Doris Wilder</td>
                <td>Sales Assistant</td>
                <td>Sidney</td>
                <td>23</td>
                <td>2010/09/20</td>
                <td>85,600</td>
            </tr>
         
            <tr>
                <td>Fiona Green</td>
                <td>Chief Operating Officer (COO)</td>
                <td>San Francisco</td>
                <td>48</td>
                <td>2010/03/11</td>
                <td>850,000</td>
            </tr>
            <tr>
                <td>Shou Itou</td>
                <td>Regional Marketing</td>
                <td>Tokyo</td>
                <td>20</td>
                <td>2011/08/14</td>
                <td>163,000</td>
            </tr>
            <tr>
                <td>Michelle House</td>
                <td>Integration Specialist</td>
                <td>Sidney</td>
                <td>37</td>
                <td>2011/06/02</td>
                <td>95,400</td>
            </tr>
            <tr>
                <td>Suki Burks</td>
                <td>Developer</td>
                <td>London</td>
                <td>53</td>
                <td>2009/10/22</td>
                <td>114,500</td>
            </tr>
            <tr>
                <td>Prescott Bartlett</td>
                <td>Technical Author</td>
                <td>London</td>
                <td>27</td>
                <td>2011/05/07</td>
                <td>145,000</td>
            </tr>
            <tr>
                <td>Gavin Cortez</td>
                <td>Team Leader</td>
                <td>San Francisco</td>
                <td>22</td>
                <td>2008/10/26</td>
                <td>235,500</td>
            </tr>
            <tr>
                <td>Martena Mccray</td>
                <td>Post-Sales support</td>
                <td>Edinburgh</td>
                <td>46</td>
                <td>2011/03/09</td>
                <td>324,050</td>
            </tr>
        
            
        </tbody>
    </table>
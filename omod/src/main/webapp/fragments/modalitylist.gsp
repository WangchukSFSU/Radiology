<% ui.includeCss("radiology", "modalitylist.css") %>

<% ui.includeJavascript("uicommons", "datatables/jquery.dataTables.min.js") %>



<script>
    jq = jQuery;
    jq(document).ready(function() {

    jq('#modalitytable').DataTable({
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
    });

    jq("#continuebtn").click(function() {
    jq(this).data('clicked', true);
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
    jq("#studytable").hide();

   jq("#managestudy").html("<li><i ></i><a href='javascript:void(0);' onClick='manageStudiesBreadCrumb()'> Manage Studies</li>");
    jq("#managestudy li i").addClass("icon-chevron-right link");
    jq("#managestudy li a").addClass("addstudylink");
    jq("#managereport").html("<li><i ></i> Manage Reports</li>");
    jq("#managereport li i").addClass("icon-chevron-right link");
    functionreportlist();
    });

    jq("#reportHTMLForm").click(function() {
    jq("#reportHTMLFormMessage").dialog( "option", "width", 460 );
    jq( "#reportHTMLFormMessage" ).dialog( "open" );
    });

    jq("#studyConceptDictionary").click(function() {
    jq( "#studyconceptmessage" ).dialog( "open" );
    });

    });

    function manageStudiesBreadCrumb() {
    manageStudiesBreadCrumb.called = true;
    alert('manageStudiesBreadCrumb');
    jq('#studysavebtn').data('clicked', false);
    jq(".reportgroup").hide();
    jq("#managereport").empty();
    jq(".studygroup").show();
    jq(".studybtn").show();
    jq("#reporttable").hide();
    myFunctionStudyList();
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
    <table id="modalitytable">
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
<div id="reportHTMLFormMessage" style="width:430px" title="reportHTMLForm"> See radiology user guide for directions on creating report </div>



  
${session.htmlToDisplay} 
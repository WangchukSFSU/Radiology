<% ui.includeCss("radiology", "adminManageRadiologyModule.css") %>
<% ui.includeJavascript("uicommons", "datatables/jquery.dataTables.min.js") %>
<% ui.includeCss("radiology", "jquery-ui.css") %>
<% ui.includeCss("radiology", "jquery.dataTables.min.css") %>


<script>
    jq = jQuery;
    jq(document).ready(function() {

    jq('#modalityTable').DataTable({
    "sPaginationType": "full_numbers",
    "bPaginate": true,
    "bAutoWidth": false,
    "bLengthChange": true,
    "bSort": true,
    "bJQueryUI": true,
    "iDisplayLength": 5,   
    });

    jq(".studyHeaderDiv").hide();
    jq(".studyContinueBtnDiv").hide();
    jq(".breadcrumbs").show();
    jq(".reportHeaderDiv").hide();
    jq("#reportTableDiv").hide();
    jq("#studyTableDiv").hide();

    jq( "#createModalityConceptMessage" ).dialog({
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

    jq( "#modalityDialogBtn" ).click(function() {
    jq( "#createModalityConceptMessage" ).dialog( "open" );
    });

    jq( "#modalityContinueDialogMessage" ).dialog({
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

    jq( "#studyContinueDialogMessage" ).dialog({
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

    jq( "#createStudyConceptMessage" ).dialog({
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

    jq( "#createReportDialogMessage" ).dialog({
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

    jq("#studyRefreshBtn").click(function() { 
    jq("#studyTableDiv").hide();
    jq(this).data('clicked', true);
    alert("zzzzzzz");
    jq("#modalityContinueBtn").click();
    });

    jq("#reportRefreshBtn").click(function() { 
    jq("#reportTableDiv").hide();
    jq(this).data('clicked', true);
    jq("#studyContinueBtn").click();
    });

    jq("#modalityContinueBtn").click(function() {
    jq(this).data('clicked', true);
    alert("CLCICLCLCLCLCCLC");
    jq("#modalitySoftwareAvailabilityFragment").hide();
    jq(".studyHeaderDiv").show();
    jq(".modalityHeaderDiv").hide();
    jq(".studyContinueBtnDiv").show(); 
    jq(".modalityContinueBtnDiv").hide();
    jq("#modalityTableDiv").hide();
    jq("#manageRadiologyBreadcrumb").html("<li><i ></i><a href='/openmrs/radiology/adminInitialize.page'> Manage Radiology Module</li>");
    jq("#manageRadiologyBreadcrumb li i").addClass("icon-chevron-right link");
    jq("#manageStudyBreadcrumb").html("<li><i ></i> Manage Studies</li>");
    jq("#manageStudyBreadcrumb li i").addClass("icon-chevron-right link");
    manageStudiesBreadCrumbClickGetStudy();
    });

    jq("#studyContinueBtn").click(function() {
    jq(this).data('clicked', true);
    alert("YES");
    jq("#modalitySoftwareAvailabilityFragment").hide();
    jq(".studyHeaderDiv").hide();
    jq(".modalityHeaderDiv").hide();
    jq(".studyContinueBtnDiv").hide(); 
    jq(".modalityContinueBtnDiv").hide();
    jq(".reportHeaderDiv").show();
    jq("#studyTableDiv").hide();
   jq("#manageStudyBreadcrumb").html("<li><i ></i><a href='javascript:void(0);' onClick='manageStudiesBreadCrumbClick()'> Manage Studies</li>");
    jq("#manageStudyBreadcrumb li i").addClass("icon-chevron-right link");
    jq("#manageStudyBreadcrumb li a").addClass("addstudylink");
    jq("#manageReportBreadcrumb").html("<li><i ></i> Manage Reports</li>");
    jq("#manageReportBreadcrumb li i").addClass("icon-chevron-right link");
    manageReportBreadCrumbClick();
    });

    jq("#reportDialogBtn").click(function() {
    jq("#createReportDialogMessage").dialog( "option", "width", 460 );
    jq( "#createReportDialogMessage" ).dialog( "open" );
    });

    jq("#studyDialogBtn").click(function() {
    jq( "#createStudyConceptMessage" ).dialog( "open" );
    });

    });


    function manageStudiesBreadCrumbClick() {
    manageStudiesBreadCrumbClick.called = true;
    alert('manageStudiesBreadCrumbClick');
    jq('#studysavebtn').data('clicked', false);
    jq(".reportHeaderDiv").hide();
    jq("#manageReportBreadcrumb").empty();
    jq(".studyHeaderDiv").show();
    jq(".studyContinueBtnDiv").show();
    jq("#reportTableDiv").hide();
    manageStudiesBreadCrumbClickGetStudy();
    }

    function manageStudiesBreadCrumbClickGetStudy() {
    //myFunctionT.called = true;
    jq("#studyTableDiv").show();
    jq('#studyTableDiv').empty();
    jq('#studyTableDiv').append('<table></table>');
    jq('#studyTableDiv table').attr('id','studyTableId');
    jq("#studyTableDiv table").addClass("studyTableClass");
    var studyTableRow = jq('#studyTableDiv').children();
    jq.getJSON('${ ui.actionLink("getStudyConceptsAnswerFromModality") }',
    {
    })
    .error(function(xhr, status, err) {
    alert('AJAX error ' + err);
    })
    .success(function(ret) {
    alert("goog"); 
studyTableRow.append( '<thead><tr><th> Studies Available</th></thead><tbody>' );
    alert("ret.length" + ret.length);
    for (var i = 0; i < ret.length; i++) {
    var studyConceptId = ret[i].conceptId;
    var studyName = ret[i].displayString;
studyTableRow.append( '<tr><td>' +  studyName + '</td> </tr>' );
    }
studyTableRow.append( '</tbody>' );
    jq('#studyTableId').dataTable({
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
    function manageReportBreadCrumbClick() {

    jq('#reportTableDiv').empty();
    jq('#reportTableDiv').append('<table></table>');
    jq('#reportTableDiv table').attr('id','reportTableId');
    jq("#reportTableDiv table").addClass("reportTableClass");
    var reportTableRow = jq('#reportTableDiv').children();

    //get report available
    jq.getJSON('${ ui.actionLink("getReport") }',
    {
    })
    .error(function(xhr, status, err) {
    alert('AJAX error ' + err);
    })
    .success(function(ret) {

    reportTableRow.append("<thead><tr><td>Studies</td><td>Report Available</td><td>Action</td></tr></thead><tbody>");

    var formNameArray = [];
    var formNameHtmlToDisplayArray = [];

    for (var i = 0; i < ret.length; i++) {
    var FormName = ret[i].FormName;
    formNameArray[i] = FormName;
    var formNameHtmlToDisplay = ret[i].HtmlToDisplay;
    formNameHtmlToDisplayArray[i] = formNameHtmlToDisplay;

 reportTableRow.append( '<tr><td>'+ FormName +'</td><td> <a id="viewReportLink" href='+ FormName +' class="viewReportLink" onclick="displayReport(this); return false;" >'+ FormName +' </a> </td> <td><a id="editFormLink" target="_blank" href="http://localhost:8080/openmrs/module/htmlformentry/htmlForms.list"><img  class="img-circle" src=" ${ ui.resourceLink ("/images/ic_edit_black_24dp.png") }"/></a>  </td></tr>' );

    }

    localStorage.setItem("formNameArray", JSON.stringify(formNameArray));
    localStorage.setItem("formNameHtmlToDisplayArray", JSON.stringify(formNameHtmlToDisplayArray));


    jq.getJSON('${ ui.actionLink("getStudyWithNoFormName") }',
    {
    })
    .error(function(xhr, status, err) {
    alert('AJAX error ' + err);
    })
    .success(function(ret) {
    alert("report goog " +ret.length); 
    jq('#reportTableDiv').show();
    // jq("#rrr").show();
    alert("ret.length" + ret.length);
    for (var i = 0; i < ret.length; i++) {
    var studyId = ret[i].id;
    var studyName = ret[i].name;
 reportTableRow.append( '<tr><td> '+ studyName +' </td><td> </td> <td><a id="addStudyIconLink" target="_blank" href="http://localhost:8080/openmrs/module/htmlformentry/htmlForm.form"><img  class="img-circle" src=" ${ ui.resourceLink ("/images/ic_control_point_2x.png") }"/></a><a id<img  class="img-circle" src=" ${ ui.resourceLink ("/images/ic_control_point_2x.png") }"/></a>  </td></tr>' );
    }

      jq('#reportTableRow').append("</tbody>");
    jq('#reportTableId').DataTable({
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
    })
    }


    function displayReport(el){

    //dialog box
    jq("#viewReportDialog").dialog({
    width: 600,
    height: 450,
    buttons: {
    OK: function() {jq(this).dialog("close");}
    },
    });

    //get the form name, arrays of the each rows information
    var firstColumnFormName = jq(el).closest('tr').find('td:first').text();
    var formNameArray = JSON.parse(localStorage.getItem("formNameArray"));
    var formNameHtmlToDisplayArray = JSON.parse(localStorage.getItem("formNameHtmlToDisplayArray"));

    //matches the form cicked and assign it for display in iframe
    for (var i=0;i<formNameArray.length;i++){
    if(firstColumnFormName == formNameArray[i]) {
    alert(formNameHtmlToDisplayArray[i]);
    var formNameHtmlToDisplay = formNameHtmlToDisplayArray[i];
    }

    }

    //disply form in iframe
    var iframe = document.getElementById('viewReportIframe');
    var html_string = '<html><head></head><body>'+ formNameHtmlToDisplay +'</body></html>';
    var iframedoc = iframe.document;
    iframedoc = iframe.contentWindow.document;
    iframedoc.writeln(html_string);

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
        <li id="manageRadiologyBreadcrumb">  
            <i class="icon-chevron-right link"></i>
            Manage Radiology Module   
        </li>
        <li id="manageStudyBreadcrumb"> 
        </li>
        <li id="manageReportBreadcrumb"> 
        </li>
    </ul>
</div>



<div id ="modalitySoftwareAvailabilityFragment"  >
    ${ ui.includeFragment("radiology", "modalitySoftwareAvalability") }
</div>

<div class="modalityHeaderDiv">
    <label id="modalityDialogMessage" for modality-dialog-label> Please Add Modality not appearing in list to Concept Dictionary and Refresh: <a id="conceptMessage" target='_blank' href="http://localhost:8080/openmrs/dictionary/concept.form"> Click here to Concept Dictionary </a></label>
    <input type="button" id="modalityDialogBtn" value = "?" >
    <input type="button" onclick="location.href='/openmrs/pages/radiology/adminInitialize.page'" id="modalityRefreshBtn" value="Refresh">
</div>


<div class="studyHeaderDiv">
    <label id="studyDialogMessage" for modality-dialog-label> Please Add Study not appearing in list to Concept Dictionary and Refresh: <a id="conceptMessage" target='_blank' href="http://localhost:8080/openmrs/dictionary/concept.form"> Click here to Concept Dictionary </a></label>
    <input type="button" id="studyDialogBtn" value = "?" >
    <input type="button" id="studyRefreshBtn" value="Refresh">
</div>

<div class="reportHeaderDiv">
    <label id="reportDialogMessage" for report-dialog-label>  Please Create Report not appearing in list and Refresh: <a id="conceptMessage" target='_blank' href="http://localhost:8080/openmrs/module/htmlformentry/htmlForm.form"> Click here to create HTMLForm  </a></label>
    <input type="button" id="reportDialogBtn" value = "?" >
    <input type="button" id="reportRefreshBtn" value="Refresh">
</div>

<div id="modalityTableDiv">
    <table id="modalityTable">
        <thead>
            <tr>
                <th>Modality Available</th>
            </tr>
        </thead>
        <tbody>
            <% modalityConcept.each { modalityname -> %>
            <tr>
                <td>
                    ${modalityname}</td>
            </tr>
            <% } %>  
        </tbody>
    </table>
</div>


<div id="studyTableDiv" >  
</div>

<div id="reportTableDiv" >  
</div>

<div class="modalityContinueBtnDiv">
    <input type="button" id="modalityContinueBtn" value="Continue" >
</div>

<div class="studyContinueBtnDiv">
    <input type="button" id="studyContinueBtn" value="Continue" >
</div>

<div id="createModalityConceptMessage" title="Create Modality Concept">IMPORTANT NOTES FOR CREATING MODALITY CONCEPT: <br> 1) Select Radiology Imaging/Procedure as class from the dropdown menu.<br> 2) Select N/A as datatype from the dropdown menu.<br> 3) Add newly created modality concept to Imaging modalitites ConvSet in the concept dictionary. </div>
<div id="modalityContinueDialogMessage" title="Click Save">  Please Click Save to save the modality before continue </div>
<div id="createStudyConceptMessage" title="Create Study Concept"> IMPORTANT NOTES FOR CREATING STUDY CONCEPT: <br> 1) Select Radiology Imaging/Procedure  as class from the dropdown menu. <br> 2) Select N/A as datatype from the dropdown menu. <br> 3)  Include the newly created study concept to modality set using concept dictionary.  </div>
<div id="studyContinueDialogMessage" title="Click Save">  Please Click Save to save the study before continue </div>
<div id="createReportDialogMessage" style="width:430px" title="Create Report"> See radiology user guide for directions on creating report </div>


<div id="viewReportDialog" title="View Report" style="display:none;">
    <iframe id="viewReportIframe" width="1250" height="550"></iframe>
</div>




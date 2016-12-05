<% ui.includeCss("radiology", "modalitylist.css") %>
<% ui.includeJavascript("uicommons", "datatables/jquery.dataTables.min.js") %>
<% ui.includeCss("radiology", "jquery-ui.css") %>
<% ui.includeCss("radiology", "jquery.dataTables.min.css") %>
<% ui.includeJavascript("radiology", "moreInfo.js") %>

<script>
    jq = jQuery;
    jq(document).ready(function() {

    jq('#modality-table').DataTable({
    "sPaginationType": "full_numbers",
    "bPaginate": true,
    "bAutoWidth": false,
    "bLengthChange": true,
    "bSort": true,
    "bJQueryUI": true,
    "iDisplayLength": 5,   
    });

    jq(".study-header-div").hide();
    jq(".study-continue-btn-div").hide();
    jq(".breadcrumbs").show();
    jq(".report-header-div").hide();
    jq("#report-table-div").hide();
    jq("#study-table-div").hide();

    jq( "#create-modality-concept-message" ).dialog({
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

    jq( "#modality-dialog-btn" ).click(function() {
    jq( "#create-modality-concept-message" ).dialog( "open" );
    });

    jq( "#modality-continue-dialog-message" ).dialog({
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

    jq( "#study-continue-dialog-message" ).dialog({
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

    jq( "#create-study-concept-message" ).dialog({
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

    jq( "#create-report-dialog-message" ).dialog({
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

    jq("#study-refresh-btn").click(function() { 
    jq("#study-table-div").hide();
    jq(this).data('clicked', true);
    alert("zzzzzzz");
    jq("#modality-continue-btn").click();
    });

    jq("#report-refresh-btn").click(function() { 
    jq("#report-table-div").hide();
    jq(this).data('clicked', true);
    jq("#study-continue-btn").click();
    });

    jq("#modality-continue-btn").click(function() {
    jq(this).data('clicked', true);
    alert("CLCICLCLCLCLCCLC");
    jq("#modality-software-availability-fragment").hide();
    jq(".study-header-div").show();
    jq(".modality-header-div").hide();
    jq(".study-continue-btn-div").show(); 
    jq(".modality-continue-btn-div").hide();
    jq("#modality-table-div").hide();
    jq("#manage-radiology-breadcrumb").html("<li><i ></i><a href='/openmrs/radiology/adminInitialize.page'> Manage Radiology Module</li>");
    jq("#manage-radiology-breadcrumb li i").addClass("icon-chevron-right link");
    jq("#manage-study-breadcrumb").html("<li><i ></i> Manage Studies</li>");
    jq("#manage-study-breadcrumb li i").addClass("icon-chevron-right link");
    manageStudiesBreadCrumbClickGetStudy();
    });

    jq("#study-continue-btn").click(function() {
    jq(this).data('clicked', true);
    alert("YES");
    jq("#modality-software-availability-fragment").hide();
    jq(".study-header-div").hide();
    jq(".modality-header-div").hide();
    jq(".study-continue-btn-div").hide(); 
    jq(".modality-continue-btn-div").hide();
    jq(".report-header-div").show();
    jq("#study-table-div").hide();
   jq("#manage-study-breadcrumb").html("<li><i ></i><a href='javascript:void(0);' onClick='manageStudiesBreadCrumbClick()'> Manage Studies</li>");
    jq("#manage-study-breadcrumb li i").addClass("icon-chevron-right link");
    jq("#manage-study-breadcrumb li a").addClass("addstudylink");
    jq("#manage-report-breadcrumb").html("<li><i ></i> Manage Reports</li>");
    jq("#manage-report-breadcrumb li i").addClass("icon-chevron-right link");
    manageReportBreadCrumbClick();
    });

    jq("#report-dialog-btn").click(function() {
    jq("#create-report-dialog-message").dialog( "option", "width", 460 );
    jq( "#create-report-dialog-message" ).dialog( "open" );
    });

    jq("#study-dialog-btn").click(function() {
    jq( "#create-study-concept-message" ).dialog( "open" );
    });

    });


    function manageStudiesBreadCrumbClick() {
    manageStudiesBreadCrumbClick.called = true;
    alert('manageStudiesBreadCrumbClick');
    jq('#studysavebtn').data('clicked', false);
    jq(".report-header-div").hide();
    jq("#manage-report-breadcrumb").empty();
    jq(".study-header-div").show();
    jq(".study-continue-btn-div").show();
    jq("#report-table-div").hide();
    manageStudiesBreadCrumbClickGetStudy();
    }

    function manageStudiesBreadCrumbClickGetStudy() {
    //myFunctionT.called = true;
    jq("#study-table-div").show();
    jq('#study-table-div').empty();
    jq('#study-table-div').append('<table></table>');
    jq('#study-table-div table').attr('id','studyTableId');
    jq("#study-table-div table").addClass("studyTableClass");
    var studyTableRow = jq('#study-table-div').children();
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

    jq('#report-table-div').empty();
    jq('#report-table-div').append('<table></table>');
    jq('#report-table-div table').attr('id','reportTableId');
    jq("#report-table-div table").addClass("reportTableClass");
    var reportTableRow = jq('#report-table-div').children();

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


    jq.getJSON('${ ui.actionLink("getStudyConceptsAnswerFromModality") }',
    {
    })
    .error(function(xhr, status, err) {
    alert('AJAX error ' + err);
    })
    .success(function(ret) {
    alert("report goog"); 
    jq('#report-table-div').show();
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
    jq("#view-report-dialog").dialog({
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
    var iframe = document.getElementById('view-report-iframe');
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
        <li id="manage-radiology-breadcrumb">  
            <i class="icon-chevron-right link"></i>
            Manage Radiology Module   
        </li>
        <li id="manage-study-breadcrumb"> 
        </li>
        <li id="manage-report-breadcrumb"> 
        </li>
    </ul>
</div>



<div id ="modality-software-availability-fragment"  >
    ${ ui.includeFragment("radiology", "modalitySoftware") }
</div>

<div class="modality-header-div">
    <label id="modality-dialog-message" for modality-dialog-label> Please Add Modality not appearing in list to Concept Dictionary and Refresh: <a id="modalityconceptmessage" target='_blank' href="http://localhost:8080/openmrs/dictionary/concept.form"> Click here to Concept Dictionary </a></label>
    <input type="button" id="modality-dialog-btn" value = "?" >
    <input type="button" onclick="location.href='/openmrs/pages/radiology/adminInitialize.page'" id="modality-refresh-btn" value="Refresh">
</div>


<div class="study-header-div">
    <label id="study-dialog-message" for modality-dialog-label> Please Add Study not appearing in list to Concept Dictionary and Refresh: <a id="modalityconceptmessage" target='_blank' href="http://localhost:8080/openmrs/dictionary/concept.form"> Click here to Concept Dictionary </a></label>
    <input type="button" id="study-dialog-btn" value = "?" >
    <input type="button" id="study-refresh-btn" value="Refresh">
</div>

<div class="report-header-div">
    <label id="report-dialog-message" for report-dialog-label>  Please Create Report not appearing in list and Refresh: <a id="modalityconceptmessage" target='_blank' href="http://localhost:8080/openmrs/module/htmlformentry/htmlForm.form"> Click here to create HTMLForm  </a></label>
    <input type="button" id="report-dialog-btn" value = "?" >
    <input type="button" id="report-refresh-btn" value="Refresh">
</div>

<div id="modality-table-div">
    <table id="modality-table">
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


<div id="study-table-div" >  
</div>

<div id="report-table-div" >  
</div>

<div class="modality-continue-btn-div">
    <input type="button" id="modality-continue-btn" value="Continue" >
</div>

<div class="study-continue-btn-div">
    <input type="button" id="study-continue-btn" value="Continue" >
</div>

<div id="create-modality-concept-message" title="Create Modality Concept">IMPORTANT NOTES FOR CREATING MODALITY CONCEPT: <br> 1) Select Radiology Imaging/Procedure as class from the dropdown menu.<br> 2) Select N/A as datatype from the dropdown menu.<br> 3) Add newly created modality concept to Imaging modalitites ConvSet in the concept dictionary. </div>
<div id="modality-continue-dialog-message" title="Click Save">  Please Click Save to save the modality before continue </div>
<div id="create-study-concept-message" title="Create Study Concept"> IMPORTANT NOTES FOR CREATING STUDY CONCEPT: <br> 1) Select Radiology Imaging/Procedure  as class from the dropdown menu. <br> 2) Select N/A as datatype from the dropdown menu. <br> 3)  Include the newly created study concept to modality set using concept dictionary.  </div>
<div id="study-continue-dialog-message" title="Click Save">  Please Click Save to save the study before continue </div>
<div id="create-report-dialog-message" style="width:430px" title="Create Report"> See radiology user guide for directions on creating report </div>


<div id="view-report-dialog" title="View Report" style="display:none;">
    <iframe id="view-report-iframe" width="1250" height="550"></iframe>
</div>






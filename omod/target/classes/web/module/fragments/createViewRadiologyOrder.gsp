
<% ui.includeCss("radiology", "createViewRadiologyOrder.css") %>
<% ui.includeCss("radiology", "jquery-ui.css") %>
<%
def conceptStudyClass = config.requireStudyClass   
%>
<%
def conceptDiagnosisClass = config.requireDiagnosisClass  
%>   


<script>
    jq = jQuery;
jq(document).ready(function() {

    jq("#manageOrderWithLinkBreadCrumb").hide();
    jq("#messagePatientBreadCrumb").hide();
    jq("#addOrderBreadCrumb").hide();
    jq("#orderDetailBreadCrumb").hide();
    jq("#addRadiologyOrderForm").hide();
    jq("#contactPatientDiv").hide();
    jq("#performedStatusInProgressOrder").hide();
    jq("#radiologyOrderDetailsDiv").hide();
    jq("#contactRadiologist").hide();
    jq("#performedStatusCompletedOrder").show();

    jq('#performedStatusCompletedOrderTable').dataTable({
        "sPaginationType": "full_numbers",
        "bPaginate": true,
        "bAutoWidth": false,
        "bLengthChange": true,
        "bSort": true,
        "bJQueryUI": true,
        "iDisplayLength": 5,
        "aaSorting": [
                [2, "desc"]
            ] // Sort by first column descending,
    });

    //reload page if click on cancel btn
    jq("#cancelmessage").click(function() {
        alert("canel");
        location.reload();
    });
    
    //contact patient
    jq("#sendEmail").click(function() {
        var recipient = jq("#recipient").val();
        var subject = jq("#subject").val();
        var message = jq("#message").val();
        jq.ajax({
            type: "POST",
            url: "${ ui.actionLink('contactPatient') }",
            data: {
                'recipient': recipient,
                'subject': subject,
                'message': message
            },
            cache: false,
            success: function(data) {

                alert("Sent email");

                //jq("#manageOrderWithLinkBreadCrumb").hide();
                jq("#messagePatientBreadCrumb").hide();
                jq("#manageOrderWithLinkBreadCrumb").show();
                jq("#orderlink").hide();
                jq("#contactPatientDiv").hide();
                //sent comfirmation message
                jq("#completedOrderHeader").show();
                jq("#completedOrderHeader").children("h1").remove();
                jq("<h1></h1>").text("Email sent successfully").appendTo('#completedOrderHeader');
                jq("#addRadiologyOrderForm").hide();
                jq("#performedStatusInProgressOrder").hide();
                jq("#radiologyOrderDetailsDiv").hide();
                jq("#contactRadiologist").hide();
                jq("#performedStatusCompletedOrder").show();

            }
        });
    });

    //cancel radiology order
    jq("#cancelForm").click(function() {

        location.reload();
    });
    
    //get in progress orders
    jq("#InProgressOrdersList").click(function() {
        jq("#performedStatusCompletedOrder").hide();
        jq("#performedStatusInProgressOrder").empty();
        jq("#performedStatusInProgressOrder").show();
        jq("#completedOrderHeader").children("h1").remove();
        jq("#radiologyOrderDetailsDiv").hide();
        var patient = jq("#patientId p").text();
        var patientId = patient.substr(patient.indexOf("#") + 1)
        jq.getJSON('${ ui.actionLink("getInProgressRadiologyOrders") }', {
                'patientId': patientId,
            })
            .error(function(xhr, status, err) {
                alert('AJAX error ' + err);
            })
            .success(function(ret) {
                jq("<h1></h1>").text("IN PROGRESS RADIOLOGY ORDERS").appendTo('#performedStatusInProgressOrder');
                jq('#performedStatusInProgressOrder').append('<table></table>');
                jq('#performedStatusInProgressOrder table').attr('id', 'patientCompletedOrdersDatatable');
                jq("#performedStatusInProgressOrder table").addClass("patientCompletedOrdersClass");
                var patientCompletedOrdersTable = jq('#performedStatusInProgressOrder table');
                patientCompletedOrdersTable.append('<thead><tr><th> Order</th><th> StartDate</th><th> OrderStatus</th></tr></thead><tbody>');
                for (var i = 0; i < ret.length; i++) {
                    var studyName = ret[i].study.studyname;
                    var dateCreated = ret[i].dateCreated;
                    var scheduledStatus = ret[i].study.scheduledStatus;
                    patientCompletedOrdersTable.append('<tr><td> ' + studyName + ' </td><td> ' + dateCreated + '</td><td> ' + scheduledStatus + '</td></tr>');
                }
                patientCompletedOrdersTable.append("</tbody>");

                jq('#patientCompletedOrdersDatatable').DataTable({
                    "sPaginationType": "full_numbers",
                    "bPaginate": true,
                    "bAutoWidth": false,
                    "bLengthChange": true,
                    "bSort": true,
                    "bJQueryUI": true,
                    "iDisplayLength": 5,
                    "aaSorting": [
                            [1, "desc"]
                        ] // Sort by first column descending,

                });
            })
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
        buttons: {

            "Ok": function() {

                jq(this).dialog('close');
            }
        },

    });
    
    //get completed report ready orders
    jq("#CompletedOrdersList").click(function() {
        jq("#performedStatusCompletedOrder").show();
        jq("#performedStatusInProgressOrder").hide();
        jq("#completedOrderHeader").children("h1").remove();
        jq('#radiologyOrderDetailsDiv').children("h1").remove();
        jq('#radiologyOrderDetailsDiv').children("h1").remove();
        jq("#radiologyOrderDetailsDiv").hide();

    });


    //create new radiology order and save in database and Pacs
    jq("#submitForm").click(function() {
        var pat = "${patient}".split("#");
        var patient = pat[1];
        var studyOrder = jq("#studyTags").val();
        var diagnosisOrder = jq("#diagnosisTags").val();
        var instructionOrder = jq("#orderInstruction").val();
        var priorityOrder = jq('select[name=priority]').val();
        alert("Sutyd " + studyOrder);
        jq.getJSON('${ ui.actionLink("placeRadiologyOrder") }', {
                'patient': patient,
                'study': studyOrder,
                'diagnosis': diagnosisOrder,
                'instruction': instructionOrder,
                'priority': priorityOrder
            })
            .error(function(xhr, status, err) {
                alert('AJAX error ' + err);
            })
            .success(function(ret) {
                jq("#messagePatientBreadCrumb").hide();
                jq("#addOrderBreadCrumb").hide();
                jq("#orderDetailBreadCrumb").hide();
                jq("#completedOrderHeader").show();
                jq("#completedOrderHeader").children("h1").remove();
                jq("<h1></h1>").text("Radiology order sent successfully").appendTo('#completedOrderHeader');
                jq("#addRadiologyOrderForm").hide();
                jq("#contactPatientDiv").hide();
                jq("#performedStatusInProgressOrder").hide();
                jq("#radiologyOrderDetailsDiv").hide();
                jq("#contactRadiologist").hide();
                jq("#performedStatusCompletedOrder").show();

            })
    });

    //create new radiology order
    jq("#addRadiologyOrderBtn").click(function() {
        jq("#completedOrderHeader").hide();
        jq("#performedStatusCompletedOrder").hide();
        jq("#contactPatientDiv").hide();
        jq("#performedStatusInProgressOrder").hide();
        jq("#radiologyOrderDetailsDiv").hide();
        jq("#addRadiologyOrderForm").show();
        jq("#studyTags").val('');
        jq("#diagnosisTags").val('');
        jq("#orderInstruction").val('');
        jq("#manageOrderWithNoLinkBreadCrumb").hide();
        jq("#manageOrderWithLinkBreadCrumb").show();
        jq("#messagePatientBreadCrumb").hide();
        jq("#addOrderBreadCrumb").show();
        jq("#orderDetailBreadCrumb").hide();
    });



    //message patient
    jq("#emailform").click(function() {
        jq("#performedStatusCompletedOrder").hide();
        jq("#performedStatusInProgressOrder").hide();
        jq("#radiologyOrderDetailsDiv").hide();
        jq("#contactPatientDiv").show();
        jq("#addRadiologyOrderForm").hide();
        jq("#contactRadiologist").hide();
        jq("#completedOrderHeader").hide();
        jq("#message").val('');
        jq("#manageOrderWithNoLinkBreadCrumb").hide();
        jq("#manageOrderWithLinkBreadCrumb").show();

        jq("#messagePatientBreadCrumb").show();
        jq("#addOrderBreadCrumb").hide();
        jq("#orderDetailBreadCrumb").hide();
    });
    
    //get order detail of the order
    jq("#performedStatusCompletedOrderTable tr").click(function() {
        jq("#manageOrderWithNoLinkBreadCrumb").hide();
        jq("#manageOrderWithLinkBreadCrumb").show();
        jq("#messagePatientBreadCrumb").hide();
        jq("#addOrderBreadCrumb").hide();
        jq("#orderDetailBreadCrumb").show();
        //get the order id
        jq(this).addClass('selected').siblings().removeClass('selected');
        var value = jq(this).find('td:first').html();
        alert(value);
        var splitvalue = value.split('>');
       
        jq("#radiologyOrderDetailsDiv > h1").remove();
        jq("#radiologyOrderDetailsDiv").show();
        jq("#performedStatusCompletedOrder").hide();
        
        jq("#completedOrderHeader > h1").remove();
        ordervalue = splitvalue[1];
        alert(ordervalue);
        var orderId = ordervalue.substr(0, ordervalue.indexOf('<'));
        //var orderId = ordervalue.substr(0, 2);
        jq('#radiologyOrderDetailsTableId').empty();
        alert(orderId);
        <% if (radiologyOrders) { %>
        <% radiologyOrders.each { anOrder -> %>
        var radiologyorderId = ${ anOrder.orderId };
        if (orderId == radiologyorderId) {
            var orderencounterId = ${ anOrder.study.studyReportSavedEncounterId };
            jq('#radiologyOrderDetailsDiv').append("<h1 class='order'  id= 'orderDetailHeading'>RADIOLOGY ORDER DETAILS - CompletedDate :   ${ anOrder.study.obsCompletedDate }  </h1>");
            jq('#radiologyOrderDetailsDiv').append(jq('#radiologyOrderDetailsTableId'));
            alert("orderencounterId" + orderencounterId);
            localStorage.setItem("orderencounterId", orderencounterId);
            localStorage.setItem("orderId", orderId);
            jq('#radiologyOrderDetailsTableId').append('<thead><tr><th> Report</th><th> Radiologist</th><th> Instructions </th><th> Diagnosis</th><th> Study</th><th>ViewStudy</th><th> ContactRadiologist</th></tr></thead>');
            jq('#radiologyOrderDetailsTableId').append('<tbody><tr><td><a onclick="ViewReport();"> Obs</a> </td><td> ${anOrder.study.studyReportRadiologist}</td><td> ${anOrder.instructions} </td><td> ${anOrder.orderdiagnosis}</td><td>${anOrder.study.studyname}</td><td id="dogdog" href="ddasdas"><a id="tiger" class="tiger" href="${ dicomViewerUrladdress + "studyUID=" + anOrder.study.studyInstanceUid + "&patientID=" + patient.patientIdentifier }" onclick="loadImages(); return false;" >ViewStudy</a></td><td><a onclick="contactRadiologist();"> ContactRadiologist</a></td></tr></tbody>');

        }

        <% } %>
        <% } %>

    });

    //clear radiologist message
    jq("#clearMessage").click(function() {
        alert("111111 ");
        jq('#contactRadiologistDialogBox').dialog('close');
    });
    
    //send email to radiologist
    jq("#sendEmailRadiologist").click(function() {
        var recipient = jq("#recipientRadiologist").val();
        var subject = jq("#subjectRadiologist").val();
        alert(subject);
        var message = jq("#messageRadiologist").val();
        alert(message);
        jq.ajax({
            type: "POST",
            url: "${ ui.actionLink('contactRadiologist') }",
            data: {
                'recipient': recipient,
                'subject': subject,
                'message': message
            },
            cache: false,
            success: function(data) {
                alert("999ppp");
                jq('#contactRadiologistDialogBox').dialog('close');
                jq("<h1>Email sent successfully</h1>").insertBefore(jq('#radiologyOrderDetailsDiv h1'));

            }
        });
    });
});


//view study images in oviyum in the dialog box
function loadImages() {
    alert("addressValue");
    var addressValue = jq('.tiger').attr("href");
    alert(addressValue);
    jq("#viewStudyImageIframe").attr('src', jq('.tiger').attr("href"));
    jq("#viewStudyImageDialog").dialog({
        width: 400,
        height: 450,
        modal: true,
        buttons: {
            "Close": function() {
                jq(this).dialog('close');
            }
        },
        close: function() {
            jq("#viewStudyImageIframe").attr('src', "about:blank");
        }
    });
    return false;
}


//view report based on the report encounterId in the dialog box
function ViewReport() {
    var orderencounterId = localStorage.getItem("orderencounterId");
    jq.getJSON('${ ui.actionLink("getEncounterIdObs") }', {
            'encounterId': orderencounterId
        })
        .error(function(xhr, status, err) {
            alert('AJAX error ' + err);
        })
        .success(function(ret) {

            jq('#obsDialogBoxText').append('<table></table>');
            jq('#obsDialogBoxText table').attr('id', 'obsDialogBoxTextDatatable');
            jq("#obsDialogBoxText table").addClass("obsDialogBoxTextclass");
            var obsDialogBoxTextTable = jq('#obsDialogBoxText table');
            obsDialogBoxTextTable.append('<thead><tr><th>Concept</th><th>Value Text</th></tr></thead><tbody>');
            for (var i = 0; i < ret.length; i++) {
                var concept = ret[i].Concept;
                var valueText = ret[i].valueText;
                obsDialogBoxTextTable.append('<tr><td>' + concept + '</td><td>' + valueText + '</td></tr>');
            }
            obsDialogBoxTextTable.append("</tbody>");
            jq("#obsDialogBox").dialog("open");

        })

}


//autofill the radiologist email with the patient and order info
function contactRadiologist() {
    alert("run my contactRadiologist");
    jq("#contactRadiologist").show();
    var orderId = localStorage.getItem("orderId");
    alert("orderId" + orderId);
    jq('#messageRadiologist').val('foobar');
    <% radiologyOrders.each { anOrder -> %>
    var radiologyorderId = ${ anOrder.orderId };
    if (orderId == radiologyorderId) {
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
    jq("#contactRadiologistDialogBox").dialog("open");
}

</script>


<script>
    jq(function() {
        //get study list for autocomlete feature
        jq("#studyTags").autocomplete({
            source: function(request, response) {
                var results = [];
                jq.getJSON('${ ui.actionLink("getStudyAutocomplete") }', {
                        'query': request.term,
                        'conceptStudyClass': "<%= conceptStudyClass %>"
                    })
                    .success(function(data) {
                        for (index in data) {
                            var item = data[index];
                            results.push(item.name);
                        }
                        response(results);
                    })
                    .error(function(xhr, status, err) {
                        alert('AJAX error ' + err);
                    });
            }
        })

        //get diagnosis list for autocomlete feature
        jq("#diagnosisTags").autocomplete({
            source: function(request, response) {
                var results = [];
                jq.getJSON('${ ui.actionLink("getDiagnosisAutocomplete") }', {
                        'query': request.term,
                        'conceptDiagnosisClass': "<%= conceptDiagnosisClass %>"
                    })
                    .success(function(data) {
                        for (index in data) {
                            var item = data[index];
                            results.push(item.name);
                        }
                        response(results);
                    })
                    .error(function(xhr, status, err) {
                        alert('AJAX error ' + err);
                    });
            }
        })
    });
</script>



<!-- breadcrumbs -->
<div class="breadcrumbradiologyorder">
    <ul id="breadcrumbs" class="radiologyorderbreadcrumb">
        <li>
            <a href="/openmrs/index.htm">    
                <i class="icon-home small"></i>  
            </a>       
        </li>
        <li id="patientNameBreadCrumb">  
            <i class="icon-chevron-right link"></i>
            <a href="/openmrs/coreapps/clinicianfacing/patient.page?patientId=${patient.person.uuid}&">    
                <i >${patient.familyName + ', ' + patient.givenName}</i>  
            </a> 
        </li>
        <li id="manageOrderWithNoLinkBreadCrumb">  
            <i class="icon-chevron-right link"></i>
            Manage Radiology Order         
        </li>
        <li id="manageOrderWithLinkBreadCrumb">
            <i class="icon-chevron-right link"></i>
            <a href="/openmrs/radiology/radiologyOrder.page?patientId=${patient.person.uuid}&returnUrl="> 
                Manage Radiology Order
            </a> 
        </li>
        <li id="messagePatientBreadCrumb">  
            <i class="icon-chevron-right link"></i>
            Message Patient
        </li>
        <li id="addOrderBreadCrumb">  
            <i class="icon-chevron-right link"></i>
            Add Radiology Order
        </li>
        <li id="orderDetailBreadCrumb">  
            <i class="icon-chevron-right link"></i>
            Radiology Order Detail
        </li>
    </ul>
</div>
<!-- completed radiology order table header -->
<div id="completedOrderDiv">
    <div id="completedOrderHeader" class="performedStatusesContainer">
        <span class="left"><button type="button" id="CompletedOrdersList">Completed</button></span>
        <span class="left"><button type="button" id="InProgressOrdersList">InProgress</button></span>
        <span class="right"><button type="button" id="addRadiologyOrderBtn">Add Radiology Order</button></span>
        <span class="right"><button type="button" id="emailform">Message Patient</button></span>
    </div>
<!-- completed radiology order table -->
    <div id="performedStatusCompletedOrder">
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
                    <td> ${anOrder.study.studyReportRadiologist}</td>
                    <td>${ anOrder.study.obsCompletedDate } </td>
                </tr>
                <% } %>  
            </tbody>
        </table>
    </div>
<!-- in progress radiology order table -->
    <div id="performedStatusInProgressOrder">
    </div>
<!-- contact patient -->
    <div id="contactPatientDiv">
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
<!-- radiology order detail table -->
    <div id = "radiologyOrderDetailsDiv">
        <table id="radiologyOrderDetailsTableId">
        </table>
    </div>
</div>
<!-- view study image dialog -->
<div id="viewStudyImageDialog" title="View Study Image" style="display:none;">
    <iframe id="viewStudyImageIframe" width="550" height="350"></iframe>
</div>
<!-- add radiology order -->
<div id="addRadiologyOrderForm">
    <h2> ADD RADIOLOGY ORDER</h2>
    <div class="studyfieldclass">
        <label for="tags">Study </label>
        <input id="studyTags">
    </div>

    <div class="fieldclass">
        <label for="tags">Diagnosis </label>
        <input id="diagnosisTags">
    </div>

    <div class="fieldclass"><label>Instruction </label>
        <textarea  name="orderInstruction" id="orderInstruction" rows="1" cols="50">  </textarea>
    </div>

    <div class="fieldclass"><label>Priority </label>
        <span>
            <select name="priority" id="priority">
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
<!-- obs dialog box -->
<div id="obsDialogBox" title="View Obs" style="display:none;">
    <div id="obsDialogBoxText" width="550" height="350"></div>
</div>

<!-- contact radiologist -->
<div id="contactRadiologistDialogBox" title="ContactRadiologist" style="display:none;">
    <div id="contactRadiologist" width="550" height="350"></div>

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
                    <input class="fields" id="clearMessage" type="button" value="Cancel" />
                </td>
            </tr>
        </table>

    </center>
</div>


<div id="patientId">
    <p style="display:none;">${ patient }</p>
</div>



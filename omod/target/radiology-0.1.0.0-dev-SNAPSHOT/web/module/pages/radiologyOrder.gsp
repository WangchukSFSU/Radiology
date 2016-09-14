

<%
ui.decorateWith("appui", "standardEmrPage")
ui.includeJavascript("uicommons", "datatables/jquery.dataTables.min.js")
ui.includeCss("uicommons", "datatables/dataTables_jui.css")
%>


<% ui.includeCss("radiology", "radiologyOrder.css") %>
    
<% ui.includeCss("radiology", "performedStatusCompletedOrder.css") %>
   


<script>
    jq = jQuery;
    
 jq(function(){
  function runn() {
  alert("yeheyee");
         jq('<div/>', {'class':'myDlgClass', 'id':'link-'+( jq(this).index()+1)})
        .html( jq('<iframe/>', {
            'src' :  jq(this).attr(url),
            'style' :'width:100%; height:100%;border:none;'
        })).appendTo('body')
        .dialog({
            'title' :  jq(this).text(),
            'width' : 400,
            'height' :250,
            buttons: [ { 
                    text: "Close",
                    click: function() {  jq( this ).dialog( "close" ); } 
                } ]
        });
        
        
        }
    });

    
    </script>
    
<script>
    jq = jQuery;
    jq(document).ready(function() { 

 
    
   
    jq("#orders").hide();
    jq("#messagepatient").hide();
    jq("#addorder").hide();
    jq("#orderdetail").hide();
   
   
    
    jq("#AddRadiologyOrderForm").hide();
    jq("#EmailForm").hide();
    jq("#performedStatusInProgressOrder").hide();
    jq("#performedStatusCompletedObsSelect").hide();
    jq("#HTMLFORM").hide();
    jq("#ContactRadiologist").hide();
    jq("#performedStatusCompletedOrder").show();
    
    jq("#addRadiologyOrderBtn").click(function(){
    jq("#performedStatusCompletedOrder").hide();
    jq("#EmailForm").hide();
    jq("#performedStatusInProgressOrder").hide();
    jq("#performedStatusCompletedObsSelect").hide();
    jq("#ContactRadiologist").hide(); 
    jq("#AddRadiologyOrderForm").show();
    
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
    
     jq("#ordernolink").hide();
    jq("#orders").show();
    jq("#messagepatient").show();
    jq("#addorder").hide();
    jq("#orderdetail").hide();
    });
    
    
     
jq(".email_link").click(function() {
		
                alert("Heretre");
                
                });
    
    
   jq("#performedStatusCompletedOrderTable tr").click(function(){

   jq("#ordernolink").hide();
    jq("#orders").show();
    jq("#messagepatient").hide();
    jq("#addorder").hide();
    jq("#orderdetail").show();
   
   
    jq(this).addClass('selected').siblings().removeClass('selected');    
    var value=jq(this).find('td:first').html();
    alert(value); 
    var splitvalue = value.split('>');
     jq("#performedStatusCompletedObsSelect").show();
     jq("#performedStatusCompletedOrder").hide();
    ordervalue = splitvalue[1];
    alert(ordervalue);
    var orderId= ordervalue.substr(0, ordervalue.indexOf('<'));
   //var orderId = ordervalue.substr(0, 2);
  alert(orderId);
     <% if (radiologyOrders) { %>
   
    <% radiologyOrders.each { anOrder -> %>
    
    var radiologyorderId = ${anOrder.orderId} ;
  
    if(orderId == radiologyorderId) {

 
  jq('#completedOrderObs').append( '<thead><tr><th> Report</th><th> Provider</th><th> Instructions </th><th> Diagnosis</th><th> Study</th><th> ContactRadiologist</th><th>tsest</th></tr></thead>' );


jq('#completedOrderObs').append( '<tbody><tr><td id="dogdog"><a href="http://wikipedia.com/" class="test" onclick="loadImages(); return false;" >comment #1</a></td><td><a onclick="runMyFunction();"> Obs</a> </td><td> ${anOrder.orderer.name}</td><td> ${anOrder.instructions} </td><td> ${anOrder.orderdiagnosis}</td><td><a id="appledog" href="${ dicomViewerUrladdress + "studyUID=" + anOrder.study.studyInstanceUid + "&patientID=" + patient.patientIdentifier }"> ${anOrder.study.studyInstanceUid}</a></td><td><a onclick="contactRadiologist();"> ContactRadiologist</a></td></tr></tbody>' );
  
}
    
    
   <% } %>
    <% } %> 
    
 jq('#completedOrderObs').dataTable({
            "sPaginationType": "full_numbers",
            "bPaginate": true,
            "bAutoWidth": false,
            "bLengthChange": true,
            "bSort": true,
            "bJQueryUI": true,
             "iDisplayLength": 5,
    
        });
    
    });
    
    });
    
   function loadImages() {
   alert("HUHUHU");
   var href = jq(this).attr('href');
   alert(href);
        jq('<div/>', {'class':'myDlgClass', 'id':'link-'+( jq(this).index()+1)})
        .html( jq('<iframe/>', {
            'src' :  jq(this).attr('href'),
            'style' :'width:100%; height:100%;border:none;'
        })).appendTo('body')
        .dialog({
            'title' :  jq(this).text(),
            'width' : 400,
            'height' :250,
            buttons: [ { 
                    text: "Close",
                    click: function() {  jq( this ).dialog( "close" ); } 
                } ]
        });
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
  alert("run my function");
  jq("#HTMLFORM").show(); 
   jq("#ContactRadiologist").hide(); 
 
 
}
function contactRadiologist() {
  alert("run my contactRadiologist");
  jq("#HTMLFORM").hide(); 
  jq("#ContactRadiologist").show();
 
}
    function selectFunction(selectedValue) {
   // location.reload();
    jq("#ordernolink").show();
    jq("#orders").hide();
    jq("#messagepatient").hide();
    jq("#addorder").hide();
    jq("#orderdetail").hide();
    
    if(selectedValue == "COMPLETED") {
  
    jq("#performedStatusCompletedOrder").show();
  
    jq("#EmailForm").hide();
    jq("#performedStatusInProgressOrder").hide();
    jq("#AddRadiologyOrderForm").hide();
    jq("#performedStatusCompletedObsSelect").hide();
    
    }  
   
     if(selectedValue == "IN_PROGRESS") {
    
    jq("#performedStatusCompletedOrder").hide();
    jq("#EmailForm").hide();
    jq("#performedStatusInProgressOrder").show();
    jq("#AddRadiologyOrderForm").hide();
    jq("#performedStatusCompletedObsSelect").hide();
    
    
    alert("jiiii progress" + selectedValue);
    } 
    
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
    "aaSorting": [[ 1, "desc" ]] // Sort by first column descending,
    
            
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
        Manage Order         
    </li>
    <li id="orders">
       <i class="icon-chevron-right link"></i>
        <a href="/openmrs/radiology/radiologyOrder.page?patientId=${patient.person.uuid}&returnUrl="> 
        Manage Orders
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
         Order Detail
         
    </li>
   
</ul>
</div>

<div>
    <div id="performedStatusesDropdown" class="performedStatusesContainer">
        <span>
            <select name="performedStatuses" id="performedStatuses" onchange="selectFunction(this.value)">
                <option name="performedStatuses" selected="selected" value="${performedStatuses.value}">COMPLETED</option>
                <% performedStatuses.each { performedStatuses -> %>
                <option name="performedStatuses" value="${performedStatuses.value}">${performedStatuses.value}</option>
                <% } %>
            </select>        
        </span>

        <span class="right"><button type="button" id="addRadiologyOrderBtn">Add Radiology Order</button></span>
        <span class="right"><button type="button" id="emailform">Message Patient</button></span>

    </div>


   

     <div id="performedStatusInProgressOrder">
        ${ ui.includeFragment("radiology", "performedStatusInProgressOrder",[ returnUrl: '${returnUrl}',
        patient: '${patient}'
        ]) }

    </div>
    

    <div id="AddRadiologyOrderForm">
        ${ ui.includeFragment("radiology", "addRadiologyOrderForm",[ returnUrl: '${returnUrl}',
        patient: '${patient}'
        ]) }
    </div>



    <div id="EmailForm">
        ${ ui.includeFragment("radiology", "contactPatient",[ returnUrl: '${returnUrl}',
        patient: '${patient}'
        ]) }
    </div>


  


<div id = "performedStatusCompletedObsSelect">
    
  <h1>RADIOLOGY ORDER DETAILS</h1>
  
<table id="completedOrderObs">
   
    

</table>

</div>
    
    

       <div id="ContactRadiologist" width="50%">
        ${ ui.includeFragment("radiology", "contactRadiologist",[ returnUrl: '${returnUrl}',
        patient: '${patient}'
        ]) }
    </div>
    
    <div id="performedStatusCompletedOrder">
        <h1>COMPLETED RADIOLOGY ORDERS</h1>
    <table id="performedStatusCompletedOrderTable">
    <thead>
        <tr>
            <th>Order</th>
            <th>OrderCompletedDate</th>
            
        </tr>
    </thead>
     <tbody>
    <% radiologyOrders.each { anOrder -> %>
    <tr>
        <td> <p style="display:none;">${ anOrder.orderId }</p>
            ${anOrder.study.studyname}</td>
        <td>${ anOrder.dateCreated } </td>
        

    </tr>
    <% } %>  
</tbody>
</table>
 </div>

  
  <div id="HTMLFORM" width="50%">
        ${ ui.includeFragment("radiology", "reportObs",[ returnUrl: '${returnUrl}',
        patient: '${patient}'
        ]) }
    </div>
        
    
    
    
    
    
     <tbody>
    <% dicomViewerUrl.each { url -> %>
    <tr>
       
  <td><a onclick=openDialogT(" http://localhost:8081/oviyam2/viewer.html?serverName=oviyamlocal&studyUID=1.2.826.0.1.3680043.8.2186.1.10&patientID=10000X ") > oviyan </a></td>
    <td><a href="http://localhost:8081/oviyam2/viewer.html?serverName=oviyamlocal&studyUID=1.2.826.0.1.3680043.8.2186.1.10&patientID=10000X">Heera IT</a> </td>
    </tr>
    <% } %>  
</tbody>



<script>
    jq = jQuery;
    
 jq(function(){
 
    jq(".test").click(function () {
    
        jq("#thedialog").attr('src', jq(this).attr("href"));
        jq("#somediv").dialog({
            width: 400,
            height: 450,
            modal: true,
            close: function () {
                jq("#thedialog").attr('src', "about:blank");
            }
        });
        return false;
    });
    
    
    
     jq('a #apple').on('click', function(e){
        e.preventDefault();
         jq('<div/>', {'class':'myDlgClass', 'id':'link-'+( jq(this).index()+1)})
        .html( jq('<iframe/>', {
            'src' :  jq(this).attr('href'),
            'style' :'width:100%; height:100%;border:none;'
        })).appendTo('body')
        .dialog({
            'title' :  jq(this).text(),
            'width' : 400,
            'height' :250,
            buttons: [ { 
                    text: "Close",
                    click: function() {  jq( this ).dialog( "close" ); } 
                } ]
        });
    });
});
    
    </script>

<a href="http://localhost:8081/oviyam2/viewer.html?serverName=oviyamlocal&studyUID=1.2.826.0.1.3680043.8.2186.1.10&patientID=10000X">Heera IT</a>

<a id ="apple" href="${ dicomViewerUrladdress + "studyUID=" + "1.2.826.0.1.3680043.8.2186.1.10" + "&patientID=" + "10000X" }"> kdsdf </a>



<a href="http://wikipedia.com/" class="test">comment #1</a><br>
<a href="http://ebay.com/" class="test">comment #2</a><br>
<a href="http://ask.com/" class="test" >comment #3</a><br>
<div id="somediv" title="this is a dialog" style="display:none;">
    <iframe id="thedialog" width="350" height="350"></iframe>
</div>


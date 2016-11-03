
<% ui.includeCss("radiology", "radiologistInProgressOrder.css") %>


<script>
    jq = jQuery;
    jq(document).ready(function() {
    
     

    
      jq('#performedStatusInProgressOrderTable').dataTable({
            "sPaginationType": "full_numbers",
            "bPaginate": true,
            "bAutoWidth": false,
            "bLengthChange": true,
            "bSort": true,
            "bJQueryUI": true,
            
             "iDisplayLength": 5,
    "aaSorting": [[ 1, "desc" ]] // Sort by first column descending,
    
            
        });

 jq("#performedStatusInProgressOrderDetail").hide(); 
 

 
 
 
  
    
    
  
    
    jq("#dicomtable table tbody").delegate("tr", "click", function(e) {
     

 alert("lpo");
 });
 


jq("#test").click(function() {
alert("dsdads");
jq("#somediv").load('/openmrs/radiology/radiologistActiveOrders.page').dialog({modal:true}); 
    });  
    
    
    });

  
  function displayReport(el) {
   jq(el).addClass("highlight").css("background-color","#CCCCCC");
   alert("33333");
 
   jq('#orderdetails').show();
    jq("#activeorders").html("<li><i ></i><a href='/openmrs/radiology/radiologistActiveOrders.page'> RadiologyOrdersToSendImageToPAC</li>");
jq("#activeorders li i").addClass("icon-chevron-right link");


jq("#orderdetails").html("<li><i ></i> SendDicomToPAC</li>");
jq("#orderdetails li i").addClass("icon-chevron-right link");

alert("11111");
   
    jq(el).addClass('selected').siblings().removeClass('selected');  
var value= jq(el).closest('tr').find('td:first').text();
   // var value=jq(el).find('td:first').html();
    
    alert(value); 
    var orderId = parseInt(value, 10);
alert(orderId);
    jq("#performedStatusInProgressOrderDetail").show();
      jq("#performedStatusInProgressOrder").hide();
    var splitvalue = value.split('');
    alert("otertertetete " +splitvalue);
    ordervalue = splitvalue[1];
    alert("ordervalue" +ordervalue);
   //var orderId = ordervalue.substr(0, 2);
      //alert("orderId" +orderId);
      //var orderId= ordervalue.substr(0, ordervalue.indexOf('<'));
      alert("orderId" +orderId);
    
   alert("yess");
  
    <% inProgressRadiologyOrders.each { anOrder -> %>
    
    var radiologyorderId = ${anOrder.orderId} ;

     if(orderId == radiologyorderId) {
   
  localStorage.setItem("radiologyorderId", orderId);
    
    
    alert("YYEYYEYYEYEE");
    
 
    
jq('#dicomtable').empty();
jq('#dicomtable').append('<table></table>');
jq('#dicomtable table').attr('id','dicomtablelistid');
jq("#dicomtable table").addClass("studyclass");
var dicomtablelist = jq('#dicomtable').children();

  
  dicomtablelist.append( '<thead><tr><th>Study/Associated Files</th><th>Start Date</th></tr></thead><tbody>' );
  dicomtablelist.append( '<tr><td>${anOrder.study.studyname}</td><td>${anOrder.dateCreated}</td></tr>' );
 
  
  
  
  <% apo.each { apoo -> %>


  dicomtablelist.append( '<tr><td style="text-indent: 50px;">    ${ apoo }</td></tr>' );

   <% } %>
 dicomtablelist.append( '<tr>  <td> <a href="javascript: void(0)" id="linkActButton" onclick="submitObs(); return false;">Send</a></td></tr>' );
     dicomtablelist.append("</tbody>");


     
     }
    
    
   <% } %>
  
     
     
    }
    
    
    
  
    function submitObs() {

    alert("YESS");
   var radiologyorderId = localStorage.getItem("radiologyorderId");
   
   alert("radiologyorderId " + radiologyorderId);
   
   
    jq.getJSON('${ ui.actionLink("updateActiveOrders") }',
    { 'radiologyorderId': radiologyorderId
    })
    .error(function(xhr, status, err) {
    alert('AJAX error ' + err);
    })
    .success(function(ret) {
    
       jq('#orderdetails').hide();
    jq('#dicomtable').empty();
    jq("<h1></h1>").text("dicom files(s) sent successfully").appendTo('#dicomtable');
    jq("<h1></h1>").text("CLICK RADIOLOGY ORDER TO SEND IMAGE TO PAC").appendTo('#dicomtable');
 
     jq('#dicomtable').append('<table></table>');
    jq('#dicomtable table').attr('id','updateActiveOrderDatatable');
    jq("#dicomtable table").addClass("reporttableclass");
var dicomtablelist = jq('#dicomtable table');
    dicomtablelist.append( '<thead><tr><th>Order</th><th>OrderStartDate</th><th>OrderPriority</th></tr></thead><tbody>' );
     alert("COOL");
    for (var i = 0; i < ret.length; i++) {
    var anOrderId = ret[i].orderId;
    var studyname = ret[i].study.studyname;
    var dateCreated = ret[i].dateCreated;
    var urgency = ret[i].urgency;

 dicomtablelist.append( '<tr><td><a id="fillreport" href='+ studyname +' class="fillreport" onclick="displayReport(this); return false;" ><p style="display:none;">'+ anOrderId +'</p>'+ studyname +' </a></td><td>'+ dateCreated +'</td><td>'+ urgency +'</td></tr>' );
 


    }
    
    
      dicomtablelist.append("</tbody>");
       jq('#updateActiveOrderDatatable').dataTable({
            "sPaginationType": "full_numbers",
            "bPaginate": true,
            "bAutoWidth": false,
            "bLengthChange": true,
            "bSort": true,
            "bJQueryUI": true,
            
             "iDisplayLength": 5,
    "aaSorting": [[ 1, "desc" ]] // Sort by first column descending,
    
            
        });
    
    })
   
   
    
   
    }
    
    
    
       function fillReport() {
 
        var addressValue = jq('.fillreport').attr("href");
        alert(addressValue );
        
         jq("#thedialogreport").attr('src', jq('.fillreport').attr("href"));
        jq("#somedivreport").dialog({
            width: 600,
            height: 450,
            modal: false,
            close: function () {
                jq("#thedialogreport").attr('src', "about:blank");
            }
        });
        return false;
        
       
   }
    
     function loadImages() {
 
        var addressValue = jq('.tiger').attr("href");
        alert(addressValue );
        
         jq("#thedialog").attr('src', jq('.tiger').attr("href"));
        jq("#somediv").dialog({
            width: 400,
            height: 450,
            modal: false,
            close: function () {
                jq("#thedialog").attr('src', "about:blank");
            }
        });
        return false;
        
       
   }
    
function runMyFunction() {
  alert("run my function");
 
   jq("#ContactRadiologist").hide(); 
 
 
}

  
function contactRadiologist() {
  alert("run my contactRadiologist");
   
  jq("#ContactRadiologist").show();
 
 
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
   
</script>

   <div class="breadcrumbsactiveorders">
 <ul id="breadcrumbs" class="apple">
    <li>
        <a href="/openmrs/index.htm">    
        <i class="icon-home small"></i>  
        </a>       
    </li>
    <li id="activeorders">
       <i class="icon-chevron-right link"></i>
        
        RadiologyOrdersToSendImageToPAC
         
    </li>
    <li id="orderdetails">  
       
         
    </li>
   
</ul>
</div>
    



    <div id="performedStatusInProgressOrder">
  
        <h1>CLICK RADIOLOGY ORDER TO SEND IMAGE TO PAC</h1>
<table id="performedStatusInProgressOrderTable">
    <thead>
        <tr>
            <th>Order</th>
            <th>OrderStartDate</th>
            <th>OrderPriority</th>
        </tr>
    </thead>
    <tbody>
    <% inProgressRadiologyOrders.each { anOrder -> %>
    <tr>
        <td><a id="fillreport" href='+ studyname +' class="fillreport" onclick="displayReport(this); return false;"><p style="display:none;">${ anOrder.orderId }</p>
                ${anOrder.study.studyname}</a></td>
        <td>${ anOrder.dateCreated } </td>
        <td>${ anOrder.urgency }</td>

    </tr>
    <% } %>  
</tbody>
</table>
</div>


<div id = "dicomtable">

</div>





















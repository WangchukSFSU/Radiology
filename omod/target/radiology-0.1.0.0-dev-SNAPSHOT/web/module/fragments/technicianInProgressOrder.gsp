
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
 
  

    
   jq("#performedStatusInProgressOrderTable tr").click(function(){
   
   
   
   
    jq("#activeorders").html("<li><i ></i><a href='/openmrs/radiology/radiologistActiveOrders.page'> Radiology Active Orders</li>");
jq("#activeorders li i").addClass("icon-chevron-right link");


jq("#orderdetails").html("<li><i ></i> Send Dicom to PACS</li>");
jq("#orderdetails li i").addClass("icon-chevron-right link");


   
    jq(this).addClass('selected').siblings().removeClass('selected');    
    var value=jq(this).find('td:first').html();
    
    alert(value); 
    jq("#performedStatusInProgressOrderDetail").show();
      jq("#performedStatusInProgressOrder").hide();
    var splitvalue = value.split('>');
    
    ordervalue = splitvalue[1];
    alert("ordervalue" +ordervalue);
   //var orderId = ordervalue.substr(0, 2);
      //alert("orderId" +orderId);
      var orderId= ordervalue.substr(0, ordervalue.indexOf('<'));
      alert("orderId" +orderId);
    
   alert("yess");
  
    

   
  localStorage.setItem("radiologyorderId", orderId);
    
    
    alert("YYEYYEYYEYEE");
    
 
    
jq('#dicomtable').empty();
jq('#dicomtable').append('<table></table>');
jq('#dicomtable table').attr('id','dicomtablelistid');
jq("#dicomtable table").addClass("studyclass");
var dicomtablelist = jq('#dicomtable').children();

  
  dicomtablelist.append( '<thead><tr><th> Dicom Files</th></tr></thead><tbody>' );
  <% apo.each { apoo -> %>

  dicomtablelist.append( '<tr>  <td>${ apoo }</td></tr>' );
  

   <% } %>
 dicomtablelist.append( '<tr>  <td> <a href="javascript: void(0)" id="linkActButton" onclick="submitObs(); return false;">Send</a></td></tr>' );
     dicomtablelist.append("</tbody>");


    });
    
    
    
    
    
  
    
    
     
    
 


jq("#test").click(function() {
alert("dsdads");
jq("#somediv").load('/openmrs/radiology/radiologistActiveOrders.page').dialog({modal:true}); 
    });  
    
    
    });

    
  
    function submitObs() {

    alert("YESS");
   var radiologyorderId = localStorage.getItem("radiologyorderId");
   
   alert("radiologyorderId " + radiologyorderId);
   
   jq.ajax({
    type: "POST",
    url: "${ ui.actionLink('updateActiveOrders') }",
    data : { 'radiologyorderId': radiologyorderId},
    cache: false,
    success: function(data){
    location.reload();
alert("COOL");
    }
    });
   
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
        
        Active Radiology Orders
         
    </li>
    <li id="orderdetails">  
       
         
    </li>
   
</ul>
</div>
    
 


    <div id="performedStatusInProgressOrder">
  
        <h1>ACTIVE RADIOLOGY ORDERS</h1>
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
        <td><p style="display:none;">${ anOrder.orderId }</p>
            ${anOrder.study.studyname}</td>
        <td>${ anOrder.dateCreated } </td>
        <td>${ anOrder.urgency }</td>

    </tr>
    <% } %>  
</tbody>
</table>
</div>


<div id = "dicomtable">
    

  


</div>





















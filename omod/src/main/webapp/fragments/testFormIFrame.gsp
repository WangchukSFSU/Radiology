<% ui.includeCss("radiology", "modalitylist.css") %>

 <%
    // config supports style (css style on div around form)
    // config supports cssClass (css class on div around form)

    // assumes jquery and jquery-ui from emr module
    ui.includeJavascript("uicommons", "handlebars/handlebars.min.js", Integer.MAX_VALUE - 1);
    ui.includeJavascript("htmlformentryui", "dwr-util.js")
    ui.includeJavascript("htmlformentryui", "htmlForm.js")
    ui.includeJavascript("uicommons", "emr.js")
    ui.includeJavascript("uicommons", "moment.js")
    // TODO setup "confirm before navigating" functionality
%>

<script type="text/javascript" src="/${ contextPath }/moduleResources/htmlformentry/htmlFormEntry.js"></script>
<script type="text/javascript" src="/${ contextPath }/moduleResources/htmlformentry/htmlForm.js"></script>
<link href="/${ contextPath }/moduleResources/htmlformentry/htmlFormEntry.css" type="text/css" rel="stylesheet" />

<script type="text/javascript">

    // for now we just expose these in the global scope for compatibility with htmlFormEntry.js and legacy forms
    function submitHtmlForm() {
    alert("0000000");
        htmlForm.submitHtmlForm();
        return false;
    }

    
    
    
    
    function showDiv(id) {
        htmlForm.showDiv(id);
    }

    function hideDiv(id) {
        htmlForm.hideDiv(id);
    }

    function getValueIfLegal(idAndProperty) {
        htmlForm.getValueIfLegal(idAndProperty);
    }

    function loginThenSubmitHtmlForm() {
        htmlForm.loginThenSubmitHtmlForm();
    }

    var beforeSubmit = htmlForm.getBeforeSubmit();
    var beforeValidation = htmlForm.getBeforeValidation();
    var propertyAccessorInfo = htmlForm.getPropertyAccessorInfo();

  
        htmlForm.setReturnUrl('${ returnUrl }');
 

  

	jq(document).ready(function() {
		jQuery.each(jq("htmlform").find('input'), function(){
		    jq(this).bind('keypress', function(e){
		       if (e.keyCode == 13) {
		       		if (!jq(this).hasClass("submitButton")) {
		       			e.preventDefault(); 
		       		}
		       }
		    });
		});
    });
    
</script>

<script>
     jq = jQuery;
       jq(document).ready(function() {
       
       jq("#dialog-message").dialog({
       autoOpen: false,
    modal: true,
    draggable: true,
    resizable: true,
    position: ['center', 'top'],
    show: 'blind',
    hide: 'blind',
    width: 900,
    dialogClass: 'ui-dialog-osx',
    buttons: {
        "I've read and understand this": function() {
            jq(this).dialog("close");
        }
    }
});

  jq("#studyConceptDictionary").click(function() {
  alert("jiiji");
  radiologyorderId = 130;
    jq.getJSON('${ ui.actionLink("getForm") }',
    { 'radiologyorderId': radiologyorderId
    })
    .error(function(xhr, status, err) {
    alert('AJAX error ' + err);
    })
    .success(function(ret) {
    alert("succsss");
    for (var i = 0; i < ret.length; i++) {

    var formNameHtmlToDisplay = ret[i].HtmlToDisplay;
    var patientId = ret[i].Patient.PatientId;
    var HtmlFormId = ret[i].HtmlFormId;
    var FormModifiedTimestamp = ret[i].FormModifiedTimestamp;
    var ReturnUrl = ret[i].ReturnUrl;
    
     localStorage.setItem("patientId", patientId);
     localStorage.setItem("HtmlFormId", HtmlFormId);
      localStorage.setItem("FormModifiedTimestamp", FormModifiedTimestamp);
     localStorage.setItem("formNameHtmlToDisplay", formNameHtmlToDisplay);
     
     jq('#fff').append("<div class='nnn'  id= 'viewstudyid'><a id = 'tiger' class='tiger' onclick='loadImages(); return false;'>ViewStudy</a> </div>");

     
 
    }
    
    
 
    
    
    })
  
    
    });

       
       });
       
       
       function loadImages() {
       alert("loadImages");
       
       
       
       
  var patientId = localStorage.getItem("patientId");
 var returnUrl = localStorage.getItem("returnUrl");
  var HtmlFormId = localStorage.getItem("HtmlFormId");
   var formModifiedTimestamp = localStorage.getItem("formModifiedTimestamp");
  var formNameHtmlToDisplay = localStorage.getItem("formNameHtmlToDisplay");
  
  jq( "#dialog-message" ).dialog( "open" );
      jq('#personId').val(patientId);
       jq('#htmlFormId').val(HtmlFormId);
       jq('#returnUrl').val(returnUrl);
       
      
  jq('input#closeAfterSubmission').after(formNameHtmlToDisplay);
       }
    </script>


     
    

<div id="dialog-message" title="Important information">

        <span class="error" style="display: none" id="general-form-error"></span>
       <form id="htmlform" method="post" action="${ ui.actionLink("submit") }" onSubmit="submitHtmlForm(); return false;">
        <input type="hidden" id = "personId" name="personId" value=""/>
        <input type="hidden" id = "htmlFormId" name="htmlFormId" value=""/>
        <input type="hidden" id = "createVisit" name="createVisit" value=""/>
        <input type="hidden" id = "formModifiedTimestamp" name="formModifiedTimestamp" value=""/>
        <input type="hidden" id = "encounterModifiedTimestamp" name="encounterModifiedTimestamp" value=""/>
       
        <input type="hidden" id = "encounterId" name="encounterId" value=""/>
     
      
        <input type="hidden" id = "visitId" name="visitId" value=""/>
      
     
        <input type="hidden" id = "returnUrl" name="returnUrl" value=""/>
       
        <input type="hidden" id = "closeAfterSubmission" name="closeAfterSubmission" value=""/>

       

        <div id="passwordPopup" style="position: absolute; z-axis: 1; bottom: 25px; background-color: #ffff00; border: 2px black solid; display: none; padding: 10px">
            <center>
                <table>
                    <tr>
                        <td colspan="2"><b>${ ui.message("htmlformentry.loginAgainMessage") }</b></td>
                    </tr>
                    <tr>
                        <td align="right"><b>${ ui.message("coreapps.user.username") }:</b></td>
                        <td><input type="text" id="passwordPopupUsername"/></td>
                    </tr>
                    <tr>
                        <td align="right"><b>${ ui.message("coreapps.user.password") }:</b></td>
                        <td><input type="password" id="passwordPopupPassword"/></td>
                    </tr>
                    <tr>
                        <td colspan="2" align="center"><input type="button" value="Submit" onClick="loginThenSubmitHtmlForm()"/></td>
                    </tr>
                </table>
            </center>
        </div>
    </form>
</div>


    
<div id="fff" > </div>

<input type="button" id="studyConceptDictionary" class="studyConceptDictionary" value = "?" >





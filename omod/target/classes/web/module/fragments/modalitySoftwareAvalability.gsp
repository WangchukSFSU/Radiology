
<% ui.includeCss("radiology", "modalitySoftware.css") %>


<script>
    jq = jQuery;
    jq(document).ready(function() {

    //modality Available DialogBox
    jq( "#modalityAvailableDialogBox" ).dialog({
    autoOpen: false, 
    buttons: {
    OK: function() {jq(this).dialog("close");}
    },
    title: "Software Modality Availability",
    position: {
    my: "left center",
    at: "left center"
    }
    });

    //open Dialogbox
    jq( "#modalityAvailableInstruction" ).click(function() {
    jq( "#modalityAvailableDialogBox" ).dialog( "open" );
    });


    jq( "input" ).click(function() {
    //get the selected radio message
    var inputvalue = jq(this).val();
    if(inputvalue == "Modality Software Available" || inputvalue == "Modality Software Not Available") {
    jq.ajax({
    type: "POST",
    url: "${ ui.actionLink('contactRadiologist') }",
    data : { 'message': inputvalue},
    cache: false,
    success: function(data){

    }

    })


    }


    });


    });
</script>

<!-- Modality header -->
<div class="modality-header" >    
    <label id=modality-label for modality-software> <h2>Modality Software Availability :</h2> </label>
    <input type="radio" name="modality-sofware" id="modality" value="Modality Software Available">  
    <label id=modality-label for modality-software-available> Yes </label>
    <input type="radio" name="modality-sofware" id="modality" value="Modality Software Not Available">
    <label id=modality-label for modality-software-unavailable> No </label>
    <input type="button" id="modalityAvailableInstruction" class="modalityAvailableInstruction" value = "?" >
</div>

<br>
<!-- Modality dialogbox message -->
<div id="modalityAvailableDialogBox" title="Software Modality Availability">If the software connecting the modality to the PACS system is available then selects “Yes”. <br> If the software connecting the modality to the PACS system is not available then selects “No”. </div>

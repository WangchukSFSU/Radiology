<%
ui.decorateWith("appui", "standardEmrPage")

ui.includeJavascript("uicommons", "datatables/jquery.dataTables.min.js")
ui.includeCss("uicommons", "datatables/dataTables_jui.css")
%>




 <div id="radiologistInProgressOrder">
        ${ ui.includeFragment("radiology", "test") }

    </div>






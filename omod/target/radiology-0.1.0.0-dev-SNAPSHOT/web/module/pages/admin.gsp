<!-- Standard EMR header Page -->
<%
ui.decorateWith("appui", "standardEmrPage")
ui.includeJavascript("uicommons", "datatables/jquery.dataTables.min.js")
ui.includeCss("uicommons", "datatables/dataTables_jui.css")
%>

<!-- Include adminManageRadiologyModule fragment -->
${ ui.includeFragment("radiology", "adminManageRadiologyModule") }







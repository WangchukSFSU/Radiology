<%
ui.decorateWith("appui", "standardEmrPage")

ui.includeJavascript("uicommons", "datatables/jquery.dataTables.min.js")
ui.includeCss("uicommons", "datatables/dataTables_jui.css")
%>

${ ui.includeFragment("radiology", "modalitySoftware") }


<script type="text/javascript">
    var breadcrumbs = [
    { icon: "icon-home", link: '/' + OPENMRS_CONTEXT_PATH + '/index.htm' },
    { label: "Admin Initialization"}
    ];
</script>

${ ui.includeFragment("radiology", "modalitylist") }






<%
ui.decorateWith("appui", "standardEmrPage")

ui.includeJavascript("uicommons", "datatables/jquery.dataTables.min.js")
ui.includeCss("uicommons", "datatables/dataTables_jui.css")
%>




<script type="text/javascript">
    var breadcrumbs = [
    { icon: "icon-home", link: '/' + OPENMRS_CONTEXT_PATH + '/index.htm' },
    { label: "Active Orders"}
    ];
</script>





 <div id="radiologistInProgressOrder">
        ${ ui.includeFragment("radiology", "radiologistInProgressOrder",[ returnUrl: '${returnUrl}',
        patient: '${patient}'
        ]) }

    </div>






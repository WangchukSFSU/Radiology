<%
ui.decorateWith("appui", "standardEmrPage")
ui.includeJavascript("uicommons", "datatables/jquery.dataTables.min.js")
ui.includeCss("uicommons", "datatables/dataTables_jui.css")
%>

<!-- include createViewRadiologyOrder fragment, patient, diagnosis and study class -->
${ ui.includeFragment("radiology", "createViewRadiologyOrder",[ returnUrl: '${returnUrl}',
        patient: '${patient}', requireDiagnosisClass: 'Diagnosis', requireStudyClass: 'Radiology/Imaging Procedure'
        ]) }
    
    
    








  


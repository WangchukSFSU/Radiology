


<!-- include createViewRadiologyOrder fragment, patient, diagnosis and study class -->
${ ui.includeFragment("radiology", "createViewRadiologyOrder",[ returnUrl: '${returnUrl}',
        patient: '${patient}', requireDiagnosisClass: 'Diagnosis', requireStudyClass: 'Radiology Imaging/Procedure'
        ]) }
    
    
    








  


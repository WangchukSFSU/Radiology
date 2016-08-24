<%
ui.decorateWith("appui", "standardEmrPage")

ui.includeJavascript("uicommons", "datatables/jquery.dataTables.min.js")
ui.includeCss("uicommons", "datatables/dataTables_jui.css")
%>


    
    <ul id="breadcrumbs">
    <li>
        
        
        <a href="/openmrs/index.htm">
        
        
        <i class="icon-home small"></i>
        
        
        
        </a>
        
    </li>

    <li>
        
        <i class="icon-chevron-right link"></i>
        
        
        <a href="/openmrs/coreapps/systemadministration/systemAdministration.page">
        
        
        
        System Administration
        
        
        </a>
        
    </li>

    <li>
        
        <i class="icon-chevron-right link"></i>
        
        
        
        
        Manage Radiology Module
        
        
    </li>
</ul>





${ ui.includeFragment("radiology", "modalitylist") }






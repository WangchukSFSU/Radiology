  <h1>RADIOLOGY ORDER REPORT</h1>
<table id="table">
    
    <% getObs.each { observation -> %>
    <tr>
        <td>${observation.concept.getFullySpecifiedName(Locale.ENGLISH)}</td>
  <td>${observation.valueText}</td>
          
      

    </tr>
    <% } %>  

</table>

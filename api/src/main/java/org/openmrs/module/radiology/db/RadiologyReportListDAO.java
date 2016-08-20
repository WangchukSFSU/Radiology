/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package org.openmrs.module.radiology.db;

import java.util.List;
import org.openmrs.module.radiology.RadiologyModalityList;
import org.openmrs.module.radiology.RadiologyReportList;

/**
 * @author youdon
 */
public interface RadiologyReportListDAO {
	
	List<RadiologyReportList> getAllReport();
	
	RadiologyReportList getReport(Integer id);
	
	RadiologyReportList getReportUUID(String reportuuid);
	
	public RadiologyReportList saveReportList(RadiologyReportList report);
}

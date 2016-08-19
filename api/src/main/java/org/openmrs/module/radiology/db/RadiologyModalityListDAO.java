/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package org.openmrs.module.radiology.db;

import java.util.List;
import org.openmrs.module.radiology.RadiologyModalityList;

/**
 * @author youdon
 */
public interface RadiologyModalityListDAO {
	
	List<RadiologyModalityList> getAllModality();
	
	RadiologyModalityList getModality(Integer id);
	
	RadiologyModalityList getModalityName(String modalityname);
	
	public RadiologyModalityList saveModalityList(RadiologyModalityList modality);
}

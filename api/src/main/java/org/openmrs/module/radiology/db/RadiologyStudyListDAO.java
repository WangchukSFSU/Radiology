/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package org.openmrs.module.radiology.db;

import java.util.List;
import org.openmrs.module.radiology.RadiologyStudyList;

/**
 * @author youdon
 */
public interface RadiologyStudyListDAO {
	
	RadiologyStudyList getStudy(Integer id);
	
	List<RadiologyStudyList> getAllStudy();
	
	public RadiologyStudyList saveStudyList(RadiologyStudyList studylist);
}

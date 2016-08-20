/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package org.openmrs.module.radiology;

import java.io.Serializable;
import org.openmrs.BaseOpenmrsObject;

/**
 * @author youdon
 */
public class RadiologyReportList extends BaseOpenmrsObject implements Serializable {
	
	private Integer id;
	
	private String studyConceptName;
	
	private String htmlformuuid;
	
	public Integer getId() {
		return id;
	}
	
	public void setId(Integer id) {
		this.id = id;
	}
	
	public String getStudyConceptName() {
		return studyConceptName;
	}
	
	public void setStudyConceptName(String studyConceptName) {
		this.studyConceptName = studyConceptName;
	}
	
	public String getHtmlformuuid() {
		return htmlformuuid;
	}
	
	public void setHtmlformuuid(String htmlformuuid) {
		this.htmlformuuid = htmlformuuid;
	}
	
}

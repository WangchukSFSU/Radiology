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

public class RadiologyStudyList extends BaseOpenmrsObject implements Serializable {
	
	private Integer id;
	
	private String studyReporturl;
	
	private String studyName;
	
	public String getStudyName() {
		return studyName;
	}
	
	public void setStudyName(String studyName) {
		this.studyName = studyName;
	}
	
	public String getFormreportuuid() {
		return formreportuuid;
	}
	
	public void setFormreportuuid(String formreportuuid) {
		this.formreportuuid = formreportuuid;
	}
	
	private String formreportuuid;
	
	public String getStudyReporturl() {
		return studyReporturl;
	}
	
	public void setStudyReporturl(String studyReporturl) {
		this.studyReporturl = studyReporturl;
	}
	
	public void setId(Integer id) {
		this.id = id;
	}
	
	public Integer getId() {
		return id;
	}
	
	private Integer studyConceptId;
	
	public void setStudyConceptId(Integer studyConceptId) {
		this.studyConceptId = studyConceptId;
	}
	
	public Integer getStudyConceptId() {
		return studyConceptId;
	}
	
}

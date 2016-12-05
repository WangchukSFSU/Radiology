/**
 * This Source Code Form is subject to the terms of the Mozilla Public License,
 * v. 2.0. If a copy of the MPL was not distributed with this file, You can
 * obtain one at http://mozilla.org/MPL/2.0/. OpenMRS is also distributed under
 * the terms of the Healthcare Disclaimer located at http://openmrs.org/license.
 *
 * Copyright (C) OpenMRS Inc. OpenMRS is a registered trademark and the OpenMRS
 * graphic logo is a trademark of OpenMRS Inc.
 */
package org.openmrs.module.radiology;

import java.lang.reflect.Field;

/**
 * A class that supports on openmrs's orders to make the module DICOM compatible, corresponds to the
 * table order_dicom_complment
 */
public class Study {
	
	private Integer studyId;
	
	private String studyInstanceUid;
	
	private Integer studyReportSavedEncounterId;
	
	public Integer getStudyReportSavedEncounterId() {
		return studyReportSavedEncounterId;
	}
	
	public void setStudyReportSavedEncounterId(Integer studyReportSavedEncounterId) {
		this.studyReportSavedEncounterId = studyReportSavedEncounterId;
	}
	
	private String studyReportRadiologist;
	
	public String getStudyReportRadiologist() {
		return studyReportRadiologist;
	}
	
	public void setStudyReportRadiologist(String studyReportRadiologist) {
		this.studyReportRadiologist = studyReportRadiologist;
	}
	
	public String getObsCompletedDate() {
		return obsCompletedDate;
	}
	
	public void setObsCompletedDate(String obsCompletedDate) {
		this.obsCompletedDate = obsCompletedDate;
	}
	
	private String obsCompletedDate;
	
	private RadiologyOrder radiologyOrder;
	
	private ScheduledProcedureStepStatus scheduledStatus;
	
	private PerformedProcedureStepStatus performedStatus;
	
	private String modality;
	
	private String genericHtmlFormUid;
	
	public String getGenericHtmlFormUid() {
		return genericHtmlFormUid;
	}
	
	public void setGenericHtmlFormUid(String genericHtmlFormUid) {
		this.genericHtmlFormUid = genericHtmlFormUid;
	}
	
	private String nonGenericHtmlFormUid;
	
	public String getNonGenericHtmlFormUid() {
		return nonGenericHtmlFormUid;
	}
	
	public void setNonGenericHtmlFormUid(String nonGenericHtmlFormUid) {
		this.nonGenericHtmlFormUid = nonGenericHtmlFormUid;
	}
	
	public void setModality(String modality) {
		this.modality = modality;
	}
	
	public String getModality() {
		return modality;
	}
	
	private String studyname;
	
	public void setStudyname(String studyname) {
		this.studyname = studyname;
	}
	
	public String getStudyname() {
		return studyname;
	}
	
	private MwlStatus mwlStatus;
	
	public Integer getStudyId() {
		return studyId;
	}
	
	public RadiologyOrder getRadiologyOrder() {
		return radiologyOrder;
	}
	
	public PerformedProcedureStepStatus getPerformedStatus() {
		return performedStatus;
	}
	
	public ScheduledProcedureStepStatus getScheduledStatus() {
		return scheduledStatus;
	}
	
	public String getStudyInstanceUid() {
		return studyInstanceUid;
	}
	
	public MwlStatus getMwlStatus() {
		return mwlStatus;
	}
	
	/**
	 * Returns true when this Study's performedStatus is in progress and false otherwise.
	 * 
	 * @return true on performedStatus in progress and false otherwise
	 * @should return false if performed status is null
	 * @should return false if performed status is not in progress
	 * @should return true if performed status is in progress
	 */
	public boolean isInProgress() {
		return performedStatus == PerformedProcedureStepStatus.IN_PROGRESS;
	}
	
	/**
	 * Returns true when this Study's performedStatus is completed and false otherwise.
	 * 
	 * @return true on performedStatus completed and false otherwise
	 * @should return false if performedStatus is null
	 * @should return false if performedStatus is not completed
	 * @should return true if performedStatus is completed
	 */
	public boolean isCompleted() {
		return performedStatus == PerformedProcedureStepStatus.COMPLETED;
	}
	
	public boolean isReportReady() {
		return performedStatus == PerformedProcedureStepStatus.REPORT_READY;
	}
	
	public boolean isScheduleable() {
		return performedStatus == null;
	}
	
	public void setMwlStatus(MwlStatus mwlStatus) {
		this.mwlStatus = mwlStatus;
	}
	
	public void setStudyId(Integer studyId) {
		this.studyId = studyId;
	}
	
	void setRadiologyOrder(RadiologyOrder radiologyOrder) {
		this.radiologyOrder = radiologyOrder;
	}
	
	public void setPerformedStatus(PerformedProcedureStepStatus performedStatus) {
		this.performedStatus = performedStatus;
	}
	
	public void setScheduledStatus(ScheduledProcedureStepStatus scheduledStatus) {
		this.scheduledStatus = scheduledStatus;
	}
	
	public void setStudyInstanceUid(String studyInstanceUid) {
		this.studyInstanceUid = studyInstanceUid;
	}
	
	@Override
	public String toString() {
		final StringBuilder buff = new StringBuilder();
		
		final Field[] fields = this.getClass()
				.getDeclaredFields();
		for (Field field : fields) {
			try {
				buff.append(field.getName())
						.append(": ")
						.append(field.get(this))
						.append(" ");
			}
			catch (IllegalAccessException ex) {}
			catch (IllegalArgumentException ex) {}
		}
		return buff.toString();
	}
}

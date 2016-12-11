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
	
	private String obsCompletedDate;
	
	private RadiologyOrder radiologyOrder;
	
	private ScheduledProcedureStepStatus scheduledStatus;
	
	private PerformedProcedureStepStatus performedStatus;
	
	private String modality;
	
	/**
	 * @return studyReportSavedEncounterId
	 */
	public Integer getStudyReportSavedEncounterId() {
		return studyReportSavedEncounterId;
	}
	
	/**
	 * @param studyReportSavedEncounterId
	 */
	public void setStudyReportSavedEncounterId(Integer studyReportSavedEncounterId) {
		this.studyReportSavedEncounterId = studyReportSavedEncounterId;
	}
	
	private String studyReportRadiologist;
	
	/**
	 * @return studyReportRadiologist
	 */
	public String getStudyReportRadiologist() {
		return studyReportRadiologist;
	}
	
	/**
	 * @param studyReportRadiologist
	 */
	public void setStudyReportRadiologist(String studyReportRadiologist) {
		this.studyReportRadiologist = studyReportRadiologist;
	}
	
	/**
	 * @return obsCompletedDate
	 */
	public String getObsCompletedDate() {
		return obsCompletedDate;
	}
	
	/**
	 * @param obsCompletedDate
	 */
	public void setObsCompletedDate(String obsCompletedDate) {
		this.obsCompletedDate = obsCompletedDate;
	}
	
	/**
	 * @param modality
	 */
	public void setModality(String modality) {
		this.modality = modality;
	}
	
	/**
	 * @return modality
	 */
	public String getModality() {
		return modality;
	}
	
	private String studyname;
	
	/**
	 * @param studyname
	 */
	public void setStudyname(String studyname) {
		this.studyname = studyname;
	}
	
	/**
	 * @return studyname
	 */
	public String getStudyname() {
		return studyname;
	}
	
	private MwlStatus mwlStatus;
	
	/**
	 * @return studyId
	 */
	public Integer getStudyId() {
		return studyId;
	}
	
	/**
	 * @return radiologyOrder
	 */
	public RadiologyOrder getRadiologyOrder() {
		return radiologyOrder;
	}
	
	/**
	 * @return performedStatus
	 */
	public PerformedProcedureStepStatus getPerformedStatus() {
		return performedStatus;
	}
	
	/**
	 * @return scheduledStatus
	 */
	public ScheduledProcedureStepStatus getScheduledStatus() {
		return scheduledStatus;
	}
	
	/**
	 * @return studyInstanceUid
	 */
	public String getStudyInstanceUid() {
		return studyInstanceUid;
	}
	
	/**
	 * @return mwlStatus
	 */
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
	
	/**
	 * @return true if performedStatus is REPORT_READY
	 */
	public boolean isReportReady() {
		return performedStatus == PerformedProcedureStepStatus.REPORT_READY;
	}
	
	/**
	 * @return true if performedStatus is null
	 */
	public boolean isScheduleable() {
		return performedStatus == null;
	}
	
	/**
	 * @param mwlStatus
	 */
	public void setMwlStatus(MwlStatus mwlStatus) {
		this.mwlStatus = mwlStatus;
	}
	
	/**
	 * @param studyId
	 */
	public void setStudyId(Integer studyId) {
		this.studyId = studyId;
	}
	
	void setRadiologyOrder(RadiologyOrder radiologyOrder) {
		this.radiologyOrder = radiologyOrder;
	}
	
	/**
	 * @param performedStatus
	 */
	public void setPerformedStatus(PerformedProcedureStepStatus performedStatus) {
		this.performedStatus = performedStatus;
	}
	
	/**
	 * @param scheduledStatus
	 */
	public void setScheduledStatus(ScheduledProcedureStepStatus scheduledStatus) {
		this.scheduledStatus = scheduledStatus;
	}
	
	/**
	 * @param studyInstanceUid
	 */
	public void setStudyInstanceUid(String studyInstanceUid) {
		this.studyInstanceUid = studyInstanceUid;
	}
	
	/**
	 * @return
	 */
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

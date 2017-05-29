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
public class ModalityInit extends BaseOpenmrsObject implements Serializable {
	
	private static final long serialVersionUID = 1L;
	
	private Integer modalityId;
	
	public Integer getModalityId() {
		return modalityId;
	}
	
	public void setModalityId(Integer modalityId) {
		this.modalityId = modalityId;
	}
	
	public String getModalityName() {
		return modalityName;
	}
	
	public void setModalityName(String modalityName) {
		this.modalityName = modalityName;
	}
	
	public String getModalityIP() {
		return modalityIP;
	}
	
	public void setModalityIP(String modalityIP) {
		this.modalityIP = modalityIP;
	}
	
	public String getModalityPath() {
		return modalityPath;
	}
	
	public void setModalityPath(String modalityPath) {
		this.modalityPath = modalityPath;
	}
	
	private String modalityName;
	
	private String modalityIP;
	
	private String modalityPath;
	
	@Override
	public Integer getId() {
		return modalityId;
	}
	
	@Override
	public void setId(Integer intgr) {
		this.modalityId = intgr;
	}
	
}

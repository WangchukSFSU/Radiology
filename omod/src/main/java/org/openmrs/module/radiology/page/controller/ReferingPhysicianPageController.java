package org.openmrs.module.radiology.page.controller;

import org.openmrs.Patient;
import org.openmrs.ui.framework.page.PageModel;
import org.springframework.web.bind.annotation.RequestParam;

/**
 * Referring Physician to create radiology order, view observation
 * 
 * @author tenzin
 */
public class ReferingPhysicianPageController {
	
	/**
	 * @param model PageModel
	 * @param returnUrl
	 * @param patient
	 */
	public void controller(PageModel model, @RequestParam(value = "returnUrl", required = false) String returnUrl,
			@RequestParam(value = "patientId", required = false) Patient patient) {
		
	}
	
}

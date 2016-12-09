package org.openmrs.module.radiology.page.controller;

import java.text.ParseException;
import org.openmrs.Patient;
import org.openmrs.ui.framework.page.PageModel;
import org.springframework.web.bind.annotation.RequestParam;

/**
 * @author tenzin
 */
public class ReferingPhysicianPageController {
	
	/**
	 * @param model
	 * @param returnUrl
	 * @param patient
	 */
	public void controller(PageModel model, @RequestParam(value = "returnUrl", required = false) String returnUrl,
			@RequestParam(value = "patientId", required = false) Patient patient) {
		
	}
	
}

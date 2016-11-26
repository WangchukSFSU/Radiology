/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package org.openmrs.module.radiology.fragment.controller;

import org.openmrs.module.radiology.page.controller.*;
import java.text.ParseException;
import org.openmrs.Patient;
import org.openmrs.module.htmlformentryui.page.controller.htmlform.BaseEnterHtmlFormPageController;
import org.openmrs.ui.framework.page.PageModel;
import org.springframework.web.bind.annotation.RequestParam;

public class SendFormMessageExtFragmentPageController {
	
	public void controller(PageModel model, @RequestParam(value = "returnUrl", required = false) String returnUrl,
			@RequestParam(value = "patientId", required = false) Patient patient) throws ParseException {
		
	}
	
}

/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package org.openmrs.module.radiology.fragment.controller;

import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.Vector;
import org.openmrs.Concept;
import org.openmrs.ConceptName;
import org.openmrs.Order;
import org.openmrs.Patient;
import org.openmrs.api.context.Context;
import org.openmrs.module.radiology.RadiologyOrder;
import org.openmrs.module.radiology.RadiologyService;
import org.openmrs.module.radiology.Study;
import org.openmrs.ui.framework.fragment.FragmentModel;
import org.springframework.web.bind.annotation.RequestParam;

/**
 * @author youdon
 */
public class PerformedStatusCompletedOrderFragmentController {
	
	public void controller(@RequestParam("patientId") Patient patient, FragmentModel model,
			@RequestParam(value = "returnUrl", required = false) String returnUrl) {
		
		System.out.println("PPPPPPP " + patient);
		
	}
	
}

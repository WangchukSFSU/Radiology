/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package org.openmrs.module.radiology.fragment.controller;

import java.util.ArrayList;
import java.util.List;
import java.util.Locale;
import org.openmrs.ConceptName;
import org.openmrs.Encounter;
import org.openmrs.Obs;
import org.openmrs.Patient;
import org.openmrs.api.ObsService;
import org.openmrs.api.context.Context;
import org.openmrs.module.radiology.RadiologyService;
import org.openmrs.ui.framework.fragment.FragmentModel;
import org.openmrs.ui.framework.page.PageModel;
import org.springframework.web.bind.annotation.RequestParam;

/**
 * @author youdon
 */
public class ReportObsFragmentController {
	
	public void controller(FragmentModel model, @RequestParam(value = "returnUrl", required = false) String returnUrl,
			@RequestParam(value = "patientId", required = false) Patient patient) {
		
		// System.out.println("encounter_id encounter_id " + encounter_id);
		
		List<Obs> getObs = Context.getObsService()
				.getObservations("39");
		
		for (Obs printobservation : getObs) {
			// System.out.println("MKMKMKMKMK " + printobservation.getConcept());
			// System.out.println("MKMKMKMKMK LLLLLLL " + printobservation.getValueText());
			ConceptName diagnosisConceptName = Context.getConceptService()
					.getConcept(162836)
					.getName();
			// System.out.println("MKMKMKMKMK PPPPP " + Context.getConceptService()
			// .getConcept(162836)
			// .getName());
			// System.out.println("MKMKMKMKMK MMMMMMM " + diagnosisConceptName);
			// System.out.println("MKMKMKMKMK NNNNNNN " + printobservation.getConcept()
			// .getFullySpecifiedName(Locale.ENGLISH));
			// getObs.add(printobservation);
		}
		
		model.addAttribute("getObs", getObs);
	}
	
}

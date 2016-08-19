/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package org.openmrs.module.radiology.fragment.controller;

import java.util.Date;
import org.openmrs.Order;
import org.openmrs.Patient;
import org.openmrs.Provider;
import org.openmrs.User;
import org.openmrs.api.context.Context;

import org.openmrs.module.radiology.PerformedProcedureStepStatus;

import org.openmrs.module.radiology.RadiologyOrder;
import org.openmrs.module.radiology.RadiologyService;

import org.openmrs.module.radiology.Study;
import org.openmrs.notification.MessageException;

import org.openmrs.ui.framework.fragment.FragmentModel;

import org.springframework.web.bind.annotation.RequestParam;

/**
 * @author youdon
 */
public class AddRadiologyOrderFormFragmentController {
	
	// static final String RADIOLOGY_ORDER_FORM_VIEW = "/module/radiology/addRadiologyOrderForm";
	
	public void controller(FragmentModel model) throws MessageException {
		
		System.out.println("AddRadiologyOrderFormFragmentController");
		// ModelAndView modelAndView = new ModelAndView(RADIOLOGY_ORDER_FORM_VIEW);
		
		if (Context.isAuthenticated()) {
			model.addAttribute("order", new Order());
			final RadiologyOrder radiologyOrder = new RadiologyOrder();
			radiologyOrder.setStudy(new Study());
			model.addAttribute("radiologyOrder", radiologyOrder);
		}
		
		// return modelAndView;
	}
	
	public void placeRadiologyOrder(FragmentModel model, @RequestParam("patient") Patient patient,
			@RequestParam(value = "returnUrl", required = false) String returnUrl,
			@RequestParam(value = "modalityname") String modalityname, @RequestParam(value = "studyname") String studyname,
			@RequestParam(value = "diagnosisname") String diagnosisname,
			@RequestParam(value = "instructionname") String instructionname,
			@RequestParam(value = "priorityname") String priorityname) {
		
		RadiologyOrder radiologyOrder = new RadiologyOrder();
		
		User authenticatedUser = Context.getAuthenticatedUser();
		
		System.out.println("SSSSS TTTTT UUUUU DDDDD YYYYYYY " + studyname);
		System.out.println("USer  PPPPPPPPP " + authenticatedUser.getUsername());
		
		// Provider provider = new Provider();
		// provider.setProviderId(11);
		// provider.setName("moon");
		Provider provider = Context.getProviderService()
				.getProvider(3);
		
		radiologyOrder.setOrderer(provider);
		
		// Provider provider = Context.getProviderService()
		// .saveProvider(pp);
		// radiologyOrder.setOrderer(Context.getProviderService());
		
		radiologyOrder.setPatient(patient);
		radiologyOrder.setDateCreated(new Date());
		radiologyOrder.setInstructions(instructionname);
		radiologyOrder.setUrgency(Order.Urgency.valueOf(priorityname));
		radiologyOrder.setOrderdiagnosis(diagnosisname);
		
		Study study = new Study();
		
		RadiologyService radiologyservice = Context.getService(RadiologyService.class);
		study.setModality(modalityname);
		study.setStudyname(studyname);
		study.setPerformedStatus(PerformedProcedureStepStatus.COMPLETED);
		
		radiologyOrder.setStudy(study);
		
		radiologyOrder.setConcept(Context.getConceptService()
				.getConcept(Context.getConceptService()
						.getConcept(studyname)
						.getId()));
		
		System.out.println("ORder Concept " + Context.getConceptService()
				.getConcept(studyname)
				.getId());
		RadiologyOrder saveOrder = radiologyservice.placeRadiologyOrder(radiologyOrder);
		
		if (radiologyservice.placeRadiologyOrderInPacs(saveOrder)) {
			System.out.println("PACS PACS PACS PACS PACS");
		}
		
		System.out.println("JJJJJJJJJJJJJJJJJJJJ done");
		
	}
	
}

/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package org.openmrs.module.radiology.fragment.controller;

import java.text.DateFormat;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Collection;
import java.util.Date;
import java.util.HashMap;
import java.util.LinkedList;
import java.util.List;
import java.util.Map;
import org.openmrs.Concept;
import org.openmrs.ConceptAnswer;
import org.openmrs.ConceptClass;
import org.openmrs.ConceptName;
import org.openmrs.Order;
import org.openmrs.Patient;
import org.openmrs.Provider;
import org.openmrs.User;
import org.openmrs.api.ConceptService;
import org.openmrs.api.context.Context;

import org.openmrs.module.radiology.PerformedProcedureStepStatus;
import org.openmrs.module.radiology.RadiologyModalityList;

import org.openmrs.module.radiology.RadiologyOrder;
import org.openmrs.module.radiology.RadiologyReportList;
import org.openmrs.module.radiology.RadiologyService;
import org.openmrs.module.radiology.RadiologyStudyList;

import org.openmrs.module.radiology.Study;
import org.openmrs.notification.MessageException;
import org.openmrs.ui.framework.SimpleObject;
import org.openmrs.ui.framework.UiUtils;
import org.openmrs.ui.framework.annotation.SpringBean;

import org.openmrs.ui.framework.fragment.FragmentModel;

import org.springframework.web.bind.annotation.RequestParam;

/**
 * @author youdon
 */
public class AddRadiologyOrderFormFragmentController {
	
	// static final String RADIOLOGY_ORDER_FORM_VIEW = "/module/radiology/addRadiologyOrderForm";
	static SimpleDateFormat sdf = new SimpleDateFormat("dd-MM-yyyy");
	
	public void controller(FragmentModel model) throws MessageException {
		
		System.out.println("AddRadiologyOrderFormFragmentController");
		// ModelAndView modelAndView = new ModelAndView(RADIOLOGY_ORDER_FORM_VIEW);
		final List<String> urgencies = new LinkedList<String>();
		
		for (Order.Urgency urgency : Order.Urgency.values()) {
			System.out.println("EEEEEEEE" + urgency.name());
			urgencies.add(urgency.name());
		}
		
		Map<String, String> performedStatuses = new HashMap<String, String>();
		for (PerformedProcedureStepStatus performedStatus : PerformedProcedureStepStatus.values()) {
			performedStatuses.put(performedStatus.name(), performedStatus.name());
			System.out.println("list performned status " + performedStatus.name());
		}
		
		RadiologyService radiologyservice = Context.getService(RadiologyService.class);
		final List<RadiologyModalityList> modalityListFromDb = radiologyservice.getAllModality();
		ArrayList<ConceptName> modalityConceptNameList = new ArrayList();
		for (RadiologyModalityList modalityConceptId : modalityListFromDb) {
			int modalityConceptIdInteger = modalityConceptId.getModalityId();
			ConceptName modalityConceptName = Context.getConceptService()
					.getConcept(modalityConceptIdInteger)
					.getName();
			modalityConceptNameList.add(modalityConceptName);
			
		}
		
		final List<RadiologyStudyList> studyListFromDb = radiologyservice.getAllStudy();
		ArrayList<ConceptName> studyConceptNameList = new ArrayList();
		for (RadiologyStudyList studyConceptId : studyListFromDb) {
			int studyConceptIdInteger = studyConceptId.getStudyConceptId();
			ConceptName studyConceptName = Context.getConceptService()
					.getConcept(studyConceptIdInteger)
					.getName();
			String app = modalityConceptNameList.get(0)
					.toString();
			System.out.println("CN45454565665 " + modalityConceptNameList.get(0));
			System.out.println("CN45454565665 " + studyConceptId.getModalityNameSaved());
			if ((modalityConceptNameList.get(0).toString()).equals(studyConceptId.getModalityNameSaved())) {
				System.out.println("YDHDYDYDYDYDYDYDDY  ");
				studyConceptNameList.add(studyConceptName);
			}
			
			System.out.println("Study name " + studyConceptName);
			
		}
		
		ArrayList<ConceptName> diagnosisConceptNameList = new ArrayList();
		ConceptClass diagnosisConcept = Context.getConceptService()
				.getConceptClassByName("Diagnosis");
		String diagnosislist = Context.getConceptService()
				.getConceptsByClass(diagnosisConcept)
				.toString();
		String diagnosislisttrim = diagnosislist.substring(1, diagnosislist.length() - 1)
				.trim();
		List<String> diagnosisnewlist = new ArrayList<String>(Arrays.asList(diagnosislisttrim.split(",")));
		for (String diagnosisString : diagnosisnewlist) {
			int diagnosisToInt = Integer.parseInt(diagnosisString.trim());
			ConceptName diagnosisConceptName = Context.getConceptService()
					.getConcept(diagnosisToInt)
					.getName();
			diagnosisConceptNameList.add(diagnosisConceptName);
		}
		
		model.addAttribute("urgencies", urgencies);
		model.addAttribute("diagnosislist", diagnosisConceptNameList);
		model.addAttribute("studyConceptNameList", studyConceptNameList);
		model.addAttribute("modalityConceptNameList", modalityConceptNameList);
		model.addAttribute("performedStatuses", performedStatuses);
		
		if (Context.isAuthenticated()) {
			model.addAttribute("order", new Order());
			final RadiologyOrder radiologyOrder = new RadiologyOrder();
			radiologyOrder.setStudy(new Study());
			model.addAttribute("radiologyOrder", radiologyOrder);
		}
		
		// return modelAndView;
	}
	
	public List<SimpleObject> getStudyConceptsAnswerFromModality(FragmentModel model,
			@RequestParam(value = "modalityselected", required = false) String studyConceptone,
			@SpringBean("conceptService") ConceptService service, UiUtils ui) {
		
		System.out.println("0000000000000 PPPPPPPP " + studyConceptone);
		final List<RadiologyStudyList> studyListFromDb = Context.getService(RadiologyService.class)
				.getAllStudy();
		ArrayList<RadiologyStudyList> studyConceptNameList = new ArrayList();
		for (RadiologyStudyList studyConceptId : studyListFromDb) {
			int studyConceptIdInteger = studyConceptId.getStudyConceptId();
			ConceptName studyConceptName = Context.getConceptService()
					.getConcept(studyConceptIdInteger)
					.getName();
			System.out.println("3333333333333333333333  " + studyConceptName);
			String aop = studyConceptId.getModalityNameSaved();
			System.out.println("CN45454565665 PPPPPPPP " + studyConceptId.getModalityNameSaved());
			if ((studyConceptone).equals(studyConceptId.getModalityNameSaved())) {
				System.out.println("ZZZZZZZZZZZZZZZZZZZZZ MMMMMMM  ");
				studyConceptNameList.add(studyConceptId);
			}
			
			System.out.println("Study name LLLLLLLLL" + studyConceptName);
			
		}
		
		String[] properties = new String[3];
		properties[0] = "id";
		properties[1] = "studyName";
		properties[2] = "studyReporturl";
		return SimpleObject.fromCollection(studyConceptNameList, ui, properties);
	}
	
	public void placeRadiologyOrder(FragmentModel model, @RequestParam("patient") Patient patient,
			@RequestParam(value = "returnUrl", required = false) String returnUrl,
			@RequestParam(value = "modalityname") String modalityname, @RequestParam(value = "studyname") String studyname,
			@RequestParam(value = "diagnosisname") String diagnosisname,
			@RequestParam(value = "instructionname") String instructionname,
			@RequestParam(value = "priorityname") String priorityname) throws ParseException {
		
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
		
		List<RadiologyReportList> reportListFromDb = radiologyservice.getAllReport();
		for (RadiologyReportList rr : reportListFromDb) {
			
			if (studyname == rr.getStudyConceptName()) {
				study.setStudyHtmlFormUUID(rr.getHtmlformuuid());
			}
		}
		
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

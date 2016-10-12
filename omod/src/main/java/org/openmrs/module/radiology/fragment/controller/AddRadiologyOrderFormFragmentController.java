/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package org.openmrs.module.radiology.fragment.controller;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.LinkedList;
import java.util.List;
import java.util.Map;
import org.openmrs.Concept;
import org.openmrs.ConceptClass;
import org.openmrs.ConceptName;
import org.openmrs.ConceptSearchResult;
import org.openmrs.Form;
import org.openmrs.Order;
import org.openmrs.Patient;
import org.openmrs.Provider;
import org.openmrs.User;
import org.openmrs.api.ConceptService;
import org.openmrs.api.context.Context;

import org.openmrs.module.radiology.PerformedProcedureStepStatus;

import org.openmrs.module.radiology.RadiologyOrder;
import org.openmrs.module.radiology.RadiologyOrderStatus;
import org.openmrs.module.radiology.RadiologyReportList;
import org.openmrs.module.radiology.RadiologyService;
import org.openmrs.module.radiology.RadiologyStudyList;
import org.openmrs.module.radiology.ScheduledProcedureStepStatus;

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
	
	private static int count = 9;
	
	public void controller(FragmentModel model, @RequestParam(value = "returnUrl", required = false) String returnUrl,
			@RequestParam(value = "patientId", required = false) Patient patient) throws MessageException {
		
		System.out.println("AddRadiologyOrderFormFragmentController");
		
		final List<String> urgencies = new LinkedList<String>();
		
		for (Order.Urgency urgency : Order.Urgency.values()) {
			System.out.println("EEEEEEEE" + urgency.name());
			urgencies.add(urgency.name());
		}
		
		ArrayList<ConceptName> studyConceptNameList = new ArrayList();
		
		ConceptClass mot = Context.getConceptService()
				.getConceptClassByName("Radiology/Imaging Procedure");
		
		List<Concept> mot_list = Context.getConceptService()
				.getConceptsByClass(mot);
		
		for (Concept ccc : mot_list) {
			if (ccc.getDisplayString()
					.endsWith("modality")) {
				
			} else {
				ConceptName studyConceptName = ccc.getName();
				studyConceptNameList.add(studyConceptName);
			}
		}
		
		Map<String, String> performedStatuses = new HashMap<String, String>();
		for (PerformedProcedureStepStatus performedStatus : PerformedProcedureStepStatus.values()) {
			performedStatuses.put(performedStatus.name(), performedStatus.name());
			System.out.println("list performned status " + performedStatus.name());
		}
		
		// ArrayList<ConceptName> diagnosisConceptNameList = new ArrayList();
		// ConceptClass diagnosisConcept = Context.getConceptService()
		// .getConceptClassByName("Diagnosis");
		// System.out.println("KKDSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSS diagnosisConcept  " + diagnosisConcept);
		// List<Concept> modd = Context.getConceptService()
		// .getConceptsByClass(diagnosisConcept);
		/*
		 * for (Concept ade : modd) {
		 * ConceptName diagnosisConceptNamet = ade.getName();
		 * diagnosisConceptNameList.add(diagnosisConceptNamet);
		 * }
		 */
		
		model.addAttribute("urgencies", urgencies);
		// model.addAttribute("diagnosislist", modd);
		model.addAttribute("studyConceptNameList", studyConceptNameList);
		// model.addAttribute("modalityConceptNameList", modalityConceptNameList);
		model.addAttribute("performedStatuses", performedStatuses);
		model.addAttribute("patient", patient);
		model.addAttribute("returnUrl", returnUrl);
		if (Context.isAuthenticated()) {
			model.addAttribute("order", new Order());
			final RadiologyOrder radiologyOrder = new RadiologyOrder();
			radiologyOrder.setStudy(new Study());
			model.addAttribute("radiologyOrder", radiologyOrder);
		}
		
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
			@RequestParam(value = "studyname") String studyname,
			@RequestParam(value = "diagnosisname") String diagnosisname,
			@RequestParam(value = "instructionname") String instructionname,
			@RequestParam(value = "priorityname") String priorityname) throws ParseException {
		
		System.out.println("PAPAPAPAPAPAPATITNTBET " + patient.getGivenName());
		System.out.println("PAPAPAPAPAPAPATITNTBET " + patient.getUuid());
		
		RadiologyOrder radiologyOrder = new RadiologyOrder();
		
		User authenticatedUser = Context.getAuthenticatedUser();
		
		System.out.println("SSSSS TTTTT UUUUU DDDDD YYYYYYY " + studyname);
		System.out.println("USer  PPPPPPPPP " + authenticatedUser.getUsername());
		
		// Provider provider = new Provider();
		// provider.setProviderId(++count);
		// provider.setName(authenticatedUser.getUsername());
		// Provider provider =
		
		Provider provider = Context.getProviderService()
				.getProvider(authenticatedUser.getId());
		// .saveProvider(pp);
		// radiologyOrder.setOrderer(Context.getProviderService());
		System.out.println("KKKKKKKKKKKKK PPPPPPPPPPPPPP " + provider.getCreator());
		System.out.println("KKKKKKKKKKKKK PPPPPPPPPPPPPP " + provider.getCreator()
				.getName());
		System.out.println("KKKKKKKKKKKKK PPPPPPPPPPPPPP " + provider.getCreator()
				.getUsername());
		
		radiologyOrder.setCreator(authenticatedUser);
		radiologyOrder.setOrderer(provider);
		// Encounter ee = new Encounter();
		
		radiologyOrder.setPatient(patient);
		// radiologyOrder.getEncounter().getEncounterId();
		radiologyOrder.setDateCreated(new Date());
		radiologyOrder.setInstructions(instructionname);
		radiologyOrder.setUrgency(Order.Urgency.valueOf(priorityname));
		radiologyOrder.setOrderdiagnosis(diagnosisname);
		
		RadiologyService radiologyservice = Context.getService(RadiologyService.class);
		List<RadiologyStudyList> studyListSaved = radiologyservice.getAllStudy();
		Study study = new Study();
		
		// study.setModality(modalityname);
		study.setStudyname(studyname);
		
		List<Form> studyreport = Context.getFormService()
				.getAllForms();
		
		for (Form searchform : studyreport) {
			
			String podspdoas = searchform.getName()
					.trim();
			
			if (study.getStudyname()
					.equals(podspdoas)) {
				System.out.println("PAPAPAPAPAPAPATITNTBET 6546546 " + patient.getGivenName());
				System.out.println("PAPAPAPAPAPAPATITNTBET 6576575675" + patient.getUuid());
				
				String domain = "http://localhost:8080/openmrs/htmlformentryui/htmlform/enterHtmlFormWithStandardUi.page?patientId=";
				String patientidurl = patient.getUuid();
				
				String visitform = "&visitId=&formUuid=";
				String formuuidurl = searchform.getUuid();
				String returnurl = "&returnUrl=";
				// String returnurl = "&returnUrl=/openmrs/radiology/radiologistActiveOrders.page";
				
				String url = domain.concat(patientidurl)
						.concat(visitform)
						.concat(formuuidurl)
						.concat(returnurl);
				
				System.out.println("HYYEYYEYEYYEYEYEYE SAME SAM");
				study.setStudyreporturl(url);
				
				System.out.println("URL URL URL URL URL URL URL " + url);
				System.out.println("URL URL URL URL URL URL URL " + study.getStudyreporturl());
				
			}
			
		}
		
		study.setPerformedStatus(PerformedProcedureStepStatus.IN_PROGRESS);
		study.setScheduledStatus(ScheduledProcedureStepStatus.SCHEDULED);
		study.setRadiologyStatusOrder(RadiologyOrderStatus.INPROGRESS);
		
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
	
	public List<SimpleObject> getStudyAutocomplete(@RequestParam(value = "query", required = false) String query,
			@RequestParam(value = "conceptStudyClass", required = false) String requireConceptClass,
			@SpringBean("conceptService") ConceptService service, UiUtils ui) {
		
		System.out.println("**********getSuggestions: query: " + query + "  requireConceptClass: " + requireConceptClass);
		List<ConceptClass> requireClasses = new ArrayList<ConceptClass>();
		
		if ((requireConceptClass == null) || (requireConceptClass.equals(""))) {
			requireClasses = null;
		} else {
			for (ConceptClass cl : service.getAllConceptClasses()) {
				if (requireConceptClass.equals(cl.getName())) {
					requireClasses.add(cl);
					System.out.println("Concept Class Name Found: " + cl.getName());
					break;
				}
			}
		}
		
		// the following will return at most 100 matches
		List<ConceptSearchResult> results = Context.getConceptService()
				.getConcepts(query, null, false, requireClasses, null, null, null, null, 0, 100);
		
		List<Concept> names = new ArrayList<Concept>();
		for (ConceptSearchResult con : results) {
			names.add(con.getConcept()); // con.getConcept().getName().getName()
			System.out.println("Concept: " + con.getConceptName());
		}
		/*
		 * The Ajax call requires a json result;
		 * names are concepts and properties indicate the Concept properties of interest;
		 * The framework will build the json response when the method returns
		 */
		String[] properties = new String[] { "name" };
		return SimpleObject.fromCollection(names, ui, properties);
	}
	
	public List<SimpleObject> getDiagnosisAutocomplete(@RequestParam(value = "query", required = false) String query,
			@RequestParam(value = "conceptDiagnosisClass", required = false) String requireConceptClass,
			@SpringBean("conceptService") ConceptService service, UiUtils ui) {
		
		System.out.println("**********getSuggestions: query: " + query + "  requireConceptClass: " + requireConceptClass);
		List<ConceptClass> requireClasses = new ArrayList<ConceptClass>();
		
		if ((requireConceptClass == null) || (requireConceptClass.equals(""))) {
			requireClasses = null;
		} else {
			for (ConceptClass cl : service.getAllConceptClasses()) {
				if (requireConceptClass.equals(cl.getName())) {
					requireClasses.add(cl);
					System.out.println("Concept Class Name Found: " + cl.getName());
					break;
				}
			}
		}
		
		// the following will return at most 100 matches
		List<ConceptSearchResult> results = Context.getConceptService()
				.getConcepts(query, null, false, requireClasses, null, null, null, null, 0, 100);
		
		List<Concept> names = new ArrayList<Concept>();
		for (ConceptSearchResult con : results) {
			names.add(con.getConcept()); // con.getConcept().getName().getName()
			System.out.println("Concept: " + con.getConceptName());
		}
		/*
		 * The Ajax call requires a json result;
		 * names are concepts and properties indicate the Concept properties of interest;
		 * The framework will build the json response when the method returns
		 */
		String[] properties = new String[] { "name" };
		return SimpleObject.fromCollection(names, ui, properties);
	}
	
}

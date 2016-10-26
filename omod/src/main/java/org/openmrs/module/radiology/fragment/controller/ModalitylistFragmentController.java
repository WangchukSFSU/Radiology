/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package org.openmrs.module.radiology.fragment.controller;

import java.util.ArrayList;
import java.util.List;
import org.openmrs.Concept;
import org.openmrs.ConceptClass;
import org.openmrs.ConceptName;
import org.openmrs.ConceptSet;
import org.openmrs.Form;
import org.openmrs.Patient;
import org.openmrs.api.ConceptService;
import org.openmrs.api.context.Context;
import org.openmrs.module.htmlformentry.FormEntrySession;
import org.openmrs.module.htmlformentry.HtmlForm;
import org.openmrs.module.htmlformentry.HtmlFormEntryUtil;
import org.openmrs.module.radiology.RadiologyService;
import org.openmrs.module.radiology.RadiologyStudyList;

import org.openmrs.ui.framework.SimpleObject;
import org.openmrs.ui.framework.UiUtils;
import org.openmrs.ui.framework.annotation.SpringBean;
import org.openmrs.ui.framework.fragment.FragmentModel;
import org.springframework.web.bind.annotation.RequestParam;

public class ModalitylistFragmentController {
	
	public void controller(FragmentModel model) throws Exception {
		
		Patient patient = null;
		Form form = null;
		HtmlForm htmlForm = null;
		
		form = Context.getFormService()
				.getForm(7);
		htmlForm = HtmlFormEntryUtil.getService()
				.getHtmlFormByForm(form);
		
		patient = Context.getPatientService()
				.getPatient(2);
		
		FormEntrySession session = null;
		session = new FormEntrySession(patient, htmlForm, null, null);
		
		// ensure we've generated the form's HTML (and thus set up the submission actions, etc) before we do anything
		session.getHtmlToDisplay();
		
		model.addAttribute("session", session);
		
		List<Form> mod = new ArrayList();
		List<Form> studyreport = Context.getFormService()
				.getAllForms();
		
		for (Form searchform : studyreport) {
			// System.out.println("GOOD ************************************ " + searchform.getName());
			// System.out.println("GOOD **************************************" + searchform.getFormId());
			if (searchform.getFormId()
					.equals(7)) {
				System.out.println("GOOD ************************************ " + searchform.getName());
				System.out.println("GOOD **************************************" + searchform.getUuid());
				mod.add(searchform);
			}
			
		}
		
		ArrayList<ConceptName> modalityconceptnamelist = new ArrayList();
		List<ConceptSet> moset = Context.getConceptService()
				.getConceptSetsByConcept(Context.getConceptService()
						.getConcept(164068));
		
		for (ConceptSet abd : moset) {
			
			ConceptName modalityConceptName = abd.getConcept()
					.getName();
			
			System.out.println("Cocnept Set " + abd.getConceptSet());
			System.out.println("Cocnept Set cc " + abd.getConcept());
			modalityconceptnamelist.add(modalityConceptName);
		}
		
		model.addAttribute("mmm", modalityconceptnamelist);
		model.addAttribute("mod", mod);
		
	}
	
	public List<SimpleObject> getStudyConceptsAnswerFromModality(@SpringBean("conceptService") ConceptService service,
			UiUtils ui) {
		
		ArrayList<Concept> studySetMembers = new ArrayList<Concept>();
		
		ConceptClass mot = Context.getConceptService()
				.getConceptClassByName("Radiology/Imaging Procedure");
		
		List<Concept> mot_list = Context.getConceptService()
				.getConceptsByClass(mot);
		
		for (Concept ccc : mot_list) {
			if (ccc.getDisplayString()
					.endsWith("modality")) {
				
			} else {
				studySetMembers.add(ccc);
			}
		}
		
		saveStudy(studySetMembers);
		String[] properties = new String[2];
		properties[0] = "conceptId";
		properties[1] = "displayString";
		return SimpleObject.fromCollection(studySetMembers, ui, properties);
	}
	
	public List<SimpleObject> getReportConcepts(FragmentModel model, @SpringBean("conceptService") ConceptService service,
			UiUtils ui) {
		
		ArrayList<RadiologyStudyList> studylistmember = new ArrayList<RadiologyStudyList>();
		List<RadiologyStudyList> liststudystudy = Context.getService(RadiologyService.class)
				.getAllStudy();
		
		for (RadiologyStudyList getstudyselected : liststudystudy) {
			
			System.out.println("selectedstudy same ");
			studylistmember.add(getstudyselected);
			
		}
		
		String[] properties = new String[3];
		properties[0] = "id";
		properties[1] = "studyName";
		properties[2] = "studyReporturl";
		return SimpleObject.fromCollection(studylistmember, ui, properties);
	}
	
	public List<SimpleObject> getStudyConcepts(FragmentModel model, @SpringBean("conceptService") ConceptService service,
			UiUtils ui) {
		
		List<RadiologyStudyList> liststudystudy = Context.getService(RadiologyService.class)
				.getAllStudy();
		
		ArrayList<ConceptName> studySetMembers = new ArrayList<ConceptName>();
		
		ConceptClass mot = Context.getConceptService()
				.getConceptClassByName("Radiology/Imaging Procedure");
		
		List<Concept> mot_list = Context.getConceptService()
				.getConceptsByClass(mot);
		
		for (Concept ccc : mot_list) {
			for (RadiologyStudyList getstudyselected : liststudystudy) {
				if (ccc.getDisplayString()
						.endsWith("modality")) {
					
				} else if (ccc.getDisplayString()
						.equals(getstudyselected.getStudyName())) {
					
				}
				
				else {
					studySetMembers.add(ccc.getName());
				}
			}
		}
		
		String[] properties = new String[2];
		properties[0] = "id";
		properties[1] = "name";
		
		return SimpleObject.fromCollection(studySetMembers, ui, properties);
	}
	
	public void saveStudy(@RequestParam(value = "studyList[]") ArrayList<Concept> studyList) {
		
		List<Form> studyreport = Context.getFormService()
				.getAllForms();
		
		List<Patient> personrowuuid = Context.getPatientService()
				.getAllPatients(true);
		Integer patientid = personrowuuid.size();
		
		System.out.println("Length of patient " + personrowuuid.get(patientid - 1)
				.getUuid());
		RadiologyStudyList studyName = new RadiologyStudyList();
		List<RadiologyStudyList> liststudysaved = Context.getService(RadiologyService.class)
				.getAllStudy();
		
		if (liststudysaved.isEmpty()) {
			
			for (Concept studylist : studyList) {
				
				for (Form searchform : studyreport) {
					
					String noopa = studylist.getDisplayString();
					String podspdoas = searchform.getName()
							.trim();
					
					if (noopa.equals(podspdoas)) {
						
						int studyConceptid = studylist.getConceptId();
						
						studyName.setStudyConceptId(studyConceptid);
						
						studyName.setStudyName(studylist.getDisplayString());
						
						System.out.println("SSSSSSSSSSSSS noopa" + noopa);
						System.out.println("SSSSSSSSSSSSS podspdoas" + podspdoas);
						
						String domain = "http://localhost:8080/openmrs/htmlformentryui/htmlform/enterHtmlFormWithStandardUi.page?patientId=";
						String patientidurl = personrowuuid.get(patientid - 1)
								.getUuid();
						String visitform = "&visitId=&formUuid=";
						String formuuidurl = searchform.getUuid();
						String returnurl = "&returnUrl=/openmrs/radiology/adminInitialize.page";
						
						String url = domain.concat(patientidurl)
								.concat(visitform)
								.concat(formuuidurl)
								.concat(returnurl);
						
						System.out.println("HYYEYYEYEYYEYEYEYE SAME SAM");
						studyName.setStudyReporturl(url);
						
						Context.getService(RadiologyService.class)
								.saveStudyList(studyName);
						
					}
					
				}
				
			}
			
		} else {
			System.out.println("Not Empty");
			
			for (Concept studylist : studyList) {
				
				for (Form searchform : studyreport) {
					
					String noopa = studylist.getDisplayString();
					String podspdoas = searchform.getName()
							.trim();
					
					if (noopa.equals(podspdoas)) {
						
						System.out.println("SSSSSSSSSSSSS noopa" + noopa);
						System.out.println("SSSSSSSSSSSSS podspdoas" + podspdoas);
						for (RadiologyStudyList comparestudy : liststudysaved) {
							System.out.println("MKOKDOSDSDDD comparestudy.getStudyName()" + comparestudy.getStudyName());
							System.out.println("MKOKDOSDSDDD comparnoopa  )" + noopa);
							
							if (comparestudy.getStudyName()
									.equals(noopa)) {
								return;
							} else {
								int studyConceptid = studylist.getConceptId();
								
								studyName.setStudyConceptId(studyConceptid);
								
								studyName.setStudyName(studylist.getDisplayString());
								
								String domain = "http://localhost:8080/openmrs/htmlformentryui/htmlform/enterHtmlFormWithStandardUi.page?patientId=";
								String patientidurl = personrowuuid.get(patientid - 1)
										.getUuid();
								String visitform = "&visitId=&formUuid=";
								String formuuidurl = searchform.getUuid();
								String returnurl = "&returnUrl=/openmrs/radiology/adminInitialize.page";
								
								String url = domain.concat(patientidurl)
										.concat(visitform)
										.concat(formuuidurl)
										.concat(returnurl);
								
								System.out.println("HYYEYYEYEYYEYEYEYE SAME SAM");
								studyName.setStudyReporturl(url);
								
								Context.getService(RadiologyService.class)
										.saveStudyList(studyName);
								
							}
						}
						
					}
					
				}
				
			}
		}
		
	}
	
}

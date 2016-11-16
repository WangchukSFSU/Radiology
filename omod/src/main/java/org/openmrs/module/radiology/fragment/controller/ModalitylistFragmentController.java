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
import org.openmrs.module.htmlformentry.FormEntryContext.Mode;
import org.openmrs.module.htmlformentry.FormEntrySession;
import org.openmrs.module.htmlformentry.HtmlForm;
import org.openmrs.module.htmlformentry.HtmlFormEntryUtil;
import org.openmrs.module.radiology.RadiologyService;

import org.openmrs.ui.framework.SimpleObject;
import org.openmrs.ui.framework.UiUtils;
import org.openmrs.ui.framework.annotation.SpringBean;
import org.openmrs.ui.framework.fragment.FragmentModel;
import org.springframework.web.bind.annotation.RequestParam;

public class ModalitylistFragmentController {
	
	public void controller(FragmentModel model) throws Exception {
		
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
		
		String[] properties = new String[2];
		properties[0] = "conceptId";
		properties[1] = "displayString";
		return SimpleObject.fromCollection(studySetMembers, ui, properties);
	}
	
	public List<SimpleObject> getReportConcepts(FragmentModel model, @SpringBean("conceptService") ConceptService service,
			UiUtils ui) throws Exception {
		
		ArrayList<FormEntrySession> fff = new ArrayList<FormEntrySession>();
		
		List<Form> getAllForms = Context.getFormService()
				.getAllForms();
		ConceptClass getConceptClassByName = Context.getConceptService()
				.getConceptClassByName("Radiology/Imaging Procedure");
		List<Concept> getConceptsByClass = Context.getConceptService()
				.getConceptsByClass(getConceptClassByName);
		
		for (Form searchform : getAllForms) {
			
			String searchformName = searchform.getName()
					.trim();
			if (searchform.getFormId()
					.equals(7)) {
				
				Mode mode = Mode.ENTER;
				HtmlForm htmlForm = HtmlFormEntryUtil.getService()
						.getHtmlFormByForm(searchform);
				Patient patient = HtmlFormEntryUtil.getFakePerson();
				FormEntrySession FormEntrySessionNew = null;
				FormEntrySessionNew = new FormEntrySession(patient, htmlForm, mode, null);
				FormEntrySessionNew.getHtmlToDisplay();
				fff.add(FormEntrySessionNew);
			}
			
		}
		
		String[] FormEntryProperties = new String[3];
		FormEntryProperties[0] = "FormName";
		FormEntryProperties[1] = "Form";
		FormEntryProperties[2] = "HtmlToDisplay";
		
		return SimpleObject.fromCollection(fff, ui, FormEntryProperties);
	}
	
	public List<SimpleObject> getStudyConcepts(FragmentModel model, @SpringBean("conceptService") ConceptService service,
			UiUtils ui) {
		
		ArrayList<ConceptName> studySetMembers = new ArrayList<ConceptName>();
		
		ConceptClass mot = Context.getConceptService()
				.getConceptClassByName("Radiology/Imaging Procedure");
		
		List<Concept> mot_list = Context.getConceptService()
				.getConceptsByClass(mot);
		
		for (Concept ccc : mot_list) {
			
			if (ccc.getDisplayString()
					.endsWith("modality")) {
				
			}
			
			else {
				studySetMembers.add(ccc.getName());
			}
		}
		
		String[] properties = new String[2];
		properties[0] = "id";
		properties[1] = "name";
		
		return SimpleObject.fromCollection(studySetMembers, ui, properties);
	}
	
	public List<SimpleObject> manageReport(FragmentModel model, @SpringBean("conceptService") ConceptService service,
			UiUtils ui) {
		
		ArrayList<FormEntrySession> fff = new ArrayList<FormEntrySession>();
		
		ArrayList<ConceptName> studySetMembers = new ArrayList<ConceptName>();
		
		ConceptClass mot = Context.getConceptService()
				.getConceptClassByName("Radiology/Imaging Procedure");
		
		List<Concept> mot_list = Context.getConceptService()
				.getConceptsByClass(mot);
		
		for (Concept ccc : mot_list) {
			
			if (ccc.getDisplayString()
					.endsWith("modality")) {
				
			}
			
			else {
				studySetMembers.add(ccc.getName());
			}
			
		}
		
		String[] properties = new String[2];
		properties[0] = "id";
		properties[1] = "name";
		
		return SimpleObject.fromCollection(studySetMembers, ui, properties);
	}
	
	public List<SimpleObject> getReport(FragmentModel model, @SpringBean("conceptService") ConceptService service, UiUtils ui)
			throws Exception {
		
		// list of Study Forms avaialble
		ArrayList<FormEntrySession> getStudyHTMLCreated = new ArrayList<FormEntrySession>();
		
		// Get All HTMLForms
		List<Form> getAllHTMLForms = Context.getFormService()
				.getAllForms();
		
		// Study Concept Class
		ConceptClass studyConceptClass = Context.getConceptService()
				.getConceptClassByName("Radiology/Imaging Procedure");
		
		// Get all Study Concept
		List<Concept> listOfStudyConcept = Context.getConceptService()
				.getConceptsByClass(studyConceptClass);
		
		for (Concept eachStudyConcept : listOfStudyConcept) {
			
			for (Form eachHTMLForms : getAllHTMLForms) {
				
				// study name
				String studyDisplayString = eachStudyConcept.getDisplayString();
				// htmlform name
				String htmlFormName = eachHTMLForms.getName()
						.trim();
				
				// check if study htmlform is available
				if (studyDisplayString.equals(htmlFormName)) {
					
					Mode mode = Mode.ENTER;
					
					HtmlForm htmlForm = HtmlFormEntryUtil.getService()
							.getHtmlFormByForm(eachHTMLForms);
					
					Patient patient = HtmlFormEntryUtil.getFakePerson();
					
					FormEntrySession session = null;
					session = new FormEntrySession(patient, htmlForm, mode, null);
					
					session.getHtmlToDisplay();
					
					session.getFormName();
					
					getStudyHTMLCreated.add(session);
					
				}
			}
		}
		
		String[] properties = new String[2];
		properties[0] = "FormName";
		properties[1] = "HtmlToDisplay";
		return SimpleObject.fromCollection(getStudyHTMLCreated, ui, properties);
	}
	
}

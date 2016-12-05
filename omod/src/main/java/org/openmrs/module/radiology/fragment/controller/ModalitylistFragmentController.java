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
import org.openmrs.ui.framework.SimpleObject;
import org.openmrs.ui.framework.UiUtils;
import org.openmrs.ui.framework.annotation.SpringBean;
import org.openmrs.ui.framework.fragment.FragmentModel;

public class ModalitylistFragmentController {
	
	public void controller(FragmentModel model) throws Exception {
		
		ArrayList<ConceptName> modalityConcept = new ArrayList();
		List<ConceptSet> modalityConceptSet = Context.getConceptService()
				.getConceptSetsByConcept(Context.getConceptService()
						.getConcept(164068));
		
		for (ConceptSet addModalityConceptSet : modalityConceptSet) {
			
			ConceptName modalityConceptName = addModalityConceptSet.getConcept()
					.getName();
			
			modalityConcept.add(modalityConceptName);
		}
		
		model.addAttribute("modalityConcept", modalityConcept);
		
	}
	
	public List<SimpleObject> getStudyConceptsAnswerFromModality(@SpringBean("conceptService") ConceptService service,
			UiUtils ui) {
		
		ArrayList<Concept> studySetMembers = new ArrayList<Concept>();
		
		ConceptClass studyClassName = Context.getConceptService()
				.getConceptClassByName("Radiology/Imaging Procedure");
		
		List<Concept> studyClassNameConcept = Context.getConceptService()
				.getConceptsByClass(studyClassName);
		
		for (Concept filterStudyClassNameConcept : studyClassNameConcept) {
			if (!filterStudyClassNameConcept.getDisplayString()
					.endsWith("modality")) {
				studySetMembers.add(filterStudyClassNameConcept);
			}
		}
		
		String[] properties = new String[4];
		properties[0] = "conceptId";
		properties[1] = "displayString";
		properties[2] = "id";
		properties[3] = "name";
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

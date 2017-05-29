package org.openmrs.module.radiology.fragment.controller;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;
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

import org.openmrs.module.radiology.ModalityInit;
import org.openmrs.module.radiology.RadiologyProperties;
import org.openmrs.module.radiology.RadiologyService;
import org.openmrs.ui.framework.SimpleObject;
import org.openmrs.ui.framework.UiUtils;
import org.openmrs.ui.framework.annotation.SpringBean;
import org.openmrs.ui.framework.fragment.FragmentModel;
import org.springframework.web.bind.annotation.RequestParam;

/**
 * Admin manage modality, study and report for the radiology module
 * 
 * @author tenzin
 */
public class AdminManageRadiologyModuleFragmentController {
	
	/**
	 * Get modality concepts available in the concept dictionary
	 * Get the URL for the concept dictionary and htmlform
	 * 
	 * @param model FragmentModel
	 */
	public void controller(FragmentModel model) {
		// get modality concept name
		ArrayList<ConceptName> modalityConceptName = new ArrayList();
		// get modality concept
		ArrayList<Concept> modalityConcept = getModalityConcept();
		// convert modality concept to conceptName
		for (Concept getModalityConceptName : modalityConcept) {
			modalityConceptName.add(getModalityConceptName.getName());
		}
		
		RadiologyProperties radiologyProperties = new RadiologyProperties();
		
		// concept dictionary and htmlform url
		String serverAddress = radiologyProperties.getOpenMRSServersAddress();
		String serverPort = radiologyProperties.getOpenMRSServersPort();
		String conceptDictionaryFormUrl = serverAddress + ":" + serverPort + "/openmrs/dictionary/concept.form";
		String htmlFormsUrl = serverAddress + ":" + serverPort + "/openmrs/module/htmlformentry/htmlForms.list";
		model.addAttribute("htmlFormsUrl", htmlFormsUrl);
		model.addAttribute("conceptDictionaryFormUrl", conceptDictionaryFormUrl);
		model.addAttribute("modalityConcept", modalityConceptName);
		
		String modalitySoftware = radiologyProperties.getModalitySoftwareAvalability();
		if (modalitySoftware.toLowerCase()
				.contains("Yes".toLowerCase())) {
			model.addAttribute("modalitySoftware", modalitySoftware);
		} else {
			model.addAttribute("modalitySoftware", "");
		}
		
		System.out.println("lkkdfdf " + modalitySoftware);
		String dicomFileRootFolder = radiologyProperties.getSmtpAuthentificationPassword();
		System.out.println("fssewrwwr " + dicomFileRootFolder);
		
		// Get modality ip address and home directory from the saved ModalityInit table
		List<String> absentModality = new ArrayList<String>();
		List<ModalityInit> modalityList = Context.getService(RadiologyService.class)
				.getAllModalityInit();
		HashMap<String, String> modlist = new HashMap<String, String>();
		
		if (modalityList.isEmpty()) {
			for (ConceptName eachConcept : modalityConceptName) {
				modlist.put(eachConcept.toString(), "");
				absentModality.add(eachConcept.toString());
			}
		} else {
			
			Boolean modPresent = true;
			for (ConceptName eachConceptName : modalityConceptName) {
				for (ModalityInit moo : modalityList) {
					
					String conceptString = eachConceptName.toString()
							.trim();
					String modString = moo.getModalityName()
							.toString()
							.trim();
					if (conceptString.equals(modString)) {
						modPresent = false;
						modlist.put(eachConceptName.toString(), moo.getModalityIP());
						break;
						
					} else {
						modPresent = true;
					}
				}
				if (modPresent) {
					modlist.put(eachConceptName.toString(), "");
					absentModality.add(eachConceptName.toString());
					modPresent = true;
					
				}
				
			}
		}
		
		model.addAttribute("modalityList", modalityList);
		model.addAttribute("modlist", modlist);
		model.addAttribute("absentModality", absentModality);
		
	}
	
	/**
	 * Get the list of modality concept
	 * 
	 * @return modality Concepts from the concept dictionary
	 */
	public ArrayList<Concept> getModalityConcept() {
		ArrayList<Concept> modalityConcept = new ArrayList();
		List<ConceptSet> modalityConceptSet = Context.getConceptService()
				.getConceptSetsByConcept(Context.getConceptService()
						.getConcept(164068));
		for (ConceptSet addModalityConceptSet : modalityConceptSet) {
			Concept modalityConceptName = addModalityConceptSet.getConcept();
			modalityConcept.add(modalityConceptName);
		}
		return modalityConcept;
	}
	
	/**
	 * Get the study concepts available in the concept dictionary
	 * 
	 * @param service ConceptService
	 * @param ui UiUtils
	 * @return study concepts available in the concept dictionary
	 */
	public List<SimpleObject> getStudyConceptsAnswerFromModality(@SpringBean("conceptService") ConceptService service,
			UiUtils ui) {
		
		ArrayList<Concept> studySetMembers = getStudyConcept();
		
		// properties selected from the study field
		String[] properties = new String[4];
		properties[0] = "conceptId";
		properties[1] = "displayString";
		properties[2] = "id";
		properties[3] = "name";
		return SimpleObject.fromCollection(studySetMembers, ui, properties);
	}
	
	/**
	 * Get the list of study concepts
	 * 
	 * @return studyConcept
	 */
	public ArrayList<Concept> getStudyConcept() {
		ArrayList<Concept> studyConcept = new ArrayList<Concept>();
		
		ArrayList<Concept> modalityConceptToBeRemovedFromStudyConcept = getModalityConcept();
		// study class name
		ConceptClass studyClassName = Context.getConceptService()
				.getConceptClassByName("Radiology/Imaging Procedure");
		List<Concept> studyClassNameConcept = Context.getConceptService()
				.getConceptsByClass(studyClassName);
		// get only study with no HtmlForm available
		studyClassNameConcept.removeAll(modalityConceptToBeRemovedFromStudyConcept);
		
		studyConcept.addAll(studyClassNameConcept);
		
		return studyConcept;
	}
	
	/**
	 * Get report generated for the study
	 * 
	 * @param model FragmentModel
	 * @param service conceptService
	 * @param ui UiUtils
	 * @return HTMLFOrm templates available for the study
	 */
	public List<SimpleObject> getReport(FragmentModel model, @SpringBean("conceptService") ConceptService service, UiUtils ui) {
		
		// list of Study Forms avaialble
		ArrayList<FormEntrySession> getStudyHTMLCreated = new ArrayList<FormEntrySession>();
		
		// Get All HTMLForms
		List<Form> getAllHTMLForms = Context.getFormService()
				.getAllForms();
		// Get all Study Concept
		List<Concept> listOfStudyConcept = getStudyConcept();
		for (Concept eachStudyConcept : listOfStudyConcept) {
			for (Form eachHTMLForms : getAllHTMLForms) {
				// study name
				String studyDisplayString = eachStudyConcept.getDisplayString();
				// htmlform name
				String htmlFormName = eachHTMLForms.getName()
						.trim();
				// check if study htmlform is available
				if (studyDisplayString.equals(htmlFormName)) {
					try {
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
					catch (Exception ex) {
						Logger.getLogger(AdminManageRadiologyModuleFragmentController.class.getName())
								.log(Level.SEVERE, null, ex);
					}
					
				}
			}
		}
		// properties selected from the HtmlForm field
		String[] properties = new String[2];
		properties[0] = "FormName";
		properties[1] = "HtmlToDisplay";
		return SimpleObject.fromCollection(getStudyHTMLCreated, ui, properties);
	}
	
	/**
	 * List studies having no generated HTMLForm
	 * 
	 * @param service ConceptService
	 * @param ui UiUtils
	 * @return study concepts having no generated htmlform available
	 */
	public List<SimpleObject> getStudyWithNoFormName(@SpringBean("conceptService") ConceptService service, UiUtils ui) {
		
		ArrayList<Concept> studySetMembers = new ArrayList<Concept>();
		// studies having HtmlForm
		ArrayList<Concept> studyConceptToBeRemoved = new ArrayList<Concept>();
		
		// Get All HTMLForms
		List<Form> getAllHTMLForms = Context.getFormService()
				.getAllForms();
		// Get all Study Concept
		List<Concept> listOfStudyConcept = getStudyConcept();
		for (Concept eachStudyConcept : listOfStudyConcept) {
			for (Form eachHTMLForms : getAllHTMLForms) {
				// study name
				String studyDisplayString = eachStudyConcept.getDisplayString();
				// htmlform name
				String htmlFormName = eachHTMLForms.getName()
						.trim();
				
				// check if study htmlform is available, add to the remove list
				if (studyDisplayString.equals(htmlFormName)) {
					studyConceptToBeRemoved.add(eachStudyConcept);
					
				}
				
			}
		}
		// get only study with no HtmlForm available
		listOfStudyConcept.removeAll(studyConceptToBeRemoved);
		
		studySetMembers.addAll(listOfStudyConcept);
		
		// properties selected from the study field
		String[] properties = new String[4];
		properties[0] = "conceptId";
		properties[1] = "displayString";
		properties[2] = "id";
		properties[3] = "name";
		return SimpleObject.fromCollection(studySetMembers, ui, properties);
	}
	
	/**
	 * Update/Save modality ip address
	 */
	public List<SimpleObject> updateModalityIP(@RequestParam(value = "modalityName") String modalityName,
			@RequestParam(value = "modalityIP") String modalityIP, @SpringBean("conceptService") ConceptService service,
			UiUtils ui) {
		
		ArrayList<ModalityInit> getModality = new ArrayList<ModalityInit>();
		
		List<ModalityInit> modalityList = Context.getService(RadiologyService.class)
				.getAllModalityInit();
		Boolean modalityAbsent = true;
		Integer modalityID = null;
		if (modalityList.isEmpty()) {
			modalityAbsent = true;
			
		} else {
			
			for (ModalityInit eachModality : modalityList) {
				if (eachModality.getModalityName()
						.toString()
						.trim()
						.equals(modalityName.toString()
								.trim())) {
					modalityAbsent = false;
					modalityID = eachModality.getId();
					
					ModalityInit mm2 = Context.getService(RadiologyService.class)
							.getModalityInit(modalityID);
					mm2.setModalityIP(modalityIP);
					Context.getService(RadiologyService.class)
							.saveModalityInit(mm2);
					
					break;
				} else {
					modalityAbsent = true;
				}
				
			}
			
		}
		
		if (modalityAbsent) {
			ModalityInit addModality = new ModalityInit();
			addModality.setModalityName(modalityName);
			addModality.setModalityIP(modalityIP);
			Context.getService(RadiologyService.class)
					.saveModalityInit(addModality);
			
		}
		
		// properties
		String[] properties = new String[2];
		properties[0] = "ModalityName";
		properties[1] = "ModalityIP";
		return SimpleObject.fromCollection(getModality, ui, properties);
	}
	
	/**
	 * Update modality folder path
	 */
	public List<SimpleObject> updateModalityRootPath(@RequestParam(value = "modalityName") String modalityName,
			@RequestParam(value = "modalityRootPath") String modalityRootPath,
			@SpringBean("conceptService") ConceptService service, UiUtils ui) {
		
		ArrayList<ModalityInit> getModality = new ArrayList<ModalityInit>();
		List<ModalityInit> modalityList = Context.getService(RadiologyService.class)
				.getAllModalityInit();
		Boolean modalityAbsent = true;
		Integer modalityID = null;
		if (modalityList.isEmpty()) {
			modalityAbsent = true;
			
		} else {
			
			for (ModalityInit eachModality : modalityList) {
				if (eachModality.getModalityName()
						.toString()
						.trim()
						.equals(modalityName.toString()
								.trim())) {
					modalityAbsent = false;
					modalityID = eachModality.getId();
					
					ModalityInit mm2 = Context.getService(RadiologyService.class)
							.getModalityInit(modalityID);
					mm2.setModalityPath(modalityRootPath);
					Context.getService(RadiologyService.class)
							.saveModalityInit(mm2);
					
					break;
				} else {
					modalityAbsent = true;
				}
				
			}
			
		}
		
		if (modalityAbsent) {
			ModalityInit addModality = new ModalityInit();
			addModality.setModalityName(modalityName);
			addModality.setModalityPath(modalityRootPath);
			Context.getService(RadiologyService.class)
					.saveModalityInit(addModality);
			
		}
		
		// properties
		String[] properties = new String[2];
		properties[0] = "ModalityName";
		properties[1] = "ModalityIP";
		return SimpleObject.fromCollection(getModality, ui, properties);
	}
	
}

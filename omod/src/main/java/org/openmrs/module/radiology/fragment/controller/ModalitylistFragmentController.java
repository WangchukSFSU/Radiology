/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package org.openmrs.module.radiology.fragment.controller;

import java.util.ArrayList;
import org.springframework.web.bind.annotation.RequestParam;
import java.util.Arrays;
import java.util.Collection;
import java.util.HashMap;
import java.util.List;
import java.util.Locale;
import java.util.Map;
import org.openmrs.Concept;
import org.openmrs.ConceptAnswer;
import org.openmrs.ConceptClass;
import org.openmrs.ConceptDatatype;
import org.openmrs.ConceptName;
import org.openmrs.ConceptSearchResult;
import org.openmrs.ConceptSet;
import org.openmrs.Form;
import org.openmrs.Patient;
import org.openmrs.api.ConceptService;
import org.openmrs.api.context.Context;
import org.openmrs.module.radiology.Modality;
import org.openmrs.module.radiology.RadiologyModalityList;
import org.openmrs.module.radiology.RadiologyReportList;
import org.openmrs.module.radiology.RadiologyService;
import org.openmrs.module.radiology.RadiologyStudyList;
import org.openmrs.module.radiology.Study;

import org.openmrs.ui.framework.SimpleObject;
import org.openmrs.ui.framework.UiUtils;
import org.openmrs.ui.framework.annotation.SpringBean;
import org.openmrs.ui.framework.fragment.FragmentModel;
import org.openmrs.ui.framework.page.PageModel;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

public class ModalitylistFragmentController {
	
	public void controller(FragmentModel model) {
		ConceptClass modality_concept = Context.getConceptService()
				.getConceptClassByName("modality");
		
		List<Concept> modality_list = Context.getConceptService()
				.getConceptsByClass(modality_concept);
		
		for (Concept ccd : modality_list) {
			
			System.out.println("CMDKCMDKCDMCDMKfdsdfds " + ccd);
			Collection<ConceptAnswer> monoa = ccd.getAnswers();
			
			for (ConceptAnswer ccdd : monoa) {
				// for (Concept ccd : monoa) {
				System.out.println("CMDKCMDKCDMCDMK " + ccdd.getAnswerConcept());
				
			}
			
		}
		
		String ss = null;
		ArrayList<String> modalityconceptdescription = new ArrayList();
		ArrayList<ConceptName> modalityconceptnamelist = new ArrayList();
		Map aps = new HashMap();
		for (Concept cc : modality_list) {
			
			ConceptName modalityConceptName = Context.getConceptService()
					.getConcept(cc.getConceptId())
					.getName();
			
			if (modalityConceptName.toString()
					.equals("X-Ray")) {
				modalityconceptdescription.add("A very energetic form of electromagnetic radiation that can be used to take images of the human body");
				ss = "A very energetic form of electromagnetic radiation that can be used to take images of the human body.";
			}
			if (modalityConceptName.toString()
					.equals("Ultrasound")) {
				modalityconceptdescription.add("Sound or other vibrations having an ultrasonic frequency, particularly as used in medical imaging");
				ss = "Sound or other vibrations having an ultrasonic frequency, particularly as used in medical imaging.";
			}
			if (modalityConceptName.toString()
					.equals("Magnetic Resonance Imaging")) {
				modalityconceptdescription.add("Uses a magnetic field and pulses of radio wave energy to make pictures of organs and structures inside the body.");
				ss = "Uses a magnetic field and pulses of radio wave energy to make pictures of organs and structures inside the body.";
			}
			aps.put(modalityConceptName, ss);
			modalityconceptnamelist.add(modalityConceptName);
			System.out.println("ONEEEEEEEEEEEEE111111 " + modalityConceptName);
			
		}
		model.addAttribute("aps", aps);
		model.addAttribute("modality_list", modality_list);
		model.addAttribute("modalityconceptnamelist", modalityconceptnamelist);
		model.addAttribute("modalityconceptdescription", modalityconceptdescription);
		
	}
	
	public List<SimpleObject> getStudyConcepts(
			@RequestParam(value = "studyconceptclass", required = false) String studyConceptone,
			@SpringBean("conceptService") ConceptService service, UiUtils ui) {
		
		System.out.println("Labset " + studyConceptone);
		Concept studyConcept = Context.getConceptService()
				.getConcept(studyConceptone.trim());
		ArrayList<Concept> studySetMembers = new ArrayList<Concept>();
		System.out.println("outside for loop ");
		
		Concept con;
		
		con = Context.getConceptService()
				.getConcept(studyConcept.getConceptId());
		
		System.out.println("**********Concept xxx " + con.getDisplayString());
		
		ConceptClass study_concept = Context.getConceptService()
				.getConceptClassByName(studyConcept.getDisplayString());
		System.out.println("**********Concept yyy ");
		List<Concept> study_list = Context.getConceptService()
				.getConceptsByClass(study_concept);
		System.out.println("**********Concept zzz ");
		
		for (Concept nextstudy : study_list) {
			System.out.println("**********Concept set member:  " + nextstudy.getDisplayString());
			studySetMembers.add(nextstudy);
		}
		
		String[] properties = new String[2];
		properties[0] = "conceptId";
		properties[1] = "displayString";
		return SimpleObject.fromCollection(studySetMembers, ui, properties);
	}
	
	public List<SimpleObject> getStudyConceptsAnswerFromModality(
			@RequestParam(value = "studyconceptclass", required = false) String studyConceptone,
			@SpringBean("conceptService") ConceptService service, UiUtils ui) {
		
		System.out.println("Labset " + studyConceptone);
		Concept studyConcept = Context.getConceptService()
				.getConcept(studyConceptone.trim());
		
		ArrayList<Concept> studySetMembers = new ArrayList<Concept>();
		
		Collection<ConceptAnswer> monoa = studyConcept.getAnswers();
		
		for (ConceptAnswer ccdd : monoa) {
			// for (Concept ccd : monoa) {
			System.out.println("CMDKCMDKCDMCDMK " + ccdd.getAnswerConcept());
			studySetMembers.add(ccdd.getAnswerConcept());
			
		}
		
		String[] properties = new String[2];
		properties[0] = "conceptId";
		properties[1] = "displayString";
		return SimpleObject.fromCollection(studySetMembers, ui, properties);
	}
	
	public List<SimpleObject> getReportConcepts(FragmentModel model,
			@RequestParam(value = "studyconceptclass", required = false) String[] studyConceptone,
			@SpringBean("conceptService") ConceptService service, UiUtils ui) {
		for (String conce : studyConceptone) {
			System.out.println("getReportConcepts 1 " + conce);
			
		}
		ArrayList<RadiologyStudyList> studylistmember = new ArrayList<RadiologyStudyList>();
		List<RadiologyStudyList> liststudystudy = Context.getService(RadiologyService.class)
				.getAllStudy();
		for (String selectedstudy : studyConceptone) {
			for (RadiologyStudyList getstudyselected : liststudystudy) {
				if (selectedstudy.equals(getstudyselected.getStudyName())) {
					System.out.println("selectedstudy same ");
					studylistmember.add(getstudyselected);
				}
				
			}
		}
		
		String[] properties = new String[3];
		properties[0] = "id";
		properties[1] = "studyName";
		properties[2] = "studyReporturl";
		return SimpleObject.fromCollection(studylistmember, ui, properties);
	}
	
	public void saveModality(FragmentModel model, @RequestParam(value = "modalityList[]") String[] modalityList) {
		
		for (String modlist : modalityList) {
			RadiologyModalityList modalityName = new RadiologyModalityList();
			
			int modalityConcept = Context.getConceptService()
					.getConcept(modlist.trim())
					.getConceptId();
			
			modalityName.setModalityId(modalityConcept);
			
			modalityName.setModalityname(modlist);
			
			Context.getService(RadiologyService.class)
					.saveModalityList(modalityName);
			
		}
		
	}
	
	public void saveStudy(@RequestParam(value = "studyList[]") String[] studyList) {
		
		System.out.println("KKKKKKKKKKKKKKKKKKKKLLLLLLLLLLLLLLLL " + studyList);
		List<Form> studyreport = Context.getFormService()
				.getAllForms();
		
		List<Patient> personrowuuid = Context.getPatientService()
				.getAllPatients(true);
		Integer patientid = personrowuuid.size();
		
		System.out.println("Length of patient " + personrowuuid.get(patientid - 1)
				.getUuid());
		
		for (String studylist : studyList) {
			RadiologyStudyList studyName = new RadiologyStudyList();
			int studyConceptid = Context.getConceptService()
					.getConcept(studylist.trim())
					.getConceptId();
			studyName.setStudyConceptId(studyConceptid);
			
			studyName.setStudyName(studylist);
			
			for (Form searchform : studyreport) {
				
				String noopa = studylist.trim();
				String podspdoas = searchform.getName()
						.trim();
				
				if (noopa.equals(podspdoas)) {
					
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
					
				}
				
			}
			Context.getService(RadiologyService.class)
					.saveStudyList(studyName);
			System.out.println("ZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZ " + studylist);
			
		}
		
	}
	
	public void saveReport(@RequestParam(value = "reportList[]") String[] studyList) {
		
		List<Form> formreport = Context.getFormService()
				.getAllForms();
		
		for (String studylist : studyList) {
			RadiologyReportList reportName = new RadiologyReportList();
			
			reportName.setStudyConceptName(studylist);
			for (Form reportform : formreport) {
				String studyname = studylist.trim();
				String formname = reportform.getName()
						.trim();
				
				if (studyname.equals(formname)) {
					reportName.setHtmlformuuid(reportform.getUuid());
				}
				
			}
			
			Context.getService(RadiologyService.class)
					.saveReportList(reportName);
			System.out.println("ZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZ " + studylist);
			
		}
		
	}
}

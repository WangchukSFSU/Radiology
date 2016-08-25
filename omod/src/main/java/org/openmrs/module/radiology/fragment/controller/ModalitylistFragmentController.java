/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package org.openmrs.module.radiology.fragment.controller;

import java.util.ArrayList;
import org.springframework.web.bind.annotation.RequestParam;
import java.util.Arrays;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import org.openmrs.Concept;
import org.openmrs.ConceptClass;
import org.openmrs.ConceptName;
import org.openmrs.ConceptSet;
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
			@RequestParam(value = "studyconceptclass", required = false) Concept studyConcept,
			@SpringBean("conceptService") ConceptService service, UiUtils ui) {
		
		System.out.println("Labset " + studyConcept);
		ArrayList<Concept> studySetMembers = new ArrayList<Concept>();
		System.out.println("outside for loop ");
		
		Concept con;
		
		con = Context.getConceptService()
				.getConcept(studyConcept.getConceptId());
		
		System.out.println("**********Concept xxx " + con.getDisplayString());
		
		ConceptClass study_concept = Context.getConceptService()
				.getConceptClassByName(studyConcept.getDisplayString());
		
		List<Concept> study_list = Context.getConceptService()
				.getConceptsByClass(study_concept);
		
		for (Concept nextstudy : study_list) {
			System.out.println("**********Concept set member:  " + nextstudy.getDisplayString());
			studySetMembers.add(nextstudy);
		}
		
		String[] properties = new String[2];
		properties[0] = "conceptId";
		properties[1] = "displayString";
		return SimpleObject.fromCollection(studySetMembers, ui, properties);
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
	
	public void saveStudy(@RequestParam(value = "studyList[]") Integer[] studyList) {
		
		System.out.println("KKKKKKKKKKKKKKKKKKKKLLLLLLLLLLLLLLLL " + studyList);
		
		for (Integer studylist : studyList) {
			RadiologyStudyList studyName = new RadiologyStudyList();
			studyName.setStudyConceptId(studylist);
			Context.getService(RadiologyService.class)
					.saveStudyList(studyName);
			System.out.println("ZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZ " + studylist);
			
		}
		
	}
	
	public void saveReport(@RequestParam(value = "reportList[]") Integer[] studyList) {
		
		for (Integer studylist : studyList) {
			RadiologyReportList reportName = new RadiologyReportList();
			
			reportName.setStudyConceptName(Context.getConceptService()
					.getConcept(studylist)
					.getDisplayString());
			reportName.setHtmlformuuid("9e414151-e2d0-4693-9548-b6beb916b213");
			
			Context.getService(RadiologyService.class)
					.saveReportList(reportName);
			System.out.println("ZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZ " + studylist);
			
		}
		
	}
}

/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package org.openmrs.module.radiology.fragment.controller;

import java.util.ArrayList;
import org.springframework.web.bind.annotation.RequestParam;
import java.util.Arrays;
import java.util.List;
import org.openmrs.Concept;
import org.openmrs.ConceptClass;
import org.openmrs.ConceptSet;
import org.openmrs.api.ConceptService;
import org.openmrs.api.context.Context;
import org.openmrs.module.radiology.Modality;
import org.openmrs.module.radiology.RadiologyModalityList;
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
		
		model.addAttribute("modality_list", modality_list);
		
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
		
		System.out.println("READY TO SAVE LABORDER");
		RadiologyModalityList modalityName = new RadiologyModalityList();
		for (String modlist : modalityList) {
			int modalityConcept = Integer.parseInt(modlist);
			modalityName.setModalityId(modalityConcept);
			
			modalityName.setModalityname(Context.getConceptService()
					.getConcept(modalityConcept)
					.getDisplayString());
			Context.getService(RadiologyService.class)
					.saveModalityList(modalityName);
			System.out.println("ORDER SAVED");
			
		}
		
	}
	
	public void saveStudy(@RequestParam(value = "studyList[]") Integer[] studyList) {
		
		RadiologyStudyList studyName = new RadiologyStudyList();
		for (Integer studylist : studyList) {
			studyName.setStudyConceptId(studylist);
			Context.getService(RadiologyService.class)
					.saveStudyList(studyName);
			System.out.println("ZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZ " + studylist);
			
		}
		
	}
	
	public void saveReport(@RequestParam(value = "reportList[]") Integer[] studyList) {
		
		List<Integer> saveStudyList = Arrays.asList(studyList);
		// RadiologyStudy setStudy = new RadiologyStudy();
		
		for (Integer studyName : saveStudyList) {
			
			// System.out.println("reportList " + studyName);
			
		}
		
	}
}

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
import org.openmrs.Form;
import org.openmrs.Patient;
import org.openmrs.api.context.Context;
import org.openmrs.module.radiology.RadiologyService;
import org.openmrs.module.radiology.RadiologyStudyList;
import org.openmrs.ui.framework.fragment.FragmentModel;
import org.springframework.web.bind.annotation.RequestParam;

/**
 * @author youdon
 */
public class AdminstudylistFragmentController {
	
	public void controller(FragmentModel model) {
		
		ArrayList<ConceptName> studyconceptnamelist = new ArrayList();
		
		ConceptClass studyclassname = Context.getConceptService()
				.getConceptClassByName("Radiology/Imaging Procedure");
		
		List<Concept> studyconcepts = Context.getConceptService()
				.getConceptsByClass(studyclassname);
		
		List<Form> studyformreport = Context.getFormService()
				.getAllForms();
		
		List<Patient> allpatient = Context.getPatientService()
				.getAllPatients(true);
		Integer patientid = allpatient.size();
		
		for (Concept eachstudyconcepts : studyconcepts) {
			
			System.out.println("POPODPSDSPD " + eachstudyconcepts.getDisplayString());
			if (eachstudyconcepts.getDisplayString()
					.endsWith("modality")) {
				
			} else {
				
				RadiologyStudyList studyName = new RadiologyStudyList();
				ConceptName modalityConceptName = eachstudyconcepts.getName();
				
				studyconceptnamelist.add(modalityConceptName);
				
				studyName.setStudyConceptId(eachstudyconcepts.getConceptId());
				
				studyName.setStudyName(eachstudyconcepts.getDisplayString());
				
				for (Form searchform : studyformreport) {
					
					String formname = searchform.getName()
							.trim();
					if (eachstudyconcepts.getDisplayString()
							.equals(formname)) {
						String domain = "http://localhost:8080/openmrs/htmlformentryui/htmlform/enterHtmlFormWithStandardUi.page?patientId=";
						String patientidurl = allpatient.get(patientid - 1)
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
				
			}
			
		}
		
		model.addAttribute("modalityconceptnamelist", studyconceptnamelist);
	}
	
	public void saveReport() {
		
		List<Form> studyreport = Context.getFormService()
				.getAllForms();
		
		List<Patient> personrowuuid = Context.getPatientService()
				.getAllPatients(true);
		Integer patientid = personrowuuid.size();
		
		System.out.println("Length of patient " + personrowuuid.get(patientid - 1)
				.getUuid());
		
		List<RadiologyStudyList> liststudysaved = Context.getService(RadiologyService.class)
				.getAllStudy();
		
		for (Form searchform : studyreport) {
			
			String podspdoas = searchform.getName()
					.trim();
			
			for (RadiologyStudyList comparestudy : liststudysaved) {
				System.out.println("POPOPPPPPOPO " + comparestudy.getStudyName());
				System.out.println("POPOPPPPPOPO " + podspdoas);
				
				if (comparestudy.getStudyName()
						.equals(podspdoas)) {
					
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
					
					comparestudy.setStudyReporturl(url);
					
				}
			}
			
		}
		
	}
	
}

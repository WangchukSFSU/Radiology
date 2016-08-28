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

public class StudylistFragmentController {
	
	public void controller(FragmentModel model, @RequestParam(value = "modalityListt", required = false) String[] returnUrl) {
		
		for (String sd : returnUrl) {
			System.out.println("ARRRRYALISTTTTTTTT " + sd);
		}
	}
}

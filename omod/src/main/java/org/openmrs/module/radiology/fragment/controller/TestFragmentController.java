/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package org.openmrs.module.radiology.fragment.controller;

import java.util.List;
import org.openmrs.api.context.Context;
import org.openmrs.module.radiology.RadiologyService;
import org.openmrs.module.radiology.RadiologyStudyList;
import org.openmrs.ui.framework.fragment.FragmentModel;

/**
 * @author youdon
 */
public class TestFragmentController {
	
	public void controller(FragmentModel model) {
		
		List<RadiologyStudyList> liststudystudy = Context.getService(RadiologyService.class)
				.getAllStudy();
		
		model.addAttribute("modalityconceptnamelist", liststudystudy);
		
	}
	
}

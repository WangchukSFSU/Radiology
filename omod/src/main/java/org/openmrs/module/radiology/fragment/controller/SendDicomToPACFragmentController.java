/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package org.openmrs.module.radiology.fragment.controller;

import java.io.File;
import java.util.ArrayList;
import org.openmrs.api.context.Context;
import org.openmrs.module.radiology.RadiologyService;
import org.openmrs.ui.framework.fragment.FragmentModel;

/**
 * @author youdon
 */
public class SendDicomToPACFragmentController {
	
	public void controller(FragmentModel model) {
		
		System.out.println("22222222222222 ");
		
		ArrayList<String> apo = listFiles("/home/youdon/Desktop/aaa");
		
		// radiologyservice.placeDicomInPacs("/home/youdon/Downloads/dicomImage/FluroWithDisplayShutter.dcm");
		System.out.println("444444444 ");
		model.addAttribute("apo", apo);
		
	}
	
	public ArrayList listFiles(String directoryName) {
		ArrayList<String> aa = new ArrayList();
		File directory = new File(directoryName);
		// get all the files from a directory
		File[] fList = directory.listFiles();
		for (File file : fList) {
			if (file.isFile()) {
				System.out.println("DSDSDSDDSSD " + file.getName());
				aa.add(file.getName());
			}
		}
		return aa;
	}
	
	public void sendDicomToPACS() {
		
		System.out.println("333333333333333 ");
		RadiologyService radiologyservice = Context.getService(RadiologyService.class);
		ArrayList<String> apo = listFiles("/home/youdon/Desktop/aaa");
		
		radiologyservice.placeDicomInPacs("/home/youdon/Desktop/aaa");
		System.out.println("4444477777777777777 ");
		
	}
	
}

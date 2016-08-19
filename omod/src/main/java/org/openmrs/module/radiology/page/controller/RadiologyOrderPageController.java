/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package org.openmrs.module.radiology.page.controller;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.Date;
import java.util.HashMap;
import java.util.LinkedList;
import java.util.List;
import java.util.Map;
import java.util.Vector;
import org.openmrs.Concept;
import org.openmrs.ConceptClass;
import org.openmrs.ConceptName;
import org.openmrs.Order;
import org.openmrs.Patient;
import org.openmrs.api.context.Context;
import org.openmrs.module.radiology.PerformedProcedureStepStatus;
import org.openmrs.module.radiology.RadiologyConstants;
import org.openmrs.module.radiology.RadiologyModalityList;
import org.openmrs.module.radiology.RadiologyOrder;
import org.openmrs.module.radiology.RadiologyProperties;
import org.openmrs.module.radiology.RadiologyService;
import org.openmrs.module.radiology.RadiologyStudyList;
import org.openmrs.ui.framework.fragment.FragmentModel;
import org.openmrs.ui.framework.page.PageModel;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;

public class RadiologyOrderPageController {
	
	public void controller(PageModel model, @RequestParam(value = "returnUrl", required = false) String returnUrl,
			@RequestParam(value = "patientId", required = false) Patient patient) {
		
		String aa = Context.getAdministrationService()
				.getGlobalProperty(RadiologyConstants.GP_RADIOLOGY_CONCEPT_CLASSES);
		System.out.println("AAAAA" + aa);
		
		final List<String> urgencies = new LinkedList<String>();
		
		for (Order.Urgency urgency : Order.Urgency.values()) {
			System.out.println("EEEEEEEE" + urgency.name());
			urgencies.add(urgency.name());
		}
		
		Map<String, String> performedStatuses = new HashMap<String, String>();
		for (PerformedProcedureStepStatus performedStatus : PerformedProcedureStepStatus.values()) {
			performedStatuses.put(performedStatus.name(), performedStatus.name());
			System.out.println("list performned status " + performedStatus.name());
		}
		
		RadiologyService radiologyservice = Context.getService(RadiologyService.class);
		final List<RadiologyModalityList> modalityListFromDb = radiologyservice.getAllModality();
		ArrayList<ConceptName> modalityConceptNameList = new ArrayList();
		for (RadiologyModalityList modalityConceptId : modalityListFromDb) {
			int modalityConceptIdInteger = modalityConceptId.getModalityId();
			ConceptName modalityConceptName = Context.getConceptService()
					.getConcept(modalityConceptIdInteger)
					.getName();
			modalityConceptNameList.add(modalityConceptName);
			
		}
		
		final List<RadiologyStudyList> studyListFromDb = radiologyservice.getAllStudy();
		ArrayList<ConceptName> studyConceptNameList = new ArrayList();
		for (RadiologyStudyList studyConceptId : studyListFromDb) {
			int studyConceptIdInteger = studyConceptId.getStudyConceptId();
			ConceptName studyConceptName = Context.getConceptService()
					.getConcept(studyConceptIdInteger)
					.getName();
			studyConceptNameList.add(studyConceptName);
			
			System.out.println("Study name " + studyConceptName);
			
		}
		
		ArrayList<ConceptName> diagnosisConceptNameList = new ArrayList();
		ConceptClass diagnosisConcept = Context.getConceptService()
				.getConceptClassByName("Diagnosis");
		String diagnosislist = Context.getConceptService()
				.getConceptsByClass(diagnosisConcept)
				.toString();
		String diagnosislisttrim = diagnosislist.substring(1, diagnosislist.length() - 1)
				.trim();
		List<String> diagnosisnewlist = new ArrayList<String>(Arrays.asList(diagnosislisttrim.split(",")));
		for (String diagnosisString : diagnosisnewlist) {
			int diagnosisToInt = Integer.parseInt(diagnosisString.trim());
			ConceptName diagnosisConceptName = Context.getConceptService()
					.getConcept(diagnosisToInt)
					.getName();
			diagnosisConceptNameList.add(diagnosisConceptName);
		}
		
		model.addAttribute("urgencies", urgencies);
		model.addAttribute("diagnosislist", diagnosisConceptNameList);
		model.addAttribute("studyConceptNameList", studyConceptNameList);
		model.addAttribute("modalityConceptNameList", modalityConceptNameList);
		model.addAttribute("performedStatuses", performedStatuses);
		model.addAttribute("returnUrl", returnUrl);
		
		List<RadiologyOrder> radiologyOrders = getCompletedRadiologyOrdersByPatient(patient);
		
		System.out.println("length LLLLLLLLLLLLL " + radiologyOrders.size());
		
		model.put("radiologyOrders", radiologyOrders);
		
		model.addAttribute("patient", patient);
		model.addAttribute("returnUrl", returnUrl);
		
	}
	
	public void getRadiologyOrderForm(FragmentModel model) {
		
		System.out.println("FFFFFFFFFFFFFFFFFFFFFFFFFFFFSADADASDASASD");
		ModelAndView mav = new ModelAndView("radiology/radiologyOrderAll.page");
		System.out.println("ORDER SAVEDCSDSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSS");
		
	}
	
	public List<RadiologyOrder> getCompletedRadiologyOrdersByPatient(Patient p) {
		System.out.println("getLabOrdersByPatient");
		Vector<RadiologyOrder> radiologyOrders = new Vector<RadiologyOrder>();
		
		List<Order> orders = Context.getOrderService()
				.getAllOrdersByPatient(p);
		
		int testOrderTypeId = Context.getOrderService()
				.getOrderTypeByName("Radiology Order")
				.getOrderTypeId();
		
		RadiologyOrder radiologyOrder;
		for (Order order : orders) {
			// if (order.getOrderType().getOrderTypeId() == 3) { OrderType ot = new OrderType();
			if (order.getOrderType()
					.getOrderTypeId() == testOrderTypeId) {
				
				radiologyOrder = Context.getService(RadiologyService.class)
						.getRadiologyOrderByOrderId(order.getOrderId());
				
				if (radiologyOrder.isCompleted()) {
					radiologyOrders.add(radiologyOrder);
					
				}
				
			}
		}
		return radiologyOrders;
	}
	
}

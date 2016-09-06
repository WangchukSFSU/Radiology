/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package org.openmrs.module.radiology.fragment.controller;

import java.util.ArrayList;
import java.util.List;
import java.util.Vector;
import org.openmrs.Order;
import org.openmrs.Patient;
import org.openmrs.api.context.Context;
import org.openmrs.module.radiology.RadiologyOrder;
import org.openmrs.module.radiology.RadiologyService;
import org.openmrs.module.radiology.RadiologyStudyList;
import org.openmrs.ui.framework.fragment.FragmentModel;
import org.springframework.web.bind.annotation.RequestParam;

/**
 * @author youdon
 */
public class RadiologistInProgressOrderFragmentController {
	
	public void controller(FragmentModel model, @RequestParam(value = "returnUrl", required = false) String returnUrl,
			@RequestParam(value = "patientId", required = false) Patient patient) {
		
		RadiologyService radiologyservice = Context.getService(RadiologyService.class);
		List<RadiologyStudyList> studyListFromDb = radiologyservice.getAllStudy();
		
		List<RadiologyOrder> inProgressRadiologyOrders = getInProgressRadiologyOrdersByPatient();
		
		System.out.println("length LLLLLLLLLLLLL " + inProgressRadiologyOrders.size());
		
		model.put("inProgressRadiologyOrders", inProgressRadiologyOrders);
		model.put("studyListFromDb", studyListFromDb);
		model.addAttribute("patient", patient);
		model.addAttribute("returnUrl", returnUrl);
	}
	
	public List<RadiologyOrder> getInProgressRadiologyOrdersByPatient() {
		System.out.println("getLabOrdersByPatient");
		Vector<RadiologyOrder> radiologyOrders = new Vector<RadiologyOrder>();
		
		List<RadiologyOrder> orders = Context.getService(RadiologyService.class)
				.getAllRadiologyOrder();
		
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
				
				if (radiologyOrder.isInProgress()) {
					radiologyOrders.add(radiologyOrder);
					
				}
				
			}
		}
		return radiologyOrders;
	}
	
}

/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package org.openmrs.module.radiology.fragment.controller;

import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.Vector;
import org.openmrs.Encounter;
import org.openmrs.Order;
import org.openmrs.api.ConceptService;
import org.openmrs.api.context.Context;
import org.openmrs.module.radiology.PerformedProcedureStepStatus;
import org.openmrs.module.radiology.RadiologyOrder;
import org.openmrs.module.radiology.RadiologyOrderStatus;
import org.openmrs.module.radiology.RadiologyProperties;
import org.openmrs.module.radiology.RadiologyService;

import org.openmrs.module.radiology.Study;
import org.openmrs.ui.framework.SimpleObject;
import org.openmrs.ui.framework.UiUtils;
import org.openmrs.ui.framework.annotation.SpringBean;
import org.openmrs.ui.framework.fragment.FragmentModel;
import org.springframework.web.bind.annotation.RequestParam;

/**
 * @author youdon
 */
public class RadiologistInProgressOrderFragmentController {
	
	public void controller(FragmentModel model) {
		
		// System.out.println("PPPPPPPPP active " + patient);
		
		RadiologyService radiologyservice = Context.getService(RadiologyService.class);
		
		List<RadiologyOrder> inProgressRadiologyOrders = getInProgressRadiologyOrdersByPatient();
		
		System.out.println("length LLLLLLLLLLLLL " + inProgressRadiologyOrders.size());
		
		String aap = getDicomViewerUrladdress();
		String domain = "http://localhost:8080/openmrs/htmlformentryui/htmlform/enterHtmlFormWithStandardUi.page?patientId=";
		String visitform = "&visitId=&formUuid=";
		String returnurl = "&returnUrl=/openmrs/radiology/sendFormMessage.page";
		
		model.addAttribute("domain", domain);
		model.addAttribute("visitform", visitform);
		model.addAttribute("returnurl", returnurl);
		
		model.addAttribute("dicomViewerUrladdress", aap);
		model.put("inProgressRadiologyOrders", inProgressRadiologyOrders);
		
	}
	
	private String getDicomViewerUrladdress() {
		
		System.out.println("333");
		RadiologyProperties radiologyProperties = new RadiologyProperties();
		
		System.out.println("444");
		// String studyUidUrl = "studyUID=" + study.getStudyInstanceUid();
		// String patientIdUrl = "patientID=" + patient.getPatientIdentifier()
		// .getIdentifier();
		
		System.out.println("12232 radiologyProperties.getServersAddress()" + radiologyProperties.getServersAddress());
		System.out.println("12232 radiologyProperties.getServersPort()" + radiologyProperties.getServersPort());
		System.out.println("12232 radiologyProperties.getDicomViewerUrlBase()" + radiologyProperties.getDicomViewerUrlBase());
		System.out.println("12232 radiologyProperties.getDicomViewerLocalServerName()"
				+ radiologyProperties.getDicomViewerLocalServerName());
		// System.out.println("12232 studyUidUrl " + studyUidUrl);
		// System.out.println("12232 patientIdUrl" + patientIdUrl);
		
		return radiologyProperties.getServersAddress() + ":" + radiologyProperties.getServersPort()
				+ radiologyProperties.getDicomViewerUrlBase() + "?" + radiologyProperties.getDicomViewerLocalServerName();
		
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
				
				if (radiologyOrder.isCompleted()) {
					
					System.out.println("222222 " + radiologyOrder.getInstructions());
					radiologyOrders.add(radiologyOrder);
					
				}
				
			}
		}
		return radiologyOrders;
	}
	
	public List<SimpleObject> updateActiveOrders(@SpringBean("conceptService") ConceptService service, FragmentModel model,
			@RequestParam(value = "radiologyorderId") String radiologyorderId, UiUtils ui) {
		
		System.out.println("radiologyorderId");
		System.out.println("radiologyorderId" + radiologyorderId);
		
		List<RadiologyOrder> orders = Context.getService(RadiologyService.class)
				.getAllRadiologyOrder();
		
		int result = Integer.parseInt(radiologyorderId);
		
		List<Study> orderst = Context.getService(RadiologyService.class)
				.getAllStudyRadiologyOrder();
		
		RadiologyOrder radiologyOrder;
		
		for (Order order : orders) {
			
			if ((order.getOrderId()
					.toString().trim()).equals(radiologyorderId.trim())) {
				radiologyOrder = Context.getService(RadiologyService.class)
						.getRadiologyOrderByOrderId(order.getOrderId());
				
				Context.getService(RadiologyService.class)
						.updateStudyPerformedStatus(radiologyOrder.getStudy()
								.getStudyInstanceUid(), PerformedProcedureStepStatus.DONE);
				
				Context.getService(RadiologyService.class)
						.updateRadiologyStatusOrder(radiologyOrder.getStudy()
								.getStudyInstanceUid(), RadiologyOrderStatus.COMPLETED);
				
				Context.getService(RadiologyService.class)
						.updateObsCompletedDate(radiologyOrder.getStudy()
								.getStudyInstanceUid(), new Date().toString());
				
				List<Encounter> ampt = Context.getEncounterService()
						.getEncountersByPatient(order.getPatient());
				
				System.out.println("Jytryrtryryr enc.size() " + ampt.size());
				int encou = 0;
				int max = 0;
				for (Encounter ep : ampt) {
					if (ep.getEncounterId() > max) {
						max = ep.getEncounterId();
					}
					System.out.println("MKMK@#@#@##2412443424 encounter max " + max);
					
				}
				
				Context.getService(RadiologyService.class)
						.updateStudyEncounterId(radiologyOrder.getStudy()
								.getStudyInstanceUid(), max);
				
			}
			
		}
		
		ArrayList<RadiologyOrder> getRadiologyOrder = new ArrayList<RadiologyOrder>();
		
		List<RadiologyOrder> inProgressRadiologyOrders = getInProgressRadiologyOrdersByPatient();
		
		for (RadiologyOrder updateActiveOrder : inProgressRadiologyOrders) {
			getRadiologyOrder.add(updateActiveOrder);
		}
		
		String[] properties = new String[5];
		properties[0] = "orderId";
		properties[1] = "study.studyname";
		properties[2] = "dateCreated";
		properties[3] = "urgency";
		properties[4] = "patient.personName";
		
		return SimpleObject.fromCollection(getRadiologyOrder, ui, properties);
	}
}

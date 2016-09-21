/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package org.openmrs.module.radiology.fragment.controller;

import static java.lang.reflect.Array.set;
import java.util.ArrayList;
import org.openmrs.EncounterProvider;
import java.util.Calendar;
import java.util.Collection;
import java.util.Date;
import java.util.Iterator;
import java.util.List;
import java.util.Vector;
import org.openmrs.Encounter;
import org.openmrs.EncounterProvider;
import org.openmrs.Obs;
import org.openmrs.Order;
import org.openmrs.Patient;
import org.openmrs.api.context.Context;
import org.openmrs.module.radiology.PerformedProcedureStepStatus;
import org.openmrs.module.radiology.RadiologyEncounterMatcher;
import org.openmrs.module.radiology.RadiologyOrder;
import org.openmrs.module.radiology.RadiologyOrderStatus;
import org.openmrs.module.radiology.RadiologyProperties;
import org.openmrs.module.radiology.RadiologyService;
import org.openmrs.module.radiology.RadiologyStudyList;
import org.openmrs.module.radiology.ScheduledProcedureStepStatus;
import org.openmrs.module.radiology.Study;
import org.openmrs.ui.framework.fragment.FragmentModel;
import org.springframework.web.bind.annotation.RequestParam;

/**
 * @author youdon
 */
public class TechnicianInProgressOrderFragmentController {
	
	public void controller(FragmentModel model) {
		
		// System.out.println("PPPPPPPPP active " + patient);
		
		RadiologyService radiologyservice = Context.getService(RadiologyService.class);
		List<RadiologyStudyList> studyListFromDb = radiologyservice.getAllStudy();
		
		List<RadiologyOrder> inProgressRadiologyOrders = getInProgressRadiologyOrdersByPatient();
		
		System.out.println("length LLLLLLLLLLLLL " + inProgressRadiologyOrders.size());
		
		RadiologyOrder radiologyOrder = Context.getService(RadiologyService.class)
				.getRadiologyOrderByOrderId(62);
		
		System.out.println("test " + radiologyOrder.getStudy()
				.getPerformedStatus());
		System.out.println("test " + radiologyOrder.getStudy()
				.getRadiologyStatusOrder());
		System.out.println("test " + radiologyOrder.getStudy()
				.getRadiologyorderstatus());
		System.out.println("test " + radiologyOrder.getStudy()
				.getObsCompletedDate());
		
		String aap = getDicomViewerUrladdress();
		
		model.addAttribute("dicomViewerUrladdress", aap);
		model.put("inProgressRadiologyOrders", inProgressRadiologyOrders);
		model.put("studyListFromDb", studyListFromDb);
		
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
					radiologyOrders.add(radiologyOrder);
					
				}
				
			}
		}
		return radiologyOrders;
	}
	
	public void updateActiveOrders(FragmentModel model, @RequestParam(value = "radiologyorderId") String radiologyorderId) {
		
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
		
	}
}

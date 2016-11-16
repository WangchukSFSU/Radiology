/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package org.openmrs.module.radiology.fragment.controller;

import java.io.File;
import java.util.ArrayList;
import java.util.List;
import java.util.Vector;
import org.openmrs.Order;
import org.openmrs.api.ConceptService;
import org.openmrs.api.context.Context;
import org.openmrs.module.radiology.PerformedProcedureStepStatus;
import org.openmrs.module.radiology.RadiologyOrder;
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
public class TechnicianInProgressOrderFragmentController {
	
	public void controller(FragmentModel model) {
		
		// System.out.println("PPPPPPPPP active " + patient);
		
		RadiologyService radiologyservice = Context.getService(RadiologyService.class);
		
		List<RadiologyOrder> inProgressRadiologyOrders = getInProgressRadiologyOrdersByPatient();
		
		System.out.println("length LLLLLLLLLLLLL " + inProgressRadiologyOrders.size());
		
		String aap = getDicomViewerUrladdress();
		System.out.println("22222222222222 ");
		
		ArrayList<String> apo = listFiles("/home/youdon/Desktop/aaa");
		
		// radiologyservice.placeDicomInPacs("/home/youdon/Downloads/dicomImage/FluroWithDisplayShutter.dcm");
		System.out.println("444444444 ");
		model.addAttribute("apo", apo);
		
		model.addAttribute("dicomViewerUrladdress", aap);
		model.put("inProgressRadiologyOrders", inProgressRadiologyOrders);
		
	}
	
	public ArrayList listFiles(String directoryName) {
		ArrayList<String> aa = new ArrayList();
		File directory = new File(directoryName);
		// get all the files from a directory
		File[] fList = directory.listFiles();
		for (File file : fList) {
			if (file.isFile()) {
				if (file.getName()
						.equals(".DS_Store")) {
					
				} else {
					System.out.println("DSDSDSDDSSD " + file.getName());
					aa.add(file.getName());
				}
			}
		}
		return aa;
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
	
	public ArrayList getdicom() {
		// public List<SimpleObject> getdicom(@SpringBean("conceptService") ConceptService service, UiUtils ui) {
		ArrayList<String> aa = new ArrayList();
		File directory = new File("/home/youdon/Desktop/aaa");
		// get all the files from a directory
		File[] fList = directory.listFiles();
		for (File file : fList) {
			if (file.isFile()) {
				if (file.getName()
						.equals(".DS_Store")) {
					
				} else {
					System.out.println("88888888888888 " + file.getName());
					aa.add(file.getName());
				}
			}
		}
		
		return aa;
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
		
		System.out.println("333333333333333 ");
		RadiologyService radiologyservice = Context.getService(RadiologyService.class);
		// ArrayList<String> apo = listFiles("/home/youdon/Desktop/aaa");
		
		radiologyservice.placeDicomInPacs("/home/youdon/Desktop/aaa");
		System.out.println("4444477777777777777 ");
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
								.getStudyInstanceUid(), PerformedProcedureStepStatus.COMPLETED);
			}
		}
		
		ArrayList<RadiologyOrder> getRadiologyOrder = new ArrayList<RadiologyOrder>();
		
		List<RadiologyOrder> inProgressRadiologyOrders = getInProgressRadiologyOrdersByPatient();
		
		for (RadiologyOrder updateActiveOrder : inProgressRadiologyOrders) {
			getRadiologyOrder.add(updateActiveOrder);
		}
		String[] properties = new String[4];
		properties[0] = "orderId";
		properties[1] = "study.studyname";
		properties[2] = "dateCreated";
		properties[3] = "urgency";
		
		return SimpleObject.fromCollection(getRadiologyOrder, ui, properties);
	}
	
}

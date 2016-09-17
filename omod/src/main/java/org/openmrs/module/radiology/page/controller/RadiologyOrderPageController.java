/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package org.openmrs.module.radiology.page.controller;

import java.text.DateFormat;
import java.text.ParseException;
import java.text.SimpleDateFormat;
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
import org.openmrs.Obs;
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
import org.openmrs.module.radiology.Study;
import org.openmrs.ui.framework.fragment.FragmentModel;
import org.openmrs.ui.framework.page.PageModel;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;

public class RadiologyOrderPageController {
	
	public void controller(PageModel model, @RequestParam(value = "returnUrl", required = false) String returnUrl,
			@RequestParam(value = "patientId", required = false) Patient patient) throws ParseException {
		
		String aa = Context.getAdministrationService()
				.getGlobalProperty(RadiologyConstants.GP_RADIOLOGY_CONCEPT_CLASSES);
		System.out.println("AAAAA" + aa);
		
		DateFormat dateFormat = new SimpleDateFormat("MM/dd/yyyy");
		Date date = new Date();
		String dd = dateFormat.format(date);
		Date sd = dateFormat.parse(dd);
		System.out.println("DATEETETETTETET " + sd);
		
		Map<String, String> performedStatuses = new HashMap<String, String>();
		for (PerformedProcedureStepStatus performedStatus : PerformedProcedureStepStatus.values()) {
			if (performedStatus.name()
					.equals("DONE")) {
				
			} else {
				performedStatuses.put(performedStatus.name(), performedStatus.name());
				System.out.println("list performned status " + performedStatus.name());
				
			}
		}
		
		model.addAttribute("performedStatuses", performedStatuses);
		
		List<RadiologyOrder> radiologyOrders = getCompletedRadiologyOrdersByPatient(patient);
		
		System.out.println("length LLLLLLLLLLLLL " + radiologyOrders.size());
		System.out.println("patient patient PPPPPP " + patient.getUuid());
		
		List<String> urllist = new ArrayList<String>();
		for (RadiologyOrder ro : radiologyOrders) {
			Study study = ro.getStudy();
			System.out.println("122");
			urllist.add(getDicomViewerUrl(study, ro.getPatient()));
		}
		
		for (String ds : urllist) {
			System.out.println("STRRTRSTRR " + ds);
		}
		
		List<Obs> getObs = Context.getObsService()
				.getObservationsByPerson(patient);
		
		model.addAttribute("getObs", getObs);
		
		String aap = getDicomViewerUrladdress();
		model.addAttribute("dicomViewerUrl", aap);
		model.addAttribute("dicomViewerUrladdress", aap);
		model.put("radiologyOrders", radiologyOrders);
		
		model.addAttribute("patient", patient);
		// model.addAttribute("patientuuid", patient.getUuid());
		// model.addAttribute("patientfamilyname", patient.getFamilyName());
		// model.addAttribute("patientgivenname", patient.getGivenName());
		model.addAttribute("returnUrl", returnUrl);
		
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
	
	private String getDicomViewerUrl(Study study, Patient patient) {
		
		System.out.println("333");
		RadiologyProperties radiologyProperties = new RadiologyProperties();
		if (study.isOrderCompleted()) {
			System.out.println("444");
			String studyUidUrl = "studyUID=" + study.getStudyInstanceUid();
			String patientIdUrl = "patientID=" + patient.getPatientIdentifier()
					.getIdentifier();
			
			System.out.println("12232 radiologyProperties.getServersAddress()" + radiologyProperties.getServersAddress());
			System.out.println("12232 radiologyProperties.getServersPort()" + radiologyProperties.getServersPort());
			System.out.println("12232 radiologyProperties.getDicomViewerUrlBase()"
					+ radiologyProperties.getDicomViewerUrlBase());
			System.out.println("12232 radiologyProperties.getDicomViewerLocalServerName()"
					+ radiologyProperties.getDicomViewerLocalServerName());
			System.out.println("12232 studyUidUrl " + studyUidUrl);
			System.out.println("12232 patientIdUrl" + patientIdUrl);
			
			return radiologyProperties.getServersAddress() + ":" + radiologyProperties.getServersPort()
					+ radiologyProperties.getDicomViewerUrlBase() + "?"
					+ radiologyProperties.getDicomViewerLocalServerName();
		} else {
			return null;
		}
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
				
				if (radiologyOrder.isOrderCompleted()) {
					radiologyOrders.add(radiologyOrder);
					
				}
				
			}
		}
		return radiologyOrders;
	}
	
}

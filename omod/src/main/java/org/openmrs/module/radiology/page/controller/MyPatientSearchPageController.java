package org.openmrs.module.radiology.page.controller;

import java.util.List;
import java.util.Vector;
import org.openmrs.Order;
import org.openmrs.Patient;
import org.openmrs.api.context.Context;
import org.openmrs.module.radiology.RadiologyOrder;
import org.openmrs.module.radiology.RadiologyService;
import org.openmrs.ui.framework.fragment.FragmentModel;
import org.openmrs.ui.framework.page.PageModel;
import org.springframework.web.bind.annotation.RequestParam;

/**
 * Admin page, admin add modality, study and report
 * Pages does not allow to have ajax call therefore no any functionality added
 * 
 * @author tenzin
 */
public class MyPatientSearchPageController {
	
	public void controller(PageModel model, @RequestParam(value = "patientId", required = false) Patient patient) {
		
		System.out.println("PPPP " + patient);
		System.out.println("PPPP 111 " + patient.getPerson()
				.getPersonName());
		model.addAttribute("patient", patient);
		model.addAttribute("patientName", patient.getPerson()
				.getPersonName());
		List<RadiologyOrder> inProgressRadiologyOrders = null;
		/*
		 * List<Patient> allPatients = Context.getPatientService()
		 * .getAllPatients();
		 * for (Patient eachPatient : allPatients) {
		 * if (eachPatient.getPersonName()
		 * .toString()
		 * .trim()
		 * .equals(patient.getPerson()
		 * .getPersonName())) {
		 * System.out.println("YY23233 ");
		 * // get ScheduledStatus orders of the patient
		 * inProgressRadiologyOrders = getScheduledStatusRadiologyOrdersByPatient(eachPatient);
		 * }
		 * }
		 */
		
		inProgressRadiologyOrders = getScheduledStatusRadiologyOrdersByPatient(patient);
		model.put("inProgressRadiologyOrders", inProgressRadiologyOrders);
		
	}
	
	/**
	 * Method returns list of ScheduledStatus radiology orders of the patient
	 *
	 * @param patient
	 * @return ScheduledStatus radiology orders of the patient The Ajax call
	 *         requires a json result; properties string array elements are concepts
	 *         and properties indicate the Concept properties of interest; The
	 *         framework will build the json response when the method returns
	 */
	public List<RadiologyOrder> getScheduledStatusRadiologyOrdersByPatient(Patient patient) {
		
		Vector<RadiologyOrder> radiologyOrders = new Vector<RadiologyOrder>();
		// get all orders of the patient
		List<Order> orders = Context.getOrderService()
				.getAllOrdersByPatient(patient);
		int testOrderTypeId = Context.getOrderService()
				.getOrderTypeByName("Radiology Order")
				.getOrderTypeId();
		RadiologyOrder radiologyOrder;
		for (Order order : orders) {
			if (order.getOrderType()
					.getOrderTypeId() == testOrderTypeId) {
				radiologyOrder = Context.getService(RadiologyService.class)
						.getRadiologyOrderByOrderId(order.getOrderId());
				
				// get all orders of scheduled status
				if ((radiologyOrder.getStudy()
						.getScheduledStatus() == radiologyOrder.getStudy()
						.getScheduledStatus().SCHEDULED)) {
					
					radiologyOrders.add(radiologyOrder);
				}
			}
		}
		return radiologyOrders;
	}
	
}

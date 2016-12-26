package org.openmrs.module.radiology.fragment.controller;

import java.util.ArrayList;
import java.util.List;
import java.util.Vector;
import org.openmrs.ConceptClass;
import org.openmrs.Order;
import org.openmrs.Patient;
import org.openmrs.api.ConceptService;
import org.openmrs.api.context.Context;
import org.openmrs.module.radiology.RadiologyOrder;
import org.openmrs.module.radiology.RadiologyService;
import org.openmrs.ui.framework.SimpleObject;
import org.openmrs.ui.framework.UiUtils;
import org.openmrs.ui.framework.annotation.SpringBean;
import org.openmrs.ui.framework.fragment.FragmentModel;
import org.springframework.web.bind.annotation.RequestParam;

/**
 * Technician make sure the Patient Order Detail is available before taking picture
 * Find Patient Order Detail
 *
 * @author tenzin
 */
public class ViewOrderDetailFragmentController {
	
	/**
	 * @param model
	 */
	public void controller(FragmentModel model) {
		
	}
	
	/**
	 * Auto complete feature for the patient
	 *
	 * @param query
	 * @param requireConceptClass
	 * @param service ConceptService
	 * @param ui UiUtils
	 * @return matches patient
	 */
	public List<SimpleObject> getPatientAutocomplete(@RequestParam(value = "query", required = false) String query,
			@RequestParam(value = "conceptPatientClass", required = false) String requireConceptClass,
			@SpringBean("conceptService") ConceptService service, UiUtils ui) {
		
		List<ConceptClass> requireClasses = new ArrayList<ConceptClass>();
		
		if ((requireConceptClass == null) || (requireConceptClass.equals(""))) {
			requireClasses = null;
		} else {
			for (ConceptClass cl : service.getAllConceptClasses()) {
				if (requireConceptClass.equals(cl.getName())) {
					requireClasses.add(cl);
					System.out.println("Concept Class Name Found: " + cl.getName());
					break;
				}
			}
		}
		
		// the following will return at most 2 matches
		List<Patient> results = Context.getPatientService()
				.getPatients(query, null, null, false, 0, 2);
		
		List<Patient> names = new ArrayList<Patient>();
		for (Patient con : results) {
			con.getBirthdate();
			names.add(con); // con.getConcept().getName().getName()
		}
		/*
		 * The Ajax call requires a json result;
		 * names are concepts and properties indicate the Concept properties of interest;
		 * The framework will build the json response when the method returns
		 */
		// properties selected from patient
		String[] properties = new String[5];
		properties[0] = "personName";
		properties[1] = "patientIdentifier.Identifier";
		properties[2] = "gender";
		properties[3] = "age";
		properties[4] = "birthdate";
		
		return SimpleObject.fromCollection(names, ui, properties);
	}
	
	/**
	 * Find patient orders
	 * 
	 * @param service ConceptService
	 * @param model FragmentModel
	 * @param ui UiUtils
	 * @param patientName
	 * @return patient order details
	 */
	public List<SimpleObject> getPatientOrderDetails(@SpringBean("conceptService") ConceptService service,
			FragmentModel model, UiUtils ui, @RequestParam(value = "patientId", required = false) String patientName) {
		List<Patient> allPatients = Context.getPatientService()
				.getAllPatients();
		List<RadiologyOrder> inProgressRadiologyOrders = null;
		for (Patient eachPatient : allPatients) {
			if (eachPatient.getPersonName()
					.toString()
					.trim()
					.equals(patientName.trim())) {
				
				// get ScheduledStatus orders of the patient
				inProgressRadiologyOrders = getScheduledStatusRadiologyOrdersByPatient(eachPatient);
				
			}
		}
		
		// properties selected from orders
		String[] properties = new String[13];
		properties[0] = "patient.personName";
		properties[1] = "patient.patientIdentifier.Identifier";
		properties[2] = "study.studyname";
		properties[3] = "dateCreated";
		properties[4] = "urgency";
		properties[5] = "patient.gender";
		properties[6] = "orderId";
		properties[7] = "patient.age";
		properties[8] = "Orderer";
		properties[9] = "Orderdiagnosis";
		properties[10] = "Instructions";
		properties[11] = "study.studyInstanceUid";
		properties[12] = "patient.birthdate";
		
		return SimpleObject.fromCollection(inProgressRadiologyOrders, ui, properties);
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
	public List<RadiologyOrder> getScheduledStatusRadiologyOrdersByPatient(Patient p) {
		
		Vector<RadiologyOrder> radiologyOrders = new Vector<RadiologyOrder>();
		// get all orders of the patient
		List<Order> orders = Context.getOrderService()
				.getAllOrdersByPatient(p);
		int testOrderTypeId = Context.getOrderService()
				.getOrderTypeByName("Radiology Order")
				.getOrderTypeId();
		
		RadiologyOrder radiologyOrder;
		for (Order order : orders) {
			if (order.getOrderType()
					.getOrderTypeId() == testOrderTypeId) {
				radiologyOrder = Context.getService(RadiologyService.class)
						.getRadiologyOrderByOrderId(order.getOrderId());
				// get scehduled status orders
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

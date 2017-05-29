package org.openmrs.module.radiology.page.controller;

import java.io.File;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;
import java.util.Vector;
import org.openmrs.Concept;
import org.openmrs.ConceptSet;
import org.openmrs.Order;
import org.openmrs.Patient;
import org.openmrs.api.context.Context;
import org.openmrs.module.radiology.ModalityInit;
import org.openmrs.module.radiology.RadiologyOrder;
import org.openmrs.module.radiology.RadiologyService;
import org.openmrs.ui.framework.page.PageModel;
import org.springframework.web.bind.annotation.RequestParam;

/**
 * Technician view patient orders
 * 
 * @author tenzin
 */
public class MyPatientSearchPageController {
	
	public void controller(PageModel model, @RequestParam(value = "patientId", required = false) Patient patient)
			throws IOException {
		
		model.addAttribute("patient", patient);
		model.addAttribute("patientName", patient.getPerson()
				.getPersonName());
		List<RadiologyOrder> inProgressRadiologyOrders = getScheduledStatusRadiologyOrdersByPatient(patient);
		model.put("inProgressRadiologyOrders", inProgressRadiologyOrders);
		
		List<ModalityInit> modalityList = Context.getService(RadiologyService.class)
				.getAllModalityInit();
		
		String modalityIPAdd = null;
		String modalityRootPath = null;
		String modalityComplatePathRootFolder = null;
		for (RadiologyOrder createSubFolderForEachPatient : inProgressRadiologyOrders) {
			String cc = createSubFolderForEachPatient.getStudy()
					.getModality()
					.toString();
			for (ModalityInit eachModality : modalityList) {
				String dd = eachModality.getModalityName()
						.toString();
				if (cc.equals(dd)) {
					modalityIPAdd = eachModality.getModalityIP();
					modalityRootPath = eachModality.getModalityPath();
					modalityComplatePathRootFolder = File.separator + File.separator + modalityIPAdd
							+ System.getProperty("user.home");
					
					String fff = File.separator;
					// String path = System.getProperty("user.home") + File.separator + dicomFileRootFolder;
					String ospath = System.getProperty("os.name");
					System.out.println("ospath  " + ospath);
					
					System.out.println("modalityIPAdd  " + modalityIPAdd);
					System.out.println("modalityRootPath  " + modalityRootPath);
					System.out.println("modalityComplatePathRootFolder  " + modalityComplatePathRootFolder);
					
				}
			}
			
		}
		
	}
	
	/**
	 * Method returns list of ScheduledStatus radiology orders of the patient
	 *
	 * @param patient
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

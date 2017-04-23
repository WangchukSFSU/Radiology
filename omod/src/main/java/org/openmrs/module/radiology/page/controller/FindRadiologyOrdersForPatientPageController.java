package org.openmrs.module.radiology.page.controller;

import java.io.File;
import java.nio.file.Files;
import java.util.ArrayList;
import java.util.List;
import java.util.Vector;
import org.openmrs.Order;
import org.openmrs.api.context.Context;
import org.openmrs.module.radiology.RadiologyOrder;
import org.openmrs.module.radiology.RadiologyProperties;
import org.openmrs.module.radiology.RadiologyService;
import org.openmrs.ui.framework.page.PageModel;

/**
 * Technician make sure the Patient Order Detail is available before taking picture
 * 
 * @author tenzin
 */
public class FindRadiologyOrdersForPatientPageController {
	
	/**
	 * @param model PageModel
	 */
	public void controller(PageModel model) {
		// get all the active orders and create folders for each patient
		List<RadiologyOrder> inProgressRadiologyOrders = getInProgressRadiologyOrders();
		RadiologyProperties radiologyProperties = new RadiologyProperties();
		String dicomFileRootFolder = radiologyProperties.getDicomFileRootFolder();
		String path = System.getProperty("user.home") + File.separator + dicomFileRootFolder;
		File customDir = new File(path);
		boolean customDirExists = customDir.exists();
		if (customDirExists == true) {
			File[] folder = customDir.listFiles();
			for (File eachFolder : folder) {
				
				File[] files = eachFolder.listFiles();
				for (File eachFile : files) {
					eachFile.delete();
				}
				
			}
			for (File deleteFolder : folder) {
				deleteFolder.delete();
			}
			
		} else {
			
			new java.io.File(System.getProperty("user.home"), dicomFileRootFolder).mkdirs();
			
		}
		
		for (RadiologyOrder createSubFolderForEachPatient : inProgressRadiologyOrders) {
			String subDirectory = path + File.separator + createSubFolderForEachPatient.getPatient()
					.getPerson()
					.getPersonName() + createSubFolderForEachPatient.getPatient()
					.getPatientIdentifier();
			
			File subFolder = new File(subDirectory);
			if (!subFolder.exists()) {
				subFolder.mkdir();
				
			}
			
		}
		
	}
	
	/**
	 * Get all in progress radiology orders
	 * 
	 * @return in progress radiology orders
	 */
	public List<RadiologyOrder> getInProgressRadiologyOrders() {
		
		Vector<RadiologyOrder> inProgressRadiologyOrders = new Vector<RadiologyOrder>();
		// get all orders
		List<RadiologyOrder> allRadiologyOrders = Context.getService(RadiologyService.class)
				.getAllRadiologyOrder();
		
		int testOrderTypeId = Context.getOrderService()
				.getOrderTypeByName("Radiology Order")
				.getOrderTypeId();
		
		RadiologyOrder radiologyOrder;
		for (Order order : allRadiologyOrders) {
			if (order.getOrderType()
					.getOrderTypeId() == testOrderTypeId) {
				radiologyOrder = Context.getService(RadiologyService.class)
						.getRadiologyOrderByOrderId(order.getOrderId());
				// get all orders of scheduled status
				if ((radiologyOrder.getStudy()
						.getScheduledStatus() == radiologyOrder.getStudy()
						.getScheduledStatus().SCHEDULED) && (radiologyOrder.getStudy()
						.getPerformedStatus() != radiologyOrder.getStudy()
						.getPerformedStatus().REPORT_READY)) {
					inProgressRadiologyOrders.add(radiologyOrder);
					
				}
				
			}
		}
		return inProgressRadiologyOrders;
	}
	
}

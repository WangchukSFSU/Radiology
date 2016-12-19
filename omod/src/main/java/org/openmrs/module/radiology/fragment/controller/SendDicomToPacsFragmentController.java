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
import org.openmrs.module.radiology.RadiologyService;
import org.openmrs.module.radiology.ScheduledProcedureStepStatus;
import org.openmrs.ui.framework.SimpleObject;
import org.openmrs.ui.framework.UiUtils;
import org.openmrs.ui.framework.annotation.SpringBean;
import org.openmrs.ui.framework.fragment.FragmentModel;
import org.springframework.web.bind.annotation.RequestParam;

/**
 * Send dicom files to PACS when the modality software is not available
 * 
 * @author tenzin
 */
public class SendDicomToPacsFragmentController {
	
	/**
	 * Get all the dicom files after picture is taken
	 * 
	 * @param model
	 */
	public void controller(FragmentModel model) {
		// get all the active orders
		List<RadiologyOrder> inProgressRadiologyOrders = getInProgressRadiologyOrders();
		// Transfer all the dicom files modality station to local disk
		ArrayList<String> dicomeFiles = listFiles("/home/wangchuk/Desktop/DicomFromModality");
		model.addAttribute("dicomeFiles", dicomeFiles);
		model.put("inProgressRadiologyOrders", inProgressRadiologyOrders);
		
	}
	
	/**
	 * get the dicom files
	 * 
	 * @param directoryName
	 * @return arraylist of dicom files
	 */
	public ArrayList listFiles(String directoryName) {
		ArrayList<String> getDicomFiles = new ArrayList();
		File directory = new File(directoryName);
		// get all the files from a directory
		File[] fList = directory.listFiles();
		for (File file : fList) {
			if (file.isFile()) {
				if (!file.getName()
						.equals(".DS_Store")) {
					getDicomFiles.add(file.getName());
				}
			}
		}
		return getDicomFiles;
	}
	
	/**
	 * Get all the in progress radiology orders that needs to take picture
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
	
	/**
	 * Update active orders after the image is send to PACS
	 * The Ajax call requires a json result;
	 * properties string array elements are concepts and properties indicate the Concept properties of interest;
	 * The framework will build the json response when the method returns
	 * 
	 * @param service ConceptService
	 * @param model
	 * @param radiologyorderId order to update the order status
	 * @param ui UiUtils
	 * @return updated active orders
	 */
	public List<SimpleObject> updateActiveOrders(@SpringBean("conceptService") ConceptService service, FragmentModel model,
			@RequestParam(value = "radiologyorderId") String radiologyorderId, UiUtils ui) {
		
		RadiologyService radiologyService = Context.getService(RadiologyService.class);
		// send dicom to PACS
		radiologyService.placeDicomInPacs("/home/youdon/Desktop/aaa");
		// get all radiology orders
		List<RadiologyOrder> allRadiologyOrders = Context.getService(RadiologyService.class)
				.getAllRadiologyOrder();
		RadiologyOrder radiologyOrder;
		for (Order order : allRadiologyOrders) {
			if ((order.getOrderId()
					.toString().trim()).equals(radiologyorderId.trim())) {
				radiologyOrder = Context.getService(RadiologyService.class)
						.getRadiologyOrderByOrderId(order.getOrderId());
				// update order performed status to completed
				Context.getService(RadiologyService.class)
						.updateStudyPerformedStatus(radiologyOrder.getStudy()
								.getStudyInstanceUid(), PerformedProcedureStepStatus.COMPLETED);
				// update order scheduled status to started
				Context.getService(RadiologyService.class)
						.updateScheduledProcedureStepStatus(radiologyOrder.getStudy()
								.getStudyInstanceUid(), ScheduledProcedureStepStatus.STARTED);
			}
		}
		
		// get the updated active orders
		ArrayList<RadiologyOrder> getRadiologyOrder = new ArrayList<RadiologyOrder>();
		List<RadiologyOrder> inProgressRadiologyOrders = getInProgressRadiologyOrders();
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

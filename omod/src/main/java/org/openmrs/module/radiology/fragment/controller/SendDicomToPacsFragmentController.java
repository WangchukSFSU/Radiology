package org.openmrs.module.radiology.fragment.controller;

import java.io.File;
import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.List;
import java.util.Vector;
import javax.servlet.http.HttpServletRequest;
import org.apache.commons.io.FileUtils;
import org.openmrs.Order;
import org.openmrs.api.context.Context;
import org.openmrs.module.radiology.PerformedProcedureStepStatus;
import org.openmrs.module.radiology.RadiologyOrder;
import org.openmrs.module.radiology.RadiologyProperties;
import org.openmrs.module.radiology.RadiologyService;
import org.openmrs.module.radiology.ScheduledProcedureStepStatus;
import org.openmrs.ui.framework.fragment.FragmentModel;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.support.DefaultMultipartHttpServletRequest;

/**
 * Send dicom files to PACS when the modality software is not available
 *
 * @author tenzin
 */
public class SendDicomToPacsFragmentController {
	
	/**
	 * Get all the dicom files after picture is taken
	 *
	 * @param model FragmentModel
	 */
	public void controller(FragmentModel model) {
		
		// get all the active orders
		List<RadiologyOrder> inProgressRadiologyOrders = getInProgressRadiologyOrders();
		
		model.put("inProgressRadiologyOrders", inProgressRadiologyOrders);
		
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
	 * Update active orders after the image is send to PACS The Ajax call
	 * requires a json result; properties string array elements are concepts
	 * and properties indicate the Concept properties of interest; The
	 * framework will build the json response when the method returns
	 */
	public void sendDicomToPAC(HttpServletRequest request) throws IOException {
		
		RadiologyService radiologyService = Context.getService(RadiologyService.class);
		
		String page = request.getQueryString();
		String radioIdString = page.split("=")[2];
		int radioId = Integer.parseInt(page.split("=")[2]);
		
		List<MultipartFile> dicomImages = ((DefaultMultipartHttpServletRequest) request).getFiles("photos[]");
		
		RadiologyProperties radiologyProperties = new RadiologyProperties();
		// create temporary server folder for dicom file storage
		String dicomFileRootFolder = radiologyProperties.getGetDicomFileStorageLocation();
		String path = System.getProperty("user.home") + File.separator + dicomFileRootFolder;
		File customDir = new File(path);
		if (customDir.exists()) {} else {
			boolean success = new java.io.File(System.getProperty("user.home"), dicomFileRootFolder).mkdirs();
			
		}
		
		RadiologyOrder radiologyOrderId = radiologyService.getRadiologyOrderByOrderId(radioId);
		String subDirectory = path + File.separator + radiologyOrderId.getPatient()
				.getPerson()
				.getPersonName() + radiologyOrderId.getPatient()
				.getPatientIdentifier();
		
		File subFolder = new File(subDirectory);
		if (!subFolder.exists()) {
			subFolder.mkdir();
		}
		String UploadedFolder = subDirectory;
		for (int i = 0; i < dicomImages.size(); i++) {
			byte[] bytes = dicomImages.get(i)
					.getBytes();
			Path path2 = Paths.get(UploadedFolder + File.separator + dicomImages.get(i)
					.getOriginalFilename());
			Files.write(path2, bytes);
			// send dicom to pacs
			radiologyService.placeDicomInPacs(path2.toString());
		}
		
		FileUtils.deleteDirectory(subFolder);
		
		// update the radiology active orders
		List<RadiologyOrder> allRadiologyOrders = Context.getService(RadiologyService.class)
				.getAllRadiologyOrder();
		RadiologyOrder radiologyOrder;
		for (Order order : allRadiologyOrders) {
			if ((order.getOrderId()
					.toString().trim()).equals(radioIdString.trim())) {
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
		
	}
	
}

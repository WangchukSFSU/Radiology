package org.openmrs.module.radiology.fragment.controller;

import java.text.ParseException;
import java.util.ArrayList;
import java.util.Date;
import java.util.LinkedList;
import java.util.List;
import java.util.Properties;
import java.util.Vector;
import javax.mail.Message;
import javax.mail.MessagingException;
import javax.mail.PasswordAuthentication;
import javax.mail.Session;
import javax.mail.Transport;
import javax.mail.internet.InternetAddress;
import javax.mail.internet.MimeMessage;
import org.openmrs.Concept;
import org.openmrs.ConceptClass;
import org.openmrs.ConceptSearchResult;
import org.openmrs.ConceptSet;
import org.openmrs.Obs;
import org.openmrs.Order;
import org.openmrs.Patient;
import org.openmrs.Provider;
import org.openmrs.User;
import org.openmrs.api.ConceptService;
import org.openmrs.api.context.Context;
import org.openmrs.module.radiology.PerformedProcedureStepStatus;
import org.openmrs.module.radiology.RadiologyOrder;
import org.openmrs.module.radiology.RadiologyProperties;
import org.openmrs.module.radiology.RadiologyService;
import org.openmrs.module.radiology.ScheduledProcedureStepStatus;
import org.openmrs.module.radiology.Study;
import org.openmrs.ui.framework.SimpleObject;
import org.openmrs.ui.framework.UiUtils;
import org.openmrs.ui.framework.annotation.SpringBean;
import org.openmrs.ui.framework.fragment.FragmentModel;
import org.openmrs.ui.framework.page.PageModel;
import org.springframework.web.bind.annotation.RequestParam;

/**
 * Referring Physician create order, place order in database, PACS and view
 * completed order
 *
 * @author tenzin
 */
public class CreateViewRadiologyOrderFragmentController {
	
	/**
	 * Get the performed status report ready completed order. Get necessary
	 * patient, radiologist information for sending messages. Get the
	 * dicomViewerUrladdress for displaying images
	 *
	 * @param model FragmentModel
	 * @param returnUrl
	 * @param patient
	 */
	public void controller(FragmentModel model, @RequestParam(value = "returnUrl", required = false) String returnUrl,
			@RequestParam(value = "patientId", required = false) Patient patient) {
		
		// Priority of the order
		final List<String> urgencies = new LinkedList<String>();
		for (Order.Urgency urgency : Order.Urgency.values()) {
			if (!urgency.equals(Order.Urgency.ON_SCHEDULED_DATE)) {
				urgencies.add(urgency.name());
			}
		}
		
		model.addAttribute("urgencies", urgencies);
		model.addAttribute("returnUrl", returnUrl);
		// get all orders with report ready
		List<RadiologyOrder> radiologyOrdersCompletedReport = getRadiologyOrdersWithCompletedReportByPatient(patient);
		
		// check for dicom viwer avalability
		RadiologyProperties radiologyProperties = new RadiologyProperties();
		String oviyamStatus = radiologyProperties.getDicomViewerLocalServerName();
		String weasisStatus = radiologyProperties.getDicomViewerWeasisUrlBase();
		
		// get weasis url
		String dicomViewerWeasisUrladdress = getDicomViewerWeasisUrladdress();
		model.addAttribute("oviyamStatus", oviyamStatus);
		model.addAttribute("weasisStatus", weasisStatus);
		model.addAttribute("dicomViewerWeasisUrladdress", dicomViewerWeasisUrladdress);
		
		// get oviyum url
		String dicomViewerUrladdress = getDicomViewerUrladdress();
		model.addAttribute("dicomViewerUrladdress", dicomViewerUrladdress);
		
		model.put("radiologyOrders", radiologyOrdersCompletedReport);
		// contact patient and radiologist information
		String PatientName = patient.getNames()
				.toString();
		String patientName = PatientName.substring(1, PatientName.length() - 1);
		model.addAttribute("patient", patient);
		model.addAttribute("patientID", patient.getPatientId());
		model.addAttribute("patientname", patientName);
		model.addAttribute("patientid", patient.getId());
		model.addAttribute("radiologistemailaddress", "radiologist@gmail.com");
		model.addAttribute("subject", "Enquire Patient Observation");
		model.addAttribute("patientemailaddress", "patient@gmail.com");
		model.addAttribute("subjectPatient", "Recent visit information");
		
	}
	
	/**
	 * Oviyum url address
	 */
	private String getDicomViewerUrladdress() {
		RadiologyProperties radiologyProperties = new RadiologyProperties();
		return radiologyProperties.getServersAddress() + ":" + radiologyProperties.getServersPort()
				+ radiologyProperties.getDicomViewerUrlBase() + "?" + radiologyProperties.getDicomViewerLocalServerName();
		
	}
	
	/**
	 * get the weasis url address
	 */
	private String getDicomViewerWeasisUrladdress() {
		RadiologyProperties radiologyProperties = new RadiologyProperties();
		
		return radiologyProperties.getServersAddress() + ":" + radiologyProperties.getServersPort()
				+ radiologyProperties.getDicomViewerWeasisUrlBase() + "?";
		
	}
	
	/**
	 * Get all report ready status orders of the patient
	 *
	 * @param patient
	 * @return orders with report ready status for the patient The Ajax call
	 *         requires a json result; properties string array elements are concepts
	 *         and properties indicate the Concept properties of interest; The
	 *         framework will build the json response when the method returns
	 */
	public List<RadiologyOrder> getRadiologyOrdersWithCompletedReportByPatient(Patient patient) {
		
		Vector<RadiologyOrder> radiologyOrders = new Vector<RadiologyOrder>();
		// get all patient orders
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
				// get the orders having report ready status
				if (radiologyOrder.isReportReady()) {
					radiologyOrders.add(radiologyOrder);
					
				}
			}
		}
		return radiologyOrders;
	}
	
	/**
	 * Get all observations recorded for the report generated encounterId of
	 * the order
	 *
	 * @param service conceptService
	 * @param model FragmentModel
	 * @param encounterId report generated encounterId for the order
	 * @param ui UiUtils
	 * @return observations for the report generated encounterId The Ajax call
	 *         requires a json result; properties string array elements are concepts
	 *         and properties indicate the Concept properties of interest; The
	 *         framework will build the json response when the method returns
	 */
	public List<SimpleObject> getEncounterIdObs(@SpringBean("conceptService") ConceptService service, FragmentModel model,
			@RequestParam(value = "encounterId") String encounterId, UiUtils ui) {
		// get observations for the encounterId
		System.out.println("encounter id " + encounterId);
		List<Obs> encounterIdObs = Context.getObsService()
				.getObservations(encounterId);
		System.out.println("size size" + encounterIdObs.size());
		
		for (Obs aa : encounterIdObs) {
			System.out.println("encounter id location 11111" + aa.getLocation()
					.getAddress1());
			System.out.println("encounter id date 2222" + aa.getObsDatetime());
			System.out.println("encounter id date 33333" + aa.getCreator());
			
			System.out.println("encounter id location 44444" + aa.getEncounter()
					.getLocation());
			System.out.println("encounter id date 55555" + aa.getEncounter()
					.getEncounterDatetime());
			System.out.println("encounter id date 6666" + aa.getEncounter()
					.getProvider()
					.getPersonName());
			
			System.out.println("list obs " + aa.getConcept()
					.getDisplayString());
			System.out.println("list obs text" + aa.getValueText());
			
		}
		
		// properties selected for the obs
		String[] properties = new String[6];
		properties[0] = "Concept";
		properties[1] = "valueText";
		properties[2] = "valueNumeric";
		properties[3] = "Encounter.Location";
		properties[4] = "Encounter.EncounterDatetime";
		properties[5] = "Encounter.Provider.PersonName";
		
		return SimpleObject.fromCollection(encounterIdObs, ui, properties);
	}
	
	/**
	 * Get all in progress orders of the patient
	 *
	 * @param service conceptService
	 * @param model FragmentModel
	 * @param ui UiUtils
	 * @param patient
	 * @return in progress radiology orders of the patient The Ajax call
	 *         requires a json result; properties string array elements are concepts
	 *         and properties indicate the Concept properties of interest; The
	 *         framework will build the json response when the method returns
	 */
	public List<SimpleObject> getInProgressRadiologyOrders(@SpringBean("conceptService") ConceptService service,
			FragmentModel model, UiUtils ui, @RequestParam(value = "patientId", required = false) Patient patient) {
		// get in progress orders of the patient
		List<RadiologyOrder> inProgressRadiologyOrders = getInProgressRadiologyOrdersByPatient(patient);
		// properties selected from orders
		String[] properties = new String[5];
		properties[0] = "study.studyname";
		properties[1] = "dateCreated";
		properties[2] = "study.scheduledStatus";
		properties[3] = "study.performedStatus";
		properties[4] = "orderId";
		
		return SimpleObject.fromCollection(inProgressRadiologyOrders, ui, properties);
	}
	
	/**
	 * Get list of in progress radiology orders of the patient
	 *
	 * @param patient
	 * @return in progress radiology orders of the patient The Ajax call
	 *         requires a json result; properties string array elements are concepts
	 *         and properties indicate the Concept properties of interest; The
	 *         framework will build the json response when the method returns
	 */
	public List<RadiologyOrder> getInProgressRadiologyOrdersByPatient(Patient patient) {
		
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
				// get inprogress, completed and scehduled status orders
				if (radiologyOrder.isInProgress() || radiologyOrder.isCompleted() || (radiologyOrder.getStudy()
						.getScheduledStatus() == radiologyOrder.getStudy()
						.getScheduledStatus().SCHEDULED)) {
					radiologyOrders.add(radiologyOrder);
				}
			}
		}
		return radiologyOrders;
	}
	
	/**
	 * create radiology order and save in the database and in pacs. Update the
	 * radiology orders.
	 *
	 * @param service ConceptService
	 * @param model FragmentModel
	 * @param patient
	 * @param returnUrl
	 * @param study of the radiology order
	 * @param diagnosis of the radiology order
	 * @param instruction of the radiology order
	 * @param priority of the radiology order
	 * @param ui UiUtils
	 * @return completed report ready radiology orders The Ajax call requires a
	 *         json result; properties string array elements are concepts and
	 *         properties indicate the Concept properties of interest; The framework
	 *         will build the json response when the method returns
	 * @throws ParseException
	 */
	public List<SimpleObject> placeRadiologyOrder(@SpringBean("conceptService") ConceptService service, FragmentModel model,
			@RequestParam("patient") Patient patient, @RequestParam(value = "returnUrl", required = false) String returnUrl,
			@RequestParam(value = "study") String study, @RequestParam(value = "diagnosis") String diagnosis,
			@RequestParam(value = "instruction") String instruction, @RequestParam(value = "priority") String priority,
			UiUtils ui) throws ParseException {
		
		// create new radiology order
		RadiologyOrder radiologyOrder = new RadiologyOrder();
		// get the user
		User authenticatedUser = Context.getAuthenticatedUser();
		System.out.println("User setCreator " + authenticatedUser);
		// Provider provider = Context.getProviderService()
		// .getProvider(4);
		List<Provider> provs = Context.getProviderService()
				.getAllProviders();
		Provider provider = provs.get(0);
		
		// add data to new radiology order
		radiologyOrder.setCreator(authenticatedUser);
		radiologyOrder.setOrderer(provider);
		radiologyOrder.setConcept(Context.getConceptService()
				.getConcept(study));
		radiologyOrder.setPatient(patient);
		radiologyOrder.setDateCreated(new Date());
		radiologyOrder.setInstructions(instruction);
		radiologyOrder.setUrgency(Order.Urgency.valueOf(priority));	
		radiologyOrder.setOrderdiagnosis(diagnosis);
		RadiologyService radiologyservice = Context.getService(RadiologyService.class);
		// create new study
		Study newStudy = new Study();
		newStudy.setModality(study);
		newStudy.setStudyname(study);
		
		newStudy.setScheduledStatus(ScheduledProcedureStepStatus.SCHEDULED);
		radiologyOrder.setStudy(newStudy);
		radiologyOrder.setConcept(Context.getConceptService()
				.getConcept(Context.getConceptService()
						.getConcept(study)
						.getId()));
		// save in database
		RadiologyOrder saveOrder = radiologyservice.placeRadiologyOrder(radiologyOrder);
		// send to Pacs
		radiologyservice.placeRadiologyOrderInPacs(saveOrder);
		// get the updated completed report orders
		ArrayList<RadiologyOrder> getRadiologyOrder = new ArrayList<RadiologyOrder>();
		List<RadiologyOrder> completedReportRadiologyOrders = getRadiologyOrdersWithCompletedReportByPatient(patient);
		for (RadiologyOrder updateActiveOrder : completedReportRadiologyOrders) {
			getRadiologyOrder.add(updateActiveOrder);
		}
		
		String[] properties = new String[4];
		properties[0] = "orderId";
		properties[1] = "study.studyname";
		properties[2] = "dateCreated";
		properties[3] = "urgency";
		
		return SimpleObject.fromCollection(getRadiologyOrder, ui, properties);
		
	}
	
	/**
	 * Auto complete feature for the study
	 *
	 * @param query to get study concepts
	 * @param requireConceptClass study concept class
	 * @param service conceptService
	 * @param ui UiUtils
	 * @return 100 matches study concepts The Ajax call requires a json result;
	 *         properties string array elements are concepts and properties indicate
	 *         the Concept properties of interest; The framework will build the json
	 *         response when the method returns
	 */
	public List<SimpleObject> getStudyAutocomplete(@RequestParam(value = "query", required = false) String query,
			@RequestParam(value = "conceptStudyClass", required = false) String requireConceptClass,
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
		
		// the following will return at most 100 matches
		List<ConceptSearchResult> results = Context.getConceptService()
				.getConcepts(query, null, false, requireClasses, null, null, null, null, 0, 100);
		
		List<Concept> names = new ArrayList<Concept>();
		List<Concept> removedlist = new ArrayList<Concept>();
		ArrayList<Concept> modalityConceptToBeRemovedFromStudyConcept = getModalityConcept();
		for (ConceptSearchResult resultsConcept : results) {
			removedlist.add(resultsConcept.getConcept());
		}
		removedlist.removeAll(modalityConceptToBeRemovedFromStudyConcept);
		names.addAll(removedlist);
		
		String[] properties = new String[] { "name" };
		return SimpleObject.fromCollection(names, ui, properties);
	}
	
	public ArrayList<Concept> getModalityConcept() {
		ArrayList<Concept> modalityConcept = new ArrayList();
		List<ConceptSet> modalityConceptSet = Context.getConceptService()
				.getConceptSetsByConcept(Context.getConceptService()
						.getConcept(164068));
		for (ConceptSet addModalityConceptSet : modalityConceptSet) {
			Concept modalityConceptName = addModalityConceptSet.getConcept();
			modalityConcept.add(modalityConceptName);
		}
		return modalityConcept;
	}
	
	/**
	 * Auto complete feature for the diagnosis
	 *
	 * @param query to get diagnosis concepts
	 * @param requireConceptClass diagnosis concept class
	 * @param service ConceptService
	 * @param ui UiUtils
	 * @return 100 matches diagnosis concepts
	 */
	public List<SimpleObject> getDiagnosisAutocomplete(@RequestParam(value = "query", required = false) String query,
			@RequestParam(value = "conceptDiagnosisClass", required = false) String requireConceptClass,
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
		
		// the following will return at most 100 matches
		List<ConceptSearchResult> results = Context.getConceptService()
				.getConcepts(query, null, false, requireClasses, null, null, null, null, 0, 100);
		
		List<Concept> names = new ArrayList<Concept>();
		for (ConceptSearchResult con : results) {
			names.add(con.getConcept()); // con.getConcept().getName().getName()
			System.out.println("Concept: " + con.getConceptName());
		}
		/*
		 * The Ajax call requires a json result;
		 * names are concepts and properties indicate the Concept properties of interest;
		 * The framework will build the json response when the method returns
		 */
		String[] properties = new String[] { "name" };
		return SimpleObject.fromCollection(names, ui, properties);
	}
	
	/**
	 * Send email message to Radiologist if referring physician has questions
	 * about the observations.
	 *
	 * @param recipient email recipient
	 * @param subject email subject
	 * @param message email message
	 */
	public void contactRadiologist(@RequestParam(value = "recipient", required = false) String recipient,
			@RequestParam(value = "subject", required = false) String subject,
			@RequestParam(value = "message", required = false) String message) {
		
		// authentification username and password
		final String username = "johnDevRadio@gmail.com";
		final String password = "john1234";
		
		// set up smtp server
		Properties props = new Properties();
		props.put("mail.smtp.auth", "true");
		props.put("mail.smtp.starttls.enable", "true");
		props.put("mail.smtp.host", "smtp.gmail.com");
		props.put("mail.smtp.port", "587");
		Session session = Session.getInstance(props, new javax.mail.Authenticator() {
			
			// user authentication required
			protected PasswordAuthentication getPasswordAuthentication() {
				return new PasswordAuthentication(username, password);
			}
		});
		try {
			// Sender and receiver info with the message
			Message message1 = new MimeMessage(session);
			message1.setFrom(new InternetAddress("johnDevRadio@gmail.com"));
			message1.setRecipients(Message.RecipientType.TO, InternetAddress.parse(recipient));
			message1.setSubject(subject);
			message1.setText(message);
			Transport.send(message1);
		}
		catch (MessagingException e) {
			throw new RuntimeException(e);
		}
		
	}
	
	/**
	 * Send email message to patient
	 *
	 * @param recipient email
	 * @param subject of the email
	 * @param message content of the email
	 */
	public void contactPatient(@RequestParam(value = "recipient", required = false) String recipient,
			@RequestParam(value = "subject", required = false) String subject,
			@RequestParam(value = "message", required = false) String message) {
		
		final String username = "johnDevRadio@gmail.com";
		final String password = "john1234";
		
		// set up smtp server
		Properties props = new Properties();
		props.put("mail.smtp.auth", "true");
		props.put("mail.smtp.starttls.enable", "true");
		props.put("mail.smtp.host", "smtp.gmail.com");
		props.put("mail.smtp.port", "587");
		Session session = Session.getInstance(props, new javax.mail.Authenticator() {
			
			// user authentication required
			protected PasswordAuthentication getPasswordAuthentication() {
				return new PasswordAuthentication(username, password);
			}
		});
		try {
			// Sender and receiver info with the message
			Message message1 = new MimeMessage(session);
			message1.setFrom(new InternetAddress("johnDevRadio@gmail.com"));
			message1.setRecipients(Message.RecipientType.TO, InternetAddress.parse(recipient));
			message1.setSubject(subject);
			message1.setText(message);
			Transport.send(message1);
		}
		catch (MessagingException e) {
			throw new RuntimeException(e);
		}
		
	}
	
	public List<SimpleObject> deleteOrder(UiUtils ui, @RequestParam(value = "orderId", required = false) Integer orderId)
			throws Exception {
		
		// get the radiology order with the report saved encounter id
		RadiologyOrder deleteRadiologyOrder = Context.getService(RadiologyService.class)
				.getRadiologyOrderByOrderId(orderId);
		// update the performed status to report ready so it is available to referring physician
		Context.getService(RadiologyService.class)
				.updateStudyPerformedStatus(deleteRadiologyOrder.getStudy()
						.getStudyInstanceUid(), PerformedProcedureStepStatus.DISCONTINUED);
		Context.getService(RadiologyService.class)
				.updateScheduledProcedureStepStatus(deleteRadiologyOrder.getStudy()
						.getStudyInstanceUid(), ScheduledProcedureStepStatus.DEPARTED);
		
		RadiologyService radiologyService = Context.getService(RadiologyService.class);
		// radiologyService.discontinueRadiologyOrder(deleteRadiologyOrder, deleteRadiologyOrder.getOrderer(),
		// "delete order");
		
		radiologyService.discontinueRadiologyOrderInPacs(deleteRadiologyOrder);
		
		ArrayList<RadiologyOrder> deleteOrder = new ArrayList<RadiologyOrder>();
		deleteOrder.add(deleteRadiologyOrder);
		
		// properties selected from orders
		String[] properties = new String[5];
		properties[0] = "study.studyname";
		properties[1] = "dateCreated";
		properties[2] = "study.scheduledStatus";
		properties[3] = "study.performedStatus";
		properties[4] = "orderId";
		
		return SimpleObject.fromCollection(deleteOrder, ui, properties);
	}
	
}

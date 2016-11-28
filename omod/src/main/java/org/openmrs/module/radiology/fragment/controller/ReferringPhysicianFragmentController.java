/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package org.openmrs.module.radiology.fragment.controller;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.LinkedList;
import java.util.List;
import java.util.Map;
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
import org.openmrs.ConceptName;
import org.openmrs.ConceptSearchResult;
import org.openmrs.Form;
import org.openmrs.Obs;
import org.openmrs.Order;
import org.openmrs.Patient;
import org.openmrs.Provider;
import org.openmrs.User;
import org.openmrs.api.ConceptService;
import org.openmrs.api.context.Context;
import org.openmrs.module.radiology.PerformedProcedureStepStatus;
import org.openmrs.module.radiology.RadiologyOrder;
import org.openmrs.module.radiology.RadiologyOrderStatus;
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

public class ReferringPhysicianFragmentController {
	
	public void controller(PageModel model, @RequestParam(value = "returnUrl", required = false) String returnUrl,
			@RequestParam(value = "patientId", required = false) Patient patient) throws ParseException {
		
		final List<String> urgencies = new LinkedList<String>();
		for (Order.Urgency urgency : Order.Urgency.values()) {
			urgencies.add(urgency.name());
		}
		
		ArrayList<ConceptName> studyConceptNameList = new ArrayList();
		
		ConceptClass conceptName = Context.getConceptService()
				.getConceptClassByName("Radiology/Imaging Procedure");
		
		List<Concept> conceptNamelist = Context.getConceptService()
				.getConceptsByClass(conceptName);
		
		for (Concept eachConceptNamelist : conceptNamelist) {
			if (eachConceptNamelist.getDisplayString()
					.endsWith("modality")) {
				
			} else {
				ConceptName studyConceptName = eachConceptNamelist.getName();
				studyConceptNameList.add(studyConceptName);
			}
		}
		
		model.addAttribute("urgencies", urgencies);
		model.addAttribute("studyConceptNameList", studyConceptNameList);
		model.addAttribute("returnUrl", returnUrl);
		
		Map<String, String> performedStatuses = new HashMap<String, String>();
		for (PerformedProcedureStepStatus performedStatus : PerformedProcedureStepStatus.values()) {
			if (performedStatus.name()
					.equals("DONE")) {
				
			} else {
				performedStatuses.put(performedStatus.name(), performedStatus.name());
				
			}
		}
		
		model.addAttribute("performedStatuses", performedStatuses);
		
		List<RadiologyOrder> radiologyOrders = getCompletedRadiologyOrdersByPatient(patient);
		
		List<String> urllist = new ArrayList<String>();
		for (RadiologyOrder radiologyOrderDicomViewer : radiologyOrders) {
			Study study = radiologyOrderDicomViewer.getStudy();
			urllist.add(getDicomViewerUrl(study, radiologyOrderDicomViewer.getPatient()));
		}
		
		List<Obs> getObs = Context.getObsService()
				.getObservationsByPerson(patient);
		
		model.addAttribute("getObs", getObs);
		
		String dicomViewerUrladdress = getDicomViewerUrladdress();
		model.addAttribute("dicomViewerUrladdress", dicomViewerUrladdress);
		model.put("radiologyOrders", radiologyOrders);
		
		String PatientName = patient.getNames()
				.toString();
		String patientName = PatientName.substring(1, PatientName.length() - 1);
		model.addAttribute("patient", patient);
		model.addAttribute("patientID", patient.getPatientId());
		model.addAttribute("patientname", patientName);
		model.addAttribute("patientdob", patient.getBirthdate());
		model.addAttribute("patientid", patient.getId());
		model.addAttribute("radiologistemailaddress", "radiologistemailaddress@gmail.com");
		model.addAttribute("subject", "Enquire Patient Observation");
		model.addAttribute("patientemailaddress", "patientemailaddress@gmail.com");
		model.addAttribute("subjectPatient", "Recent visit information");
		
	}
	
	private String getDicomViewerUrladdress() {
		
		RadiologyProperties radiologyProperties = new RadiologyProperties();
		
		return radiologyProperties.getServersAddress() + ":" + radiologyProperties.getServersPort()
				+ radiologyProperties.getDicomViewerUrlBase() + "?" + radiologyProperties.getDicomViewerLocalServerName();
		
	}
	
	private String getDicomViewerUrl(Study study, Patient patient) {
		
		RadiologyProperties radiologyProperties = new RadiologyProperties();
		if (study.isOrderCompleted()) {
			
			String studyUidUrl = "studyUID=" + study.getStudyInstanceUid();
			String patientIdUrl = "patientID=" + patient.getPatientIdentifier()
					.getIdentifier();
			
			return radiologyProperties.getServersAddress() + ":" + radiologyProperties.getServersPort()
					+ radiologyProperties.getDicomViewerUrlBase() + "?"
					+ radiologyProperties.getDicomViewerLocalServerName();
		} else {
			return null;
		}
	}
	
	public List<RadiologyOrder> getCompletedRadiologyOrdersByPatient(Patient p) {
		
		Vector<RadiologyOrder> radiologyOrders = new Vector<RadiologyOrder>();
		
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
				
				if (radiologyOrder.isOrderCompleted()) {
					radiologyOrders.add(radiologyOrder);
					
				}
				
			}
		}
		return radiologyOrders;
	}
	
	// from addradiologyform
	public List<SimpleObject> placeRadiologyOrder(@SpringBean("conceptService") ConceptService service, FragmentModel model,
			@RequestParam("patient") Patient patient, @RequestParam(value = "returnUrl", required = false) String returnUrl,
			@RequestParam(value = "studyname") String studyname,
			@RequestParam(value = "diagnosisname") String diagnosisname,
			@RequestParam(value = "instructionname") String instructionname,
			@RequestParam(value = "priorityname") String priorityname, UiUtils ui) throws ParseException {
		
		RadiologyOrder radiologyOrder = new RadiologyOrder();
		
		User authenticatedUser = Context.getAuthenticatedUser();
		
		Provider provider = Context.getProviderService()
				.getProvider(authenticatedUser.getId());
		
		radiologyOrder.setCreator(authenticatedUser);
		radiologyOrder.setOrderer(provider);
		
		radiologyOrder.setConcept(Context.getConceptService()
				.getConcept(studyname));
		
		radiologyOrder.setPatient(patient);
		
		radiologyOrder.setDateCreated(new Date());
		radiologyOrder.setInstructions(instructionname);
		radiologyOrder.setUrgency(Order.Urgency.valueOf(priorityname));
		radiologyOrder.setOrderdiagnosis(diagnosisname);
		
		RadiologyService radiologyservice = Context.getService(RadiologyService.class);
		
		Study study = new Study();
		
		study.setModality(studyname);
		study.setStudyname(studyname);
		
		List<Form> studyreport = Context.getFormService()
				.getAllForms();
		
		for (Form searchform : studyreport) {
			
			String podspdoas = searchform.getName()
					.trim();
			
			if (podspdoas.startsWith("Generic")) {
				String arr[] = podspdoas.split(" ", 2);
				String genericWord = arr[0];
				String studyName = arr[1];
				if (study.getStudyname()
						.equals(studyName)) {
					study.setStudyGenericHTMLFormUUID(searchform.getUuid());
				}
			}
			
			if (study.getStudyname()
					.equals(podspdoas)) {
				study.setStudyHtmlFormUUID(searchform.getUuid());
				
			}
			
		}
		
		study.setPerformedStatus(PerformedProcedureStepStatus.IN_PROGRESS);
		study.setScheduledStatus(ScheduledProcedureStepStatus.SCHEDULED);
		study.setRadiologyStatusOrder(RadiologyOrderStatus.INPROGRESS);
		
		radiologyOrder.setStudy(study);
		
		radiologyOrder.setConcept(Context.getConceptService()
				.getConcept(Context.getConceptService()
						.getConcept(studyname)
						.getId()));
		
		RadiologyOrder saveOrder = radiologyservice.placeRadiologyOrder(radiologyOrder);
		
		if (radiologyservice.placeRadiologyOrderInPacs(saveOrder)) {}
		
		ArrayList<RadiologyOrder> getRadiologyOrder = new ArrayList<RadiologyOrder>();
		
		List<RadiologyOrder> inProgressRadiologyOrders = getCompletedRadiologyOrdersByPatient(patient);
		
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
	
	public List<SimpleObject> getStudyAutocomplete(@RequestParam(value = "query", required = false) String query,
			@RequestParam(value = "conceptStudyClass", required = false) String requireConceptClass,
			@SpringBean("conceptService") ConceptService service, UiUtils ui) {
		
		System.out.println("**********getSuggestions: query: " + query + "  requireConceptClass: " + requireConceptClass);
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
	
	public List<SimpleObject> getDiagnosisAutocomplete(@RequestParam(value = "query", required = false) String query,
			@RequestParam(value = "conceptDiagnosisClass", required = false) String requireConceptClass,
			@SpringBean("conceptService") ConceptService service, UiUtils ui) {
		
		System.out.println("**********getSuggestions: query: " + query + "  requireConceptClass: " + requireConceptClass);
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
	
	public void sendEmailToRadiologistA(@RequestParam(value = "recipient", required = false) String recipient,
			@RequestParam(value = "subject", required = false) String subject,
			@RequestParam(value = "message", required = false) String message) {
		
		final String username = "tibwangchuk@gmail.com";
		final String password = "TznWangchuk80";
		
		Properties props = new Properties();
		props.put("mail.smtp.auth", "true");
		props.put("mail.smtp.starttls.enable", "true");
		props.put("mail.smtp.host", "smtp.gmail.com");
		props.put("mail.smtp.port", "587");
		System.out.println("09090090900090");
		Session session = Session.getInstance(props, new javax.mail.Authenticator() {
			
			protected PasswordAuthentication getPasswordAuthentication() {
				return new PasswordAuthentication(username, password);
			}
		});
		try {
			
			Message message1 = new MimeMessage(session);
			message1.setFrom(new InternetAddress("tibwangchuk@gmail.com"));
			message1.setRecipients(Message.RecipientType.TO, InternetAddress.parse("tenzin.wangchuk@yahoo.com"));
			message1.setSubject("Testing Subject");
			message1.setText("Dear Mail Crawler," + "\n\n No spam to my email, please!");
			
			Transport.send(message1);
			
			System.out.println("Done");
			
		}
		catch (MessagingException e) {
			throw new RuntimeException(e);
		}
		
	}
	
	public void sendEmailToPatient(@RequestParam(value = "recipient", required = false) String recipient,
			@RequestParam(value = "subject", required = false) String subject,
			@RequestParam(value = "message", required = false) String message) {
		
		final String username = "tibwangchuk@gmail.com";
		final String password = "TznWangchuk80";
		
		Properties props = new Properties();
		props.put("mail.smtp.auth", "true");
		props.put("mail.smtp.starttls.enable", "true");
		props.put("mail.smtp.host", "smtp.gmail.com");
		props.put("mail.smtp.port", "587");
		
		Session session = Session.getInstance(props, new javax.mail.Authenticator() {
			
			protected PasswordAuthentication getPasswordAuthentication() {
				return new PasswordAuthentication(username, password);
			}
		});
		
		try {
			
			Message message1 = new MimeMessage(session);
			message1.setFrom(new InternetAddress("tibwangchuk@gmail.com"));
			message1.setRecipients(Message.RecipientType.TO, InternetAddress.parse("tenzin.wangchuk@yahoo.com"));
			message1.setSubject("Testing Subject");
			message1.setText("Dear Mail Crawler," + "\n\n No spam to my email, please!");
			
			Transport.send(message1);
			
			System.out.println("Done");
			
		}
		catch (MessagingException e) {
			throw new RuntimeException(e);
		}
		
	}
}

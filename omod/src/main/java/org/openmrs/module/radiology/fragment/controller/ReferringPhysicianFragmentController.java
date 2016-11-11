/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package org.openmrs.module.radiology.fragment.controller;

import java.text.DateFormat;
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
import org.openmrs.module.radiology.RadiologyConstants;
import org.openmrs.module.radiology.RadiologyOrder;
import org.openmrs.module.radiology.RadiologyOrderStatus;
import org.openmrs.module.radiology.RadiologyProperties;
import org.openmrs.module.radiology.RadiologyReportList;
import org.openmrs.module.radiology.RadiologyService;
import org.openmrs.module.radiology.RadiologyStudyList;
import org.openmrs.module.radiology.ScheduledProcedureStepStatus;
import org.openmrs.module.radiology.Study;
import org.openmrs.ui.framework.SimpleObject;
import org.openmrs.ui.framework.UiUtils;
import org.openmrs.ui.framework.annotation.SpringBean;
import org.openmrs.ui.framework.fragment.FragmentModel;
import org.openmrs.ui.framework.page.PageModel;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;

public class ReferringPhysicianFragmentController {
	
	static SimpleDateFormat sdf = new SimpleDateFormat("dd-MM-yyyy");
	
	private static int count = 9;
	
	public void controller(PageModel model, @RequestParam(value = "returnUrl", required = false) String returnUrl,
			@RequestParam(value = "patientId", required = false) Patient patient) throws ParseException {
		
		System.out.println("AddRadiologyOrderFormFragmentController" + patient.getFamilyName());
		System.out.println("AddRadiologyOrderFormFragmentController" + patient);
		System.out.println("AddRadiologyOrderFormFragmentController" + patient.getPerson());
		final List<String> urgencies = new LinkedList<String>();
		
		for (Order.Urgency urgency : Order.Urgency.values()) {
			System.out.println("EEEEEEEE" + urgency.name());
			urgencies.add(urgency.name());
		}
		
		ArrayList<ConceptName> studyConceptNameList = new ArrayList();
		
		ConceptClass mot = Context.getConceptService()
				.getConceptClassByName("Radiology/Imaging Procedure");
		
		List<Concept> mot_list = Context.getConceptService()
				.getConceptsByClass(mot);
		
		for (Concept ccc : mot_list) {
			if (ccc.getDisplayString()
					.endsWith("modality")) {
				
			} else {
				ConceptName studyConceptName = ccc.getName();
				studyConceptNameList.add(studyConceptName);
			}
		}
		
		model.addAttribute("urgencies", urgencies);
		// model.addAttribute("diagnosislist", modd);
		model.addAttribute("studyConceptNameList", studyConceptNameList);
		// model.addAttribute("modalityConceptNameList", modalityConceptNameList);
		
		model.addAttribute("patientIDDD", patient);
		model.addAttribute("returnUrl", returnUrl);
		
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
			// System.out.println("122");
			urllist.add(getDicomViewerUrl(study, ro.getPatient()));
		}
		
		for (String ds : urllist) {
			// System.out.println("STRRTRSTRR " + ds);
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
		
		String PatientName = patient.getNames()
				.toString();
		String patientName = PatientName.substring(1, PatientName.length() - 1);
		
		// System.out.println("returnUrl  returnUrl " + returnUrl);
		// System.out.println("patient  patient " + patient);
		model.addAttribute("returnUrl", returnUrl);
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
		
		// System.out.println("333");
		RadiologyProperties radiologyProperties = new RadiologyProperties();
		
		// System.out.println("444");
		// String studyUidUrl = "studyUID=" + study.getStudyInstanceUid();
		// String patientIdUrl = "patientID=" + patient.getPatientIdentifier()
		// .getIdentifier();
		
		// System.out.println("12232 studyUidUrl " + studyUidUrl);
		// System.out.println("12232 patientIdUrl" + patientIdUrl);
		
		return radiologyProperties.getServersAddress() + ":" + radiologyProperties.getServersPort()
				+ radiologyProperties.getDicomViewerUrlBase() + "?" + radiologyProperties.getDicomViewerLocalServerName();
		
	}
	
	private String getDicomViewerUrl(Study study, Patient patient) {
		
		// System.out.println("333");
		RadiologyProperties radiologyProperties = new RadiologyProperties();
		if (study.isOrderCompleted()) {
			// System.out.println("444");
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
	
	// from addradiologyform
	
	public List<SimpleObject> getStudyConceptsAnswerFromModality(FragmentModel model,
			@RequestParam(value = "modalityselected", required = false) String studyConceptone,
			@SpringBean("conceptService") ConceptService service, UiUtils ui) {
		
		System.out.println("0000000000000 PPPPPPPP " + studyConceptone);
		final List<RadiologyStudyList> studyListFromDb = Context.getService(RadiologyService.class)
				.getAllStudy();
		ArrayList<RadiologyStudyList> studyConceptNameList = new ArrayList();
		for (RadiologyStudyList studyConceptId : studyListFromDb) {
			int studyConceptIdInteger = studyConceptId.getStudyConceptId();
			ConceptName studyConceptName = Context.getConceptService()
					.getConcept(studyConceptIdInteger)
					.getName();
			System.out.println("3333333333333333333333  " + studyConceptName);
			String aop = studyConceptId.getModalityNameSaved();
			System.out.println("CN45454565665 PPPPPPPP " + studyConceptId.getModalityNameSaved());
			if ((studyConceptone).equals(studyConceptId.getModalityNameSaved())) {
				System.out.println("ZZZZZZZZZZZZZZZZZZZZZ MMMMMMM  ");
				studyConceptNameList.add(studyConceptId);
			}
			
			System.out.println("Study name LLLLLLLLL" + studyConceptName);
			
		}
		
		String[] properties = new String[3];
		properties[0] = "id";
		properties[1] = "studyName";
		properties[2] = "studyReporturl";
		return SimpleObject.fromCollection(studyConceptNameList, ui, properties);
	}
	
	public List<SimpleObject> placeRadiologyOrder(@SpringBean("conceptService") ConceptService service, FragmentModel model,
			@RequestParam("patient") Patient patient, @RequestParam(value = "returnUrl", required = false) String returnUrl,
			@RequestParam(value = "studyname") String studyname,
			@RequestParam(value = "diagnosisname") String diagnosisname,
			@RequestParam(value = "instructionname") String instructionname,
			@RequestParam(value = "priorityname") String priorityname, UiUtils ui) throws ParseException {
		
		System.out.println("PAPAPAPAPAPAPATITNTBET " + patient.getGivenName());
		System.out.println("PAPAPAPAPAPAPATITNTBET " + patient.getUuid());
		System.out.println("PAPAPAPAPAPAPATITNTBET " + patient.toString());
		System.out.println("PAPAPAPAPAPAPATITNTBET " + patient.getNames());
		RadiologyOrder radiologyOrder = new RadiologyOrder();
		
		User authenticatedUser = Context.getAuthenticatedUser();
		
		System.out.println("SSSSS TTTTT UUUUU DDDDD YYYYYYY " + studyname);
		System.out.println("USer  PPPPPPPPP " + authenticatedUser.getUsername());
		
		// Provider provider = new Provider();
		// provider.setProviderId(++count);
		// provider.setName(authenticatedUser.getUsername());
		// Provider provider =
		
		Provider provider = Context.getProviderService()
				.getProvider(authenticatedUser.getId());
		// .saveProvider(pp);
		// radiologyOrder.setOrderer(Context.getProviderService());
		System.out.println("KKKKKKKKKKKKK PPPPPPPPPPPPPP " + provider.getCreator());
		System.out.println("KKKKKKKKKKKKK PPPPPPPPPPPPPP " + provider.getCreator()
				.getName());
		System.out.println("KKKKKKKKKKKKK PPPPPPPPPPPPPP " + provider.getCreator()
				.getUsername());
		
		radiologyOrder.setCreator(authenticatedUser);
		radiologyOrder.setOrderer(provider);
		// Encounter ee = new Encounter();
		
		radiologyOrder.setPatient(patient);
		// radiologyOrder.getEncounter().getEncounterId();
		radiologyOrder.setDateCreated(new Date());
		radiologyOrder.setInstructions(instructionname);
		radiologyOrder.setUrgency(Order.Urgency.valueOf(priorityname));
		radiologyOrder.setOrderdiagnosis(diagnosisname);
		
		RadiologyService radiologyservice = Context.getService(RadiologyService.class);
		List<RadiologyStudyList> studyListSaved = radiologyservice.getAllStudy();
		Study study = new Study();
		
		study.setModality(studyname);
		study.setStudyname(studyname);
		study.setPatientName(patient.getPersonName()
				.toString());
		
		List<Form> studyreport = Context.getFormService()
				.getAllForms();
		System.out.println("1111");
		for (Form searchform : studyreport) {
			
			String podspdoas = searchform.getName()
					.trim();
			System.out.println("2222");
			System.out.println(" Form name " + podspdoas);
			System.out.println(" Study name " + study.getStudyname());
			
			if (study.getStudyname()
					.equals(podspdoas)) {
				System.out.println(" 6546546 " + patient.getGivenName());
				System.out.println("P 6576575675" + patient.getUuid());
				
				String domain = "http://localhost:8080/openmrs/htmlformentryui/htmlform/enterHtmlFormWithStandardUi.page?patientId=";
				String patientidurl = patient.getUuid();
				
				String visitform = "&visitId=&formUuid=";
				String formuuidurl = searchform.getUuid();
				// String returnurl = "&returnUrl=";
				String returnurl = "&returnUrl=/openmrs/radiology/sendFormMessage.page";
				
				String url = domain.concat(patientidurl)
						.concat(visitform)
						.concat(formuuidurl)
						.concat(returnurl);
				
				System.out.println("HYYEYYEYEYYEYEYEYE SAME SAM");
				study.setStudyreporturl(url);
				
				System.out.println("URL URL URL URL URL URL URL " + url);
				System.out.println("URL URL URL URL URL URL URL " + study.getStudyreporturl());
				
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
		
		System.out.println("ORder Concept " + Context.getConceptService()
				.getConcept(studyname)
				.getId());
		RadiologyOrder saveOrder = radiologyservice.placeRadiologyOrder(radiologyOrder);
		
		if (radiologyservice.placeRadiologyOrderInPacs(saveOrder)) {
			System.out.println("PACS PACS PACS PACS PACS");
		}
		
		System.out.println("JJJJJJJJJJJJJJJJJJJJ done");
		
		ArrayList<RadiologyOrder> getRadiologyOrder = new ArrayList<RadiologyOrder>();
		List<RadiologyStudyList> studyListFromDb = radiologyservice.getAllStudy();
		
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
		
		System.out.println("POST POST POST POST");
		System.out.println("POST POST POST POST recipient" + recipient);
		System.out.println("POST POST POST POST subject" + subject);
		System.out.println("POST POST POST POST message" + message);
		// return "redirect:radiology/radiologyOrder.page";
		
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
		System.out.println("7777777777777777777777777770");
		try {
			
			Message message1 = new MimeMessage(session);
			message1.setFrom(new InternetAddress("tibwangchuk@gmail.com"));
			System.out.println("33333333333333333333333");
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
		
		System.out.println("POST POST POST POST");
		System.out.println("POST POST POST POST recipient" + recipient);
		System.out.println("POST POST POST POST subject" + subject);
		System.out.println("POST POST POST POST message" + message);
		// return "redirect:radiology/radiologyOrder.page";
		
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

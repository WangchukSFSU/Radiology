/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package org.openmrs.module.radiology.fragment.controller;

import java.io.IOException;
import java.io.PrintWriter;
import java.io.StringWriter;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Locale;
import java.util.Map;
import java.util.Vector;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import org.apache.commons.lang.StringUtils;
import org.joda.time.DateMidnight;
import org.openmrs.Encounter;
import org.openmrs.Form;
import org.openmrs.Obs;
import org.openmrs.Order;
import org.openmrs.Patient;
import org.openmrs.Provider;
import org.openmrs.User;
import org.openmrs.Visit;
import org.openmrs.api.ConceptService;
import org.openmrs.api.FormService;
import org.openmrs.api.context.Context;
import org.openmrs.api.context.ContextAuthenticationException;
import org.openmrs.module.appframework.feature.FeatureToggleProperties;
import org.openmrs.module.appui.UiSessionContext;
import org.openmrs.module.emrapi.EmrApiProperties;
import org.openmrs.module.emrapi.adt.AdtService;
import org.openmrs.module.emrapi.adt.exception.EncounterDateAfterVisitStopDateException;
import org.openmrs.module.emrapi.adt.exception.EncounterDateBeforeVisitStartDateException;
import org.openmrs.module.emrapi.encounter.EncounterDomainWrapper;
import org.openmrs.module.emrapi.visit.VisitDomainWrapper;
import org.openmrs.module.htmlformentry.FormEntryContext;
import org.openmrs.module.htmlformentry.FormEntrySession;
import org.openmrs.module.htmlformentry.FormSubmissionError;
import org.openmrs.module.htmlformentry.HtmlForm;
import org.openmrs.module.htmlformentry.HtmlFormEntryService;
import org.openmrs.module.htmlformentry.HtmlFormEntryUtil;
import org.openmrs.module.htmlformentryui.HtmlFormUtil;
import org.openmrs.module.radiology.PerformedProcedureStepStatus;
import org.openmrs.module.radiology.RadiologyOrder;
import org.openmrs.module.radiology.RadiologyOrderStatus;
import org.openmrs.module.radiology.RadiologyProperties;
import org.openmrs.module.radiology.RadiologyService;

import org.openmrs.module.radiology.Study;
import org.openmrs.module.uicommons.UiCommonsConstants;
import org.openmrs.ui.framework.SimpleObject;
import org.openmrs.ui.framework.UiUtils;
import org.openmrs.ui.framework.annotation.FragmentParam;
import org.openmrs.ui.framework.annotation.SpringBean;
import org.openmrs.ui.framework.fragment.FragmentConfiguration;
import org.openmrs.ui.framework.fragment.FragmentModel;
import org.openmrs.ui.framework.resource.ResourceFactory;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.bind.annotation.RequestParam;

/**
 * @author youdon
 */
public class RadiologistInProgressOrderFragmentController extends BaseHtmlFormFragmentController {
	
	public void controller(
			FragmentConfiguration config,
			UiSessionContext sessionContext,
			UiUtils ui,
			@SpringBean("htmlFormEntryService") HtmlFormEntryService htmlFormEntryService,
			@SpringBean("adtService") AdtService adtService,
			@SpringBean("formService") FormService formService,
			@SpringBean("coreResourceFactory") ResourceFactory resourceFactory,
			@SpringBean("featureToggles") FeatureToggleProperties featureToggles,
			// @FragmentParam("patient") Patient patient,
			// @FragmentParam(value = "htmlForm", required = false) HtmlForm hf,
			// @FragmentParam(value = "htmlFormId", required = false) Integer htmlFormId,
			// @FragmentParam(value = "formId", required = false) Form form,
			// @FragmentParam(value = "formUuid", required = false) String formUuid,
			@FragmentParam(value = "definitionUiResource", required = false) String definitionUiResource,
			@FragmentParam(value = "encounter", required = false) Encounter encounter,
			@FragmentParam(value = "visit", required = false) Visit visit,
			@FragmentParam(value = "createVisit", required = false) Boolean createVisit,
			// @FragmentParam(value = "returnUrl", required = false) String returnUrl,
			@FragmentParam(value = "automaticValidation", defaultValue = "true") boolean automaticValidation,
			FragmentModel model, HttpSession httpSession) throws Exception {
		
		String returnUrl = "";
		// String returnUrl = "/openmrs/radiology/sendFormMessage.page";
		model.addAttribute("returnUrl", returnUrl);
		
		model.addAttribute("currentDate", (new DateMidnight()).toDate());
		
		List<RadiologyOrder> inProgressRadiologyOrders = getInProgressRadiologyOrdersByPatient();
		
		System.out.println("length LLLLLLLLLLLLL " + inProgressRadiologyOrders.size());
		
		String aap = getDicomViewerUrladdress();
		String domain = "http://localhost:8080/openmrs/htmlformentryui/htmlform/enterHtmlFormWithStandardUi.page?patientId=";
		String visitform = "&visitId=&formUuid=";
		String returnurl = "&returnUrl=/openmrs/radiology/sendFormMessage.page";
		
		model.addAttribute("dicomViewerUrladdress", aap);
		model.put("inProgressRadiologyOrders", inProgressRadiologyOrders);
		model.addAttribute("domain", domain);
		model.addAttribute("visitform", visitform);
		model.addAttribute("returnurl", returnurl);
		
		// form section
		
	}
	
	public List<SimpleObject> getPatientCompletedOrder(@SpringBean("conceptService") ConceptService service,
			FragmentModel model, @RequestParam(value = "patientId") Patient patientId, UiUtils ui) {
		
		System.out.println("getLabOrdersByPatient");
		ArrayList<RadiologyOrder> radiologyOrders = new ArrayList<RadiologyOrder>();
		
		List<Order> orders = Context.getOrderService()
				.getAllOrdersByPatient(patientId);
		
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
		String[] properties = new String[8];
		properties[0] = "orderer.name";
		properties[1] = "instructions";
		properties[2] = "Patient.PatientId";
		properties[3] = "orderdiagnosis";
		properties[4] = "study.studyname";
		properties[5] = "study.studyInstanceUid";
		properties[6] = "DateCreated";
		properties[7] = "study.OrderencounterId";
		
		return SimpleObject.fromCollection(radiologyOrders, ui, properties);
	}
	
	public List<SimpleObject> getUpdatedEncounterId(@SpringBean("conceptService") ConceptService service,
			FragmentModel model, @RequestParam(value = "radiologyorderId") Integer radiologyorderId, UiUtils ui) {
		
		System.out.println("PPPPPPPP");
		ArrayList<RadiologyOrder> radiologyOrders = new ArrayList<RadiologyOrder>();
		
		RadiologyOrder aaa = Context.getService(RadiologyService.class)
				.getRadiologyOrderByOrderId(radiologyorderId);
		radiologyOrders.add(aaa);
		System.out.println("Emncounter Order Id TTTTT " + aaa.getStudy()
				.getOrderencounterId());
		
		String[] properties = new String[1];
		
		properties[0] = "study.OrderencounterId";
		
		return SimpleObject.fromCollection(radiologyOrders, ui, properties);
	}
	
	public List<SimpleObject> getEncounterIdObs(@SpringBean("conceptService") ConceptService service, FragmentModel model,
			@RequestParam(value = "encounterId") String encounterId, UiUtils ui) {
		
		List<Obs> encounterIdObs = Context.getObsService()
				.getObservations(encounterId);
		for (Obs oob : encounterIdObs) {
			oob.getConcept()
					.getFullySpecifiedName(Locale.ENGLISH);
		}
		String[] properties = new String[2];
		
		properties[0] = "Concept";
		properties[1] = "valueText";
		
		return SimpleObject.fromCollection(encounterIdObs, ui, properties);
	}
	
	public List<SimpleObject> getRadiologyOrderDetail(@SpringBean("conceptService") ConceptService service,
			FragmentModel model, @RequestParam(value = "radiologyorderId") Integer radiologyorderId, UiUtils ui) {
		
		ArrayList<RadiologyOrder> radiologyOrders = new ArrayList<RadiologyOrder>();
		
		RadiologyOrder aaa = Context.getService(RadiologyService.class)
				.getRadiologyOrderByOrderId(radiologyorderId);
		radiologyOrders.add(aaa);
		
		System.out.println("Emncounter Order Id TTTTT " + aaa.getStudy()
				.getOrderencounterId());
		aaa.getOrderer();
		
		String[] properties = new String[12];
		
		properties[0] = "patient.personName";
		properties[1] = "patient.patientIdentifier";
		properties[2] = "study.studyname";
		properties[3] = "dateCreated";
		properties[4] = "urgency";
		properties[5] = "patient.patientIdentifier";
		properties[6] = "orderId";
		properties[7] = "study.OrderencounterId";
		properties[8] = "Orderer";
		properties[9] = "Orderdiagnosis";
		properties[10] = "Instructions";
		properties[11] = "study.studyInstanceUid";
		
		return SimpleObject.fromCollection(radiologyOrders, ui, properties);
	}
	
	public List<SimpleObject> CancelReportUpdate(@SpringBean("conceptService") ConceptService service, FragmentModel model,
			@RequestParam(value = "radiologyorderId") Integer radiologyorderId, UiUtils ui) {
		
		System.out.println("uuuuu");
		ArrayList<RadiologyOrder> radiologyOrders = new ArrayList<RadiologyOrder>();
		
		RadiologyOrder removeEncounterOnRadiologyOrder = Context.getService(RadiologyService.class)
				.getRadiologyOrderByOrderId(radiologyorderId);
		Context.getService(RadiologyService.class)
				.updateStudyEncounterId(removeEncounterOnRadiologyOrder.getStudy()
						.getStudyInstanceUid(), null);
		
		List<RadiologyOrder> updateInProgressRadiologyOrders = getInProgressRadiologyOrdersByPatient();
		
		for (RadiologyOrder updateRadiologyOrder : updateInProgressRadiologyOrders) {
			radiologyOrders.add(updateRadiologyOrder);
		}
		
		String[] properties = new String[8];
		properties[0] = "patient.personName";
		properties[1] = "patient.patientIdentifier";
		properties[2] = "study.studyname";
		properties[3] = "dateCreated";
		properties[4] = "urgency";
		properties[5] = "patient.patientIdentifier";
		properties[6] = "orderId";
		properties[7] = "study.OrderencounterId";
		
		return SimpleObject.fromCollection(radiologyOrders, ui, properties);
	}
	
	public List<SimpleObject> getForm(@SpringBean("conceptService") ConceptService service, FragmentModel model,
			@RequestParam(value = "radiologyorderId") String radiologyorderId,
			@SpringBean("htmlFormEntryService") HtmlFormEntryService htmlFormEntryService,
			@SpringBean("adtService") AdtService adtService, @SpringBean("formService") FormService formService,
			@SpringBean("coreResourceFactory") ResourceFactory resourceFactory,
			@SpringBean("featureToggles") FeatureToggleProperties featureToggles,
			// @FragmentParam(value = "definitionUiResource", required = false) String definitionUiResource,
			// @FragmentParam(value = "encounter", required = false) Encounter encounter,
			// @FragmentParam(value = "visit", required = false) Visit visit,
			// @FragmentParam(value = "createVisit", required = false) Boolean createVisit,
			// FragmentConfiguration config,
			UiSessionContext sessionContext,
			// @FragmentParam(value = "returnUrl", required = false) String returnUrl,
			// @FragmentParam(value = "automaticValidation", defaultValue = "true") boolean automaticValidation,
			HttpSession httpSession, UiUtils ui) throws IOException, Exception {
		
		String definitionUiResource = null;
		Encounter encounter = null;
		Visit visit = null;
		Boolean createVisit = false;
		boolean automaticValidation = true;
		Form form = null;
		ArrayList<FormEntrySession> command = new ArrayList<FormEntrySession>();
		ArrayList<Form> formlist = new ArrayList<Form>();
		
		int radiologyorderIdInteger = Integer.parseInt(radiologyorderId);
		
		System.out.println("radiologyorderId " + radiologyorderIdInteger);
		RadiologyService radiologyservice = Context.getService(RadiologyService.class);
		RadiologyOrder getRadiologyOrder = radiologyservice.getRadiologyOrderByOrderId(radiologyorderIdInteger);
		
		System.out.println("radiology Order " + getRadiologyOrder);
		System.out.println("study  " + getRadiologyOrder.getStudy());
		System.out.println("study form encounter Id " + getRadiologyOrder.getStudy()
				.getOrderencounterId());
		
		if (getRadiologyOrder.getStudy()
				.getOrderencounterId() == null) {
			System.out.println("encounter form is null");
			encounter = null;
			form = Context.getFormService()
					.getFormByUuid(getRadiologyOrder.getStudy()
							.getStudyHtmlFormUUID());
			Form genericform = Context.getFormService()
					.getFormByUuid(getRadiologyOrder.getStudy()
							.getStudyGenericHTMLFormUUID());
			formlist.add(form);
			formlist.add(genericform);
		} else {
			System.out.println("encounter form not not null");
			encounter = Context.getEncounterService()
					.getEncounter(getRadiologyOrder.getStudy()
							.getOrderencounterId());
			
			form = encounter.getForm();
			
			formlist.add(form);
		}
		String returnUrl = "";
		// String returnUrl = "/openmrs/radiology/sendFormMessage.page";
		
		for (Form eachform : formlist) {
			
			HtmlForm hf = HtmlFormEntryUtil.getService()
					.getHtmlFormByForm(eachform);
			Patient patient = getRadiologyOrder.getPatient();
			Integer htmlFormId = eachform.getFormId();
			String formUuid = eachform.getUuid();
			
			System.out.println("form " + patient);
			// config.require("patient", "htmlForm | htmlFormId | formId | formUuid | definitionUiResource | encounter");
			
			System.out.println("form 11" + hf);
			
			if (hf == null) {
				if (htmlFormId != null) {
					hf = htmlFormEntryService.getHtmlForm(htmlFormId);
				} else if (eachform != null) {
					hf = htmlFormEntryService.getHtmlFormByForm(eachform);
				} else if (formUuid != null) {
					eachform = formService.getFormByUuid(formUuid);
					hf = htmlFormEntryService.getHtmlFormByForm(eachform);
				} else if (StringUtils.isNotBlank(definitionUiResource)) {
					hf = HtmlFormUtil.getHtmlFormFromUiResource(resourceFactory, formService, htmlFormEntryService,
						definitionUiResource);
				}
			}
			if (hf == null && encounter != null) {
				eachform = encounter.getForm();
				if (form == null) {
					throw new IllegalArgumentException(
							"Cannot view a form-less encounter unless you specify which form to use");
				}
				hf = HtmlFormEntryUtil.getService()
						.getHtmlFormByForm(encounter.getForm());
				if (hf == null)
					throw new IllegalArgumentException("The form for the specified encounter (" + encounter.getForm()
							+ ") does not have an HtmlForm associated with it");
			}
			if (hf == null)
				throw new RuntimeException("Could not find HTML Form");
			
			// the code below doesn't handle the HFFS case where you might want to _add_ data to an existing encounter
			FormEntrySession fes;
			if (encounter != null) {
				fes = new FormEntrySession(patient, encounter, FormEntryContext.Mode.EDIT, hf, null, httpSession,
						automaticValidation, !automaticValidation);
			} else {
				System.out.println("forrrrrr");
				fes = new FormEntrySession(patient, hf, FormEntryContext.Mode.ENTER, null, httpSession, automaticValidation,
						!automaticValidation);
			}
			
			System.out.println("form ooo " + fes.getPatient());
			// fes.getPatient().setPersonId(htmlFormId);
			
			VisitDomainWrapper visitDomainWrapper = getVisitDomainWrapper(visit, encounter, adtService);
			setupVelocityContext(fes, visitDomainWrapper, ui, sessionContext, featureToggles);
			setupFormEntrySession(fes, visitDomainWrapper, ui, sessionContext, returnUrl);
			// setupModel(model, fes, visitDomainWrapper, createVisit);
			
			fes.setReturnUrl(returnUrl);
			
			command.add(fes);
			
		}
		
		String[] properties = new String[7];
		properties[0] = "EncounterModifiedTimestamp";
		properties[1] = "HtmlToDisplay";
		properties[2] = "Patient.PatientId";
		properties[3] = "HtmlFormId";
		properties[4] = "FormModifiedTimestamp";
		properties[5] = "ReturnUrl";
		properties[6] = "FormName";
		
		return SimpleObject.fromCollection(command, ui, properties);
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
	
	public List<RadiologyOrder> getInProgressRadiologyOrdersByPatient() {
		System.out.println("getLabOrdersByPatient");
		Vector<RadiologyOrder> radiologyOrders = new Vector<RadiologyOrder>();
		
		List<RadiologyOrder> orders = Context.getService(RadiologyService.class)
				.getAllRadiologyOrder();
		
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
				
				if (radiologyOrder.isCompleted()) {
					
					System.out.println("222222 " + radiologyOrder.getInstructions());
					radiologyOrders.add(radiologyOrder);
					
				}
				
			}
		}
		return radiologyOrders;
	}
	
	public List<SimpleObject> updateActiveOrders(@SpringBean("conceptService") ConceptService service, FragmentModel model,
			@RequestParam(value = "radiologyorderId") String radiologyorderId, UiUtils ui) {
		
		System.out.println("radiologyorderId");
		System.out.println("radiologyorderId" + radiologyorderId);
		
		List<RadiologyOrder> orders = Context.getService(RadiologyService.class)
				.getAllRadiologyOrder();
		
		int result = Integer.parseInt(radiologyorderId);
		
		List<Study> orderst = Context.getService(RadiologyService.class)
				.getAllStudyRadiologyOrder();
		User authenticatedUser = Context.getAuthenticatedUser();
		
		Provider provider = Context.getProviderService()
				.getProvider(authenticatedUser.getId());
		
		RadiologyOrder radiologyOrder;
		
		for (Order order : orders) {
			
			if ((order.getOrderId()
					.toString().trim()).equals(radiologyorderId.trim())) {
				radiologyOrder = Context.getService(RadiologyService.class)
						.getRadiologyOrderByOrderId(order.getOrderId());
				
				Context.getService(RadiologyService.class)
						.updateStudyPerformedStatus(radiologyOrder.getStudy()
								.getStudyInstanceUid(), PerformedProcedureStepStatus.DONE);
				
				Context.getService(RadiologyService.class)
						.updateRadiologyStatusOrder(radiologyOrder.getStudy()
								.getStudyInstanceUid(), RadiologyOrderStatus.COMPLETED);
				
				Context.getService(RadiologyService.class)
						.updateRadiologyOrderRadiologist(radiologyOrder.getStudy()
								.getStudyInstanceUid(), provider);
				
				Context.getService(RadiologyService.class)
						.updateObsCompletedDate(radiologyOrder.getStudy()
								.getStudyInstanceUid(), new Date().toString());
				
				List<Encounter> ampt = Context.getEncounterService()
						.getEncountersByPatient(order.getPatient());
				
				System.out.println("Jytryrtryryr enc.size() " + ampt.size());
				int encou = 0;
				int max = 0;
				for (Encounter ep : ampt) {
					if (ep.getEncounterId() > max) {
						max = ep.getEncounterId();
					}
					System.out.println("MKMK@#@#@##2412443424 encounter max " + max);
					
				}
				
				Context.getService(RadiologyService.class)
						.updateStudyEncounterId(radiologyOrder.getStudy()
								.getStudyInstanceUid(), max);
				
			}
			
		}
		
		ArrayList<RadiologyOrder> getRadiologyOrder = new ArrayList<RadiologyOrder>();
		
		List<RadiologyOrder> inProgressRadiologyOrders = getInProgressRadiologyOrdersByPatient();
		
		for (RadiologyOrder updateActiveOrder : inProgressRadiologyOrders) {
			getRadiologyOrder.add(updateActiveOrder);
		}
		
		String[] properties = new String[5];
		properties[0] = "orderId";
		properties[1] = "study.studyname";
		properties[2] = "dateCreated";
		properties[3] = "urgency";
		properties[4] = "patient.personName";
		
		return SimpleObject.fromCollection(getRadiologyOrder, ui, properties);
	}
	
	/**
	 * Creates a simple object to record if there is an authenticated user
	 * 
	 * @return the simple object
	 */
	public SimpleObject checkIfLoggedIn() {
		return SimpleObject.create("isLoggedIn", Context.isAuthenticated());
	}
	
	/**
	 * Tries to authenticate with the given credentials
	 * 
	 * @param user the username
	 * @param pass the password
	 * @return a simple object to record if successful
	 */
	public SimpleObject authenticate(@RequestParam("user") String user, @RequestParam("pass") String pass,
			UiSessionContext context, @SpringBean EmrApiProperties emrApiProperties) {
		try {
			Context.authenticate(user, pass);
			context.setSessionLocation(emrApiProperties.getUnknownLocation());
		}
		catch (ContextAuthenticationException ex) {
			
		}
		
		return checkIfLoggedIn();
	}
	
	/**
	 * Handles a form submit request
	 * 
	 * @param patient
	 * @param hf
	 * @param encounter
	 * @param visit
	 * @param returnUrl
	 * @param request
	 * @return
	 * @throws Exception
	 */
	@Transactional
	public SimpleObject submit(UiSessionContext sessionContext, @RequestParam("personId") Patient patient,
			@RequestParam("htmlFormId") HtmlForm hf,
			@RequestParam(value = "encounterId", required = false) Encounter encounter,
			@RequestParam(value = "radiologyOrderId", required = false) Integer radiologyOrderId,
			@RequestParam(value = "visitId", required = false) Visit visit,
			@RequestParam(value = "createVisit", required = false) Boolean createVisit,
			@RequestParam(value = "returnUrl", required = false) String returnUrl,
			@SpringBean("adtService") AdtService adtService,
			@SpringBean("featureToggles") FeatureToggleProperties featureToggles, UiUtils ui, HttpServletRequest request)
			throws Exception {
		
		// TODO formModifiedTimestamp and encounterModifiedTimestamp
		System.out.println("2222222 radiologyOrderId" + radiologyOrderId);
		RadiologyOrder setEncounterToRadiologyOrderOnFormSubmit = Context.getService(RadiologyService.class)
				.getRadiologyOrderByOrderId(radiologyOrderId);
		
		System.out.println("EEEEEEncounter before Form submit " + setEncounterToRadiologyOrderOnFormSubmit.getStudy());
		
		System.out.println("2222222 patient" + patient);
		System.out.println("2222222 encounter" + encounter);
		System.out.println("2222222 hf" + hf);
		boolean editMode = encounter != null;
		
		FormEntrySession fes;
		if (encounter != null) {
			System.out.println("44444");
			fes = new FormEntrySession(patient, encounter, FormEntryContext.Mode.EDIT, hf, request.getSession());
		} else {
			System.out.println("555555");
			fes = new FormEntrySession(patient, hf, FormEntryContext.Mode.ENTER, request.getSession());
		}
		
		VisitDomainWrapper visitDomainWrapper = getVisitDomainWrapper(visit, encounter, adtService);
		setupVelocityContext(fes, visitDomainWrapper, ui, sessionContext, featureToggles);
		setupFormEntrySession(fes, visitDomainWrapper, ui, sessionContext, returnUrl);
		fes.getHtmlToDisplay(); // needs to happen before we validate or process a form
		System.out.println("666663");
		// Validate and return with errors if any are found
		List<FormSubmissionError> validationErrors = fes.getSubmissionController()
				.validateSubmission(fes.getContext(), request);
		if (validationErrors.size() > 0) {
			System.out.println("777777");
			return returnHelper(validationErrors, fes, null);
		}
		
		try {
			
			System.out.println("333333");
			// No validation errors found so process form submission
			fes.prepareForSubmit();
			fes.getSubmissionController()
					.handleFormSubmission(fes, request);
		}
		catch (Exception ex) {
			StringWriter sw = new StringWriter();
			ex.printStackTrace(new PrintWriter(sw));
			validationErrors.add(new FormSubmissionError("general-form-error", "Form submission error " + ex.getMessage()
					+ "<br/>" + sw.toString()));
			return returnHelper(validationErrors, fes, null);
		}
		
		// Check this form will actually create an encounter if its supposed to
		if (fes.getContext()
				.getMode() == FormEntryContext.Mode.ENTER && fes.hasEncouterTag() && (fes.getSubmissionActions()
				.getEncountersToCreate() == null || fes.getSubmissionActions()
				.getEncountersToCreate()
				.size() == 0)) {
			throw new IllegalArgumentException("This form is not going to create an encounter");
		}
		
		Encounter formEncounter = fes.getContext()
				.getMode() == FormEntryContext.Mode.ENTER ? fes.getSubmissionActions()
				.getEncountersToCreate()
				.get(0) : encounter;
		
		// we don't want to lose any time information just because we edited it with a form that only collects date
		if (fes.getContext()
				.getMode() == FormEntryContext.Mode.EDIT && hasNoTimeComponent(formEncounter.getEncounterDatetime())) {
			keepTimeComponentOfEncounterIfDateComponentHasNotChanged(fes.getContext()
					.getPreviousEncounterDate(), formEncounter);
		}
		
		// create a visit if necessary (note that this currently only works in real-time mode)
		if (createVisit != null && (createVisit) && visit == null) {
			visit = adtService.ensureActiveVisit(patient, sessionContext.getSessionLocation());
			fes.getContext()
					.setVisit(visit);
		}
		
		// attach to the visit if it exists
		if (visit != null) {
			try {
				new EncounterDomainWrapper(formEncounter).attachToVisit(visit);
			}
			catch (EncounterDateBeforeVisitStartDateException e) {
				validationErrors.add(new FormSubmissionError("general-form-error",
						"Encounter datetime should be after the visit start date"));
			}
			catch (EncounterDateAfterVisitStopDateException e) {
				validationErrors.add(new FormSubmissionError("general-form-error",
						"Encounter datetime should be before the visit stop date"));
			}
			
			if (validationErrors.size() > 0) {
				return returnHelper(validationErrors, fes, null);
			}
		}
		
		// Do actual encounter creation/updating
		fes.applyActions();
		
		request.getSession()
				.setAttribute(
					UiCommonsConstants.SESSION_ATTRIBUTE_INFO_MESSAGE,
					ui.message(editMode ? "htmlformentryui.editHtmlForm.successMessage"
							: "htmlformentryui.enterHtmlForm.successMessage", ui.format(hf.getForm()),
						ui.escapeJs(ui.format(patient))));
		request.getSession()
				.setAttribute(UiCommonsConstants.SESSION_ATTRIBUTE_TOAST_MESSAGE, "true");
		
		System.out.println("EEEEEEncoformEncounter.getEncounterId() " + formEncounter.getEncounterId());
		
		Context.getService(RadiologyService.class)
				.updateStudyEncounterId(setEncounterToRadiologyOrderOnFormSubmit.getStudy()
						.getStudyInstanceUid(), formEncounter.getEncounterId());
		System.out.println("EEEEEEncounter after Form submit " + setEncounterToRadiologyOrderOnFormSubmit.getStudy());
		return returnHelper(null, fes, formEncounter);
	}
	
	private SimpleObject returnHelper(List<FormSubmissionError> validationErrors, FormEntrySession session,
			Encounter encounter) {
		if (validationErrors == null || validationErrors.size() == 0) {
			String afterSaveUrl = session.getAfterSaveUrlTemplate();
			if (afterSaveUrl != null) {
				afterSaveUrl = afterSaveUrl.replaceAll("\\{\\{patient.id\\}\\}", session.getPatient()
						.getId()
						.toString());
				afterSaveUrl = afterSaveUrl.replaceAll("\\{\\{encounter.id\\}\\}", session.getEncounter()
						.getId()
						.toString());
			}
			return SimpleObject.create("success", true, "encounterId", encounter.getId(), "goToUrl", afterSaveUrl);
		} else {
			Map<String, String> errors = new HashMap<String, String>();
			for (FormSubmissionError err : validationErrors) {
				if (err.getSourceWidget() != null)
					errors.put(session.getContext()
							.getErrorFieldId(err.getSourceWidget()), err.getError());
				else
					errors.put(err.getId(), err.getError());
				System.out.println("EEEE " + err.getId());
				System.out.println("EEEE " + err.getError());
			}
			return SimpleObject.create("success", false, "errors", errors);
		}
	}
	
	private boolean hasNoTimeComponent(Date date) {
		return new DateMidnight(date).toDate()
				.equals(date);
	}
	
	private void keepTimeComponentOfEncounterIfDateComponentHasNotChanged(Date previousEncounterDate, Encounter formEncounter) {
		
		if (previousEncounterDate != null
				&& new DateMidnight(previousEncounterDate).equals(new DateMidnight(formEncounter.getEncounterDatetime()))) {
			formEncounter.setEncounterDatetime(previousEncounterDate);
		}
		
	}
	
	private void setupModel(FragmentModel model, FormEntrySession fes, VisitDomainWrapper visitDomainWrapper,
			Boolean createVisit) {
		
		model.addAttribute("currentDate", (new DateMidnight()).toDate());
		System.out.println("56565656565 " + fes.getFormName());
		// System.out.println("56565656565 " + fes.getPatient()
		// .getPersonId());
		model.addAttribute("command", fes);
		model.addAttribute("visit", visitDomainWrapper);
		if (createVisit != null) {
			model.addAttribute("createVisit", createVisit.toString());
		} else {
			model.addAttribute("createVisit", "false");
		}
		
	}
	
	private VisitDomainWrapper getVisitDomainWrapper(Visit visit, Encounter encounter, AdtService adtService) {
		// if we don't have a visit, but the encounter has a visit, use that
		if (visit == null && encounter != null) {
			visit = encounter.getVisit();
		}
		
		if (visit == null) {
			return null;
		} else {
			return adtService.wrap(visit);
		}
	}
}

package org.openmrs.module.radiology.fragment.controller;

import java.io.IOException;
import java.io.PrintWriter;
import java.io.StringWriter;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
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
import org.openmrs.module.radiology.RadiologyProperties;
import org.openmrs.module.radiology.RadiologyService;
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
 * Radiologist to add, edit observation and submit observation.
 * 
 * @author tenzin
 */
public class AddEditObservationFragmentController extends BaseHtmlFormFragmentController {
	
	/**
	 * Get the performed status completed orders
	 * 
	 * @param config
	 * @param sessionContext
	 * @param ui
	 * @param htmlFormEntryService
	 * @param adtService
	 * @param formService
	 * @param resourceFactory
	 * @param featureToggles
	 * @param definitionUiResource
	 * @param encounter
	 * @param visit
	 * @param createVisit
	 * @param automaticValidation
	 * @param model
	 * @param httpSession
	 * @throws Exception
	 */
	public void controller(FragmentConfiguration config, UiSessionContext sessionContext, UiUtils ui,
			@SpringBean("htmlFormEntryService") HtmlFormEntryService htmlFormEntryService,
			@SpringBean("adtService") AdtService adtService, @SpringBean("formService") FormService formService,
			@SpringBean("coreResourceFactory") ResourceFactory resourceFactory,
			@SpringBean("featureToggles") FeatureToggleProperties featureToggles,
			@FragmentParam(value = "definitionUiResource", required = false) String definitionUiResource,
			@FragmentParam(value = "encounter", required = false) Encounter encounter,
			@FragmentParam(value = "visit", required = false) Visit visit,
			@FragmentParam(value = "createVisit", required = false) Boolean createVisit,
			@FragmentParam(value = "automaticValidation", defaultValue = "true") boolean automaticValidation,
			FragmentModel model, HttpSession httpSession) throws Exception {
		
		// patient dashboard
		String patientClinicianUrl = "http://localhost:8080/openmrs/coreapps/clinicianfacing/patient.page?patientId=";
		model.addAttribute("patientClinicianUrl", patientClinicianUrl);
		// get performed status completed orders
		List<RadiologyOrder> performedStatusCompletedOrders = getPerformedStatusCompletedRadiologyOrders();
		// get oviyum url
		String dicomViewerUrladdress = getDicomViewerUrladdress();
		model.addAttribute("dicomViewerUrladdress", dicomViewerUrladdress);
		model.put("performedStatusCompletedOrders", performedStatusCompletedOrders);
		
	}
	
	/**
	 * Get the previous radiology orders
	 * 
	 * @param service
	 * @param model
	 * @param patientId
	 * @param ui
	 * @return json radiology orders having report ready status
	 */
	public List<SimpleObject> getPatientReportReadyOrder(@SpringBean("conceptService") ConceptService service,
			FragmentModel model, @RequestParam(value = "patientId") Patient patientId, UiUtils ui) {
		
		ArrayList<RadiologyOrder> reportReadyRadiologyOrders = new ArrayList<RadiologyOrder>();
		// get all patient orders
		List<Order> allPatientOrders = Context.getOrderService()
				.getAllOrdersByPatient(patientId);
		
		int testOrderTypeId = Context.getOrderService()
				.getOrderTypeByName("Radiology Order")
				.getOrderTypeId();
		
		RadiologyOrder radiologyOrder;
		for (Order order : allPatientOrders) {
			if (order.getOrderType()
					.getOrderTypeId() == testOrderTypeId) {
				
				radiologyOrder = Context.getService(RadiologyService.class)
						.getRadiologyOrderByOrderId(order.getOrderId());
				// get orders with report ready status
				if (radiologyOrder.isReportReady()) {
					reportReadyRadiologyOrders.add(radiologyOrder);
				}
			}
		}
		// properties selected from radiology order
		String[] properties = new String[8];
		properties[0] = "orderer.name";
		properties[1] = "instructions";
		properties[2] = "Patient.PatientId";
		properties[3] = "orderdiagnosis";
		properties[4] = "study.studyname";
		properties[5] = "study.studyInstanceUid";
		properties[6] = "DateCreated";
		properties[7] = "study.studyReportSavedEncounterId";
		
		return SimpleObject.fromCollection(reportReadyRadiologyOrders, ui, properties);
	}
	
	/**
	 * If report is saved, get the report saved encounter id
	 * 
	 * @param service
	 * @param model
	 * @param radiologyorderId
	 * @param ui
	 * @return radiology order with report saved encounter id
	 */
	public List<SimpleObject> getReportSavedEncounterId(@SpringBean("conceptService") ConceptService service,
			FragmentModel model, @RequestParam(value = "radiologyorderId") Integer radiologyorderId, UiUtils ui) {
		
		ArrayList<RadiologyOrder> reportSavedStudy = new ArrayList<RadiologyOrder>();
		// get the radiology order with the report saved encounter id
		RadiologyOrder radiologyOrderByOrderId = Context.getService(RadiologyService.class)
				.getRadiologyOrderByOrderId(radiologyorderId);
		reportSavedStudy.add(radiologyOrderByOrderId);
		String[] properties = new String[1];
		properties[0] = "study.studyReportSavedEncounterId";
		return SimpleObject.fromCollection(reportSavedStudy, ui, properties);
	}
	
	/**
	 * get the observation for the report encounter id
	 * 
	 * @param service
	 * @param model
	 * @param encounterId
	 * @param ui
	 * @return observations for the encounter id
	 */
	public List<SimpleObject> getEncounterIdObs(@SpringBean("conceptService") ConceptService service, FragmentModel model,
			@RequestParam(value = "encounterId") String encounterId, UiUtils ui) {
		
		List<Obs> encounterIdObs = Context.getObsService()
				.getObservations(encounterId);
		
		String[] properties = new String[2];
		properties[0] = "Concept";
		properties[1] = "valueText";
		
		return SimpleObject.fromCollection(encounterIdObs, ui, properties);
	}
	
	/**
	 * @param service
	 * @param model
	 * @param radiologyorderId
	 * @param ui
	 * @return radiology order with detailed order information
	 */
	public List<SimpleObject> getRadiologyOrderDetail(@SpringBean("conceptService") ConceptService service,
			FragmentModel model, @RequestParam(value = "radiologyorderId") Integer radiologyorderId, UiUtils ui) {
		
		ArrayList<RadiologyOrder> radiologyOrdersDetail = new ArrayList<RadiologyOrder>();
		RadiologyOrder radiologyOrderByOrderId = Context.getService(RadiologyService.class)
				.getRadiologyOrderByOrderId(radiologyorderId);
		radiologyOrdersDetail.add(radiologyOrderByOrderId);
		
		String[] properties = new String[12];
		properties[0] = "patient.personName";
		properties[1] = "patient.patientIdentifier";
		properties[2] = "study.studyname";
		properties[3] = "dateCreated";
		properties[4] = "urgency";
		properties[5] = "patient.patientIdentifier";
		properties[6] = "orderId";
		properties[7] = "study.studyReportSavedEncounterId";
		properties[8] = "Orderer";
		properties[9] = "Orderdiagnosis";
		properties[10] = "Instructions";
		properties[11] = "study.studyInstanceUid";
		
		return SimpleObject.fromCollection(radiologyOrdersDetail, ui, properties);
	}
	
	/**
	 * Cancel Saved report and update saved report column in the active order table for the order.
	 * 
	 * @param service
	 * @param model
	 * @param radiologyorderId
	 * @param ui
	 * @return updated report saved column in the active order page
	 */
	public List<SimpleObject> CancelSavedReport(@SpringBean("conceptService") ConceptService service, FragmentModel model,
			@RequestParam(value = "radiologyorderId") Integer radiologyorderId, UiUtils ui) {
		
		ArrayList<RadiologyOrder> radiologyOrdersReportUpdate = new ArrayList<RadiologyOrder>();
		// get the radiology order
		RadiologyOrder reportEncounterIdToBeRemoved = Context.getService(RadiologyService.class)
				.getRadiologyOrderByOrderId(radiologyorderId);
		// remove the report encounter id for the order
		Context.getService(RadiologyService.class)
				.updateStudyEncounterId(reportEncounterIdToBeRemoved.getStudy()
						.getStudyInstanceUid(), null);
		// get the updated performed status completed orders
		List<RadiologyOrder> updatePerformedStatusCompletedRadiologyOrders = getPerformedStatusCompletedRadiologyOrders();
		
		for (RadiologyOrder updateRadiologyOrder : updatePerformedStatusCompletedRadiologyOrders) {
			radiologyOrdersReportUpdate.add(updateRadiologyOrder);
		}
		// properties selected from the order
		String[] properties = new String[8];
		properties[0] = "patient.personName";
		properties[1] = "patient.patientIdentifier";
		properties[2] = "study.studyname";
		properties[3] = "dateCreated";
		properties[4] = "urgency";
		properties[5] = "patient.patientIdentifier.Identifier";
		properties[6] = "orderId";
		properties[7] = "study.studyReportSavedEncounterId";
		
		return SimpleObject.fromCollection(radiologyOrdersReportUpdate, ui, properties);
	}
	
	/**
	 * Get the form if the form is generated in the HTMLForm
	 * 
	 * @param service
	 * @param model
	 * @param radiologyorderId
	 * @param htmlFormEntryService
	 * @param adtService
	 * @param formService
	 * @param resourceFactory
	 * @param featureToggles
	 * @param sessionContext
	 * @param httpSession
	 * @param ui
	 * @return forms from the HTMLForm
	 * @throws IOException
	 * @throws Exception
	 */
	public List<SimpleObject> getForm(@SpringBean("conceptService") ConceptService service, FragmentModel model,
			@RequestParam(value = "radiologyorderId") String radiologyorderId,
			@SpringBean("htmlFormEntryService") HtmlFormEntryService htmlFormEntryService,
			@SpringBean("adtService") AdtService adtService, @SpringBean("formService") FormService formService,
			@SpringBean("coreResourceFactory") ResourceFactory resourceFactory,
			@SpringBean("featureToggles") FeatureToggleProperties featureToggles, UiSessionContext sessionContext,
			HttpSession httpSession, UiUtils ui) throws IOException, Exception {
		
		String definitionUiResource = null;
		Encounter encounter = null;
		Visit visit = null;
		boolean automaticValidation = true;
		Form form = null;
		ArrayList<FormEntrySession> command = new ArrayList<FormEntrySession>();
		ArrayList<Form> formlist = new ArrayList<Form>();
		
		int radiologyorderIdInteger = Integer.parseInt(radiologyorderId);
		RadiologyService radiologyservice = Context.getService(RadiologyService.class);
		RadiologyOrder getRadiologyOrder = radiologyservice.getRadiologyOrderByOrderId(radiologyorderIdInteger);
		// If no report saved encounter Id, then get the generic and non generic form
		if (getRadiologyOrder.getStudy()
				.getStudyReportSavedEncounterId() == null) {
			encounter = null;
			form = Context.getFormService()
					.getFormByUuid(getRadiologyOrder.getStudy()
							.getNonGenericHtmlFormUid());
			Form genericform = Context.getFormService()
					.getFormByUuid(getRadiologyOrder.getStudy()
							.getGenericHtmlFormUid());
			formlist.add(form);
			formlist.add(genericform);
		} else {
			// If there is report saved encounter Id, then get the report saved form
			encounter = Context.getEncounterService()
					.getEncounter(getRadiologyOrder.getStudy()
							.getStudyReportSavedEncounterId());
			form = encounter.getForm();
			formlist.add(form);
		}
		String returnUrl = "";
		for (Form eachform : formlist) {
			HtmlForm hf = HtmlFormEntryUtil.getService()
					.getHtmlFormByForm(eachform);
			Patient patient = getRadiologyOrder.getPatient();
			Integer htmlFormId = eachform.getFormId();
			String formUuid = eachform.getUuid();
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
				if (hf == null) {
					throw new IllegalArgumentException("The form for the specified encounter (" + encounter.getForm()
							+ ") does not have an HtmlForm associated with it");
				}
			}
			if (hf == null) {
				throw new RuntimeException("Could not find HTML Form");
			}
			
			FormEntrySession fes;
			if (encounter != null) {
				fes = new FormEntrySession(patient, encounter, FormEntryContext.Mode.EDIT, hf, null, httpSession,
						automaticValidation, !automaticValidation);
			} else {
				fes = new FormEntrySession(patient, hf, FormEntryContext.Mode.ENTER, null, httpSession, automaticValidation,
						!automaticValidation);
			}
			
			VisitDomainWrapper visitDomainWrapper = getVisitDomainWrapper(visit, encounter, adtService);
			setupVelocityContext(fes, visitDomainWrapper, ui, sessionContext, featureToggles);
			setupFormEntrySession(fes, visitDomainWrapper, ui, sessionContext, returnUrl);
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
	
	// get the oviyum url address
	private String getDicomViewerUrladdress() {
		RadiologyProperties radiologyProperties = new RadiologyProperties();
		return radiologyProperties.getServersAddress() + ":" + radiologyProperties.getServersPort()
				+ radiologyProperties.getDicomViewerUrlBase() + "?" + radiologyProperties.getDicomViewerLocalServerName();
		
	}
	
	/**
	 * @return json list of completed radiology orders
	 */
	public List<RadiologyOrder> getPerformedStatusCompletedRadiologyOrders() {
		Vector<RadiologyOrder> completedRadiologyOrders = new Vector<RadiologyOrder>();
		
		List<RadiologyOrder> orders = Context.getService(RadiologyService.class)
				.getAllRadiologyOrder();
		
		int testOrderTypeId = Context.getOrderService()
				.getOrderTypeByName("Radiology Order")
				.getOrderTypeId();
		
		RadiologyOrder radiologyOrder;
		for (Order order : orders) {
			if (order.getOrderType()
					.getOrderTypeId() == testOrderTypeId) {
				
				radiologyOrder = Context.getService(RadiologyService.class)
						.getRadiologyOrderByOrderId(order.getOrderId());
				// get the completed radiology orders
				if (radiologyOrder.isCompleted()) {
					completedRadiologyOrders.add(radiologyOrder);
				}
				
			}
		}
		return completedRadiologyOrders;
	}
	
	/**
	 * Once report is submitted, update the active orders
	 * 
	 * @param service
	 * @param model
	 * @param radiologyorderId
	 * @param ui
	 * @return the updated active orders
	 */
	public List<SimpleObject> updateActiveOrders(@SpringBean("conceptService") ConceptService service, FragmentModel model,
			@RequestParam(value = "radiologyorderId") String radiologyorderId, UiUtils ui) {
		
		List<RadiologyOrder> allOrders = Context.getService(RadiologyService.class)
				.getAllRadiologyOrder();
		User authenticatedUser = Context.getAuthenticatedUser();
		RadiologyOrder radiologyOrder;
		for (Order order : allOrders) {
			if ((order.getOrderId()
					.toString().trim()).equals(radiologyorderId.trim())) {
				
				radiologyOrder = Context.getService(RadiologyService.class)
						.getRadiologyOrderByOrderId(order.getOrderId());
				// update the performed status to report ready so it is available to referring physician
				Context.getService(RadiologyService.class)
						.updateStudyPerformedStatus(radiologyOrder.getStudy()
								.getStudyInstanceUid(), PerformedProcedureStepStatus.REPORT_READY);
				// get the radiologist submitted obs date
				Context.getService(RadiologyService.class)
						.updateObsCompletedDate(radiologyOrder.getStudy()
								.getStudyInstanceUid(), new Date().toString());
				// get the radiologist
				Context.getService(RadiologyService.class)
						.updateRadiologyOrderUser(radiologyOrder.getStudy()
								.getStudyInstanceUid(), authenticatedUser.toString());
			}
		}
		
		// get the updated performed status completed radiology orders
		ArrayList<RadiologyOrder> updateRadiologyOrder = new ArrayList<RadiologyOrder>();
		List<RadiologyOrder> performedStatusCompletedOrders = getPerformedStatusCompletedRadiologyOrders();
		for (RadiologyOrder updateActiveOrder : performedStatusCompletedOrders) {
			updateRadiologyOrder.add(updateActiveOrder);
		}
		
		String[] properties = new String[7];
		properties[0] = "orderId";
		properties[1] = "study.studyname";
		properties[2] = "dateCreated";
		properties[3] = "urgency";
		properties[4] = "patient.personName";
		properties[5] = "study.studyReportSavedEncounterId";
		properties[6] = "patient.patientIdentifier.Identifier";
		return SimpleObject.fromCollection(updateRadiologyOrder, ui, properties);
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
	 * @param context
	 * @param emrApiProperties
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
	 * @param sessionContext
	 * @param patient
	 * @param hf
	 * @param encounter
	 * @param radiologyOrderId
	 * @param visit
	 * @param returnUrl
	 * @param createVisit
	 * @param request
	 * @param featureToggles
	 * @param adtService
	 * @param ui
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
		
		RadiologyOrder radiologyOrderByOrderId = Context.getService(RadiologyService.class)
				.getRadiologyOrderByOrderId(radiologyOrderId);
		boolean editMode = encounter != null;
		FormEntrySession fes;
		if (encounter != null) {
			// edit saved form
			fes = new FormEntrySession(patient, encounter, FormEntryContext.Mode.EDIT, hf, request.getSession());
		} else {
			// fill new form
			fes = new FormEntrySession(patient, hf, FormEntryContext.Mode.ENTER, request.getSession());
		}
		
		VisitDomainWrapper visitDomainWrapper = getVisitDomainWrapper(visit, encounter, adtService);
		setupVelocityContext(fes, visitDomainWrapper, ui, sessionContext, featureToggles);
		setupFormEntrySession(fes, visitDomainWrapper, ui, sessionContext, returnUrl);
		fes.getHtmlToDisplay(); // needs to happen before we validate or process a form
		
		// Validate and return with errors if any are found
		List<FormSubmissionError> validationErrors = fes.getSubmissionController()
				.validateSubmission(fes.getContext(), request);
		if (validationErrors.size() > 0) {
			
			return returnHelper(validationErrors, fes, null);
		}
		
		try {
			
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
		Context.getService(RadiologyService.class)
				.updateStudyEncounterId(radiologyOrderByOrderId.getStudy()
						.getStudyInstanceUid(), formEncounter.getEncounterId());
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
				if (err.getSourceWidget() != null) {
					errors.put(session.getContext()
							.getErrorFieldId(err.getSourceWidget()), err.getError());
				} else {
					errors.put(err.getId(), err.getError());
				}
				
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

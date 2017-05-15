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
import org.openmrs.ui.framework.annotation.SpringBean;
import org.openmrs.ui.framework.fragment.FragmentModel;
import org.openmrs.ui.framework.resource.ResourceFactory;
import org.springframework.web.bind.annotation.RequestParam;

/**
 * Radiologist to add,and edit observations.
 * Following methods are from HTMLFormEntryUI module:
 * GetForm() submit() returnHelper() hasNoTimeComponent()
 * keepTimeComponentOfEncounterIfDateComponentHasNotChanged()
 * getVisitDomainWrapper() authenticate() checkIfLoggedIn()
 *
 * @author tenzin
 */
public class AddEditObservationFragmentController extends BaseHtmlFormFragmentController {
	
	/**
	 * Get the performed status completed orders that needs to add observation
	 * after the picture is taken
	 *
	 * @param model FragmentModel
	 */
	public void controller(FragmentModel model) {
		
		RadiologyProperties radiologyProperties = new RadiologyProperties();
		// patient dashboard
		String serverAddress = radiologyProperties.getServersAddress();
		String serverPort = radiologyProperties.getOpenMRSServersPort();
		String patientClinicianUrl = serverAddress + ":" + serverPort
				+ "/openmrs/coreapps/clinicianfacing/patient.page?patientId=";
		model.addAttribute("patientClinicianUrl", patientClinicianUrl);
		// get performed status completed orders
		
		String oviyamStatus = radiologyProperties.getDicomViewerLocalServerName();
		String weasisStatus = radiologyProperties.getDicomViewerWeasisUrlBase();
		
		// get oviyum url
		String dicomViewerUrladdress = getDicomViewerUrladdress();
		
		// get weasis url
		String dicomViewerWeasisUrladdress = getDicomViewerWeasisUrladdress();
		
		List<RadiologyOrder> performedStatusCompletedOrders = getPerformedStatusCompletedRadiologyOrders();
		
		model.addAttribute("oviyamStatus", oviyamStatus);
		model.addAttribute("weasisStatus", weasisStatus);
		model.addAttribute("dicomViewerUrladdress", dicomViewerUrladdress);
		model.addAttribute("dicomViewerWeasisUrladdress", dicomViewerWeasisUrladdress);
		model.put("performedStatusCompletedOrders", performedStatusCompletedOrders);
	}
	
	/**
	 * Get the past completed report ready radiology orders of the patient. The
	 * Ajax call requires a json result; properties string array elements are
	 * concepts and properties indicate the Concept properties of interest; The
	 * framework will build the json response when the method returns
	 *
	 * @param service ConceptService
	 * @param model FragmentModel
	 * @param patientId to retrieve previous radiology orders
	 * @param ui UiUtils
	 * @return past radiology orders
	 */
	public List<SimpleObject> getPatientReportReadyOrder(@SpringBean("conceptService") ConceptService service,
			FragmentModel model, @RequestParam(value = "patientId") Patient patientId, UiUtils ui) {
		
		ArrayList<RadiologyOrder> reportReadyRadiologyOrders = new ArrayList<RadiologyOrder>();
		if (patientId == null) {
			throw new IllegalArgumentException("patientId is required");
		}
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
		properties[2] = "patient.patientIdentifier.Identifier";
		properties[3] = "orderdiagnosis";
		properties[4] = "study.studyname";
		properties[5] = "study.studyInstanceUid";
		properties[6] = "DateCreated";
		properties[7] = "study.studyReportSavedEncounterId";
		
		return SimpleObject.fromCollection(reportReadyRadiologyOrders, ui, properties);
	}
	
	/**
	 * If report is entered, get the report saved encounterId generated by the
	 * HTMLFormEntryUI for the order. The Ajax call requires a json result;
	 * properties string array elements are concepts and properties indicate
	 * the Concept properties of interest; The framework will build the json
	 * response when the method returns
	 *
	 * @param service ConceptService
	 * @param model FragmentModel
	 * @param radiologyorderId order having HTMLFormEntryUI report saved
	 *        encounterId
	 * @param ui UiUtils
	 * @return radiology order with report saved encounter id
	 */
	public List<SimpleObject> getReportSavedEncounterId(@SpringBean("conceptService") ConceptService service,
			FragmentModel model, @RequestParam(value = "radiologyorderId") Integer radiologyorderId, UiUtils ui) {
		
		ArrayList<RadiologyOrder> reportSavedStudy = new ArrayList<RadiologyOrder>();
		// get the radiology order with the report saved encounter id
		RadiologyOrder radiologyOrderByOrderId = Context.getService(RadiologyService.class)
				.getRadiologyOrderByOrderId(radiologyorderId);
		reportSavedStudy.add(radiologyOrderByOrderId);
		String[] properties = new String[3];
		properties[0] = "study.studyReportSavedEncounterId";
		properties[1] = "study.studyInstanceUid";
		properties[2] = "patient.patientIdentifier";
		return SimpleObject.fromCollection(reportSavedStudy, ui, properties);
	}
	
	/**
	 * Get the observation for the report generated encounter id. The Ajax call
	 * requires a json result; properties string array elements are concepts
	 * and properties indicate the Concept properties of interest; The
	 * framework will build the json response when the method returns
	 *
	 * @param service ConceptService
	 * @param encounterId HTMLFormEntryUI encounterId
	 * @param ui UiUtils
	 * @return observations for the encounter id
	 */
	public List<SimpleObject> getEncounterIdObs(@SpringBean("conceptService") ConceptService service,
			@RequestParam(value = "encounterId") String encounterId, UiUtils ui) {
		List<Obs> encounterIdObs = Context.getObsService()
				.getObservations(encounterId);
		
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
	 * Get the radiology order detail when click on the radiology order. The
	 * Ajax call requires a json result; properties string array elements are
	 * concepts and properties indicate the Concept properties of interest; The
	 * framework will build the json response when the method returns
	 *
	 * @param service ConceptService
	 * @param radiologyorderId order clicked on active order page
	 * @param ui UiUtils
	 * @return radiology orders with detailed order information
	 */
	public List<SimpleObject> getRadiologyOrderDetail(@SpringBean("conceptService") ConceptService service,
			@RequestParam(value = "radiologyorderId") Integer radiologyorderId, UiUtils ui) {
		
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
	 * Delete SavedReport and update report column in the active order table
	 * for the order. The Ajax call requires a json result; properties string
	 * array elements are concepts and properties indicate the Concept
	 * properties of interest; The framework will build the json response when
	 * the method returns
	 *
	 * @param service ConceptService
	 * @param model FragmentModel
	 * @param radiologyorderId order that has the saved HTMLFormEntryUI
	 *        encounterId
	 * @param ui UiUtils
	 * @return deleted HTMLFormEntryui encounterId for the order
	 */
	public List<SimpleObject> CancelSavedReport(@SpringBean("conceptService") ConceptService service, FragmentModel model,
			@RequestParam(value = "radiologyorderId") Integer radiologyorderId, UiUtils ui) {
		
		ArrayList<RadiologyOrder> radiologyOrdersReportUpdate = new ArrayList<RadiologyOrder>();
		// get the radiology order
		RadiologyOrder reportEncounterIdToBeRemoved = Context.getService(RadiologyService.class)
				.getRadiologyOrderByOrderId(radiologyorderId);
		// remove the report encounter id for the order
		Context.getService(RadiologyService.class)
				.updateReportSavedEncounterId(reportEncounterIdToBeRemoved.getStudy()
						.getStudyInstanceUid(), null);
		// get the updated performed status completed orders
		List<RadiologyOrder> updatePerformedStatusCompletedRadiologyOrders = getPerformedStatusCompletedRadiologyOrders();
		
		for (RadiologyOrder updateRadiologyOrder : updatePerformedStatusCompletedRadiologyOrders) {
			updateRadiologyOrder.getPatient()
					.getPatientIdentifier();
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
	 * Get the generic and non-generic available HTMLForm for the study of the
	 * order. The Ajax call requires a json result; properties string array
	 * elements are concepts and properties indicate the Concept properties of
	 * interest; The framework will build the json response when the method
	 * returns
	 *
	 * @param service ConceptService
	 * @param radiologyorderId order to get the HTMLFormEntryui report
	 *        templates
	 * @param htmlFormEntryService services provided by the HTML Form Entry module
	 * @param adtService API methods related to Check-In, Admission, Discharge, and Transfer of patient
	 * @param formService service contains methods relating to Form, FormField, and Field
	 * @param resourceFactory provides methods for getting resources
	 * @param featureToggles allow us to develop features that take a long time to build directly in the main development
	 *        line without showing it to the end user
	 * @param sessionContext Details of the current user's login session
	 * @param httpSession current user session
	 * @param ui UiUtils Utility methods available in view technologies for pages and fragments
	 * @return HTMLFormEntryui forms available for the order
	 * @throws IOException
	 * @throws Exception
	 */
	public List<SimpleObject> getForm(@SpringBean("conceptService") ConceptService service,
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
		// generic and non-generic HTMLForm
		Form form = null;
		Form genericform = null;
		ArrayList<FormEntrySession> getForms = new ArrayList<FormEntrySession>();
		ArrayList<Form> formlist = new ArrayList<Form>();
		
		int radiologyorderIdInteger = Integer.parseInt(radiologyorderId);
		RadiologyService radiologyservice = Context.getService(RadiologyService.class);
		RadiologyOrder getRadiologyOrder = radiologyservice.getRadiologyOrderByOrderId(radiologyorderIdInteger);
		// If no report saved encounter Id, then get the generic and non generic form
		if (getRadiologyOrder.getStudy()
				.getStudyReportSavedEncounterId() == null) {
			encounter = null;
			// get the generic and non-generic form uid for the study
			List<Form> getAllForm = Context.getFormService()
					.getAllForms();
			for (Form eachForm : getAllForm) {
				String formName = eachForm.getName()
						.trim();
				if (formName.startsWith("Generic Radiology Report")) {
					genericform = Context.getFormService()
							.getFormByUuid(eachForm.getUuid());
				}
				
				if (getRadiologyOrder.getStudy()
						.getStudyname()
						.trim()
						.equals(formName)) {
					form = Context.getFormService()
							.getFormByUuid(eachForm.getUuid());
					formlist.add(form);
				}
			}
			
			// formlist.add(form);
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
			System.out.println("TETETETETET " + eachform.getName());
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
			getForms.add(fes);
			
		}
		String[] properties = new String[7];
		properties[0] = "EncounterModifiedTimestamp";
		properties[1] = "HtmlToDisplay";
		properties[2] = "Patient.PatientId";
		properties[3] = "HtmlFormId";
		properties[4] = "FormModifiedTimestamp";
		properties[5] = "ReturnUrl";
		properties[6] = "FormName";
		
		return SimpleObject.fromCollection(getForms, ui, properties);
	}
	
	/**
	 * @return oviyam URL address
	 */
	private String getDicomViewerUrladdress() {
		RadiologyProperties radiologyProperties = new RadiologyProperties();
		return radiologyProperties.getServersAddress() + ":" + radiologyProperties.getServersPort()
				+ radiologyProperties.getDicomViewerUrlBase() + "?" + radiologyProperties.getDicomViewerLocalServerName();
		
	}
	
	/**
	 * @return weasis URL address
	 */
	private String getDicomViewerWeasisUrladdress() {
		RadiologyProperties radiologyProperties = new RadiologyProperties();
		return radiologyProperties.getServersAddress() + ":" + radiologyProperties.getServersPort()
				+ radiologyProperties.getDicomViewerWeasisUrlBase() + "?";
		
	}
	
	/**
	 * Get all preformed status completed radiology orders
	 *
	 * @return all preformed status completed radiology orders
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
	 * Once report is submitted, update the active orders. Order submitted is
	 * no longer available in the active order list The Ajax call requires a
	 * json result; properties string array elements are concepts and
	 * properties indicate the Concept properties of interest; The framework
	 * will build the json response when the method returns
	 *
	 * @param service ConceptService
	 * @param model FragmentModel
	 * @param radiologyorderId order HTMLFormEntryUI report submitted
	 * @param ui UiUtils Utility methods
	 * @return the updated active orders
	 */
	public List<SimpleObject> updateActiveOrders(@SpringBean("conceptService") ConceptService service, FragmentModel model,
			@RequestParam(value = "radiologyorderId") String radiologyorderId, UiUtils ui) {
		
		List<RadiologyOrder> allOrders = Context.getService(RadiologyService.class)
				.getAllRadiologyOrder();
		String authenticatedUser = Context.getAuthenticatedUser()
				.getPersonName()
				.getFullName();
		
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
						.updateReportCompletedDate(radiologyOrder.getStudy()
								.getStudyInstanceUid(), new Date());
				// get the radiologist
				Context.getService(RadiologyService.class)
						.updateStudyReportRadiologist(radiologyOrder.getStudy()
								.getStudyInstanceUid(), authenticatedUser);
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
	 * @param user username
	 * @param pass password
	 * @param context UiSessionContext
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
	 * Handles a form submit request. This is from the HTMLFormEntryui module
	 *
	 * @param sessionContext Details of the current user's login session
	 * @param patient
	 * @param hf HTMLForm for report template
	 * @param encounter HTMLForm completed to record observations
	 * @param radiologyOrderId order form submitted
	 * @param visit a patient visit
	 * @param returnUrl
	 * @param createVisit create visit type
	 * @param request HttpServletRequest
	 * @param featureToggles allow us to develop features that take a long time to build directly in the main development
	 *        line without showing it to the end user
	 * @param adtService API methods related to Check-In, Admission, Discharge, and Transfer of patient
	 * @param ui UiUtils Utility methods
	 * @return if any form validation errors occurs
	 * @throws Exception
	 */
	// @Transactional
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
				.updateReportSavedEncounterId(radiologyOrderByOrderId.getStudy()
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

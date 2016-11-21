/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package org.openmrs.module.radiology.fragment.controller;

import java.io.PrintWriter;
import java.io.StringWriter;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import org.apache.commons.lang.StringUtils;
import org.joda.time.DateMidnight;
import org.openmrs.Concept;
import org.openmrs.ConceptClass;
import org.openmrs.ConceptName;
import org.openmrs.ConceptSet;
import org.openmrs.Encounter;
import org.openmrs.Form;
import org.openmrs.Patient;
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
import org.openmrs.module.htmlformentry.FormEntryContext.Mode;
import org.openmrs.module.htmlformentry.FormEntrySession;
import org.openmrs.module.htmlformentry.FormSubmissionError;
import org.openmrs.module.htmlformentry.HtmlForm;
import org.openmrs.module.htmlformentry.HtmlFormEntryService;
import org.openmrs.module.htmlformentry.HtmlFormEntryUtil;
import org.openmrs.module.htmlformentryui.HtmlFormUtil;
import org.openmrs.module.radiology.RadiologyService;

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

public class TestFragmentController extends BaseHtmlFormFragmentController {
	
	/**
	 * @param config
	 * @param sessionContext
	 * @param htmlFormEntryService
	 * @param formService
	 * @param resourceFactory
	 * @param patient
	 * @param hf
	 * @param form
	 * @param formUuid
	 * @param definitionUiResource
	 * @param encounter
	 * @param visit
	 * @param returnUrl
	 * @param automaticValidation defaults to true. If you don't want HFE's automatic validation, set it to false
	 * @param model
	 * @param httpSession
	 * @throws Exception
	 */
	public void controller(
			FragmentConfiguration config,
			UiSessionContext sessionContext,
			UiUtils ui,
			@SpringBean("htmlFormEntryService") HtmlFormEntryService htmlFormEntryService,
			@SpringBean("adtService") AdtService adtService,
			@SpringBean("formService") FormService formService,
			@SpringBean("coreResourceFactory") ResourceFactory resourceFactory,
			@SpringBean("featureToggles") FeatureToggleProperties featureToggles,
			@FragmentParam("patient") Patient patient,
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
		
		System.out.println("aaaaaa definitionUiResource" + definitionUiResource);
		System.out.println("aaaaaa visit" + visit);
		System.out.println("aaaaaa createVisit" + createVisit);
		System.out.println("aaaaaa automaticValidation" + automaticValidation);
		
		String returnUrl = "/openmrs/radiology/sendFormMessage.page";
		Form form = Context.getFormService()
				.getForm(7);
		HtmlForm hf = HtmlFormEntryUtil.getService()
				.getHtmlFormByForm(form);
		// Patient patient = Context.getPatientService()
		// .getPatient(7);
		Integer htmlFormId = null;
		String formUuid = "";
		// encounter = Context.getEncounterService()
		// .getEncounter(202);
		System.out.println("1111111 " + patient);
		// config.require("patient", "htmlForm | htmlFormId | formId | formUuid | definitionUiResource | encounter");
		
		System.out.println("0000000" + hf);
		
		if (hf == null) {
			if (htmlFormId != null) {
				hf = htmlFormEntryService.getHtmlForm(htmlFormId);
			} else if (form != null) {
				hf = htmlFormEntryService.getHtmlFormByForm(form);
			} else if (formUuid != null) {
				form = formService.getFormByUuid(formUuid);
				hf = htmlFormEntryService.getHtmlFormByForm(form);
			} else if (StringUtils.isNotBlank(definitionUiResource)) {
				hf = HtmlFormUtil.getHtmlFormFromUiResource(resourceFactory, formService, htmlFormEntryService,
					definitionUiResource);
			}
		}
		if (hf == null && encounter != null) {
			form = encounter.getForm();
			if (form == null) {
				throw new IllegalArgumentException("Cannot view a form-less encounter unless you specify which form to use");
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
			System.out.println("88888888");
			fes = new FormEntrySession(patient, hf, FormEntryContext.Mode.ENTER, null, httpSession, automaticValidation,
					!automaticValidation);
		}
		
		System.out.println("56565656565 ooo " + fes.getPatient());
		// fes.getPatient().setPersonId(htmlFormId);
		
		VisitDomainWrapper visitDomainWrapper = getVisitDomainWrapper(visit, encounter, adtService);
		setupVelocityContext(fes, visitDomainWrapper, ui, sessionContext, featureToggles);
		setupFormEntrySession(fes, visitDomainWrapper, ui, sessionContext, returnUrl);
		setupModel(model, fes, visitDomainWrapper, createVisit);
		
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
			@RequestParam(value = "visitId", required = false) Visit visit,
			@RequestParam(value = "createVisit", required = false) Boolean createVisit,
			@RequestParam(value = "returnUrl", required = false) String returnUrl,
			@SpringBean("adtService") AdtService adtService,
			@SpringBean("featureToggles") FeatureToggleProperties featureToggles, UiUtils ui, HttpServletRequest request)
			throws Exception {
		
		// TODO formModifiedTimestamp and encounterModifiedTimestamp
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
		System.out.println("56565656565 " + fes.getPatient());
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

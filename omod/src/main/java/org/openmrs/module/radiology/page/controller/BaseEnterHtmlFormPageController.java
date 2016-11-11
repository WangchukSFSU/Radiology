/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package org.openmrs.module.radiology.page.controller;

import org.apache.commons.lang.StringUtils;
import org.openmrs.Form;
import org.openmrs.Patient;
import org.openmrs.Visit;
import org.openmrs.api.FormService;
import org.openmrs.module.appui.UiSessionContext;
import org.openmrs.module.htmlformentry.HtmlForm;
import org.openmrs.module.htmlformentry.HtmlFormEntryService;
import org.openmrs.module.htmlformentryui.HtmlFormUtil;
import org.openmrs.module.htmlformentryui.page.controller.htmlform.BaseHtmlFormPageController;
import org.openmrs.ui.framework.UiUtils;
import org.openmrs.ui.framework.annotation.SpringBean;
import org.openmrs.ui.framework.page.PageModel;
import org.openmrs.ui.framework.resource.ResourceFactory;
import org.springframework.web.bind.annotation.RequestParam;

public abstract class BaseEnterHtmlFormPageController extends BaseHtmlFormPageController {
	
	public void get(UiSessionContext sessionContext, @RequestParam("patientId") Patient currentPatient,
			@RequestParam(value = "formUuid", required = false) String formUuid,
			@RequestParam(value = "htmlFormId", required = false) HtmlForm htmlForm,
			@RequestParam(value = "definitionUiResource", required = false) String definitionUiResource,
			@RequestParam(value = "visitId", required = false) Visit visit,
			@RequestParam(value = "createVisit", required = false) Boolean createVisit,
			@RequestParam(value = "returnUrl", required = false) String returnUrl,
			@RequestParam(value = "returnProvider", required = false) String returnProvider,
			@RequestParam(value = "returnPage", required = false) String returnPage,
			@RequestParam(value = "returnLabel", required = false) String returnLabel,
			@RequestParam(value = "breadcrumbOverride", required = false) String breadcrumbOverride,
			@SpringBean("htmlFormEntryService") HtmlFormEntryService htmlFormEntryService,
			@SpringBean("formService") FormService formService,
			@SpringBean("coreResourceFactory") ResourceFactory resourceFactory, UiUtils ui, PageModel model)
			throws Exception {
		
		// TODO: maybe EditHtmlFormWithStandardUiPageController should probably be merged into this?
		
		sessionContext.requireAuthentication();
		
		if (htmlForm == null && StringUtils.isNotEmpty(definitionUiResource)) {
			htmlForm = HtmlFormUtil.getHtmlFormFromUiResource(resourceFactory, formService, htmlFormEntryService,
				definitionUiResource);
		}
		if (htmlForm == null && formUuid != null) {
			Form form = formService.getFormByUuid(formUuid);
			if (form != null) {
				htmlForm = htmlFormEntryService.getHtmlFormByForm(form);
			}
		}
		
		if (htmlForm == null) {
			throw new IllegalArgumentException("Couldn't find a form");
		}
		
		returnUrl = determineReturnUrl(returnUrl, returnProvider, returnPage, currentPatient, visit, ui);
		returnLabel = determineReturnLabel(returnLabel, currentPatient, ui);
		
		model.addAttribute("htmlForm", htmlForm);
		model.addAttribute("patient", currentPatient);
		model.addAttribute("visit", visit);
		model.addAttribute("createVisit", createVisit);
		model.addAttribute("returnUrl", returnUrl);
		model.addAttribute("returnLabel", returnLabel);
		model.addAttribute("breadcrumbOverride", breadcrumbOverride);
	}
	
}

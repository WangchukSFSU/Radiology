package org.openmrs.module.radiology.fragment.controller;

import org.openmrs.module.appframework.feature.FeatureToggleProperties;
import org.openmrs.module.appui.UiSessionContext;
import org.openmrs.module.emrapi.visit.VisitDomainWrapper;
import org.openmrs.module.htmlformentry.FormEntrySession;
import org.openmrs.ui.framework.UiUtils;
import org.springframework.util.StringUtils;

/**
 * This abstract class is from HTMLFormEntryUI module
 */
public abstract class BaseHtmlFormFragmentController {
	
	/**
	 * @param fes
	 * @param visitDomainWrapper
	 * @param ui
	 * @param sessionContext
	 * @param featureToggles
	 */
	protected void setupVelocityContext(FormEntrySession fes, VisitDomainWrapper visitDomainWrapper, UiUtils ui,
			UiSessionContext sessionContext, FeatureToggleProperties featureToggles) {
		
		fes.addToVelocityContext("visit", visitDomainWrapper);
		fes.addToVelocityContext("sessionContext", sessionContext);
		fes.addToVelocityContext("ui", ui);
		fes.addToVelocityContext("featureToggles", featureToggles);
		
	}
	
	/**
	 * @param fes
	 * @param visitDomainWrapper
	 * @param ui
	 * @param sessionContext
	 * @param returnUrl
	 */
	protected void setupFormEntrySession(FormEntrySession fes, VisitDomainWrapper visitDomainWrapper, UiUtils ui,
			UiSessionContext sessionContext, String returnUrl) {
		
		fes.setAttribute("uiSessionContext", sessionContext);
		fes.setAttribute("uiUtils", ui);
		
		// note that we pass the plain visit object to the form entry context, but the velocity context and the model get the
		// "wrapped" visit--not sure if we want to pass the wrapped visit to HFE as well
		fes.getContext()
				.setVisit(visitDomainWrapper != null ? visitDomainWrapper.getVisit() : null);
		
		if (StringUtils.hasText(returnUrl)) {
			fes.setReturnUrl(returnUrl);
			
		}
	}
}

package com.hr.common.language;

import java.util.Locale;

import javax.inject.Inject;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.springframework.beans.propertyeditors.LocaleEditor;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.LocaleResolver;

/*
import javax.servlet.ServletRequestEvent;
import javax.servlet.http.HttpServletRequest;
import org.springframework.util.StringUtils;
import org.springframework.web.servlet.i18n.SessionLocaleResolver;
import org.springframework.web.util.WebUtils;
public class RequestContextListener extends
		org.springframework.web.context.request.RequestContextListener {

	@Override
	public void requestInitialized(ServletRequestEvent requestEvent) {
		super.requestInitialized(requestEvent);
		String lang = requestEvent.getServletRequest().getParameter("lang");

		if (lang != null) {
			WebUtils.setSessionAttribute((HttpServletRequest) requestEvent.getServletRequest(),
			             				  SessionLocaleResolver.LOCALE_SESSION_ATTRIBUTE_NAME,
			             				  StringUtils.parseLocaleString(lang));
		}

	}
}

*/


@Controller("loginChangeLocaleController")
public class ChangeLocaleController {
 @Inject
 private LocaleResolver localeResolver;
 @RequestMapping(value="/loginChangeLocaleTest.do", method=RequestMethod.POST )
 public String changeLoacle(@RequestParam(value = "locale", defaultValue = "en") String
 newLocale,
 Model model,
 HttpSession session, HttpServletRequest request, HttpServletResponse response) throws
 Exception {

 LocaleEditor localeEditor = new LocaleEditor();
 localeEditor.setAsText(newLocale);
 localeResolver.setLocale(request, response, (Locale) localeEditor.getValue());

 return "forward:/ssoLogin.do";
 }
}

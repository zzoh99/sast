package com.hr.common.resolver;

import java.util.Enumeration;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.springframework.context.ApplicationContext;
import org.springframework.web.servlet.view.JstlView;

import com.hr.common.logger.Log;
import com.hr.common.security.SecurityMgrService;
import com.hr.common.wrapper.ReadableRequestWrapper;

public class JstlCustomViewResolver extends JstlView {
	
	private SecurityMgrService securityMgrService;
	
	@Override
	protected void initApplicationContext(ApplicationContext context) {
		this.securityMgrService = context.getBean(SecurityMgrService.class);
		super.initApplicationContext(context);
	}
	
	@Override
	public void render(Map<String, ?> model, HttpServletRequest request, HttpServletResponse response)
			throws Exception {
		Log.Debug("JSTL PAGE RENDERING CUSTOM");
		
		HttpSession session = request.getSession(false);
		String ssnEnterCd = session == null ? null:(String)session.getAttribute("ssnEnterCd");
		if (ssnEnterCd != null) {
			String encryptKey = securityMgrService.getEncryptKey(ssnEnterCd);
			
			//Request Scope data Encrypted
			ReadableRequestWrapper requestWrapper =  new ReadableRequestWrapper(request, encryptKey, false);
			Enumeration<String> pnames = requestWrapper.getParameterNames();
			while (pnames.hasMoreElements()) {
				String pname = pnames.nextElement();
				requestWrapper.setParameterEncrypt(pname, requestWrapper.getParameter(pname));
			}
			request = (HttpServletRequest) requestWrapper;
		}
		
		super.render(model, request, response);
	}
}

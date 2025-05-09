package com.hr.common.filter;

import com.hr.common.logger.Log;
import com.hr.common.security.SecurityMgrService;
import com.hr.common.wrapper.ModifyResponseWrapper;
import com.hr.common.wrapper.ReadableRequestWrapper;
import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import javax.servlet.*;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

@Service
public class ServletWrapperFilter implements Filter {
	@Override
	public void init(FilterConfig filterConfig) throws ServletException {
		Filter.super.init(filterConfig);
	}

	@Autowired
	private SecurityMgrService securityMgrService;

	@Override
	public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain) throws IOException, ServletException {
		Log.Debug("HEADER :::: {} " ,((HttpServletRequest) request).getHeader("l"));

		HttpSession session = ((HttpServletRequest) request).getSession(false);
		String ssnEnterCd = session == null ? null:(String)session.getAttribute("ssnEnterCd");
		String requestURI = ((HttpServletRequest) request).getRequestURI();
		Log.Debug("DO FILTER WRAPPER FILTER REQUEST URI: {}", requestURI);
		
		if (ssnEnterCd != null) {
			String encryptKey = securityMgrService.getEncryptKey(ssnEnterCd);
			// interceptor 쪽에서 로그인 세션 체크를 하므로 필터에서는 일단 수행하지 않도록 한다.
			if (((HttpServletResponse)response).getStatus() != HttpServletResponse.SC_OK) { //RESPONSE STATUS가 OK가 아닐 경우
				chain.doFilter(request, response);
			}
			//DOWNLOAD 관련 URI는 RESPONSE를 WRAPPING하지 않도록 수정
			else if( requestURI != null &&
					(requestURI.contains("fileuploadJFileUpload.do") && request.getParameter("cmd") != null && request.getParameter("cmd").contains("download"))
					|| requestURI.contains("OrgPhotoOut.do")
					|| requestURI.contains("EmpPhotoOut.do")
					|| requestURI.contains("SignPhotoOut.do")
					|| requestURI.contains("LayoutPhotoOut.do")
					|| requestURI.contains("LayoutThumbnail.do")
					|| requestURI.contains("FileDownload.do")
					|| requestURI.contains("AttachFileView.do")
					){
				Log.Debug("IS DOWNLOAD RESPONSE URI : {}", requestURI);
				ReadableRequestWrapper requestWrapper = new ReadableRequestWrapper((HttpServletRequest) request, encryptKey, true);
				chain.doFilter(requestWrapper, response);
			}
			else if (request.getContentType() != null && request.getContentType().contains("multipart/form-data")) { // 파일 업로드시 로깅제외
				chain.doFilter(request, response);
			}
			else {
				Log.Debug("Request/Response Wrapper");
				ReadableRequestWrapper requestWrapper = new ReadableRequestWrapper((HttpServletRequest) request, encryptKey, true);
				ModifyResponseWrapper responseWrapper = new ModifyResponseWrapper((HttpServletResponse) response);
				chain.doFilter(requestWrapper, responseWrapper);
				String body = responseWrapper.getResponseBody();
				if (!StringUtils.isEmpty(body)) {
					byte[] data = null;
					data = body.getBytes();
					response.setContentType(responseWrapper.getContentType());
					response.setContentLength(data.length);
					ServletOutputStream out = response.getOutputStream();
					out.write(data);
					out.flush();
					out.close();
				}

			}
		} else {
			chain.doFilter(request, response);
		}
	}
	
	@Override
	public void destroy() {}
}

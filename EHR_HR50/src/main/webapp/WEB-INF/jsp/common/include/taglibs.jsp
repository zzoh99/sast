<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<%---------------------------------------- 화면 라이브러리 ----------------------------------------%>
<%@ taglib uri="http://www.springframework.org/tags" 		prefix="spring" %>
<%-- <%@ taglib uri="http://www.springframework.org/tags/form" 	prefix="form" %> --%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" 			prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" 			prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" 	prefix="fn" %>
<%-- <%@ taglib uri="http://www.anyframejava.org/tags" 			prefix="anyframe" %> --%>

<%@ taglib prefix="com" tagdir="/WEB-INF/tags/common" %>
<%@ taglib prefix="btn" tagdir="/WEB-INF/tags/button" %>
<%@ taglib prefix="msg" tagdir="/WEB-INF/tags/message" %>
<%@ taglib prefix="sht" tagdir="/WEB-INF/tags/sheet" %>
<%@ taglib prefix="tbl" tagdir="/WEB-INF/tags/table" %>
<%@ taglib prefix="tit" tagdir="/WEB-INF/tags/title" %>
<%@ taglib prefix="sch" tagdir="/WEB-INF/tags/search" %>

<%---------------------------------------- 화면 공통 변수 ----------------------------------------%>
<c:set var="sessionScope"	scope="session" />
<c:set var="packageName"	value="com.hr"/>
<c:set var="ctx" 			value="${pageContext.request.contextPath}"/>
<c:set var="localeResource" value="${ctx}/common/" />

<c:set var="contextroot" value="${pageContext.request.contextPath}" />
<c:if test="${(pageContext.request.scheme == 'http' && pageContext.request.serverPort != 80) ||
        (pageContext.request.scheme == 'https' && pageContext.request.serverPort != 443) }">
    <c:set var="port" value=":${pageContext.request.serverPort}" />
</c:if>
<c:set var="scheme" value="${(not empty header['x-forwarded-proto']) ? header['x-forwarded-proto'] : pageContext.request.scheme}" />
<c:set var="baseURL" value="${scheme}://${pageContext.request.serverName}${port}${contextroot}" />

<spring:eval var="front" expression="@environment.getProperty('vue.front.baseUrl')"/>
<%----------------------------------- 1a 개발확인용으로만  -----------------------------------%>
<c:set var="hostIp" 		value="${pageContext.request.remoteHost}"/>

<c:set var="hrm"		value="/hrfile/${sessionScope.ssnEnterCd}/hrm/" />
<c:set var="hri"		value="/hrfile/${sessionScope.ssnEnterCd}/hri/" />
<c:set var="cpn"		value="/hrfile/${sessionScope.ssnEnterCd}/cpn/" />
<c:set var="mail"		value="/hrfile/${sessionScope.ssnEnterCd}/mail/" />
<c:set var="pctr"       value="/hrfile/${sessionScope.ssnEnterCd}/picture/Thum/" />

<%@ page import="java.util.*" %>
<%@ page import="com.hr.common.util.StringUtil" %>
<%@ page import="javax.servlet.ServletContext" %>
<%@ page import="org.springframework.web.context.WebApplicationContext" %>
<%@ page import="org.springframework.web.context.support.WebApplicationContextUtils" %>
<%@ page import="com.hr.common.security.SecurityMgrService" %>

<%//=request.getAttribute("javax.servlet.forward.servlet_path") %>
<%//=request.getQueryString()%>
<%

	/*
	Enumeration eHeader = request.getHeaderNames();
	while (eHeader.hasMoreElements()) {
		String hName = (String)eHeader.nextElement();
		String hValue = request.getHeader(hName);
		System.out.println(hName + " : " + hValue);
	}
	*/

	String ssnSecurityYn = (String)session.getAttribute("ssnSecurityYn");
	String ssnSecurityDetail = (String)session.getAttribute("ssnSecurityDetail");
	//out.println("■ SSN_SECURITY_YN:" + ssnSecurityYn);
	//out.println("■ SSN_SECURITY_DETAIL:" + ssnSecurityDetail);

	String encPwConfirmYn = (String)request.getAttribute("encPwConfirmYn"); //비밀번호확인여부 암호, 비밀번호를 확인 했으면 이 값이 있음.
	String pwConfirmFwUrl = (String)request.getAttribute("pwConfirmFwUrl"); //실제 요청 url, forward 해서 request_uri가 다르게 나옴.

	//System.out.println("request_uri : "+ request.getAttribute("javax.servlet.forward.request_uri") );
	//out.println("<br>getQueryString : "+ request.getQueryString() );

	String sec_authPg = (String)request.getParameter("authPg");
	String sec_relUrl = request.getAttribute("javax.servlet.forward.request_uri") ==null ? "":(String)request.getAttribute("javax.servlet.forward.request_uri");
	String sec_qryStr = request.getAttribute("javax.servlet.forward.query_string") ==null ? "":(String)request.getAttribute("javax.servlet.forward.query_string");
	String sec_cmd = (String)request.getParameter("cmd");
	//out.println("<br>------> "+ sec_relUrl+"?" + sec_qryStr+"<br>");
	String searchOnlyMyself = "";
	
	String thisUrl = sec_relUrl + (sec_qryStr == "" ? "" : ("?"+ sec_qryStr));

	if( sec_relUrl == null ){ //서버가 재구동 되고 화면 새로고침을 하면 request_uri가 null 임
		response.sendRedirect("/Main.do");
		return;
	}

	if( sec_relUrl.equals("PwConCheck.do") ){
		sec_relUrl = pwConfirmFwUrl;
	}else{
		if( sec_cmd != null && sec_cmd.equals("boardRead")){ //예외...
			sec_relUrl += "?cmd=viewBoardRead";
		}else if( sec_cmd != null && !sec_cmd.equals("") ){
			sec_relUrl += "?" + sec_qryStr;
		}
	}
	if( !"/".equals(sec_relUrl.substring(0,1)) ) { sec_relUrl="/"+sec_relUrl; }

	// DB 연동을 위한 Bean 가져오기
	ServletContext servletContext = pageContext.getServletContext();
	WebApplicationContext wac = WebApplicationContextUtils.getRequiredWebApplicationContext(servletContext);
	SecurityMgrService svc = (SecurityMgrService)wac.getBean(SecurityMgrService.class);

	//out.println("■ ssnSecurityYn---> "+ ssnSecurityYn);
	//체크 안함
	boolean isSecCheck = true; //보안체크 여부

	String strRef = StringUtil.stringValueOf(request.getHeader("REFERER"));
	if(strRef.indexOf("Main.do")>0){
		isSecCheck = false;
	}else {
		if( sec_relUrl.indexOf("/Main.do") == 0
				|| sec_relUrl.indexOf("/Hr.do") == 0
				|| sec_relUrl.indexOf("/Board.do") == 0
				|| sec_relUrl.indexOf("/HelpPopup.do") == 0
				|| sec_relUrl.indexOf("/MboTargetReg.do") == 0
				|| sec_relUrl.indexOf("/MboTargetApr.do") == 0
				|| sec_relUrl.indexOf("/AppSelf.do") == 0
				|| sec_relUrl.indexOf("/App1st2nd.do") == 0
				|| sec_relUrl.indexOf("/EvaMain.do") == 0
				|| sec_relUrl.indexOf("/MltsrcEvlt.do") == 0 || sec_relUrl.indexOf("/MltsrcEvltSbjt.do") == 0
				|| sec_relUrl.indexOf("/Error.do") == 0 || sec_relUrl.indexOf("/Info.do") == 0  //에러페이지
				|| ( sec_relUrl.indexOf("/Popup.do") == 0 && ( sec_qryStr == null || sec_qryStr.equals("") ) )
				|| ( sec_relUrl.indexOf("/Popg.do") == 0 && ( sec_qryStr == null || sec_qryStr.equals("") ) )
				|| ( sec_relUrl.indexOf("/PwConForm.do") == 0 || sec_relUrl.indexOf("/PwConCheck.do") == 0 ) //비밀번호 확인 화면은 보안 체크 안함.
				|| sec_relUrl.indexOf("/getWidgetToHtml.do") == 0
				|| sec_relUrl.indexOf("/viewSearchUser.do") == 0
			){
				//out.println("■■ 보안체크 안함 ■■");
				isSecCheck = false;


			}
/*
			// 보안체크 Start ■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
			else if( ssnSecurityYn != null && "Y".equals(ssnSecurityYn) ){ //보안체크!


				//보안체크 여부, 강제URL 접근 여부 체크
				if( ssnSecurityDetail != null && ssnSecurityDetail.indexOf("U") > -1 ){

					Map<String, Object> sec_paramMap = new HashMap<String, Object>();
					sec_paramMap.put("token", request.getParameter("token"));
					sec_paramMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
					sec_paramMap.put("ssnGrpCd", session.getAttribute("ssnGrpCd"));
					sec_paramMap.put("relUrl", sec_relUrl);
					System.out.println("■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■");
					System.out.println("paramMap : "+sec_paramMap);
					System.out.println("■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■");

					Map<String, Object> sec_map = (Map<String, Object>)svc.chkAuth(sec_paramMap); // 보안 체크

					//out.println("<br>map : ["+sec_map+"]   <<<------ 널이면 잘못된 접근임!!!");
					if( ssnSecurityDetail != null && ssnSecurityDetail.indexOf("U") > -1 && ( sec_map == null || sec_map.get("token") == null )){
						session.setAttribute("errorUrl", sec_relUrl);
						response.sendRedirect("/SecurityError.do?code=995");  //★강제URL 접근 에러!!★
						return;
					}

					//프로그램 권한.
					if( sec_map != null && sec_map.get("dataPrgType") != null && sec_map.get("dataRwType") != null ){
						if( sec_map.get("dataPrgType").equals("P") ){
							sec_authPg = (String)sec_map.get("dataRwType");
						}else{
							sec_authPg = (String)session.getAttribute("ssnDataRwType");
						}
					}
				}

			}
*/

	}


	// 보안체크 End ■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■


	//AuthPg 가져오기 - 보안체크를 하지 않더라도 AuthPg 를 가져오기 위함.
	String url =request.getParameter("surl") ==null ? "" :String.valueOf(request.getParameter("surl"));
	String key =session.getAttribute("ssnEncodedKey") ==null ? "" :String.valueOf(session.getAttribute("ssnEncodedKey"));

	if( url.length() != 0 && key.length() != 0) {

		Map<String, Object> sec_rtn = (Map<String, Object>)svc.getDecryptUrl(url, key);

/*
		//보안체크 여부
		if( ssnSecurityYn != null && "Y".equals(ssnSecurityYn) && ssnSecurityDetail != null  && ssnSecurityDetail.indexOf("P") > -1 ){

			if( isSecCheck && sec_rtn == null  ){

				System.out.println("★★★★★★★★★★★★★sec_rtn:"+sec_rtn);
				session.setAttribute("errorUrl", sec_relUrl);
				response.sendRedirect("/SecurityError.do?code=993");  //★파라미터 변조 !!★
				return;
			}

			//String rtn_url = ((String)sec_rtn.get("url")).replace("#", "?");
			String rtn_url = (String)sec_rtn.get("url");
			if( isSecCheck && sec_rtn.get("url") != null && !"/".equals(rtn_url.substring(0,1)) ) { rtn_url="/"+rtn_url; }

			if( isSecCheck && sec_rtn.get("url") != null && !sec_relUrl.equals(rtn_url) ){ //★surl 변조 !!★

				System.out.println("★★★★★★★★★★★★★sec_relUrl:"+sec_relUrl);
				System.out.println("★★★★★★★★★★★★★rtn_url:"+rtn_url);
				session.setAttribute("errorUrl", sec_relUrl);
				response.sendRedirect("/SecurityError.do?code=993");
				return;
			}
		}
*/
		//메뉴에서 넘기는 AuthPg 값
		if( sec_rtn.get("dataPrgType") != null && sec_rtn.get("dataPrgType").equals("P")){  //프로그램 권한.
			sec_authPg = (String)sec_rtn.get("dataRwType");
		}else{
			sec_authPg = (String)session.getAttribute("ssnDataRwType");
		}

		searchOnlyMyself = "1".equals(sec_rtn.get("searchUseYn")) ? "Y" : "N";

		/**
		*    비밀번호 확인이 필요한 경우
		**/
		if( sec_rtn.get("popupUseYn") != null && ("Y".equals(sec_rtn.get("popupUseYn")) || "1".equals(sec_rtn.get("popupUseYn")) )){

			// encPwConfirmYn 값이 있으면 비밀번호 체크 한 것임.
			if( encPwConfirmYn != null ){
				Map<String, Object> pwMap = (Map<String, Object>)svc.getDecryptUrl(encPwConfirmYn, key);
				//System.out.println("★★★★★★★★★★★★★pwMap:"+pwMap);
				if( pwMap != null && pwMap.get("pwConfirmYn") != null && "Y".equals(pwMap.get("pwConfirmYn")) ){
					//비밀번호 확인 성공!!
				}else{
					pageContext.forward("/PwConForm.do?pwCheck=F"); //비밀번호가 틀린 경우
					return;
				}
			}else{
				pageContext.forward("/PwConForm.do");
				return;
			}
		}
	}
%>

<%---------------------------------------- 권한 설정 ----------------------------------------%>
<c:set var="authPg"			value="<%=sec_authPg%>" />
<c:set var="grpCd"			value="${sessionScope.ssnGrpCd}" />
<c:set var="tUrl"			value="<%=thisUrl%>" />
<%---------------------------------------- 조회가능범위 사용여부(searchUseYn 이였으나 충돌때문에 변경) ----------------------------------------%>
<c:set var="searchOnlyMyself"			value="<%=searchOnlyMyself%>" />
<%---------------------------------------- 팝업 설정[parent,top] ----------------------------------------%>
<c:set var="popUpStatus"  value="parent" />

<%---------------------------------------- 다국어 언어 설정 ----------------------------------------%>

<fmt:setLocale value="${ssnLocaleCd}" scope="session"/>

<%-------------------------------------- IBSheet 공통 필드 설정 ----------------------------------------%>

<c:set var="dataReadCnt"  value="22" />
<c:set var="sNoTy"  value="Seq" 	/><c:set var="sNoHdn"  value="0" /><c:set var="sNoWdt"  value="45" />

<c:choose>
	<c:when test="${authPg == 'A'}">
		<c:set var="textCss"	value="text" />
		<c:set var="dateCss"  	value="date2" />
		<c:set var="selectCss" 	value="" />
		<c:set var="readonly" 	value="" />
		<c:set var="disabled" 	value="" />
		<c:set var="editable" 	value="1" />

		<c:set var="sDelTy" value="DelCheck"/><c:set var="sDelHdn" value="0" /><c:set var="sDelWdt" value="55" />
		<c:set var="sRstTy" value="Result" 	/><c:set var="sRstHdn" value="1" /><c:set var="sRstWdt" value="0" />
		<c:set var="sSttTy" value="Status" 	/><c:set var="sSttHdn" value="0" /><c:set var="sSttWdt" value="45" />
	</c:when>
	<c:otherwise>
		<c:set var="textCss" 	value="text transparent" />
		<c:set var="dateCss" 	value="text transparent" />
		<c:set var="selectCss" 	value="transparent hideSelectButton " />
		<c:set var="readonly" 	value="readonly" />
		<c:set var="disabled" 	value="disabled" />
		<c:set var="editable" 	value="0" />

		<c:set var="sDelTy" value="DelCheck"/><c:set var="sDelHdn" value="1" /><c:set var="sDelWdt" value="0" />
		<c:set var="sRstTy" value="Result" 	/><c:set var="sRstHdn" value="1" /><c:set var="sRstWdt" value="0" />
		<c:set var="sSttTy" value="Status" 	/><c:set var="sSttHdn" value="1" /><c:set var="sSttWdt" value="0" />
	</c:otherwise>
</c:choose>

<%----------------------------------------호칭, 직위, 직급 컬럼 사용 설정 ----------------------------------------%>
<c:choose>
	<c:when test="${ssnAliasUseYn == 'Y'}">
		<c:set var="aliasHdn" value="0" />
	</c:when>
	<c:otherwise>
		<c:set var="aliasHdn" value="1" />
	</c:otherwise>
</c:choose>

<c:choose>
	<c:when test="${ssnJikweeUseYn == 'Y'}">
		<c:set var="jwHdn" value="0" />
	</c:when>
	<c:otherwise>
		<c:set var="jwHdn" value="1" />
	</c:otherwise>
</c:choose>

<c:choose>
	<c:when test="${ssnJikgubUseYn == 'Y'}">
		<c:set var="jgHdn" value="0" />
	</c:when>
	<c:otherwise>
		<c:set var="jgHdn" value="1" />
	</c:otherwise>
</c:choose>

<c:choose>
	<c:when test="${ssnLocaleCd !='' && ssnLangUseYn == 1}">
		<c:set var="sLanHdn" value="0" /><c:set var="sLanWdt" value="100" />
	</c:when>
	<c:otherwise>
		<c:set var="sLanHdn" value="1" /><c:set var="sLanWdt" value="100" />
	</c:otherwise>
</c:choose>

<c:choose>
	<c:when test="${ssnRetAgreeYn == 'YY'}">
		<c:set var="retAgreeHdn" value="YY" />
	</c:when>
	<c:when test="${ssnRetAgreeYn == 'YN'}">
		<c:set var="retAgreeHdn" value="YN" />
	</c:when>
	<c:when test="${ssnRetAgreeYn == 'NY'}">
		<c:set var="retAgreeHdn" value="NY" />
	</c:when>
	<c:otherwise>
		<c:set var="retAgreeHdn" value="NN" />
	</c:otherwise>
</c:choose>

<c:choose>
	<c:when test="${ssnRetSurveyYn == 'Y'}">
		<c:set var="retSurveyHdn" value="0" />
	</c:when>
	<c:otherwise>
		<c:set var="retSurveyHdn" value="1" />
	</c:otherwise>
</c:choose>

<%---------------------------------------- Jquery Tab  ----------------------------------------%>

<c:set var="maxTabCnt"  value="6" 	/>
<c:set var="fileSheetHeight"  value="100px" 	/>

<%---------------------------------------- JSTL Date  ----------------------------------------%>
<c:set var="now" value="<%=new java.util.Date()%>" />
<c:set var="curSysYyyyMMdd"><fmt:formatDate value="${now}" pattern="yyyyMMdd" /></c:set>
<c:set var="curSysYear">	<fmt:formatDate value="${now}" pattern="yyyy" /></c:set>
<c:set var="curSysMon">		<fmt:formatDate value="${now}" pattern="MM" /></c:set>
<c:set var="curSysDay">		<fmt:formatDate value="${now}" pattern="dd" /></c:set>
<c:set var="curSysYyyyMMddHyphen"><fmt:formatDate value="${now}" pattern="yyyy-MM-dd" /></c:set>
<c:set var="curSysYyyyMMHyphen"><fmt:formatDate value="${now}" pattern="yyyy-MM" /></c:set>

<%----------------------------------------  SMS ----------------------------------------%>
<c:set var="ssnSmsSender"  value="${ssnSmsSender}" 	/>

<%----------------------------------------  DOWNLOAD ----------------------------------------%>
<c:set var="ssnFileDownRegReason" value="${sessionScope.ssnFileDownRegReason}" />
<c:if test="${ empty ssnFileDownRegReason }"><c:set var="ssnFileDownRegReason" value="N" /></c:if>

<c:set var="ssnFileDownMobileYn" value="${sessionScope.ssnFileDownMobileYn}" />
<c:if test="${ empty ssnFileDownMobileYn }"><c:set var="ssnFileDownMobileYn" value="N" /></c:if>

<%------------------------------------------- RD -------------------------------------------%>
<spring:eval var="rdUrl" expression="@environment.getProperty('rd.url')"/>
<spring:eval var="rdMrd" expression="@environment.getProperty('rd.mrd')"/>
<spring:eval var="imageBaseUrl" expression="@environment.getProperty('rd.image.base.url')"/>
<spring:eval var="taxApiBaseUrl" expression="@environment.getProperty('taxApi.baseUrl')"/>
<c:if test="${pageContext.request.scheme == 'https' }">
	<c:set var="rdUrl" 			value='${rdUrl.replace("http:", "https:")}'/>
	<c:set var="rdMrd" 			value='${rdMrd.replace("http:", "https:")}'/>
	<c:set var="imageBaseUrl" 	value='${rdMrd.replace("http:", "https:")}'/>
</c:if>
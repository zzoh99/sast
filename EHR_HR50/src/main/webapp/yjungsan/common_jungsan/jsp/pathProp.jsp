<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="yjungsan.util.StringUtil"%>
<%@ page import="yjungsan.util.DateUtil"%>
<%
	//프로퍼티 설정.
	String sysVersion = StringUtil.getPropertiesValue("SYS.VERSION"); //시스템버전
	String sysEnc = StringUtil.getPropertiesValue("SYS.ENC"); //시스템 인코딩
	String javaVersion = StringUtil.getPropertiesValue("JAVA.VERSION"); //자바버전
	String serverBaseUrl = StringUtil.getBaseUrl(request); // 서버 url
	String jspPath = ""; //연말정산 jsp 루트
	String xmlPath = ""; //연말정산 xml 물리경로
	String yeaYear = ""; //연말정산 년도
	String imagePath = ""; //연말정산 이미지 루트
	String cacertPath = ""; //pdf 암호화 패스

	/* WORK UP 버전관리 추가 START */
	String cloudHr = StringUtil.getPropertiesValue("CLOUD.HR.YN"); // cloud HR 사용여부
	String cloudHrUrl = StringUtil.getPropertiesValue("CLOUD.HR.URL"); // cloud HR url
	/* WORK UP 버전관리 추가 END */

	//서현엔지니어링(SY_HR) 와 같이 JSP 앞에 컨텍스트가 있을경우 경로를 지정한다.
	//예)/SH_HR
	//세션이 끊어졌을때 각 세션 페이지에서 사용.
	String preJspPath = "";

	//시스템 버전(1 = ActiveX, 2=html)
	if("1".equals(sysVersion)) {
		String[] arrReqUri = request.getRequestURI().split("/");
		yeaYear = arrReqUri[3].replace("y_","");
		jspPath = "/JSP/yjungsan/"+arrReqUri[3]+"/jsp_jungsan";
		xmlPath = session.getServletContext().getRealPath("/JSP/yjungsan/y_"+yeaYear+"/xml_query");
		imagePath = "/JSP/yjungsan/common_jungsan/images";
		cacertPath = session.getServletContext().getRealPath("/JSP/yjungsan/common_jungsan/cacerts/");
	} else {
		String[] arrReqUri = request.getRequestURI().split("/");
		yeaYear = arrReqUri[2].replace("y_","");
		jspPath = "/yjungsan/"+arrReqUri[2]+"/jsp_jungsan";
		imagePath = "/yjungsan/common_jungsan/images";

		/* WORK UP 버전관리 추가 START */
		if ("Y".equals(cloudHr)) {
			// clour hr 경우 getRealPath 로 찾을수 없고 쿼리 파서에서 getResourceAsStream 로 변경.
			xmlPath = "/yjungsan/y_"+yeaYear+"/xml_query";
			cacertPath = "/yjungsan/common_jungsan/cacerts/";
		} else {
			xmlPath = session.getServletContext().getRealPath("/yjungsan/y_"+yeaYear+"/xml_query");
			cacertPath = session.getServletContext().getRealPath("/yjungsan/common_jungsan/cacerts/");
		}
		/* WORK UP 버전관리 추가 END */
	}
%>
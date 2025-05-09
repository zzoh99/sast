<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="yjungsan.util.StringUtil"%>
<%
	//프로퍼티 설정.
	String sysVersion = StringUtil.getPropertiesValue("SYS.VERSION"); //시스템버전
	String sysEnc = StringUtil.getPropertiesValue("SYS.ENC"); //시스템 인코딩
	String javaVersion = StringUtil.getPropertiesValue("JAVA.VERSION"); //자바버전
	String serverBaseUrl = StringUtil.getBaseUrl(request); // 서버 url
	String jspPath = ""; //주소변경 jsp 루트
	String xmlPath = ""; //주소변경 xml 물리경로
	String imagePath = ""; //주소변경 이미지 루트
	String cloudHr = StringUtil.getPropertiesValue("CLOUD.HR.YN"); // cloud HR 사용여부
	String cloudHrUrl = StringUtil.getPropertiesValue("CLOUD.HR.URL"); // cloud HR url


	//서현엔지니어링(SY_HR) 와 같이 JSP 앞에 컨텍스트가 있을경우 경로를 지정한다.
	//예)/SH_HR
	//세션이 끊어졌을때 각 세션 페이지에서 사용.
	String preJspPath = "";

	//시스템 버전(1 = ActiveX, 2=html)
	if("1".equals(sysVersion)) {
		jspPath = "/JSP/yjungsan/chgAddress/jsp_jungsan";
		xmlPath = session.getServletContext().getRealPath("/JSP/yjungsan/chgAddress/xml_query");
		imagePath = "/JSP/yjungsan/common_jungsan/images";
	} else {
		jspPath = "/yjungsan/chgAddress/jsp_jungsan";
		imagePath = "/yjungsan/common_jungsan/images";

		if ("Y".equals(cloudHr)) {
			// clour hr 경우 getRealPath 로 찾을수 없고 쿼리 파서에서 getResourceAsStream 로 변경.
			xmlPath = "/yjungsan/chgAddress/xml_query";
		} else {
			xmlPath = session.getServletContext().getRealPath("/yjungsan/chgAddress/xml_query");
		}
	}
%>
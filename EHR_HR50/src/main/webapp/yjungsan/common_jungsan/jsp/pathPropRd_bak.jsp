<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="yjungsan.util.StringUtil"%>
<%@ page import="yjungsan.util.DateUtil"%>
<%
	//RD 버전(1 = ActiveX, 2=html)
	String rdVersion = StringUtil.getPropertiesValue("RD.VERSION");
	String rdAliasName = StringUtil.getPropertiesValue("RD.ALIAS.NAME"); //RD alias

	//서버 베이스 URL
	String baseUrl = StringUtil.getBaseUrl(request);

	//RD 리포트 베이스 URL
	String rdBaseUrl = StringUtil.getPropertiesValue("RD.URL");

	//RD 리포트 패스정보(ROOT 기준)
	//activex : baseUrl/JSP/report/
	//html : baseUrl/html/report/
	String rdBasePath = baseUrl+"/html/report";

	//RD 리포트 멀티뷰어 URL(html 버전에서만 사용)
	String rdMultiViewerUrl = rdBaseUrl+"/DataServer/multiViewer";
	String rdJars = rdMultiViewerUrl+"/javard.jar,./lib/barbecue-1.5-beta1.jar,./lib/batik-all-flex.jar,./lib/ChartDirector_s.jar,./lib/enc.jar,./lib/iText-4.2.0-m2,./lib/jai_codec.jar,./lib/poi-3.2-FINAL-20081019.jar,./lib/plugin.jar,./lib/poi-scratchpad-3.2-FINAL-20081019.jar,./lib/swfutils.jar";

	//RD 리포트 에이전트 패스정보(ROOT 기준)
	//activex : /JSP/RDServer/rdagent.jsp
	//html : /DataServer/rdagent.jsp
	String rdAgentPath = "/DataServer/rdagent.jsp";

	//RD 스크립트 URL
	//activex : rdBaseUrl/JSP/include/IE_OCX/rd_inc.jsp?docId=rdViewer&width=100P&height=100P
	//html : rdBaseUrl/DataServer/rdViewer_all.js
	String rdScriptUrl = rdBaseUrl+"/DataServer/rdViewer_all.js";

	//RD에 들어갈 도장 이미지 URL
	//activex : 이노션(baseUrl/HTML/image/) 그외(baseUrl/HR_FILE/CORPORATION_IMAGE/HICAR/)
	//html : baseUrl/ImageDownloadTorg903.do?logoCd=2  (참고사항: html버전일경우 mrd 도장 수정해야함)
	//String rdStempImgUrl = baseUrl+"/yjungsan/common_jungsan/images/icon/"+session.getAttribute("ssnEnterCd")+"/";
    String rdStempImgUrl = baseUrl+"/OrgPhotoOut.do?logoCd=2&" ;

	//이노션용 스탬프 이미지 파일명(다른 사이트는 ""로 처리바람)
	String rdStempImgFile = "Stamp_Ingam.gif";

	//연말정산 mrd 위치
	String cpnYearEndPath = "cpn/yearEnd";

	if("1".equals(StringUtil.getPropertiesValue("SYS.VERSION"))) {
		cpnYearEndPath = "cpn/year_end_ad_total";
	}
%>
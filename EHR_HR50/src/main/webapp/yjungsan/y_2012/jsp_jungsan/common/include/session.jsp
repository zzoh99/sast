<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="yjungsan.util.StringUtil"%>
<%@ page import="yjungsan.util.DateUtil"%>
<%
	if(request.getCharacterEncoding() == null) {
		request.setCharacterEncoding(StringUtil.getPropertiesValue("SYS.ENC")) ;
	}
%>
<%@ include file="../../../../common_jungsan/jsp/pathProp.jsp" %>
<%
	//ibsheet 에서 넘어오믄 이값은 ibsheet, ajax로 넘어오면 이값은 ajax, null 이면 화면에서 넘어온것임
	String ibUserAgent = request.getHeader("IBUserAgent");

	//////////////////////////////세션체크////////////////////////////////////
	String chkEnterCd = "";
	String chkSysVersion = StringUtil.getPropertiesValue("SYS.VERSION"); 
	if("1".equals(chkSysVersion)) {
		chkEnterCd = (String)session.getAttribute("SESSION_ENTER_CD");
	} else {
		chkEnterCd = (String)session.getAttribute("ssnEnterCd");
	}
	
	if(chkEnterCd == null || chkEnterCd.length() == 0) {
		//세션이 없음
		if("ajax".equals(ibUserAgent) || "ibsheet".equals(ibUserAgent)) {
			//ajax로 넘어옴
			out.print("{\"Data\":{},\"Result\":{\"Code\":\"905\",\"Message\":\"세션이 종료되었습니다.\"}}");
			return;
		} else {
%>
<script type="text/javascript">
<!--
var chkSysVersion = "<%=chkSysVersion%>";
var reqPage = "";

if(chkSysVersion == "1") {
	reqPage = "<%=preJspPath%>/JSP/ErrorPage.jsp";
} else {
	alert("세션이 종료되었습니다.");
	reqPage = "<%=preJspPath%>/Login.do";
}

if(parent.parent != null && parent.parent.opener != null) {
	parent.parent.self.close();
	parent.parent.opener.top.location.href = reqPage;
}else if(parent.opener != null){
	parent.self.close();
	parent.opener.top.location.href = reqPage;
}else if(parent != null) {
	parent.location.href = reqPage;
}else{
	top.location.href = reqPage;
}
//-->
</script>
<%
			return;
		}
	}
	////////////////////////////////////////////////////////////////////////
	
	//시스템 버전에 따른 세션처리.(1:ActiveX, 2:html)
	if("1".equals(chkSysVersion)) {
		//if(session.getAttribute("ssnEnterCd") == null || session.getAttribute("ssnEnterCd").toString().length() == 0) {
			session.setAttribute("ssnEnterCd", session.getAttribute("SESSION_ENTER_CD"));
			session.setAttribute("ssnEnterNm", session.getAttribute("SESSION_ENTER_NM"));
			session.setAttribute("ssnSabun", session.getAttribute("SESSION_SABUN"));
			session.setAttribute("ssnName", session.getAttribute("SESSION_NAME"));
			session.setAttribute("ssnJikweeNm", session.getAttribute("SESSION_JIKWEE_NM"));
			session.setAttribute("ssnJikgubNm", session.getAttribute("SESSION_JIKGUB_NM"));
			session.setAttribute("ssnJikchakNm", session.getAttribute("SESSION_JIKCHAK_NM"));
			session.setAttribute("ssnOrgNm", session.getAttribute("SESSION_ORG_NM"));
			session.setAttribute("ssnOrgCd", session.getAttribute("SESSION_ORG_CD"));
			session.setAttribute("ssnGrpCd", session.getAttribute("SESSION_AUTHORITY_GROUP"));
			session.setAttribute("ssnSearchType", session.getAttribute("SESSION_SEARCH_TYPE"));
			//session.setAttribute("ssnBaseDate", session.getAttribute("SESSION_BASE_DATE"));
			//session.setAttribute("ssnSkinType", session.getAttribute("SESSION_SKIN_TYPE"));
			//session.setAttribute("ssnLastLogin", session.getAttribute("SESSION_LAST_LOGIN"));
		//}
	}

	String authPg = "";
	
	//권한관련 셋팅
	if(request.getParameter("authPg") != null && request.getParameter("authPg").length() != 0) {
		authPg = request.getParameter("authPg");
	} else {
		if("1".equals(chkSysVersion)) {
		    String dataPgGubun = request.getParameter("dataPgGubun") == null ? "P" : request.getParameter("dataPgGubun");
		    String progRw = request.getParameter("progRw") == null ? "R" : request.getParameter("progRw");
		    String dataAuthority = request.getParameter("dataAuthority");
			
		    //아닌경우 메뉴프로그램의 권한적용 우선순위로 권한을 정한다.
	        if( dataAuthority == null  || dataAuthority.length() == 0) {
	            if( "U".equals(dataPgGubun)) {
	                dataAuthority = (String)session.getAttribute("SESSION_AUTHORITY");
	            }
	            else {
	                dataAuthority = progRw;
	            }
	        }
	        authPg = dataAuthority;
		} else {
			authPg = "R";
		}
	}
	
	//읽기/쓰기 권한 아니면 무조건 쓰기권한
	if(!"A".equals(authPg)) authPg = "R";

	//권한에 따른 css 변수
	String popUpStatus = "parent";
	String sNoTy = "Seq";
	String sNoHdn = "0";
	String sNoWdt = "45";
	
	String textCss = "text";
	String dateCss = "date2";
	String readonly = "";
	String disabled = "";
	String editable = "1";
	String sDelTy = "DelCheck";
	String sDelHdn = "0";
	String sDelWdt = "45";
	String sRstTy = "Result";
	String sRstHdn = "1";
	String sRstWdt = "0";
	String sSttTy = "Status";
	String sSttHdn = "0";
	String sSttWdt = "45";
	
	if(!"A".equals(authPg)) {
		textCss = "text transparent";
		dateCss = "text transparent";
		readonly = "readonly";
		disabled = "disabled";
		editable = "0";
		sDelTy = "DelCheck";
		sDelHdn = "1";
		sDelWdt = "0";
		sRstTy = "Result";
		sRstHdn = "1";
		sRstWdt = "0";
		sSttTy = "Status";
		sSttHdn = "1";
		sSttWdt = "0";
	}

	//기본 날짜 설정.
	String curSysYyyyMMdd = yjungsan.util.DateUtil.getDateTime("yyyyMMdd");
	String curSysYear = yjungsan.util.DateUtil.getDateTime("yyyy");
	String curSysMon = yjungsan.util.DateUtil.getDateTime("MM");
	String curSysDay = yjungsan.util.DateUtil.getDateTime("dd");
	String curSysYyyyMMddHyphen = yjungsan.util.DateUtil.getDateTime("yyyy-MM-dd");
	String curSysYyyyMMHyphen = yjungsan.util.DateUtil.getDateTime("yyyy-MM");	
%>
<%@ include file="../../../../common_jungsan/jsp/pathPropRd.jsp" %>



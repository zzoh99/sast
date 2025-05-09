<%@page import="java.io.BufferedWriter"%>
<%@page import="java.io.FileWriter"%>
<%@page import="java.io.File"%>
<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="yjungsan.util.*"%>
<%@ page import="yjungsan.exception.*"%>
<%@ page import="java.sql.Connection"%>
<%@ page import="java.util.List"%>
<%@ page import="java.util.ArrayList"%>
<%@ page import="java.util.Map"%>
<%@ page import="java.util.HashMap"%>
<%@ page import="java.net.URLDecoder"%>
<%@ page import="java.io.*"%>

<%@ page import="com.hr.common.logger.Log" %>
<%@ include file="../common/include/session.jsp"%>

<%!
//xml 파서를 이용한 방법;
public Map setQueryMap(String path) {
	return XmlQueryParser.getQueryMap(path);
}

//지방세 조회
public List selectEarnIncomeRtaxDataMgrList(Map paramMap, Map queryMap) throws Exception {

	//파라메터 복사.
	Map pm =  StringUtil.getParamMapData(paramMap);
	List listData = null;

	try{
		//쿼리 실행및 결과 받기.
		listData  = (queryMap == null) ? null : DBConn.executeQueryList(queryMap,"selectEarnIncomeRtaxDataMgrList",pm);
	} catch (Exception e) {
		Log.Error("[Exception] " + e);
		throw new Exception("조회에 실패하였습니다.");
	}

	return listData;
}

%>

<%
	//쿼리 맵 셋팅
	Map queryMap = setQueryMap(xmlPath+"/earnIncomeRtaxDataMgr/EarnIncomeRtaxDataMgr.xml");
	String ssnEnterCd = (String)session.getAttribute("ssnEnterCd");
	String ssnSabun = (String)session.getAttribute("ssnSabun");
	String cmd = (String)request.getParameter("cmd");
	

	if("selectEarnIncomeRtaxDataMgrList".equals(cmd)) {
		Map mp = StringUtil.getRequestMap(request);
		Map paramMap =  StringUtil.getParamMapData(mp);
		
		String taxDocNo = (String)paramMap.get("taxDocNo");
		String locationCd = (String)paramMap.get("locationCd");

		mp.put("ssnEnterCd", ssnEnterCd);
		mp.put("ssnSabun", ssnSabun);
		mp.put("taxDocNo", taxDocNo);
		mp.put("locationCd", locationCd);
		
		List listData  = new ArrayList();
		String message = "";
		String code = "1";
		try {
			listData = selectEarnIncomeRtaxDataMgrList(mp, queryMap);
		} catch(Exception e) {
			code = "-1";
			message = e.getMessage();
		}
		Map mapCode = new HashMap();
		mapCode.put("Code", code);
		mapCode.put("Message", message);
		Map rstMap = new HashMap();
		rstMap.put("Result", mapCode);
		rstMap.put("Data", (List)listData);
		out.print((new org.json.JSONObject(rstMap)).toString());
	}
%>
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
/* public void setQueryMap(String path) {
	queryMap = XmlQueryParser.getQueryMap(path);
} */

//원천징수영수증 대상자 조회
public List selectEarnIncomeCreDataMgrList(String path, Map paramMap) throws Exception {
	Map queryMap = XmlQueryParser.getQueryMap(path);
	//파라메터 복사.
	Map pm =  StringUtil.getParamMapData(paramMap);
	List listData = null;

	try{
		//쿼리 실행및 결과 받기.
		listData  = (queryMap == null) ? null : DBConn.executeQueryList(queryMap,"selectEarnIncomeCreDataMgrList",pm);
	} catch (Exception e) {
		Log.Error("[Exception] " + e);
		throw new Exception("조회에 실패하였습니다.");
	}

	return listData;
}

//원천칭수이행상황신고서 문서번호 목록 조회
public List selectEarnIncomeTaxDocNoCodeList(String path, Map paramMap) throws Exception {
	Map queryMap = XmlQueryParser.getQueryMap(path);
	//파라메터 복사.
	Map pm =  StringUtil.getParamMapData(paramMap);
	List listData = null;

	try{
		//쿼리 실행및 결과 받기.
		listData  = (queryMap == null) ? null : DBConn.executeQueryList(queryMap,"selectEarnIncomeTaxDocNoCodeList",pm);
	} catch (Exception e) {
		Log.Error("[Exception] " + e);
		throw new Exception("조회에 실패하였습니다.");
	}

	return listData;
}

%>

<%
	//쿼리 맵 셋팅
	//setQueryMap(xmlPath+"/earnIncomeCreDataMgr/EarnIncomeCreDataMgr.xml");
	String ssnEnterCd = (String)session.getAttribute("ssnEnterCd");
	String ssnSabun = (String)session.getAttribute("ssnSabun");
	String cmd = (String)request.getParameter("cmd");
	
	if("selectEarnIncomeCreDataMgrList".equals(cmd)) {
		Map mp = StringUtil.getRequestMap(request);
		Map paramMap =  StringUtil.getParamMapData(mp);
		
		String taxDocNo = (String)paramMap.get("taxDocNo");
		String businessPlaceCd = (String)paramMap.get("businessPlaceCd");
		String sabunName = (String)paramMap.get("sabunName");

		mp.put("ssnEnterCd", ssnEnterCd);
		mp.put("ssnSabun", ssnSabun);
		mp.put("taxDocNo", taxDocNo);
		mp.put("businessPlaceCd", businessPlaceCd);
		mp.put("sabunName", sabunName);
		
		List listData  = new ArrayList();
		String message = "";
		String code = "1";
		try {
			listData = selectEarnIncomeCreDataMgrList(xmlPath+"/earnIncomeCreDataMgr/EarnIncomeCreDataMgr.xml", mp);
		} catch(Exception e) {
			code = "-1";
			message = e.getMessage();
		}
		Map mapCode = new HashMap();
		mapCode.put("Code", code);
		mapCode.put("Message", message);
		Map rstMap = new HashMap();
		rstMap.put("Result", mapCode);
		rstMap.put("Data", listData == null ? null : (List)listData);
		out.print((new org.json.JSONObject(rstMap)).toString());
	} else if("selectEarnIncomeTaxDocNoCodeList".equals(cmd)) {
		Map mp = StringUtil.getRequestMap(request);
		mp.put("ssnEnterCd", ssnEnterCd);
		mp.put("ssnSabun", ssnSabun);
		List listData  = new ArrayList();
		String message = "";
		String code = "1";
		try {
			listData = selectEarnIncomeTaxDocNoCodeList(xmlPath+"/earnIncomeCreDataMgr/EarnIncomeCreDataMgr.xml", mp);
		} catch(Exception e) {
			code = "-1";
			message = e.getMessage();
		}
		Map mapCode = new HashMap();
		mapCode.put("Code", code); //ajax 성공코드 1번, 그외 오류
		mapCode.put("Message", message);
		Map rstMap = new HashMap();
		rstMap.put("Result", mapCode);
		rstMap.put("codeList", listData == null ? null : (List)listData);
		out.print((new org.json.JSONObject(rstMap)).toString());
	}
%>
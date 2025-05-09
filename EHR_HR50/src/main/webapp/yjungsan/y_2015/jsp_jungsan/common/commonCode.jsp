<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="yjungsan.util.*"%>
<%@ page import="java.util.List"%>
<%@ page import="java.util.ArrayList"%>
<%@ page import="java.util.Map"%>
<%@ page import="java.util.HashMap"%>

<%@ page import="org.json.JSONObject" %>
<%@ page import="com.hr.common.logger.Log" %>
<%@ include file="../common/include/session.jsp"%>

<%!

//공통코드 검색
public List getCommonCodeList(String orderBy, Map paramMap, String locPath) throws Exception {

	//파라메터 복사.
	Map pm =  StringUtil.getParamMapData(paramMap);
	Map queryMap = XmlQueryParser.getQueryMap(locPath);
	List list = null;
	
	try{
		//dynamic query 보안 이슈 때문에 수정
		if ( orderBy == null || "".equals(orderBy) ) {
			pm.put("orderBy", "0");
		} else {
			pm.put("orderBy", "1");
		}
		
		//쿼리 실행및 결과 받기.
		list  = (queryMap == null) ? null : DBConn.executeQueryList(queryMap, "getCommonCodeList", pm);
	} catch (Exception e) {
		Log.Error("[Exception] \n" + e);
		throw new Exception();
	} finally {
		queryMap = null;
	}
	
	return list;
}

//공통코드 기타 검색
public List getCommonNSCodeList(String queryId, Map paramMap, String locPath) throws Exception {

	//파라메터 복사.
	Map pm =  StringUtil.getParamMapData(paramMap);
	Map queryMap = XmlQueryParser.getQueryMap(locPath);
	List list = null;
	
	try{
		//쿼리 실행및 결과 받기.
		list  = (queryMap == null) ? null : DBConn.executeQueryList(queryMap, queryId, pm);
	} catch (Exception e) {
		Log.Error("[Exception] \n" + e);
		throw new Exception();
	} finally {
		queryMap = null;
	}
	
	return list;
}

//대상자(보험료, 기부금, 의료비, 신용카드) 조회
public List getFamCodeList(String queryId, Map paramMap, String locPath) throws Exception {

	//파라메터 복사.
	Map pm =  StringUtil.getParamMapData(paramMap);
	Map queryMap = XmlQueryParser.getQueryMap(locPath);
	List list = null;
	
	try{
		//쿼리 실행및 결과 받기.
		list  = (queryMap == null) ? null : DBConn.executeQueryList(queryMap, queryId, pm);
	} catch (Exception e) {
		Log.Error("[Exception] \n" + e);
		throw new Exception();
	} finally {
		queryMap = null;
	}
	
	return list;
}

//대상자(교육) 조회
public List getFamCodeEduList(String queryId, Map paramMap, String locPath) throws Exception {

	//파라메터 복사.
	Map pm =  StringUtil.getParamMapData(paramMap);
	Map queryMap = XmlQueryParser.getQueryMap(locPath);
	List list = null;
	
	try{
		//쿼리 실행및 결과 받기.
		list  = (queryMap == null) ? null : DBConn.executeQueryList(queryMap, queryId, pm);
	} catch (Exception e) {
		Log.Error("[Exception] \n" + e);
		throw new Exception();
	} finally {
		queryMap = null;
	}
	
	return list;
}

//대상자(카드) 조회
public List getFamCodeCardList(String queryId, Map paramMap, String locPath) throws Exception {

	//파라메터 복사.
	Map pm =  StringUtil.getParamMapData(paramMap);
	Map queryMap = XmlQueryParser.getQueryMap(locPath);
	List list = null;
	
	try{
		//쿼리 실행및 결과 받기.
		list  = (queryMap == null) ? null : DBConn.executeQueryList(queryMap, queryId, pm);
	} catch (Exception e) {
		Log.Error("[Exception] \n" + e);
		throw new Exception();
	} finally {
		queryMap = null;
	}
	
	return list;
}

//신용카드구분(카드) 조회
public List getCardTypeCodeList(String orderBy, Map paramMap, String locPath) throws Exception {

	//파라메터 복사.
	Map pm =  StringUtil.getParamMapData(paramMap);
	Map queryMap = XmlQueryParser.getQueryMap(locPath);
	List list = null;
	
	try{
		//dynamic query 보안 이슈 때문에 수정
// 		if ( orderBy == null || "".equals(orderBy) ) {
// 			pm.put("orderBy", "ORDER BY USE_YN DESC, SEQ, CODE, CODE_NM ");
// 		} else {
// 			pm.put("orderBy", "ORDER BY CODE_NM ");
// 		}
		
		//쿼리 실행및 결과 받기.
		list  = (queryMap == null) ? null : DBConn.executeQueryList(queryMap, "getCardTypeCodeList", pm);
	} catch (Exception e) {
		Log.Error("[Exception] \n" + e);
		throw new Exception();
	} finally {
		queryMap = null;
	}
	
	return list;
}
%>

<%
	String locPath = xmlPath+"/common/commonCode.xml";

	String ssnEnterCd = (String)session.getAttribute("ssnEnterCd");
	String ssnSabun = (String)session.getAttribute("ssnSabun");
	String cmd = (String)request.getParameter("cmd");
	String queryId = (String)request.getParameter("queryId");
	String orderBy = (String)request.getParameter("orderBy");
	String visualYn = StringUtil.nvl((String)request.getParameter("visualYn"));
	String useYn = StringUtil.nvl((String)request.getParameter("useYn"));
	String note1 = StringUtil.nvl((String)request.getParameter("note1"));
	
	Map mp = StringUtil.getRequestMap(request);
	mp.put("ssnEnterCd", ssnEnterCd);
	mp.put("ssnSabun", ssnSabun);
	
	List listData  = new ArrayList();
	String message = "";
	String code = "1";

	if("getCommonCodeList".equals(cmd)) {
		mp.put("visualYn", visualYn);
		mp.put("useYn", useYn);
		
		try {
			listData = getCommonCodeList(orderBy, mp, locPath);
		} catch(Exception e) {
			code = "-1";
			message = "공통 코드 조회중 오류가 발생하였습니다.";
		}
	} else if("getCommonNSCodeList".equals(cmd)) {
		try {
			listData = getCommonNSCodeList(queryId, mp, locPath);
		} catch(Exception e) {
			code = "-1";
			message = "공통 코드 조회중 오류가 발생하였습니다.";
		}
	} else if("getFamCodeList".equals(cmd)) {
		/*
			보험료, 기부금 : 부양가족만 조회
			의료비 : 가족전체
		*/
		try {
			listData = getFamCodeList(queryId, mp, locPath);
		} catch(Exception e) {
			code = "-1";
			message = "대상자 조회중 오류가 발생하였습니다.";
		}
	} else if("getFamCodeEduList".equals(cmd)) {
		/*
			교육비 : 교육비 공제 대상자
		*/
		try {
			listData = getFamCodeEduList(queryId, mp, locPath);
		} catch(Exception e) {
			code = "-1";
			message = "대상자(교육) 조회중 오류가 발생하였습니다.";
		}
	} else if("getFamCodeCardList".equals(cmd)) {
		/*
			신용카드 : 가족중 형제자매 제외
		*/
		try {
			listData = getFamCodeCardList(queryId, mp, locPath);
		} catch(Exception e) {
			code = "-1";
			message = "대상자(카드) 조회중 오류가 발생하였습니다.";
		}
	} else if("getCardTypeCodeList".equals(cmd)) {
		mp.put("useYn", useYn);
		mp.put("note1", note1);
		
		try {
			listData = getCardTypeCodeList(orderBy, mp, locPath);
		} catch(Exception e) {
			code = "-1";
			message = "공통 코드 조회중 오류가 발생하였습니다.";
		}
	}
	Map mapCode = new HashMap();
	mapCode.put("Code", code); //ajax 성공코드 1번, 그외 오류
	mapCode.put("Message", message);
	
	Map rstMap = new HashMap();
	rstMap.put("Result", mapCode);
	rstMap.put("codeList", listData == null ? null : (List)listData);
	
	out.print((new org.json.JSONObject(rstMap)).toString());
%>

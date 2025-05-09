<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="yjungsan.util.*"%>
<%@ page import="yjungsan.exception.*"%>
<%@ page import="java.sql.Connection"%>
<%@ page import="java.util.List"%>
<%@ page import="java.util.ArrayList"%>
<%@ page import="java.util.Map"%>
<%@ page import="java.util.HashMap"%>
<%@ page import="java.net.URLDecoder"%>
 
<%@ page import="org.json.JSONObject" %>
<%@ page import="com.hr.common.logger.Log" %>
<%@ include file="../common/include/session.jsp"%>

<%!
//작업현황조회
public Map selectYeaCalcProcessStatusPopupInfo(Map paramMap, String locPath) throws Exception {

	//파라메터 복사.
	Map pm =  StringUtil.getParamMapData(paramMap);
	Map queryMap = XmlQueryParser.getQueryMap(locPath);
	Map mp = null;
	
	String searchBusinessCd = String.valueOf(pm.get("searchBusinessCd"));	

	StringBuffer query   = new StringBuffer();
	StringBuffer queryA   = new StringBuffer();
	StringBuffer queryB   = new StringBuffer();
	StringBuffer queryG   = new StringBuffer();
	StringBuffer queryH  = new StringBuffer();
	
	query.setLength(0);
	queryA.setLength(0);
	queryB.setLength(0);
	queryG.setLength(0);
	queryH.setLength(0);
	
	if(searchBusinessCd.trim().length() != 0){
		query.append(" AND BUSINESS_PLACE_CD = #searchBusinessCd#");
		queryA.append(" AND A.BUSINESS_PLACE_CD = #searchBusinessCd#");
		queryB.append(" AND B.BUSINESS_PLACE_CD = #searchBusinessCd#");
		queryG.append(" AND G.BUSINESS_PLACE_CD = #searchBusinessCd#");
		queryH.append(" AND H.BUSINESS_PLACE_CD = #searchBusinessCd#");
	}

	pm.put("query", query.toString());
	pm.put("queryA", queryA.toString());
	pm.put("queryB", queryB.toString());
	pm.put("queryG", queryG.toString());
	pm.put("queryH", queryH.toString());
	
	try{
		//쿼리 실행및 결과 받기.
		mp  = (queryMap==null) ? null : DBConn.executeQueryMap(queryMap,"selectYeaCalcProcessStatusPopupInfo",pm);
	} catch (Exception e) {
		Log.Error("[Exception] " + e);
		throw new Exception("조회에 실패하였습니다.");
	} finally {
		queryMap = null;
	}
	
	return mp;
}

//연말정산 작업현황 팝업 대상자 및 옵션 내역 조회
public List selectYeaCalcProcessStatusPopupDetail(String queryId, Map paramMap, String locPath) throws Exception {

	//파라메터 복사.
	Map pm =  StringUtil.getParamMapData(paramMap);
	Map queryMap = XmlQueryParser.getQueryMap(locPath);
	List list = null;
	
	String searchBusinessCd = String.valueOf(pm.get("searchBusinessCd"));	
		
	StringBuffer query  = new StringBuffer();
	StringBuffer queryA = new StringBuffer();
	StringBuffer queryB = new StringBuffer();
	StringBuffer queryH = new StringBuffer();	
	
	query.setLength(0);
	queryA.setLength(0);
	queryB.setLength(0);
	queryH.setLength(0);
	
System.out.println(" [ 1차 length ] ==============       "+searchBusinessCd.trim().length());
	if(searchBusinessCd.trim().length() != 0){

System.out.println(" [ 2차 length ] ==============       "+searchBusinessCd.trim().length());			
		if("selectBfComTargetList".equals(queryId) || "selectCardYTargetList".equals(queryId) || "selectPdfYTargetList".equals(queryId)){
			query.append(" AND C.BUSINESS_PLACE_CD = #searchBusinessCd#");				
		}
		if("selectPdfNTargetList".equals(queryId) || "selectCardNTargetList".equals(queryId) || "selectMonpayManTargetList".equals(queryId)){
			queryA.append(" AND A.BUSINESS_PLACE_CD = #searchBusinessCd#");				
			queryH.append(" AND H.BUSINESS_PLACE_CD = #searchBusinessCd#");				
		}	
		if("selectMinusTargetList".equals(queryId) || "selectPointTargetList".equals(queryId) ){
			queryB.append(" AND B.BUSINESS_PLACE_CD = #searchBusinessCd#");				
		}
		if("selectAddrYTargetList".equals(queryId)    || "selectAddrNTargetList".equals(queryId)       || "selectPerYTargetList".equals(queryId)
		|| "selectPerNTargetList".equals(queryId)     || "selectInputCloseYTargetList".equals(queryId) || "selectInputCloseNTargetList".equals(queryId)
		|| "selectApprvYTargetList".equals(queryId)   || "selectApprvNTargetList".equals(queryId)      || "selectConfirmYTargetList".equals(queryId)
		|| "selectConfirmNTargetList".equals(queryId) || "selectFinalCloseNTargetList".equals(queryId) || "selectTaxYTargetList".equals(queryId)
		|| "selectTaxNTargetList".equals(queryId)     || "selectManTargetList".equals(queryId) ){
			queryA.append(" AND A.BUSINESS_PLACE_CD = #searchBusinessCd#");				
		}

	}

	pm.put("query", query.toString());
	pm.put("queryA", queryA.toString());
	pm.put("queryB", queryB.toString());
	pm.put("queryH", queryH.toString());	
	try{
		//쿼리 실행및 결과 받기.
		list  = (queryMap == null) ? null : DBConn.executeQueryList(queryMap, queryId, pm);
	} catch (Exception e) {
		Log.Error("[Exception] \n" + e);
		throw new Exception("조회에 실패하였습니다.");
	} finally {
		queryMap = null;
	}
	
	return list;
}

%>

<%
	String locPath = xmlPath+"/yeaCalcCre/yeaCalcProcessStatusPopup.xml";

	String ssnEnterCd = (String)session.getAttribute("ssnEnterCd");
	String ssnSabun = (String)session.getAttribute("ssnSabun");
	String cmd = (String)request.getParameter("cmd");
	String queryId = (String)request.getParameter("queryId");
	
	Map mp = StringUtil.getRequestMap(request);
	mp.put("ssnEnterCd", ssnEnterCd);
	mp.put("ssnSabun", ssnSabun);
	
	String message = "";
	String code = "1";

	if("selectYeaCalcProcessStatusPopupInfo".equals(cmd)) {
		//연말정산 급여코드 조회
		Map mapData  = new HashMap();
		try {
			mapData = selectYeaCalcProcessStatusPopupInfo(mp, locPath);
		} catch(Exception e) {
			code = "-1";
			message = e.getMessage();
		}
		
		Map mapCode = new HashMap();
		mapCode.put("Code", code);
		mapCode.put("Message", message);
		
		Map rstMap = new HashMap();
		rstMap.put("Result", mapCode);
		rstMap.put("Data", (Map)mapData);
		out.print((new org.json.JSONObject(rstMap)).toString());
		
	} else if("selectYeaCalcProcessStatusPopupDetail".equals(cmd)) {
		//연말정산 작업현황 팝업 대상자 및 옵션 내역 조회
		List listData  = new ArrayList();
		try {
			listData = selectYeaCalcProcessStatusPopupDetail(queryId, mp, locPath);
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
		
	}
	
%>
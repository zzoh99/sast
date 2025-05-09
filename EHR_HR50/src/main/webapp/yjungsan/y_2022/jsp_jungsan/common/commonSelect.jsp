<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="yjungsan.util.*"%>
<%@ page import="yjungsan.exception.*"%>
<%@ page import="java.sql.Connection"%>
<%@ page import="java.util.List"%>
<%@ page import="java.util.ArrayList"%>
<%@ page import="java.util.Map"%>
<%@ page import="java.util.HashMap"%>

<%@ page import="org.json.JSONObject" %>
<%@ page import="com.hr.common.logger.Log" %>
<%@ include file="../common/include/session.jsp"%>
<%!

public List selectCommonSelectList(Map paramMap, String locPath) throws Exception {

	//파라메터 복사.
	Map pm =  StringUtil.getParamMapData(paramMap);
	Map queryMap = XmlQueryParser.getQueryMap(locPath);	
	String queryId = (String)pm.get("queryId");
	List list = null;

	try{
		//쿼리 실행및 결과 받기.
		list  = (queryMap == null) ? null : DBConn.executeQueryList(queryMap, queryId, pm);
	} catch (Exception e) {
		Log.Error("[Exception] " + e);
		throw new Exception("조회에 실패하였습니다.");
	} finally {
		queryMap = null;
	}

	return list;
}

public Map selectCommonSelectMap(Map paramMap, String locPath) throws Exception {

	//파라메터 복사.
	Map pm =  StringUtil.getParamMapData(paramMap);
	Map queryMap = XmlQueryParser.getQueryMap(locPath);
	String queryId = (String)pm.get("queryId");
	Map mp = null;

	try{
		//쿼리 실행및 결과 받기.
		mp  = (queryMap == null) ? null : DBConn.executeQueryMap(queryMap, queryId, pm);
	} catch (Exception e) {
		Log.Error("[Exception] " + e);
		throw new Exception("조회에 실패하였습니다.");
	} finally {
		queryMap = null;
	}

	return mp;
}
%>

<%
	String locPath = xmlPath+"/common/commonSelect.xml";

	String ssnEnterCd = (String)session.getAttribute("ssnEnterCd");
	String ssnSabun = (String)session.getAttribute("ssnSabun");
	String ssnOrgCd = (String)session.getAttribute("ssnOrgCd");
	String ssnGrpCd = (String)session.getAttribute("ssnGrpCd");
	String ssnSearchType = (String)session.getAttribute("ssnSearchType");
	String cmd = (String)request.getParameter("cmd");

	Map mp = StringUtil.getRequestMap(request);
	mp.put("ssnEnterCd", ssnEnterCd);
	mp.put("ssnSabun", ssnSabun);
	mp.put("ssnOrgCd", ssnOrgCd);
	mp.put("ssnGrpCd", ssnGrpCd);
	mp.put("ssnSearchType", ssnSearchType);
	mp.put("yeaYear", yeaYear); //연말정산 기준년도(현재폴더의 년도)

	if("commonSelectList".equals(cmd)) {

		List listData  = new ArrayList();
		String message = "";
		String code = "1";

		try {
			listData = selectCommonSelectList(mp, locPath);
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

	} else if("commonSelectMap".equals(cmd)) {

		Map mapData  = new HashMap();
		String message = "";
		String code = "1";

		try {
			mapData = selectCommonSelectMap(mp, locPath);
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
	}
%>
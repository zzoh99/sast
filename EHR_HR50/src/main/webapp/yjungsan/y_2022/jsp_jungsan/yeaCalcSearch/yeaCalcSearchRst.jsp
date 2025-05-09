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
<%@ include file="../auth/saveLog.jsp"%>
<%!
//정산계산내역조회 검색
public List selectYeaCalcSearch(Map paramMap, String locPath, String ssnYeaLogYn) throws Exception {

	//파라메터 복사.
	Map pm =  StringUtil.getParamMapData(paramMap);
	Map queryMap = XmlQueryParser.getQueryMap(locPath);
	List list = null;

	try{
		//쿼리 실행및 결과 받기.

		if(pm.get("searchPage") != null && !"".equals(pm.get("searchPage").toString()) ) {

			int divPage = pm.get("searchDivPage") == null ? 100 : Integer.valueOf(pm.get("searchDivPage").toString());
			int page = Integer.valueOf(pm.get("searchPage").toString());
			int stNum = (page -1) * divPage + 1;
			int edNum = page * divPage;

			pm.put("stNum", stNum+"");
			pm.put("edNum", edNum+"");

			list = (queryMap == null) ? null : DBConn.executeQueryList(queryMap,"selectYeaCalcSearchPaging",pm);

		} else {
			list = (queryMap == null) ? null : DBConn.executeQueryList(queryMap,"selectYeaCalcSearch",pm);
		}
		saveLog(null, pm, ssnYeaLogYn);
	} catch (Exception e) {
		Log.Error("[Exception] " + e);
		throw new Exception("조회에 실패하였습니다.");
	} finally {
		queryMap = null;
	}

	return list;
}

public Map selectYeaCalcSearchTotCnt(Map paramMap, String locPath) throws Exception {

	//파라메터 복사.
	Map pm =  StringUtil.getParamMapData(paramMap);
	Map queryMap = XmlQueryParser.getQueryMap(locPath);
	Map map = null;

	try{
		//쿼리 실행및 결과 받기.
		map  = (queryMap==null) ? null : DBConn.executeQueryMap(queryMap,"selectYeaCalcSearchTotCnt",pm);
	} catch (Exception e) {
		Log.Error("[Exception] " + e);
		throw new Exception("조회에 실패하였습니다.");
	} finally {
		queryMap = null;
	}

	return map;
}

%>

<%
	String locPath = xmlPath+"/yeaCalcSearch/yeaCalcSearch.xml";

	String message = "";
	String code = "1";

	String ssnEnterCd = (String)session.getAttribute("ssnEnterCd");
	String ssnSabun = (String)session.getAttribute("ssnSabun");
	String ssnYeaLogYn = (String)session.getAttribute("ssnYeaLogYn");
	String cmd = (String)request.getParameter("cmd");

	Map mp = StringUtil.getRequestMap(request);
	mp.put("ssnEnterCd", ssnEnterCd);
	mp.put("ssnSabun", ssnSabun);
	mp.put("cmd", cmd);
	if("selectYeaCalcSearch".equals(cmd)) {
		//정산계산내역조회 조회
		List listData  = new ArrayList();

		try {
			listData = selectYeaCalcSearch(mp, locPath, ssnYeaLogYn);
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

	} else if("selectYeaCalcSearchTotCnt".equals(cmd)) {
		Map mapData  = new HashMap();
		try {
			mapData = selectYeaCalcSearchTotCnt(mp, locPath);
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
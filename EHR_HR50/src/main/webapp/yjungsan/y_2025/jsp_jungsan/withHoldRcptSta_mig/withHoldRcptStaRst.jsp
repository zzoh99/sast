<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="yjungsan.util.*"%>
<%@ page import="yjungsan.exception.*"%>
<%@ page import="java.sql.Connection"%>
<%@ page import="java.util.List"%>
<%@ page import="java.util.ArrayList"%>
<%@ page import="java.util.Map"%>
<%@ page import="java.util.HashMap"%>
<%@ page import="java.net.URLDecoder"%>

<%@ page import="com.hr.common.logger.Log" %>
<%@ include file="../common/include/session.jsp"%>
<%@ include file="../auth/saveLog.jsp"%>
<%!
//원천징수영수증 대상자 조회
public List selectWithHoldRcptStaList(Map paramMap, String locPath, String ssnYeaLogYn) throws Exception {

	//파라메터 복사.
	Map pm =  StringUtil.getParamMapData(paramMap);
	//xml 파서를 이용한 방법;
	Map queryMap = XmlQueryParser.getQueryMap(locPath);
	List listData = null;

	//쿼리 실행및 결과 받기.
	try{
		if(pm.get("searchPage") != null && !"".equals(pm.get("searchPage").toString()) ) {

			int divPage = pm.get("searchDivPage") == null ? 100 : Integer.valueOf(pm.get("searchDivPage").toString());
			int page = Integer.valueOf(pm.get("searchPage").toString());
			int stNum = (page -1) * divPage + 1;
			int edNum = page * divPage;

			pm.put("stNum", stNum+"");
			pm.put("edNum", edNum+"");

			listData = (queryMap == null) ? null : DBConn.executeQueryList(queryMap,"selectWithHoldPaging",pm);

		} else {
			listData  = (queryMap == null) ? null : DBConn.executeQueryList(queryMap,"selectWithHoldRcptStaList",pm);
		}
		saveLog(null, pm, ssnYeaLogYn);

	} catch (Exception e) {
		Log.Error("[Exception] " + e);
		throw new Exception("조회에 실패하였습니다.");
	} finally {
		queryMap = null;
	}
	
	return listData;
}

//원천징수영수증 업로드시 사원정보 조회
public Map selectEmpInfoUsingSabun(Map paramMap, String locPath) throws Exception {

	//파라메터 복사.
	Map pm =  StringUtil.getParamMapData(paramMap);
	//xml 파서를 이용한 방법;
	Map queryMap = XmlQueryParser.getQueryMap(locPath);
	Map map = null;

	try{
		//쿼리 실행및 결과 받기.
		pm  = (queryMap==null) ? null : DBConn.executeQueryMap(queryMap,"selectEmpInfoUsingSabun",pm);
	} catch (Exception e) {
		Log.Error("[Exception] " + e);
		throw new Exception("조회에 실패하였습니다.");
	} finally {
		queryMap = null;
	}
	
	return pm;
}
public Map selecWithHoldTotCnt(Map paramMap, String locPath) throws Exception {

	//파라메터 복사.
	Map pm =  StringUtil.getParamMapData(paramMap);
	//xml 파서를 이용한 방법;
	Map queryMap = XmlQueryParser.getQueryMap(locPath);
	Map map = null;

	try{
		//쿼리 실행및 결과 받기.
		map  = (queryMap==null) ? null : DBConn.executeQueryMap(queryMap,"selecWithHoldTotCnt",pm);
	} catch (Exception e) {
		Log.Error("[Exception] " + e);
		throw new Exception("조회에 실패하였습니다.");
	} finally {
		queryMap = null;
	}

	return map;
}

//CPN_YEA_RD_COMMENT_YN : 연말정산 RD 원천징수영수증 작성방법 출력 여부(Y:출력, N:제외)
public int SaveRdCmtYn(Map paramMap, String locPath, String ssnYeaLogYn) throws Exception {

	//파라메터 복사.
	Map pm =  StringUtil.getParamMapData(paramMap);
	//xml 파서를 이용한 방법;
	Map queryMap = XmlQueryParser.getQueryMap(locPath);
	
	Map mp = null;

	int rstCnt = 0;

	StringBuffer query   = new StringBuffer();
	query.setLength(0);

	pm.put("query", query.toString());
	try{
		//쿼리 실행및 결과 받기.
		rstCnt  = DBConn.executeUpdate(queryMap, "SaveRdCmtYn", pm);
		saveLog(null, pm, ssnYeaLogYn);
	} catch (Exception e) {
		Log.Error("[Exception] " + e);
		throw new Exception("저장에 실패하였습니다.");
	} finally {
		queryMap = null;
	}

	return rstCnt;
}

//이관업로드 대상자 카운트
public Map selectMigExistCnt(Map paramMap, String locPath) throws Exception {

	//파라메터 복사.
	Map pm =  StringUtil.getParamMapData(paramMap);
	Map queryMap = XmlQueryParser.getQueryMap(locPath);
	String queryId = (String)pm.get("queryId");
	Map mp = null;

	pm.put("sabuns", pm.get("sabuns"));
	try{
		//쿼리 실행및 결과 받기.
		mp  = (queryMap==null) ? null : DBConn.executeQueryMap(queryMap, queryId, pm);
	} catch (Exception e) {
		Log.Error("[Exception] " + e);
		throw new Exception("조회에 실패하였습니다.");
	}

	return mp;
}
%>

<%
	String locPath = xmlPath+"/withHoldRcptSta_mig/withHoldRcptSta.xml";

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
	if("selectWithHoldRcptStaList".equals(cmd)) {
		//원천징수영수증 대상자 조회

		List listData  = new ArrayList();

		try {
			listData = selectWithHoldRcptStaList(mp, locPath, ssnYeaLogYn);
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

	} else 	if("selectEmpInfoUsingSabun".equals(cmd)) {
		//원천징수영수증 업로드시 사원정보 조회
		Map mapData  = new HashMap();

		try {
			mapData = selectEmpInfoUsingSabun(mp, locPath);
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

	} else if("selecWithHoldTotCnt".equals(cmd)) {

		Map mapData  = new HashMap();
		try {
			mapData = selecWithHoldTotCnt(mp, locPath);
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

	} else if("SaveRdCmtYn".equals(cmd)) {
		//시스템사용기준저장 CPN_YEA_RD_COMMENT_YN : 연말정산 RD 원천징수영수증 작성방법 출력 여부(Y:출력, N:제외)

		Map mapData = StringUtil.getRequestMap(request);
		mapData.put("ssnEnterCd", ssnEnterCd);
		mapData.put("ssnSabun", ssnSabun);
		mapData.put("cmd", cmd);
		
		try {
			int cnt = SaveRdCmtYn(mapData, locPath, ssnYeaLogYn);
		} catch(Exception e) {
			code = "-1";
			message = e.getMessage();
		}
		
		Map mapCode = new HashMap();
		//mapCode.put("Code", code);
		//mapCode.put("Message", message);
		mapCode.put("Code", "");
		mapCode.put("Message", "");

		Map rstMap = new HashMap();
		rstMap.put("Result", mapCode);
		
		out.print((new org.json.JSONObject(rstMap)).toString());
	} else if("selectMigExistCnt".equals(cmd)) {
		//이관업로드 대상자 카운트
		Map mapData  = new HashMap();

		try {
			mapData = selectMigExistCnt(mp, locPath);
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
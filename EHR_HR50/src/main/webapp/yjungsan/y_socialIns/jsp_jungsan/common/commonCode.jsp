<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="yjungsan.util.*"%>
<%@ page import="java.util.List"%>
<%@ page import="java.util.ArrayList"%>
<%@ page import="java.util.Map"%>
<%@ page import="java.util.HashMap"%>

<%@ page import="com.hr.common.logger.Log" %>
<%@ include file="../common/include/session.jsp"%>

<%!
//private Logger log = Logger.getLogger(this.getClass());

//public Map queryMap = null;

//xml 파서를 이용한 방법;
/* public void setQueryMap(String path) {
	queryMap = XmlQueryParser.getQueryMap(path);
} */

//공통코드 검색
public List getCommonCodeList(String path, String orderBy, Map paramMap) throws Exception {
	Map queryMap = XmlQueryParser.getQueryMap(path);
	//파라메터 복사.
	Map pm =  StringUtil.getParamMapData(paramMap);
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
	}
	
	return list;
}

//공통코드 기타 검색
public List getCommonNSCodeList(String path, String queryId, Map paramMap) throws Exception {
	Map queryMap = XmlQueryParser.getQueryMap(path);
	//파라메터 복사.
	Map pm =  StringUtil.getParamMapData(paramMap);
	List list = null;
	
	try{
		//쿼리 실행및 결과 받기.
		list  = (queryMap == null) ? null : DBConn.executeQueryList(queryMap, queryId, pm);
	} catch (Exception e) {
		Log.Error("[Exception] \n" + e);
		throw new Exception();
	}
	
	return list;
}
%>

<%
	//쿼리 맵 셋팅
	//setQueryMap(xmlPath+"/common/commonCode.xml");

	String ssnEnterCd = (String)session.getAttribute("ssnEnterCd");
	String ssnSabun = (String)session.getAttribute("ssnSabun");
	String cmd = (String)request.getParameter("cmd");
	String queryId = (String)request.getParameter("queryId");
	String orderBy = (String)request.getParameter("orderBy");
	
	Map mp = StringUtil.getRequestMap(request);
	mp.put("ssnEnterCd", ssnEnterCd);
	mp.put("ssnSabun", ssnSabun);
	
	List listData  = new ArrayList();
	String message = "";
	String code = "1";

	if("getCommonCodeList".equals(cmd)) {
		try {
			listData = getCommonCodeList(xmlPath+"/common/commonCode.xml", orderBy, mp);
		} catch(Exception e) {
			code = "-1";
			message = "공통 코드 조회중 오류가 발생하였습니다.";
		}
	} else if("getCommonNSCodeList".equals(cmd)) {
		try {
			listData = getCommonNSCodeList(xmlPath+"/common/commonCode.xml", queryId, mp);
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
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
//private Logger log = Logger.getLogger(this.getClass());

public Map queryMap = null;

//xml 파서를 이용한 방법;
public void setQueryMap(String path) {
	queryMap = XmlQueryParser.getQueryMap(path);
}


//작업현황조회
public Map selectYeaCalcProcessStatusPopupInfo(Map paramMap) throws Exception {

	//파라메터 복사.
	Map pm =  StringUtil.getParamMapData(paramMap);
	Map mp = null;
	
	try{
		//쿼리 실행및 결과 받기.
		mp  = DBConn.executeQueryMap(queryMap,"selectYeaCalcProcessStatusPopupInfo",pm);
	} catch (Exception e) {
		Log.Error("[Exception] " + e);
		throw new Exception("조회에 실패하였습니다.");
	}
	
	return mp;
}

//연말정산 작업현황 팝업 대상자 및 옵션 내역 조회
public List selectYeaCalcProcessStatusPopupDetail(String queryId, Map paramMap) throws Exception {

	//파라메터 복사.
	Map pm =  StringUtil.getParamMapData(paramMap);
	List list = null;
	
	try{
		//쿼리 실행및 결과 받기.
		list  = DBConn.executeQueryList(queryMap, queryId, pm);
	} catch (Exception e) {
		Log.Error("[Exception] \n" + e);
		throw new Exception("조회에 실패하였습니다.");
	}
	
	return list;
}

%>

<%
	//쿼리 맵 셋팅
	setQueryMap(xmlPath+"/yeaCalcCre/yeaCalcProcessStatusPopup.xml");

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
			mapData = selectYeaCalcProcessStatusPopupInfo(mp);
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
			listData = selectYeaCalcProcessStatusPopupDetail(queryId, mp);
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
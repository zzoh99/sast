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

<%!
//private Logger log = Logger.getLogger(this.getClass());

//public Map queryMap = null;

//xml 파서를 이용한 방법;
/* public void setQueryMap(String path) {
	queryMap = XmlQueryParser.getQueryMap(path);
} */

//간이지급명세 출력
public List selectSimplePymtPrtMgrList(String path, Map paramMap) throws Exception {
	Map queryMap = XmlQueryParser.getQueryMap(path);
	//파라메터 복사.
	Map pm =  StringUtil.getParamMapData(paramMap);
	List listData = null;
	
	try{
		
		//년도
		String searchYear			= String.valueOf(pm.get("searchYear"));
		//반기구분
		String searchHalfType		= String.valueOf(pm.get("searchHalfType"));
		//사업장
		String searchBusinessPlace	= String.valueOf(pm.get("searchBusinessPlace"));
		//사번/성명
		String searchSabunNameAlias	= String.valueOf(pm.get("searchSabunNameAlias"));
		//소득구분
		String includeGb			= String.valueOf(pm.get("includeGb"));

		StringBuffer query = new StringBuffer();

		query.setLength(0);

	    //대상년도
		if(searchYear.trim().length() != 0 ){

			query.append(" AND WORK_YY = '"+searchYear+"'");
		}
	    //반기구분
	    if(searchHalfType.trim().length() != 0 ){

			query.append(" AND HALF_TYPE = '"+searchHalfType+"'");
		}
	    //사업장
		if(searchBusinessPlace.trim().length() != 0 ){

			query.append(" AND BUSINESS_PLACE_CD = '"+searchBusinessPlace+"'");
		}
		//사번/성명
		if(searchSabunNameAlias.trim().length() != 0 ){

			query.append(" AND (SABUN || NAME) LIKE '%" +searchSabunNameAlias+"%'");
		}
		//소득구분
		if(includeGb.trim().length() != 0 ){

			query.append(" AND INCOME_TYPE = '"+includeGb+"'");
		}else{
			query.append(" AND INCOME_TYPE IN ('49','50','77')");
		}
		
		pm.put("query", query.toString());
		
		
		//쿼리 실행및 결과 받기.
		listData  = (queryMap == null) ? null : DBConn.executeQueryList(queryMap,"selectSimplePymtPrtMgrList",pm);
	} catch (Exception e) {
		Log.Error("[Exception] " + e);
		throw new Exception("조회에 실패하였습니다.");
	}
	
	return listData;
}


//중복 사번 체크
public List getHpChk(String path, Map paramMap) throws Exception {
	Map queryMap = XmlQueryParser.getQueryMap(path);
	//파라메터 복사.
	Map pm =  StringUtil.getParamMapData(paramMap);
	List listData = null;
	
	try{
		//쿼리 실행및 결과 받기.
		listData  = (queryMap == null) ? null : DBConn.executeQueryList(queryMap,"getHpChk",pm);
		
	} catch (Exception e) {
		Log.Error("[Exception] " + e);
		throw new Exception("조회에 실패하였습니다.");
	}
	
	return listData;
}

%>

<%
	//쿼리 맵 셋팅
	//setQueryMap(xmlPath+"/simplePymtPrtMgr/simplePymtPrtMgr.xml");

	String ssnEnterCd = (String)session.getAttribute("ssnEnterCd");
	String ssnSabun = (String)session.getAttribute("ssnSabun");
	String cmd = (String)request.getParameter("cmd");

	if("selectSimplePymtPrtMgrList".equals(cmd)) {
		
		//간이지급명세 대상자 조회
		Map mp = StringUtil.getRequestMap(request);
		mp.put("ssnEnterCd", ssnEnterCd);
		mp.put("ssnSabun", ssnSabun);
		
		List listData  = new ArrayList();
		String message = "";
		String code = "1";
	
		try {
			listData = selectSimplePymtPrtMgrList(xmlPath+"/simplePymtPrtMgr/simplePymtPrtMgr.xml", mp);
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
	
	//중복 사번 체크
	else if("getHpChk".equals(cmd)) {

		Map mp = StringUtil.getRequestMap(request);
		mp.put("ssnEnterCd", ssnEnterCd);
		mp.put("ssnSabun", ssnSabun);
		
		List listData  = new ArrayList();
		String message = "";
		String code = "1";
	
		try {
			listData = getHpChk(xmlPath+"/simplePymtPrtMgr/simplePymtPrtMgr.xml", mp);
		} catch(Exception e) {
			code = "-1";
			message = e.getMessage();
		}
		
		Map mapCode = new HashMap();
		mapCode.put("Code", code);
		mapCode.put("Message", message);
		
		Map rstMap = new HashMap();
		rstMap.put("Result", mapCode);
		rstMap.put("Data", listData == null ? null : listData.get(0));
		out.print((new org.json.JSONObject(rstMap)).toString());
			
	}
%>
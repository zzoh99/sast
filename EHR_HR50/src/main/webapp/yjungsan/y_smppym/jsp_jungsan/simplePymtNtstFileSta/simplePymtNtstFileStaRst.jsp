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
<%@ page import="java.util.StringTokenizer"%>
<%@ page import="java.io.Serializable"%>

<%@ include file="../common/include/session.jsp"%>

<%!
//private Logger log = Logger.getLogger(this.getClass());
//public Map queryMap = null;

//xml 파서를 이용한 방법;
/* public void setQueryMap(String path) {
	queryMap = XmlQueryParser.getQueryMap(path);
} */

//컬럼명 조회
public List getSimplePymtNtstFileSta01(String path, Map paramMap) throws Exception {
	Map queryMap = XmlQueryParser.getQueryMap(path);
	//파라메터 복사.
	Map pm =  StringUtil.getParamMapData(paramMap);
	List listData = null;

	//파일종류
	String fileKind	= String.valueOf(pm.get("fileKind"));
	
	StringBuffer query = new StringBuffer();

	query.setLength(0);
	
	//파일종류
	if(fileKind.trim().length() != 0 ){

		query.append(" AND FILE_SEQ = '"+fileKind+"'");
	}else{
		query.append(" AND FILE_SEQ = ''");
	}
	
	pm.put("query", query.toString());
	
	
	try{
		//쿼리 실행및 결과 받기.
		listData  = (queryMap == null) ? null : DBConn.executeQueryList(queryMap,"getSimplePymtNtstFileSta01",pm);
	} catch (Exception e) {
		Log.Error("[Exception] " + e);
		throw new Exception("조회에 실패하였습니다.");
	}
	
	return listData;
}



//데이터 조회
public List getSimplePymtNtstFileSta02(String path, Map paramMap) throws Exception {
	Map queryMap = XmlQueryParser.getQueryMap(path);
	//파라메터 복사.
	Map pm =  StringUtil.getParamMapData(paramMap);
	List listData = null;

	//년도
	String searchYear	= String.valueOf(pm.get("searchYear"));
	//반기구분
	String searchHalfType	= String.valueOf(pm.get("searchHalfType"));
	//사업장
	String searchBusinessPlace	= String.valueOf(pm.get("searchBusinessPlace"));
	//사번/성명
	String searchSabunNameAlias	= String.valueOf(pm.get("searchSabunNameAlias"));
	//제출일자
	String searchDt	= String.valueOf(pm.get("searchDt"));
	//소득구분
	String includeGb	= String.valueOf(pm.get("includeGb"));
	//파일종류
	String fileKind	= String.valueOf(pm.get("fileKind"));
	//파일항목
	String fileItem	= String.valueOf(pm.get("fileItem"));

	StringBuffer query = new StringBuffer();

	query.setLength(0);

   /*  //년도
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

		query.append(" AND (A.SABUN || A.NAME) LIKE '%" +searchSabunNameAlias+"%'");
	} */


	if(fileKind.trim().length() != 0 ){

		query.append(" AND ITEM_VALUE2 = '"+fileKind+"'");
	}else{
		query.append(" AND ITEM_VALUE2 = ''");
	}
	
	pm.put("query", query.toString());
	
	try{
		//쿼리 실행및 결과 받기.
		listData  = (queryMap == null) ? null : DBConn.executeQueryList(queryMap,"getSimplePymtNtstFileSta02",pm);
	} catch (Exception e) {
		Log.Error("[Exception] " + e);
		throw new Exception("조회에 실패하였습니다.");
	}
	
	return listData;
}



%>

<%
	//쿼리 맵 셋팅
	//setQueryMap(xmlPath+"/simplePymtNtstFileSta/simplePymtNtstFileSta.xml");

	String ssnEnterCd = (String)session.getAttribute("ssnEnterCd");
	String ssnSabun = (String)session.getAttribute("ssnSabun");
	String cmd = (String)request.getParameter("cmd");

	//컬럼명 조회
	if("getSimplePymtNtstFileSta01".equals(cmd)) {

		Map mp = StringUtil.getRequestMap(request);
		mp.put("ssnEnterCd", ssnEnterCd);
		mp.put("ssnSabun", ssnSabun);
		
		List listData  = new ArrayList();
		String message = "";
		String code = "1";
	
		try {
			listData = getSimplePymtNtstFileSta01(xmlPath+"/simplePymtNtstFileSta/simplePymtNtstFileSta.xml", mp);
		} catch(Exception e) {
			code = "-1";
			message = e.getMessage();
		}
		
		Map mapCode = new HashMap();
		mapCode.put("Code", code);
		mapCode.put("Message", message);
		
		Map rstMap = new HashMap();
		rstMap.put("Result", mapCode);
		rstMap.put("Data",  listData == null ? null : (List)listData);
		out.print((new org.json.JSONObject(rstMap)).toString());
		
	} 
	
	//데이터 조회
	else if("getSimplePymtNtstFileSta02".equals(cmd)) {

		Map mp = StringUtil.getRequestMap(request);
		mp.put("ssnEnterCd", ssnEnterCd);
		mp.put("ssnSabun", ssnSabun);
		
		List listData  = new ArrayList();
		String message = "";
		String code = "1";
	
		try {
			listData = getSimplePymtNtstFileSta02(xmlPath+"/simplePymtNtstFileSta/simplePymtNtstFileSta.xml", mp);
		} catch(Exception e) {
			code = "-1";
			message = e.getMessage();
		}
		
		Map mapCode = new HashMap();
		mapCode.put("Code", code);
		mapCode.put("Message", message);
		
		Map rstMap = new HashMap();
		rstMap.put("Result", mapCode);
		rstMap.put("Data",  listData == null ? null : (List)listData);
		out.print((new org.json.JSONObject(rstMap)).toString());
		
	} 
%>
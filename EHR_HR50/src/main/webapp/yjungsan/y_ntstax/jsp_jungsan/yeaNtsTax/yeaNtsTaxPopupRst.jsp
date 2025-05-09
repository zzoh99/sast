<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="yjungsan.util.*"%>
<%@ page import="yjungsan.exception.*"%>
<%@ page import="java.sql.Connection"%>
<%@ page import="java.util.List"%>
<%@ page import="java.util.ArrayList"%>
<%@ page import="java.util.Map"%>
<%@ page import="java.util.HashMap"%>
<%@ page import="com.hr.common.logger.Log" %>
<%@ include file="../common/include/session.jsp"%>
<%!

//레코드 상세팝업 타이틀 조회 검색
public List selectRecordTitleList(Map paramMap, String locPath) throws Exception {

	//파라메터 복사.
	Map pm =  StringUtil.getParamMapData(paramMap);
	//xml 파서를 이용한 방법;
	Map queryMap = XmlQueryParser.getQueryMap(locPath);
	List list = null;
	try{
		//쿼리 실행및 결과 받기.
		list = (queryMap == null) ? null : DBConn.executeQueryList(queryMap,"selectRecordTitleList",pm);
	} catch (Exception e) {
		Log.Error("[Exception] " + e);
		throw new Exception("조회에 실패하였습니다.");
	}
	return list;
}

//레코드 상세팝업 데이터 조회
public List selectRecordList(Map paramMap, String locPath) throws Exception {

	//파라메터 복사.
	Map pm =  StringUtil.getParamMapData(paramMap);
	//xml 파서를 이용한 방법;
	Map queryMap = XmlQueryParser.getQueryMap(locPath);
	List list = null;
	
	String searchTable = String.valueOf(pm.get("searchTable"));
	String record 	   = String.valueOf(pm.get("gubun"));
	String declClass   = String.valueOf(pm.get("declClass"));

	StringBuffer table   = new StringBuffer();
	StringBuffer column  = new StringBuffer();
	StringBuffer column2 = new StringBuffer(); //파라미터 구분 : 근로소득[1], 퇴직소득[3]

	table.setLength(0);
	column.setLength(0);
	column2.setLength(0);

	if(searchTable.trim().length() != 0){table.append(searchTable);}
	//DISK(기부금)분기처리
	if("H".equals(record) || "I".equals(record) || "A1".equals(record)) {
		column.append("");
		column2.append("");
	}else {
		column.append(", TAX_FILE_TYPE");
		column2.append("AND TAX_FILE_TYPE = '"+declClass+"'");
	}
	pm.put("table"  , table.toString()  );
	pm.put("column" , column.toString() );
	pm.put("column2", column2.toString());

	try{
		//쿼리 실행및 결과 받기.
		list = (queryMap == null) ? null : DBConn.executeQueryList(queryMap,"selectRecordList",pm);
	} catch (Exception e) {
		Log.Error("[Exception] " + e);
		throw new Exception("조회에 실패하였습니다.");
	}
	return list;
}
%>

<%
	//쿼리 맵 셋팅
	String locPath = xmlPath+"/yeaNtsTax/yeaNtsTaxPopup.xml";

	String ssnEnterCd = (String)session.getAttribute("ssnEnterCd");
	String ssnSabun = (String)session.getAttribute("ssnSabun");
	String cmd = (String)request.getParameter("cmd");

	if("selectRecordTitleList".equals(cmd)) {
		//레코드 상세 팝업 타이틀 조회

		Map mp = StringUtil.getRequestMap(request);
		mp.put("ssnEnterCd", ssnEnterCd);
		mp.put("ssnSabun", ssnSabun);

		List listData  = new ArrayList();
		String message = "";
		String code = "1";

		try {
			listData = selectRecordTitleList(mp, locPath);
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
	}else if("selectRecordList".equals(cmd)) {
		//레코드 상세팝업 데이터 조회

		Map mp = StringUtil.getRequestMap(request);
		mp.put("ssnEnterCd", ssnEnterCd);
		mp.put("ssnSabun", ssnSabun);

		List listData  = new ArrayList();
		String message = "";
		String code = "1";

		try {
			listData = selectRecordList(mp, locPath);
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
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
<%@ page import="java.util.StringTokenizer" %>
<%@ page import="java.io.Serializable" %>
<%@ page import="com.hr.common.logger.Log" %>
<%@ include file="../common/include/session.jsp"%>

<%!

//우편번호 갯수 조회
public String getZipCodePopupDoroListCnt(Map paramMap, String locPath) throws Exception {

	//파라메터 복사.
	Map pm =  StringUtil.getParamMapData(paramMap);
	Map queryMap = XmlQueryParser.getQueryMap(locPath);
	Map mapData = null;
	String totalCnt = "0";
			
	try{
		String searchWord	= pm.get("searchWord").toString().replaceAll("-"," ");
		StringBuffer query = new StringBuffer();
		
		if ( searchWord == null || searchWord.equals("") ) {
			query.append(" AND  1 = 2 ");
			
		} else {
			StringTokenizer st = new StringTokenizer(searchWord);
			List<Serializable> sword = new ArrayList<Serializable>();
			
			while(st.hasMoreTokens()) {
				String tocken = st.nextToken();
				sword.add(tocken);
			}
	
			for( int i = 0 ; i < sword.size() ; i ++ ){
				query.append(" AND "
							+ "("
							+ " SIDO LIKE '"+sword.get(i)+"%'"
							+ " OR SIGUNGU LIKE '"+sword.get(i)+"%'"
							+ " OR UPMYON LIKE '"+sword.get(i)+"%'"
							+ " OR ROAD_NAME LIKE '"+sword.get(i)+"%'"
							+ " OR SIGUNGUBD_NAME LIKE '"+sword.get(i)+"%'"
							+ " OR BDNO_M LIKE '"+sword.get(i)+"%'"
							+ " OR BDNO_S LIKE '"+sword.get(i)+"%'"
							+ " OR LAW_DONG_NAME LIKE '"+sword.get(i)+"%'"
							+ " OR GOV_DONG_NAME  LIKE '"+sword.get(i)+"%'"
							+ " OR JIBUN_M LIKE '"+sword.get(i)+"%'"
							+ " OR JIBUN_S LIKE '"+sword.get(i)+"%'"
							+ " )");
			}
		}
		pm.put("query", query.toString());
		
		//쿼리 실행및 결과 받기.
		mapData  = (queryMap == null) ? null : DBConn.executeQueryMap(queryMap,"getZipCodePopupDoroListCnt",pm);
		totalCnt = (mapData == null || !mapData.containsKey("cnt") || mapData.get("cnt") == null) ? "0" : (String)mapData.get("cnt");
		
	} catch (Exception e) {
		Log.Error("[Exception] " + e);
		throw new Exception("조회에 실패하였습니다.");
	} finally {
		queryMap = null;
	}
	
	return totalCnt;
}

//우편번호 조회
public List getZipCodePopupDoroList(Map paramMap, String locPath) throws Exception {

	//파라메터 복사.
	Map pm =  StringUtil.getParamMapData(paramMap);
	Map queryMap = XmlQueryParser.getQueryMap(locPath);
	List listData = null;
	
	try{
		String searchWord	= pm.get("searchWord").toString().replaceAll("-"," ");
		StringBuffer query = new StringBuffer();
		
		if ( searchWord == null || searchWord.equals("") ) {
			query.append(" AND  1 = 2 ");
			
		} else {
			StringTokenizer st = new StringTokenizer(searchWord);
			List<Serializable> sword = new ArrayList<Serializable>();
			
			while(st.hasMoreTokens()) {
				String tocken = st.nextToken();
				sword.add(tocken);
			}
	
			for( int i = 0 ; i < sword.size() ; i ++ ){
				query.append(" AND "
							+ "("
							+ " SIDO LIKE '"+sword.get(i)+"%'"
							+ " OR SIGUNGU LIKE '"+sword.get(i)+"%'"
							+ " OR UPMYON LIKE '"+sword.get(i)+"%'"
							+ " OR ROAD_NAME LIKE '"+sword.get(i)+"%'"
							+ " OR SIGUNGUBD_NAME LIKE '"+sword.get(i)+"%'"
							+ " OR BDNO_M LIKE '"+sword.get(i)+"%'"
							+ " OR BDNO_S LIKE '"+sword.get(i)+"%'"
							+ " OR LAW_DONG_NAME LIKE '"+sword.get(i)+"%'"
							+ " OR GOV_DONG_NAME  LIKE '"+sword.get(i)+"%'"
							+ " OR JIBUN_M LIKE '"+sword.get(i)+"%'"
							+ " OR JIBUN_S LIKE '"+sword.get(i)+"%'"
							+ " )");
			}
		}
		pm.put("query", query.toString());
		
		String pageStr = "";
		Integer ibpage	   = Integer.parseInt(pm.get("ibpage").toString());
		Integer defaultRow = Integer.parseInt(pm.get("defaultRow").toString());
	
		if( pm.get("ibpage") == null || pm.get("ibpage").toString().equals("") ) {
			pageStr = " WHERE RNUM BETWEEN 1 AND TO_NUMBER("+defaultRow+") ";
		} else {
			pageStr = " WHERE RNUM BETWEEN (TO_NUMBER("+ibpage+")-1)*TO_NUMBER("+defaultRow+")+1 AND ( TO_NUMBER("+ibpage+")*TO_NUMBER("+defaultRow+") )";
		}
		pm.put("pageStr", pageStr);
	

		//쿼리 실행및 결과 받기.
		listData  = (queryMap == null) ? null : DBConn.executeQueryList(queryMap,"getZipCodePopupDoroList",pm);
	} catch (Exception e) {
		Log.Error("[Exception] " + e);
		throw new Exception("조회에 실패하였습니다.");
	} finally {
		queryMap = null;
	}
	
	return listData;
}
%>

<%
	String locPath = xmlPath+"/common/zipCodeRefPopup.xml";

	String ssnEnterCd = (String)session.getAttribute("ssnEnterCd");
	String ssnSabun = (String)session.getAttribute("ssnSabun");
	String cmd = (String)request.getParameter("cmd");

	if("getZipCodePopupDoroList".equals(cmd)) {
		//우편번호 조회
		
		Map mp = StringUtil.getRequestMap(request);
		mp.put("ssnEnterCd", ssnEnterCd);
		mp.put("ssnSabun", ssnSabun);
		
		List listData  = new ArrayList();
		String message = "";
		String code = "1";
		String totalCnt = "0";

		try {
			totalCnt = getZipCodePopupDoroListCnt(mp, locPath);
			listData = getZipCodePopupDoroList(mp, locPath);
		} catch(Exception e) {
			code = "-1";
			message = e.getMessage();
		}
		
		Map mapCode = new HashMap();
		mapCode.put("Code", code);
		mapCode.put("Message", message);
		
		Map rstMap = new HashMap();
		rstMap.put("Result", mapCode);
		rstMap.put("Botal", "");
		rstMap.put("DATA", listData == null ? null : (List)listData);
		rstMap.put("TOTAL", totalCnt);
		out.print((new org.json.JSONObject(rstMap)).toString());
	}
%>
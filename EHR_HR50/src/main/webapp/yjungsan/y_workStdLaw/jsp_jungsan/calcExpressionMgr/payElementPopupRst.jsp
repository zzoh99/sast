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

//수당/항목 조회
public List selectPayElementList(String path, Map paramMap) throws Exception {
	Map queryMap = XmlQueryParser.getQueryMap(path);
	//파라메터 복사.
	Map pm =  StringUtil.getParamMapData(paramMap);
	
	String searchElemNm	= String.valueOf(pm.get("searchElemNm"));
	String searchYn		= String.valueOf(pm.get("searchYn"));
	StringBuffer query  = new StringBuffer();
	query.setLength(0);

	if(searchElemNm.trim().length() != 0 ){
		query.append(" AND UPPER(ELEMENT_NM) LIKE '%'||UPPER(trim('"+searchElemNm+"'))||'%'");
	}	
	if("Y".equals(searchYn)){
		query.append("AND NVL(EDATE,'99991231') >= TO_CHAR(SYSDATE,'YYYYMMDD')");
	}else if("N".equals(searchYn)){
		query.append("AND NVL(EDATE,'99991231') < TO_CHAR(SYSDATE,'YYYYMMDD')");
	}

	pm.put("query", query.toString());
		
	List listData = null;
	
	try{
		//쿼리 실행및 결과 받기.
		listData = (queryMap == null) ? null : DBConn.executeQueryList(queryMap,"getPayElementAllList",pm);
		
	} catch (Exception e) {
		Log.Error("[Exception] " + e);
		throw new Exception("조회에 실패하였습니다.");
	}
	
	return listData;
}
%>

<%
	//쿼리 맵 셋팅
	//setQueryMap(xmlPath+"/calcExpressionMgr/payElementPopup.xml");
	String ssnEnterCd = (String)session.getAttribute("ssnEnterCd");
	String ssnSabun = (String)session.getAttribute("ssnSabun");
	String cmd = (String)request.getParameter("cmd");

	if("selectPayElementList".equals(cmd)) {
		Map mp = StringUtil.getRequestMap(request);
		mp.put("ssnEnterCd", ssnEnterCd);
		mp.put("ssnSabun", ssnSabun);
		
		List listData  = new ArrayList();
		String message = "";
		String code = "1";
	
		try {
			listData = selectPayElementList(xmlPath+"/calcExpressionMgr/payElementPopup.xml", mp);
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
<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="yjungsan.util.*"%>
<%@ page import="yjungsan.exception.*"%>
<%@ page import="java.sql.Connection"%>
<%@ page import="java.util.List"%>
<%@ page import="java.util.ArrayList"%>
<%@ page import="java.util.Map"%>
<%@ page import="java.util.HashMap"%>
<%@ page import="net.sf.json.JSONArray" %>
<%@ page import="net.sf.json.JSONObject" %>
<%@ page import="com.hr.common.logger.Log" %>
<%@ include file="../common/include/session.jsp"%>

<%!
//private Logger log = Logger.getLogger(this.getClass());
//public Map queryMap = null;
//xml 파서를 이용한 방법;
/* public void setQueryMap(String path) {
	queryMap = XmlQueryParser.getQueryMap(path);
} */

//원천징수영수증 조회
public List selectDayIncomeTaxSta(String path, Map paramMap) throws Exception {
	Map queryMap = XmlQueryParser.getQueryMap(path);
	//파라메터 복사.
	Map pm =  StringUtil.getParamMapData(paramMap);
	List listData = null;
	
    //2021.07.13
    String workPartGubun = String.valueOf(pm.get("workPartGubun"));
    String workPart      = String.valueOf(pm.get("workPart"));
	
    StringBuffer query   = new StringBuffer();
    query.setLength(0);
    
    if(workPart.length() > 0 && workPart.length() < 2){
    	workPart = "0"+workPart;
    	pm.put("workPart", workPart);
    }

    if(workPartGubun.equals("1")){
    	query.append("AND SUBSTR(Y.PAYMENT_YMD,5,2) = #workPart#)");
    }else if(workPartGubun.equals("2")){    	
        if("01".equals(workPart) || "02".equals(workPart)){
            query.append("AND SUBSTR(Y.PAYMENT_YMD,5,2) BETWEEN DECODE(#workPart#,'1','01','2','04','3','07','4','10')AND DECODE(#workPart#,'1','03','2','06','3','09','4','12'))");            
        } else {
            query.append("AND SUBSTR(Y.PAYMENT_YMD,5,2) = #workPart#)");
        }    	
    }else{
    	query.append("AND SUBSTR(Y.PAYMENT_YMD,5,2) BETWEEN DECODE(#workPart#,'1','01','2','04','3','07','4','10')AND DECODE(#workPart#,'1','03','2','06','3','09','4','12'))");
    }
    pm.put("query", query.toString());
	try{
		//쿼리 실행및 결과 받기.
		listData  = (queryMap == null) ? null : DBConn.executeQueryList(queryMap,"selectDayIncomeTaxStaList",pm);
	} catch (Exception e) {
		Log.Error("[Exception] " + e);
		throw new Exception("조회에 실패하였습니다.");
	}
	
	return listData;
}

%>

<%
	//쿼리 맵 셋팅
	//setQueryMap(xmlPath+"/dayIncomeTaxSta/dayIncomeTaxSta.xml");
	String ssnEnterCd = (String)session.getAttribute("ssnEnterCd");
	String ssnSabun = (String)session.getAttribute("ssnSabun");
	String cmd = (String)request.getParameter("cmd");
	if("selectDayIncomeTaxStaList".equals(cmd)) {
		Map mp = StringUtil.getRequestMap(request);
		mp.put("ssnEnterCd", ssnEnterCd);
		mp.put("ssnSabun", ssnSabun);
		List listData  = new ArrayList();
		String message = "";
		String code = "1";
		try {
			listData = selectDayIncomeTaxSta(xmlPath+"/dayIncomeTaxSta/dayIncomeTaxSta.xml", mp);
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
		out.print(JSONObject.fromObject(rstMap).toString());
	} 
%>
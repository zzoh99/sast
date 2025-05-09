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

//원천징수영수증 대상자 조회
public Map getProcessBarpMap(String path, Map paramMap) throws Exception {
	Map queryMap = XmlQueryParser.getQueryMap(path);
	//파라메터 복사.
	Map pm =  StringUtil.getParamMapData(paramMap);
	Map mp = null;

	try{
		//쿼리 실행및 결과 받기.
		mp  = (queryMap==null) ? null : DBConn.executeQueryMap(queryMap,"getProcessBarpMap",pm);
	} catch (Exception e) {
		Log.Error("[Exception] " + e);
		throw new Exception("조회에 실패하였습니다.");
	}

	return mp;
}


%>

<%
	//쿼리 맵 셋팅
	//setQueryMap(xmlPath+"/common/commonSelect.xml");
	String ssnEnterCd = (String)session.getAttribute("ssnEnterCd");
	String ssnSabun = (String)session.getAttribute("ssnSabun");
	String cmd = (String)request.getParameter("cmd");
	String prgCd = (String)request.getParameter("prgCd");
	String payActionCd = (String)request.getParameter("payActionCd");

	if("getProcessBarpMap".equals(cmd)) {
		Map mp = StringUtil.getRequestMap(request);
		mp.put("ssnEnterCd", ssnEnterCd);
		mp.put("ssnSabun", ssnSabun);
		mp.put("prgCd", prgCd);
		mp.put("payActionCd", payActionCd);

		Map mapData  = new HashMap();
		String message = "";
		String code = "1";

		try {
			mapData = getProcessBarpMap(xmlPath+"/common/commonSelect.xml", mp);
		} catch(Exception e) {
			code = "-1";
			message = e.getMessage();
		}
		//Log.Debug(mp + " / mapData :::::" + mapData);

		Map mapCode = new HashMap();
		mapCode.put("Code", code);
		mapCode.put("Message", message);

		Map rstMap = new HashMap();
		rstMap.put("Result", mapCode);
		rstMap.put("Data", (Map)mapData);
		out.print((new org.json.JSONObject(rstMap)).toString());
	} else if("prcCpnSepPayMain".equals(cmd)) {

		Map paramMap = StringUtil.getRequestMap(request);
		Map mp =  StringUtil.getParamMapData(paramMap);
		String[] type =  new String[]{"OUT","OUT","STR","STR","STR","STR","STR","STR"};
		String[] param = new String[]{"","",ssnEnterCd,payActionCd,"","","1",ssnSabun};

		String message = "";
		String code = "1";

		try {
				String[] rstStr = DBConn.executeProcedure("P_CPN_SEP_PAY_MAIN",type,param);
				if(rstStr[1] == null || rstStr[1].length() == 0) {
					message = "퇴직금 계산이 완료되었습니다.";
				} else {
					code = "-1";
					message = "퇴직금 계산 처리도중 : "+rstStr[1];
				}

		} catch(Exception e) {
			code = "-1";
			message = e.getMessage();
		}

		Map mapCode = new HashMap();
		mapCode.put("Code", code);
		mapCode.put("Message", message);

		Map rstMap = new HashMap();
		rstMap.put("Result", mapCode);

		out.print((new org.json.JSONObject(rstMap)).toString());

	//6. 퇴직금계산취소 Proc
	}
%>
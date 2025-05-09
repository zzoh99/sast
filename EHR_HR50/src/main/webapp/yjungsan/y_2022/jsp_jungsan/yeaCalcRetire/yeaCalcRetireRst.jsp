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
<%@ include file="../auth/saveLog.jsp"%>
<%!
//퇴직자정산 급여코드 조회
public Map selectYeaPayActionInfo(Map paramMap, String locPath) throws Exception {

	//파라메터 복사.
	Map pm = StringUtil.getParamMapData(paramMap);
	Map queryMap = XmlQueryParser.getQueryMap(locPath);
	Map mp = null;

	try{
		//쿼리 실행및 결과 받기.
		mp  = (queryMap==null) ? null : DBConn.executeQueryMap(queryMap,"selectYeaPayActionInfo",pm);
	} catch (Exception e) {
		Log.Error("[Exception] " + e);
		throw new Exception("조회에 실패하였습니다.");
	} finally {
		queryMap = null;
	}

	return mp;
}

//퇴직정산 급여코드 조회
public Map selectYeaPayActionInfo2(Map paramMap, String locPath) throws Exception {

	//파라메터 복사.
	Map pm =  StringUtil.getParamMapData(paramMap);
	Map queryMap = XmlQueryParser.getQueryMap(locPath);
	Map mp = null;

	try{
		//쿼리 실행및 결과 받기.
		mp  = (queryMap==null) ? null : DBConn.executeQueryMap(queryMap,"selectYeaPayActionInfo2",pm);
	} catch (Exception e) {
		Log.Error("[Exception] " + e);
		throw new Exception("조회에 실패하였습니다.");
	} finally {
		queryMap = null;
	}

	return mp;
}


public List selectYeaCalcRetireSheet1List(Map paramMap, String locPath, String ssnYeaLogYn) throws Exception {

	//파라메터 복사.
	Map pm =  StringUtil.getParamMapData(paramMap);
	Map queryMap = XmlQueryParser.getQueryMap(locPath);
	List listData = null;

	try{
		//쿼리 실행및 결과 받기.
		listData  = (queryMap==null) ? null : DBConn.executeQueryList(queryMap,"selectYeaCalcRetireSheet1List",pm);
		saveLog(null, pm, ssnYeaLogYn);
	} catch (Exception e) {
		Log.Error("[Exception] " + e);
		throw new Exception("조회에 실패하였습니다.");
	} finally {
		queryMap = null;
	}

	return listData;
}

public List selectYeaCalcRetireSheet2List(Map paramMap, String locPath) throws Exception {

	//파라메터 복사.
	Map pm =  StringUtil.getParamMapData(paramMap);
	Map queryMap = XmlQueryParser.getQueryMap(locPath);
	List listData = null;

	try{
		//쿼리 실행및 결과 받기.
		listData  = (queryMap==null) ? null : DBConn.executeQueryList(queryMap,"selectYeaCalcRetireSheet2List",pm);
// 		saveLog(null, pm);
	} catch (Exception e) {
		Log.Error("[Exception] " + e);
		throw new Exception("조회에 실패하였습니다.");
	} finally {
		queryMap = null;
	}

	return listData;
}

//퇴직자정산 마감 , 취소 처리
public int saveFinalCloseYn(Map paramMap, String locPath, String ssnYeaLogYn) throws Exception {

	//파라메터 복사.
	Map pm =  StringUtil.getParamMapData(paramMap);
	Map queryMap = XmlQueryParser.getQueryMap(locPath);
	Map mp = null;

	int rstCnt = 0;

	try{
		//쿼리 실행및 결과 받기.
		rstCnt = DBConn.executeUpdate(queryMap, "saveFinalCloseTCPN811", pm);
		DBConn.executeUpdate(queryMap, "saveFinalCloseTCPN983", pm);
		DBConn.executeUpdate(queryMap, "saveFinalCloseTCPN981", pm);
		saveLog(null, pm, ssnYeaLogYn);
	} catch (Exception e) {
		Log.Error("[Exception] " + e);
		throw new Exception("저장에 실패하였습니다.");
	} finally {
		queryMap = null;
	}

	return rstCnt;
}

%>

<%
	String locPath = xmlPath+"/yeaCalcRetire/yeaCalcRetire.xml";

	String ssnEnterCd = (String)session.getAttribute("ssnEnterCd");
	String ssnSabun = (String)session.getAttribute("ssnSabun");
	String ssnYeaLogYn = (String)session.getAttribute("ssnYeaLogYn");
	String cmd = (String)request.getParameter("cmd");

	if("selectYeaPayActionInfo".equals(cmd)) {
		//퇴직자정산 급여코드 조회

		Map mp = StringUtil.getRequestMap(request);
		mp.put("ssnEnterCd", ssnEnterCd);
		mp.put("ssnSabun", ssnSabun);

		Map mapData  = new HashMap();
		String message = "";
		String code = "1";

		try {
			mapData = selectYeaPayActionInfo(mp, locPath);
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

	} else 	if("selectYeaPayActionInfo2".equals(cmd)) {
		//퇴직정산 급여코드 조회

		Map mp = StringUtil.getRequestMap(request);
		mp.put("ssnEnterCd", ssnEnterCd);
		mp.put("ssnSabun", ssnSabun);

		Map mapData  = new HashMap();
		String message = "";
		String code = "1";

		try {
			mapData = selectYeaPayActionInfo2(mp, locPath);
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

	} else if("selectYeaCalcRetireSheet1List".equals(cmd)) {

		Map mp = StringUtil.getRequestMap(request);
		mp.put("ssnEnterCd", ssnEnterCd);
		mp.put("ssnSabun", ssnSabun);

		List listData  = new ArrayList();
		String message = "";
		String code = "1";

		try {
			listData = selectYeaCalcRetireSheet1List(mp, locPath, ssnYeaLogYn);
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
	} else if("selectYeaCalcRetireSheet2List".equals(cmd)) {

		Map mp = StringUtil.getRequestMap(request);
		mp.put("ssnEnterCd", ssnEnterCd);
		mp.put("ssnSabun", ssnSabun);

		List listData  = new ArrayList();
		String message = "";
		String code = "1";

		try {
			listData = selectYeaCalcRetireSheet2List(mp, locPath);
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
	} else if("prcYearEndMonPayAndTax".equals(cmd)) {
		//총급여합산,세금계산

		Map paramMap = StringUtil.getRequestMap(request);
		Map mp =  StringUtil.getParamMapData(paramMap);

		String payActionCd = (String)mp.get("searchPayActionCd");
		String workYy = (String)mp.get("searchWorkYy");
		String adjustType = (String)mp.get("searchAdjustType");

		String[] type =  new String[]{"OUT","OUT","STR","STR","STR","STR","STR","STR","STR"};
		String[] param = new String[]{"","",ssnEnterCd,payActionCd,workYy,adjustType,"","",ssnSabun};

		String message = "";
		String code = "1";

		try {

			String[] rstStr1 = DBConn.executeProcedure("P_CPN_YEAREND_MONPAY_"+yeaYear,type,param);

			if(rstStr1[1] == null || rstStr1[1].length() == 0) {
				String[] rstStr2 = DBConn.executeProcedure("PKG_CPN_YEA_"+yeaYear+".P_CPN_YEAREND_TAX",type,param);

				if(rstStr2[1] == null || rstStr2[1].length() == 0) {
					message = "퇴직정산 계산이 완료되었습니다.";
				} else {
					code = "-1";
					message = "퇴직정산 계산 처리도중 : "+rstStr2[1];
				}
			} else {
				code = "-1";
				message = "총급여계산 처리도중 : "+rstStr1[1];
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

	} else if("prcYearEndMonPay".equals(cmd)) {
		//총급여 합산

		Map paramMap = StringUtil.getRequestMap(request);
		Map mp =  StringUtil.getParamMapData(paramMap);

		String payActionCd = (String)mp.get("searchPayActionCd");
		String workYy = (String)mp.get("searchWorkYy");
		String adjustType = (String)mp.get("searchAdjustType");

		String[] type =  new String[]{"OUT","OUT","STR","STR","STR","STR","STR","STR","STR"};
		String[] param = new String[]{"","",ssnEnterCd,payActionCd,workYy,adjustType,"","",ssnSabun};

		String message = "";
		String code = "1";
		int cnt = 0;

		try {

			String[] rstStr = DBConn.executeProcedure("P_CPN_YEAREND_MONPAY_"+yeaYear,type,param);

			if(rstStr[1] == null || rstStr[1].length() == 0) {
				message = "총급여 합산이 완료되었습니다.";
			} else {
				code = "-1";
				message = "총급여 합산 처리도중 : "+rstStr[1];
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

	} else if("prcYearEndTax".equals(cmd)) {
		//세금계산

		Map paramMap = StringUtil.getRequestMap(request);
		Map mp =  StringUtil.getParamMapData(paramMap);

		String payActionCd = (String)mp.get("searchPayActionCd");
		String workYy = (String)mp.get("searchWorkYy");
		String adjustType = (String)mp.get("searchAdjustType");

		String[] type =  new String[]{"OUT","OUT","STR","STR","STR","STR","STR","STR","STR"};
		String[] param = new String[]{"","",ssnEnterCd,payActionCd,workYy,adjustType,"","",ssnSabun};

		String message = "";
		String code = "1";
		int cnt = 0;

		try {

			String[] rstStr = DBConn.executeProcedure("PKG_CPN_YEA_"+yeaYear+".P_CPN_YEAREND_TAX",type,param);

			if(rstStr[1] == null || rstStr[1].length() == 0) {
				message = "세금계산이 완료되었습니다.";
			} else {
				code = "-1";
				message = "세금계산 처리도중 : "+rstStr[1];
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

	} else if("prcYearEndCenCel".equals(cmd)) {
		//퇴직자정산계산취소

		Map paramMap = StringUtil.getRequestMap(request);
		Map mp =  StringUtil.getParamMapData(paramMap);

		String payActionCd = (String)mp.get("searchPayActionCd");
		String workYy = (String)mp.get("searchWorkYy");
		String adjustType = (String)mp.get("searchAdjustType");

		String[] type =  new String[]{"OUT","OUT","STR","STR","STR","STR","STR","STR","STR"};
		String[] param = new String[]{"","",ssnEnterCd,payActionCd,workYy,adjustType,"","",ssnSabun};

		String message = "";
		String code = "1";
		int cnt = 0;

		try {

			String[] rstStr = DBConn.executeProcedure("P_CPN_YEAREND_CANCEL",type,param);

			if(rstStr[1] == null || rstStr[1].length() == 0) {
				message = "퇴직자정산 계산취소가 완료되었습니다.";
			} else {
				code = "-1";
				message = "퇴직자정산 계산취소 처리도중 : "+rstStr[1];
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

	} else if("saveFinalCloseYn".equals(cmd)) {
		//퇴직자정산 마감 , 취소 처리

		Map mp = StringUtil.getRequestMap(request);
		mp.put("ssnEnterCd", ssnEnterCd);
		mp.put("ssnSabun", ssnSabun);
		mp.put("cmd", cmd);
		String closeYn = ((String[])mp.get("searchFinalCloseYN"))[0];
		String cancelMsg = "" ;
		if("N".equals(closeYn)) {
			cancelMsg = "취소" ;
		}

		String message = "";
		String code = "1";

		try {
			int cnt = saveFinalCloseYn(mp, locPath, ssnYeaLogYn);

			if(cnt > 0) {
				message = "퇴직자정산 마감"+cancelMsg+" 되었습니다.";
			} else {
				code = "-1";
				message="마감"+cancelMsg+"된 내용이 없습니다.";
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
	}
%>
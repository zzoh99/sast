<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="yjungsan.util.*"%>

<%@ page import="java.util.List"%>
<%@ page import="java.util.ArrayList"%>
<%@ page import="java.util.Map"%>
<%@ page import="java.util.HashMap"%>
<%@ page import="com.hr.common.logger.Log" %>

<%@ include file="../common/include/session.jsp"%>
<%@ include file="../auth/saveLog.jsp"%>
<%!
//연말정산 급여코드 조회
public Map selectYeaPayActionInfo(Map paramMap, String locPath) throws Exception {

	//파라메터 복사.
	Map pm =  StringUtil.getParamMapData(paramMap);
	//xml 파서를 이용한 방법;
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

public List selectYeaCalcCreSheet1List(Map paramMap, String locPath) throws Exception {

	//파라메터 복사.
	Map pm =  StringUtil.getParamMapData(paramMap);
	//xml 파서를 이용한 방법;
	Map queryMap = XmlQueryParser.getQueryMap(locPath);
	List listData = null;

	String searchBizPlaceCd = String.valueOf(pm.get("searchBizPlaceCd"));

	StringBuffer query   = new StringBuffer();
	query.setLength(0);

	if(searchBizPlaceCd.trim().length() != 0){
		query.append(" AND BUSINESS_PLACE_CD = #searchBizPlaceCd#");
	}

	pm.put("query", query.toString());

	try{
		//쿼리 실행및 결과 받기.
		listData  = (queryMap == null) ? null : DBConn.executeQueryList(queryMap,"selectYeaCalcCreSheet1List",pm);
		//saveLog(null, pm);
	} catch (Exception e) {
		Log.Error("[Exception] " + e);
		throw new Exception("조회에 실패하였습니다.");
	} finally {
		queryMap = null;
	}

	return listData;
}

public List selectYeaCalcCreSheet2List(Map paramMap, String locPath) throws Exception {

	//파라메터 복사.
	Map pm =  StringUtil.getParamMapData(paramMap);
	//xml 파서를 이용한 방법;
	Map queryMap = XmlQueryParser.getQueryMap(locPath);
	List listData = null;

	String searchBizPlaceCd = String.valueOf(pm.get("searchBizPlaceCd"));

	StringBuffer query   = new StringBuffer();
	query.setLength(0);

	if(searchBizPlaceCd.trim().length() != 0){
		query.append(" AND BUSINESS_PLACE_CD = #searchBizPlaceCd#");
	}

	pm.put("query", query.toString());
	try{
		//쿼리 실행및 결과 받기.
		listData  = (queryMap == null) ? null : DBConn.executeQueryList(queryMap,"selectYeaCalcCreSheet2List",pm);
		//saveLog(null, pm);
	} catch (Exception e) {
		Log.Error("[Exception] " + e);
		throw new Exception("조회에 실패하였습니다.");
	} finally {
		queryMap = null;
	}

	return listData;
}

//대상인원전체 상태 저장.
public int savePayPeopleStatus(Map paramMap, String locPath, String ssnYeaLogYn) throws Exception {

	//파라메터 복사.
	Map pm =  StringUtil.getParamMapData(paramMap);
	//xml 파서를 이용한 방법;
	Map queryMap = XmlQueryParser.getQueryMap(locPath);
	Map mp = null;

	int rstCnt = 0;

	String searchBizPlaceCd = String.valueOf(pm.get("searchBizPlaceCd"));

	StringBuffer query   = new StringBuffer();
	query.setLength(0);

	if(searchBizPlaceCd.trim().length() != 0){
		query.append(" AND BUSINESS_PLACE_CD = #searchBizPlaceCd#");
	}

	pm.put("query", query.toString());
	try{
		//쿼리 실행및 결과 받기.
		rstCnt  = DBConn.executeUpdate(queryMap, "savePayPeopleStatus", pm);
		saveLog(null, pm, ssnYeaLogYn);
	} catch (Exception e) {
		Log.Error("[Exception] " + e);
		throw new Exception("저장에 실패하였습니다.");
	} finally {
		queryMap = null;
	}

	return rstCnt;
}

//연말정산 마감 , 취소 처리
public int saveFinalCloseYn(Map paramMap, String locPath) throws Exception {

	//파라메터 복사.
	Map pm =  StringUtil.getParamMapData(paramMap);
	//xml 파서를 이용한 방법;
	Map queryMap = XmlQueryParser.getQueryMap(locPath);
	Map mp = null;

	int rstCnt = 0;

	try{
		//쿼리 실행및 결과 받기.
		rstCnt = DBConn.executeUpdate(queryMap, "saveFinalCloseTCPN811", pm);
		DBConn.executeUpdate(queryMap, "saveFinalCloseTCPN983", pm);
		DBConn.executeUpdate(queryMap, "deleteFinalCloseTCPN981", pm);
		DBConn.executeUpdate(queryMap, "insertFinalCloseTCPN981", pm);
		DBConn.executeUpdate(queryMap, "deleteFinalCloseTYEA956", pm); //연말정산을 마감할 때, 계산 당시의 옵션 기록
		DBConn.executeUpdate(queryMap, "insertFinalCloseTYEA956", pm); //연말정산을 마감할 때, 계산 당시의 옵션 기록
		
	} catch (Exception e) {
		Log.Error("[Exception] " + e);
		throw new Exception("저장에 실패하였습니다.");
	} finally {
		queryMap = null;
	}

	return rstCnt;
}

// FAQ 조회
public List selectFaqActionInList(Map paramMap, String locPath, String ssnYeaLogYn) throws Exception{

	Map pm = StringUtil.getParamMapData(paramMap);
	//xml 파서를 이용한 방법;
	Map queryMap = XmlQueryParser.getQueryMap(locPath);
	List listData = null;

	String searchValue	 = String.valueOf(pm.get("searchValue"));
	String searchKeyword = String.valueOf(pm.get("searchKeyword"));
	String searchCdValue = String.valueOf(pm.get("searchCdValue"));

	StringBuffer query   = new StringBuffer();
	StringBuffer query2  = new StringBuffer();

	query.setLength(0);
	query2.setLength(0);

	if(!searchCdValue.equals("1")){
		query.append(" AND BIZ_CD = #inputCdType#");
	}

	if(searchKeyword.trim().length() != 0){
		if(searchValue.equals("2")){
			query2.append(" AND LOWER(TITLE) LIKE LOWER('%" +searchKeyword+"%')");
		}else if(searchValue.equals("3")){
			query2.append(" AND LOWER(REPLY) LIKE LOWER('%" +searchKeyword+"%')");
		}else{
			query2.append(" AND (LOWER(TITLE) LIKE LOWER('%" +searchKeyword+"%') OR LOWER(REPLY) LIKE LOWER('%" +searchKeyword+"%'))");
		}
	}

	pm.put("query", query.toString());
	pm.put("query2", query2.toString());

	try{
		listData = (queryMap == null) ? null : DBConn.executeQueryList(queryMap, "selectFaqActionInList", pm);
		saveLog(null, pm, ssnYeaLogYn);
	}catch(Exception e){
		Log.Error("[Exception] " + e);
		throw new Exception("조회에 실패하였습니다.");
	} finally {
		queryMap = null;
	}

	return listData;
}
//연말정산 급여일자 생성
public int insertYeaPayDayTCPN201(Map paramMap, String locPath, String ssnYeaLogYn) throws Exception {

	//파라메터 복사.
	Map pm =  StringUtil.getParamMapData(paramMap);
	//xml 파서를 이용한 방법;
	Map queryMap = XmlQueryParser.getQueryMap(locPath);
	Map mp = null;

	int rstCnt = 0;

	try{
		//쿼리 실행및 결과 받기.
		rstCnt  = DBConn.executeUpdate(queryMap, "insertYeaPayDayTCPN201", pm);
		saveLog(null, pm, ssnYeaLogYn);
	} catch (Exception e) {
		Log.Error("[Exception] " + e);
		throw new Exception("저장에 실패하였습니다.");
	} finally {
		queryMap = null;
	}

	return rstCnt;
}

//임직원 메뉴 오픈
public int saveOrgAuthStatus(Map paramMap, String locPath, String ssnYeaLogYn) throws Exception {

	//파라메터 복사.
	Map pm =  StringUtil.getParamMapData(paramMap);
	//xml 파서를 이용한 방법;
	Map queryMap = XmlQueryParser.getQueryMap(locPath);
	Map mp = null;

	int rstCnt = 0;

	try{
		//쿼리 실행및 결과 받기.
		rstCnt  = DBConn.executeUpdate(queryMap, "saveOrgAuthStatus", pm);
		saveLog(null, pm, ssnYeaLogYn);
	} catch (Exception e) {
		Log.Error("[Exception] " + e);
		throw new Exception("저장에 실패하였습니다.");
	} finally {
		queryMap = null;
	}
	return rstCnt;
}

// 임직원메뉴오픈
public Map selectOrgAuthStatus(Map paramMap, String locPath, String ssnYeaLogYn) throws Exception {

	//파라메터 복사.
	Map pm =  StringUtil.getParamMapData(paramMap);
	//xml 파서를 이용한 방법;
	Map queryMap = XmlQueryParser.getQueryMap(locPath);
	Map mp = null;

	try{
		//쿼리 실행및 결과 받기.
		mp  = (queryMap==null) ? null : DBConn.executeQueryMap(queryMap,"selectOrgAuthStatus",pm);
		saveLog(null, pm, ssnYeaLogYn);
	} catch (Exception e) {
		Log.Error("[Exception] " + e);
		throw new Exception("조회에 실패하였습니다.");
	} finally {
		queryMap = null;
	}

	return mp;
}
//담당자마감여부
public Map getApprvYn(Map paramMap, String locPath, String ssnYeaLogYn) throws Exception {

    //파라메터 복사.
    Map pm =  StringUtil.getParamMapData(paramMap);
	//xml 파서를 이용한 방법;
	Map queryMap = XmlQueryParser.getQueryMap(locPath);
    Map mp = null;

    try{
       //쿼리 실행및 결과 받기.
       mp  = (queryMap==null) ? null : DBConn.executeQueryMap(queryMap,"getApprvYn",pm);
       saveLog(null, pm, ssnYeaLogYn);
    } catch (Exception e) {
       Log.Error("[Exception] " + e);
       throw new Exception("조회에 실패하였습니다.");
    } finally {
		queryMap = null;
	}

    return mp;
}


//담당자마감여부 저장
public int saveApprvYn(Map paramMap, String locPath) throws Exception {

	//파라메터 복사.
	Map pm =  StringUtil.getParamMapData(paramMap);
	//xml 파서를 이용한 방법;
	Map queryMap = XmlQueryParser.getQueryMap(locPath);
	Map mp = null;

	int rstCnt = 0;

	try{
	    //쿼리 실행및 결과 받기.
	    rstCnt  = DBConn.executeUpdate(queryMap, "saveApprvYn", pm);
	    //saveLog(null, pm);
	} catch (Exception e) {
	    Log.Error("[Exception] " + e);
	    throw new Exception("저장에 실패하였습니다.");
	} finally {
		queryMap = null;
	}
	return rstCnt;
}
//담당자마감여부
public Map getResOpenYn(Map paramMap, String locPath, String ssnYeaLogYn) throws Exception {

	//파라메터 복사.
	Map pm =  StringUtil.getParamMapData(paramMap);
	//xml 파서를 이용한 방법;
	Map queryMap = XmlQueryParser.getQueryMap(locPath);
	Map mp = null;

	try{
	 //쿼리 실행및 결과 받기.
	 mp  = (queryMap==null) ? null : DBConn.executeQueryMap(queryMap,"getResOpenYn",pm);
	 saveLog(null, pm, ssnYeaLogYn);
	} catch (Exception e) {
	 Log.Error("[Exception] " + e);
	 throw new Exception("조회에 실패하였습니다.");
	} finally {
		queryMap = null;
	}

	return mp;
}
//계산오픈여부 저장
public int saveResOpenYn(Map paramMap, String locPath) throws Exception {

	//파라메터 복사.
	Map pm =  StringUtil.getParamMapData(paramMap);
	//xml 파서를 이용한 방법;
	Map queryMap = XmlQueryParser.getQueryMap(locPath);
	Map mp = null;

	int rstCnt = 0;

	try{
	  //쿼리 실행및 결과 받기.
	  rstCnt  = DBConn.executeUpdate(queryMap, "saveResOpenYn", pm);
	  //saveLog(null, pm);
	} catch (Exception e) {
	  Log.Error("[Exception] " + e);
	  throw new Exception("저장에 실패하였습니다.");
	} finally {
		queryMap = null;
	}
	return rstCnt;
}
//연말정산 급여일자 생성
public int insertYeaPayDayTCPN201_sys(Map paramMap, String locPath, String ssnYeaLogYn) throws Exception {

	//파라메터 복사.
	Map pm =  StringUtil.getParamMapData(paramMap);
	//xml 파서를 이용한 방법;
	Map queryMap = XmlQueryParser.getQueryMap(locPath);
	Map mp = null;
	
	int rstCnt = 0;
	
	try{
	    //쿼리 실행및 결과 받기.
	    rstCnt  = DBConn.executeUpdate(queryMap, "insertYeaPayDayTCPN201_sys", pm);
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
	String locPath = xmlPath+"/yeaCalcCre/yeaCalcCre.xml";

	String ssnEnterCd = (String)session.getAttribute("ssnEnterCd");
	String ssnSabun = (String)session.getAttribute("ssnSabun");
	String ssnYeaLogYn = (String)session.getAttribute("ssnYeaLogYn");
	String cmd = (String)request.getParameter("cmd");

	if("selectYeaPayActionInfo".equals(cmd)) {
		//연말정산 급여코드 조회

		Map mp = StringUtil.getRequestMap(request);
		mp.put("ssnEnterCd", ssnEnterCd);
		mp.put("ssnSabun", ssnSabun);
		mp.put("cmd", cmd);
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

	} else if("selectYeaCalcCreSheet1List".equals(cmd)) {

		Map mp = StringUtil.getRequestMap(request);
		mp.put("ssnEnterCd", ssnEnterCd);
		mp.put("ssnSabun", ssnSabun);
		mp.put("cmd", cmd);
		List listData  = new ArrayList();
		String message = "";
		String code = "1";

		try {
			listData = selectYeaCalcCreSheet1List(mp, locPath);
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
	} else if("selectYeaCalcCreSheet2List".equals(cmd)) {

		Map mp = StringUtil.getRequestMap(request);
		mp.put("ssnEnterCd", ssnEnterCd);
		mp.put("ssnSabun", ssnSabun);
		mp.put("cmd", cmd);
		List listData  = new ArrayList();
		String message = "";
		String code = "1";

		try {
			listData = selectYeaCalcCreSheet2List(mp, locPath);
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
	} else if("savePayPeopleStatus".equals(cmd)) {
		//대상인원전체 상태 저장

		Map mp = StringUtil.getRequestMap(request);
		mp.put("ssnEnterCd", ssnEnterCd);
		mp.put("ssnSabun", ssnSabun);
		mp.put("cmd", cmd);
		String message = "";
		String code = "1";

		try {
			int cnt = savePayPeopleStatus(mp, locPath, ssnYeaLogYn);

			if(cnt > 0) {
				message = "저장되었습니다.";
			} else {
				code = "-1";
				message = "저장된 내용이 없습니다.";
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
	} else if("prcYearEndMonPayAndTax".equals(cmd)) {
		//연급여생성,세금계산

		Map paramMap = StringUtil.getRequestMap(request);
		Map mp =  StringUtil.getParamMapData(paramMap);

		String payActionCd = (String)mp.get("searchPayActionCd");
		String workYy = (String)mp.get("searchWorkYy");
		String adjustType = (String)mp.get("searchAdjustType");
		String businessPlaceCd = (String)mp.get("searchBizPlaceCd");

		String[] type =  new String[]{"OUT","OUT","STR","STR","STR","STR","STR","STR","STR"};
		String[] param = new String[]{"","",ssnEnterCd,payActionCd,workYy,adjustType,businessPlaceCd,"",ssnSabun};

		String message = "";
		String code = "1";

		try {

			String[] rstStr1 = DBConn.executeProcedure("P_CPN_YEAREND_MONPAY_"+yeaYear,type,param);

			if(rstStr1[1] == null || rstStr1[1].length() == 0) {
				String[] rstStr2 = DBConn.executeProcedure("PKG_CPN_YEA_"+yeaYear+".P_CPN_YEAREND_TAX",type,param);

				if(rstStr2[1] == null || rstStr2[1].length() == 0) {
					message = "연말정산 계산이 완료되었습니다.";
				} else {
					code = "-1";
					message = "연말정산 계산 처리도중 : "+rstStr2[1];
				}
			} else {
				code = "-1";
				message = "세금계산 처리도중 : "+rstStr1[1];
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
		//연급여생성

		Map paramMap = StringUtil.getRequestMap(request);
		Map mp =  StringUtil.getParamMapData(paramMap);

		String payActionCd = (String)mp.get("searchPayActionCd");
		String workYy = (String)mp.get("searchWorkYy");
		String adjustType = (String)mp.get("searchAdjustType");
		String businessPlaceCd = (String)mp.get("searchBizPlaceCd");

		String[] type =  new String[]{"OUT","OUT","STR","STR","STR","STR","STR","STR","STR"};
		String[] param = new String[]{"","",ssnEnterCd,payActionCd,workYy,adjustType,businessPlaceCd,"",ssnSabun};

		String message = "";
		String code = "1";
		int cnt = 0;

		try {

			String[] rstStr = DBConn.executeProcedure("P_CPN_YEAREND_MONPAY_"+yeaYear,type,param);

			if(rstStr[1] == null || rstStr[1].length() == 0) {
				message = "연급여 생성이 완료되었습니다.";
			} else {
				code = "-1";
				message = "연급여 생성 처리도중 : "+rstStr[1];
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
		String businessPlaceCd = (String)mp.get("searchBizPlaceCd");

		String[] type =  new String[]{"OUT","OUT","STR","STR","STR","STR","STR","STR","STR"};
		String[] param = new String[]{"","",ssnEnterCd,payActionCd,workYy,adjustType,businessPlaceCd,"",ssnSabun};

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
		//연말정산계산취소

		Map paramMap = StringUtil.getRequestMap(request);
		Map mp =  StringUtil.getParamMapData(paramMap);

		String payActionCd = (String)mp.get("searchPayActionCd");
		String workYy = (String)mp.get("searchWorkYy");
		String adjustType = (String)mp.get("searchAdjustType");
		String businessPlaceCd = (String)mp.get("searchBizPlaceCd");

		String[] type =  new String[]{"OUT","OUT","STR","STR","STR","STR","STR","STR","STR"};
		String[] param = new String[]{"","",ssnEnterCd,payActionCd,workYy,adjustType,businessPlaceCd,"",ssnSabun};
		String message = "";
		String code = "1";
		int cnt = 0;

		try {

			String[] rstStr = DBConn.executeProcedure("P_CPN_YEAREND_CANCEL",type,param);

			if(rstStr[1] == null || rstStr[1].length() == 0) {
				message = "연말정산 계산취소가 완료되었습니다.";
			} else {
				code = "-1";
				message = "연말정산 계산취소 처리도중 : "+rstStr[1];
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
		
	} else if("delEmpData".equals(cmd)) {
		//세금모의계산 자료 삭제

		Map paramMap = StringUtil.getRequestMap(request);
		Map mp =  StringUtil.getParamMapData(paramMap);
		String workYy = (String)mp.get("searchWorkYy");

		String[] type =  new String[]{"OUT","OUT","STR","STR","STR"};
		String[] param = new String[]{"","",ssnEnterCd,workYy,ssnSabun};

		String message = "";
		String code = "1";
		int cnt = 0;

		try {

			String[] rstStr = DBConn.executeProcedure("PKG_CPN_YEA_"+yeaYear+"_EMP.P_CPN_EMP_DEL",type,param);

			if(rstStr[1] == null || rstStr[1].length() == 0) {
				message = "세금모의계산 자료 삭제되었습니다.";
			} else {
				code = "-1";
				message = "세금모의계산 자료 삭제 처리도중 : "+rstStr[1];
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
		//연말정산 마감 , 취소 처리

		Map mp = StringUtil.getRequestMap(request);
		mp.put("ssnEnterCd", ssnEnterCd);
		mp.put("ssnSabun", ssnSabun);
		mp.put("cmd", cmd);
		String closeYn = ((String[])mp.get("searchFinalCloseYN"))[0];
		String cancelMsg = "" ;
		if("N".equals(closeYn)) {
			cancelMsg = "취소" ;
		}

		mp.put("closeYn", closeYn);

		String message = "";
		String code = "1";

		try {
			int cnt = saveFinalCloseYn(mp, locPath);

			if(cnt > 0) {
				message = "연말정산 마감"+cancelMsg+" 되었습니다.";
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
	}else if("selectFaqActionInList".equals(cmd)){
		//FAQ 조회

		Map mp = StringUtil.getRequestMap(request);

		mp.put("ssnEnterCd", ssnEnterCd);
		mp.put("ssnSabun", ssnSabun);
		mp.put("cmd", cmd);
		List listData  = new ArrayList();
		String message = "";
		String code = "1";

		try {
			listData = selectFaqActionInList(mp, locPath, ssnYeaLogYn);
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
	else if("insertYeaPayDayTCPN201".equals(cmd)) {
		//연말정산 급여일자 생성

		Map mp = StringUtil.getRequestMap(request);
		mp.put("ssnEnterCd", ssnEnterCd);
		mp.put("ssnSabun", ssnSabun);
		mp.put("cmd", cmd);
		String message = "";
		String code = "1";

		try {
			int cnt = insertYeaPayDayTCPN201(mp, locPath, ssnYeaLogYn);

			if(cnt > 0) {
				message = "저장되었습니다.";
			} else {
				code = "-1";
				message = "저장된 내용이 없습니다.";
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
	}else if("saveOrgAuthStatus".equals(cmd)) {
		//대상인원전체 상태 저장

		Map mp = StringUtil.getRequestMap(request);
		mp.put("ssnEnterCd", ssnEnterCd);
		mp.put("ssnSabun", ssnSabun);
		mp.put("cmd", cmd);
		String message = "";
		String code = "1";

		try {
			int cnt = saveOrgAuthStatus(mp, locPath, ssnYeaLogYn);

			if(cnt > 0) {
				message = "저장되었습니다.";
			} else {
				code = "-1";
				message = "저장된 내용이 없습니다.";
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
	}else if("selectOrgAuthStatus".equals(cmd)) {
		//연말정산 급여코드 조회

		Map mp = StringUtil.getRequestMap(request);
		mp.put("ssnEnterCd", ssnEnterCd);
		mp.put("ssnSabun", ssnSabun);
		mp.put("cmd", cmd);
		Map mapData  = new HashMap();
		String message = "";
		String code = "1";

		try {
			mapData = selectOrgAuthStatus(mp, locPath, ssnYeaLogYn);
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

	}else if("getApprvYn".equals(cmd)) {
        //연말정산 담당자마감여부 조회

        Map mp = StringUtil.getRequestMap(request);
        mp.put("ssnEnterCd", ssnEnterCd);
        mp.put("ssnSabun", ssnSabun);
        mp.put("cmd", cmd);
        Map mapData  = new HashMap();
        String message = "";
        String code = "1";

        try {
            mapData = getApprvYn(mp, locPath, ssnYeaLogYn);
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

    } else if("saveApprvYn".equals(cmd)) {
        //대상자마감

        Map mp = StringUtil.getRequestMap(request);
        mp.put("ssnEnterCd", ssnEnterCd);
        mp.put("ssnSabun", ssnSabun);
        mp.put("cmd", cmd);
        String message = "";
        String code = "1";

        try {
            int cnt = saveApprvYn(mp, locPath);

            if(cnt > 0) {
                message = "저장되었습니다.";
            } else {
                code = "-1";
                message = "저장된 내용이 없습니다.";
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
    } else if("getResOpenYn".equals(cmd)) {
        //연말정산 계산결과오픈 조회

        Map mp = StringUtil.getRequestMap(request);
        mp.put("ssnEnterCd", ssnEnterCd);
        mp.put("ssnSabun", ssnSabun);
        mp.put("cmd", cmd);
        Map mapData  = new HashMap();
        String message = "";
        String code = "1";

        try {
            mapData = getResOpenYn(mp, locPath, ssnYeaLogYn);
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

    } else if("saveResOpenYn".equals(cmd)) {
        //대상자마감

        Map mp = StringUtil.getRequestMap(request);
        mp.put("ssnEnterCd", ssnEnterCd);
        mp.put("ssnSabun", ssnSabun);
        mp.put("cmd", cmd);
        String message = "";
        String code = "1";

        try {
            int cnt = saveResOpenYn(mp, locPath);

            if(cnt > 0) {
                message = "저장되었습니다.";
            } else {
                code = "-1";
                message = "저장된 내용이 없습니다.";
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
    } else if("insertYeaPayDayTCPN201_sys".equals(cmd)) {
        //연말정산 급여일자 생성

        Map mp = StringUtil.getRequestMap(request);
        mp.put("ssnEnterCd", ssnEnterCd);
        mp.put("ssnSabun", ssnSabun);
        mp.put("cmd", cmd);
        String message = "";
        String code = "1";

        try {
            int cnt = insertYeaPayDayTCPN201_sys(mp, locPath, ssnYeaLogYn);

            if(cnt > 0) {
                message = "저장되었습니다.";
            } else {
                code = "-1";
                message = "저장된 내용이 없습니다.";
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
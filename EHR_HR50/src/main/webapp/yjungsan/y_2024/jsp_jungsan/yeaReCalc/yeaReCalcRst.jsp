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
<%@ include file="../auth/saveLog.jsp"%>
<%!

public List selectYeaReCalcSheet2List(Map paramMap, String locPath) throws Exception {

	//파라메터 복사.
	Map pm =  StringUtil.getParamMapData(paramMap);
	//xml 파서를 이용한 방법;
	Map queryMap = XmlQueryParser.getQueryMap(locPath);
	List listData = null;

	try{
		//쿼리 실행및 결과 받기.
		listData  = (queryMap == null) ? null : DBConn.executeQueryList(queryMap,"selectYeaReCalcSheet2List",pm);
// 		saveLog(null, pm);
	} catch (Exception e) {
		Log.Error("[Exception] " + e);
		throw new Exception("조회에 실패하였습니다.");
	} finally {
		queryMap = null;
	}

	return listData;
}

public List selectYeaReCalcSheet3List(Map paramMap, String locPath) throws Exception {

	//파라메터 복사.
	Map pm =  StringUtil.getParamMapData(paramMap);
	//xml 파서를 이용한 방법;
	Map queryMap = XmlQueryParser.getQueryMap(locPath);
	List listData = null;

	try{
		//쿼리 실행및 결과 받기.
		listData  = (queryMap == null) ? null : DBConn.executeQueryList(queryMap,"selectYeaReCalcSheet3List",pm);
// 		saveLog(null, pm);
	} catch (Exception e) {
		Log.Error("[Exception] " + e);
		throw new Exception("조회에 실패하였습니다.");
	} finally {
		queryMap = null;
	}

	return listData;
}

public List selectYeaReCalcUnClosed(Map paramMap, String locPath) throws Exception {

	//파라메터 복사.
	Map pm =  StringUtil.getParamMapData(paramMap);
	//xml 파서를 이용한 방법;
	Map queryMap = XmlQueryParser.getQueryMap(locPath);
	List listData = null;

	try{
		//쿼리 실행및 결과 받기.
		listData  = (queryMap == null) ? null : DBConn.executeQueryList(queryMap,"selectYeaReCalcUnClosed",pm);
// 		saveLog(null, pm);
	} catch (Exception e) {
		Log.Error("[Exception] " + e);
		throw new Exception("조회에 실패하였습니다.");
	} finally {
		queryMap = null;
	}

	return listData;
}

public Map selectYeaReCalcUnClosedCnt(Map paramMap, String locPath) throws Exception {

	//파라메터 복사.
	Map pm =  StringUtil.getParamMapData(paramMap);
	//xml 파서를 이용한 방법;
	Map queryMap = XmlQueryParser.getQueryMap(locPath);
	Map dataMap = null;

	try{
		//쿼리 실행및 결과 받기.
		dataMap  = (queryMap == null) ? null : DBConn.executeQueryMap(queryMap,"selectYeaReCalcUnClosedCnt",pm);
// 		saveLog(null, pm);
	} catch (Exception e) {
		Log.Error("[Exception] " + e);
		throw new Exception("조회에 실패하였습니다.");
	} finally {
		queryMap = null;
	}

	return dataMap;
}

//정산용 PAY_ACTION_CD 조회
public List selectYeaPayActionCdList(Map paramMap, String locPath) throws Exception {

	//파라메터 복사.
	Map pm =  StringUtil.getParamMapData(paramMap);
	//xml 파서를 이용한 방법;
	Map queryMap = XmlQueryParser.getQueryMap(locPath);
	List list = null;

	try{
		//쿼리 실행및 결과 받기.
		list  = (queryMap == null) ? null : DBConn.executeQueryList(queryMap,"selectYeaPayActionCdList",pm);
	} catch (Exception e) {
		Log.Error("[Exception] " + e);
		throw new Exception("조회에 실패하였습니다.");
	} finally {
		queryMap = null;
	}

	return list;
}

//정산용 PAY_ACTION_CD 조회
public List selectYeaPayActionCdList2(Map paramMap, String locPath) throws Exception {

	//파라메터 복사.
	Map pm =  StringUtil.getParamMapData(paramMap);
	//xml 파서를 이용한 방법;
	Map queryMap = XmlQueryParser.getQueryMap(locPath);
	List list = null;

	try{
		//쿼리 실행및 결과 받기.
		list  = (queryMap == null) ? null : DBConn.executeQueryList(queryMap,"selectYeaPayActionCdList2",pm);
	} catch (Exception e) {
		Log.Error("[Exception] " + e);
		throw new Exception("조회에 실패하였습니다.");
	} finally {
		queryMap = null;
	}

	return list;
}

%>

<%
	String locPath = xmlPath+"/yeaReCalc/yeaReCalc.xml";

	String ssnEnterCd = (String)session.getAttribute("ssnEnterCd");
	String ssnSabun = (String)session.getAttribute("ssnSabun");
	String ssnYeaLogYn = (String)session.getAttribute("ssnYeaLogYn");
	String cmd = (String)request.getParameter("cmd");

	if("selectYeaReCalcSheet2List".equals(cmd)) {

		Map mp = StringUtil.getRequestMap(request);
		mp.put("ssnEnterCd", ssnEnterCd);
		mp.put("ssnSabun", ssnSabun);

		String mSearchReSeq = (String)request.getParameter("mSearchReSeq");
		
		if (null == mSearchReSeq || "".equals(mSearchReSeq) || "''".equals(mSearchReSeq) || "null".equals(mSearchReSeq)) {
			mp.put("mSearchReSeqSQL", " ");
		} else {
			mp.put("mSearchReSeqSQL", "AND E.RE_SEQ IN ( " + mSearchReSeq + " )");
		}

		List listData  = new ArrayList();
		String message = "";
		String code = "1";

		try {
			listData = selectYeaReCalcSheet2List(mp, locPath);
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
	} else if("selectYeaReCalcSheet3List".equals(cmd)) {

		Map mp = StringUtil.getRequestMap(request);
		mp.put("ssnEnterCd", ssnEnterCd);
		mp.put("ssnSabun", ssnSabun);

		String mSearchReSeq = (String)request.getParameter("mSearchReSeq");
		
		if (null == mSearchReSeq || "".equals(mSearchReSeq) || "''".equals(mSearchReSeq) || "null".equals(mSearchReSeq)) {
			mp.put("mSearchReSeqSQL", " ");
		} else {
			mp.put("mSearchReSeqSQL", "AND E.RE_SEQ IN ( " + mSearchReSeq + " )");
		}

		List listData  = new ArrayList();
		String message = "";
		String code = "1";

		try {
			listData = selectYeaReCalcSheet3List(mp, locPath);
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
	} else if("selectYeaReCalcUnClosed".equals(cmd)) {

		Map mp = StringUtil.getRequestMap(request);
		mp.put("ssnEnterCd", ssnEnterCd);
		mp.put("ssnSabun", ssnSabun);

		String mSearchReSeq = (String)request.getParameter("mSearchReSeq");
		
		if (null == mSearchReSeq || "".equals(mSearchReSeq) || "''".equals(mSearchReSeq) || "null".equals(mSearchReSeq)) {
			mp.put("mSearchReSeqSQL", " ");
		} else {
			mp.put("mSearchReSeqSQL", "AND E.RE_SEQ IN ( " + mSearchReSeq + " )");
		}

		List listData  = new ArrayList();
		String message = "";
		String code = "1";

		try {
			listData = selectYeaReCalcUnClosed(mp, locPath);
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
	} else if("selectYeaReCalcUnClosedCnt".equals(cmd)) {

		Map mp = StringUtil.getRequestMap(request);
		mp.put("ssnEnterCd", ssnEnterCd);
		mp.put("ssnSabun", ssnSabun);

		String mSearchReSeq = (String)request.getParameter("mSearchReSeq");
		
		if (null == mSearchReSeq || "".equals(mSearchReSeq) || "''".equals(mSearchReSeq) || "null".equals(mSearchReSeq)) {
			mp.put("mSearchReSeqSQL", " ");
		} else {
			mp.put("mSearchReSeqSQL", "AND E.RE_SEQ IN ( " + mSearchReSeq + " )");
		}

		Map dataMap = new HashMap();

		String message = "";
		String code = "1";

		try {
			dataMap = selectYeaReCalcUnClosedCnt(mp, locPath);
		} catch(Exception e) {
			code = "-1";
			message = e.getMessage();
		}

		Map mapCode = new HashMap();
		mapCode.put("Code", code);
		mapCode.put("Message", message);

		Map rstMap = new HashMap();
		rstMap.put("Result", mapCode);
		rstMap.put("Data", dataMap);
		out.print((new org.json.JSONObject(rstMap)).toString());
	} else if("selectYeaPayActionCdList".equals(cmd)) {

		Map mp = StringUtil.getRequestMap(request);
		mp.put("ssnEnterCd", ssnEnterCd);
		mp.put("ssnSabun", ssnSabun);

		String mSearchReSeq = (String)request.getParameter("mSearchReSeq");
		
		if (null == mSearchReSeq || "".equals(mSearchReSeq) || "''".equals(mSearchReSeq) || "null".equals(mSearchReSeq)) {
			mp.put("mSearchReSeqSQL", " ");
		} else {
			mp.put("mSearchReSeqSQL", "AND E.RE_SEQ IN ( " + mSearchReSeq + " )");
		}

		List listData  = new ArrayList();
		String message = "";
		String code = "1";

		try {
			listData = selectYeaPayActionCdList(mp, locPath);
		} catch(Exception e) {
			code = "-1";
			message = e.getMessage();
		}

		Map mapCode = new HashMap();
		mapCode.put("Code", code);
		mapCode.put("Message", message);

		Map rstMap = new HashMap();
		rstMap.put("Result", mapCode);
		rstMap.put("codeList", listData == null ? null : (List)listData);
		out.print((new org.json.JSONObject(rstMap)).toString());
	}  else if("selectYeaPayActionCdList2".equals(cmd)) {

		Map mp = StringUtil.getRequestMap(request);
		mp.put("ssnEnterCd", ssnEnterCd);
		mp.put("ssnSabun", ssnSabun);

		String mSearchReSeq = (String)request.getParameter("mSearchReSeq");
		
		if (null == mSearchReSeq || "".equals(mSearchReSeq) || "''".equals(mSearchReSeq) || "null".equals(mSearchReSeq)) {
			mp.put("mSearchReSeqSQL", " ");
		} else {
			mp.put("mSearchReSeqSQL", "AND E.RE_SEQ IN ( " + mSearchReSeq + " )");
		}

		List listData  = new ArrayList();
		String message = "";
		String code = "1";

		try {
			listData = selectYeaPayActionCdList2(mp, locPath);
		} catch(Exception e) {
			code = "-1";
			message = e.getMessage();
		}

		Map mapCode = new HashMap();
		mapCode.put("Code", code);
		mapCode.put("Message", message);

		Map rstMap = new HashMap();
		rstMap.put("Result", mapCode);
		rstMap.put("codeList", listData == null ? null : (List)listData);
		out.print((new org.json.JSONObject(rstMap)).toString());
	} else if("saveYeaReCalcSheet3".equals(cmd)) {
		//정산 재계산 대상자 (TCPN884) 저장

		Map paramMap = StringUtil.getRequestMap(request);
		paramMap.put("ssnEnterCd", ssnEnterCd);
		paramMap.put("ssnSabun", ssnSabun);

		List listMap = StringUtil.getParamListData(paramMap);

		String message = "";
		String code = "1";
		int cnt = 0;

		try {

			for(int i = 0; i < listMap.size(); i++) {
				Map data = (Map)listMap.get(i);

				String sStatus           = (String)data.get("sStatus");
				
				String work_yy           = (String)data.get("work_yy");
				String sabun             = (String)data.get("sabun");
				
				String adjust_type_inst  = (String)data.get("adjust_type_inst");  // 최종→이거 (1=연말정산최종/3=퇴직정산최종/1R2=연말정산2회차/3R1=연말정산1회차)
				String adjust_type_orig  = (String)data.get("adjust_type_orig");  // 이거→최종 (1=연말정산최종/3=퇴직정산최종/1R2=연말정산2회차/3R1=연말정산1회차)
				String adjust_type       = (String)data.get("adjust_type");		  // 정산구분  (1=연말정산최종/3=퇴직정산최종/1R2=연말정산2회차/3R1=연말정산1회차)
				String adjust_type_nm    = (String)data.get("adjust_type_nm");    // 정산구분  (1=연말정산/3=퇴직정산)
								
				String re_cre            = (String)data.get("re_cre");            // 선택 체크박스
				
				String pay_people_status = (String)data.get("pay_people_status");
				String final_close_yn    = (String)data.get("final_close_yn");
				
				String gubun             = (String)data.get("gubun");             // 재정산 구분				
				String re_seq            = (String)data.get("re_seq");            // 재정산 차수
				String re_ymd            = (String)data.get("re_ymd");            // 재정산 추징일
				String re_reason         = (String)data.get("re_reason");         // 재정산 사유
				String memo              = (String)data.get("memo");              // 재정산 메모
				
				String[] type =  new String[]{ "OUT","OUT"
				        , "STR", "STR", "STR", "STR", "STR", "STR", "STR", "STR", "STR"
				        , "STR", "STR", "STR", "STR", "STR", "STR", "STR", "STR"};
				
				String[] param = new String[]{ "",""
						, ssnEnterCd, sStatus, work_yy, sabun
						, adjust_type_inst, adjust_type_orig, adjust_type, adjust_type_nm, re_cre            
						, pay_people_status, final_close_yn, gubun, re_seq, re_ymd, re_reason, memo, ssnSabun };

				String[] rstStr = DBConn.executeProcedure("PKG_CPN_YEA_"+yeaYear+"_EMP.P_CPN_YEA_RECAL_EMP",type,param);

				if(rstStr[1] != null && rstStr[1].length() > 0) {
					message = rstStr[1]+"\n";
				}
				cnt++;
			}

			if(cnt > 0) {
				if(message.length() == 0) {
					message = "저장되었습니다.";
				}
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
	} else if("prcYearEndRecalTax".equals(cmd)) {
		//세금계산

		Map paramMap = StringUtil.getRequestMap(request);
		Map mp =  StringUtil.getParamMapData(paramMap);

		String workYy     = (String)mp.get("searchWorkYy");
		String adjustType = (String)mp.get("searchAdjustType");
		String sbNm       = (String)mp.get("searchSbNm");
		String jobMode    = (String)mp.get("jobMode");

		String[] type  =  new String[]{"OUT","OUT","STR","STR","STR","STR","STR","STR"};
		String[] param = new String[]{"","",ssnEnterCd,workYy,adjustType,sbNm,jobMode,ssnSabun};

		String message = "";
		String code = "1";
		int cnt = 0;

		try {

			String[] rstStr = DBConn.executeProcedure("PKG_CPN_YEA_"+yeaYear+"_EMP.P_CPN_YEA_RECAL_TAX",type,param);
			
			if(rstStr[1] == null || rstStr[1].length() == 0) {
				message = "재계산 작업이 완료되었습니다.";
			} else {
				code = "-1";
				message = "재계산 작업 처리도중 : "+rstStr[1];
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
	} else if("finishYeaReCalcSheet3".equals(cmd)) {
		//정산 재계산 대상자 (TCPN884) 마감 저장
		
		Map paramMap = StringUtil.getRequestMap(request);
		paramMap.put("ssnEnterCd", ssnEnterCd);
		paramMap.put("ssnSabun", ssnSabun);

		List listMap = StringUtil.getParamListData(paramMap);

		String message = "";
		String code = "1";
		int cnt = 0;

		try {

			String final_close_yn = (String)request.getParameter("type");
			
			for(int i = 0; i < listMap.size(); i++) {
				Map data = (Map)listMap.get(i);

				String sStatus           = (String)data.get("sStatus");
				
				String work_yy           = (String)data.get("work_yy");
				String sabun             = (String)data.get("sabun");
				String adjust_type       = (String)data.get("adjust_type");		  // 정산구분  (1=연말정산최종/3=퇴직정산최종/1R2=연말정산2회차/3R1=연말정산1회차)
				
				String re_cre            = (String)data.get("re_cre");            // 선택 체크박스
				String pay_people_status = (String)data.get("pay_people_status"); // 재정산 상태
				
				String re_ymd            = (String)data.get("re_ymd");            // 재정산 추징일
				String re_reason         = (String)data.get("re_reason");         // 재정산 사유
				String memo              = (String)data.get("memo");              // 재정산 메모
				
				if ("Y".equals(re_cre) && "J".equals(pay_people_status)) {
					String[] type =  new String[]{ "OUT","OUT"
					        , "STR", "STR", "STR", "STR", "STR"
					        , "STR", "STR", "STR", "STR"};
					
					String[] param = new String[]{ "",""
							, ssnEnterCd, work_yy, adjust_type, sabun, final_close_yn
                            , re_ymd, re_reason, memo, ssnSabun };
	
					String[] rstStr = DBConn.executeProcedure("PKG_CPN_YEA_"+yeaYear+"_EMP.P_CPN_YEA_RECAL_CLOSE_YN",type,param);
	
					if(rstStr[1] != null && rstStr[1].length() > 0) {
						message = rstStr[1]+"\n";
					}
					cnt++;
				}
			}

			if(cnt > 0) {
				if(message.length() == 0) {
					message = "저장되었습니다.";
				}
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
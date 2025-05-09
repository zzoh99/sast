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

<%!
//주택자금 공제구분코드 조회
public List selectHouseDecCdList(Map paramMap, String locPath) throws Exception {

	//파라메터 복사.
	Map pm =  StringUtil.getParamMapData(paramMap);
	Map queryMap = XmlQueryParser.getQueryMap(locPath);
	List listData = null;
	
	try{
		//쿼리 실행및 결과 받기.
		listData  = (queryMap == null) ? null : DBConn.executeQueryList(queryMap,"selectHouseDecCdList",pm);
	} catch (Exception e) {
		Log.Error("[Exception] " + e);
		throw new Exception("조회에 실패하였습니다.");
	}
	
	return listData;
}


//주택자금 자료 조회
public List selectYeaDataHouList(Map paramMap, String locPath) throws Exception {

	//파라메터 복사.
	Map pm =  StringUtil.getParamMapData(paramMap);
	Map queryMap = XmlQueryParser.getQueryMap(locPath);
	List listData = null;
	
	try{
		//쿼리 실행및 결과 받기.
		listData  = (queryMap == null) ? null : DBConn.executeQueryList(queryMap,"selectYeaDataHouList",pm);
	} catch (Exception e) {
		Log.Error("[Exception] " + e);
		throw new Exception("조회에 실패하였습니다.");
	}
	
	return listData;
}

%>

<%
	String locPath = xmlPath+"/yeaData/yeaDataHou.xml";

	String ssnEnterCd = (String)session.getAttribute("ssnEnterCd");
	String ssnSabun = (String)session.getAttribute("ssnSabun");
	String cmd = (String)request.getParameter("cmd");
	String codeType = (String)request.getParameter("codeType");

	if("selectHouseDecCdList".equals(cmd)) {
		//주택자금 공제구분코드 조회
		Map mp = StringUtil.getRequestMap(request);
		mp.put("ssnEnterCd", ssnEnterCd);
		mp.put("ssnSabun", ssnSabun);
		
// 		if ( "1".equals(codeType) ) mp.put("searchCode_s", " AND CODE NOT IN ('20', '60') "); // 20 - 임차차입금원리금상환액_거주자, 60 - 월세액
// 		else if ( "2".equals(codeType) ) mp.put("searchCode_s", " AND CODE = '60' "); // 20 - 임차차입금원리금상환액_거주자, 60 - 월세액
// 		else if ( "3".equals(codeType) ) mp.put("searchCode_s", " AND CODE = '20' "); // 20 - 임차차입금원리금상환액_거주자, 60 - 월세액
// 		else if ( "4".equals(codeType) ) mp.put("searchCode_s", " AND CODE = '20' "); // 20 - 임차차입금원리금상환액_거주자, 60 - 월세액
// 		else mp.put("searchCode_s", "");
		
		List listData  = new ArrayList();
		String message = "";
		String code = "1";
	
		try {
			listData = selectHouseDecCdList(mp, locPath);
		} catch(Exception e) {
			code = "-1";
			message = e.getMessage();
		}
		
		Map mapCode = new HashMap();
		mapCode.put("Code", code); //ajax 성공코드 1번, 그외 오류
		mapCode.put("Message", message);
		
		Map rstMap = new HashMap();
		rstMap.put("Result", mapCode);
		rstMap.put("codeList", (List)listData);
		
		out.print((new org.json.JSONObject(rstMap)).toString());
		
	} else if("selectYeaDataHouList".equals(cmd)) {
		//주택자금 자료 조회
		
		Map mp = StringUtil.getRequestMap(request);
		mp.put("ssnEnterCd", ssnEnterCd);
		mp.put("ssnSabun", ssnSabun);
		
// 		if ( "1".equals(codeType) ) mp.put("searchCode_s", " AND HOUSE_DEC_CD NOT IN ('20', '60') "); // 20 - 임차차입금원리금상환액_거주자, 60 - 월세액
// 		else if ( "2".equals(codeType) ) mp.put("searchCode_s", " AND HOUSE_DEC_CD = '60' "); // 20 - 임차차입금원리금상환액_거주자, 60 - 월세액
// 		else if ( "3".equals(codeType) ) mp.put("searchCode_s", " AND HOUSE_DEC_CD = '20' AND KEOJUZA_GUBUN = '1' "); // 20 - 임차차입금원리금상환액_거주자, 60 - 월세액
// 		else if ( "4".equals(codeType) ) mp.put("searchCode_s", " AND HOUSE_DEC_CD = '20' AND KEOJUZA_GUBUN = '2' "); // 20 - 임차차입금원리금상환액_거주자, 60 - 월세액
// 		else mp.put("searchCode_s", "");
		
		List listData  = new ArrayList();
		String message = "";
		String code = "1";
	
		try {
			listData = selectYeaDataHouList(mp, locPath);
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
		
	} else if("saveYeaDataHou".equals(cmd)) {
		//주택자금 저장.
		
		Map paramMap = StringUtil.getRequestMap(request);
		List saveList = StringUtil.getParamListData(paramMap);
		
		String[] type =  new String[]{"OUT","OUT","STR","STR","STR"
				,"STR","STR","STR","STR","STR"
				,"STR","STR","STR","STR","STR"
				,"STR","STR","STR","STR","STR","STR","STR","STR"
				,"STR"};
		
		String message = "";
		String code = "1";
		int cnt = 0;
		
		try {
			
			if(saveList != null && saveList.size() > 0) {
				for(int i = 0; i < saveList.size(); i++) {
					Map mp = (Map)saveList.get(i);
					String sStatus = StringUtil.nvl((String)mp.get("sStatus"));
					String workYy = StringUtil.nvl((String)mp.get("work_yy"));
					String adjustType = StringUtil.nvl((String)mp.get("adjust_type"));
					String sabun = StringUtil.nvl((String)mp.get("sabun"));
					String houseDecCd = StringUtil.nvl((String)mp.get("house_dec_cd"));
					String seq = StringUtil.nvl((String)mp.get("seq"));
					
					String conSYmd = StringUtil.nvl((String)mp.get("con_s_ymd"));
					String conEYmd = StringUtil.nvl((String)mp.get("con_e_ymd"));
					String rentMon = StringUtil.nvl((String)mp.get("rent_mon"));
					String taxDay = StringUtil.nvl((String)mp.get("tax_day"));
					String applMon = StringUtil.nvl((String)mp.get("appl_mon"));
					String adjInputType = StringUtil.nvl((String)mp.get("adj_input_type"));
					
					String name_imdaein = StringUtil.nvl((String)mp.get("name_imdaein"));	// 임대인 및 대주 성명
					String res_no_imdaein = StringUtil.nvl((String)mp.get("res_no_imdaein"));	// 임대인 및 대주 주민등록번호
					String keojuza_gubun = StringUtil.nvl((String)mp.get("keojuza_gubun"));	// 거주자 주택임차차입금간 구분(1:금전소비대차계약, 2:임대차계약)
					String chaib_rate = StringUtil.nvl((String)mp.get("chaib_rate"));	// 차입금이자율
					String wonri_mon = StringUtil.nvl((String)mp.get("wonri_mon"));	// 금전소비대차 원리금상환액_원리금
					String ija_mon = StringUtil.nvl((String)mp.get("ija_mon"));	// 금전소비대차 원리금상환액_이자
					String address = StringUtil.nvl((String)mp.get("address"));	// 주소
					
					String feedbackType = (String)mp.get("feedback_type");
					
					String[] param = new String[]{"","",sStatus,ssnEnterCd,workYy
							,adjustType,sabun,houseDecCd,seq,conSYmd
							,conEYmd,rentMon,taxDay,applMon,adjInputType
							,name_imdaein, res_no_imdaein, keojuza_gubun, chaib_rate, wonri_mon, ija_mon, address, feedbackType
							,ssnSabun};
					
					String[] rstStr = DBConn.executeProcedure("PKG_CPN_YEA_"+yeaYear+"_SYNC.MTH_RENT_INS",type,param);
					
					if(rstStr[1] == null || rstStr[1].length() == 0) {
						cnt++;
					} else {
						message = message + "\n\n" + rstStr[1];
					}
				}
			}
			
			if(cnt > 0) {
				message = cnt+"건이 처리되었습니다." + message;
			} else {
				code = "-1";
				message = "처리된 내용이 없습니다." + message;
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
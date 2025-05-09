<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="yjungsan.util.*"%>
<%@ page import="yjungsan.exception.*"%>
<%@ page import="java.sql.Connection"%>
<%@ page import="java.util.List"%>
<%@ page import="java.util.ArrayList"%>
<%@ page import="java.util.Map"%>
<%@ page import="java.util.HashMap"%>

<%@ page import="org.json.JSONObject" %>
<%@ page import="org.json.JSONArray" %>
<%@ page import="com.hr.common.logger.Log" %>
<%@ include file="../common/include/session.jsp"%>
<%@ include file="../auth/saveLog.jsp"%>
<%!
//연말정산 대상자 조회
public List selectYeaReCalcPeopleList(Map paramMap, String locPath, String ssnYeaLogYn) throws Exception {

	//파라메터 복사.
	Map pm =  StringUtil.getParamMapData(paramMap);
	//xml 파서를 이용한 방법;
	Map queryMap = XmlQueryParser.getQueryMap(locPath);
	List listData = null;

	try{
		//쿼리 실행및 결과 받기.
		listData  = (queryMap == null) ? null : DBConn.executeQueryList(queryMap,"selectYeaReCalcPeopleList",pm);
		saveLog(null, pm, ssnYeaLogYn);
	} catch (Exception e) {
		Log.Error("[Exception] " + e);
		throw new Exception("조회에 실패하였습니다.");
	} finally {
		queryMap = null;
	}

	return listData;
}

//연말정산 대상자 저장.
public int saveYeaReCalcPeople(List paramList, String locPath, String ssnYeaLogYn) throws Exception {

	Connection conn = DBConn.getConnection();
	int rstTotCnt = 0;
	int rstCnt = 0;
	//xml 파서를 이용한 방법;
	Map queryMap = XmlQueryParser.getQueryMap(locPath);

	if(paramList != null && paramList.size() > 0 && conn != null) {

		conn.setAutoCommit(false);

		try{
			for(int i = 0; i < paramList.size(); i++ ) {
				rstCnt = 0;
				String query = "";
				Map mp = (Map)paramList.get(i);
				String sStatus = (String)mp.get("sStatus");
                Map mp2 = (Map)paramList.get(0);
                String menuNm = (String)mp2.get("menuNm");
                mp.put("menuNm", menuNm);
				
                if("U".equals(sStatus)) {
					rstCnt += DBConn.executeUpdate(conn, queryMap, "updateYeaReCalcPeople", mp);
					rstCnt += DBConn.executeUpdate(conn, queryMap, "updateYeaReCalcPeopleAdjYmd", mp);
					if(rstCnt > 0) DBConn.executeUpdate(conn, queryMap, "updateYeaReCalc884", mp); //변경사항이 있으면, 작업대상(재계산) 상태로 변경한다
					
					rstTotCnt += rstCnt;
				}
				saveLog(conn, mp, ssnYeaLogYn);
			}

			//커밋
			conn.commit();
		} catch(UserException e) {
			try {
				//롤백
				conn.rollback();
			} catch (Exception e1) {
				Log.Error("[rollback Exception] " + e);
			}
			rstTotCnt = 0;
			Log.Error("[Exception] " + e);
			throw new Exception(e.getMessage());
		} catch(Exception e) {
			try {
				//롤백
				conn.rollback();
			} catch (Exception e1) {
				Log.Error("[rollback Exception] " + e);
			}
			rstTotCnt = 0;
			Log.Error("[Exception] " + e);
			throw new Exception("저장에 실패하였습니다.");
		} finally {
			DBConn.closeConnection(conn, null, null);
	        queryMap = null;
		}
	}

	return rstTotCnt;
}

%>

<%
	String locPath = xmlPath+"/yeaReCalc/yeaReCalcPeople.xml";

	String ssnEnterCd = (String)session.getAttribute("ssnEnterCd");
	String ssnSabun = (String)session.getAttribute("ssnSabun");
	String ssnYeaLogYn = (String)session.getAttribute("ssnYeaLogYn");
	String cmd = (String)request.getParameter("cmd");

	if("selectYeaReCalcPeopleList".equals(cmd)) {
		//연말정산 대상자 조회

		Map mp = StringUtil.getRequestMap(request);
		mp.put("ssnEnterCd", ssnEnterCd);
		mp.put("ssnSabun", ssnSabun);
		mp.put("cmd", cmd);
		
		String mSearchReSeq = (String)request.getParameter("mSearchReSeq");
		
		if (null == mSearchReSeq || "".equals(mSearchReSeq) || "''".equals(mSearchReSeq) || "null".equals(mSearchReSeq)) {
			mp.put("mSearchReSeqSQL", " ");
		} else {
			mp.put("mSearchReSeqSQL", "AND RE_SEQ IN ( " + mSearchReSeq + " )");
		}

		List listData  = new ArrayList();
		String message = "";
		String code = "1";

		try {
			listData = selectYeaReCalcPeopleList(mp, locPath, ssnYeaLogYn);
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
	} else if("saveYeaReCalcPeople".equals(cmd)) {
		//연말정산 대상자 저장

		Map paramMap = StringUtil.getRequestMap(request);
		paramMap.put("ssnEnterCd", ssnEnterCd);
		paramMap.put("ssnSabun", ssnSabun);
		paramMap.put("cmd", cmd);
		List listMap = StringUtil.getParamListData(paramMap);
		
		String message = "";
		String code = "1";

		try {

			int cnt = 0;

			cnt += saveYeaReCalcPeople(listMap, locPath, ssnYeaLogYn);

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
	} else if("chgFinalYeaReCalcPeople".equals(cmd)) {
		//정산 재계산 대상자 (TCPN884) 저장 :: 수정(이력) 자료를 최종 자료로 변경

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

				String sStatus           = "FI"; // FI(최종으로변경)
				
				String work_yy           = (String)data.get("work_yy");
				String sabun             = (String)data.get("sabun");
				
				String adjust_type_inst  = "";
				String adjust_type_orig  = (String)data.get("adjust_type");       // 이거→최종 (1=연말정산최종/3=퇴직정산최종/1R2=연말정산2회차/3R1=연말정산1회차)
				String adjust_type       = (String)data.get("adjust_type");
				String adjust_type_nm    = (String)data.get("adjust_type_nm");    // 정산구분  (1=연말정산/3=퇴직정산)
								
				String re_cre            = "";				
				String pay_people_status = (String)data.get("pay_people_status");
				String final_close_yn    = (String)data.get("final_close_yn");				
				String gubun             = "";				
				String re_seq            = "";
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
	}
%>
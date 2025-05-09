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
<%@ page import="org.json.JSONArray" %>
<%@ page import="com.hr.common.logger.Log" %>
<%@ include file="../common/include/session.jsp"%>
<%@ include file="../auth/saveLog.jsp"%>
<%!
//연말정산 대상자 조회
public List selectYeaCalcCrePopupList(Map paramMap, String locPath, String ssnYeaLogYn) throws Exception {

	//파라메터 복사.
	Map pm =  StringUtil.getParamMapData(paramMap);
	Map queryMap = XmlQueryParser.getQueryMap(locPath);
	List listData = null;

	String searchBusinessCd	 = String.valueOf(pm.get("searchBizPlaceCd"));
	String searchNameSabun	 = String.valueOf(pm.get("findName"));

	StringBuffer query    = new StringBuffer();
	StringBuffer query2   = new StringBuffer();

	query.setLength(0);
	query2.setLength(0);

	if(searchBusinessCd.trim().length() > 0){
		query.append(" AND BUSINESS_PLACE_CD = #searchBizPlaceCd#");
		query2.append(" AND A.BUSINESS_PLACE_CD = #searchBizPlaceCd#");
	}

	if(searchNameSabun.trim().length() > 0 ){
		query2.append(" AND ( LOWER(A.SABUN) LIKE LOWER('%" +searchNameSabun+"%') OR LOWER(B.NAME) LIKE LOWER('%" +searchNameSabun+"%') )");
	}

	pm.put("query", query.toString());
	pm.put("query2", query2.toString());

	try{
		//쿼리 실행및 결과 받기.
		listData  = (queryMap == null) ? null : DBConn.executeQueryList(queryMap,"selectYeaCalcCrePopupList",pm);
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
public int saveYeaCalcCrePopup(List paramList, String locPath, String ssnYeaLogYn) throws Exception {

	Connection conn = DBConn.getConnection();
	int rstCnt = 0;
	Map queryMap = XmlQueryParser.getQueryMap(locPath);

	if(paramList != null && paramList.size() > 0 && conn != null) {

		conn.setAutoCommit(false);

		try{
			for(int i = 0; i < paramList.size(); i++ ) {
				String query = "";
				Map mp = (Map)paramList.get(i);
				String sStatus = (String)mp.get("sStatus");
                Map mp2 = (Map)paramList.get(0);
                String menuNm = (String)mp2.get("menuNm");
                mp.put("menuNm", menuNm);
				if("D".equals(sStatus)) {
					//삭제
					DBConn.executeUpdate(conn, queryMap, "deleteYeaCalcCrePopupTCPN811", mp);
					DBConn.executeUpdate(conn, queryMap, "deleteYeaCalcCrePopupTCPN823", mp);
					DBConn.executeUpdate(conn, queryMap, "deleteYeaCalcCrePopupTCPN843", mp);
					DBConn.executeUpdate(conn, queryMap, "deleteYeaCalcCrePopupTCPN813", mp);
					DBConn.executeUpdate(conn, queryMap, "deleteYeaCalcCrePopupTCPN815", mp);
					rstCnt++;

				} else if("U".equals(sStatus)) {
					//수정
					rstCnt += DBConn.executeUpdate(conn, queryMap, "updateYeaCalcCrePopup", mp);

					// 2018-08-08  연말정산계산결과 귀속시작일, 귀속종료일 수정
					DBConn.executeUpdate(conn, queryMap, "updateYeaCalcCrePopupAdjYmd", mp);

				}
				saveLog(conn, mp, ssnYeaLogYn);
			}

			DBConn.executeUpdate(conn, queryMap, "deleteFinalCloseTCPN981", (Map)paramList.get(0) );
			DBConn.executeUpdate(conn, queryMap, "insertFinalCloseTCPN981", (Map)paramList.get(0) );

			//커밋
			conn.commit();
		} catch(UserException e) {
			try {
				//롤백
				conn.rollback();
			} catch (Exception e1) {
				Log.Error("[rollback Exception] " + e);
			}
			rstCnt = 0;
			Log.Error("[Exception] " + e);
			throw new Exception(e.getMessage());
		} catch(Exception e) {
			try {
				//롤백
				conn.rollback();
			} catch (Exception e1) {
				Log.Error("[rollback Exception] " + e);
			}
			rstCnt = 0;
			Log.Error("[Exception] " + e);
			throw new Exception("저장에 실패하였습니다.");
		} finally {
			DBConn.closeConnection(conn, null, null);
	        queryMap = null;
		}
	}

	return rstCnt;
}

//기존 등록여부 체크
public Map selectYeaCalcCrePopupChkSabun(Map pm, String locPath) throws Exception {

	//파라메터 복사.
	Map mapData = null;
	Map queryMap = XmlQueryParser.getQueryMap(locPath);

	try{
		//쿼리 실행및 결과 받기.
		mapData  = (queryMap == null) ? null : DBConn.executeQueryMap(queryMap,"selectYeaCalcCrePopupChkSabun",pm);
	} catch (Exception e) {
		Log.Error("[Exception] " + e);
		throw new Exception("조회에 실패하였습니다.");
	} finally {
		queryMap = null;
	}

	return mapData;
}

//TCPN811 데이터 존재여부 확인
public Map selectYeaCalcCrePopupDataCnt(Map pm, String locPath) throws Exception {

	//파라메터 복사.
	Map mapData = null;
	Map queryMap = XmlQueryParser.getQueryMap(locPath);

	try{
		//쿼리 실행및 결과 받기.
		mapData  = (queryMap == null) ? null : DBConn.executeQueryMap(queryMap,"selectYeaCalcCrePopupDataCnt",pm);
	} catch (Exception e) {
		Log.Error("[Exception] " + e);
		throw new Exception("조회에 실패하였습니다.");
	} finally {
		queryMap = null;
	}

	return mapData;
}


%>

<%
	String locPath = xmlPath+"/yeaCalcCre/yeaCalcCrePeoplePopup.xml";

	String ssnEnterCd = (String)session.getAttribute("ssnEnterCd");
	String ssnSabun = (String)session.getAttribute("ssnSabun");
	String ssnYeaLogYn = (String)session.getAttribute("ssnYeaLogYn");
	String cmd = (String)request.getParameter("cmd");

	if("selectYeaCalcCrePopupList".equals(cmd)) {
		//연말정산 대상자 조회

		Map mp = StringUtil.getRequestMap(request);
		mp.put("ssnEnterCd", ssnEnterCd);
		mp.put("ssnSabun", ssnSabun);
		mp.put("cmd", cmd);

		List listData  = new ArrayList();
		String message = "";
		String code = "1";

		try {
			listData = selectYeaCalcCrePopupList(mp, locPath, ssnYeaLogYn);
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
	} else if("saveYeaCalcCrePopup".equals(cmd)) {
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

			//insert 인경우 프로시저로 데이터 저장.
			for(int i = 0; i < listMap.size(); i++) {
				Map data = (Map)listMap.get(i);

				String sStatus = (String)data.get("sStatus");

				if("I".equals(sStatus)) {
					String payActionCd = (String)data.get("pay_action_cd");
					String workYy = (String)data.get("work_yy");
					String adjustType = (String)data.get("adjust_type");
					String sabun = (String)data.get("sabun");
					String taxType = "2";

					String[] type =  new String[]{"OUT","OUT","OUT","STR","STR","STR","STR","STR","STR","STR","STR","STR"};
					String[] param = new String[]{"","","",ssnEnterCd,payActionCd,workYy,adjustType,"","0",sabun,taxType,ssnSabun};


					String[] rstStr = DBConn.executeProcedure("P_CPN_YEAREND_EMP",type,param);

					//if(rstStr[1] == null || rstStr[1].length() == 0) {
					//	data.put("sStatus", "U");
					//}

					cnt++;
				}
			}

			cnt += saveYeaCalcCrePopup(listMap, locPath, ssnYeaLogYn);

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
	} else if("prcCpnYearEndEmp".equals(cmd)) {
		//연말정산 대상자 작업

		Map paramMap = StringUtil.getRequestMap(request);
		Map mp =  StringUtil.getParamMapData(paramMap);

		String payActionCd = (String)mp.get("searchPayActionCd");
		String workYy = (String)mp.get("searchWorkYy");
		String adjustType = (String)mp.get("searchAdjustType");
		String businessPlaceCd = (String)mp.get("searchBizPlaceCd");
		String sabun = (String)mp.get("searchSabun");
		String taxType = "2";

		String[] type =  new String[]{"OUT","OUT","OUT","STR","STR","STR","STR","STR","STR","STR","STR","STR"};
		String[] param = new String[]{"","","",ssnEnterCd,payActionCd,workYy,adjustType,businessPlaceCd,"0","",taxType,ssnSabun};

		String message = "";
		String code = "1";
		int cnt = 0;

		try {

			String[] rstStr = DBConn.executeProcedure("P_CPN_YEAREND_EMP",type,param);

			if(rstStr[1] == null || rstStr[1].length() == 0) {
				message = "작업 완료되었습니다.";
			} else {
				code = "-1";
				message = "처리도중 문제발생 : "+rstStr[1];
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
	} else if("checkYeaCalcCrePopup".equals(cmd)) {
		/*저장시 validation check 추가 - 2019.11.26
		 *대상자입력후 save할때 for문 돌면서 확인. alert(PAY_ACTION_NM에 사번 sabun이 있습니다. 확인해주십시오.) 한명망 alert하고 return
		 *대상자입력후 save할때 TCPN811 확인. 있으면 popup. 팝업에서 대상자 리스트 업 및 삭제기능만. 삭제시 TCPN811, TCPN823 같이 삭제
		*/
		Map paramMap = StringUtil.getRequestMap(request);
		paramMap.put("ssnEnterCd", ssnEnterCd);
		paramMap.put("ssnSabun", ssnSabun);

		String paramValue    	= String.valueOf(request.getParameter("pValue"));

		String message = "";
		String code = "1";

		try {

			JSONArray jsonArr = new JSONArray(paramValue);
			JSONObject jsonObj = null;

			for(int i=0; i<jsonArr.length(); i++) {
				jsonObj = jsonArr.getJSONObject(i);

				Map pm = new HashMap();
				pm.put("ssnEnterCd", ssnEnterCd);
				pm.put("work_yy", jsonObj.getString("workYy"));
				pm.put("adjust_type", jsonObj.getString("adjustType"));
				pm.put("sabun", jsonObj.getString("sabun"));

				//기존 등록여부 체크
				Map retMap = selectYeaCalcCrePopupChkSabun(pm, locPath);

				if(retMap != null && retMap.get("pay_action_nm") != null ) {
					//등록되어 있는 데이터가 있으면 한명만 alert하고 return
					code = "-2";
					message = retMap.get("pay_action_nm").toString()+"에 사번("+jsonObj.getString("sabun")+")이 있습니다. 확인해 주십시요.";
					break;
				} else {
					//TCPN811 에만 등록된 데이터가 있는지 확인
					Map retCnt = this.selectYeaCalcCrePopupDataCnt(pm, locPath);
					if(retCnt != null && retCnt.get("cnt") != null && Integer.valueOf(retCnt.get("cnt").toString()) > 0) {
						//데이터가 있으면 삭제기능만 있는 팝업 호출
						code = "-3";
						message = "";
						break;
					}
				}
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
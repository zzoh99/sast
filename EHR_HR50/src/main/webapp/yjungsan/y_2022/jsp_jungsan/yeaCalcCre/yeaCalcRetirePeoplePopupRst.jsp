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
public List selectYeaCalcRetirePopupList(Map paramMap, String locPath, String ssnYeaLogYn) throws Exception {

	//파라메터 복사.
	Map pm =  StringUtil.getParamMapData(paramMap);
	Map queryMap = XmlQueryParser.getQueryMap(locPath);
	List listData = null;

	String searchBusinessCd	 = String.valueOf(pm.get("searchBizPlaceCd"));
	String searchNameSabun	 = String.valueOf(pm.get("findName"));

	StringBuffer query    = new StringBuffer();
	query.setLength(0);

	if(searchBusinessCd.trim().length() > 0){
		query.append(" AND A.BUSINESS_PLACE_CD = #searchBizPlaceCd#");
	}

	if(searchNameSabun.trim().length() > 0 ){
		query.append(" AND ( LOWER(A.SABUN) LIKE LOWER('%" +searchNameSabun+"%') OR LOWER(B.NAME) LIKE LOWER('%" +searchNameSabun+"%') )");
	}

	pm.put("query", query.toString());

	try{
		//쿼리 실행및 결과 받기.
		listData  = (queryMap == null) ? null : DBConn.executeQueryList(queryMap,"selectYeaCalcRetirePopupList",pm);
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
public int saveYeaCalcRetirePopup(List paramList, String locPath, String ssnYeaLogYn) throws Exception {

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
				if("U".equals(sStatus)) {
					//수정
					rstCnt += DBConn.executeUpdate(conn, queryMap, "updateYeaCalcRetirePopup", mp);
					DBConn.executeUpdate(conn, queryMap, "updateYeaCalcRetirePopupAdjYmd", mp);

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
public Map selectYeaCalcRetirePopupChkSabun(Map pm, String locPath) throws Exception {

	//파라메터 복사.
	Map mapData = null;
	Map queryMap = XmlQueryParser.getQueryMap(locPath);

	try{
		//쿼리 실행및 결과 받기.
		mapData  = (queryMap==null) ? null : DBConn.executeQueryMap(queryMap,"selectYeaCalcRetirePopupChkSabun",pm);
	} catch (Exception e) {
		Log.Error("[Exception] " + e);
		throw new Exception("조회에 실패하였습니다.");
	} finally {
		queryMap = null;
	}

	return mapData;
}

//TCPN811 데이터 존재여부 확인
public Map selectYeaCalcRetirePopupDataCnt(Map pm, String locPath) throws Exception {

	//파라메터 복사.
	Map mapData = null;
	Map queryMap = XmlQueryParser.getQueryMap(locPath);

	try{
		//쿼리 실행및 결과 받기.
		mapData  = (queryMap==null) ? null : DBConn.executeQueryMap(queryMap,"selectYeaCalcRetirePopupDataCnt",pm);
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
	String locPath = xmlPath+"/yeaCalcCre/yeaCalcRetirePeoplePopup.xml";

	String ssnEnterCd = (String)session.getAttribute("ssnEnterCd");
	String ssnSabun = (String)session.getAttribute("ssnSabun");
	String ssnYeaLogYn = (String)session.getAttribute("ssnYeaLogYn");
	String cmd = (String)request.getParameter("cmd");

	if("selectYeaCalcRetirePopupList".equals(cmd)) {
		//연말정산 대상자 조회

		Map mp = StringUtil.getRequestMap(request);
		mp.put("ssnEnterCd", ssnEnterCd);
		mp.put("ssnSabun", ssnSabun);
		mp.put("cmd", cmd);

		List listData  = new ArrayList();
		String message = "";
		String code = "1";

		try {
			listData = selectYeaCalcRetirePopupList(mp, locPath, ssnYeaLogYn);
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
	} else if("saveYeaCalcRetirePopup".equals(cmd)) {
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
			cnt += saveYeaCalcRetirePopup(listMap, locPath, ssnYeaLogYn);

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
	} else if("checkYeaCalcRetirePopup".equals(cmd)) {
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
				Map retMap = selectYeaCalcRetirePopupChkSabun(pm, locPath);

				if(retMap != null && retMap.get("pay_action_nm") != null ) {
					code = "-2";
					message = retMap.get("pay_action_nm").toString()+"에 사번("+jsonObj.getString("sabun")+")이 있습니다. 확인해 주십시요.";
					break;
				} else {
					Map retCnt = this.selectYeaCalcRetirePopupDataCnt(pm, locPath);
					if(retCnt != null && retCnt.get("cnt") != null && Integer.valueOf(retCnt.get("cnt").toString()) > 0) {
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
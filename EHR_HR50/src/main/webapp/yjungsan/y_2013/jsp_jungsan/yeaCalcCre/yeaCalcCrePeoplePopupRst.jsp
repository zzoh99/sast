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
//연말정산 대상자 조회
public List selectYeaCalcCrePopupList(Map paramMap, String locPath) throws Exception {

	//파라메터 복사.
	Map pm =  StringUtil.getParamMapData(paramMap);
	Map queryMap = XmlQueryParser.getQueryMap(locPath);
	List listData = null;
	
	try{
		//쿼리 실행및 결과 받기.
		listData  = (queryMap == null) ? null : DBConn.executeQueryList(queryMap,"selectYeaCalcCrePopupList",pm);
	} catch (Exception e) {
		Log.Error("[Exception] " + e);
		throw new Exception("조회에 실패하였습니다.");
	} finally {
		queryMap = null;
	}
	
	return listData;
}

//연말정산 대상자 저장.
public int saveYeaCalcCrePopup(List paramList, String locPath) throws Exception {
	
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
				
				if("D".equals(sStatus)) {
					//삭제
					DBConn.executeUpdate(conn, queryMap, "deleteYeaCalcCrePopupTCPN811", mp);
					DBConn.executeUpdate(conn, queryMap, "deleteYeaCalcCrePopupTCPN823", mp);
					DBConn.executeUpdate(conn, queryMap, "deleteYeaCalcCrePopupTCPN843", mp);
					rstCnt++;
					
				} else if("U".equals(sStatus)) {
					//수정
					rstCnt += DBConn.executeUpdate(conn, queryMap, "updateYeaCalcCrePopup", mp);
				}
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

%>

<%
	String locPath = xmlPath+"/yeaCalcCre/yeaCalcCrePeoplePopup.xml";

	String ssnEnterCd = (String)session.getAttribute("ssnEnterCd");
	String ssnSabun = (String)session.getAttribute("ssnSabun");
	String cmd = (String)request.getParameter("cmd");

	if("selectYeaCalcCrePopupList".equals(cmd)) {
		//연말정산 대상자 조회
		
		Map mp = StringUtil.getRequestMap(request);
		mp.put("ssnEnterCd", ssnEnterCd);
		mp.put("ssnSabun", ssnSabun);
		
		List listData  = new ArrayList();
		String message = "";
		String code = "1";
	
		try {
			listData = selectYeaCalcCrePopupList(mp, locPath);
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

					String[] type =  new String[]{"OUT","OUT","OUT","STR","STR","STR","STR","STR","STR","STR","STR"};
					String[] param = new String[]{"","","",ssnEnterCd,payActionCd,workYy,adjustType,"","0",sabun,ssnSabun};
					
					
					String[] rstStr = DBConn.executeProcedure("PKG_CPN_YEA_"+yeaYear+".P_CPN_YEAREND_EMP",type,param);
					
					//if(rstStr[1] == null || rstStr[1].length() == 0) {
					//	data.put("sStatus", "U");
					//}
					
					cnt++;
				}
			}
			
			cnt += saveYeaCalcCrePopup(listMap, locPath);
			
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
		String sabun = (String)mp.get("searchSabun");

		String[] type =  new String[]{"OUT","OUT","OUT","STR","STR","STR","STR","STR","STR","STR","STR"};
		String[] param = new String[]{"","","",ssnEnterCd,payActionCd,workYy,adjustType,"","0","",ssnSabun};
		
		String message = "";
		String code = "1";
		int cnt = 0;
		
		try {
			
			String[] rstStr = DBConn.executeProcedure("PKG_CPN_YEA_"+yeaYear+".P_CPN_YEAREND_EMP",type,param);
			
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
	}
%>
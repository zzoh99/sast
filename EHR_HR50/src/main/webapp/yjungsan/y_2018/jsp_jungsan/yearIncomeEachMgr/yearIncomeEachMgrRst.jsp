<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="yjungsan.util.*"%>
<%@ page import="yjungsan.exception.*"%>
<%@ page import="java.sql.Connection"%>
<%@ page import="java.util.List"%>
<%@ page import="java.util.ArrayList"%>
<%@ page import="java.util.Map"%>
<%@ page import="java.util.HashMap"%>
 
<%@ page import="org.json.JSONObject" %>
<%@ page import="com.hr.common.logger.Log" %>
<%@ include file="../common/include/session.jsp"%>
<%!
//연간소득_개별 검색
public List selectYearIncomeEachMgr(Map paramMap, String locPath) throws Exception {

	//파라메터 복사.
	Map pm =  StringUtil.getParamMapData(paramMap);
	Map queryMap = XmlQueryParser.getQueryMap(locPath);
	List list = null;
	
	try{
		//쿼리 실행및 결과 받기.
		list  = (queryMap == null) ? null : DBConn.executeQueryList(queryMap,"selectYearIncomeEachMgr",pm);
	} catch (Exception e) {
		Log.Error("[Exception] " + e);
		throw new Exception("조회에 실패하였습니다.");
	}
	
	return list;
}

//연간소득_개별 기타소득 검색
public List selectYearIncomeEachMgrEtc(Map paramMap, String locPath) throws Exception {

	//파라메터 복사.
	Map pm =  StringUtil.getParamMapData(paramMap);
	Map queryMap = XmlQueryParser.getQueryMap(locPath);
	List list = null;
	
	try{
		//쿼리 실행및 결과 받기.
		list  = (queryMap == null) ? null : DBConn.executeQueryList(queryMap,"selectYearIncomeEachMgrEtc",pm);
	} catch (Exception e) {
		Log.Error("[Exception] " + e);
		throw new Exception("조회에 실패하였습니다.");
	}
	
	return list;
}

//연간소득_개별 저장.
public int saveYearIncomeEachMgr(Map paramMap, String locPath) throws Exception {
	
	//파라메터 맵안에는 배열형태로 저장되어 있으니 다시 리스트형태로 뽑아서 루프를 돈다.
	List list = StringUtil.getParamListData(paramMap);
	Map queryMap = XmlQueryParser.getQueryMap(locPath);

	//사용자가 직접 트렌젝션 관리하기 위해 커넥션 가져오기.
	Connection conn = DBConn.getConnection();
	int rstCnt = 0;
	
	if(list != null && list.size() > 0 && conn != null) {
	
		//사용자가 직접 트랜젝션 관리
		conn.setAutoCommit(false);
		
		try{
			for(int i = 0; i < list.size(); i++ ) {
				String query = "";
				Map mp = (Map)list.get(i);
				String sStatus = (String)mp.get("sStatus");
				
				if("D".equals(sStatus)) {
					//삭제
					rstCnt += DBConn.executeUpdate(conn, queryMap, "deleteYearIncomeEachMgr", mp);
				} else if("U".equals(sStatus)) {
					//수정
					rstCnt += DBConn.executeUpdate(conn, queryMap, "updateYearIncomeEachMgr", mp);
				} else if("I".equals(sStatus)) {
					//입력 중복체크
					Map dupMap = DBConn.executeQueryMap(conn, queryMap,"selectYearIncomeEachMgrCnt",mp);
					
					if(dupMap != null && Integer.parseInt((String)dupMap.get("cnt")) > 0 ) {
						throw new UserException("중복되어 저장할 수 없습니다.");
					}
					//입력
					rstCnt += DBConn.executeUpdate(conn, queryMap, "insertYearIncomeEachMgr", mp);
				}
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
		}
	}
	
	return rstCnt;
}

//연간소득_개별 기타소득 저장.
public int saveYearIncomeEachMgrEtc(Map paramMap, String locPath) throws Exception {
	
	//파라메터 맵안에는 배열형태로 저장되어 있으니 다시 리스트형태로 뽑아서 루프를 돈다.
	List list = StringUtil.getParamListData(paramMap);
	Map queryMap = XmlQueryParser.getQueryMap(locPath);

	//사용자가 직접 트렌젝션 관리하기 위해 커넥션 가져오기.
	Connection conn = DBConn.getConnection();
	int rstCnt = 0;
	
	if(list != null && list.size() > 0 && conn != null) {
	
		//사용자가 직접 트랜젝션 관리
		conn.setAutoCommit(false);
		
		try{
			for(int i = 0; i < list.size(); i++ ) {
				String query = "";
				Map mp = (Map)list.get(i);
				String sStatus = (String)mp.get("sStatus");
				
				if("D".equals(sStatus)) {
					//삭제
					rstCnt += DBConn.executeUpdate(conn, queryMap, "deleteYearIncomeEachMgrEtc", mp);
				} else if("U".equals(sStatus)) {
					//수정
					rstCnt += DBConn.executeUpdate(conn, queryMap, "updateYearIncomeEachMgrEtc", mp);
				} else if("I".equals(sStatus)) {
					//입력 중복체크
					Map dupMap = DBConn.executeQueryMap(conn, queryMap,"selectYearIncomeEachMgrEtcCnt",mp);
					
					if(dupMap != null && Integer.parseInt((String)dupMap.get("cnt")) > 0 ) {
						throw new UserException("중복되어 저장할 수 없습니다.");
					}
					//입력
					rstCnt += DBConn.executeUpdate(conn, queryMap, "insertYearIncomeEachMgrEtc", mp);
				}
				/*
				2018 개선 - 중소기업취업자 감면 입력시 값을 종합하여 자료등록쪽에 자동반영한다.
				          - 기존에 연간소득 및 종전근무지 값을 입력하여도 자료등록에 별도로 한번 더 입력하여야하는 번거로움을 없애기 위함
				          - 각 항목별로 SUM하여 자료등록쪽에 자동합산 반영한다. 자료등록에서는 수정 할 수 없다.
				20181114 by JSG
				*/
				Map dataMap = DBConn.executeQueryMap(conn, queryMap,"selectYearIncomeEachMgrEtcSum",mp);
				if(dataMap != null) {
					
					String B010_30 = (String)dataMap.get("b010_30")  ;
					if(!"".equals(B010_30)) {
						mp.put("input_mon", B010_30) ;
						mp.put("adj_element_cd", "B010_30") ;
						DBConn.executeUpdate(conn, queryMap, "updateYearIncomeEachMgrEtcSum", mp);
					}

					String B010_31 = (String)dataMap.get("b010_31")  ;
					if(!"".equals(B010_31)) {
						mp.put("input_mon", B010_31) ;
						mp.put("adj_element_cd", "B010_31") ;
						DBConn.executeUpdate(conn, queryMap, "updateYearIncomeEachMgrEtcSum", mp);
					}

					String B010_32 = (String)dataMap.get("b010_32")  ;
					if(!"".equals(B010_32)) {
						mp.put("input_mon", B010_32) ;
						mp.put("adj_element_cd", "B010_32") ;
						DBConn.executeUpdate(conn, queryMap, "updateYearIncomeEachMgrEtcSum", mp);
					}

					String B010_33 = (String)dataMap.get("b010_33")  ;
					if(!"".equals(B010_33)) {
						mp.put("input_mon", B010_33) ;
						mp.put("adj_element_cd", "B010_33") ;
						DBConn.executeUpdate(conn, queryMap, "updateYearIncomeEachMgrEtcSum", mp);
					}
				}
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
		}
	}
	
	return rstCnt;
}

%>

<%
	String locPath = xmlPath+"/yearIncomeEachMgr/yearIncomeEachMgr.xml";

	String ssnEnterCd = (String)session.getAttribute("ssnEnterCd");
	String ssnSabun = (String)session.getAttribute("ssnSabun");
	String cmd = (String)request.getParameter("cmd");

	if("selectYearIncomeEachMgr".equals(cmd)) {
		//연간소득_개별
		
		Map mp = StringUtil.getRequestMap(request);
		mp.put("ssnEnterCd", ssnEnterCd);
		mp.put("ssnSabun", ssnSabun);
		
		List listData  = new ArrayList();
		String message = "";
		String code = "1";

		try {
			listData = selectYearIncomeEachMgr(mp, locPath);
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
		
	} else if("selectYearIncomeEachMgrEtc".equals(cmd)) {
		//연간소득_개별 기타소득 조회
		
		Map mp = StringUtil.getRequestMap(request);
		mp.put("ssnEnterCd", ssnEnterCd);
		mp.put("ssnSabun", ssnSabun);
		
		List listData  = new ArrayList();
		String message = "";
		String code = "1";

		try {
			listData = selectYearIncomeEachMgrEtc(mp, locPath);
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
		
	} else if("saveYearIncomeEachMgr".equals(cmd)) {
		//연간소득_개별 저장
		
		Map mp = StringUtil.getRequestMap(request);
		mp.put("ssnEnterCd", ssnEnterCd);
		mp.put("ssnSabun", ssnSabun);
		
		String message = "";
		String code = "1";
		
		try {
			int cnt = saveYearIncomeEachMgr(mp, locPath);
			
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
		
	} else if("saveYearIncomeEachMgrEtc".equals(cmd)) {
		//연간소득_개별 기타소득 저장
		
		Map mp = StringUtil.getRequestMap(request);
		mp.put("ssnEnterCd", ssnEnterCd);
		mp.put("ssnSabun", ssnSabun);
		
		String message = "";
		String code = "1";
		
		try {
			int cnt = saveYearIncomeEachMgrEtc(mp, locPath);
			
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
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

//주택자금 자료 조회
public List selectYeaDataWooriList(Map paramMap, String ssnYeaLogYn, Map queryMap) throws Exception {

	//파라메터 복사.
	Map pm =  StringUtil.getParamMapData(paramMap);
	List listData = null;

	try{
		//쿼리 실행및 결과 받기.
		listData  = (queryMap == null) ? null : DBConn.executeQueryList(queryMap,"selectYeaDataWooriList",pm);
		saveLog(null, pm, ssnYeaLogYn);
	} catch (Exception e) {
		Log.Error("[Exception] " + e);
		throw new Exception("조회에 실패하였습니다.");
	}

	return listData;
}



//pdf 파일 상세 저장.
public int saveYeaDataPdf(Map paramMap, String orgAuthPg, Map queryMap) throws Exception {

	//사용자가 직접 트렌젝션 관리하기 위해 커넥션 가져오기.
	Connection conn = DBConn.getConnection();
	int rstCnt = 0;

	//권한에 따른 반영제외자 체크 ( 10(본인반영제외) / 20(담당자반영제외))
	String exceptCheck = "";
	if( "A".equals(orgAuthPg) ) {
		exceptCheck = "20";
	} else {
		exceptCheck = "10";
	}

	if (conn != null) {
		//사용자가 직접 트랜젝션 관리
		conn.setAutoCommit(false);
	
		try{
			Map mp = paramMap ;
			mp.put("exceptCheck", exceptCheck);
			//System.out.println( paramMap ) ;
			rstCnt += DBConn.executeUpdate(conn, queryMap, "updateYeaDataPdf", paramMap);
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

public int saveYeaDataWoori(Map paramMap, Map queryMap) throws Exception {

	//파라메터 맵안에는 배열형태로 저장되어 있으니 다시 리스트형태로 뽑아서 루프를 돈다.
	List list = StringUtil.getParamListData(paramMap);

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
					rstCnt += DBConn.executeUpdate(conn, queryMap, "deleteWooriMgr", mp);
				} else if("U".equals(sStatus)) {
					//수정
					rstCnt += DBConn.executeUpdate(conn, queryMap, "updateWooriMgr", mp);
				} else if("I".equals(sStatus)) {
					//입력
					rstCnt += DBConn.executeUpdate(conn, queryMap, "insertWooriMgr", mp);
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
	Map queryMap = XmlQueryParser.getQueryMap(xmlPath+"/wooriMgr/wooriMgr.xml");

	String ssnEnterCd = (String)session.getAttribute("ssnEnterCd");
	String ssnSabun = (String)session.getAttribute("ssnSabun");
	String ssnYeaLogYn = (String)session.getAttribute("ssnYeaLogYn");
	String cmd = (String)request.getParameter("cmd");

	if("selectYeaDataWooriList".equals(cmd)) {
		//자료 조회

		Map mp = StringUtil.getRequestMap(request);
		mp.put("ssnEnterCd", ssnEnterCd);
		mp.put("ssnSabun", ssnSabun);
		mp.put("cmd", cmd);

		List listData  = new ArrayList();
		String message = "";
		String code = "1";

		try {
			listData = selectYeaDataWooriList(mp, ssnYeaLogYn, queryMap);
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

	} else if("saveYeaDataWoori".equals(cmd)) {
		//종전근무지 저장
		
		Map mp = StringUtil.getRequestMap(request);
		mp.put("ssnEnterCd", ssnEnterCd);
		mp.put("ssnSabun", ssnSabun);
		
		String message = "";
		String code = "1";
		
		try {
			int cnt = saveYeaDataWoori(mp, queryMap);
			
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
		
	} else if("saveYeaDataWoori_back".equals(cmd)) {
		//내역 저장

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

				String sStatus = (String)data.get("sStatus");
				String workYy = (String)data.get("work_yy");
				String adjustType = (String)data.get("adjust_type");
				String sabun = (String)data.get("sabun");
				String name = (String)data.get("name");
				String resNo = (String)data.get("res_no");
				String b9No = (String)data.get("b9_no");
				String b10EnterNm = (String)data.get("b10_enter_nm");
				String b11Ymd = (String)data.get("b11_ymd");
				String b12Ymd = (String)data.get("b12_ymd");
				String b13Ymd = (String)data.get("b13_ymd");
				String b14Ymd = (String)data.get("b14_ymd");
				String b15Mon = (String)data.get("b15_mon");
				String b16Mon = (String)data.get("b16_mon");
				String b17Gubun = (String)data.get("b17_gubun");
				String b18Mon = (String)data.get("b18_mon");
				String b19Mon = (String)data.get("b19_mon");


				String[] type =  new String[]{"OUT","OUT","STR","STR","STR"
						,"STR","STR","STR","STR","STR"
						,"STR","STR","STR","STR","STR"
						,"STR","STR","STR","STR","STR","STR"};
				String[] param = new String[]{"","",sStatus,ssnEnterCd,workYy
						,adjustType,sabun,name,resNo,b9No
						,b10EnterNm,b11Ymd,b12Ymd,b13Ymd,b14Ymd
						,b15Mon,b16Mon,b17Gubun,b18Mon,b19Mon,ssnSabun};

				String[] rstStr = DBConn.executeProcedure("PKG_CPN_YEA_"+workYy+"_SYNC.WOORI_INS",type,param);

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
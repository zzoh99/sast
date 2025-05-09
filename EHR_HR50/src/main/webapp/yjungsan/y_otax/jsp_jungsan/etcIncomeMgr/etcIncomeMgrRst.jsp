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

<%!
//xml 파서를 이용한 방법;
/* public void setQueryMap(String path) {
	queryMap = XmlQueryParser.getQueryMap(path);
} */

//기타소득 조회
public List selectEtcIncomeMgrList(String path, Map paramMap) throws Exception {
	Map queryMap = XmlQueryParser.getQueryMap(path);
	//파라메터 복사.
	Map pm =  StringUtil.getParamMapData(paramMap);
	List listData = null;

	try{
		//쿼리 실행및 결과 받기.
		listData  = (queryMap == null) ? null : DBConn.executeQueryList(queryMap,"selectEtcIncomeMgrList",pm);
	} catch (Exception e) {
		Log.Error("[Exception] " + e);
		throw new Exception("조회에 실패하였습니다.");
	}

	return listData;
}


//기타소득 저장
public int saveEtcIncomeMgr(String path, Map paramMap) throws Exception {
	Map queryMap = XmlQueryParser.getQueryMap(path);
	//파라메터 맵안에는 배열형태로 저장되어 있으니 다시 리스트형태로 뽑아서 루프를 돈다.
	List list = StringUtil.getParamListData(paramMap);
	//사용자가 직접 트렌젝션 관리하기 위해 커넥션 가져오기.
	Connection conn = DBConn.getConnection();
	int rstCnt = 0;
	if(conn != null && list != null && list.size() > 0) {
		//사용자가 직접 트랜젝션 관리
		conn.setAutoCommit(false);
		try{
			for(int i = 0; i < list.size(); i++ ) {
				String query = "";
				Map mp = (Map)list.get(i);
				String sStatus = (String)mp.get("sStatus");
				if("D".equals(sStatus)) {
					//삭제
					rstCnt += DBConn.executeUpdate(conn, queryMap, "deleteEtcIncomeMgr", mp);
				} else if("U".equals(sStatus)) {
					//수정
					rstCnt += DBConn.executeUpdate(conn, queryMap, "mergeEtcIncomeMgr", mp);
				} else if("I".equals(sStatus)) {
					/* 2016-06-27 YHCHOI ADD START */
					/* 임직원 포함하여 일용소득 등록시  주민번호 등 표기 안되는 버그 */
					/* 임직원은 소득자로 등록되지 않는 것이 원인이므로 일용소득 업로드 기능과 동일하게 소득자 merge 호출부분 추가 */
					//사업자 등록에서 사번 가져오기.
					Map ownerMap = DBConn.executeQueryMap(conn, queryMap,"selectEtcIncomeMgrSabun",mp);
					/* 2016-06-27 YHCHOI ADD END */
					
					//입력 중복체크
					mp.put("searchSbNm", mp.get("sabun"));
					Map dupMap = DBConn.executeQueryMap(conn, queryMap,"selectEtcIncomeMgrCnt",mp);

					if(dupMap != null && Integer.parseInt((String)dupMap.get("cnt")) > 0 ) {
						throw new UserException("중복되어 저장할 수 없습니다.");
					}
					
					/* 2016-06-27 YHCHOI ADD START */
					/* 임직원 포함하여 일용소득 등록시  주민번호 등 표기 안되는 버그 */
					/* 임직원은 소득자로 등록되지 않는 것이 원인이므로 일용소득 업로드 기능과 동일하게 소득자 merge 호출부분 추가 */
					if("Y".equals(ownerMap.get("insert_owner_yn"))) {
						DBConn.executeUpdate(conn, queryMap, "mergeEtcIncomeMgrOwner", mp);
					}
					/* 2016-06-27 YHCHOI ADD END */
					
					//입력
					rstCnt += DBConn.executeUpdate(conn, queryMap, "mergeEtcIncomeMgr", mp);
				}
			}
			//커밋
			conn.commit();
		} catch(UserException e) {
			try {
				//롤백
				if (conn != null) conn.rollback();
			} catch (Exception e1) {
				Log.Error("[rollback Exception] " + e);
			}
			rstCnt = 0;
			Log.Error("[Exception] " + e);
			throw new Exception(e.getMessage());
		} catch(Exception e) {
			try {
				//롤백
				if (conn != null) conn.rollback();
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

//기타소득 팝업 저장
public int saveEtcIncomeMgrPopup(String path, Map paramMap) throws Exception {
	Map queryMap = XmlQueryParser.getQueryMap(path);
	//파라메터 맵안에는 배열형태로 저장되어 있으니 다시 리스트형태로 뽑아서 루프를 돈다.
	List list = StringUtil.getParamListData(paramMap);
	//사용자가 직접 트렌젝션 관리하기 위해 커넥션 가져오기.
	Connection conn = DBConn.getConnection();
	int rstCnt = 0;
	if(conn != null && list != null && list.size() > 0) {
		//사용자가 직접 트랜젝션 관리
		conn.setAutoCommit(false);
		try{
			for(int i = 0; i < list.size(); i++ ) {
				String query = "";
				Map mp = (Map)list.get(i);
				String sStatus = (String)mp.get("sStatus");

				if("I".equals(sStatus)) {
					//사업자 등록에서 사번 가져오기.
					Map ownerMap = DBConn.executeQueryMap(conn, queryMap,"selectEtcIncomeMgrSabun",mp);

					mp.put("sabun", ownerMap.get("sabun"));

					Map dupMap = DBConn.executeQueryMap(conn, queryMap,"selectEtcIncomeMgrCnt",mp);

					if(dupMap != null && Integer.parseInt((String)dupMap.get("cnt")) > 0 ) {
						throw new UserException("중복되어 저장할 수 없습니다.");
					}

					Log.Debug("insert_owner_yn : " + String.valueOf(ownerMap.get("insert_owner_yn")));
					//입력
					if("Y".equals(ownerMap.get("insert_owner_yn"))) {
						DBConn.executeUpdate(conn, queryMap, "mergeEtcIncomeMgrOwner", mp);
					}

					rstCnt += DBConn.executeUpdate(conn, queryMap, "mergeEtcIncomeMgr", mp);
				}
			}
			//커밋
			conn.commit();
		} catch(UserException e) {
			try {
				//롤백
				if (conn != null) conn.rollback();
			} catch (Exception e1) {
				Log.Error("[rollback Exception] " + e);
			}
			rstCnt = 0;
			Log.Error("[Exception] " + e);
			throw new Exception(e.getMessage());
		} catch(Exception e) {
			try {
				//롤백
				if (conn != null) conn.rollback();
			} catch (Exception e1) {
				Log.Error("[rollback Exception] " + e);
			}
			rstCnt = 0;
			Log.Error("[Exception] " + e);
			throw new Exception("반영에 실패하였습니다.");
		} finally {
			DBConn.closeConnection(conn, null, null);
		}
	}
	return rstCnt;
}

%>

<%
	//쿼리 맵 셋팅
	//setQueryMap(xmlPath+"/etcIncomeMgr/etcIncomeMgr.xml");
	String ssnEnterCd = (String)session.getAttribute("ssnEnterCd");
	String ssnSabun = (String)session.getAttribute("ssnSabun");
	String cmd = (String)request.getParameter("cmd");
	if("selectEtcIncomeMgrList".equals(cmd)) {
		Map mp = StringUtil.getRequestMap(request);
		mp.put("ssnEnterCd", ssnEnterCd);
		mp.put("ssnSabun", ssnSabun);
		List listData  = new ArrayList();
		String message = "";
		String code = "1";
		try {
			listData = selectEtcIncomeMgrList(xmlPath+"/etcIncomeMgr/etcIncomeMgr.xml", mp);
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
	} else if ("saveEtcIncomeMgr".equals(cmd)) {
		Map mp = StringUtil.getRequestMap(request);
		mp.put("ssnEnterCd", ssnEnterCd);
		mp.put("ssnSabun", ssnSabun);

		String message = "";
		String code = "1";

		try {
			int cnt = saveEtcIncomeMgr(xmlPath+"/etcIncomeMgr/etcIncomeMgr.xml", mp);

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
	} else if ("saveEtcIncomeMgrPopup".equals(cmd)) {
		Map mp = StringUtil.getRequestMap(request);
		mp.put("ssnEnterCd", ssnEnterCd);
		mp.put("ssnSabun", ssnSabun);

		String message = "";
		String code = "1";

		try {
			int cnt = saveEtcIncomeMgrPopup(xmlPath+"/etcIncomeMgr/etcIncomeMgr.xml", mp);

			if(cnt > 0) {
				message = "반영 되었습니다.";
			} else {
				code = "-1";
				message = "반영된 내용이 없습니다.";
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
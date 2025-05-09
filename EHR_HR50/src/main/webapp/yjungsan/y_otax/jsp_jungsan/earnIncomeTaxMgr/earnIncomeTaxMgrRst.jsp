<%@page import="java.io.BufferedWriter"%>
<%@page import="java.io.FileWriter"%>
<%@page import="java.io.File"%>
<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="yjungsan.util.*"%>
<%@ page import="yjungsan.exception.*"%>
<%@ page import="java.sql.Connection"%>
<%@ page import="java.util.List"%>
<%@ page import="java.util.ArrayList"%>
<%@ page import="java.util.Map"%>
<%@ page import="java.util.HashMap"%>
<%@ page import="java.net.URLDecoder"%>
<%@ page import="java.io.*"%>

<%@ page import="com.hr.common.logger.Log" %>
<%@ include file="../common/include/session.jsp"%>

<%!
//xml 파서를 이용한 방법;
/* public void setQueryMap(String path) {
	queryMap = XmlQueryParser.getQueryMap(path);
} */

//원천징수영수증 대상자 조회
public List selectEarnIncomeTaxMgrList(String path, Map paramMap) throws Exception {
	Map queryMap = XmlQueryParser.getQueryMap(path);
	//파라메터 복사.
	Map pm =  StringUtil.getParamMapData(paramMap);
	List listData = null;

	try{
		//쿼리 실행및 결과 받기.
		listData  = (queryMap == null) ? null : DBConn.executeQueryList(queryMap,"selectEarnIncomeTaxMgrList",pm);
	} catch (Exception e) {
		Log.Error("[Exception] " + e);
		throw new Exception("조회에 실패하였습니다.");
	}

	return listData;
}


//원천징수이행상황신고서 저장
public int saveEarnIncomeTaxMgr(String path, Map paramMap) throws Exception {
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
					rstCnt += DBConn.executeUpdate(conn, queryMap, "deleteEarnIncomeTaxMgr", mp);
				} else if("U".equals(sStatus)) {
					//수정
					rstCnt += DBConn.executeUpdate(conn, queryMap, "updateEarnIncomeTaxMgr", mp);
				} else if("I".equals(sStatus)) {
					//입력 중복체크
					Map dupMap = DBConn.executeQueryMap(conn, queryMap,"selectEarnIncomeTaxMgrCnt",mp);

					if(dupMap != null && Integer.parseInt((String)dupMap.get("cnt")) > 0 ) {
						throw new UserException("중복되어 저장할 수 없습니다.");
					}
					//입력
					rstCnt += DBConn.executeUpdate(conn, queryMap, "insertEarnIncomeTaxMgr", mp);
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


public int saveEarnIncomeTaxMgrTab(String path, Map paramMap, String cmd) throws Exception {
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
				if(mp.get("sStatus") != null) {
					String sStatus = (String)mp.get("sStatus");
					if("D".equals(sStatus)) {
						//삭제
						rstCnt += DBConn.executeUpdate(conn, queryMap, "delete"+cmd, mp);
					} else if("U".equals(sStatus)) {
						//수정
						rstCnt += DBConn.executeUpdate(conn, queryMap, "save"+cmd, mp);
					} else if("I".equals(sStatus)) {
						//입력
						rstCnt += DBConn.executeUpdate(conn, queryMap, "save"+cmd, mp);
					}
				} else {
					rstCnt += DBConn.executeUpdate(conn, queryMap, "save"+cmd, mp);
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

public List selectEarnIncomeTaxMgr(String path, Map paramMap, String cmd) throws Exception {
	Map queryMap = XmlQueryParser.getQueryMap(path);
	//파라메터 복사.
	Map pm =  StringUtil.getParamMapData(paramMap);
	List listData = null;

	try{
		//쿼리 실행및 결과 받기.
		listData  = (queryMap == null) ? null : DBConn.executeQueryList(queryMap, cmd, pm);
	} catch (Exception e) {
		Log.Error("[Exception] " + e);
		throw new Exception("조회에 실패하였습니다.");
	}

	return listData;
}

// 조회
public Map getEarnIncomeTaxMgrDtl3Map(String path, Map paramMap) throws Exception {
	Map queryMap = XmlQueryParser.getQueryMap(path);
	//파라메터 복사.
	Map pm =  StringUtil.getParamMapData(paramMap);
	Map map = null;

	try{
		//쿼리 실행및 결과 받기.
		pm  = (queryMap==null) ? null : DBConn.executeQueryMap(queryMap,"getEarnIncomeTaxMgrDtl3Map",pm);
	} catch (Exception e) {
		Log.Error("[Exception] " + e);
		throw new Exception("조회에 실패하였습니다.");
	}

	return pm;
}

public int saveEarnIncomeTaxMgrDtl3(String path, Map paramMap) throws Exception {
	Map queryMap = XmlQueryParser.getQueryMap(path);
	//파라메터 복사.
	Map pm =  StringUtil.getParamMapData(paramMap);
	Map mp = null;

	int rstCnt = 0;

	try{
		//쿼리 실행및 결과 받기.
		rstCnt = DBConn.executeUpdate(queryMap, "saveEarnIncomeTaxMgrDtl3", pm);
	} catch (Exception e) {
		Log.Error("[Exception] " + e);
		throw new Exception("저장에 실패하였습니다.");
	}

	return rstCnt;
}

public int saveEarnIncomeTaxMgrDtl3_2025(String path, Map paramMap) throws Exception {
	Map queryMap = XmlQueryParser.getQueryMap(path);
	//파라메터 복사.
	Map pm =  StringUtil.getParamMapData(paramMap);
	Map mp = null;

	int rstCnt = 0;

	try{
		//쿼리 실행및 결과 받기.
		rstCnt = DBConn.executeUpdate(queryMap, "saveEarnIncomeTaxMgrDtl3_2025", pm);
	} catch (Exception e) {
		Log.Error("[Exception] " + e);
		throw new Exception("저장에 실패하였습니다.");
	}

	return rstCnt;
}

//지방세_계속근무연말정산환급액 및 중도퇴사연말정산환급액 저장
public int saveEarnIncomeTaxMgrDtl2RefundMon(String path, Map paramMap) throws Exception {
	Map queryMap = XmlQueryParser.getQueryMap(path);

	//파라메터 복사.
	Map pm =  StringUtil.getParamMapData(paramMap);
	Map mp = null;

	int rstCnt = 0;

	try{
		//쿼리 실행및 결과 받기.
		rstCnt = DBConn.executeUpdate(queryMap, "saveEarnIncomeTaxMgrDtl2RefundMon", pm);
	} catch (Exception e) {
		Log.Error("[Exception] " + e);
		throw new Exception("저장에 실패하였습니다.");
	}

	return rstCnt;
}

//지방세_계속근무연말정산환급액 및 중도퇴사연말정산환급액 저장
public int saveEarnIncomeTaxMgrDtl1Tab3BankInfo(String path, Map paramMap) throws Exception {
	Map queryMap = XmlQueryParser.getQueryMap(path);
	//파라메터 복사.
	Map pm =  StringUtil.getParamMapData(paramMap);
	Map mp = null;

	int rstCnt = 0;

	try{
		//쿼리 실행및 결과 받기.
		rstCnt = DBConn.executeUpdate(queryMap, "saveEarnIncomeTaxMgrDtl1Tab3BankInfo", pm);
	} catch (Exception e) {
		Log.Error("[Exception] " + e);
		throw new Exception("저장에 실패하였습니다.");
	}

	return rstCnt;
}

//지방세_계속근무연말정산환급액 및 중도퇴사연말정산환급액 저 조회
public Map getEarnIncomeTaxMgrDtl1Tab3BankInfo(String path, Map paramMap) throws Exception {
	Map queryMap = XmlQueryParser.getQueryMap(path);
	//파라메터 복사.
	Map pm =  StringUtil.getParamMapData(paramMap);
	Map map = null;

	try{
		//쿼리 실행및 결과 받기.
		pm  = (queryMap==null) ? null : DBConn.executeQueryMap(queryMap,"getEarnIncomeTaxMgrDtl1Tab3BankInfo",pm);
	} catch (Exception e) {
		Log.Error("[Exception] " + e);
		throw new Exception("조회에 실패하였습니다.");
	}

	return pm;
}

//지방세_계속근무연말정산환급액 및 중도퇴사연말정산환급액 저 조회
public Map getEarnIncomeTaxMgrDtl2RefundMonMap(String path, Map paramMap) throws Exception {
	Map queryMap = XmlQueryParser.getQueryMap(path);
	//파라메터 복사.
	Map pm =  StringUtil.getParamMapData(paramMap);
	Map map = null;

	try{
		//쿼리 실행및 결과 받기.
		pm  = (queryMap==null) ? null : DBConn.executeQueryMap(queryMap,"getEarnIncomeTaxMgrDtl2RefundMonMap",pm);
	} catch (Exception e) {
		Log.Error("[Exception] " + e);
		throw new Exception("조회에 실패하였습니다.");
	}

	return pm;
}

public List getFileContentList(String path, Map paramMap) throws Exception {
	Map queryMap = XmlQueryParser.getQueryMap(path);
	//파라메터 복사.
	Map pm =  StringUtil.getParamMapData(paramMap);
	List listData = null;

	try{
		//쿼리 실행및 결과 받기.
		listData  = (queryMap == null) ? null : DBConn.executeQueryList(queryMap, "getFileContentList", pm);
	} catch (Exception e) {
		Log.Error("[Exception] " + e);
		throw new Exception("조회에 실패하였습니다.");
	}
	/*
	if (listData == null) {
		return new ArrayList<>();
	}*/

	return listData;
}

// 법정동 코드 
public Map getAdmCd(String path, Map paramMap) throws Exception {
	Map queryMap = XmlQueryParser.getQueryMap(path);
	//파라메터 복사.
	Map pm =  StringUtil.getParamMapData(paramMap);
	Map map = null;

	try{
		//쿼리 실행및 결과 받기.
		pm  = (queryMap==null) ? null : DBConn.executeQueryMap(queryMap,"getAdmCd",pm);
	} catch (Exception e) {
		Log.Error("[Exception] " + e);
		throw new Exception("조회에 실패하였습니다.");
	}

	return pm;
}

// 개인법인 코드 
public Map getTprCod(String path, Map paramMap) throws Exception {
	Map queryMap = XmlQueryParser.getQueryMap(path);
	//파라메터 복사.
	Map pm =  StringUtil.getParamMapData(paramMap);
	Map map = null;

	try{
		//쿼리 실행및 결과 받기.
		pm  = (queryMap==null) ? null : DBConn.executeQueryMap(queryMap,"getTprCod",pm);
	} catch (Exception e) {
		Log.Error("[Exception] " + e);
		throw new Exception("조회에 실패하였습니다.");
	}

	return pm;
}

// 법정동코드 수정
public int updateAdmCd(String path, Map paramMap) throws Exception {
	Map queryMap = XmlQueryParser.getQueryMap(path);
	//파라메터 복사.
	Map pm =  StringUtil.getParamMapData(paramMap);
	Map mp = null;

	int rstCnt = 0;

	try{
		//쿼리 실행및 결과 받기.
		rstCnt = DBConn.executeUpdate(queryMap, "updateAdmCd", pm);
	} catch (Exception e) {
		Log.Error("[Exception] " + e);
		throw new Exception("저장에 실패하였습니다.");
	}

	return rstCnt;
}

// 신고구분 수정
public int updateReqDiv(String path, Map paramMap) throws Exception {
	Map queryMap = XmlQueryParser.getQueryMap(path);
	//파라메터 복사.
	Map pm =  StringUtil.getParamMapData(paramMap);
	Map mp = null;

	int rstCnt = 0;

	try{
		//쿼리 실행및 결과 받기.
		rstCnt = DBConn.executeUpdate(queryMap, "updateReqDiv", pm);
	} catch (Exception e) {
		Log.Error("[Exception] " + e);
		throw new Exception("저장에 실패하였습니다.");
	}

	return rstCnt;
}

// 개인법인구분 수정
public int updateTprCod(String path, Map paramMap) throws Exception {
	Map queryMap = XmlQueryParser.getQueryMap(path);
	//파라메터 복사.
	Map pm =  StringUtil.getParamMapData(paramMap);
	Map mp = null;

	int rstCnt = 0;

	try{
		//쿼리 실행및 결과 받기.
		rstCnt = DBConn.executeUpdate(queryMap, "updateTprCod", pm);
	} catch (Exception e) {
		Log.Error("[Exception] " + e);
		throw new Exception("저장에 실패하였습니다.");
	}

	return rstCnt;
}

// 지방소득세 조회
public Map getRtaxMonSum(String path, Map paramMap) throws Exception {
	Map queryMap = XmlQueryParser.getQueryMap(path);
	//파라메터 복사.
	Map pm =  StringUtil.getParamMapData(paramMap);
	Map map = null;

	try{
		//쿼리 실행및 결과 받기.
		pm  = (queryMap==null) ? null : DBConn.executeQueryMap(queryMap,"getRtaxMonSum",pm);
	} catch (Exception e) {
		Log.Error("[Exception] " + e);
		throw new Exception("조회에 실패하였습니다.");
	}

	return pm;
}

/* 
	당초납기일 조회
	급여지급년월(paymentYmd)의 익월 10일
	주말일 경우 차주 월요일
*/
public Map getDueDate(String path, Map paramMap) throws Exception {
	Map queryMap = XmlQueryParser.getQueryMap(path);
	//파라메터 복사.
	Map pm =  StringUtil.getParamMapData(paramMap);
	Map map = null;

	try{
		//쿼리 실행및 결과 받기.
		pm  = (queryMap==null) ? null : DBConn.executeQueryMap(queryMap,"getDueDate",pm);
	} catch (Exception e) {
		Log.Error("[Exception] " + e);
		throw new Exception("조회에 실패하였습니다.");
	}

	return pm;
}

//원천징수명세서 및 납부세액 상세 대상자 팝업
public List getEarnIncomeTaxMgrDtl1Tab1EmpPopupList(String path, Map paramMap) throws Exception {
	Map queryMap = XmlQueryParser.getQueryMap(path);
	//파라메터 복사.
	Map pm =  StringUtil.getParamMapData(paramMap);
	List listData = null;

	try{
		//쿼리 실행및 결과 받기.
		listData  = (queryMap == null) ? null : DBConn.executeQueryList(queryMap,"getEarnIncomeTaxMgrDtl1Tab1EmpPopupList",pm);
	} catch (Exception e) {
		Log.Error("[Exception] " + e);
		throw new Exception("조회에 실패하였습니다.");
	}

	return listData;
}


//지방세 상세 대상자 팝업
public List getEarnIncomeTaxMgrDtl2EmpPopupList(String path, Map paramMap) throws Exception {
	Map queryMap = XmlQueryParser.getQueryMap(path);
	//파라메터 복사.
	Map pm =  StringUtil.getParamMapData(paramMap);
	List listData = null;

	try{
		//쿼리 실행및 결과 받기.
		listData  = (queryMap == null) ? null : DBConn.executeQueryList(queryMap,"getEarnIncomeTaxMgrDtl2EmpPopupList",pm);
	} catch (Exception e) {
		Log.Error("[Exception] " + e);
		throw new Exception("조회에 실패하였습니다.");
	}

	return listData;
}

//사업소세 상세 대상자 팝업
public List getEarnIncomeTaxMgrDtl3EmpPopupList(String path, Map paramMap) throws Exception {
	Map queryMap = XmlQueryParser.getQueryMap(path);
	//파라메터 복사.
	Map pm =  StringUtil.getParamMapData(paramMap);
	List listData = null;

	try{
		//쿼리 실행및 결과 받기.
		listData  = (queryMap == null) ? null : DBConn.executeQueryList(queryMap,"getEarnIncomeTaxMgrDtl3EmpPopupList",pm);
	} catch (Exception e) {
		Log.Error("[Exception] " + e);
		throw new Exception("조회에 실패하였습니다.");
	}

	return listData;
}

%>

<%
	//쿼리 맵 셋팅
	//setQueryMap(xmlPath+"/earnIncomeTaxMgr/earnIncomeTaxMgr.xml");
	String ssnEnterCd = (String)session.getAttribute("ssnEnterCd");
	String ssnSabun = (String)session.getAttribute("ssnSabun");
	String cmd = (String)request.getParameter("cmd");

	if("selectEarnIncomeTaxMgrList".equals(cmd)) {
		Map mp = StringUtil.getRequestMap(request);
		mp.put("ssnEnterCd", ssnEnterCd);
		mp.put("ssnSabun", ssnSabun);
		List listData  = new ArrayList();
		String message = "";
		String code = "1";
		try {
			listData = selectEarnIncomeTaxMgrList(xmlPath+"/earnIncomeTaxMgr/earnIncomeTaxMgr.xml", mp);
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
	} else if ("saveEarnIncomeTaxMgr".equals(cmd)) {
		Map mp = StringUtil.getRequestMap(request);
		mp.put("ssnEnterCd", ssnEnterCd);
		mp.put("ssnSabun", ssnSabun);

		String message = "";
		String code = "1";

		try {
			int cnt = saveEarnIncomeTaxMgr(xmlPath+"/earnIncomeTaxMgr/earnIncomeTaxMgr.xml", mp);

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
	} else if("getEarnIncomeTaxMgrDtl1Tab1List".equals(cmd)
			 ||"getEarnIncomeTaxMgrDtl1Tab1DtlList".equals(cmd)
			 ||"getEarnIncomeTaxMgrDtl1Tab2List".equals(cmd)
			 ||"getEarnIncomeTaxMgrDtl1Tab3List".equals(cmd)
			 ||"getEarnIncomeTaxMgrDtl1Tab4List940".equals(cmd)
			 ||"getEarnIncomeTaxMgrDtl1Tab4List941".equals(cmd)
			 ||"getEarnIncomeTaxMgrDtl1Tab4List942".equals(cmd)
			 ||"getEarnIncomeTaxMgrDtl1Tab5List943".equals(cmd)
			 ||"getEarnIncomeTaxMgrDtl1Tab5List944".equals(cmd)
			 ||"getEarnIncomeTaxMgrDtl2List".equals(cmd)
			 ) {
		Map mp = StringUtil.getRequestMap(request);
		mp.put("ssnEnterCd", ssnEnterCd);
		mp.put("ssnSabun", ssnSabun);
		List listData  = new ArrayList();
		String message = "";
		String code = "1";
		try {
			listData = selectEarnIncomeTaxMgr(xmlPath+"/earnIncomeTaxMgr/earnIncomeTaxMgr.xml", mp, cmd);
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

	}  else if ("saveEarnIncomeTaxMgrDtl1Tab1".equals(cmd)
			||"saveEarnIncomeTaxMgrDtl1Tab1Dtl".equals(cmd)
			||"saveEarnIncomeTaxMgrDtl2".equals(cmd)
			||"saveEarnIncomeTaxMgrDtl1Tab3".equals(cmd)
			||"saveEarnIncomeTaxMgrDtl1Tab4List940".equals(cmd)
			||"saveEarnIncomeTaxMgrDtl1Tab4List941".equals(cmd)
			||"saveEarnIncomeTaxMgrDtl1Tab4List942".equals(cmd)
			//||"saveEarnIncomeTaxMgrDtl1Tab5List943".equals(cmd)
			||"saveEarnIncomeTaxMgrDtl1Tab5List944".equals(cmd)
			) {
		Map mp = StringUtil.getRequestMap(request);
		mp.put("ssnEnterCd", ssnEnterCd);
		mp.put("ssnSabun", ssnSabun);

		String message = "";
		String code = "1";

		try {
			int cnt = saveEarnIncomeTaxMgrTab(xmlPath+"/earnIncomeTaxMgr/earnIncomeTaxMgr.xml", mp, cmd.replaceAll("save", ""));
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
		
	}   else if ("saveEarnIncomeTaxMgrDtl1Tab5List943".equals(cmd)
			) {
		Map mp = StringUtil.getRequestMap(request);
		mp.put("ssnEnterCd", ssnEnterCd);
		mp.put("ssnSabun", ssnSabun);

		String message = "";
		String code = "1";

		try {
			int cnt = saveEarnIncomeTaxMgrTab(xmlPath+"/earnIncomeTaxMgr/earnIncomeTaxMgr.xml", mp, cmd.replaceAll("save", ""));
			if(cnt > 0) {
				cnt = saveEarnIncomeTaxMgrTab(xmlPath+"/earnIncomeTaxMgr/earnIncomeTaxMgr.xml", mp, cmd.replaceAll("save", "")+"_2");
				if(cnt > 0) {
					message = "저장되었습니다.";	
				} else {
					code = "-1";
					message = "환급세액 조정 현황이 생성되지 않았습니다.";	
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
	}else if ("saveEarnIncomeTaxMgrDtl1Tab3BankInfo".equals(cmd)) {
		Map mp = StringUtil.getRequestMap(request);
		mp.put("ssnEnterCd", ssnEnterCd);
		mp.put("ssnSabun", ssnSabun);
		String message = "";
		String code = "1";
		try {
			int cnt = saveEarnIncomeTaxMgrDtl1Tab3BankInfo(xmlPath+"/earnIncomeTaxMgr/earnIncomeTaxMgr.xml", mp);
			if(cnt > 0) {
				message = "";
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
	} else if ("saveEarnIncomeTaxMgrDtl2RefundMon".equals(cmd)) {
		Map mp = StringUtil.getRequestMap(request);
		mp.put("ssnEnterCd", ssnEnterCd);
		mp.put("ssnSabun", ssnSabun);
		String message = "";
		String code = "1";

		try {
			int cnt = saveEarnIncomeTaxMgrDtl2RefundMon(xmlPath+"/earnIncomeTaxMgr/earnIncomeTaxMgr.xml", mp);
			if(cnt > 0) {
				message = "";
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
	} else if ("saveEarnIncomeTaxMgrDtl3".equals(cmd)) {
		Map mp = StringUtil.getRequestMap(request);
		mp.put("ssnEnterCd", ssnEnterCd);
		mp.put("ssnSabun", ssnSabun);
		String message = "";
		String code = "1";

		try {
			int cnt = saveEarnIncomeTaxMgrDtl3(xmlPath+"/earnIncomeTaxMgr/earnIncomeTaxMgr.xml", mp);
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

	}  else if ("saveEarnIncomeTaxMgrDtl3_2025".equals(cmd)) {
		Map mp = StringUtil.getRequestMap(request);
		mp.put("ssnEnterCd", ssnEnterCd);
		mp.put("ssnSabun", ssnSabun);
		String message = "";
		String code = "1";

		try {
			int cnt = saveEarnIncomeTaxMgrDtl3_2025(xmlPath+"/earnIncomeTaxMgr/earnIncomeTaxMgr.xml", mp);
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

	} else if("getEarnIncomeTaxMgrDtl1Tab3BankInfo".equals(cmd)) {
		Map mp = StringUtil.getRequestMap(request);
		mp.put("ssnEnterCd", ssnEnterCd);
		mp.put("ssnSabun", ssnSabun);

		Map mapData  = new HashMap();
		String message = "";
		String code = "1";
		try {
			mapData = getEarnIncomeTaxMgrDtl1Tab3BankInfo(xmlPath+"/earnIncomeTaxMgr/earnIncomeTaxMgr.xml", mp);
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

	} else if("getEarnIncomeTaxMgrDtl2RefundMonMap".equals(cmd)) {
		Map mp = StringUtil.getRequestMap(request);
		mp.put("ssnEnterCd", ssnEnterCd);
		mp.put("ssnSabun", ssnSabun);

		Map mapData  = new HashMap();
		String message = "";
		String code = "1";
		try {
			mapData = getEarnIncomeTaxMgrDtl2RefundMonMap(xmlPath+"/earnIncomeTaxMgr/earnIncomeTaxMgr.xml", mp);
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

	} else if("getEarnIncomeTaxMgrDtl3Map".equals(cmd)) {
		Map mp = StringUtil.getRequestMap(request);
		mp.put("ssnEnterCd", ssnEnterCd);
		mp.put("ssnSabun", ssnSabun);

		Map mapData  = new HashMap();
		String message = "";
		String code = "1";
		try {
			mapData = getEarnIncomeTaxMgrDtl3Map(xmlPath+"/earnIncomeTaxMgr/earnIncomeTaxMgr.xml", mp);
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

	} else if( "prcP_CPN_ORIGIN_TAX_INS".equals(cmd) ) {


		//자료생성
		Map paramMap = StringUtil.getRequestMap(request);
		Map mp =  StringUtil.getParamMapData(paramMap);

		String taxDocNo = (String)mp.get("taxDocNo");
		String businessPlaceCd = (String)mp.get("businessPlaceCd");

		if("ALL".equals(businessPlaceCd)) 	businessPlaceCd = "%";

		String[] type =  new String[]{"OUT","OUT","STR","STR","STR","STR"};
		String[] param = new String[]{"","",ssnEnterCd,taxDocNo,businessPlaceCd,ssnSabun};

		String message = "";
		String code = "1";
		int cnt = 0;

		try {
			String[] rstStr = DBConn.executeProcedure(cmd.replaceAll("prcP", "P"),type,param);
			if(rstStr[1] == null || rstStr[1].length() == 0) {
				message = "자료생성이 완료되었습니다.";
			} else {
				code = "-1";
				message = "자료생성 처리도중 : "+rstStr[1];
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

	}  else if( "prcP_CPN_ORIGIN_OFFICE_TAX_INS".equals(cmd) ) {

		//자료생성
		Map paramMap = StringUtil.getRequestMap(request);
		Map mp =  StringUtil.getParamMapData(paramMap);

		String taxDocNo = (String)mp.get("taxDocNo");
		String businessPlaceCd = (String)mp.get("businessPlaceCd");
		String locationCd = (String)mp.get("locationCd");

		if("ALL".equals(businessPlaceCd)) 	businessPlaceCd = "%";

		String[] type =  new String[]{"OUT","OUT","STR","STR","STR","STR","STR"};
		String[] param = new String[]{"","",ssnEnterCd,taxDocNo,businessPlaceCd,locationCd,ssnSabun};

		String message = "";
		String code = "1";
		int cnt = 0;

		try {
			String[] rstStr = DBConn.executeProcedure(cmd.replaceAll("prcP", "P"),type,param);
			if(rstStr[1] == null || rstStr[1].length() == 0) {
				message = "자료생성이 완료되었습니다.";
			} else {
				code = "-1";
				message = "자료생성 처리도중 : "+rstStr[1];
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

	} else if("prcP_CPN_ORIGIN_RTAX_INS".equals(cmd)) {
		//자료생성
		Map paramMap = StringUtil.getRequestMap(request);
		Map mp =  StringUtil.getParamMapData(paramMap);

		String taxDocNo = (String)mp.get("taxDocNo");
		String businessPlaceCd = (String)mp.get("businessPlaceCd");
		String locationCd = (String)mp.get("locationCd");

		if("ALL".equals(businessPlaceCd)) 	businessPlaceCd = "%";

		String[] type =  new String[]{"OUT","OUT","STR","STR","STR","STR","STR"};
		String[] param = new String[]{"","",ssnEnterCd,taxDocNo,businessPlaceCd,locationCd,ssnSabun};

		String message = "";
		String code = "1";
		int cnt = 0;

		try {
			String[] rstStr = DBConn.executeProcedure("P_CPN_ORIGIN_RTAX_INS",type,param);
			if(rstStr[1] == null || rstStr[1].length() == 0) {
				message = "자료생성이 완료되었습니다.";
			} else {
				code = "-1";
				message = "자료생성 처리도중 : "+rstStr[1];
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

	} else if("prcPKG_CPN_OTAX_DISK_2010".equals(cmd)) {
		//자료생성
		Map paramMap = StringUtil.getRequestMap(request);
		paramMap.put("ssnEnterCd", ssnEnterCd);
		Map mp =  StringUtil.getParamMapData(paramMap);

		//파일생성위한 변수 선언
		StringBuffer sbuf = new StringBuffer();
		List<?> list = new ArrayList<Object>();
		File mFile = null;
		//FileWriter fw;

		String taxDocNo = (String)mp.get("taxDocNo");
		String businessPlaceCd = (String)mp.get("businessPlaceCd");
		String userId = (String)mp.get("userId");

		if("ALL".equals(businessPlaceCd)) 	businessPlaceCd = "%";

		String[] type =  new String[]{"OUT","OUT","STR","STR","STR","STR","STR"};
		String[] param = new String[]{"","",ssnEnterCd,taxDocNo,businessPlaceCd,userId,ssnSabun};

		String message = "";
		String code = "1";
		int cnt = 0;

		String saveFileName = ""; //저장 파일명
		String saveFilePath = StringUtil.getPropertiesValue("WAS.PATH")+StringUtil.getPropertiesValue("HRFILE.PATH")+"/NTS_FILES/"+ssnEnterCd; //저장위치

		try {
			
			// 디렉토리 만들기
			File dir = new File(saveFilePath);
			if(!dir.exists()) {
				dir.mkdirs();
			}

			String[] rstStr = DBConn.executeProcedure("PKG_CPN_OTAX_DISK_2010.DISK_ALL",type,param);
			if(rstStr[1] == null || rstStr[1].length() == 0) {
				message = "자료생성이 완료되었습니다.";

				try{
					String fileName = "/"+taxDocNo.replaceAll("-", "");

					fileName = fileName+ ".201" + "." + System.currentTimeMillis();
					// 파일객체생성
					mFile = new File(saveFilePath + fileName);
					// 생성한 파일에 작성할 내용 조회
					//xmlPath+"/earnIncomeTaxMgr/earnIncomeTaxMgr.xml"
					list = getFileContentList(xmlPath+"/earnIncomeTaxMgr/earnIncomeTaxMgr.xml", paramMap);
					if(list != null && list.size() > 0) {
						for(int i = 0; i < list.size(); i++) {
							if( i > 0 ) {
								sbuf.append("\n");
							}
							Map<String,Object> fMp = (Map<String,Object>)list.get(i);
							sbuf.append(fMp.get("content").toString());
						}
					}
					Log.Debug("[ NTS FILE ] 내용 조회결과 sbuf [" + sbuf.toString() + "]");
					if (sbuf.toString().length() <= 0) {
						Log.Debug("[ NTS FILE ] 작성할 내용이없습니다.");
					}

					// 파일작성
					//fw = new FileWriter(mFile);

					FileOutputStream fileOut = new FileOutputStream(mFile);
					//BufferedWriter bufferWriter = new BufferedWriter(fw);
					fileOut.write(sbuf.toString().getBytes("euc-kr"));
					fileOut.flush();
					fileOut.close();
				} catch(Exception e) {
					message = "파일생성 오류입니다.";
					Log.Debug("[ NTS FILE ] Exception [" + e + "]");
					if (mFile != null) {
						try{
							mFile.delete();
							message = "파일생성 오류입니다.";
						} catch(Exception ex) {
							Log.Debug("[ NTS FILE ] Exception [" + ex + "]");
						}
					}
				}
			} else {
				code = "-1";
				message = "자료생성 처리도중 : "+rstStr[1];
			}
		} catch(Exception e) {
			code = "-1";
			message = e.getMessage();
		}

		Map mapCode = new HashMap();
		mapCode.put("Code", code);
		mapCode.put("Message", message);
		mapCode.put("serverFileName", (mFile == null)? "" : mFile.getName());

		Map rstMap = new HashMap();
		rstMap.put("Result", mapCode);

		out.print((new org.json.JSONObject(rstMap)).toString());

	} else if( "prcP_CPN_ORIGIN_TAX_GI_PAY_INS".equals(cmd) ) {

		//자료생성
		Map paramMap = StringUtil.getRequestMap(request);
		Map mp =  StringUtil.getParamMapData(paramMap);

		String taxDocNo = (String)mp.get("taxDocNo");
		String businessPlaceCd = (String)mp.get("businessPlaceCd");

		if("ALL".equals(businessPlaceCd)) 	businessPlaceCd = "%";

		String[] type =  new String[]{"OUT","OUT","STR","STR","STR","STR"};
		String[] param = new String[]{"","",ssnEnterCd,taxDocNo,businessPlaceCd,ssnSabun};

		String message = "";
		String code = "1";
		int cnt = 0;

		try {
			String[] rstStr = DBConn.executeProcedure(cmd.replaceAll("prcP", "P"),type,param);
			if(rstStr[1] == null || rstStr[1].length() == 0) {
				message = "자료생성이 완료되었습니다.";
			} else {
				code = "-1";
				message = "자료생성 처리도중 : "+rstStr[1];
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

	} else if("prcPKG_CPN_OTAX_DISK_2010_DISK_ALL_LOC".equals(cmd)) {
		
		//자료생성
		Map paramMap = StringUtil.getRequestMap(request);
		paramMap.put("ssnEnterCd", ssnEnterCd);
		paramMap.put("ssnSabun", ssnSabun);
		Map mp =  StringUtil.getParamMapData(paramMap);
		
		String message = "";
		String code = "1";
		String tprCod = "";
		
		// 개인/법인 저장
		try {
			int updateCnt = updateTprCod(xmlPath+"/earnIncomeTaxMgr/earnIncomeTaxMgr.xml", mp);
			if(updateCnt > 0) {
				message = "저장되었습니다.";
				tprCod = (String)mp.get("tprCod");
			} else {
				code = "-1";
				message = "저장된 내용이 없습니다.";
			}
		} catch(Exception e) {
			code = "-1";
			message = e.getMessage();
		}
		
		//파일생성위한 변수 선언
		StringBuffer sbuf = new StringBuffer();
		List<?> list = new ArrayList<Object>();
		File mFile = null;
		//FileWriter fw;
		
		if(code == "1"){
			
			String taxDocNo = (String)mp.get("taxDocNo");
			String businessPlaceCd = (String)mp.get("businessPlaceCd");
			String userId = null;
	
			if("ALL".equals(businessPlaceCd)) 	businessPlaceCd = "%";
	
			String[] type =  new String[]{"OUT","OUT","STR","STR","STR","STR","STR"};
			String[] param = new String[]{"","",ssnEnterCd,taxDocNo,businessPlaceCd,userId,ssnSabun};
	
			int cnt = 0;
	
			String saveFileName = ""; //저장 파일명
			String saveFilePath = StringUtil.getPropertiesValue("WAS.PATH")+StringUtil.getPropertiesValue("HRFILE.PATH")+"/NTS_FILES/"+ssnEnterCd; //저장위치
	
			try {
				
				// 디렉토리 만들기
				File dir = new File(saveFilePath);
				if(!dir.exists()) {
					dir.mkdirs();
				}
				
				String[] rstStr = DBConn.executeProcedure("PKG_CPN_OTAX_DISK_2010.DISK_ALL_LOC",type,param);
				if(rstStr[1] == null || rstStr[1].length() == 0) {
					message = "자료생성이 완료되었습니다.";
	
					try{
						// 파일명 : 작성일자 + 서식코드(A103900) + '.' + 자료구분(1,2)
						String today = yjungsan.util.DateUtil.getDateTime("yyyyMMdd");
						String docCd = "A103900"; 	
						String reqDiv = (String)mp.get("reqDiv");
						String fileName = "/" + today + docCd + "." + reqDiv;			
						
						// 파일객체생성
						mFile = new File(saveFilePath + fileName);
						// 생성한 파일에 작성할 내용 조회
						list = getFileContentList(xmlPath+"/earnIncomeTaxMgr/earnIncomeTaxMgr.xml", paramMap);
						if(list != null && list.size() > 0) {
							for(int i = 0; i < list.size(); i++) {
								if( i > 0 ) {
									sbuf.append("\n");
								}
								Map<String,Object> fMp = (Map<String,Object>)list.get(i);
								sbuf.append(fMp.get("content").toString());
							}
						}
						Log.Debug("[ NTS FILE ] 내용 조회결과 sbuf [" + sbuf.toString() + "]");
						if (sbuf.toString().length() <= 0) {
							Log.Debug("[ NTS FILE ] 작성할 내용이없습니다.");
						}
	
						// 파일작성
						//fw = new FileWriter(mFile);
	
						FileOutputStream fileOut = new FileOutputStream(mFile);
						//BufferedWriter bufferWriter = new BufferedWriter(fw);
						fileOut.write(sbuf.toString().getBytes("euc-kr"));
						fileOut.flush();
						fileOut.close();
					} catch(Exception e) {
						message = "파일생성 오류입니다.";
						Log.Debug("[ NTS FILE ] Exception [" + e + "]");
						if (mFile != null) {
							try{
								mFile.delete();
								message = "파일생성 오류입니다.";
							} catch(Exception ex) {
								Log.Debug("[ NTS FILE ] Exception [" + ex + "]");
							}
						}
					}
				} else {
					code = "-1";
					message = "자료생성 처리도중 : "+rstStr[1];
				}
			} catch(Exception e) {
				code = "-1";
				message = e.getMessage();
			}
		}
		
		Map mapCode = new HashMap();
		mapCode.put("Code", code);
		mapCode.put("Message", message);
		mapCode.put("serverFileName", (mFile == null)? "" : mFile.getName());
		mapCode.put("tprCod", tprCod);

		Map rstMap = new HashMap();
		rstMap.put("Result", mapCode);

		out.print((new org.json.JSONObject(rstMap)).toString());
		
	} else if("getAdmCd".equals(cmd)) {
		
		Map mp = StringUtil.getRequestMap(request);
		mp.put("ssnEnterCd", ssnEnterCd);
		mp.put("ssnSabun", ssnSabun);

		Map mapData  = new HashMap();
		String message = "";
		String code = "1";
		try {
			mapData = getAdmCd(xmlPath+"/earnIncomeTaxMgr/earnIncomeTaxMgr.xml", mp);
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
		
	} else if("getTprCod".equals(cmd)) {
		
		Map mp = StringUtil.getRequestMap(request);
		mp.put("ssnEnterCd", ssnEnterCd);
		mp.put("ssnSabun", ssnSabun);

		Map mapData  = new HashMap();
		String message = "";
		String code = "1";
		try {
			mapData = getTprCod(xmlPath+"/earnIncomeTaxMgr/earnIncomeTaxMgr.xml", mp);
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
		
	}  else if ("updateAdmCd".equals(cmd)) {
		Map mp = StringUtil.getRequestMap(request);
		mp.put("ssnEnterCd", ssnEnterCd);
		mp.put("ssnSabun", ssnSabun);

		String message = "";
		String code = "1";

		try {
			int cnt = updateAdmCd(xmlPath+"/earnIncomeTaxMgr/earnIncomeTaxMgr.xml", mp);
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
		
	}  else if ("updateReqDiv".equals(cmd)) {
		Map mp = StringUtil.getRequestMap(request);
		mp.put("ssnEnterCd", ssnEnterCd);
		mp.put("ssnSabun", ssnSabun);

		String message = "";
		String code = "1";

		try {
			int cnt = updateReqDiv(xmlPath+"/earnIncomeTaxMgr/earnIncomeTaxMgr.xml", mp);
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
		
	}  else if ("updateTprCod".equals(cmd)) {
		Map mp = StringUtil.getRequestMap(request);
		mp.put("ssnEnterCd", ssnEnterCd);
		mp.put("ssnSabun", ssnSabun);

		String message = "";
		String code = "1";

		try {
			int cnt = updateTprCod(xmlPath+"/earnIncomeTaxMgr/earnIncomeTaxMgr.xml", mp);
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
		
	} else if("getRtaxMonSum".equals(cmd)) {
		
		Map mp = StringUtil.getRequestMap(request);
		mp.put("ssnEnterCd", ssnEnterCd);
		mp.put("ssnSabun", ssnSabun);

		Map mapData  = new HashMap();
		String message = "";
		String code = "1";
		try {
			mapData = getRtaxMonSum(xmlPath+"/earnIncomeTaxMgr/earnIncomeTaxMgr.xml", mp);
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
		
	} else if("getDueDate".equals(cmd)) {
		
		Map mp = StringUtil.getRequestMap(request);

		Map mapData  = new HashMap();
		String message = "";
		String code = "1";
		try {
			mapData = getDueDate(xmlPath+"/earnIncomeTaxMgr/earnIncomeTaxMgr.xml", mp);
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
		
	} else if("getEarnIncomeTaxMgrDtl1Tab1EmpPopupList".equals(cmd)) {
		Map mp = StringUtil.getRequestMap(request);
		mp.put("ssnEnterCd", ssnEnterCd);
		mp.put("ssnSabun", ssnSabun);
		List listData  = new ArrayList();
		String message = "";
		String code = "1";
		try {
			listData = getEarnIncomeTaxMgrDtl1Tab1EmpPopupList(xmlPath+"/earnIncomeTaxMgr/earnIncomeTaxMgr.xml", mp);
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
	} else if("getEarnIncomeTaxMgrDtl2EmpPopupList".equals(cmd)) {
		Map mp = StringUtil.getRequestMap(request);
		mp.put("ssnEnterCd", ssnEnterCd);
		mp.put("ssnSabun", ssnSabun);
		List listData  = new ArrayList();
		String message = "";
		String code = "1";
		try {
			listData = getEarnIncomeTaxMgrDtl2EmpPopupList(xmlPath+"/earnIncomeTaxMgr/earnIncomeTaxMgr.xml", mp);
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
	} else if("getEarnIncomeTaxMgrDtl3EmpPopupList".equals(cmd)) {
		Map mp = StringUtil.getRequestMap(request);
		mp.put("ssnEnterCd", ssnEnterCd);
		mp.put("ssnSabun", ssnSabun);
		List listData  = new ArrayList();
		String message = "";
		String code = "1";
		try {
			listData = getEarnIncomeTaxMgrDtl3EmpPopupList(xmlPath+"/earnIncomeTaxMgr/earnIncomeTaxMgr.xml", mp);
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
	
%>
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
//private Logger log = Logger.getLogger(this.getClass());
//public Map queryMap = null;
//xml 파서를 이용한 방법;
/* public void setQueryMap(String path) {
	queryMap = XmlQueryParser.getQueryMap(path);
} */

//퇴직자정산 급여코드 조회
public Map selectRetCalcPayActionInfo(String path, Map paramMap) throws Exception {
	Map queryMap = XmlQueryParser.getQueryMap(path);
	//파라메터 복사.
	Map pm =  StringUtil.getParamMapData(paramMap);
	Map mp = null;
	
	try{
		//쿼리 실행및 결과 받기.
		mp  = (queryMap==null) ? null : DBConn.executeQueryMap(queryMap,"selectRetCalcPayActionInfo",pm);
	} catch (Exception e) {
		Log.Error("[Exception] " + e);
		throw new Exception("조회에 실패하였습니다.");
	}
	
	return mp;
}

public List selectRetCalcSheet1List(String path, Map paramMap) throws Exception {
	Map queryMap = XmlQueryParser.getQueryMap(path);
	//파라메터 복사.
	Map pm =  StringUtil.getParamMapData(paramMap);
	List listData = null;
	
	try{
		//쿼리 실행및 결과 받기.
		listData  = (queryMap == null) ? null : DBConn.executeQueryList(queryMap,"selectRetCalcSheet1List",pm);
	} catch (Exception e) {
		Log.Error("[Exception] " + e);
		throw new Exception("조회에 실패하였습니다.");
	}
	
	return listData;
}

public List selectRetCalcSheet2List(String path, Map paramMap) throws Exception {
	Map queryMap = XmlQueryParser.getQueryMap(path);
	//파라메터 복사.
	Map pm =  StringUtil.getParamMapData(paramMap);
	List listData = null;
	
	try{
		//쿼리 실행및 결과 받기.
		listData  = (queryMap == null) ? null : DBConn.executeQueryList(queryMap,"selectRetCalcSheet2List",pm);
	} catch (Exception e) {
		Log.Error("[Exception] " + e);
		throw new Exception("조회에 실패하였습니다.");
	}
	
	return listData;
}

public List selectRetCalcSheet3List(String path, Map paramMap) throws Exception {
	Map queryMap = XmlQueryParser.getQueryMap(path);
	//파라메터 복사.
	Map pm =  StringUtil.getParamMapData(paramMap);
	List listData = null;
	
	try{
		//쿼리 실행및 결과 받기.
		listData  = (queryMap == null) ? null : DBConn.executeQueryList(queryMap,"selectRetCalcSheet3List",pm);
	} catch (Exception e) {
		Log.Error("[Exception] " + e);
		throw new Exception("조회에 실패하였습니다.");
	}
	
	return listData;
}

//퇴직금 마감 , 취소 처리
public int saveFinalCloseYn(String path, Map paramMap) throws Exception {
	Map queryMap = XmlQueryParser.getQueryMap(path);
	//파라메터 복사.
	Map pm =  StringUtil.getParamMapData(paramMap);
	Map mp = null;

	int rstCnt = 0;
	
	try{
		//쿼리 실행및 결과 받기.
		rstCnt = DBConn.executeUpdate(queryMap, "saveFinalCloseYn", pm);
		DBConn.executeUpdate(queryMap, "saveFinalCloseTCPN983", pm);
		DBConn.executeUpdate(queryMap, "saveFinalCloseTCPN771", pm);
	} catch (Exception e) {
		Log.Error("[Exception] " + e);
		throw new Exception("저장에 실패하였습니다.");
	}
	
	return rstCnt;
}

//대상자정보 수정
public int saveRetCalcSheet3List(String path, Map paramMap) throws Exception {
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
				 if("U".equals(sStatus)) {
					//수정
					rstCnt += DBConn.executeUpdate(queryMap, "saveRetCalcTCPN771", mp);
					rstCnt += DBConn.executeUpdate(queryMap, "saveRetCalcTCPN203", mp);
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
%>

<%
	//쿼리 맵 셋팅
	//setQueryMap(xmlPath+"/retCalc/retCalc.xml");

	String ssnEnterCd = (String)session.getAttribute("ssnEnterCd");
	String ssnSabun = (String)session.getAttribute("ssnSabun");
	String searchPayActionCd = (String)request.getParameter("searchPayActionCd");
	String cmd = (String)request.getParameter("cmd");

	//1. 퇴직금계산 급여코드 조회
	if("selectRetCalcPayActionInfo".equals(cmd)) {
		
		Map mp = StringUtil.getRequestMap(request);
		mp.put("ssnEnterCd", ssnEnterCd);
		mp.put("ssnSabun", ssnSabun);
		
		Map mapData  = new HashMap();
		String message = "";
		String code = "1";
	
		try {
			mapData = selectRetCalcPayActionInfo(xmlPath+"/retCalc/retCalc.xml", mp);
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
		
	//2. 퇴직금계산 마감정보 조회	
	} else if("selectRetCalcSheet1List".equals(cmd)) {
		
		Map mp = StringUtil.getRequestMap(request);
		mp.put("ssnEnterCd", ssnEnterCd);
		mp.put("ssnSabun", ssnSabun);
		
		List listData  = new ArrayList();
		String message = "";
		String code = "1";
	
		try {
			listData = selectRetCalcSheet1List(xmlPath+"/retCalc/retCalc.xml", mp);
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
	
	//3. 퇴직금계산 인원카운트 조회
	} else if("selectRetCalcSheet2List".equals(cmd)) {
		
		Map mp = StringUtil.getRequestMap(request);
		mp.put("ssnEnterCd", ssnEnterCd);
		mp.put("ssnSabun", ssnSabun);
		
		List listData  = new ArrayList();
		String message = "";
		String code = "1";
	
		try {
			listData = selectRetCalcSheet2List(xmlPath+"/retCalc/retCalc.xml", mp);
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
	
	//4. 퇴직금계산 인원정보 조회
	} else if("selectRetCalcSheet3List".equals(cmd)) {
		
		Map mp = StringUtil.getRequestMap(request);
		mp.put("ssnEnterCd", ssnEnterCd);
		mp.put("ssnSabun", ssnSabun);
		
		List listData  = new ArrayList();
		String message = "";
		String code = "1";
	
		try {
			listData = selectRetCalcSheet3List(xmlPath+"/retCalc/retCalc.xml", mp);
		} catch(Exception e) {
			code = "-1";
			message = e.getMessage();
		}
		
		Map mapCode = new HashMap();
		mapCode.put("Code", code);
		mapCode.put("Message", message);
		
		Map rstMap = new HashMap();
		rstMap.put("Result", mapCode);
		rstMap.put("Data",  listData == null ? null : (List)listData);
		out.print((new org.json.JSONObject(rstMap)).toString());
	
	//5. 퇴직금계산 Proc	
	} else if("prcCpnSepPayMain".equals(cmd)) {
		
		Map paramMap = StringUtil.getRequestMap(request);
		Map mp =  StringUtil.getParamMapData(paramMap);
		String[] type =  new String[]{"OUT","OUT","STR","STR","STR","STR","STR","STR"};
		String[] param = new String[]{"","",ssnEnterCd,searchPayActionCd,"","","1",ssnSabun};
		
		String message = "";
		String code = "1";
		
		try {
				String[] rstStr = DBConn.executeProcedure("P_CPN_SEP_PAY_MAIN",type,param);
				if(rstStr[1] == null || rstStr[1].length() == 0) {
					message = "퇴직금 계산이 완료되었습니다.";
				} else {
					code = "-1";
					message = "퇴직금 계산 처리도중 : "+rstStr[1];
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
	
	//6. 퇴직금계산취소 Proc	
	} else if("prcCpnSepEmpCancel".equals(cmd)) {
		
		Map paramMap = StringUtil.getRequestMap(request);
		Map mp =  StringUtil.getParamMapData(paramMap);
		String[] type =  new String[]{"OUT","OUT","STR","STR","STR","STR","STR"};
		String[] param = new String[]{"","",ssnEnterCd,searchPayActionCd,"","",ssnSabun};
		
		String message = "";
		String code = "1";
		
		try {
				String[] rstStr = DBConn.executeProcedure("P_CPN_SEP_EMP_CANCEL",type,param);
				if(rstStr[1] == null || rstStr[1].length() == 0) {
					message = "퇴직금 계산취소가 완료되었습니다.";
				} else {
					code = "-1";
					message = "퇴직금 계산취소 도중 : "+rstStr[1];
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
		
	//7.퇴직금 마감 / 마감취소
	} else if("saveFinalCloseYn".equals(cmd)) {
		
		String searchFinalCloseYN = (String)request.getParameter("searchFinalCloseYN");
		
		Map mp = StringUtil.getRequestMap(request);
		mp.put("ssnEnterCd", ssnEnterCd);
		mp.put("ssnSabun", ssnSabun);
		mp.put("searchPayActionCd", searchPayActionCd);
		mp.put("searchFinalCloseYN", searchFinalCloseYN);
		
		String message = "";
		String code = "1";
		
		try {
			int cnt = saveFinalCloseYn(xmlPath+"/retCalc/retCalc.xml", mp);
			
			if(cnt > 0) {
				if(searchFinalCloseYN.equals("Y")) {
					message = "마감 되었습니다.";	
				} else if(searchFinalCloseYN.equals("N")) {
					message = "마감취소 되었습니다.";
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

	//8. 대상자정보 저장
	} else if("saveRetCalcSheet3List".equals(cmd)) {
		
		Map mp = StringUtil.getRequestMap(request);
		mp.put("ssnEnterCd", ssnEnterCd);
		mp.put("ssnSabun", ssnSabun);
		mp.put("searchPayActionCd", searchPayActionCd);

		String message = "";
		String code = "1";
		
		try {
			int cnt = saveRetCalcSheet3List(xmlPath+"/retCalc/retCalc.xml", mp);
			
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
		
	//7. 퇴직금 재계산 Proc		
	} else if("prcCpnSepRetrayPayMain".equals(cmd)) {
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
				String select = (String)data.get("select");
				if(select.equals("1")) {
					String sStatus = (String)data.get("sStatus");
					String sabun = (String)data.get("sabun");
					String businessPlaceCd = "";
					String[] type =  new String[]{"OUT","OUT","STR","STR","STR","STR","STR"};
					String[] param = new String[]{"","",ssnEnterCd,searchPayActionCd,businessPlaceCd,sabun,ssnSabun};
					String[] rstStr = DBConn.executeProcedure("P_CPN_RETRY_PAY_MAIN",type,param);
					
					if(rstStr[1] != null && rstStr[1].length() > 0) {
						message = rstStr[1]+"\n";
					}
					cnt++;
				}
			}
			
			if(cnt > 0) {
				if(message.length() == 0) {
					message = "퇴직금 재계산이 완료 되었습니다..";
				}
			} else {
				code = "-1";
				message = "작업된 내용이 없습니다.";
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
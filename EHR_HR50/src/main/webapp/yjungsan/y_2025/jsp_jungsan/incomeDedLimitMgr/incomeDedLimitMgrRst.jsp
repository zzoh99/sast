<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="yjungsan.util.*"%>
<%@ page import="yjungsan.exception.*"%>
<%@ page import="java.sql.Connection"%>
<%@ page import="java.util.List"%>
<%@ page import="java.util.ArrayList"%>
<%@ page import="java.util.Map"%>
<%@ page import="java.util.HashMap"%>
<%@ page import="java.util.Set"%>
<%@ page import="java.util.HashSet"%>

<%@ page import="com.hr.common.logger.Log" %>
<%@ include file="../common/include/session.jsp"%>
<%@ include file="../auth/saveLog.jsp"%>
<%!
//소득공제 차감관리내역(관리자) 조회
public List selectIncomeDedLimitUploadList(Map paramMap, String locPath, String ssnYeaLogYn) throws Exception {

	//파라메터 복사.
	Map pm =  StringUtil.getParamMapData(paramMap);
	Map queryMap = XmlQueryParser.getQueryMap(locPath);
	List listData = null;

	try{
		//쿼리 실행및 결과 받기.
		listData  = (queryMap == null) ? null : DBConn.executeQueryList(queryMap,"selectIncomeDedLimitUploadList",pm);
		saveLog(null, pm, ssnYeaLogYn);
	} catch (Exception e) {
		Log.Error("[Exception] " + e);
		throw new Exception("조회에 실패하였습니다.");
	} finally {
		queryMap = null;
	}

	return listData;
}

//소득공제 차감관리내역(관리자) 상세 저장
public int saveIncomeDedLimitUploadDetail(Map paramMap, String locPath, String ssnYeaLogYn) throws Exception {
	//파라메터 맵안에는 배열형태로 저장되어 있으니 다시 리스트형태로 뽑아서 루프를 돈다.
	List list = StringUtil.getParamListData(paramMap);
	Map queryMap = XmlQueryParser.getQueryMap(locPath);

	//사용자가 직접 트렌젝션 관리하기 위해 커넥션 가져오기.
	Connection conn = DBConn.getConnection();
	int rstCnt = 0;
	String message = "";

	if(list != null && list.size() > 0 && conn != null) {

		//사용자가 직접 트랜젝션 관리
		conn.setAutoCommit(false);
		
		String[] type = null ;
		String[] param = null ;
		String[] rstStr = null ;
		
		String searchWorkYy = "";
		String searchAdjustType = "";
		
		Map<String, String> decCdMap = new HashMap<String, String>();
		decCdMap.put("B007", "M"); // 의료비
		decCdMap.put("B009", "E"); // 교육비
		
		// SYNC 패키지를 호출할 대상자를 저장할 Set
		// 대상자 및 작업 구분별 SYNC 패키지는 한 번만 호출되면 입력된 금액이 모두 반영되므로 Set으로 대상자 및 작업 구분 정리
		Set<String> syncSabunSet = new HashSet<String>();

		int cnt = 0;

		try{
			for(int i = 0; i < list.size(); i++ ) {
				String query = "";
				Map mp = (Map)list.get(i);
				String sStatus = (String)mp.get("sStatus");
                Map mp2 = (Map)list.get(0);
                String menuNm = (String)mp2.get("menuNm");
                mp.put("menuNm", menuNm);
                
                if("".equals(searchAdjustType))
                	searchAdjustType = (String)mp.get("searchAdjustType");
                if("".equals(searchWorkYy))
                	searchWorkYy = (String)mp.get("searchYear");
                
                String adjustType = (String)mp.get("adjust_type");
                String workYy = (String)mp.get("work_yy");
                String sabun = (String)mp.get("sabun");
                String decCd = (String)mp.get("deduction_cd");
                
                // 공제 항목도 하단 SYNC 패키지 호출할 때 파라미터로 필요하기 때문에 사번에 콤마(,)와 함께 붙여서 Set에 넣어준다
                syncSabunSet.add(sabun + "," + decCd);
                
				if("D".equals(sStatus)) {
					//삭제
					rstCnt += DBConn.executeUpdate(conn, queryMap, "deleteIncomeDedLimitUploadDetail", mp);
				} else if("U".equals(sStatus)) {
					//수정
					rstCnt += DBConn.executeUpdate(conn, queryMap, "updateIncomeDedLimitUploadDetail", mp);
				} else if("I".equals(sStatus)) {
					//입력 중복체크
					Map dupMap = DBConn.executeQueryMap(conn, queryMap,"selectIncomeDedLimitUploadDetailCnt",mp);

					if(dupMap != null && Integer.parseInt((String)dupMap.get("cnt")) > 0 ) {
						throw new UserException("중복되어 저장할 수 없습니다.");
					}
					//입력
					rstCnt += DBConn.executeUpdate(conn, queryMap, "insertIncomeDedLimitUploadDetail", mp);
				}
				
				saveLog(conn, mp, ssnYeaLogYn);
			}

			//커밋
			conn.commit();
			
			// 위 커밋이 되지 않으면 데이터 수정 전 상태의 금액으로 SYNC 패키지가 호출되기 때문에 INSERT / UPDATE / DELETE 작업이 커밋까지 된 이후에 SYNC 패키지를 호출한다
			for(String syncSabun: syncSabunSet) {
				/*
				 P_CPN_DED_LIMIT_APPLY 파라미터
				 
				 P_SQLCODE               OUT  VARCHAR2,  -- Error Code
		         P_SQLERRM               OUT  VARCHAR2,  -- Error Messages
		         P_ENTER_CD               IN  VARCHAR2,  -- 회사코드
		         P_WORK_YY                IN  VARCHAR2,  -- 정산년도
		         P_ADJUST_TYPE            IN  VARCHAR2,  -- 정산구분
		         P_SABUN                  IN  VARCHAR2,  -- 사원번호
		         P_DED_CD                 IN  VARCHAR2,  -- 증빙자료구분(B009: 교육비/B007: 의료비 등)
		         P_CHKID                  IN  VARCHAR2   -- 수정자
				*/
				
				// 해당 Set에는 사번과 콤마를 구분자로 하여 공제 항목이 들어가있으므로 split으로 사번과 공제 항목을 분리해준다.
				String[] sabunAndDecCd = syncSabun.split(",");
				String gubun = sabunAndDecCd[1];
				
				// 데이터 수정/입력 후 SYNC 호출하여 차감 금액 반영
				type =  new String[]{"OUT", "OUT", "STR", "STR", "STR", "STR", "STR", "STR"};

				param = new String[]{"", "", (String)paramMap.get("ssnEnterCd"), searchWorkYy, searchAdjustType, sabunAndDecCd[0], sabunAndDecCd[1], (String)paramMap.get("ssnSabun")};

				rstStr = DBConn.executeProcedure("P_CPN_DED_LIMIT_APPLY", type, param);

				if(rstStr[1] == null || rstStr[1].length() == 0) {
					cnt++;
				} else {
					message = message + "\n\n" + rstStr[1];
				}
			}
			
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

public List selectIncomeDedEmployeeList(Map paramMap, String locPath, String ssnYeaLogYn) throws Exception {

	//파라메터 복사.
	Map pm =  StringUtil.getParamMapData(paramMap);
	Map queryMap = XmlQueryParser.getQueryMap(locPath);
	List listData = null;

	try{
		//쿼리 실행및 결과 받기.
		listData  = (queryMap == null) ? null : DBConn.executeQueryList(queryMap,"selectIncomeDedEmployeeList",pm);
		saveLog(null, pm, ssnYeaLogYn);
	} catch (Exception e) {
		Log.Error("[Exception] " + e);
		throw new Exception("조회에 실패하였습니다.");
	} finally {
		queryMap = null;
	}

	return listData;
}

public List getIncomeDedEmployeeDetailList(Map paramMap, String locPath, String ssnYeaLogYn) throws Exception {

	//파라메터 복사.
	Map pm =  StringUtil.getParamMapData(paramMap);
	Map queryMap = XmlQueryParser.getQueryMap(locPath);
	List listData = null;

	try{
		//쿼리 실행및 결과 받기.
		listData  = (queryMap == null) ? null : DBConn.executeQueryList(queryMap,"getIncomeDedEmployeeDetailList",pm);
		saveLog(null, pm, ssnYeaLogYn);
	} catch (Exception e) {
		Log.Error("[Exception] " + e);
		throw new Exception("조회에 실패하였습니다.");
	} finally {
		queryMap = null;
	}

	return listData;
}

public List getDedItemList(Map paramMap, String locPath, String ssnYeaLogYn) throws Exception {

	//파라메터 복사.
	Map pm =  StringUtil.getParamMapData(paramMap);
	Map queryMap = XmlQueryParser.getQueryMap(locPath);
	List listData = null;
	
	StringBuffer query   = new StringBuffer();
	query.setLength(0);
	String adjProcessCd = null;
	
	if(pm.get("adjProcessCd") != null) {
		adjProcessCd = String.valueOf(pm.get("adjProcessCd"));
		query.append(" AND ADJ_PROCESS_CD 	= '" + adjProcessCd + "' \n");
	}
	
	// 의료비의 경우 가공 후 금액에 차감 금액이 반영되도록 처리하기 위해 이에 해당하는 코드만 조회되도록 처리
	if(adjProcessCd != null && adjProcessCd.trim().length() != 0 && adjProcessCd.equals("B007")) {
		query.append(" AND ADJ_ELEMENT_CD NOT IN ('A050_30', 'A050_40', 'A050_50', 'A050_60', 'A050_70', 'A050_80', 'A050_90', 'A050_13', 'A050_131', 'A050_100', 'A050_110')");
		//query.append(" AND ADJ_ELEMENT_CD IN ('A050_02', 'A050_03', 'A050_04', 'A050_05', 'A050_10', 'A050_11')");
	}
	
	pm.put("query", query.toString());

	try{
		//쿼리 실행및 결과 받기.
		listData  = (queryMap == null) ? null : DBConn.executeQueryList(queryMap,"getDedItemList",pm);
		saveLog(null, pm, ssnYeaLogYn);
	} catch (Exception e) {
		Log.Error("[Exception] " + e);
		throw new Exception("조회에 실패하였습니다.");
	} finally {
		queryMap = null;
	}

	return listData;
}

%>

<%
	String locPath = xmlPath+"/incomeDedLimitMgr/incomeDedLimitMgr.xml";

	String ssnEnterCd = (String)session.getAttribute("ssnEnterCd");
	String ssnSabun = (String)session.getAttribute("ssnSabun");
	String ssnYeaLogYn = (String)session.getAttribute("ssnYeaLogYn");
	String cmd = (String)request.getParameter("cmd");

	if("selectIncomeDedLimitUploadList".equals(cmd)) {
		//기부금조정명세(관리자) 조회

		Map mp = StringUtil.getRequestMap(request);
		mp.put("ssnEnterCd", ssnEnterCd);
		mp.put("ssnSabun", ssnSabun);
		mp.put("cmd", cmd);
		List listData  = new ArrayList();
		String message = "";
		String code = "1";
		
		try {
			listData = selectIncomeDedLimitUploadList(mp, locPath, ssnYeaLogYn);
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

	} else if("saveIncomeDedLimitUploadDetail".equals(cmd)) {
		//기부금조정명세(관리자) 상세 저장

		Map mp = StringUtil.getRequestMap(request);
		mp.put("ssnEnterCd", ssnEnterCd);
		mp.put("ssnSabun", ssnSabun);
		mp.put("cmd", cmd);
		String message = "";
		String code = "1";

		try {
			int cnt = saveIncomeDedLimitUploadDetail(mp, locPath, ssnYeaLogYn);

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

	} else if("selectIncomeDedEmployeeList".equals(cmd)) {
		Map mp = StringUtil.getRequestMap(request);
		mp.put("ssnEnterCd", ssnEnterCd);
		mp.put("ssnSabun", ssnSabun);
		mp.put("cmd", cmd);
		List listData  = new ArrayList();
		String message = "";
		String code = "1";

		try {
			listData = selectIncomeDedEmployeeList(mp, locPath, ssnYeaLogYn);
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
	} else if("getIncomeDedEmployeeDetailList".equals(cmd)) {
		Map mp = StringUtil.getRequestMap(request);
		mp.put("ssnEnterCd", ssnEnterCd);
		mp.put("ssnSabun", ssnSabun);
		mp.put("cmd", cmd);
		List listData  = new ArrayList();
		String message = "";
		String code = "1";

		try {
			listData = getIncomeDedEmployeeDetailList(mp, locPath, ssnYeaLogYn);
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
	} else if("getDedItemList".equals(cmd)) {
		Map mp = StringUtil.getRequestMap(request);
		mp.put("ssnEnterCd", ssnEnterCd);
		mp.put("ssnSabun", ssnSabun);
		mp.put("cmd", cmd);
		List listData  = new ArrayList();
		String message = "";
		String code = "1";

		try {
			listData = getDedItemList(mp, locPath, ssnYeaLogYn);
		} catch(Exception e) {
			code = "-1";
			message = e.getMessage();
		}

		Map mapCode = new HashMap();
		mapCode.put("Code", code);
		mapCode.put("Message", message);

		Map rstMap = new HashMap();
		rstMap.put("Result", mapCode);
		rstMap.put("codeList", listData == null ? null : (List)listData);
		out.print((new org.json.JSONObject(rstMap)).toString());
	}
%>
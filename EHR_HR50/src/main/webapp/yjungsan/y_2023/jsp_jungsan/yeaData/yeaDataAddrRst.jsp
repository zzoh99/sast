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
<%@ include file="../auth/saveLog.jsp"%>
<%!

//소득공제자료등록(주소사항)
public List selectYeaDataAddrList(Map paramMap, String locPath, String ssnYeaLogYn) throws Exception {

	//파라메터 복사.
	Map pm =  StringUtil.getParamMapData(paramMap);
	//xml 파서를 이용한 방법;
	Map queryMap = XmlQueryParser.getQueryMap(locPath);
	List listData = null;

	try{
		//쿼리 실행및 결과 받기.
		listData  = (queryMap == null) ? null : DBConn.executeQueryList(queryMap,"selectYeaDataAddrList",pm);
		saveLog(null, pm, ssnYeaLogYn);
	} catch (Exception e) {
		Log.Error("[Exception] " + e);
		throw new Exception("조회에 실패하였습니다.");
	} finally {
		queryMap = null;
	}

	return listData;
}

//우편번호 조회대상 가능 리스트
/* public List selectTargetZipCodeList(Map paramMap, String locPath) throws Exception {

	//파라메터 복사.
	Map pm =  StringUtil.getParamMapData(paramMap);
	//xml 파서를 이용한 방법;
	Map queryMap = XmlQueryParser.getQueryMap(locPath);
	List listData = null;

	try{
		//쿼리 실행및 결과 받기.
		listData  = (queryMap == null) ? null : DBConn.executeQueryList(queryMap,"selectTargetZipCodeList",pm);
	} catch (Exception e) {
		Log.Error("[Exception] " + e);
		throw new Exception("조회에 실패하였습니다.");
	} finally {
		queryMap = null;
	}

	return listData;
} */

//소득공제자료등록(주소사항) 원본 주소 조회
public Map selectYeaDataOrgAddr(Map paramMap, String locPath, String ssnYeaLogYn) throws Exception {

	//파라메터 복사.
	Map pm =  StringUtil.getParamMapData(paramMap);
	//xml 파서를 이용한 방법;
	Map queryMap = XmlQueryParser.getQueryMap(locPath);
	Map mapData = null;

	try{
		//쿼리 실행및 결과 받기.
		mapData  = (queryMap == null) ? null : DBConn.executeQueryMap(queryMap,"selectYeaDataOrgAddr",pm);
		saveLog(null, pm, ssnYeaLogYn);
	} catch (Exception e) {
		Log.Error("[Exception] " + e);
		throw new Exception("조회에 실패하였습니다.");
	} finally {
		queryMap = null;
	}

	return mapData;
}

//소득공제자료등록(주소사항) 저장.
public int saveYeaDataAddr(Map paramMap, String locPath, String ssnYeaLogYn) throws Exception {

	//파라메터 맵안에는 배열형태로 저장되어 있으니 다시 리스트형태로 뽑아서 루프를 돈다.
	List list = StringUtil.getParamListData(paramMap);
	//xml 파서를 이용한 방법;
	Map queryMap = XmlQueryParser.getQueryMap(locPath);

	//사용자가 직접 트렌젝션 관리하기 위해 커넥션 가져오기.
	Connection conn = DBConn.getConnection();

	int rstCnt = 0;

	if (conn != null) {
		//사용자가 직접 트랜젝션 관리
		conn.setAutoCommit(false);

		if(list != null && list.size() > 0) {
			try{
				for(int i = 0; i < list.size(); i++ ) {
					String query = "";
					Map mp = (Map)list.get(i);
					String sStatus = (String)mp.get("sStatus");
					String adminYn = (String)mp.get("admin_yn");
	                Map mp2 = (Map)list.get(0);
	                String menuNm = (String)mp2.get("menuNm");
	                mp.put("menuNm", menuNm);
					// 다음 해 신청정보 조회
					int nextWorkYy = (mp.get("work_yy") == null)? null : Integer.parseInt(mp.get("work_yy").toString()) + 1;
					mp.put("next_work_yy", Integer.toString(nextWorkYy));
	
					if("U".equals(sStatus)) {
	
						// 개인별원천징수세율 신청내역이 없을 경우에만 저장
						Map mapData  = (queryMap==null) ? null : DBConn.executeQueryMap(queryMap,"selectITaxRateApp",mp);
						String cnt = (String)mapData.get("cnt");
						/* 추후 로직 연구 후 로직 개발
						String taxRate    = (String)mp.get("tax_rate");
						String taxRateOld = (String)mp.get("tax_rate_old");
	
						if((!"".equals(taxRate)) && cnt.equals("0") && !taxRateOld.equals(taxRateOld)){
							// 개인별원천징수세율 (TCPN114) 저장 (사용자: 처리중 / 관리자: 처리완료)
							if("Y".equals(adminYn)){
								mp.put("appl_status", "99");
								mp.put("appr_ymd", yjungsan.util.DateUtil.getDateTime("yyyyMMdd"));
								mp.put("appl_ym", nextWorkYy + "01");	// 다음해 1월
								mp.put("sdate", nextWorkYy + "0101");	// 다음해 1월1일
								mp.put("memo", "연말정산 자동입력");
							}else{
								mp.put("appl_status", "21");
								mp.put("appr_ymd", "");
								mp.put("appl_ym", nextWorkYy + "01");	// 다음해 1월로
								mp.put("sdate", nextWorkYy + "0101");	// 다음해 1월1일
								mp.put("memo", "연말정산 자동입력");
							}
	
							DBConn.executeUpdate(conn, queryMap, "insertITaxRateApp", mp);
						} */
	
						//소득공제자료등록(주소사항) 수정
						rstCnt += DBConn.executeUpdate(conn, queryMap, "updateYeaDataAddr", mp);
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
	}
	return rstCnt;
}

// 개인별원천징수세율 신청 확인
public Map selectITaxRateApp(Map paramMap, String locPath, String ssnYeaLogYn) throws Exception {

	//파라메터 복사.
	Map pm =  StringUtil.getParamMapData(paramMap);
	//xml 파서를 이용한 방법;
	Map queryMap = XmlQueryParser.getQueryMap(locPath);
	Map mapData = null;

	try{
		// 다음 해 신청정보 조회
		int nextWorkYy = (pm.get("work_yy") == null)? null : Integer.parseInt(pm.get("work_yy").toString()) + 1;
		pm.put("next_work_yy", Integer.toString(nextWorkYy));
		//쿼리 실행및 결과 받기.
		mapData = (queryMap == null) ? null : DBConn.executeQueryMap(queryMap,"selectITaxRateApp",pm);
		saveLog(null, pm, ssnYeaLogYn);
	} catch (Exception e) {
		Log.Error("[Exception] " + e);
		throw new Exception("조회에 실패하였습니다.");
	} finally {
		queryMap = null;
	}

	return mapData;
}

//우편번호 버튼 사용여부
public Map selectTargetZipCodeList(Map paramMap, String locPath) throws Exception {

	//파라메터 복사.
	Map pm =  StringUtil.getParamMapData(paramMap);
	//xml 파서를 이용한 방법;
	Map queryMap = XmlQueryParser.getQueryMap(locPath);
	Map map = null;

	try{
		//쿼리 실행및 결과 받기.
		pm  = (queryMap == null) ? null : DBConn.executeQueryMap(queryMap,"selectTargetZipCodeList",pm);
	} catch (Exception e) {
		Log.Error("[Exception] " + e);
		throw new Exception("조회에 실패하였습니다.");
	} finally {
		queryMap = null;
	}

	return pm;
}
//자료등록 필수기입사항 msg
public Map selectYeaAlert(Map paramMap, String locPath, String ssnYeaLogYn) throws Exception {

    //파라메터 복사.
    Map pm =  StringUtil.getParamMapData(paramMap);
	//xml 파서를 이용한 방법;
	Map queryMap = XmlQueryParser.getQueryMap(locPath);
    Map mapData = null;

    try{
        //쿼리 실행및 결과 받기.
        mapData  = (queryMap == null) ? null : DBConn.executeQueryMap(queryMap,"selectYeaAlert",pm);
        saveLog(null, pm, ssnYeaLogYn);
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
	String locPath = xmlPath+"/yeaData/yeaDataAddr.xml";
	Map queryMap = XmlQueryParser.getQueryMap(locPath);

	String ssnEnterCd = (String)session.getAttribute("ssnEnterCd");
	String ssnSabun = (String)session.getAttribute("ssnSabun");
	String ssnYeaLogYn = (String)session.getAttribute("ssnYeaLogYn");
	String cmd = (String)request.getParameter("cmd");

	if("selectYeaDataAddrList".equals(cmd)) {
		//소득공제자료등록(주소사항) 조회

		Map mp = StringUtil.getRequestMap(request);
		mp.put("ssnEnterCd", ssnEnterCd);
		mp.put("ssnSabun", ssnSabun);
		mp.put("cmd", cmd);
		List listData  = new ArrayList();
		String message = "";
		String code = "1";

		try {
			listData = selectYeaDataAddrList(mp, locPath, ssnYeaLogYn);
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

	} else if("selectYeaDataOrgAddr".equals(cmd)) {
		//소득공제자료등록(주소사항) 원본 주소 조회

		Map mp = StringUtil.getRequestMap(request);
		mp.put("ssnEnterCd", ssnEnterCd);
		mp.put("ssnSabun", ssnSabun);
		mp.put("cmd", cmd);
		Map mapData  = new HashMap();
		String message = "";
		String code = "1";

		try {
			mapData = selectYeaDataOrgAddr(mp, locPath, ssnYeaLogYn);
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

	} else if("saveYeaDataAddr".equals(cmd)) {

		Map mp = StringUtil.getRequestMap(request);
		mp.put("ssnEnterCd", ssnEnterCd);
		mp.put("ssnSabun", ssnSabun);
		mp.put("cmd", cmd);
		String message = "";
		String code = "1";

		try {
			int cnt = saveYeaDataAddr(mp, locPath, ssnYeaLogYn);

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
	} else if("saveYeaDataAddrConfirm".equals(cmd)) {
		Map mp = StringUtil.getRequestMap(request);
        mp.put("ssnEnterCd", ssnEnterCd);
        mp.put("ssnSabun", request.getParameter("sabun"));
        mp.put("adjust_type", request.getParameter("adjust_type"));
        mp.put("work_yy", request.getParameter("work_yy"));
        mp.put("input_status", request.getParameter("input_status"));
        mp.put("cmd", cmd);
        //사용자가 직접 트렌젝션 관리하기 위해 커넥션 가져오기.
        Connection conn = DBConn.getConnection();
        int rstCnt = 0;

        String message = "";
        String code = "1";
        if (conn != null) {
			//사용자가 직접 트랜젝션 관리
			conn.setAutoCommit(false);
	        String inputStatus = String.valueOf(request.getParameter("input_status"));
	
	        try {
	            int cnt = DBConn.executeUpdate(conn, queryMap, "updateYeaDataAddrConfirm", mp);
	
	            if(cnt > 0) {
	                message = inputStatus.equals("1") ? "확정되었습니다." : "확정 취소 되었습니다.";
	            } else {
	                code = "-1";
	                message = inputStatus.equals("1") ? "확정 된 내역이 없습니다." : "확정 취소 된 내역이 없습니다.";
	            }
	            conn.commit();
	        } catch(Exception e) {
	        	code = "-1";
	            message = inputStatus.equals("1") ? "확정에 실패하였습니다." : "확정 취소에 실패하였습니다.";
	
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

        Map mapCode = new HashMap();
        mapCode.put("Code", code);
        mapCode.put("Message", message);

        Map rstMap = new HashMap();
        rstMap.put("Result", mapCode);

        out.print((new org.json.JSONObject(rstMap)).toString());

	} else if("selectITaxRateApp".equals(cmd)) {
		Map mp = StringUtil.getRequestMap(request);
        mp.put("ssnEnterCd", ssnEnterCd);
        mp.put("sabun", request.getParameter("sabun"));
        mp.put("work_yy", request.getParameter("work_yy"));
        mp.put("cmd", cmd);
		Map mapData  = new HashMap();
		String message = "";
		String code = "1";

		try {
			mapData = selectITaxRateApp(mp, locPath, ssnYeaLogYn);
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

	}else if("selectTargetZipCodeList".equals(cmd)) {
		//담당자피드백 표시

				Map mp = StringUtil.getRequestMap(request);
				//mp.put("ssnEnterCd", ssnEnterCd);
				//mp.put("ssnSabun", ssnSabun);

				Map mapData  = new HashMap();
				String message = "";
				String code = "1";

				try {
					mapData = selectTargetZipCodeList(mp, locPath);
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
	}else if("selectYeaAlert".equals(cmd)) {
		//자료등록 필수기입사항 msg
        Map mp = StringUtil.getRequestMap(request);
        mp.put("ssnEnterCd", ssnEnterCd);
        mp.put("ssnSabun", ssnSabun);

        Map mapData  = new HashMap();
        String message = "";
        String code = "1";

        try {
            mapData = selectYeaAlert(mp, locPath, ssnYeaLogYn);
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
    }
%>
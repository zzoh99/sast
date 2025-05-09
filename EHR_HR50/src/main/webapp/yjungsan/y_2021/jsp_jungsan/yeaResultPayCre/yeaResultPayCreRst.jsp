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
//연말정산결과 급여반영 조회
public List selectYeaResultPayCreList(Map paramMap, String locPath, String ssnYeaLogYn) throws Exception {

	//파라메터 복사.
	Map pm =  StringUtil.getParamMapData(paramMap);
	Map queryMap = XmlQueryParser.getQueryMap(locPath);
	List listData = null;

	String srchAdjustType	 = String.valueOf(pm.get("srchAdjustType"));
	String searchRtrApplyCd	 = String.valueOf(pm.get("searchRtrApplyCd"));

	StringBuffer query  = new StringBuffer();
	query.setLength(0);

	if(!srchAdjustType.equals("1")){
		query.append("AND A.SABUN IN (SELECT G.SABUN FROM TCPN811 G WHERE G.ENTER_CD = A.ENTER_CD AND G.WORK_YY = A.WORK_YY AND G.ADJUST_TYPE = A.ADJUST_TYPE AND G.SABUN = A.SABUN AND G.PAY_ACTION_CD = '"+searchRtrApplyCd+"')");
	}

	pm.put("query", query.toString());

	try{
		//쿼리 실행및 결과 받기.
		listData  = (queryMap == null) ? null : DBConn.executeQueryList(queryMap,"selectYeaResultPayCreList",pm);
		saveLog(null, pm, ssnYeaLogYn);
	} catch (Exception e) {
		Log.Error("[Exception] " + e);
		throw new Exception("조회에 실패하였습니다.");
	}

	return listData;
}
public List selectYeaResultRtrCreList(Map paramMap, String locPath, String ssnYeaLogYn) throws Exception {

	//파라메터 복사.
	Map pm =  StringUtil.getParamMapData(paramMap);
	Map queryMap = XmlQueryParser.getQueryMap(locPath);
	List listData = null;

	try{
		//쿼리 실행및 결과 받기.
		listData  = (queryMap == null) ? null : DBConn.executeQueryList(queryMap,"selectYeaResultRtrCreList",pm);
		saveLog(null, pm, ssnYeaLogYn);
	} catch (Exception e) {
		Log.Error("[Exception] " + e);
		throw new Exception("조회에 실패하였습니다.");
	}

	return listData;
}

//작업일자 조회
public List selectYeaResultPayCrePayDayPopupList(Map paramMap, String locPath, String ssnYeaLogYn) throws Exception {

	//파라메터 복사.
	Map pm =  StringUtil.getParamMapData(paramMap);
	Map queryMap = XmlQueryParser.getQueryMap(locPath);
	List listData = null;

	try{
		//쿼리 실행및 결과 받기.
		listData  = (queryMap == null) ? null : DBConn.executeQueryList(queryMap,"selectYeaResultPayCrePayDayPopupList",pm);
		saveLog(null, pm, ssnYeaLogYn);
	} catch (Exception e) {
		Log.Error("[Exception] " + e);
		throw new Exception("조회에 실패하였습니다.");
	}

	return listData;
}


//연말정산결과 급여반영 저장
public int saveYeaResultPayCre(Map paramMap, String locPath, String ssnYeaLogYn) throws Exception {
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
                Map mp2 = (Map)list.get(0);
                String menuNm = (String)mp2.get("menuNm");
                mp.put("menuNm", menuNm);
				if("D".equals(sStatus)) {
					//삭제
					rstCnt += DBConn.executeUpdate(conn, queryMap, "deleteYeaResultPayCre", mp);
					rstCnt += DBConn.executeUpdate(conn, queryMap, "deleteYeaResultPayCre109", mp);
					rstCnt += DBConn.executeUpdate(conn, queryMap, "deleteYeaResultPayCre110", mp);
				} else if("U".equals(sStatus)) {
					//수정
					rstCnt += DBConn.executeUpdate(conn, queryMap, "updateYeaResultPayCre", mp);
				} else if("I".equals(sStatus)) {
					//입력 중복체크
					Map dupMap = (queryMap == null) ? null : DBConn.executeQueryMap(conn, queryMap,"selectYeaResultPayCreCnt",mp);

					if(dupMap != null && Integer.parseInt((String)dupMap.get("cnt")) > 0 ) {
						throw new UserException("중복되어 저장할 수 없습니다.");
					}
					//입력
					rstCnt += DBConn.executeUpdate(conn, queryMap, "insertYeaResultPayCre", mp);
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
		}
	}

	return rstCnt;
}

public Map getPayActionCdList(Map paramMap, String locPath) throws Exception {

	//파라메터 복사.
	Map pm =  StringUtil.getParamMapData(paramMap);
	Map queryMap = XmlQueryParser.getQueryMap(locPath);
	Map mp = null;

	try{
		//쿼리 실행및 결과 받기.
		mp  = (queryMap == null) ? null : DBConn.executeQueryMap(queryMap,"getPayActionCdList",pm);
	} catch (Exception e) {
		Log.Error("[Exception] " + e);
		throw new Exception("조회에 실패하였습니다.");
	}

	return mp;
}
//소득,주민,농특세 조회
public Map selectTaxInfo(Map paramMap, String locPath) throws Exception {

	//파라메터 복사.
	Map pm =  StringUtil.getParamMapData(paramMap);
	Map queryMap = XmlQueryParser.getQueryMap(locPath);
	Map mp = null;
	
	try{
	    //쿼리 실행및 결과 받기.
	    mp  = (queryMap == null) ? null : DBConn.executeQueryMap(queryMap,"selectTaxInfo",pm);
	} catch (Exception e) {
	    Log.Error("[Exception] " + e);
	    throw new Exception("조회에 실패하였습니다.");
	}
	
	return mp;
}
//연말정산급여반영 세금조회
public List selectYeaTaxInfoList(Map paramMap, String locPath, String ssnYeaLogYn) throws Exception {

	//파라메터 복사.
	Map pm =  StringUtil.getParamMapData(paramMap);
	Map queryMap = XmlQueryParser.getQueryMap(locPath);
	List listData = null;
	
	// String srchAdjustType    = String.valueOf(pm.get("srchAdjustType"));
	// String searchRtrApplyCd  = String.valueOf(pm.get("searchRtrApplyCd"));
	
	// StringBuffer query  = new StringBuffer();
	// query.setLength(0);
	
	// if(!srchAdjustType.equals("1")){
	//     query.append("AND A.SABUN IN (SELECT G.SABUN FROM TCPN811 G WHERE G.ENTER_CD = A.ENTER_CD AND G.WORK_YY = A.WORK_YY AND G.ADJUST_TYPE = A.ADJUST_TYPE AND G.SABUN = A.SABUN AND G.PAY_ACTION_CD = '"+searchRtrApplyCd+"')");
	// }       
	
	// pm.put("query", query.toString());
	
	try{
	    //쿼리 실행및 결과 받기.
	    listData  = (queryMap == null) ? null : DBConn.executeQueryList(queryMap,"selectYeaTaxInfoList",pm);
	    saveLog(null, pm, ssnYeaLogYn);
	} catch (Exception e) {
	    Log.Error("[Exception] " + e);
	    throw new Exception("조회에 실패하였습니다.");
	}
	
	return listData;
}
%>

<%
	String locPath = xmlPath+"/yeaResultPayCre/yeaResultPayCre.xml";

	String ssnEnterCd = (String)session.getAttribute("ssnEnterCd");
	String ssnSabun = (String)session.getAttribute("ssnSabun");
	String ssnYeaLogYn = (String)session.getAttribute("ssnYeaLogYn");
	String cmd = (String)request.getParameter("cmd");

	if("selectYeaResultPayCreList".equals(cmd)) {
		//연말정산결과 급여반영

		Map mp = StringUtil.getRequestMap(request);
		mp.put("ssnEnterCd", ssnEnterCd);
		mp.put("ssnSabun", ssnSabun);
		mp.put("cmd", cmd);
		List listData  = new ArrayList();
		String message = "";
		String code = "1";

		try {
			listData = selectYeaResultPayCreList(mp, locPath, ssnYeaLogYn);
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

	} else if("selectYeaResultRtrCreList".equals(cmd)) {
		//연말정산결과 급여반영

		Map mp = StringUtil.getRequestMap(request);
		mp.put("ssnEnterCd", ssnEnterCd);
		mp.put("ssnSabun", ssnSabun);
		mp.put("cmd", cmd);
		List listData  = new ArrayList();
		String message = "";
		String code = "1";

		try {
			listData = selectYeaResultRtrCreList(mp, locPath, ssnYeaLogYn);
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

	} else if("selectYeaResultPayCrePayDayPopupList".equals(cmd)) {
		//급여반영일자 팝업 조회

		Map mp = StringUtil.getRequestMap(request);
		mp.put("ssnEnterCd", ssnEnterCd);
		mp.put("ssnSabun", ssnSabun);
		mp.put("cmd", cmd);
		List listData  = new ArrayList();
		String message = "";
		String code = "1";

		try {
			listData = selectYeaResultPayCrePayDayPopupList(mp, locPath, ssnYeaLogYn);
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

	} else if("saveYeaResultPayCre".equals(cmd)) {
		//연말정산결과 급여반영 저장

		Map mp = StringUtil.getRequestMap(request);
		mp.put("ssnEnterCd", ssnEnterCd);
		mp.put("ssnSabun", ssnSabun);
		mp.put("cmd", cmd);
		String message = "";
		String code = "1";

		try {
			int cnt = saveYeaResultPayCre(mp, locPath, ssnYeaLogYn);

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
	} else if("prcYeaResultPayCre".equals(cmd)) {
		//연말정산결과 급여반영

		Map paramMap = StringUtil.getRequestMap(request);
		Map mp =  StringUtil.getParamMapData(paramMap);

		String workYy = (String)mp.get("searchWorkYy");
		String adjustType = (String)mp.get("srchAdjustType");
		String bizPlaceCd = (String)mp.get("searchBizPlaceCd");
		String payApplyCd = (String)mp.get("searchPayApplyCd");
		String monthSeq = (String)mp.get("searchMonthSeq");
		String jobGubun = (String)mp.get("jobGubun");
		String rtrApplyCd = (String)mp.get("searchRtrApplyCd");
		
		//주민세,소득세,농특세 추가(2021.11)
        String elementCd1 = (String)mp.get("element_cd1");
        String elementCd2 = (String)mp.get("element_cd2");
        String elementCd3 = (String)mp.get("element_cd3");
        
        String[] type =  new String[]{"OUT","OUT","STR","STR","STR","STR","STR","STR","STR","STR","STR","STR","STR","STR"};
        String[] param = new String[]{"","",ssnEnterCd,workYy,adjustType,bizPlaceCd,payApplyCd,jobGubun,monthSeq,rtrApplyCd,elementCd1,elementCd2,elementCd3,ssnSabun};

		String message = "";
		String code = "1";
		int cnt = 0;

		try {

            //P_CPN_YEAREND_RESULT_ + 연도 -> P_CPN_YEAREND_RESULT_APPLY(21.11.01 - 프로시저명 변경)
            String[] rstStr = DBConn.executeProcedure("P_CPN_YEAREND_RESULT_APPLY",type,param);
            
			if(rstStr[1] == null || rstStr[1].length() == 0) {
				message = "작업이 완료되었습니다.";
			} else {
				code = "-1";
				message = "작업 처리도중 : "+rstStr[1];
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

	}else if("getPayActionCdList".equals(cmd)) {
		//연말정산 급여코드 조회

		Map mp = StringUtil.getRequestMap(request);
		mp.put("ssnEnterCd", ssnEnterCd);
		mp.put("ssnSabun", ssnSabun);

		Map mapData  = new HashMap();
		String message = "";
		String code = "1";

		try {
			mapData = getPayActionCdList(mp, locPath);
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

	} else if("selectTaxInfo".equals(cmd)) {
        //연말정산 급여코드 조회

        Map mp = StringUtil.getRequestMap(request);
        mp.put("ssnEnterCd", ssnEnterCd);
        mp.put("ssnSabun", ssnSabun);
        mp.put("cmd", cmd);
        Map mapData  = new HashMap();
        String message = "";
        String code = "1";

        try {
            mapData = selectTaxInfo(mp, locPath);
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

    } else if("selectYeaTaxInfoList".equals(cmd)) {
        //연말정산결과 급여반영 세금조회
        
        Map mp = StringUtil.getRequestMap(request);
        mp.put("ssnEnterCd", ssnEnterCd);
        mp.put("ssnSabun", ssnSabun);
        mp.put("cmd", cmd);
        List listData  = new ArrayList();
        String message = "";
        String code = "1";
    
        try {
            listData = selectYeaTaxInfoList(mp, locPath, ssnYeaLogYn);
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
        
    } 
%>
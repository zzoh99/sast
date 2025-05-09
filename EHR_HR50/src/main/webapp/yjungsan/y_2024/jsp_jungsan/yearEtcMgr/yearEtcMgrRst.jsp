<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="yjungsan.util.*"%>
<%@ page import="yjungsan.exception.*"%>
<%@ page import="java.sql.Connection"%>
<%@ page import="java.util.List"%>
<%@ page import="java.util.ArrayList"%>
<%@ page import="java.util.Map"%>
<%@ page import="java.util.HashMap"%>

<%@ page import="com.hr.common.logger.Log" %>
<%@ include file="../common/include/session.jsp"%>
<%@ include file="../auth/saveLog.jsp"%>
<%!

//연말정산 기타소득 검색
public List selectYearEtcMgr(Map paramMap, String locPath, String ssnYeaLogYn) throws Exception {

	//파라메터 복사.
	Map pm =  StringUtil.getParamMapData(paramMap);
	//xml 파서를 이용한 방법;
	Map queryMap = XmlQueryParser.getQueryMap(locPath);
	List list = null;

	try{
		//쿼리 실행및 결과 받기.
		list = (queryMap == null) ? null : DBConn.executeQueryList(queryMap,"selectYearEtcMgr",pm);
		saveLog(null, pm, ssnYeaLogYn);
	} catch (Exception e) {
		Log.Error("[Exception] " + e);
		throw new Exception("조회에 실패하였습니다.");
	} finally {
		queryMap = null;
	}

	return list;
}

//연말정산 기타소득 저장.
public int saveYearEtcMgr(Map paramMap, String locPath, String ssnYeaLogYn) throws Exception {

	//파라메터 맵안에는 배열형태로 저장되어 있으니 다시 리스트형태로 뽑아서 루프를 돈다.
	List list = StringUtil.getParamListData(paramMap);
	//xml 파서를 이용한 방법;
	Map queryMap = XmlQueryParser.getQueryMap(locPath);
	int rstCnt = 0;

	if(list != null && list.size() > 0) {

		try{
			Map mp = null;
			String ssnEnterCd = (String) paramMap.get("ssnEnterCd");
			String ssnSabun = (String) paramMap.get("ssnSabun");
			String searchWorkYy = "";
			String searchAdjustType = "";
			String message = "";
			String code = "1";

			for(int i = 0; i < list.size(); i++ ) {
				mp = (Map)list.get(i);
				Map mp2 = (Map)list.get(0);

				String menuNm = (String)mp2.get("menuNm");
				searchWorkYy = (String)mp2.get("srchYear");
				searchAdjustType = (String)mp2.get("srchAdjustType");

				String sStatus = (String)mp.get("sStatus");
				String workYy = (String)mp.get("workYy");
				String adjustType = (String)mp.get("adjust_type");
				String sabun = (String)mp.get("sabun");
				String ym = (String)mp.get("ym");
				String adjElementCd = (String)mp.get("adj_element_cd");
				String mon = (String)mp.get("mon");
				String memo = (String)mp.get("memo");

				// 화면단에서 귀속년도와 정산구분이 빈값으로 넘어오면 조회조건의 귀속년도와 정산구분 값으로 세팅한다.
				workYy = (workYy == null || "".equals(workYy)) ? searchWorkYy : workYy;
				adjustType = (adjustType == null || "".equals(adjustType)) ? searchAdjustType : adjustType;

				mp.put("menuNm", menuNm);

				String[] type =  new String[]{"OUT","OUT"
						,"STR","STR","STR","STR","STR"
						,"STR","STR","STR","STR","STR"};

				String[] param = new String[] {"", ""
						, ssnEnterCd, sStatus, workYy, adjustType, sabun
						, ym, adjElementCd, mon, memo, ssnSabun};

				String[] rstStr = DBConn.executeProcedure("P_CPN_YEAREND_ETC_INS", type, param);

				if(rstStr[1] != null && rstStr[1].length() > 0) {
					message = rstStr[1] + "\n";
				}
				rstCnt++;
			}
		} catch(UserException e) {
			try {
			} catch (Exception e1) {
				Log.Error("[rollback Exception] " + e);
			}
			rstCnt = 0;
			Log.Error("[Exception] " + e);
			throw new Exception(e.getMessage());
		} catch(Exception e) {
			try {
			} catch (Exception e1) {
				Log.Error("[rollback Exception] " + e);
			}
			rstCnt = 0;
			Log.Error("[Exception] " + e);
			throw new Exception("저장에 실패하였습니다.");
		} finally {
		    queryMap = null;
		}
	}

	return rstCnt;
}

%>

<%
	String locPath = xmlPath+"/yearEtcMgr/yearEtcMgr.xml";

	String ssnEnterCd = (String)session.getAttribute("ssnEnterCd");
	String ssnSabun = (String)session.getAttribute("ssnSabun");
	String ssnYeaLogYn = (String)session.getAttribute("ssnYeaLogYn");
	String cmd = (String)request.getParameter("cmd");

	if("selectYearEtcMgr".equals(cmd)) {
		//연말정산 기타소득 조회

		Map mp = StringUtil.getRequestMap(request);
		mp.put("ssnEnterCd", ssnEnterCd);
		mp.put("ssnSabun", ssnSabun);
		mp.put("cmd", cmd);
		List listData  = new ArrayList();
		String message = "";
		String code = "1";

		try {
			listData = selectYearEtcMgr(mp, locPath, ssnYeaLogYn);
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

	} else if("saveYearEtcMgr".equals(cmd)) {
		//연말정산 기타소득 저장

		Map mp = StringUtil.getRequestMap(request);
		mp.put("ssnEnterCd", ssnEnterCd);
		mp.put("ssnSabun", ssnSabun);
		mp.put("cmd", cmd);

		String message = "";
		String code = "1";

		try {
			int cnt = saveYearEtcMgr(mp, locPath, ssnYeaLogYn);

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
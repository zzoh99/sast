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
//소득공제서 대상자 조회
public List selectIncomeDeductionStList(Map paramMap, String locPath, String ssnYeaLogYn) throws Exception {

	//파라메터 복사.
	Map pm =  StringUtil.getParamMapData(paramMap);
	//xml 파서를 이용한 방법;
	Map queryMap = XmlQueryParser.getQueryMap(locPath);
	List listData = null;

	try{
		//쿼리 실행및 결과 받기.
		if(pm.get("searchPage") != null && !"".equals(pm.get("searchPage").toString()) ) {

			int divPage = pm.get("searchDivPage") == null ? 100 : Integer.valueOf(pm.get("searchDivPage").toString());
			int page = Integer.valueOf(pm.get("searchPage").toString());
			int stNum = (page -1) * divPage + 1;
			int edNum = page * divPage;

			pm.put("stNum", stNum+"");
			pm.put("edNum", edNum+"");

			listData = (queryMap == null) ? null : DBConn.executeQueryList(queryMap,"selectIncomeDeduPaging",pm);

		} else {
			listData  = (queryMap == null) ? null : DBConn.executeQueryList(queryMap,"selectIncomeDeductionStList",pm);
		}
		saveLog(null, pm, ssnYeaLogYn);
	} catch (Exception e) {
		Log.Error("[Exception] " + e);
		throw new Exception("조회에 실패하였습니다.");
	} finally {
		queryMap = null;
	}

	return listData;
}

//pdf 조회
public Map getFileInfo(Map paramMap, String locPath) throws Exception {

	//파라메터 복사.
	Map pm =  StringUtil.getParamMapData(paramMap);
	//xml 파서를 이용한 방법;
	Map queryMap = XmlQueryParser.getQueryMap(locPath);
	Map map = null;

	try{
		//쿼리 실행및 결과 받기.
		pm  = (queryMap==null) ? null : DBConn.executeQueryMap(queryMap,"getFileInfo",pm);
	} catch (Exception e) {
		Log.Error("[Exception] " + e);
		throw new Exception("조회에 실패하였습니다.");
	} finally {
		queryMap = null;
	}

	return pm;
}
public Map selecIncomeDeduTotCnt(Map paramMap, String locPath) throws Exception {

	//파라메터 복사.
	Map pm =  StringUtil.getParamMapData(paramMap);
	//xml 파서를 이용한 방법;
	Map queryMap = XmlQueryParser.getQueryMap(locPath);
	Map map = null;

	try{
		//쿼리 실행및 결과 받기.
		map  = (queryMap==null) ? null : DBConn.executeQueryMap(queryMap,"selecIncomeDeduTotCnt",pm);
	} catch (Exception e) {
		Log.Error("[Exception] " + e);
		throw new Exception("조회에 실패하였습니다.");
	} finally {
		queryMap = null;
	}

	return map;
}
//소득세액공제신고서 저장
public int saveIncomeDeductionStList(Map paramMap, String locPath, String ssnYeaLogYn) throws Exception {

	  //파라메터 맵안에는 배열형태로 저장되어 있으니 다시 리스트형태로 뽑아서 루프를 돈다.
	  List list = StringUtil.getParamListData(paramMap);
	  //xml 파서를 이용한 방법;
	  Map queryMap = XmlQueryParser.getQueryMap(locPath);
	  //사용자가 직접 트렌젝션 관리하기 위해 커넥션 가져오기.
	  Connection conn = DBConn.getConnection();
	  int rstCnt = 0;

	  if(list != null && list.size() > 0 && conn != null) {

	      //사용자가 직접 트랜젝션 관리
	      conn.setAutoCommit(false);

	      try{
	    	  String searchWorkYy = "";
	    	  String searchAdjustType = "";

	          for(int i = 0; i < list.size(); i++ ) {

	              Map mp = (Map)list.get(i);
	              String sStatus = (String)mp.get("sStatus");
	              Map mp2 = (Map)list.get(0);
	              String menuNm = (String)mp2.get("menuNm");
	              mp.put("menuNm", menuNm);
	              if((String)mp.get("searchWorkYy") != null){
	            	  searchWorkYy = (String)mp.get("searchWorkYy");
	              }
	              if((String)mp.get("searchAdjustType") != null){
	            	  searchAdjustType = (String)mp.get("searchAdjustType");
	              }

	              mp.put("searchWorkYy", searchWorkYy);
	              mp.put("searchAdjustType", searchAdjustType);

	              if("I".equals(sStatus) || "U".equals(sStatus) ) {
	                //수정
	                  rstCnt += DBConn.executeUpdate(conn, queryMap, "saveIncomeDeductionStList", mp);
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

	  return rstCnt;
	}

//소득세액공제신고서 초기화
public int saveIncomeDeductionStInit(Map paramMap, String locPath, String ssnYeaLogYn) throws Exception {

	  //파라메터 맵안에는 배열형태로 저장되어 있으니 다시 리스트형태로 뽑아서 루프를 돈다.
	  List list = StringUtil.getParamListData(paramMap);
	  //xml 파서를 이용한 방법;
	  Map queryMap = XmlQueryParser.getQueryMap(locPath);
	  //사용자가 직접 트렌젝션 관리하기 위해 커넥션 가져오기.
	  Connection conn = DBConn.getConnection();
	  int rstCnt = 0;

	  if(list != null && list.size() > 0 && conn != null) {

	      //사용자가 직접 트랜젝션 관리
	      conn.setAutoCommit(false);

	      try{
	    	  String searchWorkYy = "";
	    	  String searchAdjustType = "";

	          for(int i = 0; i < list.size(); i++ ) {

	              Map mp = (Map)list.get(i);
	              String sStatus = (String)mp.get("sStatus");
	              
	              Map mp2 = (Map)list.get(0);
	              String menuNm = (String)mp2.get("menuNm");
	              mp.put("menuNm", menuNm);
	              if((String)mp.get("searchWorkYy") != null){
	            	  searchWorkYy = (String)mp.get("searchWorkYy");
	              }
	              if((String)mp.get("searchAdjustType") != null){
	            	  searchAdjustType = (String)mp.get("searchAdjustType");
	              }
					
	              mp.put("searchWorkYy", searchWorkYy);
	              mp.put("searchAdjustType", searchAdjustType);
	              
	              mp.put("init", StringUtil.nvl((String)mp.get("init")).replace("'", "\""));
	              mp.put("file_link", StringUtil.nvl((String)mp.get("file_link")).replace("'", "\""));

	              if("I".equals(sStatus) || "U".equals(sStatus) ) {
	                //수정
	                  rstCnt += DBConn.executeUpdate(conn, queryMap, "saveIncomeDeductionStInit", mp);
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

	  return rstCnt;
	}

%>

<%
	String locPath = xmlPath+"/incomeDeductionSta/incomeDeductionSta.xml";

	String ssnEnterCd = (String)session.getAttribute("ssnEnterCd");
	String ssnSabun = (String)session.getAttribute("ssnSabun");
	String ssnYeaLogYn = (String)session.getAttribute("ssnYeaLogYn");
	String cmd = (String)request.getParameter("cmd");

	if("selectIncomeDeductionStList".equals(cmd)) {
		//원천징수부 대상자 조회

		Map mp = StringUtil.getRequestMap(request);
		mp.put("ssnEnterCd", ssnEnterCd);
		mp.put("ssnSabun", ssnSabun);
		mp.put("cmd", cmd);
		List listData  = new ArrayList();
		String message = "";
		String code = "1";

		try {
			listData = selectIncomeDeductionStList(mp, locPath, ssnYeaLogYn);
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

	} else 	if("getFileInfo".equals(cmd)) {
		//원천징수부 업로드시 사원정보 조회

		Map mp = StringUtil.getRequestMap(request);
		mp.put("ssnEnterCd", ssnEnterCd);
		mp.put("ssnSabun", ssnSabun);

		Map mapData  = new HashMap();
		String message = "";
		String code = "1";

		try {
			mapData = getFileInfo(mp, locPath);
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

	}else if("selecIncomeDeduTotCnt".equals(cmd)) {

		Map mp = StringUtil.getRequestMap(request);
		mp.put("ssnEnterCd", ssnEnterCd);
		mp.put("ssnSabun", ssnSabun);

		Map mapData  = new HashMap();
		String message = "";
		String code = "1";

		try {
			mapData = selecIncomeDeduTotCnt(mp, locPath);
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

	}else if("saveIncomeDeductionStList".equals(cmd)) {
		//소득세액공제신고서 저장
        Map mp = StringUtil.getRequestMap(request);
        mp.put("ssnEnterCd", ssnEnterCd);
        mp.put("ssnSabun", ssnSabun);

        String message = "";
        String code = "1";

        try {
            int cnt = saveIncomeDeductionStList(mp, locPath, ssnYeaLogYn);

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
        
	}else if("saveIncomeDeductionStInit".equals(cmd)) {
		//소득세액공제신고서 초기화
        Map mp = StringUtil.getRequestMap(request);
        mp.put("ssnEnterCd", ssnEnterCd);
        mp.put("ssnSabun", ssnSabun);

        String message = "";
        String code = "1";

        try {
            int cnt = saveIncomeDeductionStInit(mp, locPath, ssnYeaLogYn);

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
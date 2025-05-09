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

//신용카드 내역 조회
public List selectCardHisMgrList(Map paramMap, String locPath, String ssnYeaLogYn) throws Exception {

	//파라메터 복사.
	Map pm =  StringUtil.getParamMapData(paramMap);
	Map queryMap = XmlQueryParser.getQueryMap(locPath);
	List listData = null;

// 	String searchPeriodType = String.valueOf(pm.get("searchPeriodType"));

// 	StringBuffer query   = new StringBuffer();
// 	query.setLength(0);

// 	if(searchPeriodType.trim().length() != 0){
// 		query.append(" AND PERIOD_TYPE = #searchPeriodType#");
// 	}

// 	pm.put("query", query.toString());
	try{
		//쿼리 실행및 결과 받기.
		listData  = (queryMap == null) ? null : DBConn.executeQueryList(queryMap,"selectCardHisMgrList",pm);
		saveLog(null, pm, ssnYeaLogYn);
	} catch (Exception e) {
		Log.Error("[Exception] " + e);
		throw new Exception("조회에 실패하였습니다.");
	} finally {
		queryMap = null;
	}

	return listData;
}

//공통코드(신용카드구분)
public List selectYeaDataCardCardType(Map paramMap, String locPath) throws Exception {

  //파라메터 복사.
  Map pm =  StringUtil.getParamMapData(paramMap);
  Map queryMap = XmlQueryParser.getQueryMap(locPath);
  List listData = null;

  try{
      //쿼리 실행및 결과 받기.
      listData  = (queryMap == null) ? null : DBConn.executeQueryList(queryMap,"selectYeaDataCardCardType",pm);
  } catch (Exception e) {
      Log.Error("[Exception] " + e);
      throw new Exception("조회에 실패하였습니다.");
  } finally {
	  queryMap = null;
  }

  return listData;
}
//임직원메뉴오픈
public Map getYeaBpCardLoad(Map paramMap, String locPath, String ssnYeaLogYn) throws Exception {

 //파라메터 복사.
 Map pm =  StringUtil.getParamMapData(paramMap);
 Map mp = null;
 Map queryMap = XmlQueryParser.getQueryMap(locPath);

 try{
     //쿼리 실행및 결과 받기.
     mp  = (queryMap==null) ? null : DBConn.executeQueryMap(queryMap,"getYeaBpCardLoad",pm);
     saveLog(null, pm, ssnYeaLogYn);
 } catch (Exception e) {
     Log.Error("[Exception] " + e);
     throw new Exception("조회에 실패하였습니다.");
 } finally {
     queryMap = null;
 }

 return mp;
}

//신용카드구분
public List selectDataCardType(Map paramMap, String locPath) throws Exception {

  //파라메터 복사.
  Map pm =  StringUtil.getParamMapData(paramMap);
  List listData = null;
  Map queryMap = XmlQueryParser.getQueryMap(locPath);

  try{
      //쿼리 실행및 결과 받기.
      listData  = (queryMap == null) ? null : DBConn.executeQueryList(queryMap,"selectDataCardType",pm);
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
    String locPath = xmlPath+"/cardHisMgr/cardHisMgr.xml";

	String ssnEnterCd = (String)session.getAttribute("ssnEnterCd");
	String ssnSabun = (String)session.getAttribute("ssnSabun");
	String ssnYeaLogYn = (String)session.getAttribute("ssnYeaLogYn");
	String cmd = (String)request.getParameter("cmd");

	if("selectCardHisMgrList".equals(cmd)) {
		//신용카드 내역 조회

		Map mp = StringUtil.getRequestMap(request);
		mp.put("ssnEnterCd", ssnEnterCd);
		mp.put("ssnSabun", ssnSabun);
		mp.put("cmd", cmd);
		List listData  = new ArrayList();
		String message = "";
		String code = "1";

		try {
			listData = selectCardHisMgrList(mp, locPath, ssnYeaLogYn);
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

	} else if("saveCardHisMgr".equals(cmd)) {
		//신용카드 내역 저장

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
				String seq = (String)data.get("seq");
				String famres = (String)data.get("famres");
				String cardType = (String)data.get("card_type");
				String applMon = (String)data.get("appl_mon");
				String adjInputType = (String)data.get("adj_input_type");
				String ntsYn = (String)data.get("nts_yn");
				String feedbackType = (String)data.get("feedback_type");
				String halfGubun = (String)data.get("half_gubun");
				String docSeq = (String)data.get("doc_seq");
				String docSeqDetail = (String)data.get("doc_seq_detail");
				String cardEnterNm = (String)data.get("card_enter_nm");
				String useYyyy = (String)data.get("use_yyyy");

				String[] type =  new String[]{"OUT","OUT","STR","STR","STR"
						,"STR","STR","STR","STR","STR"
						,"STR","STR","STR","STR","STR"
						,"STR","STR","STR","STR","STR"};
				String[] param = new String[]{"","",sStatus,ssnEnterCd,workYy
						,adjustType,sabun,seq,famres,cardType
						,applMon,adjInputType,ntsYn,feedbackType,ssnSabun
						,halfGubun,cardEnterNm,useYyyy,docSeq,docSeqDetail};

				String[] rstStr = DBConn.executeProcedure("PKG_CPN_YEA_"+workYy+"_SYNC.CARDS_INS",type,param);

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
	} else if("selectYeaDataCardCardType".equals(cmd)) {
        //공통코드(신용카드구분)
        Map mp = StringUtil.getRequestMap(request);
        mp.put("ssnEnterCd", ssnEnterCd);
        mp.put("ssnSabun", ssnSabun);

        List listData  = new ArrayList();
        String message = "";
        String code = "1";

        try {
            listData = selectYeaDataCardCardType(mp, locPath);
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

    } else if("getYeaBpCardLoad".equals(cmd)) {
        //20년사업관련비용불러오기

        Map mp = StringUtil.getRequestMap(request);
        mp.put("ssnEnterCd", ssnEnterCd);
        mp.put("ssnSabun", ssnSabun);
        mp.put("cmd", cmd);
        Map mapData  = new HashMap();
        String message = "";
        String code = "1";

        try {
            mapData = getYeaBpCardLoad(mp, locPath, ssnYeaLogYn);
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

    }else if("prcYeaBpCardLoad".equals(cmd)) {
        //연말정산결과 급여반영

        Map paramMap = StringUtil.getRequestMap(request);
        Map mp =  StringUtil.getParamMapData(paramMap);

        String workYy     = (String)mp.get("searchYear");
        String adjustType = (String)mp.get("searchAdjustType");
        String bizPlaceCd = (String)mp.get("searchBizPlaceCd");
        
        String[] type =  new String[]{"OUT","OUT","STR","STR","STR","STR","STR"};
        String[] param = new String[]{"","",ssnEnterCd,workYy,adjustType,bizPlaceCd,ssnSabun};

        String message = "";
        String code = "1";
        int cnt = 0;

        try {

            String[] rstStr = DBConn.executeProcedure("P_YEA_BP_CARD_LOAD",type,param);
            
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

    } else if("selectDataCardType".equals(cmd)) {
        //신용카드구분
        Map mp = StringUtil.getRequestMap(request);
        mp.put("ssnEnterCd", ssnEnterCd);
        mp.put("ssnSabun", ssnSabun);
        mp.put("cmd", cmd);
        List listData  = new ArrayList();
        String message = "";
        String code = "1";

        try {
            listData = selectDataCardType(mp, locPath);
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
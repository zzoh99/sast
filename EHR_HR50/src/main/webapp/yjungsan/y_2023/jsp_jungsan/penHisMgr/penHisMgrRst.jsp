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

//개인연금등 내역 조회
public List selectPenHisMgrList(Map paramMap, String locPath, String ssnYeaLogYn) throws Exception {

	//파라메터 복사.
	Map pm =  StringUtil.getParamMapData(paramMap);
	//xml 파서를 이용한 방법;
	Map queryMap = XmlQueryParser.getQueryMap(locPath);
	List listData = null;

	try{
		//쿼리 실행및 결과 받기.
		listData  = (queryMap == null) ? null : DBConn.executeQueryList(queryMap,"selectPenHisMgrList",pm);
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
	String locPath = xmlPath+"/penHisMgr/penHisMgr.xml";

	String ssnEnterCd = (String)session.getAttribute("ssnEnterCd");
	String ssnSabun = (String)session.getAttribute("ssnSabun");
	String ssnYeaLogYn = (String)session.getAttribute("ssnYeaLogYn");
	String cmd = (String)request.getParameter("cmd");

	if("selectPenHisMgrList".equals(cmd)) {
		//개인연금등 내역 조회

		Map mp = StringUtil.getRequestMap(request);
		mp.put("ssnEnterCd", ssnEnterCd);
		mp.put("ssnSabun", ssnSabun);
		mp.put("cmd", cmd);
		List listData  = new ArrayList();
		String message = "";
		String code = "1";

		try {
			listData = selectPenHisMgrList(mp, locPath, ssnYeaLogYn);
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

	} else if("savePenHisMgr".equals(cmd)) {
		//개인연금등 내역 저장

		Map paramMap = StringUtil.getRequestMap(request);
		paramMap.put("ssnEnterCd", ssnEnterCd);
		paramMap.put("ssnSabun", ssnSabun);

		List listMap = StringUtil.getParamListData(paramMap);

	    String[] type   = null ;
	    String[] param  = null ;
	    String[] rstStr = null ;

	    String message = "";
		String code = "1";
		int cnt = 0;

		try {
			if(listMap != null && listMap.size() > 0) {
				for(int i = 0; i < listMap.size(); i++) {
					Map data = (Map)listMap.get(i);

					String sStatus = (String)data.get("sStatus");
					String workYy = (String)data.get("work_yy");
					String adjustType = (String)data.get("adjust_type");
					String sabun = (String)data.get("sabun");
					String savingDeductType = (String)data.get("saving_deduct_type");
					String financeOrgCd = (String)data.get("finance_org_cd");
					String accountNo = (String)data.get("account_no");
					String applMon = (String)data.get("appl_mon");
					String applMonIsa  = (String)data.get("appl_mon_isa");
					String adjInputType = (String)data.get("adj_input_type");
					//String ntsYn = (String)data.get("nts_yn");
					String feedbackType = (String)data.get("feedback_type");
					String retPenType = (String)data.get("ret_pen_type");
					String docSeq = (String)data.get("doc_seq");
					String docSeqDetail = (String)data.get("doc_seq_detail");
					String regDt = (String)data.get("reg_dt");
					//String mthPer = (String)mp.get("mth_per"); //2022 청년형 장기잡합투자증권저축 소득공제용으로 mth_per(가입개월수)항목 사용시 주석해제

					type =  new String[]{"OUT","OUT","STR","STR","STR"
	                        ,"STR","STR","STR","STR","STR","STR","STR"
	                        ,"STR","STR","STR","STR","STR","STR","STR","STR"};// 2022 청년형 장기잡합투자증권저축 소득공제용으로 mth_per(가입개월수)항목 추가로 파라미터 갯수 증가
					param = new String[]{"","",sStatus,ssnEnterCd,workYy
	                        ,adjustType,sabun,savingDeductType,retPenType,financeOrgCd,accountNo,applMon
	                        ,applMonIsa,adjInputType,feedbackType,ssnSabun,regDt,docSeq,docSeqDetail,""};// 2022 청년형 장기잡합투자증권저축 소득공제용으로 mth_per(가입개월수)항목 추가로 파라미터 갯수 증가 
					rstStr = DBConn.executeProcedure("PKG_CPN_YEA_"+workYy+"_SYNC.PENSION_INS",type,param); 

					if(rstStr[1] != null && rstStr[1].length() > 0) {
						message = rstStr[1]+"\n";
					}
					cnt++;
				}
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
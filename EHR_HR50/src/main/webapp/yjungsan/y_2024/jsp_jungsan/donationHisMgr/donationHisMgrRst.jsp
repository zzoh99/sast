<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="yjungsan.util.*"%>
<%@ page import="yjungsan.exception.*"%>

<%@ page import="java.util.List"%>
<%@ page import="java.util.ArrayList"%>
<%@ page import="java.util.Map"%>
<%@ page import="java.util.HashMap"%>

<%@ page import="com.hr.common.logger.Log" %>
<%@ include file="../common/include/session.jsp"%>
<%@ include file="../auth/saveLog.jsp"%>
<%!
//기부금 내역 조회
public List selectDonationHisMgrList(Map paramMap, String locPath, String ssnYeaLogYn) throws Exception {

	//파라메터 복사.
	Map pm =  StringUtil.getParamMapData(paramMap);
	//xml 파서를 이용한 방법;
	Map queryMap = XmlQueryParser.getQueryMap(locPath);
	List listData = null;

	try{
		//쿼리 실행및 결과 받기.
		listData  = (queryMap == null) ? null : DBConn.executeQueryList(queryMap,"selectDonationHisMgrList",pm);
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
	String locPath = xmlPath+"/donationHisMgr/donationHisMgr.xml";

	String ssnEnterCd = (String)session.getAttribute("ssnEnterCd");
	String ssnSabun = (String)session.getAttribute("ssnSabun");
	String ssnYeaLogYn = (String)session.getAttribute("ssnYeaLogYn");
	String cmd = (String)request.getParameter("cmd");

	if("selectDonationHisMgrList".equals(cmd)) {
		//기부금 내역 조회

		Map mp = StringUtil.getRequestMap(request);
		mp.put("ssnEnterCd", ssnEnterCd);
		mp.put("ssnSabun", ssnSabun);
		mp.put("cmd", cmd);
		List listData  = new ArrayList();
		String message = "";
		String code = "1";

		try {
			listData = selectDonationHisMgrList(mp, locPath, ssnYeaLogYn);
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

	} else if("saveDonationHisMgr".equals(cmd)) {
		//기부금 내역 저장

		Map paramMap = StringUtil.getRequestMap(request);
		paramMap.put("ssnEnterCd", ssnEnterCd);
		paramMap.put("ssnSabun", ssnSabun);

		List listMap = StringUtil.getParamListData(paramMap);

		String message = "";
		String code = "1";
		int cnt = 0;

		//xml 파서를 이용한 방법;
		Map queryMap = XmlQueryParser.getQueryMap(locPath);
		
		try {

			for(int i = 0; i < listMap.size(); i++) {
				Map data = (Map)listMap.get(i);

				String sStatus = (String)data.get("sStatus");
				
				/* 주석 처리) 동일 기부처에서 여러번 자료를 받아서 N건으로 수기 등록할 수 있기 때문에
				if("I".equals(sStatus) || "U".equals(sStatus) ) { // 입력,수정일 경우는 중복값 사전 체크 20241205
					String errMsg = "";
					Map dupMap = DBConn.executeQueryMap(queryMap,"chkValidDup",data);

					if(dupMap != null && Integer.parseInt((String)dupMap.get("cnt")) > 0 ) {

						// 기부금종류 코드명 추출
						Map grcdPmap = new HashMap<String, String>();
						grcdPmap.put("ssnEnterCd", ssnEnterCd);
						grcdPmap.put("grCd", "C00307");
						grcdPmap.put("code", String.valueOf(data.get("contribution_cd")));
						grcdPmap.put("searchYear", String.valueOf(data.get("work_yy")));
						Map contributionMap = DBConn.executeQueryMap(queryMap,"getCommonCodeNm",grcdPmap);
						
						errMsg = "\n - 사번 : " + String.valueOf(data.get("sabun")) 
					           + "\n - 기부자주민번호 : " + String.valueOf(data.get("famres"))
					           + "\n - 상호(법인명) : " + String.valueOf(data.get("firm_nm"))
					           + "\n - 기부금종류 : " + String.valueOf(contributionMap.get("code_nm"))
					           + "\n - 기부금액(전체) : " + String.valueOf(data.get("sum_mon"))
						       ;

						throw new UserException("중복된 기부금 자료가 " + dupMap.get("cnt") + "건 이상 존재합니다.\n조정 후 다시 진행하십시오." + errMsg);
					}
				} */

				String workYy = (String)data.get("work_yy");
				String adjustType = (String)data.get("adjust_type");
				String sabun = (String)data.get("sabun");
				String seq = (String)data.get("seq");
				String famres = (String)data.get("famres");
				String enterNo = (String)data.get("enter_no");
				String firmNm = (String)data.get("firm_nm");
				String contributionCd = (String)data.get("contribution_cd");
				String applCnt = (String)data.get("appl_cnt");
				String applMon = (String)data.get("appl_mon");
				String adjInputType = (String)data.get("adj_input_type");
				String ntsYn = (String)data.get("nts_yn");
				String feedbackType = (String)data.get("feedback_type");
				String docSeq = (String)data.get("doc_seq");
				String docSeqDetail = (String)data.get("doc_seq_detail");
				String contributionSupMon = (String)data.get("contribution_sup_mon");
				String sumMon = (String)data.get("sum_mon");
				String donationType = (String)data.get("donation_type");


				String[] type =  new String[]{"OUT","OUT","STR","STR","STR"
						,"STR","STR","STR","STR","STR"
						,"STR","STR","STR","STR","STR"
						,"STR","STR","STR","STR","STR","STR","STR","STR"};
				String[] param = new String[]{"","",sStatus,ssnEnterCd,workYy
						,adjustType,sabun,seq,famres,enterNo
						,firmNm,contributionCd,applCnt,applMon,adjInputType
						,ntsYn,feedbackType,ssnSabun,contributionSupMon,sumMon,docSeq,docSeqDetail,donationType};

				String[] rstStr = DBConn.executeProcedure("PKG_CPN_YEA_"+workYy+"_SYNC.DONATION_INS",type,param);

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

		} catch(UserException e) {
			Log.Error("[Exception] " + e);
			code = "-1";
			message = e.getMessage();
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
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
//의료비 내역 조회
public List selectMedHisMgrList(Map paramMap, String locPath, String ssnYeaLogYn) throws Exception {

	//파라메터 복사.
	Map pm =  StringUtil.getParamMapData(paramMap);
	//xml 파서를 이용한 방법;
	Map queryMap = XmlQueryParser.getQueryMap(locPath);
	List listData = null;

	try{
		//쿼리 실행및 결과 받기.
		listData  = (queryMap == null) ? null : DBConn.executeQueryList(queryMap,"selectMedHisMgrList",pm);
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
	String locPath = xmlPath+"/medHisMgr/medHisMgr.xml";

	String ssnEnterCd = (String)session.getAttribute("ssnEnterCd");
	String ssnSabun = (String)session.getAttribute("ssnSabun");
	String ssnYeaLogYn = (String)session.getAttribute("ssnYeaLogYn");
	String cmd = (String)request.getParameter("cmd");

	if("selectMedHisMgrList".equals(cmd)) {
		//의료비 내역 조회

		Map mp = StringUtil.getRequestMap(request);
		mp.put("ssnEnterCd", ssnEnterCd);
		mp.put("ssnSabun", ssnSabun);
		mp.put("cmd", cmd);
		List listData  = new ArrayList();
		String message = "";
		String code = "1";

		try {
			listData = selectMedHisMgrList(mp, locPath, ssnYeaLogYn);
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

	} else if("saveMedHisMgr".equals(cmd)) {
		//개인연금등 내역 저장

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

				/* 주석 처리) 동일 의료기관에서 동일 치료를 여러번 받아서 N건으로 수기 등록할 수 있기 때문에
				if("I".equals(sStatus) || "U".equals(sStatus) ) { // 입력,수정일 경우는 중복값 사전 체크 20241205
					String errMsg = "";
					Map dupMap = DBConn.executeQueryMap(queryMap,"chkValidDup",data);

					if(dupMap != null && Integer.parseInt((String)dupMap.get("cnt")) > 0 ) {

						// 구분 코드명 추출
						Map grcdPmap = new HashMap<String, String>();
						grcdPmap.put("ssnEnterCd", ssnEnterCd);
						grcdPmap.put("grCd", "C00337");
						grcdPmap.put("code", String.valueOf(data.get("special_yn")));
						grcdPmap.put("searchYear", String.valueOf(data.get("work_yy")));
						Map cdNmMap1 = DBConn.executeQueryMap(queryMap,"getCommonCodeNm",grcdPmap);
						
						// 의료비증빙코드 코드명 추출
						grcdPmap.put("grCd", "C00308");
						grcdPmap.put("code", String.valueOf(data.get("medical_imp_cd")));
						Map cdNmMap2 = DBConn.executeQueryMap(queryMap,"getCommonCodeNm",grcdPmap);
						
						// 상세구분 코드명 추출
						grcdPmap.put("grCd", "C00340");
						grcdPmap.put("code", String.valueOf(data.get("restrict_cd")));
						Map cdNmMap3 = DBConn.executeQueryMap(queryMap,"getCommonCodeNm",grcdPmap);
						
						errMsg = "\n - 사번 : "        + String.valueOf(data.get("sabun")) 
				               + "\n - 명의인주민번호 : " + String.valueOf(data.get("famres"))
					           + "\n - 구분 : "        + String.valueOf(cdNmMap1.get("code_nm"))
					           + "\n - 의료비증빙코드 : " + String.valueOf(cdNmMap2.get("code_nm"))
					           + "\n - 상세구분 : "     + String.valueOf(cdNmMap3.get("code_nm"))
					           + "\n - 사업자번호 : "    + String.valueOf(data.get("enter_no"))
					           + "\n - 상호 : "        + String.valueOf(data.get("firm_nm"))
					           + "\n - 금액 : "        + String.valueOf(data.get("appl_mon"))
						       ;

						throw new UserException("중복된 의료비 자료가 " + dupMap.get("cnt") + "건 이상 존재합니다.\n조정 후 다시 진행하십시오." + errMsg);
					}
				} */

				String workYy = (String)data.get("work_yy");

				String adjust_type = (String)data.get("adjust_type");
				String sabun = (String)data.get("sabun");
				String seq = (String)data.get("seq");
				String ymd = (String)data.get("ymd");
				String famres = (String)data.get("famres");
				String adj_fam_cd = (String)data.get("adj_fam_cd");
				String special_yn = (String)data.get("special_yn");
				String medical_imp_cd = (String)data.get("medical_imp_cd");
				String medical_type = (String)data.get("medical_type");
				String enter_no = (String)data.get("enter_no");
				String firm_nm = (String)data.get("firm_nm");
				String sCnt = (String)data.get("cnt");
				String appl_mon = (String)data.get("appl_mon");
				String adj_input_type = (String)data.get("adj_input_type");
				String nts_yn = (String)data.get("nts_yn");
				String restrict_cd = (String)data.get("restrict_cd");
				String feedback_type = (String)data.get("feedback_type");
				String preBabyYn     = (String)data.get("pre_baby_yn");
				String nanim_yn = (String)data.get("nanim_yn");
				String docSeq = (String)data.get("doc_seq");
				String docSeqDetail = (String)data.get("doc_seq_detail");

				String[] type =  new String[]{"OUT","OUT","STR","STR","STR"
						,"STR","STR","STR","STR","STR"
						,"STR","STR","STR","STR","STR"
						,"STR","STR","STR","STR","STR","STR"
						,"STR","STR","STR","STR","STR","STR"};
				String[] param = new String[]{"","",sStatus,ssnEnterCd,workYy
						,adjust_type,sabun,seq,ymd,famres
						,adj_fam_cd,special_yn,medical_imp_cd,medical_type,enter_no
						,firm_nm,sCnt,appl_mon,adj_input_type,nts_yn,restrict_cd
						,feedback_type,preBabyYn,nanim_yn,ssnSabun,docSeq,docSeqDetail};

				String[] rstStr = DBConn.executeProcedure("PKG_CPN_YEA_"+yeaYear+"_SYNC.MEDICAL_INS",type,param);

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
	}
%>
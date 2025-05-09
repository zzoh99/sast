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
<%@ include file="../auth/saveLog.jsp"%>
<%!
//private Logger log = Logger.getLogger(this.getClass());

//주택자금 공제구분코드 조회
public List selectHouseDecCdList(Map paramMap, String locPath) throws Exception {

	//파라메터 복사.
	Map pm =  StringUtil.getParamMapData(paramMap);
	//xml 파서를 이용한 방법;
	Map queryMap = XmlQueryParser.getQueryMap(locPath);
	List listData = null;

	try{
		//쿼리 실행및 결과 받기.
		listData  = (queryMap == null) ? null : DBConn.executeQueryList(queryMap,"selectHouseDecCdList",pm);
	} catch (Exception e) {
		Log.Error("[Exception] " + e);
		throw new Exception("조회에 실패하였습니다.");
	} finally {
		queryMap = null;
	}

	return listData;
}


//주택자금 자료 조회
public List selectYeaDataHouList(Map paramMap, String locPath, String ssnYeaLogYn) throws Exception {

	//파라메터 복사.
	Map pm =  StringUtil.getParamMapData(paramMap);
	//xml 파서를 이용한 방법;
	Map queryMap = XmlQueryParser.getQueryMap(locPath);
	List listData = null;

	try{
		//쿼리 실행및 결과 받기.
		listData  = (queryMap == null) ? null : DBConn.executeQueryList(queryMap,"selectYeaDataHouList",pm);
		saveLog(null, pm, ssnYeaLogYn);
	} catch (Exception e) {
		Log.Error("[Exception] " + e);
		throw new Exception("조회에 실패하였습니다.");
	} finally {
		queryMap = null;
	}

	return listData;
}



//pdf 파일 상세 저장.
public int saveYeaDataPdf(Map paramMap, String orgAuthPg, String locPath) throws Exception {

	//사용자가 직접 트렌젝션 관리하기 위해 커넥션 가져오기.
	Connection conn = DBConn.getConnection();
	int rstCnt = 0;
	//xml 파서를 이용한 방법;
	Map queryMap = XmlQueryParser.getQueryMap(locPath);

	//권한에 따른 반영제외자 체크 ( 10(본인반영제외) / 20(담당자반영제외))
	String exceptCheck = "";
	if( "A".equals(orgAuthPg) ) {
		exceptCheck = "20";
	} else {
		exceptCheck = "10";
	}

	if (conn != null) {
		//사용자가 직접 트랜젝션 관리
		conn.setAutoCommit(false);

		try{
			Map mp = paramMap ;
			mp.put("exceptCheck", exceptCheck);
			//System.out.println( paramMap ) ;
			rstCnt += DBConn.executeUpdate(conn, queryMap, "updateYeaDataPdf", paramMap);

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
	String locPath = xmlPath+"/yeaData/yeaDataHou.xml";

	String ssnEnterCd = (String)session.getAttribute("ssnEnterCd");
	String ssnSabun = (String)session.getAttribute("ssnSabun");
	String ssnYeaLogYn = (String)session.getAttribute("ssnYeaLogYn");
	String cmd = (String)request.getParameter("cmd");
	String codeType = (String)request.getParameter("codeType");

	if("selectHouseDecCdList".equals(cmd)) {
		//주택자금 공제구분코드 조회
		Map mp = StringUtil.getRequestMap(request);
		mp.put("ssnEnterCd", ssnEnterCd);
		mp.put("ssnSabun", ssnSabun);
		mp.put("cmd", cmd);
// 		if ( "1".equals(codeType) ) mp.put("searchCode_s", " AND CODE NOT IN ('20', '60') "); // 20 - 임차차입금원리금상환액_거주자, 60 - 월세액
// 		else if ( "2".equals(codeType) ) mp.put("searchCode_s", " AND CODE = '60' "); // 20 - 임차차입금원리금상환액_거주자, 60 - 월세액
// 		else if ( "3".equals(codeType) ) mp.put("searchCode_s", " AND CODE = '20' "); // 20 - 임차차입금원리금상환액_거주자, 60 - 월세액
// 		//else if ( "4".equals(codeType) ) mp.put("searchCode_s", " AND CODE = '20' "); // 20 - 임차차입금원리금상환액_거주자, 60 - 월세액
// 		else mp.put("searchCode_s", "");

		List listData  = new ArrayList();
		String message = "";
		String code = "1";

		try {
			listData = selectHouseDecCdList(mp, locPath);
		} catch(Exception e) {
			code = "-1";
			message = e.getMessage();
		}

		Map mapCode = new HashMap();
		mapCode.put("Code", code); //ajax 성공코드 1번, 그외 오류
		mapCode.put("Message", message);

		Map rstMap = new HashMap();
		rstMap.put("Result", mapCode);
		rstMap.put("codeList", listData == null ? null : (List)listData);

		out.print((new org.json.JSONObject(rstMap)).toString());

	} else if("selectYeaDataHouList".equals(cmd)) {
		//주택자금 자료 조회

		Map mp = StringUtil.getRequestMap(request);
		mp.put("ssnEnterCd", ssnEnterCd);
		mp.put("ssnSabun", ssnSabun);
		mp.put("cmd", cmd);
// 		if ( "1".equals(codeType) ) mp.put("searchCode_s", " AND HOUSE_DEC_CD NOT IN ('20', '60') "); // 20 - 임차차입금원리금상환액_거주자, 60 - 월세액
// 		else if ( "2".equals(codeType) ) mp.put("searchCode_s", " AND HOUSE_DEC_CD = '60' "); // 20 - 임차차입금원리금상환액_거주자, 60 - 월세액

// 		else if ( "3".equals(codeType) ) mp.put("searchCode_s", " AND HOUSE_DEC_CD = '20' "); // 20 - 임차차입금원리금상환액_거주자, 60 - 월세액

// 		/*
// 		else if ( "3".equals(codeType) ) mp.put("searchCode_s", " AND HOUSE_DEC_CD = '20' AND KEOJUZA_GUBUN = '1' "); // 20 - 임차차입금원리금상환액_거주자, 60 - 월세액
// 		else if ( "4".equals(codeType) ) mp.put("searchCode_s", " AND HOUSE_DEC_CD = '20' AND KEOJUZA_GUBUN = '2' "); // 20 - 임차차입금원리금상환액_거주자, 60 - 월세액
// 		*/

// 		else mp.put("searchCode_s", "");

		List listData  = new ArrayList();
		String message = "";
		String code = "1";

		try {
			listData = selectYeaDataHouList(mp, locPath, ssnYeaLogYn);
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

	} else if("saveYeaDataHou".equals(cmd)) {
		//주택자금 저장.

		Map paramMap = StringUtil.getRequestMap(request);
		List saveList = StringUtil.getParamListData(paramMap);

		String[] type = null ;
		String[] param = null ;
		String[] rstStr = null ;

		int cnt = 0;
		boolean pdfDelete = false ;

		String message = "";
		String code = "1";

		try {


			/*
		         P_GUBUN            IN  VARCHAR2, -- 작업구분(I:입력,U:수정,D:삭제)
		         P_ENTER_CD         IN  VARCHAR2, -- 회사코드
		         P_WORK_YY          IN  VARCHAR2, -- 대상년도
		         P_ADJUST_TYPE      IN  VARCHAR2, -- 정산구분(C00303)
		         P_SABUN            IN  VARCHAR2, -- 사원번호

		         P_HOUSE_DEC_CD     IN  VARCHAR2, -- 주택자금소득공제구분(C00344)
		         P_SEQ              IN  VARCHAR2, -- 순번
		         P_CON_S_YMD        IN  VARCHAR2, -- 계약시작일
		         P_CON_E_YMD        IN  VARCHAR2, -- 계약종료일
		         P_RENT_MON         IN  NUMBER,   -- 월세액합계

		         P_TAX_DAY          IN  NUMBER,   -- 해당과세기간임차일수
		         P_APPL_MON         IN  NUMBER,   -- 반영금액
		         P_ADJ_INPUT_TYPE   IN  VARCHAR2, -- 연말정산기초자료입력유형(C00325)
		         P_NAME_IMDAEIN     IN  VARCHAR2, -- 임대인 성명
		         P_RES_NO_IMDAEIN   IN  VARCHAR2, -- 임대인 주민등록번호

		         P_CHAIB_RATE       IN  NUMBER,   -- 차입금이자율
		         P_WONRI_MON        IN  NUMBER,   -- 금전소비대차 원리금상환액_원리금
		         P_IJA_MON          IN  NUMBER,   -- 금전소비대차 원리금상환액_이자
		         P_ADDRESS          IN  VARCHAR2, -- 주소
		         P_HOUSE_TYPE       IN  VARCHAR2, -- 주택유형

		         P_HOUSE_SIZE       IN  VARCHAR2, -- 주택계약면적
		         P_NAME_DAEJU       IN  VARCHAR2, -- 대주 성명
		         P_RES_NO_DAEJU     IN  VARCHAR2, -- 대주 주민등록번호
		         P_CON_S_YMD_IMDAE  IN  VARCHAR2, -- 임대차계약기간 계약시작일
		         P_CON_E_YMD_IMDAE  IN  VARCHAR2, -- 임대차계약기간 계약종료일

		         P_BOJEONG_MON      IN  VARCHAR2, -- 전세보증금
		         P_FEEDBACK_TYPE    IN  VARCHAR2, -- 담당자피드백(C00329)
		         P_CHKID            IN  VARCHAR2  -- 수정자

				*/

			if(saveList != null && saveList.size() > 0) {
				for(int i = 0; i < saveList.size(); i++) {
					Map mp = (Map)saveList.get(i);

					String sStatus 		= StringUtil.nvl((String)mp.get("sStatus"));
					String workYy 		= StringUtil.nvl((String)mp.get("work_yy"));
					String adjustType 	= StringUtil.nvl((String)mp.get("adjust_type"));
					String sabun 		= StringUtil.nvl((String)mp.get("sabun"));
					String houseDecCd 	= StringUtil.nvl((String)mp.get("house_dec_cd"));
					String seq 			= StringUtil.nvl((String)mp.get("seq"));

					String nameDaeju		= StringUtil.nvl((String)mp.get("name_daeju"));
					String resNoDaeju		= StringUtil.nvl((String)mp.get("res_no_daeju"));
					String conSYmd		= StringUtil.nvl((String)mp.get("con_s_ymd"));
					String conEYmd		= StringUtil.nvl((String)mp.get("con_e_ymd"));
					String chaibRate 		= StringUtil.nvl((String)mp.get("chaib_rate"));
					String wonriMon 		= StringUtil.nvl((String)mp.get("wonri_mon"));
					String ijaMon 			= StringUtil.nvl((String)mp.get("ija_mon"));
					String inputMon 		= StringUtil.nvl((String)mp.get("input_mon"));
					String applMon 		= StringUtil.nvl((String)mp.get("appl_mon"));
					String adjInputType 	= StringUtil.nvl((String)mp.get("adj_input_type"));
					//String keojuza_gubun	= StringUtil.nvl((String)mp.get("keojuza_gubun"));
					String img_imdaein		= StringUtil.nvl((String)mp.get("img_imdaein"));
					String feedbackType		= StringUtil.nvl((String)mp.get("feedback_type"));

					String nameImdaein 	= StringUtil.nvl((String)mp.get("name_imdaein"));
					String resNoImdaein 	= StringUtil.nvl((String)mp.get("res_no_imdaein")).replaceAll("-", "");
					String houseType 		= StringUtil.nvl((String)mp.get("house_type"));
					String houseSize		= StringUtil.nvl((String)mp.get("house_size"));
					String address			= StringUtil.nvl((String)mp.get("address"));
					String conSYmdImdae 	= StringUtil.nvl((String)mp.get("con_s_ymd_imdae"));
					String conEYmdImdae 	= StringUtil.nvl((String)mp.get("con_e_ymd_imdae"));
					String bojeongMon		= StringUtil.nvl((String)mp.get("bojeong_mon")).replaceAll(",", "");
					String repayYears		= StringUtil.nvl((String)mp.get("repay_years"));

					String rentMon          = StringUtil.nvl((String)mp.get("rent_mon"));
					String rentType          = StringUtil.nvl((String)mp.get("rent_type"));
					//String feedbackType     = StringUtil.nvl((String)mp.get("feedback_type"));
					String taxDay           = StringUtil.nvl((String)mp.get("tax_day"));
					String docSeq           = (String)mp.get("doc_seq");
					String docSeqDetail     = (String)mp.get("doc_seq_detail");


					String resNoImcha       = (String) mp.get("res_no_imcha");

					//삭제 시 PDF업로드 데이터 미반영 처리 Logic add by JSG 20161208..
					if( "07".equals(adjInputType) && "D".equals(sStatus) ) {

						String orgAuthPg = (String)request.getParameter("orgAuthPg");
						mp.put("ssnEnterCd", ssnEnterCd);
						mp.put("ssnSabun", ssnSabun);
						int tempCnt = saveYeaDataPdf(mp, orgAuthPg, locPath);
						cnt += tempCnt ;

						if(tempCnt > 0) pdfDelete = true ;

					} else {
						type =  new String[]{"OUT","OUT"
								,"STR","STR","STR","STR","STR"
								,"STR","STR","STR","STR","STR"
								,"STR","STR","STR","STR","STR","STR"
								,"STR","STR","STR","STR","STR"
								,"STR","STR","STR","STR","STR"
								,"STR","STR", "STR", "STR","STR","STR","STR"};

						param = new String[]{"",""
								, sStatus, ssnEnterCd, workYy , adjustType, sabun
								, houseDecCd, seq, conSYmd, conEYmd, rentMon
								, taxDay, applMon, adjInputType, resNoImcha, nameImdaein, resNoImdaein
								, chaibRate, wonriMon, ijaMon, address, houseType
								, houseSize, nameDaeju,  resNoDaeju, conSYmdImdae, conEYmdImdae
								, bojeongMon, repayYears, feedbackType, ssnSabun, docSeq, docSeqDetail, rentType};



						rstStr = DBConn.executeProcedure("PKG_CPN_YEA_"+yeaYear+"_SYNC.MTH_RENT_INS",type,param);

						if(rstStr[1] == null || rstStr[1].length() == 0) {
							cnt++;
						} else {
							message = message + "\n\n" + rstStr[1];
						}
					}
				}
				/*PDF 삭제 데이터가 존재하는 경우 작동*/
				if(pdfDelete) {
					//Map mp = StringUtil.getParamMapData(paramMap);
					Map pdfMp = StringUtil.getParamMapData(paramMap);

					String paramYear = (String)pdfMp.get("work_yy");
					String paramAdjustType = (String)pdfMp.get("adjust_type");
					String paramSabun = (String)pdfMp.get("sabun");
					String docSeq = (String)pdfMp.get("doc_seq");


					/////////////////////// DB저장 및 파일업로드가 완료되었다면 프로시저 호출 //////////////////////////
					type =  new String[]{"OUT","OUT","STR","STR","STR","STR","STR","STR"};
					param = new String[]{"","",ssnEnterCd,paramYear,paramAdjustType,paramSabun,ssnSabun,docSeq};

					rstStr = DBConn.executeProcedure("P_CPN_YEA_PDF_ERRCHK_"+paramYear,type,param);

					if(rstStr[0] != null && "1".equals(rstStr[0])) {
						message = rstStr[1];

						try {
							message = "" ;
						} catch(Exception e) {
							//message = e.getMessage();
							Log.Error("[Exception] " + e);
						}

					} else {
						message = "프로시저 실행중 오류가 발생하였습니다.\\n"+rstStr[1];
					}
				}
			}

			if(cnt > 0) {
				message = cnt+"건이 처리되었습니다." + message;
			} else {
				code = "-1";
				message = "처리된 내용이 없습니다." + message;
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
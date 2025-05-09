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

<%!
//교육비 자료 조회
public List selectYeaDataEduList(Map paramMap, String locPath) throws Exception {

	//파라메터 복사.
	Map pm =  StringUtil.getParamMapData(paramMap);
	Map queryMap = XmlQueryParser.getQueryMap(locPath);
	List listData = null;
	
	try{
		//쿼리 실행및 결과 받기.
		listData  = (queryMap == null) ? null : DBConn.executeQueryList(queryMap,"selectYeaDataEduList",pm);
	} catch (Exception e) {
		Log.Error("[Exception] " + e);
		throw new Exception("조회에 실패하였습니다.");
	}
	
	return listData;
}
//pdf 파일 상세 저장.
public int saveYeaDataPdf(Map paramMap, String orgAuthPg, String locPath) throws Exception {

	//사용자가 직접 트렌젝션 관리하기 위해 커넥션 가져오기.
	Connection conn = DBConn.getConnection();
	int rstCnt = 0;
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
		}
	}
	return rstCnt;
}
%>

<%
	String locPath = xmlPath+"/yeaData/yeaDataEdu.xml";

	String ssnEnterCd = (String)session.getAttribute("ssnEnterCd");
	String ssnSabun = (String)session.getAttribute("ssnSabun");
	String cmd = (String)request.getParameter("cmd");

	if("selectYeaDataEduList".equals(cmd)) {
		//교육비 자료 조회
		
		Map mp = StringUtil.getRequestMap(request);
		mp.put("ssnEnterCd", ssnEnterCd);
		mp.put("ssnSabun", ssnSabun);
		
		List listData  = new ArrayList();
		String message = "";
		String code = "1";
	
		try {
			listData = selectYeaDataEduList(mp, locPath);
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
		
	} else if("saveYeaDataEdu".equals(cmd)) {
		//교육비 저장.
		
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
			
			if(saveList != null && saveList.size() > 0) {
				for(int i = 0; i < saveList.size(); i++) {
					Map mp = (Map)saveList.get(i);
					String sStatus = (String)mp.get("sStatus");
					String workYy = (String)mp.get("work_yy");
					String adjustType = (String)mp.get("adjust_type");
					String sabun = (String)mp.get("sabun");
					String seq = (String)mp.get("seq");
					String famres = (String)mp.get("famres");
					String workType = (String)mp.get("work_type");
					String applMon = (String)mp.get("appl_mon");
					String adjInputType = (String)mp.get("adj_input_type");
					String ntsYn = (String)mp.get("nts_yn");
					String restrictCd = (String)mp.get("restrict_cd");
					String feedbackType = (String)mp.get("feedback_type");
					String docSeq = (String)mp.get("doc_seq");
					String docSeqDetail = (String)mp.get("doc_seq_detail");

					//삭제 시 PDF업로드 데이터 미반영 처리 Logic add by JSG 20161208..
					if( "07".equals(adjInputType) && "D".equals(sStatus) ) {
						
						String orgAuthPg = (String)request.getParameter("orgAuthPg"); 
						mp.put("ssnEnterCd", ssnEnterCd);
						mp.put("ssnSabun", ssnSabun);
						int tempCnt = saveYeaDataPdf(mp, orgAuthPg, locPath);
						cnt += tempCnt ; 
						
						if(tempCnt > 0) pdfDelete = true ;
						
					} else {
						type =  new String[]{"OUT","OUT","STR","STR","STR"
								,"STR","STR","STR","STR","STR"
								,"STR","STR","STR","STR","STR","STR","STR","STR"};
						
						param = new String[]{"","",sStatus,ssnEnterCd,workYy
								,adjustType,sabun,seq,famres,workType
								,applMon,adjInputType,ntsYn,restrictCd,feedbackType,ssnSabun,docSeq,docSeqDetail};
						
						rstStr = DBConn.executeProcedure("PKG_CPN_YEA_"+yeaYear+"_SYNC.EDUCATION_INS",type,param);
						
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
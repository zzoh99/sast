<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="yjungsan.util.*"%>
<%@ page import="yjungsan.exception.*"%>
<%@ page import="java.sql.Connection"%>
<%@ page import="java.util.List"%>
<%@ page import="java.util.ArrayList"%>
<%@ page import="java.util.Map"%>
<%@ page import="java.util.HashMap"%>
<%@ page import="java.net.URLDecoder"%>
<%@ page import="java.io.*"%>

<%@ page import="org.json.JSONObject" %>
<%@ page import="com.hr.common.logger.Log" %>
<%@ include file="../common/include/session.jsp"%>
<%@ include file="../auth/saveLog.jsp"%>
<%!

//pdf 파일 종합 조회
public List selectYeaDataPdfInfo(Map paramMap, String locPath) throws Exception {

	//파라메터 복사.
	Map pm =  StringUtil.getParamMapData(paramMap);
	//xml 파서를 이용한 방법;
	Map queryMap = XmlQueryParser.getQueryMap(locPath);
	List listData = null;

	try{
		//쿼리 실행및 결과 받기.
		listData  = DBConn.executeQueryList(queryMap,"selectYeaDataPdfInfo",pm);
	} catch (Exception e) {
		Log.Error("[Exception] " + e);
		throw new Exception("조회에 실패하였습니다.");
	} finally {
		queryMap = null;
	}

	return listData;
}

//pdf 파일 조회
public List selectYeaDataPdfList(Map paramMap, String locPath) throws Exception {

	//파라메터 복사.
	Map pm =  StringUtil.getParamMapData(paramMap);
	//xml 파서를 이용한 방법;
	Map queryMap = XmlQueryParser.getQueryMap(locPath);
	List listData = null;

	try{
		//쿼리 실행및 결과 받기.
		listData  = DBConn.executeQueryList(queryMap,"selectYeaDataPdfList",pm);
		saveLog(null, pm);
	} catch (Exception e) {
		Log.Error("[Exception] " + e);
		throw new Exception("조회에 실패하였습니다.");
	} finally {
		queryMap = null;
	}

	return listData;
}

//pdf 파일 상세 조회
public List selectYeaDataPdfDetailList(Map paramMap, String locPath) throws Exception {

	//파라메터 복사.
	Map pm =  StringUtil.getParamMapData(paramMap);
	//xml 파서를 이용한 방법;
	Map queryMap = XmlQueryParser.getQueryMap(locPath);
	List listData = null;

	try{
		//쿼리 실행및 결과 받기.
		listData  = DBConn.executeQueryList(queryMap,"selectYeaDataPdfDetailList",pm);
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

	//파라메터 맵안에는 배열형태로 저장되어 있으니 다시 리스트형태로 뽑아서 루프를 돈다.
	List list = StringUtil.getParamListData(paramMap);
	//xml 파서를 이용한 방법;
	Map queryMap = XmlQueryParser.getQueryMap(locPath);

	//사용자가 직접 트렌젝션 관리하기 위해 커넥션 가져오기.
	Connection conn = DBConn.getConnection();
	int rstCnt = 0;

	//권한에 따른 반영제외자 체크 ( 10(본인반영제외) / 20(담당자반영제외))
	String exceptCheck = "";
	if( "A".equals(orgAuthPg) ) {
		exceptCheck = "20";
	} else {
		exceptCheck = "10";
	}

	if(list != null && list.size() > 0) {

		//사용자가 직접 트랜젝션 관리
		conn.setAutoCommit(false);

		try{
			for(int i = 0; i < list.size(); i++ ) {
				String query = "";
				Map mp = (Map)list.get(i);
				String sStatus = (String)mp.get("sStatus");

				if("U".equals(sStatus)) {
					//반영제외자체크
					mp.put("exceptCheck", exceptCheck);

					//수정
					rstCnt += DBConn.executeUpdate(conn, queryMap, "updateYeaDataPdf", mp);
				}
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

//pdf 파일 상세 건수 조회
public Map selectYeaDataPdfDetailCount(Map paramMap, String locPath) throws Exception {
	//파라메터 복사.
	Map pm =  StringUtil.getParamMapData(paramMap);
	//xml 파서를 이용한 방법;
	Map queryMap = XmlQueryParser.getQueryMap(locPath);
	Map mp = null;

	try{
		//쿼리 실행및 결과 받기.
		mp  = DBConn.executeQueryMap(queryMap, "selectYeaDataPdfDetailCount", pm);
	} catch (Exception e) {
		Log.Error("[Exception] " + e);
		throw new Exception("조회에 실패하였습니다.");
	} finally {
		queryMap = null;
	}

	return mp;
}

//pdf 파일 상세 건수 조회
public Map selectYeaDataPdfFormCdCount(Map paramMap, String locPath) throws Exception {
	//파라메터 복사.
	Map pm =  StringUtil.getParamMapData(paramMap);
	//xml 파서를 이용한 방법;
	Map queryMap = XmlQueryParser.getQueryMap(locPath);
	Map mp = null;

	try{
		//쿼리 실행및 결과 받기.
		mp  = DBConn.executeQueryMap(queryMap, "selectYeaDataPdfFormCdCount", pm);
	} catch (Exception e) {
		Log.Error("[Exception] " + e);
		throw new Exception("조회에 실패하였습니다.");
	} finally {
		queryMap = null;
	}

	return mp;
}

//인적공제 인원 조회
public List selectYeaDataPdfA1(Map paramMap, String locPath) throws Exception {

	//파라메터 복사.
	Map pm =  StringUtil.getParamMapData(paramMap);
	//xml 파서를 이용한 방법;
	Map queryMap = XmlQueryParser.getQueryMap(locPath);
	List listData = null;

	try{
		//쿼리 실행및 결과 받기.
		listData  = DBConn.executeQueryList(queryMap,"selectYeaDataPdfA1",pm);
	} catch (Exception e) {
		Log.Error("[Exception] " + e);
		throw new Exception("조회에 실패하였습니다.");
	} finally {
		queryMap = null;
	}

	return listData;
}

public int deleteYeaDataPdfFile(Map paramMap, String locPath) throws Exception {

	// 파라메터 셋팅

	// 사용자가 직접 트렌젝션 관리하기 위해 커넥션 가져오기.
    Connection conn = DBConn.getConnection();
	//xml 파서를 이용한 방법;
	Map queryMap = XmlQueryParser.getQueryMap(locPath);
    int rstCnt = 0;

    try {
    	conn.setAutoCommit(false);

    	rstCnt = DBConn.executeUpdate(conn, queryMap, "deleteYeaDataPdfFile", paramMap);

    	if(rstCnt != 1) {
    		Log.Error("[File not Found!!!]");
    		throw new Exception("삭제에 실패하였습니다.");
    	} else {
    	    DBConn.executeUpdate(conn, queryMap, "deleteYeaDataPdfData", paramMap);
    	}

    	conn.commit();
    } catch( Exception e ) {
    	try {
            //롤백
            conn.rollback();
        } catch (Exception e1) {
            Log.Error("[rollback Exception] " + e);
        }
        rstCnt = 0;
        Log.Error("[Exception] " + e);
        throw new Exception("삭제에 실패하였습니다.");
    } finally {
    	DBConn.closeConnection(conn, null, null);
		queryMap = null;
    }

	return rstCnt;
}

//PDF 업로드 방식 조회 (D: 삭제후 업데이트, M: 같은 항복만 업데이트)
public List selectPdfTypeCode(Map paramMap, String locPath) throws Exception {

	//파라메터 복사.
	Map pm =  StringUtil.getParamMapData(paramMap);
	//xml 파서를 이용한 방법;
	Map queryMap = XmlQueryParser.getQueryMap(locPath);
	List listData = null;

	try{
		//쿼리 실행및 결과 받기.
		listData  = DBConn.executeQueryList(queryMap,"selectPdfTypeCode",pm);
	} catch (Exception e) {
		Log.Error("[Exception] " + e);
		throw new Exception("조회에 실패하였습니다.");
	} finally {
		queryMap = null;
	}

	return listData;
}

//PDF 업로드 방식 조회 (D: 삭제후 업데이트, M: 같은 항복만 업데이트)
public List selectBulkPdf(Map paramMap, String locPath) throws Exception {

	//파라메터 복사.
	Map pm =  StringUtil.getParamMapData(paramMap);
	//xml 파서를 이용한 방법;
	Map queryMap = XmlQueryParser.getQueryMap(locPath);
	List listData = null;
	
	Map bulkPdf = null;

	try{
		//쿼리 실행및 결과 받기.
		bulkPdf  = DBConn.executeQueryMap(queryMap,"selectBulkPdfYn",pm);
	} catch (Exception e) {
		Log.Error("[Exception] " + e);
		throw new Exception("조회에 실패하였습니다.");
	} finally {
		if (bulkPdf != null) {
			String bulkPdfYn = String.valueOf(bulkPdf.get("bulk_pdf_yn"));
			if ("Y".equals(bulkPdfYn)) {
	        	listData  = DBConn.executeQueryList(queryMap,"selectBulkPdf",pm);
	        } else listData = null;
		}
		queryMap = null;
	}

	return listData;
}
public List selectConfirmedYn(Map paramMap, String locPath) throws Exception {

	//파라메터 복사.
	Map pm =  StringUtil.getParamMapData(paramMap);
	//xml 파서를 이용한 방법;
	Map queryMap = XmlQueryParser.getQueryMap(locPath);
	List list = null;

	try{
		//쿼리 실행및 결과 받기.
		list  = DBConn.executeQueryList(queryMap,"selectConfirmedYn",pm);
	} catch (Exception e) {
		Log.Error("[Exception] " + e);
		throw new Exception("조회에 실패하였습니다.");
	} finally {
		queryMap = null;
	}

	return list;
}
%>

<%
	String locPath = xmlPath+"/yeaData/yeaDataPdf.xml";

	String ssnEnterCd = (String)session.getAttribute("ssnEnterCd");
	String ssnSabun = (String)session.getAttribute("ssnSabun");
	String cmd = (String)request.getParameter("cmd");

	if("selectYeaDataPdfList".equals(cmd)) {
		//pdf 파일 조회

		Map mp = StringUtil.getRequestMap(request);
		mp.put("ssnEnterCd", ssnEnterCd);
		mp.put("ssnSabun", ssnSabun);
		mp.put("cmd", cmd);
		List listData  = new ArrayList();
		String message = "";
		String code = "1";

		try {
			listData = selectYeaDataPdfList(mp, locPath);
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

	} else if("selectYeaDataPdfInfo".equals(cmd)) {
		//pdf 파일 조회

		Map mp = StringUtil.getRequestMap(request);
		mp.put("ssnEnterCd", ssnEnterCd);
		mp.put("ssnSabun", ssnSabun);

		List listData  = new ArrayList();
		String message = "";
		String code = "1";

		try {
			listData = selectYeaDataPdfInfo(mp, locPath);
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

	} else 	if("selectYeaDataPdfDetailList".equals(cmd)) {
		//pdf 파일 상세 조회

		Map mp = StringUtil.getRequestMap(request);
		mp.put("ssnEnterCd", ssnEnterCd);
		mp.put("ssnSabun", ssnSabun);

		List listData  = new ArrayList();
		String message = "";
		String code = "1";

		try {
			listData = selectYeaDataPdfDetailList(mp, locPath);
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

	}  else if("saveYeaDataPdf".equals(cmd)) {
		//pdf 파일 상세 저장.

		Map paramMap = StringUtil.getRequestMap(request);
		paramMap.put("ssnEnterCd", ssnEnterCd);
		paramMap.put("ssnSabun", ssnSabun);

		String message = "";
		String code = "1";

		//권한
		String orgAuthPg = (String)request.getParameter("orgAuthPg");

		try {
			int cnt = saveYeaDataPdf(paramMap, orgAuthPg, locPath);

			if( cnt > 0 ) {
				Map mp = StringUtil.getParamMapData(paramMap);
				String paramYear = (String)mp.get("work_yy");
				String paramAdjustType = (String)mp.get("adjust_type");
				String paramSabun = (String)mp.get("sabun");
				String docSeq = "";

				/////////////////////// DB저장 및 파일업로드가 완료되었다면 프로시저 호출 //////////////////////////
				String[] type =  new String[]{"OUT","OUT","STR","STR","STR","STR","STR","STR"};
				String[] param = new String[]{"","",ssnEnterCd,paramYear,paramAdjustType,paramSabun,ssnSabun,docSeq};

				String[] rstStr = DBConn.executeProcedure("P_CPN_YEA_PDF_ERRCHK_"+paramYear,type,param);

				if(rstStr[0] != null && "1".equals(rstStr[0])) {
					message = rstStr[1];

					Map mapData  = new HashMap();
					try {
						mapData = selectYeaDataPdfDetailCount(mp, locPath);
						message = "반영= "+ String.valueOf(mapData.get("status_a")) +" 건"
								+" , 미반영= "+ String.valueOf(mapData.get("status_b")) +" 건"
								+" , 반영불가= "+ String.valueOf(mapData.get("status_c")) +" 건"
								+" , 반영제외 "+ String.valueOf(mapData.get("status_d")) +" 건";
					} catch(Exception e) {
						//message = e.getMessage();
					}

				} else {
					message = "프로시저 실행중 오류가 발생하였습니다.\\n"+rstStr[1];
				}
			} else {
				code = "-1";
				message = "저장된 내용이 없습니다.";
			}

		} catch(Exception e) {
			code = "-1";
			message = "저장에 실패하였습니다.";
		}

		Map mapCode = new HashMap();
		mapCode.put("Code", code);
		mapCode.put("Message", message);

		Map rstMap = new HashMap();
		rstMap.put("Result", mapCode);

		out.print((new org.json.JSONObject(rstMap)).toString());

	} else 	if("selectYeaDataPdfDetailCount".equals(cmd)) {
		//pdf 파일 상세 건수 조회

		Map mp = StringUtil.getRequestMap(request);
		mp.put("ssnEnterCd", ssnEnterCd);
		mp.put("ssnSabun", ssnSabun);

		Map mapData  = new HashMap();
		String message = "";
		String code = "1";

		try {
			mapData = selectYeaDataPdfDetailCount(mp, locPath);
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

	} else 	if("selectYeaDataPdfFormCdCount".equals(cmd)) {
		//pdf 업로드 분류별 건수 조회

		Map mp = StringUtil.getRequestMap(request);
		mp.put("ssnEnterCd", ssnEnterCd);
		mp.put("ssnSabun", ssnSabun);

		Map mapData  = new HashMap();
		String message = "";
		String code = "1";

		try {
			mapData = selectYeaDataPdfFormCdCount(mp, locPath);
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

	} else 	if("selectYeaDataPdfA1".equals(cmd)) {
		//인적공제 인원 조회

		Map mp = StringUtil.getRequestMap(request);
		mp.put("ssnEnterCd", ssnEnterCd);
		mp.put("ssnSabun", ssnSabun);

		List listData  = new ArrayList();
		String message = "";
		String code = "1";

		try {
			listData = selectYeaDataPdfA1(mp, locPath);
		} catch(Exception e) {
			code = "-1";
			message = e.getMessage();
		}

		Map mapCode = new HashMap();
		mapCode.put("Code", code);
		mapCode.put("Message", message);

		Map rstMap = new HashMap();
		rstMap.put("Result", mapCode);
		rstMap.put("codeList", (List)listData);
		out.print((new org.json.JSONObject(rstMap)).toString());
	} else if("deleteFile".equals(cmd)) {
	    //PDF 파일 삭제
        Map mp = StringUtil.getRequestMap(request);

        String fileUri         = request.getParameter("fileUrl").toString();
	    String paramYear       = request.getParameter("searchWorkYy").toString();
	    String paramDocType    = request.getParameter("doc_type").toString();
	    String paramDocSeq     = request.getParameter("doc_seq").toString();
	    String paramAdjustType = request.getParameter("searchAdjustType").toString();
	    String searchSabun     = request.getParameter("searchSabun").toString();
	    String fileUploadType     = request.getParameter("fileUploadType").toString();

	    mp.put("ssnEnterCd",  ssnEnterCd);
	    mp.put("work_yy",     paramYear);
	    mp.put("doc_type",    paramDocType);
	    mp.put("doc_seq",     paramDocSeq);
	    mp.put("adjust_type", paramAdjustType);
	    mp.put("searchSabun", searchSabun);

        List listData  = new ArrayList();
        String message = "";
        String code = "1";

        try {
        	if(fileUploadType.equals("1")){
        		%>

            	<%@ include file="../../../common_jungsan/jsp/uploadS3/uploadS3.jsp" %>

            	<%
        		String filePath = "/YEA_PDF/"+ssnEnterCd+"/"+paramYear+"/SUM";
        		boolean flag = deleteFileToS3(filePath, fileUri.substring(fileUri.lastIndexOf("/"), fileUri.length()));
        		if(flag){
        			if(deleteYeaDataPdfFile(mp, locPath) != 1) {
						flag = false;
					}
        		}
        		if(!flag) {
					code = "-1";
					message = "파일 삭제에 실패 하였습니다.";
				} else {
					code = "1";
					message = "파일 삭제에 성공 하였습니다.";
				}
        	} else{
        		File f = new File(StringUtil.getPropertiesValue("WAS.PATH")+StringUtil.getPropertiesValue("HRFILE.PATH")+"/YEA_PDF/"+ssnEnterCd+"/"+paramYear+"/SUM" + fileUri.substring(fileUri.lastIndexOf("/"), fileUri.length())); // 파일 객체생성
           	    if( f.exists()) {
           	    	String flag = "Y";

           	    	if(f.delete()){ // 파일이 존재하면 파일을 삭제한다.
           	    		if(deleteYeaDataPdfFile(mp, locPath) != 1){
           	    			flag = "N";
           	    		}
           	    	}else {
           	    		flag = "N";
           	    	}

           	    	if("N".equals(flag)) {
           	    	    code = "-1";
                        message = "파일 삭제에 실패 하였습니다.";
                    } else {
                    	code = "1";
                    	message = "파일 삭제에 성공 하였습니다.";
                    }
           	    } else {
           	    	fileUri = ((String)request.getParameter("fileUrl"));
           	    	//System.out.println(StringUtil.getPropertiesValue("WAS.PATH")+StringUtil.getPropertiesValue("HRFILE.PATH")+"/YEA_PDF/"+ssnEnterCd+"/"+paramYear+"/SUM" + fileUri.substring(fileUri.lastIndexOf("/"), fileUri.length()));
           	    	code = "-1";
           	    	message = "삭제할 파일이 존재하지 않습니다.";
           	    }	
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
	} else if("selectPdfTypeCode".equals(cmd)) {
		//PDF 업로드 방식 조회

		Map mp = StringUtil.getRequestMap(request);
		mp.put("ssnEnterCd", ssnEnterCd);
		mp.put("ssnSabun", ssnSabun);

		List listData  = new ArrayList();
		String message = "";
		String code = "1";

		try {
			listData = selectPdfTypeCode(mp, locPath);
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
	} else if("selectBulkPdf".equals(cmd)) {
		//PDF 업로드 방식 조회

		Map mp = StringUtil.getRequestMap(request);
		mp.put("ssnEnterCd", ssnEnterCd);
		mp.put("ssnSabun", ssnSabun);

		List listData  = new ArrayList();
		String message = "";
		String code = "1";

		try {
			listData = selectBulkPdf(mp, locPath);
		} catch(Exception e) {
			code = "-1";
			message = e.getMessage();
		}
		if(listData == null){
			code = "-1";
		}

		Map mapCode = new HashMap();
		mapCode.put("Code", code);
		mapCode.put("Message", message);

		Map rstMap = new HashMap();
		rstMap.put("Result", mapCode);
		rstMap.put("Data", (List)listData);
		out.print((new org.json.JSONObject(rstMap)).toString());
	} else if("selectConfirmedYn".equals(cmd)) {
		Map mp = StringUtil.getRequestMap(request);
		mp.put("ssnEnterCd", ssnEnterCd);
		mp.put("ssnSabun", ssnSabun);

		List listData  = new ArrayList();
		String message = "";
		String code = "1";
		try {
			listData = selectConfirmedYn(mp, locPath);
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
	} else if("downFile".equals(cmd)) {
		Map mp = StringUtil.getRequestMap(request);

        String fileName         = request.getParameter("fileName").toString();
        String paramYear         = request.getParameter("paramYear").toString();
        int pos = fileName.lastIndexOf(".");
        String fileId = fileName.substring(0, pos);
        String filePath = "/YEA_PDF/"+ssnEnterCd+"/"+paramYear+"/SUM";
        
        String message = "";
		String code = "1";
        
        try{
        	String downloadUrl = downloadPdfToS3(filePath, fileName, fileId, response);
        	if("".equals(downloadUrl)){
        		code = "-1";
    			message = "파일다운로드중 오류가 발생하였습니다.";
        	}
        } catch(Exception e){
        	code = "-1";
        	message = "파일다운로드중 오류가 발생하였습니다.";
        	out.println("<script>alert('파일다운로드중 오류가 발생하였습니다.');</script>");
        }
        Map mapCode = new HashMap();
		mapCode.put("Code", code);
		mapCode.put("Message", message);

		Map rstMap = new HashMap();
		rstMap.put("Result", mapCode);
		out.print((new org.json.JSONObject(rstMap)).toString());
	}
%>
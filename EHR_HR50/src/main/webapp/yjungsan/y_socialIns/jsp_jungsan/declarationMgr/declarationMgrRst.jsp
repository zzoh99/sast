<%@page import="org.apache.commons.io.FileUtils"%>
<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="yjungsan.util.*"%>
<%@ page import="yjungsan.exception.*"%>
<%@ page import="java.sql.Connection"%>
<%@ page import="java.util.List"%>
<%@ page import="java.util.ArrayList"%>
<%@ page import="java.util.Map"%>
<%@ page import="java.util.HashMap"%>
<%@ page import="java.net.URLEncoder"%>
<%@ page import="java.net.URLDecoder"%>
<%@ page import="java.io.*"%>

<%@ page import="com.hr.common.logger.Log" %>
<%@ include file="../common/include/session.jsp"%>

<%!
	//private Logger log = Logger.getLogger(this.getClass());
	
	//public Map queryMap = null;
	
	//xml 파서를 이용한 방법;
	/* public void setQueryMap(String path) {
		queryMap = XmlQueryParser.getQueryMap(path);
	} */
	
	// 신고일 목록 조회
	public List selectDeclarationMgrTargetList(String path, Map paramMap) throws Exception {
		Map queryMap = XmlQueryParser.getQueryMap(path);
		//파라메터 복사.
		Map pm =  StringUtil.getParamMapData(paramMap);
		List listData = null;
		
		try{
			//쿼리 실행및 결과 받기.
			listData  = (queryMap == null) ? null : DBConn.executeQueryList(queryMap,"selectDeclarationMgrTargetList",pm);
		} catch (Exception e) {
			Log.Error("[Exception] " + e);
			throw new Exception("조회에 실패하였습니다.");
		}
		/*
		if (listData == null) {
			return new ArrayList<>();
		}*/
		return listData;
	}
	
	// 신고일 저장
	public int mergeDeclarationMgrTarget(String path, Map paramMap) throws Exception {
		Map queryMap = XmlQueryParser.getQueryMap(path);
		//파라메터 맵안에는 배열형태로 저장되어 있으니 다시 리스트형태로 뽑아서 루프를 돈다.
		List list = StringUtil.getParamListData(paramMap);
		//사용자가 직접 트렌젝션 관리하기 위해 커넥션 가져오기.
		Connection conn = DBConn.getConnection();
		int rstCnt = 0;
		if(conn != null && list != null && list.size() > 0) {
			//사용자가 직접 트랜젝션 관리
			conn.setAutoCommit(false);
			try{
				for(int i = 0; i < list.size(); i++ ) {
					String query = "";
					Map mp = (Map)list.get(i);
					String sStatus = (String)mp.get("sStatus");
					if("D".equals(sStatus)) {
						//삭제
						rstCnt += DBConn.executeUpdate(conn, queryMap, "deleteDeclarationMgrTarget", mp);
					} else if("I".equals(sStatus) || "U".equals(sStatus)) {
						//입력  or 수정
						rstCnt += DBConn.executeUpdate(conn, queryMap, "mergeDeclarationMgrTarget", mp);
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
			}
		}
		return rstCnt;
	}
	
	//신고서 입력항목 목록 조회
	public List selectDeclarationMgrEleList(String path, Map paramMap) throws Exception {
		Map queryMap = XmlQueryParser.getQueryMap(path);
		//파라메터 복사.
		Map pm =  StringUtil.getParamMapData(paramMap);
		List listData = null;
		
		try{
			//쿼리 실행및 결과 받기.
			listData  = (queryMap == null) ? null : DBConn.executeQueryList(queryMap,"selectDeclarationMgrEleList",pm);
		} catch (Exception e) {
			Log.Error("[Exception] " + e);
			throw new Exception("조회에 실패하였습니다.");
		}
		/*
		if (listData == null) {
			return new ArrayList<>();
		} */

		return listData;
	}
	
	//신고서 항목값 목록 조회
	public List selectDeclarationMgrEleValList(String path, Map paramMap) throws Exception {
		Map queryMap = XmlQueryParser.getQueryMap(path);
		//파라메터 복사.
		Map pm =  StringUtil.getParamMapData(paramMap);
		List listData = null;
		
		try{
			
			/* INIT PIVOT SQL **********************************************************************************************************************/
			//신고서 항목값 목록 조회
			List eleListData = selectDeclarationMgrEleList(path, paramMap);
			String pivotSQL = "";
			if(eleListData != null && eleListData.size() > 0) {
				Map item = null;
				for(int i = 0; i < eleListData.size(); i++) {
					item = (Map) eleListData.get(i);
					if(i > 0) pivotSQL += "			     ";
					pivotSQL += String.format(", MAX(DECODE(T.ELEMENT_NM, '%s', DECODE(T.ENCRYPT_YN, 'Y', CRYPTIT.DECRYPT(T.ELEMENT_VAL, T.ENTER_CD), T.ELEMENT_VAL), NULL)) AS ELE_%s\n", item.get("element_nm"), item.get("display_seq"));
				}
			}
			pm.put("pivotSQL", pivotSQL);
			/* INIT PIVOT SQL **********************************************************************************************************************/
			
			//쿼리 실행및 결과 받기.
			listData  = (queryMap == null) ? null : DBConn.executeQueryList(queryMap,"selectDeclarationMgrEleValList",pm);
		} catch (Exception e) {
			Log.Error("[Exception] " + e);
			throw new Exception("조회에 실패하였습니다.");
		}
		
		return listData;
	}
	
	//신고서 항목 저장
	public int mergeDeclarationMgrEleVal(String path, Map paramMap) throws Exception {
		Map queryMap = XmlQueryParser.getQueryMap(path);
		//파라메터 맵안에는 배열형태로 저장되어 있으니 다시 리스트형태로 뽑아서 루프를 돈다.
		List list = StringUtil.getParamListData(paramMap);
		//사용자가 직접 트렌젝션 관리하기 위해 커넥션 가져오기.
		Connection conn = DBConn.getConnection();
		int rstCnt = 0;
		if(conn != null && list != null && list.size() > 0) {
			//사용자가 직접 트랜젝션 관리
			conn.setAutoCommit(false);
			
			//신고서 항목값 목록 조회
			List listData = selectDeclarationMgrEleList(path, paramMap);
			Map<String,Object> mergeMap = null;
			
			try{
				if(listData != null && listData.size() > 0) {
					mergeMap = new HashMap<String,Object>();
					mergeMap.put("ssnEnterCd", paramMap.get("ssnEnterCd"));
					mergeMap.put("ssnSabun", paramMap.get("ssnSabun"));
				}
				
				for(int i = 0; i < list.size(); i++ ) {
					String query = "";
					Map mp = (Map)list.get(i);
					String sStatus = (String)mp.get("sStatus");
					if("D".equals(sStatus)) {
						//삭제
						rstCnt += DBConn.executeUpdate(conn, queryMap, "deleteDeclarationMgrEleVal", mp);
					} else if("I".equals(sStatus) || "U".equals(sStatus)) {
						
						if(listData != null && listData.size() > 0) {
							for(int j = 0; j < listData.size(); j++) {
								Map item = (Map) listData.get(j);
								mergeMap.put("declaration_org_cd", mp.get("declaration_org_cd"));
								mergeMap.put("declaration_type",   mp.get("declaration_type"));
								mergeMap.put("use_sdate",          mp.get("use_sdate"));
								mergeMap.put("target_ymd",         mp.get("target_ymd"));
								mergeMap.put("sabun",              mp.get("sabun"));
								mergeMap.put("element_nm",         item.get("element_nm"));
								mergeMap.put("element_val",        mp.get("ele_" + item.get("display_seq")));
								
								if( item.get("element_type").equals("RESNO") ) {
									mergeMap.put("encrypt_yn", "Y");
								} else {
									mergeMap.put("encrypt_yn", "N");
								}
								
								//입력  or 수정
								rstCnt += DBConn.executeUpdate(conn, queryMap, "mergeDeclarationMgrEleVal", mergeMap);
							}
						}
						
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
			}
		}
		return rstCnt;
	}
	
	//신고서 입력항목 목록 조회(EDI 출력용)
	public List selectDeclarationMgrEleListForEdi(String path, Map paramMap) throws Exception {
		Map queryMap = XmlQueryParser.getQueryMap(path);
		//파라메터 복사.
		Map pm =  StringUtil.getParamMapData(paramMap);
		List listData = null;
		
		try{
			//쿼리 실행및 결과 받기.
			listData  = (queryMap == null) ? null : DBConn.executeQueryList(queryMap,"selectDeclarationMgrEleListForEdi",pm);
		} catch (Exception e) {
			Log.Error("[Exception] " + e);
			throw new Exception("조회에 실패하였습니다.");
		}
		/*
		if (listData == null) {
			return new ArrayList<>();
		} */
		return listData;
	}

	//신고서 항목값 목록 조회(EDI 엑셀 생성용)
	public List getDeclarationMgrEleValListForExcelEdi(String path, Map paramMap) throws Exception {
		Map queryMap = XmlQueryParser.getQueryMap(path);
		//파라메터 복사.
		Map pm =  StringUtil.getParamMapData(paramMap);
		List listData = null;
		
		try{
			
			/* INIT PIVOT SQL **********************************************************************************************************************/
			//신고서 항목값 목록 조회
			List eleListData = selectDeclarationMgrEleListForEdi(path, paramMap);
			String pivotSQL = "";
			if(eleListData != null && eleListData.size() > 0) {
				Map item = null;
				for(int i = 0; i < eleListData.size(); i++) {
					item = (Map) eleListData.get(i);
					if(i > 0) pivotSQL += "			     ";
					pivotSQL += String.format(", MAX(DECODE(T.ELEMENT_NM, '%s', DECODE(T.ENCRYPT_YN, 'Y', CRYPTIT.DECRYPT(T.ELEMENT_VAL, T.ENTER_CD), T.ELEMENT_VAL), NULL)) AS ELE_%s\n", item.get("element_nm"), item.get("display_seq"));
				}
			}
			pm.put("pivotSQL", pivotSQL);
			/* INIT PIVOT SQL **********************************************************************************************************************/
			
			//쿼리 실행및 결과 받기.
			listData  = (queryMap == null) ? null : DBConn.executeQueryList(queryMap,"selectDeclarationMgrEleValList",pm);
		} catch (Exception e) {
			Log.Error("[Exception] " + e);
			throw new Exception("조회에 실패하였습니다.");
		}
		
		return listData;
	}
	
	//신고서 항목값 목록 조회(EDI Txt 파일 생성용)
	public List getDeclarationMgrEleValListForTxtEdi(String path, Map paramMap) throws Exception {
		Map queryMap = XmlQueryParser.getQueryMap(path);
		//파라메터 복사.
		Map pm =  StringUtil.getParamMapData(paramMap);
		List listData = null;
		
		try{
			//쿼리 실행및 결과 받기.
			listData  = (queryMap == null) ? null : DBConn.executeQueryList(queryMap,"selectDeclarationMgrEleValListForTxtEdi",pm);
		} catch (Exception e) {
			Log.Error("[Exception] " + e);
			throw new Exception("조회에 실패하였습니다.");
		}
		/*
		if (listData == null) {
			return new ArrayList<>();
		}*/
		return listData;
	}
	
	//신고서 항목값 목록 조회
	public Map selectDeclarationInfoMap(String path, Map paramMap) throws Exception {
		Map queryMap = XmlQueryParser.getQueryMap(path);
		//파라메터 복사.
		Map pm =  StringUtil.getParamMapData(paramMap);
		Map data = null;
		
		try{
			//쿼리 실행및 결과 받기.
			data  = (queryMap==null) ? null : DBConn.executeQueryMap(queryMap,"selectDeclarationInfoMap",pm);
		} catch (Exception e) {
			Log.Error("[Exception] " + e);
			throw new Exception("조회에 실패하였습니다.");
		}
		
		return data;
	}
	
	//SQL 구문 실행을 통한 입력항목 기본값 조회 
	public Map selectDefaultValForSQLSyntax(String path, Map paramMap) throws Exception {
		Map queryMap = XmlQueryParser.getQueryMap(path);
		//파라메터 복사.
		Map pm =  StringUtil.getParamMapData(paramMap);
		Map data = null;
		
		try{
			//쿼리 실행및 결과 받기.
			data  = (queryMap==null) ? null : DBConn.executeQueryMap(queryMap,"selectDefaultValForSQLSyntax",pm);
		} catch (Exception e) {
			Log.Error("[Exception] " + e);
			throw new Exception("조회에 실패하였습니다.");
		}
		
		return data;
	}
	
	// 브라우저 정보 반환
	private String getBrowser(HttpServletRequest request) {
		String header =request.getHeader("User-Agent");
		//ie 11 부터 MSIE 이 없음으로 Trident 찾음
		if (header.contains("MSIE") || header.contains("Trident")) {
			return "MSIE";
		} else if(header.contains("Chrome")) {
			return "Chrome";
		} else if(header.contains("Opera")) {
			return "Opera";
		}
		return "Firefox";
	}
%>

<%
	//쿼리 맵 셋팅
	//setQueryMap(xmlPath+"/declarationMgr/declarationMgr.xml");
	String ssnEnterCd = (String)session.getAttribute("ssnEnterCd");
	String ssnSabun = (String)session.getAttribute("ssnSabun");
	String cmd = (String)request.getParameter("cmd");
	if("getDeclarationMgrTargetList".equals(cmd)) {
		Map mp = StringUtil.getRequestMap(request);
		mp.put("ssnEnterCd", ssnEnterCd);
		mp.put("ssnSabun", ssnSabun);
		List listData  = new ArrayList();
		String message = "";
		String code = "1";
		try {
			listData = selectDeclarationMgrTargetList(xmlPath+"/declarationMgr/declarationMgr.xml", mp);
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
	} else if ("saveDeclarationMgrTarget".equals(cmd)) {
		Map mp = StringUtil.getRequestMap(request);
		mp.put("ssnEnterCd", ssnEnterCd);
		mp.put("ssnSabun", ssnSabun);
		
		String message = "";
		String code = "1";
		
		try {
			int cnt = mergeDeclarationMgrTarget(xmlPath+"/declarationMgr/declarationMgr.xml", mp);
			
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
	} else if ("getDeclarationMgrEleList".equals(cmd)) {
		Map mp = StringUtil.getRequestMap(request);
		mp.put("ssnEnterCd", ssnEnterCd);
		mp.put("ssnSabun", ssnSabun);
		List listData  = new ArrayList();
		String message = "";
		String code = "1";
		try {
			listData = selectDeclarationMgrEleList(xmlPath+"/declarationMgr/declarationMgr.xml", mp);
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
	} else if ("getDeclarationMgrEleValList".equals(cmd)) {
		Map mp = StringUtil.getRequestMap(request);
		mp.put("ssnEnterCd", ssnEnterCd);
		mp.put("ssnSabun", ssnSabun);
		List listData  = new ArrayList();
		String message = "";
		String code = "1";
		try {
			listData = selectDeclarationMgrEleValList(xmlPath+"/declarationMgr/declarationMgr.xml", mp);
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
	} else if ("saveDeclarationMgrEleVal".equals(cmd)) {
		Map mp = StringUtil.getRequestMap(request);
		mp.put("ssnEnterCd", ssnEnterCd);
		mp.put("ssnSabun", ssnSabun);
		
		String message = "";
		String code = "1";
		
		try {
			int cnt = mergeDeclarationMgrEleVal(xmlPath+"/declarationMgr/declarationMgr.xml", mp);
			
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
	} else if ("getDeclarationInfoMap".equals(cmd)) {
		Map mp = StringUtil.getRequestMap(request);
		mp.put("ssnEnterCd", ssnEnterCd);
		mp.put("ssnSabun", ssnSabun);
		Map data  = null;
		String message = "";
		String code = "1";
		try {
			data = selectDeclarationInfoMap(xmlPath+"/declarationMgr/declarationMgr.xml", mp);
		} catch(Exception e) {
			code = "-1";
			message = e.getMessage();
		}
		Map mapCode = new HashMap();
		mapCode.put("Code", code);
		mapCode.put("Message", message);
		Map rstMap = new HashMap();
		rstMap.put("Result", mapCode);
		rstMap.put("Data", data);
		out.print((new org.json.JSONObject(rstMap)).toString());
	} else if ("getDefaultValForSQLSyntax".equals(cmd)) {
		Map mp = StringUtil.getRequestMap(request);
		mp.put("ssnEnterCd", ssnEnterCd);
		mp.put("ssnSabun", ssnSabun);
		Map data  = null;
		String message = "";
		String code = "1";
		try {
			data = selectDefaultValForSQLSyntax(xmlPath+"/declarationMgr/declarationMgr.xml", mp);
		} catch(Exception e) {
			code = "-1";
			message = e.getMessage();
		}
		Map mapCode = new HashMap();
		mapCode.put("Code", code);
		mapCode.put("Message", message);
		Map rstMap = new HashMap();
		rstMap.put("Result", mapCode);
		rstMap.put("Data", data);
		out.print((new org.json.JSONObject(rstMap)).toString());
	} else if ("executeDeclarationTargetCreate".equals(cmd)) {
		Map paramMap = StringUtil.getRequestMap(request);
		Map mp =  StringUtil.getParamMapData(paramMap);

		String declaration_org_cd = (String) mp.get("declaration_org_cd");
		String declaration_type   = (String) mp.get("declaration_type");
		String target_ymd         = (String) mp.get("target_ymd");
		String sdate              = (String) mp.get("sdate");
		String edate              = (String) mp.get("edate");
		
		String message = "";
		String code = "1";
		
		try {
			//************************* 대상자 생성 프로시저 호출 시작 *************************//
			Log.Debug("== 대상자 생성 프로시저 호출 시작 ==");
			
			
			//프로시저 호출
			String[] type  =  new String[]{"OUT", "OUT", "STR", "STR", "STR", "STR", "STR", "STR", "STR"};
			String[] param  = new String[]{"", "", ssnEnterCd, declaration_org_cd, declaration_type, target_ymd, sdate, edate, ssnSabun};
			String[] rstStr = DBConn.executeProcedure("P_BEN_EDI_CREATE", type, param);
			
			if( "".equals(rstStr[0]) ) {
				message = "처리되었습니다.";
			} else {
				code = "-1";
				message = "대상자 생성중 오류 발생했습니다.\n"+rstStr[1];
			}
			
			Log.Debug("== 대상자 생성 프로시저 호출 종료 ==");
			//************************* 대상자 생성 프로시저 호출 종료 *************************//
			
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
	} else if ("getDeclarationMgrEleValListForExcelEdi".equals(cmd)) {
		Map mp = StringUtil.getRequestMap(request);
		mp.put("ssnEnterCd", ssnEnterCd);
		mp.put("ssnSabun", ssnSabun);
		List listData  = getDeclarationMgrEleValListForExcelEdi(xmlPath+"/declarationMgr/declarationMgr.xml", mp);
		// 데이터를 반드시 SHEETDATA라는 이름으로 담는다.
		request.setAttribute("SHEETDATA", listData);
		String forwardPath = "/yjungsan/common_jungsan/plugin/IBLeaders/Sheet/jsp/DirectDown2Excel.jsp"; 
		if(!"".equals(forwardPath)){
			RequestDispatcher rd = request.getRequestDispatcher(forwardPath);
			rd.forward(request,response);
		}
	} else if ("exportTxtEdiFile".equals(cmd)) {
		Map mp = StringUtil.getRequestMap(request);
		mp.put("ssnEnterCd", ssnEnterCd);
		mp.put("ssnSabun", ssnSabun);
		List listData  = getDeclarationMgrEleValListForTxtEdi(xmlPath+"/declarationMgr/declarationMgr.xml", mp);
		
		Log.Debug("============== [파일 다운로드 시작] ===============");
		request.setCharacterEncoding(StringUtil.getPropertiesValue("SYS.ENC"));
		
		try {
			
			String declarationOrgCd = request.getParameter("declaration_org_cd");
			String declarationType = request.getParameter("declaration_type");
			String useSdate = request.getParameter("use_sdate");
			String targetYmd = request.getParameter("target_ymd");
			
			String serverFileName = String.format("%s_%s_%s_%s_%s_%s.edi", mp.get("ssnEnterCd"), declarationOrgCd, declarationType, useSdate, targetYmd, System.currentTimeMillis());
			String viewFileName = request.getParameter("viewFileName");
			String serverFilePath = StringUtil.getPropertiesValue("LOADEXCEL.PATH"); //저장위치
			
			Log.Debug("serverFileName == " + serverFileName);
			Log.Debug("viewFileName == " + viewFileName);
			Log.Debug("serverFilePath == " + serverFilePath);
			
			if(listData != null && listData.size() > 0 ) {
				
				// EDI 파일 인코딩
				String ediFileEncoding = null;
				// 라인 엔딩 문자열
				String lineEnding = "";
				
				Map declarationInfo = selectDeclarationInfoMap(xmlPath+"/declarationMgr/declarationMgr.xml", mp);
				if( declarationInfo != null && declarationInfo.containsKey("edi_encoding") ) {
					ediFileEncoding = (String) declarationInfo.get("edi_encoding");
				}
				
				if( ediFileEncoding == null || "".equals(ediFileEncoding) ) {
					ediFileEncoding = "EUC-KR";
				}
				
				if("EUC-KR".equals(ediFileEncoding)) {
					lineEnding = "\r\n";
				}
				Log.Debug("ediFileEncoding == " + ediFileEncoding);
				
				List<String> lines = new ArrayList<String>();
				String line = null;
				for(int i = 0; i < listData.size(); i++ ) {
					Map itemMap = (Map) listData.get(i);
					line = (String) itemMap.get("val");
					if( line != null && !"".equals(line) ) {
						lines.add(line.trim());
					}
				}
				// create temp file
				File tempFile = new File(serverFilePath, serverFileName);
				FileUtils.writeLines(tempFile, ediFileEncoding, lines, lineEnding);
	
				// read temp flie
				File file = new File(serverFilePath, serverFileName);
				byte buf[] = new byte[4096];
				
				/***** 레진에서 필요 *****/
				response.reset();
				response.setContentLength((int)file.length());
				/*******************/
	
				String header = getBrowser(request);
				String docName = null;
				if (header.contains("MSIE")) {
					docName = URLEncoder.encode(viewFileName,"UTF-8").replaceAll("\\+", "%20");
				} else {
					docName = new String(viewFileName.getBytes("UTF-8"), "ISO-8859-1");
				}
				
				response.setHeader("Content-Type", "application/octet-stream");
				response.setHeader("Content-Disposition", "attachment;filename=" + docName + ";");
				response.setHeader("Pargma", "no-cache");
				response.setHeader("Expires", "-1");
	
				BufferedInputStream  inputStream = new BufferedInputStream(new FileInputStream(file));
				BufferedOutputStream outStream = new BufferedOutputStream(response.getOutputStream());
	
				int numRead;
				while((numRead = inputStream.read(buf, 0, buf.length)) != -1){
					outStream.write(buf, 0, numRead);
					outStream.flush();
				}
				
				if(!application.getServerInfo().startsWith("WebLogic")) {
					//out.clear();
					out.clearBuffer();
				}
				out = pageContext.pushBody();
				outStream.close();
				inputStream.close();
				
				// remove temp file
				if( file != null && file.exists() ) {
					file.delete();
				}
			} else {
				out.println("<script>alert('생성 대상 데이터가 존재하지 않습니다.');</script>");	
			}
		} catch(Exception e) {
			out.println("<script>alert('파일다운로드중 오류가 발생하였습니다.');</script>");	
			//e.printStackTrace();
		}
		
		Log.Debug("============== [파일 다운로드 종료] ===============");
	} else if ("executeEdiBenBasigMgr".equals(cmd)) {
		Map paramMap = StringUtil.getRequestMap(request);
		Map mp =  StringUtil.getParamMapData(paramMap);

		String declaration_org_cd = (String) mp.get("declaration_org_cd");
		String declaration_type   = (String) mp.get("declaration_type");
		String target_ymd         = (String) mp.get("target_ymd");
		
		String message = "";
		String code = "1";
		
		try {
			//************************* 대상자 생성 프로시저 호출 시작 *************************//
			Log.Debug("== 대상자 생성 프로시저 호출 시작 ==");
			
			
			//프로시저 호출
			String[] type  =  new String[]{"OUT", "OUT", "STR", "STR", "STR", "STR", "STR"};
			String[] param  = new String[]{"", "", ssnEnterCd, declaration_org_cd, declaration_type, target_ymd, ssnSabun};
			String[] rstStr = DBConn.executeProcedure("P_BEN_EDI_BASIC_MGR", type, param);
			
			if( "".equals(rstStr[0]) ) {
				message = "처리되었습니다.";
			} else {
				code = "-1";
				message = "사회보험 기본사항 등록중 오류 발생"+rstStr[1];
			}
			
			Log.Debug("== 사회보험 기본사항 등록 프로시저 호출 종료 ==");
			//************************* 대상자 생성 프로시저 호출 종료 *************************//
			
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
<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="yjungsan.util.*"%>
<%@ page import="yjungsan.exception.*"%>
<%@ page import="java.sql.Connection"%>
<%@ page import="java.util.List"%>
<%@ page import="java.util.ArrayList"%>
<%@ page import="java.util.Map"%>
<%@ page import="java.util.HashMap"%>
<%@ page import="java.io.*"%>
<%@ page import="java.net.URLDecoder"%>

<%@ page import="com.hr.common.logger.Log" %>
<%@ include file="../common/include/session.jsp"%>

<%!
//private Logger log = Logger.getLogger(this.getClass());
//public Map queryMap = null;

//xml 파서를 이용한 방법;
/* public void setQueryMap(String path) {
	queryMap = XmlQueryParser.getQueryMap(path);
} */

//마감 체크
public List getBizLoc(String path, Map paramMap) throws Exception {
	Map queryMap = XmlQueryParser.getQueryMap(path);
	//파라메터 복사.
	Map pm =  StringUtil.getParamMapData(paramMap);
	List listData = null;

	try{
		/* 대상년도 */
		String tgtYear	= String.valueOf(pm.get("tgtYear"));
		/* 반기구분 */
		String searchHalfType	= String.valueOf(pm.get("searchHalfType"));
		/* 소득구분 */
		String declClass	= String.valueOf(pm.get("declClass"));
		/* 사업장 */
		String bizLoc	= String.valueOf(pm.get("bizLoc"));

		StringBuffer query = new StringBuffer();

		query.setLength(0);

	    //대상년도
		if(tgtYear.trim().length() != 0 ){

			query.append(" AND WORK_YY = '"+tgtYear+"'");
		}
	    //반기구분
	    if(searchHalfType.trim().length() != 0 ){

			query.append(" AND HALF_TYPE = '"+searchHalfType+"'");
		}
	    //소득구분
		if(declClass.trim().length() != 0 ){

			query.append(" AND INCOME_TYPE = '"+declClass+"'");
		}
		//사업장
		if(bizLoc.trim().length() != 0 ){

			query.append(" AND BUSINESS_PLACE_CD = '"+bizLoc+"'");
		}

		pm.put("query", query.toString());

		//쿼리 실행및 결과 받기.
		listData  = (queryMap == null) ? null : DBConn.executeQueryList(queryMap,"getBizLoc",pm);

	} catch (Exception e) {
		Log.Error("[Exception] " + e);
		throw new Exception("조회에 실패하였습니다.");
	}

	return listData;
}


//연말정산_회사별 텍스트 파일 생성 프로시저 호출
public String[] prcApply(Map paramMap) throws Exception {
	//Map queryMap = XmlQueryParser.getQueryMap(path);
	String ssnEnterCd = (String)paramMap.get("ssnEnterCd");
	String ssnSabun = (String)paramMap.get("ssnSabun");

	//프로시저 호출
	String[] type =  new String[]{"OUT","OUT","STR","STR"};
	String[] param = new String[]{"", "", ssnEnterCd, ssnSabun};

	String[] rstStr = null;
	try {
		rstStr = DBConn.executeProcedure("PKG_CPN_SYMPYM_DISK.DISK_CODE_APPLY",type,param);
	} catch(Exception e) {
		Log.Error("[Exception] " + e);
		throw new Exception("연말정산_회사별 텍스트 파일 생성 프로시저 실행중 오류가 발생하였습니다.\n"+rstStr[1]);
	}

	return rstStr;
}


//연말정산자료 디스켓생성 생성 프로시저 호출
public String[] prcDiskAll(Map paramMap) throws Exception {
	/* 회사 */
	String ssnEnterCd = (String)paramMap.get("ssnEnterCd");
	/* 정산(대상)년도 */
	String tgtYear = (String)paramMap.get("tgtYear");
	/* 반기구분(상반기:1/하반기:2) */
	String searchHalfType = (String)paramMap.get("searchHalfType");
	/* 지급조서구분(근로:77/사업:50/비거주사업기타:49) */
	String declClass = (String)paramMap.get("declClass");
	/* 사업장 (판교:1/서울역:2) */
	String bizLoc = (String)paramMap.get("bizLoc");
	/* 제출일자 */
	String declYmdTemp = (String)paramMap.get("declYmdTemp");
	declYmdTemp = declYmdTemp.replace("-", "");
	/* 제출자구분(세무대리인:1/법인:2/개인:3) */
	String declPrsnClass = (String)paramMap.get("declPrsnClass");
	/* 세무대리인번호 */
	String taxProxyNo = (String)paramMap.get("taxProxyNo");
	/* 자료수정코드 */
	String amendCd = null;
	/* 기간별코드 */
	String termCd = null;
	/* 담당부서 */
	String declDept = (String)paramMap.get("declDept");
	/* 담당자성명 */
	String declEmp = (String)paramMap.get("declEmp");
	/* 전화번호 */
	String declEmpTel = (String)paramMap.get("declEmpTel");
	/* 홈텍스ID */
	String hometaxId = (String)paramMap.get("hometaxId");
	/* 사번(수정자) */
	String ssnSabun = (String)paramMap.get("ssnSabun");

	if(bizLoc != null && bizLoc.length() == 0) {
		bizLoc = "%";
	}

	//프로시저 호출
	String[] type =  new String[]{"OUT","OUT"
			,"STR","STR","STR","STR","STR"
			,"STR","STR","STR","STR","STR"
			,"STR","STR","STR","STR","STR"};

	String[] param = new String[]{"", ""
			, ssnEnterCd, tgtYear, searchHalfType, declClass, bizLoc
			, declYmdTemp, declPrsnClass, taxProxyNo, amendCd, termCd
			, declDept, declEmp, declEmpTel, hometaxId, ssnSabun};

	String[] rstStr = null;
	try {
		rstStr = DBConn.executeProcedure("PKG_CPN_SYMPYM_DISK.DISK_ALL",type,param);
	} catch(Exception e) {
		Log.Error("[Exception] " + e);
		throw new Exception("연말정산자료 디스켓 생성 프로시저 실행중 오류가 발생하였습니다.\n"+rstStr[1]);
	}

	return rstStr;
}


//쿼리 리스트 조회
public List selectYeaNtsTaxList(String path, String queryId, Map paramMap) throws Exception {
	Map queryMap = XmlQueryParser.getQueryMap(path);
	List listData = null;

	try{
		//쿼리 실행및 결과 받기.
		listData  = (queryMap == null) ? null : DBConn.executeQueryList(queryMap, queryId, paramMap);
	} catch (Exception e) {
		Log.Error("[Exception] " + e);
		throw new Exception(queryId+" 조회에 실패하였습니다.");
	}
	/*
	if (listData == null) {
		return new ArrayList<>();
	}*/
	return listData;
}

//쿼리 맵 조회
public Map selectYeaNtsTaxMap(String path, String queryId, Map paramMap) throws Exception {
	Map queryMap = XmlQueryParser.getQueryMap(path);
	//파라메터 복사.
	Map mapData = null;

	try{
		//쿼리 실행및 결과 받기.
		mapData  = (queryMap==null) ? null : DBConn.executeQueryMap(queryMap, queryId, paramMap);
	} catch (Exception e) {
		Log.Error("[Exception] " + e);
		throw new Exception(queryId+" 조회에 실패하였습니다.");
	}

	return mapData;
}

//파일 디렉토리 생성
public void fileDir(String saveFilePath) throws Exception {
	try{
		File dir = new File(saveFilePath);

		if(!dir.exists()) {
			dir.mkdirs();
		}
	} catch (Exception e) {
		Log.Error("[Exception] " + e);
		throw new Exception("파일 디렉토리 생성중 오류 발생.");
	}
}

//파일 쓰기
public void fileWrite(FileOutputStream fileOut, StringBuffer strBuf) throws Exception {
	try{
		fileOut.write(strBuf.toString().getBytes("euc-kr"));
		fileOut.flush();
	} catch (Exception e) {
		Log.Error("[Exception] " + e);
		throw new Exception("파일 쓰기중 오류 발생.");
	}
}

//파일 닫기
public void fileClose(FileOutputStream fileOut) throws Exception {
	try{
		fileOut.close();
		fileOut = null;
	} catch (Exception e) {
		Log.Error("[Exception] " + e);
		throw new Exception("파일 닫는중 오류 발생.");
	}
}

%>

<%
	//Logger log = Logger.getLogger(this.getClass());

	//쿼리 맵 셋팅
	//setQueryMap(xmlPath+"/simplePymtNtsFileMgr/simplePymtNtsFileMgr.xml");

	String ssnEnterCd = (String)session.getAttribute("ssnEnterCd");
	String ssnSabun = (String)session.getAttribute("ssnSabun");
	String cmd = (String)request.getParameter("cmd");

	Map mp = StringUtil.getRequestMap(request);
	mp.put("ssnEnterCd", ssnEnterCd);
	mp.put("ssnSabun", ssnSabun);


	//마감상태 체크
	if("getBizLoc".equals(cmd)) {

		mp.put("ssnEnterCd", ssnEnterCd);
		mp.put("ssnSabun", ssnSabun);

		List listData  = new ArrayList();
		String message = "";
		String code = "1";

		try {
			listData = getBizLoc(xmlPath+"/simplePymtNtsFileMgr/simplePymtNtsFileMgr.xml", mp);

		} catch(Exception e) {
			code = "-1";
			message = e.getMessage();
		}

		Map mapCode = new HashMap();
		mapCode.put("Code", code);
		mapCode.put("Message", message);

		Map rstMap = new HashMap();
		rstMap.put("Result", mapCode);
		rstMap.put("Data", listData == null ? null : listData.get(0));
		out.print((new org.json.JSONObject(rstMap)).toString());

	}else{

		Map paramMap =  StringUtil.getParamMapData(mp);
		String filePrefix = (String)paramMap.get("filePrefix");
		String tgtYear = (String)paramMap.get("tgtYear");
		String declYmd = (String)paramMap.get("declYmd");
		String declClass = (String)paramMap.get("declClass");
		String message = "";	//오류 메시지
		String code = "1";		//결과 성공여부(1:성공)
		String saveFileName = ""; //저장 파일명
		StringBuffer strBuf = new StringBuffer(); //각 데이터를 담을 버퍼

		String saveFilePath = "";
	    String nfsFilePath = StringUtil.getPropertiesValue("NFS.HRFILE.PATH");

	    // 시큐어코딩으로 인하여 전달받은 파라미터 XSS체크 수행 20240801
	   	if (ssnEnterCd == null || "".equals(ssnEnterCd)) {
	   		ssnEnterCd = "" ;
	   	} else {
	   		ssnEnterCd = ssnEnterCd.replaceAll("/","");	
	   		ssnEnterCd = ssnEnterCd.replaceAll("\\\\","");
	   		ssnEnterCd = ssnEnterCd.replaceAll("\\.","");
	   		ssnEnterCd = ssnEnterCd.replaceAll("&", "");	
	   	}	
	   	
	    if(nfsFilePath != null && nfsFilePath.length() > 0) {
	    	saveFilePath = nfsFilePath+StringUtil.getPropertiesValue("HRFILE.PATH")+"/NTS_FILES/"+ssnEnterCd;
	    } else {
	    	saveFilePath = StringUtil.getPropertiesValue("WAS.PATH")+StringUtil.getPropertiesValue("HRFILE.PATH")+"/NTS_FILES/"+ssnEnterCd; //저장위치
	    }

		Log.Debug("saveFilePath ::::::: " + saveFilePath);

		String businessCnt = "0";	// 사업장수
		String userCnt = "0";		// 인원수
		String taxAmt = "0";		//과세소득 계
		String extTaxAmt = "0";		//비과세소득 계

		int recodeCntA = 0;		//A레코드수
		int recodeCntB = 0;		//B레코드수
		int recodeCntC = 0;		//C레코드수


		int totalRecodeCnt = 0;

		FileOutputStream fileOut = null;

		Log.Debug("============== [NTSTAX C(지급조서) 시작] ===============");

		try {
			fileDir(saveFilePath);

			//************************* 자료생성 프로시저 호출 시작 *************************//
			Log.Debug("== 연말정산_회사별 텍스트 파일 생성 프로시저 호출 시작 ==");

			String[] rstStr = prcApply(paramMap);

			if(rstStr[1] != null && rstStr[1].length() != 0) {
				Log.Debug("== 연말정산_회사별 텍스트 파일 생성 생성 프로시저 실행중 오류 발생:"+rstStr[1]+" ==");
				throw new UserException("연말정산_회사별 텍스트 파일 생성 프로시저 실행중 오류가 발생하였습니다.\n"+rstStr[1]);
			}

			Log.Debug("== 연말정산_회사별 텍스트 파일 생성 프로시저 호출 종료 ==");

			Log.Debug("== 연말정산자료 디스켓생성 생성 프로시저 호출 시작 ==");


			String[] rstStr2 = prcDiskAll(paramMap);

			if(rstStr2[1] != null && rstStr2[1].length() != 0) {
				Log.Debug("== 연말정산_회사별 텍스트 파일 생성 생성 프로시저 실행중 오류 발생:"+rstStr2[1]+" ==");
				throw new UserException("연말정산_회사별 텍스트 파일 생성 프로시저 실행중 오류가 발생하였습니다.\n"+rstStr2[1]);
			}

			Log.Debug("== 연말정산자료 디스켓생성 생성 프로시저 호출 종료 ==");

			//************************* 자료생성 프로시저 호출 종료 *************************//

			//************************* 파일명 조회 시작 *************************//
			Log.Debug("== 파일명 조회 시작 ==");

			//dynamic query 보안 이슈 때문에 수정
			if(((String)paramMap.get("bizLoc")).length() == 0) {
				paramMap.put("tmpBizLoc","");
			} else {
				paramMap.put("tmpBizLoc",(String)paramMap.get("bizLoc"));
			}

			Map fileData = selectYeaNtsTaxMap(xmlPath+"/simplePymtNtsFileMgr/simplePymtNtsFileMgr.xml", "selectYeaNtsTaxHFileName", paramMap);

			if( fileData != null && fileData.get("regino") != null && ((String)fileData.get("regino")).length() > 0 ) {
				String regiNo = ((String)fileData.get("regino")).replace("-", "");
				saveFileName = filePrefix + regiNo.substring(0, 7) + "." + regiNo.substring(7) + "." + System.currentTimeMillis();
			} else {
				Log.Debug("== 파일명 조회중 오류 발생:해당 회사(사업장)의 사업자등록 번호가 존재하지 않습니다. ==");
				throw new UserException("해당 회사(사업장)의 사업자등록 번호가 존재하지 않습니다.");
			}

			Log.Debug("== 파일명 조회 종료 ==");
			//************************* 파일명 조회 종료 *************************//

			//************************* 데이터 조회 시작 *************************//
			Log.Debug("== content 데이터 조회 시작 ==");

			//파일 열기.
			fileOut = new FileOutputStream(saveFilePath+"/"+saveFileName);

			List listDataA = selectYeaNtsTaxList(xmlPath+"/simplePymtNtsFileMgr/simplePymtNtsFileMgr.xml", "selectYeaNtsTaxCRecodeAContent", paramMap);
			if(listDataA != null && listDataA.size() > 0) {
				strBuf.delete(0, strBuf.toString().length());

				for(int i = 0; i < listDataA.size(); i++) {
					Map mapDataA = (Map)listDataA.get(i);

					strBuf.append((String)mapDataA.get("content"));
					recodeCntA++;
					totalRecodeCnt++;
				}

				//A리스트 쓰기
				fileWrite(fileOut, strBuf);
			}

			List listDataB = selectYeaNtsTaxList(xmlPath+"/simplePymtNtsFileMgr/simplePymtNtsFileMgr.xml", "selectYeaNtsTaxCRecodeBContent", paramMap);
			if(listDataB != null && listDataB.size() > 0) {

				for(int jj = 0; jj < listDataB.size(); jj++) {
					strBuf.delete(0, strBuf.toString().length());
					Map mapDataB = (Map)listDataB.get(jj);

					strBuf.append("\n").append((String)mapDataB.get("content"));
					recodeCntB++;
					totalRecodeCnt++;

					//B리스트 쓰기
					fileWrite(fileOut, strBuf);

					String regiNo_B = ((String)mapDataB.get("regino")).replace("-", "");

					paramMap.put("regiNo",regiNo_B);


					List listDataC = selectYeaNtsTaxList(xmlPath+"/simplePymtNtsFileMgr/simplePymtNtsFileMgr.xml", "selectYeaNtsTaxCRecodeCContent", paramMap);

					//C 레코드 수 초기화
					recodeCntC = 0;

						if(listDataC != null && listDataC.size() > 0) {
							for(int i = 0; i < listDataC.size(); i++) {
								strBuf.delete(0, strBuf.toString().length());
								Map mapDataC = (Map)listDataC.get(i);

								strBuf.append("\n").append((String)mapDataC.get("content"));
								recodeCntC++;
								totalRecodeCnt++;

								mapDataC.put("ssnEnterCd", (String)paramMap.get("ssnEnterCd"));
								mapDataC.put("tgtYear", (String)paramMap.get("tgtYear"));
								mapDataC.put("declClass", (String)paramMap.get("declClass"));
								mapDataC.put("declYmd", (String)paramMap.get("declYmd"));
								mapDataC.put("regiNo", (String)paramMap.get("regiNo"));

								//C리스트 쓰기
								fileWrite(fileOut, strBuf);

								if("1".equals(declClass)) {
							}
						}
					}
				}
			}

			fileClose(fileOut);

			if(recodeCntA == 0 && recodeCntB == 0 && recodeCntC == 0) {
				Log.Debug("== content 데이터 조회중 오류 발생:신고대상 지급조서 레코드가 존재하지 않습니다. ==");
				throw new UserException("신고대상 지급조서 레코드가 존재하지 않습니다.");
			} else if(recodeCntC == 0) {
				Log.Debug("== content 데이터 조회중 오류 발생:C레코드의 수가 0 입니다. ==");
				throw new UserException("C레코드의 수가 0 입니다.");
			}

			Log.Debug("== content 데이터 조회 종료 ==");

			Log.Debug("== 결과 데이터 조회 시작 ==");

			Map rstData1 = selectYeaNtsTaxMap(xmlPath+"/simplePymtNtsFileMgr/simplePymtNtsFileMgr.xml", "selectYeaNtsTaxCResult1", paramMap);
			Map rstData2 = selectYeaNtsTaxMap(xmlPath+"/simplePymtNtsFileMgr/simplePymtNtsFileMgr.xml", "selectYeaNtsTaxCResult2", paramMap);

			//과세소득 계
			if(rstData1 != null && rstData1.get("pay_tot_mon") != null) {
				taxAmt = (String)rstData1.get("pay_tot_mon");
			}

			//사업장수
			if(rstData1 != null && rstData1.get("diskb_totsum") != null) {
				businessCnt = (String)rstData1.get("diskb_totsum");
			}

			//인원 수
			if(rstData2 != null && rstData2.get("diskc_totsum") != null) {
				userCnt = (String)rstData2.get("diskc_totsum");
			}

			//비과세소드계
			if(rstData2 != null && rstData2.get("ext_tax_amount") != null) {
				extTaxAmt = (String)rstData2.get("ext_tax_amount");
			}

			if(rstData1 == null && rstData1.size() == 0 && rstData2 == null && rstData2.size() == 0) {
				Log.Debug("== 결과 데이터 조회중 오류 발생:결과 데이터가 존재하지 않습니다. ==");
				throw new UserException("결과 데이터가 존재하지 않습니다.");
			}

			Log.Debug("== 결과 데이터 조회 종료 ==");
			//************************* 데이터 조회 종료 *************************//

		} catch(UserException ue) {
			Log.Debug("[UserException]" + ue.getMessage());
			code = "-1";
			message = ue.getMessage();
		} catch(Exception ex) {
			//ex.printStackTrace();
			code = "-1";
			message = ex.toString();
		} finally {
			try{
				if(fileOut != null) {
					fileClose(fileOut);
				}
			} catch(Exception ex) {
				//ex.printStackTrace();
				code = "-1";
				message = ex.toString();
			}
		}

		Log.Debug("============== [NTSTAX C(지급조서) 종료] ===============");

		Map rtnData = new HashMap();
		if("1".equals(code)) {
			rtnData.put("serverSaveFileName", saveFileName); //서버 저장 파일명
			rtnData.put("viewSaveFileName", saveFileName.substring(0, saveFileName.lastIndexOf("."))); //화면에 보여줄 파일명
			rtnData.put("recodeCntA", StringUtil.formatMoney(String.valueOf(recodeCntA))); 	//A레코드수
			rtnData.put("recodeCntB", StringUtil.formatMoney(String.valueOf(recodeCntB))); 	//B레코드수
			rtnData.put("recodeCntC", StringUtil.formatMoney(String.valueOf(recodeCntC))); 	//C레코드수
			/* rtnData.put("payTotMon", StringUtil.formatMoney(payTotMon)); 					//결과(총급여)
			rtnData.put("extTaxAmount", StringUtil.formatMoney(extTaxAmount)); 				//결과(비과세계)
			rtnData.put("itaxTotMon", StringUtil.formatMoney(itaxTotMon)); 					//결과(결정소득세) */


			rtnData.put("extTaxAmt", StringUtil.formatMoney(extTaxAmt)); 				//비과세소득 계 (임시)
			rtnData.put("taxAmt", StringUtil.formatMoney(taxAmt)); 						//과세소득 계
			/* 근로소득일 경우에만 적용 */
			/* if(declClass.equals("77")){
				rtnData.put("taxAmt", StringUtil.formatMoney(taxAmt));
			} */

			rtnData.put("businessCnt", StringUtil.formatMoney(businessCnt)); 			//사업장 수
			rtnData.put("userCnt", StringUtil.formatMoney(userCnt)); 					//인원 수

			//과세소득 계 (임시)
			rtnData.put("filePrefix", filePrefix); //구분
		}
		Log.Debug("[NTSTAX C(지급조서) 결과]: "+rtnData);

		Map mapCode = new HashMap();
		mapCode.put("Code", code);
		mapCode.put("Message", message);

		Map rstMap = new HashMap();
		rstMap.put("Result", mapCode);
		rstMap.put("Data", (Map)rtnData);
		out.print((new org.json.JSONObject(rstMap)).toString());
	}
%>
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

//xml 파서를 이용한 방법;
public Map setQueryMap(String path) {
	return XmlQueryParser.getQueryMap(path);
}

//작업 프로시저 호출
public String[] prcYeaNtsDisk(Map paramMap) throws Exception {
	
	String ssnEnterCd = (String)paramMap.get("ssnEnterCd");
	String ssnSabun = (String)paramMap.get("ssnSabun");
	String curSysYyyyMMdd = yjungsan.util.DateUtil.getDateTime("yyyyMMdd");
	String tgtYear = (String)paramMap.get("tgtYear");
	String declClass = (String)paramMap.get("declClass");
	String bizLoc = (String)paramMap.get("bizLoc");
	String declYmd = (String)paramMap.get("declYmd");
	String hometaxId = (String)paramMap.get("hometaxId");
	String includeYn = (String)paramMap.get("includeYn");
	String declPrsnClass = (String)paramMap.get("declPrsnClass");
	String taxProxyNo = (String)paramMap.get("taxProxyNo");
	String dataModCode = (String)paramMap.get("dataModCode");
	String termCode = (String)paramMap.get("termCode");
	String declDept = (String)paramMap.get("declDept");
	String declEmp = (String)paramMap.get("declEmp");
	String declEmpTel = (String)paramMap.get("declEmpTel");
	
	if(bizLoc != null && bizLoc.length() == 0) {
		bizLoc = "%";
	}

	// 텍스트파일 생성 프로시저 호출
	String[] type =  new String[]{"OUT","OUT","STR","STR"};

	String[] param = new String[]{"", "", ssnEnterCd, ssnSabun};

	String[] rstStr = null;
	try {
		rstStr = DBConn.executeProcedure("PKG_CPN_YEA_"+tgtYear+"_DISK.DISK_CODE_APPLY",type,param);
	} catch(Exception e) {
		Log.Error("[Exception] " + e);
		throw new Exception("항목생성 프로시저 실행중 오류가 발생하였습니다.\n"+rstStr[1]);
	}

	// 지급조서 생성 프로시저 호출
	type =  new String[]{"OUT","OUT","STR","STR","STR"
			,"STR","STR","STR","STR","STR"
			,"STR","STR","STR","STR","STR"
			,"STR","STR","STR","STR"};

	param = new String[]{"", "", ssnEnterCd, tgtYear, declClass
			, "", curSysYyyyMMdd, bizLoc, declYmd, declPrsnClass
			, taxProxyNo, dataModCode, termCode, declDept, declEmp
			, declEmpTel, hometaxId, ssnSabun, includeYn};

	rstStr = null;
	try {
		rstStr = DBConn.executeProcedure("PKG_CPN_YEA_"+tgtYear+"_DISK.DISK_ALL",type,param);
	} catch(Exception e) {
		Log.Error("[Exception] " + e);
		throw new Exception("자료생성 프로시저 실행중 오류가 발생하였습니다.\n"+rstStr[1]);		
	}
	
	return rstStr;
}

//쿼리 리스트 조회
public List selectYeaNtsTaxList(String queryId, Map paramMap, Map queryMap) throws Exception {

	List listData = null;
	
	try{
		//쿼리 실행및 결과 받기.
		listData  = (queryMap == null) ? null : DBConn.executeQueryList(queryMap, queryId, paramMap);
	} catch (Exception e) {
		Log.Error("[Exception] " + e);
		throw new Exception(queryId+" 조회에 실패하였습니다.");
	}
	
	return listData;
}

//쿼리 맵 조회
public Map selectYeaNtsTaxMap(String queryId, Map paramMap, Map queryMap) throws Exception {

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
//	Logger log = Logger.getLogger(this.getClass());

	//쿼리 맵 셋팅
	Map queryMap = setQueryMap(xmlPath+"/yeaNtsTax/yeaNtsTaxC.xml");

	String ssnEnterCd = (String)session.getAttribute("ssnEnterCd");
	String ssnSabun = (String)session.getAttribute("ssnSabun");

	Map mp = StringUtil.getRequestMap(request);
	mp.put("ssnEnterCd", ssnEnterCd);
	mp.put("ssnSabun", ssnSabun);
	
	Map paramMap =  StringUtil.getParamMapData(mp);
	String filePrefix = (String)paramMap.get("filePrefix");
	String tgtYear = (String)paramMap.get("tgtYear");
	String declYmd = (String)paramMap.get("declYmd");
	String declClass = (String)paramMap.get("declClass");
	String message = "";	//오류 메시지
	String code = "1";		//결과 성공여부(1:성공)
	String saveFileName = ""; //저장 파일명
	String saveFilePath = StringUtil.getPropertiesValue("WAS.PATH")+StringUtil.getPropertiesValue("HRFILE.PATH")+"/NTS_FILES/"+ssnEnterCd; //저장위치
	/*태영건설은 신고파일 저장경로를 변경해서 사용(태영건설 정화미님) - 2020.02.18.
	String saveFilePath = StringUtil.getPropertiesValue("NFS.HRFILE.PATH")+"/NTS_FILES/"+ssnEnterCd; //저장위치
	*/
	StringBuffer strBuf = new StringBuffer(); //각 데이터를 담을 버퍼

	String payTotMon       = "0";//결과(총급여)
	String extTaxAmount    = "0";//결과(비과세계)
	String itaxTotMon      = "0";//결과(결정소득세)
	String taxExemptTotMon = "0";//결과(감면소득계)		
	
	int recodeCntA = 0;		//A레코드수 
	int recodeCntB = 0;		//B레코드수
	int recodeCntC = 0;		//C레코드수
	int recodeCntD = 0;		//D레코드수
	int recodeCntE = 0;		//E레코드수
	int recodeCntF = 0;		//F레코드수
	int recodeCntG = 0;		//G레코드수
	int recodeCntH = 0;		//H레코드수
	int recodeCntI = 0;		//I레코드수
	int recodeCntJ = 0;		//J레코드수
	int recodeCntK = 0;		//K레코드수
	int totalRecodeCnt = 0;
	
	FileOutputStream fileOut = null;
	
	Log.Debug("============== [NTSTAX C(지급조서) 시작] ===============");

	try {
		fileDir(saveFilePath);
		
		//************************* 자료생성 프로시저 호출 시작 *************************//
		Log.Debug("== 자료생성 프로시저 호출 시작 ==");
		
		String[] rstStr = prcYeaNtsDisk(paramMap);
		
		if(rstStr[1] != null && rstStr[1].length() != 0) {
			Log.Debug("== 자료생성 프로시저 실행중 오류 발생:"+rstStr[1]+" ==");
			throw new UserException("자료생성 프로시저 실행중 오류가 발생하였습니다.\n"+rstStr[1]);
		}
		
		Log.Debug("== 자료생성 프로시저 호출 종료 ==");
		//************************* 자료생성 프로시저 호출 종료 *************************//

		//************************* 파일명 조회 시작 *************************//
		Log.Debug("== 파일명 조회 시작 ==");
// 		if(((String)paramMap.get("bizLoc")).length() == 0) {
// 			paramMap.put("tmpBizLoc","'%'");
// 		} else {
// 			paramMap.put("tmpBizLoc","'"+(String)paramMap.get("bizLoc")+"'");
// 		}

		//dynamic query 보안 이슈 때문에 수정
		if(((String)paramMap.get("bizLoc")).length() == 0) {
			paramMap.put("tmpBizLoc","");
		} else {
			paramMap.put("tmpBizLoc",(String)paramMap.get("bizLoc"));
		}
		
		Map fileData = selectYeaNtsTaxMap("selectYeaNtsTaxHFileName", paramMap, queryMap);
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

		List listDataA = selectYeaNtsTaxList("selectYeaNtsTaxCRecodeAContent", paramMap, queryMap);
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

		List listDataB = selectYeaNtsTaxList("selectYeaNtsTaxCRecodeBContent", paramMap, queryMap);
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
			
			
				List listDataC = selectYeaNtsTaxList("selectYeaNtsTaxCRecodeCContent", paramMap, queryMap);
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
							List listDataD = selectYeaNtsTaxList("selectYeaNtsTaxCRecodeDContent", mapDataC, queryMap);
							if(listDataD != null && listDataD.size() > 0) {
								strBuf.delete(0, strBuf.toString().length());
								
								for(int j = 0; j < listDataD.size(); j++) {
									Map mapDataD = (Map)listDataD.get(j);
									
									strBuf.append("\n").append((String)mapDataD.get("content"));
									recodeCntD++;
									totalRecodeCnt++;
								}
								
								//D리스트 쓰기
								fileWrite(fileOut, strBuf);
							}
							
							List listDataE = selectYeaNtsTaxList("selectYeaNtsTaxCRecodeEContent", mapDataC, queryMap);
							if(listDataE != null && listDataE.size() > 0) {
								strBuf.delete(0, strBuf.toString().length());
		
								for(int j = 0; j < listDataE.size(); j++) {
									Map mapDataE = (Map)listDataE.get(j);
									
									strBuf.append("\n").append((String)mapDataE.get("content"));
									recodeCntE++;
									totalRecodeCnt++;
								}
		
								//E리스트 쓰기
								fileWrite(fileOut, strBuf);
							}
							
							List listDataF = selectYeaNtsTaxList("selectYeaNtsTaxCRecodeFContent", mapDataC, queryMap);
							if(listDataF != null && listDataF.size() > 0) {
								strBuf.delete(0, strBuf.toString().length());
		
								for(int j = 0; j < listDataF.size(); j++) {
									Map mapDataF = (Map)listDataF.get(j);
									
									strBuf.append("\n").append((String)mapDataF.get("content"));
									recodeCntF++;
									totalRecodeCnt++;
								}
								
								//F리스트 쓰기
								fileWrite(fileOut, strBuf);
							}
							
							List listDataG = selectYeaNtsTaxList("selectYeaNtsTaxCRecodeGContent", mapDataC, queryMap);
							if(listDataG != null && listDataG.size() > 0) {
								strBuf.delete(0, strBuf.toString().length());
		
								for(int j = 0; j < listDataG.size(); j++) {
									Map mapDataG = (Map)listDataG.get(j);
									
									strBuf.append("\n").append((String)mapDataG.get("content"));
									recodeCntG++;
									totalRecodeCnt++;
								}
		
								//G리스트 쓰기
								fileWrite(fileOut, strBuf);
							}
							
							List listDataH = selectYeaNtsTaxList("selectYeaNtsTaxCRecodeHContent", mapDataC, queryMap);
							if(listDataH != null && listDataH.size() > 0) {
								strBuf.delete(0, strBuf.toString().length());
		
								for(int j = 0; j < listDataH.size(); j++) {
									Map mapDataH = (Map)listDataH.get(j);
									
									strBuf.append("\n").append((String)mapDataH.get("content"));
									recodeCntH++;
									totalRecodeCnt++;
								}
		
								//H리스트 쓰기
								fileWrite(fileOut, strBuf);
							}
							
							List listDataI = selectYeaNtsTaxList("selectYeaNtsTaxCRecodeIContent", mapDataC, queryMap);
							if(listDataI != null && listDataI.size() > 0) {
								strBuf.delete(0, strBuf.toString().length());
		
								for(int j = 0; j < listDataI.size(); j++) {
									Map mapDataI = (Map)listDataI.get(j);
									
									strBuf.append("\n").append((String)mapDataI.get("content"));
									recodeCntI++;
									totalRecodeCnt++;
								}
		
								//I리스트 쓰기
								fileWrite(fileOut, strBuf);
							}
							
							List listDataJ = selectYeaNtsTaxList("selectYeaNtsTaxCRecodeJContent", mapDataC, queryMap);
							if(listDataJ != null && listDataJ.size() > 0) {
								strBuf.delete(0, strBuf.toString().length());
		
								for(int j = 0; j < listDataJ.size(); j++) {
									Map mapDataJ = (Map)listDataJ.get(j);
									
									strBuf.append("\n").append((String)mapDataJ.get("content"));
									recodeCntJ++;
									totalRecodeCnt++;
								}
		
								//J리스트 쓰기
								fileWrite(fileOut, strBuf);
							}

							List listDataK = selectYeaNtsTaxList("selectYeaNtsTaxCRecodeKContent", mapDataC, queryMap);
							if(listDataK != null && listDataK.size() > 0) {
								strBuf.delete(0, strBuf.toString().length());

								for(int j = 0; j < listDataK.size(); j++) {
									Map mapDataK = (Map)listDataK.get(j);

									strBuf.append("\n").append((String)mapDataK.get("content"));
									recodeCntK++;
									totalRecodeCnt++;
								}

								//K리스트 쓰기
								fileWrite(fileOut, strBuf);
							}
						} else {
							List listDataD = selectYeaNtsTaxList("selectYeaNtsTaxCRecodeEDContent", mapDataC, queryMap);
							if(listDataD != null && listDataD.size() > 0) {
								strBuf.delete(0, strBuf.toString().length());
								
								for(int j = 0; j < listDataD.size(); j++) {
									Map mapDataD = (Map)listDataD.get(j);
									
									strBuf.append("\n").append((String)mapDataD.get("content"));
									recodeCntD++;
									totalRecodeCnt++;
								}
								
								//D리스트 쓰기
								fileWrite(fileOut, strBuf);
							}
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
		
		Map rstData1 = selectYeaNtsTaxMap("selectYeaNtsTaxCResult1", paramMap, queryMap);
		Map rstData2 = selectYeaNtsTaxMap("selectYeaNtsTaxCResult2", paramMap, queryMap);
		Map rstData3 = selectYeaNtsTaxMap("selectYeaNtsTaxCResult3", paramMap, queryMap);
		
		if(rstData1 != null && rstData1.get("pay_tot_mon") != null) {
			payTotMon = (String)rstData1.get("pay_tot_mon");
		}
		if(rstData1 != null && rstData1.get("itax_tot_mon") != null) {
			itaxTotMon = (String)rstData1.get("itax_tot_mon");
		}
		if(rstData2 != null && rstData2.get("ext_tax_amount") != null) {
			extTaxAmount = (String)rstData2.get("ext_tax_amount");
		}
        if(rstData3 != null && rstData3.get("tax_exempt_tot_mon") != null) {
        	taxExemptTotMon = (String)rstData3.get("tax_exempt_tot_mon");
        }		
		if(rstData1 == null && rstData1.size() == 0 && rstData2 == null && rstData2.size() == 0 && rstData3 == null && rstData3.size() == 0) {
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
		Log.Error("[yeaNtsTaxCRst]:" + ex.getMessage());
		code = "-1";
		message = ex.toString();
	} finally {
		try{
			if(fileOut != null) {
				fileClose(fileOut);
			}
		} catch(Exception ex) {
			Log.Error("[yeaNtsTaxCRst]: finally " + ex.getMessage());
			code = "-1";
			message = ex.toString();
		}
	}
	
	Log.Debug("============== [NTSTAX C(지급조서) 종료] ===============");
	
	Map rtnData = new HashMap();
	if("1".equals(code)) {
		rtnData.put("serverSaveFileName", saveFileName); //서버 저장 파일명
		rtnData.put("viewSaveFileName", saveFileName.substring(0, saveFileName.lastIndexOf("."))); //화면에 보여줄 파일명
		rtnData.put("recodeCntA", StringUtil.formatMoney(String.valueOf(recodeCntA))); //A레코드수
		rtnData.put("recodeCntB", StringUtil.formatMoney(String.valueOf(recodeCntB))); //B레코드수
		rtnData.put("recodeCntC", StringUtil.formatMoney(String.valueOf(recodeCntC))); //C레코드수
		rtnData.put("recodeCntD", StringUtil.formatMoney(String.valueOf(recodeCntD))); //D레코드수
		rtnData.put("recodeCntE", StringUtil.formatMoney(String.valueOf(recodeCntE))); //E레코드수
		rtnData.put("recodeCntF", StringUtil.formatMoney(String.valueOf(recodeCntF))); //F레코드수
		rtnData.put("recodeCntG", StringUtil.formatMoney(String.valueOf(recodeCntG))); //G레코드수
		rtnData.put("recodeCntH", StringUtil.formatMoney(String.valueOf(recodeCntH))); //H레코드수
		rtnData.put("recodeCntI", StringUtil.formatMoney(String.valueOf(recodeCntI))); //I레코드수
		rtnData.put("recodeCntJ", StringUtil.formatMoney(String.valueOf(recodeCntJ))); //J레코드수
		rtnData.put("recodeCntK", StringUtil.formatMoney(String.valueOf(recodeCntK))); //J레코드수
		rtnData.put("payTotMon", StringUtil.formatMoney(payTotMon)); //결과(총급여)
		rtnData.put("extTaxAmount", StringUtil.formatMoney(extTaxAmount)); //결과(비과세계)
		rtnData.put("itaxTotMon", StringUtil.formatMoney(itaxTotMon)); //결과(결정소득세)
		rtnData.put("taxExemptTotMon", StringUtil.formatMoney(taxExemptTotMon)); //결과(감면소득세)		
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
%>
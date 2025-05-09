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
/* public void setQueryMap(String path) {
	queryMap = XmlQueryParser.getQueryMap(path);
} */

//작업 프로시저 호출
public String[] prcOTaxDisk(String path, Map paramMap) throws Exception {
	Map queryMap = XmlQueryParser.getQueryMap(path);
	
	String ssnEnterCd = (String)paramMap.get("ssnEnterCd");
	String belongYy = (String)paramMap.get("belongYy");
	String businessPlaceCd = (String)paramMap.get("businessPlaceCd");
	String earnerCd = (String)paramMap.get("earnerCd");
	String sendYmd = (String)paramMap.get("sendYmd");
	String hometaxId = (String)paramMap.get("hometaxId");
	String taxNo = (String)paramMap.get("taxNo");
	String email = (String)paramMap.get("email");
	String sendType = (String)paramMap.get("sendType");
	String taxNumber = (String)paramMap.get("taxNumber");
	String orgNm = (String)paramMap.get("orgNm");
	String name = (String)paramMap.get("name");
	String telNumber = (String)paramMap.get("telNumber");
	String ssnSabun = (String)paramMap.get("ssnSabun");
	
	if(businessPlaceCd == null || businessPlaceCd.equals("")) 	businessPlaceCd = "%";
	if(sendYmd != null && !sendYmd.equals("")) 					sendYmd = sendYmd.replaceAll("-", "");
	if(telNumber != null && !telNumber.equals("")) 				telNumber = telNumber.replaceAll("-", "");
	
	//프로시저 호출
	String[] type =  new String[]{"OUT","OUT","STR","STR","STR"
			,"STR","STR","STR","STR","STR"
			,"STR","STR","STR","STR","STR"
			,"STR"};
	
	String[] param = new String[]{"", "", ssnEnterCd, belongYy, businessPlaceCd
			, earnerCd, sendYmd, hometaxId, taxNo, email
			, sendType, taxNumber, orgNm, name, telNumber
			, ssnSabun};
	
	String[] rstStr = null;
	try {
		rstStr = DBConn.executeProcedure("PKG_CPN_YEA_OTax_DISK_2011.DISK_ALL",type,param);
	} catch(Exception e) {
		Log.Error("[Exception] " + e);
		throw new Exception("자료생성 프로시저 실행중 오류가 발생하였습니다.\n"+rstStr[1]);		
	}
	
	return rstStr;
}

//쿼리 리스트 조회
public List selectOTaxList(String queryId, String path, Map paramMap) throws Exception {
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
public Map selectOTaxMap(String queryId, String path, Map paramMap) throws Exception {
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
	//setQueryMap(xmlPath+"/earnIncomeTaxCre/earnIncomeTaxCre.xml");

	String ssnEnterCd = (String)session.getAttribute("ssnEnterCd");
	String ssnSabun = (String)session.getAttribute("ssnSabun");

	Map mp = StringUtil.getRequestMap(request);
	mp.put("ssnEnterCd", ssnEnterCd);
	mp.put("ssnSabun", ssnSabun);
	
	Map paramMap =  StringUtil.getParamMapData(mp);
	String filePrefix = (String)paramMap.get("filePrefix");
	String belongYy = (String)paramMap.get("belongYy");
	String earnerCd = (String)paramMap.get("earnerCd");
	String businessPlaceCd = (String)paramMap.get("businessPlaceCd");
	String message = "";	//오류 메시지
	String code = "1";		//결과 성공여부(1:성공)
	String saveFileName = ""; //저장 파일명
	String saveFilePath = StringUtil.getPropertiesValue("WAS.PATH")+StringUtil.getPropertiesValue("HRFILE.PATH")+"/NTS_FILES/"+ssnEnterCd; //저장위치
	StringBuffer strBuf = new StringBuffer(); //각 데이터를 담을 버퍼

	String payCnt = "0";		//결과(인원수)
	String payTotMon = "0";		//결과(소득금액계)
	String itaxTotMon = "0";	//결과(소득세계)
	String rtaxTotMon = "0";	//결과(주민세계)
	
	int recodeCntA = 0;		//A레코드수 
	int recodeCntB = 0;		//B레코드수
	int recodeCntC = 0;		//C레코드수
	int totalRecodeCnt = 0;
	
	FileOutputStream fileOut = null;
	
	Log.Debug("============== [OTax(원천세) 시작] ===============");

	try {
		fileDir(saveFilePath);
		//************************* 자료생성 프로시저 호출 시작 *************************//
		Log.Debug("== 자료생성 프로시저 호출 시작 ==");
		
		String[] rstStr = prcOTaxDisk(xmlPath+"/earnIncomeTaxCre/earnIncomeTaxCre.xml", paramMap);
		
		if(rstStr[1] != null && rstStr[1].length() != 0) {
			Log.Debug("== 자료생성 프로시저 실행중 오류 발생:"+rstStr[1]+" ==");
			throw new UserException("자료생성 프로시저 실행중 오류가 발생하였습니다.\n"+rstStr[1]);
		}
		
		Log.Debug("== 자료생성 프로시저 호출 종료 ==");
		//************************* 자료생성 프로시저 호출 종료 *************************//

		//************************* 파일명 조회 시작 *************************//
		Log.Debug("== 파일명 조회 시작 ==");
// 		if(((String)paramMap.get("businessPlaceCd")).length() == 0) {
// 			paramMap.put("tmpBizLoc","'%'");
// 		} else {
// 			paramMap.put("tmpBizLoc","'"+(String)paramMap.get("businessPlaceCd")+"'");
// 		}
		
		//dynamic query 보안 이슈 때문에 수정
		if(((String)paramMap.get("businessPlaceCd")).length() == 0) {
			paramMap.put("tmpBizLoc","");
		} else {
			paramMap.put("tmpBizLoc",(String)paramMap.get("businessPlaceCd"));
		}
		
		Map fileData = selectOTaxMap("selectOTaxFileName", xmlPath+"/earnIncomeTaxCre/earnIncomeTaxCre.xml", paramMap);
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

		List listDataA = selectOTaxList("selectOTaxRecodeAContent", xmlPath+"/earnIncomeTaxCre/earnIncomeTaxCre.xml", paramMap);
		if(listDataA != null && listDataA.size() > 0) {
			
			for(int i = 0; i < listDataA.size(); i++) {
				Map mapDataA = (Map)listDataA.get(i);
				
				strBuf.append((String)mapDataA.get("content"));
				recodeCntA++;
				totalRecodeCnt++;
			}
			
			//A리스트 쓰기
			fileWrite(fileOut, strBuf);			
		}
		
		List listDataB = selectOTaxList("selectOTaxRecodeBContent", xmlPath+"/earnIncomeTaxCre/earnIncomeTaxCre.xml", paramMap);
		if(listDataB != null && listDataB.size() > 0) {
			strBuf.delete(0, strBuf.toString().length());
			for(int i = 0; i < listDataB.size(); i++) {
				Map mapDataB = (Map)listDataB.get(i);
				
				strBuf.append("\n").append((String)mapDataB.get("content"));
				recodeCntB++;
				totalRecodeCnt++;
			}
			
			//B리스트 쓰기
			fileWrite(fileOut, strBuf);			
		}

		List listDataC = selectOTaxList("selectOTaxRecodeCContent", xmlPath+"/earnIncomeTaxCre/earnIncomeTaxCre.xml", paramMap);
		String oldSabun = "";
		String sabun = "";
		
		if(listDataC != null && listDataC.size() > 0) {
			strBuf.delete(0, strBuf.toString().length());
			for(int i = 0; i < listDataC.size(); i++) {
				Map mapDataC = (Map)listDataC.get(i);
				strBuf.append("\n").append((String)mapDataC.get("content"));
				recodeCntC++;
				totalRecodeCnt++;
			}
			//C리스트 쓰기
			fileWrite(fileOut, strBuf);		
		}
		
		fileClose(fileOut);
		
		if(recodeCntA == 0 && recodeCntB == 0 && recodeCntC == 0) {
			Log.Debug("== content 데이터 조회중 오류 발생:신고대상 레코드가 존재하지 않습니다. ==");
			throw new UserException("신고대상 레코드가 존재하지 않습니다.");
		} else if(recodeCntC == 0) {
			Log.Debug("== content 데이터 조회중 오류 발생:C레코드의 수가 0 입니다. ==");
			throw new UserException("C레코드의 수가 0 입니다.");
		}
		
		Log.Debug("== content 데이터 조회 종료 ==");
		
		Log.Debug("== 결과 데이터 조회 시작 ==");
		
		Map rstData = selectOTaxMap("selectOTaxResult", xmlPath+"/earnIncomeTaxCre/earnIncomeTaxCre.xml", paramMap);
		if(rstData != null && rstData.get("pay_cnt") != null) 		payCnt = (String)rstData.get("pay_cnt");
		if(rstData != null && rstData.get("pay_tot_mon") != null) 	payTotMon = (String)rstData.get("pay_tot_mon");
		if(rstData != null && rstData.get("itax_tot_mon") != null) 	itaxTotMon = (String)rstData.get("itax_tot_mon");
		if(rstData != null && rstData.get("rtax_tot_mon") != null) 	rtaxTotMon = (String)rstData.get("rtax_tot_mon");
		
		if(rstData != null && rstData.size() == 0) {
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
	
	Log.Debug("============== [OTax(원천세) 종료] ===============");
	
	Map rtnData = new HashMap();
	if("1".equals(code)) {
		rtnData.put("serverSaveFileName", saveFileName); //서버 저장 파일명
		rtnData.put("viewSaveFileName", saveFileName.substring(0, saveFileName.lastIndexOf("."))); //화면에 보여줄 파일명
		rtnData.put("recodeCntA", StringUtil.formatMoney(String.valueOf(recodeCntA))); //A레코드수
		rtnData.put("recodeCntB", StringUtil.formatMoney(String.valueOf(recodeCntB))); //B레코드수
		rtnData.put("recodeCntC", StringUtil.formatMoney(String.valueOf(recodeCntC))); //C레코드수
		rtnData.put("payCnt", StringUtil.formatMoney(payCnt)); //결과(인원수)
		rtnData.put("payTotMon", StringUtil.formatMoney(payTotMon)); //결과(소득금액계)
		rtnData.put("itaxTotMon", StringUtil.formatMoney(itaxTotMon)); //결과(소득세계)
		rtnData.put("rtaxTotMon", StringUtil.formatMoney(rtaxTotMon)); //결과(주민세계)
		rtnData.put("filePrefix", filePrefix); //구분
	}
	Log.Debug("[OTax(원천세) 결과]: "+rtnData);
	
	Map mapCode = new HashMap();
	mapCode.put("Code", code);
	mapCode.put("Message", message);

	Map rstMap = new HashMap();
	rstMap.put("Result", mapCode);
	rstMap.put("Data", (Map)rtnData);
	out.print((new org.json.JSONObject(rstMap)).toString());	
%>
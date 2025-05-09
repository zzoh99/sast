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
	
	//프로시저 호출
	String[] type =  new String[]{"OUT","OUT","STR","STR","STR"
			,"STR","STR","STR","STR"
			,"STR","STR","STR","STR"
			,"STR","STR","STR","STR"};
	
	String[] param = new String[]{"", "", ssnEnterCd, tgtYear, declClass
			, curSysYyyyMMdd, bizLoc, declYmd, declPrsnClass
			, taxProxyNo, dataModCode, termCode, declDept, declEmp
			, declEmpTel, hometaxId, ssnSabun};

	String[] rstStr = null;
	try {
		rstStr = DBConn.executeProcedure("PKG_CPN_YEA_WOORI_"+tgtYear+"_DISK.DISKA4",type,param);
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

public Map getWooriYn(String queryId, Map paramMap, Map queryMap) throws Exception {
	
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

%>

<%
	//쿼리 맵 셋팅
	Map queryMap = setQueryMap(xmlPath+"/yeaNtsTax/yeaNtsTaxSC.xml");

	String ssnEnterCd = (String)session.getAttribute("ssnEnterCd");
	String ssnSabun = (String)session.getAttribute("ssnSabun");
	String cmd = request.getParameter("cmd");
	
	
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

    // 시큐어코딩으로 인하여 전달받은 파라미터 XSS체크 수행 20240801
   	if (ssnEnterCd == null || "".equals(ssnEnterCd)) {
   		ssnEnterCd = "" ;
   	} else {
   		ssnEnterCd = ssnEnterCd.replaceAll("/","");	
   		ssnEnterCd = ssnEnterCd.replaceAll("\\\\","");
   		ssnEnterCd = ssnEnterCd.replaceAll("\\.","");
   		ssnEnterCd = ssnEnterCd.replaceAll("&", "");	
   	}	
   	
	String saveFilePath = StringUtil.getPropertiesValue("WAS.PATH")+StringUtil.getPropertiesValue("HRFILE.PATH")+"/NTS_FILES/"+ssnEnterCd; //저장위치
	
	if("chkWooriYn".equals(cmd)) {
		Map rstMap  = new HashMap();
		
		try {
			rstMap = getWooriYn("chkWooriYn", paramMap, queryMap);
		} catch(Exception e) {
			throw new Exception("조회 중에 오류가 발생했습니다: " + e.getMessage());
		}
		out.print((new org.json.JSONObject(rstMap)).toString());
		
	} else {
	
		/*태영건설은 신고파일 저장경로를 변경해서 사용(태영건설 정화미님) - 2020.02.18.
		String saveFilePath = StringUtil.getPropertiesValue("NFS.HRFILE.PATH")+"/NTS_FILES/"+ssnEnterCd; //저장위치
		*/
		StringBuffer strBuf = new StringBuffer(); //각 데이터를 담을 버퍼
		
		int recodeCntA = 0;		//A레코드수 
		int recodeCntB = 0;		//B레코드수
		
		FileOutputStream fileOut = null;
		
		Log.Debug("============== [NTSTAX SC(우리사주배당금) 시작] ===============");
	
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
			
			Map fileData = selectYeaNtsTaxMap("selectYeaNtsTaxSCFileName", paramMap, queryMap);
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
	
			List listDataA = selectYeaNtsTaxList("selectYeaNtsTaxSCContent", paramMap, queryMap);
			if(listDataA != null && listDataA.size() > 0) {
				strBuf.delete(0, strBuf.toString().length());
	
				for(int i = 0; i < listDataA.size(); i++) {
					Map mapDataA = (Map)listDataA.get(i);
					
					strBuf.append((String)mapDataA.get("content"));
					recodeCntA++;
				}
	
				//A리스트 쓰기
				fileWrite(fileOut, strBuf);
			}		
	
			List listDataB = selectYeaNtsTaxList("selectYeaNtsTaxSCBContent", paramMap, queryMap);
			if(listDataB != null && listDataB.size() > 0) {
	
				for(int jj = 0; jj < listDataB.size(); jj++) {
					strBuf.delete(0, strBuf.toString().length());
					Map mapDataB = (Map)listDataB.get(jj);
					
					strBuf.append("\n").append((String)mapDataB.get("content"));
	
					recodeCntB++;			
	
					//B리스트 쓰기
					fileWrite(fileOut, strBuf);
					
					
	
				}
			}		
			fileClose(fileOut);
	
			if(recodeCntA == 0 && recodeCntB == 0) {
				Log.Debug("== content 데이터 조회중 오류 발생:신고대상 우리사주배당금 레코드가 존재하지 않습니다. ==");
				throw new UserException("신고대상 우리사주배당금 레코드가 존재하지 않습니다.");
			} else if(recodeCntB == 0) {
				Log.Debug("== content 데이터 조회중 오류 발생:B레코드의 수가 0 입니다. ==");
				throw new UserException("B레코드의 수가 0 입니다.");
			}
	
			Log.Debug("== content 데이터 조회 종료 ==");
			
			
			//************************* 데이터 조회 종료 *************************//
			
		} catch(UserException ue) {
			Log.Debug("[UserException]" + ue.getMessage());
			code = "-1";
			message = ue.getMessage();
		} catch(Exception ex) {
			Log.Error("[yeaNtsTaxSCRst]:" + ex.getMessage());
			code = "-1";
			message = ex.toString();
		} finally {
			try{
				if(fileOut != null) {
					fileClose(fileOut);
				}
			} catch(Exception ex) {
				Log.Error("[yeaNtsTaxSCRst]: finally " + ex.getMessage());
				code = "-1";
				message = ex.toString();
			}
		}
		
		Log.Debug("============== [NTSTAX SC(우리사주배당금) 종료] ===============");
		
		Map rtnData = new HashMap();
		if("1".equals(code)) {
			rtnData.put("serverSaveFileName", saveFileName); //서버 저장 파일명
			rtnData.put("viewSaveFileName", saveFileName.substring(0, saveFileName.lastIndexOf("."))); //화면에 보여줄 파일명
			rtnData.put("recodeCntA", StringUtil.formatMoney(String.valueOf(recodeCntA))); //A레코드수
			rtnData.put("recodeCntB", StringUtil.formatMoney(String.valueOf(recodeCntB))); //B레코드수
			rtnData.put("filePrefix", filePrefix); //구분
		}
		Log.Debug("[NTSTAX SC(우리사주배당금) 결과]: "+rtnData);
		
		Map mapCode = new HashMap();
		mapCode.put("Code", code);
		mapCode.put("Message", message);
	
		Map rstMap = new HashMap();
		rstMap.put("Result", mapCode);
		rstMap.put("Data", (Map)rtnData);
		out.print((new org.json.JSONObject(rstMap)).toString());
	}
%>
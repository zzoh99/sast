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
public String[] prcYeaNtsDisk(Map paramMap, Map queryMap) throws Exception {
	
	String ssnEnterCd = (String)paramMap.get("ssnEnterCd");
	String ssnSabun = (String)paramMap.get("ssnSabun");
	String curSysYyyyMMdd = yjungsan.util.DateUtil.getDateTime("yyyyMMdd");
	String tgtYear = (String)paramMap.get("tgtYear");
	String declClass = (String)paramMap.get("declClass");
	String bizLoc = (String)paramMap.get("bizLoc");
	String declYmd = (String)paramMap.get("declYmd");
	String hometaxId = (String)paramMap.get("hometaxId");
	String includeYn = (String)paramMap.get("includeYn");
	String termCode = (String)paramMap.get("termCode");

	if(bizLoc != null && bizLoc.length() == 0) {
		bizLoc = "%";
	}
	
	//프로시저 호출
	String[] type =  new String[]{"OUT","OUT","STR","STR","STR"
			,"STR","STR","STR","STR","STR"
			,"STR","STR"};
	String[] param = new String[]{"", "", ssnEnterCd, tgtYear, declClass
			,curSysYyyyMMdd, bizLoc, declYmd, hometaxId, ssnSabun
			,includeYn, termCode};

	String[] rstStr = null;
	try {
		rstStr = DBConn.executeProcedure("PKG_CPN_YEA_"+tgtYear+"_DISK.DISKA1",type,param);
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

%>

<%
	//Logger log = Logger.getLogger(this.getClass());

	//쿼리 맵 셋팅
	Map queryMap = setQueryMap(xmlPath+"/yeaNtsTax/yeaNtsTaxCA.xml");

	String ssnEnterCd = (String)session.getAttribute("ssnEnterCd");
	String ssnSabun = (String)session.getAttribute("ssnSabun");

	Map mp = StringUtil.getRequestMap(request);
	mp.put("ssnEnterCd", ssnEnterCd);
	mp.put("ssnSabun", ssnSabun);
	
	Map paramMap =  StringUtil.getParamMapData(mp);
	String filePrefix = (String)paramMap.get("filePrefix");
	String tgtYear = (String)paramMap.get("tgtYear");
	String declYmd = (String)paramMap.get("declYmd");
	String message = "";	//오류 메시지
	String code = "1";		//결과 성공여부(1:성공)
	String saveFileName = ""; //저장 파일명
	String saveFilePath = StringUtil.getPropertiesValue("WAS.PATH")+StringUtil.getPropertiesValue("HRFILE.PATH")+"/NTS_FILES/"+ssnEnterCd; //저장위치
	/*태영건설은 신고파일 저장경로를 변경해서 사용(태영건설 정화미님) - 2020.02.18.
	String saveFilePath = StringUtil.getPropertiesValue("NFS.HRFILE.PATH")+"/NTS_FILES/"+ssnEnterCd; //저장위치
	*/
	StringBuffer strBuf = new StringBuffer(); //각 데이터를 담을 버퍼

	String totalMon = "0";	//결과(총금액)
	int recodeCnt = 0;		//레코드수
	
	Log.Debug("============== [NTSTAX CA(의료비) 시작] ===============");

	try {
		//************************* 자료생성 프로시저 호출 시작 *************************//
		Log.Debug("== 자료생성 프로시저 호출 시작 ==");
		
		String[] rstStr = prcYeaNtsDisk(paramMap, queryMap);
		
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

		Map fileData = selectYeaNtsTaxMap("selectYeaNtsTaxCAFileName", paramMap, queryMap);
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

		List listData = selectYeaNtsTaxList("selectYeaNtsTaxCAContent", paramMap, queryMap);
		if(listData != null && listData.size() > 0) {
			for(int i = 0; i < listData.size(); i++) {
				Map mapData = (Map)listData.get(i);
				
				strBuf.append((String)mapData.get("content")).append("\n");
				recodeCnt++;
			}
		} else {
			Log.Debug("== content 데이터 조회중 오류 발생:신고대상 의료비 레코드가 존재하지 않습니다. ==");
			throw new UserException("신고대상 의료비 레코드가 존재하지 않습니다.");
		}
		
		if(strBuf.length() > 0) {
			strBuf.delete(strBuf.length()-1, strBuf.length());
		}
		
		Log.Debug("== content 데이터 조회 종료 ==");
		
		Log.Debug("== 결과 데이터 조회 시작 ==");
		
		Map rstData = selectYeaNtsTaxMap("selectYeaNtsTaxCAResult", paramMap, queryMap);
		if(rstData != null && rstData.get("total_mon") != null) {
			totalMon = (String)rstData.get("total_mon");
		} else {
			Log.Debug("== 결과 데이터 조회중 오류 발생:결과 데이터가 존재하지 않습니다. ==");
			throw new UserException("결과 데이터가 존재하지 않습니다.");
		}

		Log.Debug("== 결과 데이터 조회 종료 ==");
		//************************* 데이터 조회 종료 *************************//

		//************************* 파일쓰기 시작 *************************//
		Log.Debug("== 파일 쓰기 시작 ==");
		
		// 디렉토리 만들기
		File dir = new File(saveFilePath);
		if(!dir.exists()) {
			dir.mkdirs();
		}
		
		FileOutputStream fileOut = null;
		fileOut = new FileOutputStream(saveFilePath+"/"+saveFileName);
		fileOut.write(strBuf.toString().getBytes("euc-kr"));
		fileOut.flush();
		fileOut.close();
		
		Log.Debug("== 파일 쓰기 종료 ==");
		
		//************************* 파일쓰기 종료 *************************//
		
	} catch(UserException ue) {
		Log.Debug("[UserException]" + ue.getMessage());
		code = "-1";
		message = ue.getMessage();
	} catch(Exception ex) {
		//ex.printStackTrace();
		code = "-1";
		message = ex.toString();
	}
	
	Log.Debug("============== [NTSTAX CA(의료비) 종료] ===============");
	
	Map rtnData = new HashMap();
	if("1".equals(code)) {
		rtnData.put("serverSaveFileName", saveFileName); //서버 저장 파일명
		rtnData.put("viewSaveFileName", saveFileName.substring(0, saveFileName.lastIndexOf("."))); //화면에 보여줄 파일명
		rtnData.put("recodeCnt", StringUtil.formatMoney(String.valueOf(recodeCnt))); //레코드수
		rtnData.put("totalMon", StringUtil.formatMoney(String.valueOf(totalMon))); //결과(총금액)
		rtnData.put("filePrefix", filePrefix); //구분
	}
	Log.Debug("[NTSTAX CA(의료비) 결과]: "+rtnData);
	
	Map mapCode = new HashMap();
	mapCode.put("Code", code);
	mapCode.put("Message", message);

	Map rstMap = new HashMap();
	rstMap.put("Result", mapCode);
	rstMap.put("Data", (Map)rtnData);
	out.print((new org.json.JSONObject(rstMap)).toString());
%>
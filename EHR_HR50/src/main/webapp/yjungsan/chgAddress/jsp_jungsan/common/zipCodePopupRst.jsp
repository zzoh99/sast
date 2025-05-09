<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="yjungsan.util.*"%>

<%@ page import="java.util.List"%>
<%@ page import="java.util.ArrayList"%>
<%@ page import="java.util.Map"%>
<%@ page import="java.util.HashMap"%>

<%@ page import="com.hr.common.logger.Log" %>
<%@ page import="java.util.StringTokenizer"%>
<%@ page import="java.io.Serializable"%>

<%@ include file="../common/include/session.jsp"%>


<%!
//private Logger log = Logger.getLogger(this.getClass());

//xml 파서를 이용한 방법;
public Map setQueryMap(String path) {
	return XmlQueryParser.getQueryMap(path);
}

//우편번호 갯수 조회
public String selectZipCodeListCnt(Map paramMap, Map queryMap) throws Exception {

	//파라메터 복사.
	Map pm =  StringUtil.getParamMapData(paramMap);
	Map mapData = null;
	String totalCnt = "0";

	try{
		//쿼리 실행및 결과 받기.
		mapData  = (queryMap==null) ? null : DBConn.executeQueryMap(queryMap,"selectZipCodeListCnt",pm);
		totalCnt = (mapData==null||mapData.get("total_cnt")==null) ? "0" : (String)mapData.get("total_cnt");

	} catch (Exception e) {
		Log.Error("[Exception] " + e);
		throw new Exception("조회에 실패하였습니다.");
	}

	return totalCnt;
}

//우편번호 조회
public List selectZipCodeList(Map paramMap, Map queryMap) throws Exception {

	//파라메터 복사.
	Map pm =  StringUtil.getParamMapData(paramMap);
	List listData = null;

	try{
		//쿼리 실행및 결과 받기.
		listData  = (queryMap == null) ? null : DBConn.executeQueryList(queryMap,"selectZipCodeList",pm);
	} catch (Exception e) {
		Log.Error("[Exception] " + e);
		throw new Exception("조회에 실패하였습니다.");
	}

	return listData;
}
%>

<%
	//쿼리 맵 셋팅
	Map queryMap =  setQueryMap(xmlPath+"/zipCodePopup.xml");

	String ssnEnterCd = (String)session.getAttribute("ssnEnterCd");
	String ssnSabun = (String)session.getAttribute("ssnSabun");
	String cmd = (String)request.getParameter("cmd");

	if("selectZipCodeList".equals(cmd)) {
		//우편번호 조회

		Map mp = StringUtil.getRequestMap(request);
		mp.put("ssnEnterCd", ssnEnterCd);
		mp.put("ssnSabun", ssnSabun);

		Map cm =  StringUtil.getParamMapData(mp);

		String searchWord	= cm.get("searchWord").toString().replaceAll("-"," ");
		StringBuffer query = new StringBuffer();

		query.setLength(0);

		if(searchWord.trim().length() ==0 ){

			query.append(" AND 1 = 2)");
		}
		else{


			StringTokenizer st = new StringTokenizer(searchWord);
			List<Serializable> sword = new ArrayList<Serializable>();


			while(st.hasMoreTokens()) {
				String tocken = st.nextToken();
				sword.add(tocken);
			}

			for( int i = 0 ; i < sword.size() ; i ++ ){
				query.append(" AND "
							+ "("
							+ " SIDO LIKE '"+sword.get(i)+"%'"
							+ " OR SIGUNGU LIKE '"+sword.get(i)+"%'"
							+ " OR UPMYON LIKE '"+sword.get(i)+"%'"
							+ " OR ROAD_NAME LIKE '"+sword.get(i)+"%'"
							+ " OR SIGUNGUBD_NAME LIKE '"+sword.get(i)+"%'"
							+ " OR BDNO_M LIKE '"+sword.get(i)+"%'"
							+ " OR BDNO_S LIKE '"+sword.get(i)+"%'"
							+ " OR LAW_DONG_NAME LIKE '"+sword.get(i)+"%'"
							+ " OR GOV_DONG_NAME  LIKE '"+sword.get(i)+"%'"
							+ " OR JIBUN_M LIKE '"+sword.get(i)+"%'"
							+ " OR JIBUN_S LIKE '"+sword.get(i)+"%'"
							+ " )");
			}

		}
		mp.put("query", query.toString());


		/*
		String searchWord	= cm.get("searchWord").toString();
		String searchWord1  = ""; //ROAD_NAME
		String searchWord2  = ""; //BDNO_M
		String searchWord3  = ""; //BDNO_S

		String[] arrNewWord = searchWord.split(" ");

			for (int i=0; i < arrNewWord.length; ++i) {
			if(i==0){
				searchWord1 = arrNewWord[i].toString();
			}else if (i==1){
				String[] arrBdno = arrNewWord[i].split("-");
				searchWord2 = arrBdno[0].toString();
				searchWord3 = (arrNewWord[i].indexOf("-") >= 0)? arrBdno[1].toString():"";
			}
		}

		mp.put("searchWord1", searchWord1);
		mp.put("searchWord2", searchWord2);
		mp.put("searchWord3", searchWord3);

		*/

		List listData  = new ArrayList();
		String message = "";
		String code = "1";
		String totalCnt = "0";

		try {
			totalCnt = selectZipCodeListCnt(mp, queryMap);
			listData = selectZipCodeList(mp, queryMap);
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
		rstMap.put("TOTAL", totalCnt);
		out.print((new org.json.JSONObject(rstMap)).toString() );

	}
%>
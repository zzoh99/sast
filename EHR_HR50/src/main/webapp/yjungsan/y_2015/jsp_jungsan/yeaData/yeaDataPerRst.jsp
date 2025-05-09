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
//인적공제 자료 조회
public List selectYeaDataPerList(Map paramMap, String locPath) throws Exception {

	//파라메터 복사.
	Map pm =  StringUtil.getParamMapData(paramMap);
	Map queryMap = XmlQueryParser.getQueryMap(locPath);
	List listData = null;
	
	try{
		//쿼리 실행및 결과 받기.
		listData  = (queryMap == null) ? null : DBConn.executeQueryList(queryMap,"selectYeaDataPerList",pm);
	} catch (Exception e) {
		Log.Error("[Exception] " + e);
		throw new Exception("조회에 실패하였습니다.");
	}
	
	return listData;
}

%>

<%
	String locPath = xmlPath+"/yeaData/yeaDataPer.xml";

	String ssnEnterCd = (String)session.getAttribute("ssnEnterCd");
	String ssnSabun = (String)session.getAttribute("ssnSabun");
	String cmd = (String)request.getParameter("cmd");

	if("selectYeaDataPerList".equals(cmd)) {
		//인적공제 자료 조회
		
		Map mp = StringUtil.getRequestMap(request);
		mp.put("ssnEnterCd", ssnEnterCd);
		mp.put("ssnSabun", ssnSabun);
		
		List listData  = new ArrayList();
		String message = "";
		String code = "1";
	
		try {
			listData = selectYeaDataPerList(mp, locPath);
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
		
	} else if("saveYeaDataPer".equals(cmd)) {
		//인적공제 저장.
		
		Map paramMap = StringUtil.getRequestMap(request);
		List saveList = StringUtil.getParamListData(paramMap);
		
		String[] type =  new String[]{"OUT","OUT","STR","STR","STR"
				,"STR","STR","STR","STR","STR"
				,"STR","STR","STR","STR","STR"
				,"STR","STR","STR","STR","STR"};
		
		String message = "";
		String code = "1";
		int cnt = 0;
		
		try {

			if(saveList != null && saveList.size() > 0) {
				for(int i = 0; i < saveList.size(); i++) {
					Map mp = (Map)saveList.get(i);
					String sStatus = (String)mp.get("sStatus");
					String workYy = (String)mp.get("work_yy");
					String adjustType = (String)mp.get("adjust_type");
					String sabun = (String)mp.get("sabun");
					String famres = (String)mp.get("famres");
					String famCd = (String)mp.get("fam_cd");
					String famNm = (String)mp.get("fam_nm");
					String dpndntYn = (String)mp.get("dpndnt_yn");
					String spouseYn = (String)mp.get("spouse_yn");
					String seniorYn = (String)mp.get("senior_yn");
					String hndcpYn = (String)mp.get("hndcp_yn");
					String hndcpType = (String)mp.get("hndcp_type");
					String womanYn = (String)mp.get("woman_yn");
					String oneParentYn = (String)mp.get("one_parent_yn");
					String child_yn = (String)mp.get("child_yn");
                    String adopt_born_yn = (String)mp.get("adopt_born_yn");
					
					String[] param = new String[]{"","",sStatus,ssnEnterCd,workYy
							,adjustType,sabun,famres,famCd,famNm
							,dpndntYn,spouseYn,seniorYn,hndcpYn,hndcpType
							,womanYn ,oneParentYn,child_yn,adopt_born_yn,ssnSabun};
					
					String[] rstStr = DBConn.executeProcedure("PKG_CPN_YEA_"+yeaYear+"_SYNC.FAMILY_INS",type,param);
					
					if(rstStr[1] == null || rstStr[1].length() == 0) {
						cnt++;
					} else {
						message = message + "\n\n" + rstStr[1];
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
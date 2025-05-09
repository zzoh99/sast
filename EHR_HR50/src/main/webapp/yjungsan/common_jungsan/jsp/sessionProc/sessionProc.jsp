<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="java.util.*"%>
<%@ page import="yjungsan.util.*"%>
<%!
//기준정보조회
public Map selectSystemStdInfo(Map paramMap, String xmlPath) throws Exception {

	//파라메터 복사.
	Map pm =  StringUtil.getParamMapData(paramMap);
	Map map = null;
	
	try{
		Map queryMap = XmlQueryParser.getQueryMap(xmlPath);
		//쿼리 실행및 결과 받기.
		map  = (queryMap==null) ? null : DBConn.executeQueryMap(queryMap,"selectSystemStdInfo",pm);
	} catch (Exception e) {
		//throw new Exception("조회에 실패하였습니다.");
		map = null;
	}
	
	return map;
}

%>
<%

try {
	
	/* 발레오만 우선 적용하기 위해 기본적으로 주석 처리 : 사용할때는 주석 풀어서 적용 - 2020.02.04.
	String ssnEnterCd = session.getAttribute("ssnEnterCd")==null?"":session.getAttribute("ssnEnterCd").toString();
	String ssnSabun = session.getAttribute("ssnSabun")==null?"":session.getAttribute("ssnSabun").toString();
	String cmd = session.getAttribute("cmd")==null?"":session.getAttribute("cmd").toString();
	
    //시스템 버전(1 = ActiveX, 2=html)
    String xmlPathSessionProc = "";
    if("1".equals(StringUtil.getPropertiesValue("SYS.VERSION"))) {
    	xmlPathSessionProc = session.getServletContext().getRealPath("/JSP/yjungsan/common_jungsan/xml_query");
    } else {
    	xmlPathSessionProc = session.getServletContext().getRealPath("/yjungsan/common_jungsan/xml_query");
    }
    
    
  	//쿼리 맵 셋팅
  	xmlPathSessionProc = xmlPathSessionProc + "/sessionProc/sessionProc.xml";

	Map mp = new HashMap();
	mp.put("ssnEnterCd", ssnEnterCd);
	mp.put("stdCd", "CPN_YEA_SESSION_INIT_YN");
	
	Map mapData = selectSystemStdInfo(mp, xmlPathSessionProc);
	
	//System.out.println("session_init_yn>>>>>>>>"+mapData.toString());
	
	if(mapData != null && mapData.get("std_cd_value") != null && mapData.get("std_cd_value").toString().equals("Y")) {
		
		mp = new HashMap();
		mp.put("ssnEnterCd", ssnEnterCd);
		mp.put("stdCd", "CPN_YEA_SESSION_INIT_MINUTE");
		
		Map mapData2 = selectSystemStdInfo(mp, xmlPathSessionProc);
		
		
		
		if(mapData2 != null && mapData2.get("std_cd_value") != null) {
						
			String s = mapData2.get("std_cd_value").toString();
			boolean isNum = s.matches("-?\\d+(\\.\\d+)?");
			
			//System.out.println("session_init_time>>>>>>>>"+ s);
			
			if(isNum) {
				session.setMaxInactiveInterval(Integer.parseInt(s, 10)*60);
			} else {
				session.setMaxInactiveInterval(30*60); //30분
			}
		}
	}
	*/

} catch(Exception e) {
    throw new Exception();
}
%>

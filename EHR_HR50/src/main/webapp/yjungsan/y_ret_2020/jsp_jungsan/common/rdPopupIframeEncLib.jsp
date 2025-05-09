<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="yjungsan.util.*"%>
<%@ page import="java.io.*,java.util.*,enc.*" %>
<%@ page import="org.json.simple.JSONObject"%>
<%
	//본 파일은 rdPopupIframe.jsp > rdPopupIframeEnc.jsp 에서 참조됩니다.
    /* ************************************************************************* 
	20231226 
	---------------------------------------------------------------------
	M2SOFT enc.jar 라이브러리를 참조하여 mrd path와 파라미터를 암호화 
	::오토에버버전, v5.0 디폴트 - HMM, 호반, BGF)
	************************************************************************* */
	Map Rmp = StringUtil.getRequestMap(request);	 
	Map Pmp = StringUtil.getParamMapData(Rmp);

	String mrd_path  = (String)Pmp.get("mrd_path");
	String mrd_param = (String)Pmp.get("mrd_param");

	//System.out.println("[mrd_path] " + mrd_path);
	//System.out.println("[mrd_param] " + mrd_param);
	
	C.setCharset("UTF-8");
	int type =11;
	
	mrd_path  = new String(C.process(mrd_path,type));	
	mrd_param = new String(C.process(mrd_param,type));

	//System.out.println("[Enc_Mrd_path] " + mrd_path);
	//System.out.println("[Enc_Mrd_param] " + mrd_param);
	
	// json 형태로 리턴하기 위한 json객체 생성
    JSONObject jobj = new JSONObject();
	jobj.put("Enc_Type", type);
	jobj.put("Enc_Mrd_path", mrd_path);
	jobj.put("Enc_Mrd_param", mrd_param);
	
    // 응답시 json 타입이라는 걸 명시 ( 안해주면 json 타입으로 인식하지 못함 )
	response.setContentType("application/json");
	out.print(jobj.toJSONString()); // json 형식으로 출력
%>
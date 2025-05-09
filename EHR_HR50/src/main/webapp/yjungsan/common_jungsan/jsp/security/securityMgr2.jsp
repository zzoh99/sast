<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="yjungsan.util.*"%>
<%@ page import="yjungsan.util.StringUtil"%>
<%@ page import="java.util.Map"%>
<%@ page import="java.util.HashMap"%>
<%@ page import="com.hr.common.logger.Log" %>
<%@ page import="org.json.JSONObject" %>
<%@ page import="java.util.Iterator" %>
<%@ page import="java.util.Properties"%>
<%@ page import="java.io.InputStream"%>

<%!
public String securityCheck(HttpServletRequest request, String sClientIP, String securityXmlPath) throws Exception {
//보안체크
    try{
        HttpSession session = request.getSession(false);

        String relativeUrlYjungsan = StringUtil.getRelativeUrl(request);
        String commPageYjungsan = "";
        String extYjungsan = "";

        if ( relativeUrlYjungsan.lastIndexOf("/") > -1 ) {
            extYjungsan = relativeUrlYjungsan.substring(relativeUrlYjungsan.lastIndexOf("/"));

            if ( relativeUrlYjungsan.lastIndexOf("/jsp_jungsan/") > -1 ) {
                commPageYjungsan = relativeUrlYjungsan.substring(relativeUrlYjungsan.lastIndexOf("/jsp_jungsan/"), relativeUrlYjungsan.lastIndexOf("/")+1);
            }
        }

        if ( "/jsp_jungsan/common/".equals(commPageYjungsan)
                && ( "/commonCode.jsp".equals(extYjungsan)||"/commonSelect.jsp".equals(extYjungsan) ) ) {
            //공통 디렉토리 아래의 파일

        } else if ( relativeUrlYjungsan.lastIndexOf("Rst.jsp")==(relativeUrlYjungsan.length()-7)
                    || relativeUrlYjungsan.lastIndexOf("Rst2.jsp")==(relativeUrlYjungsan.length()-8) ) {
            //Rst파일
		
        } else if(relativeUrlYjungsan.indexOf("popupg") > 0 || relativeUrlYjungsan.indexOf("newZipCodePopup") > 0 || relativeUrlYjungsan.indexOf("pdfViewPop.jsp") > 0 
        		|| relativeUrlYjungsan.indexOf("befComMgrPopup.jsp") > 0 || relativeUrlYjungsan.indexOf("yeaDataAddFileUploadPop.jsp") > 0){
        	
        } else {
            String isAccessPage = "";

            //1.1. 권한체크/로그인 체크/세션변조
            Map queryMapYjungsanAuth =XmlQueryParser.getQueryMap(securityXmlPath+"/security/securityMgr.xml");

            Map logYnParam = new HashMap();
            logYnParam.put("ssnEnterCd" ,(String)session.getAttribute("ssnEnterCd"));

            Map logYnMp  = DBConn.executeQueryMap(queryMapYjungsanAuth, "getCpnYeaLogYn", logYnParam);

            Map mpYjungsanAuth = new HashMap();
            //쿼리 맵 셋팅
            mpYjungsanAuth.put("ssnSecurityDetail",(session.getAttribute("ssnSecurityDetail")==null?"":(String)session.getAttribute("ssnSecurityDetail")));//보안체크 개별 체크 여부
            mpYjungsanAuth.put("ssnEnterCd" ,(String)session.getAttribute("ssnEnterCd"));
            mpYjungsanAuth.put("ssnSabun"   ,(String)session.getAttribute("ssnSabun"));
            mpYjungsanAuth.put("ssnGrpCd"   ,(String)session.getAttribute("ssnGrpCd"));
            mpYjungsanAuth.put("cmd"        ,(request.getParameter("cmd")==null?"":(String)request.getParameter("cmd")));
            mpYjungsanAuth.put("ssnAdmin"   ,(session.getAttribute("ssnAdmin")==null?"":(String)session.getAttribute("ssnAdmin")));
            mpYjungsanAuth.put("clientIp"   ,sClientIP);
            mpYjungsanAuth.put("sessionId"  ,session.getId());
            mpYjungsanAuth.put("relUrl"     ,relativeUrlYjungsan);
            mpYjungsanAuth.put("ssnlogYn"   ,logYnMp);
            mpYjungsanAuth.put("ssnSearchType" ,(String)session.getAttribute("ssnSearchType"));



            //String mrdYjungsan = (String)request.getParameter("rdMrd");

            String mrdYjungsan = String.valueOf(request.getParameter("rdMrd"))== "null" ? "" : String.valueOf(request.getParameter("rdMrd"));

            if( mrdYjungsan.length() != 0) {mrdYjungsan = mrdYjungsan.substring(mrdYjungsan.lastIndexOf("/")+1);}
            mpYjungsanAuth.put("mrd",       (mrdYjungsan==null?"":mrdYjungsan));
            //mpYjungsanAuth.put("rdParam",     ((String)request.getParameter("rdParam")==null?"":(String)request.getParameter("rdParam")));
            mpYjungsanAuth.put("rdParam",   (String.valueOf(request.getParameter("rdParam"))== "null" ? "" : String.valueOf(request.getParameter("rdParam"))));
            
            //20240409 [명세서/국세청신고 > 원천징수영수증]에서 전체 인원 선택하여 MRD 출력할 때 오류나는 원인
            // 1. F_SEC_GET_AUTH_CHK_YJUNGSAN 파라미터 중 rdParam이 4000 BYTE를 초과할 때
            // 2. F_SEC_GET_AUTH_CHK_YJUNGSAN 내부에서 TSEC010.PARAM에 INSERT 할 때, VARCHAR2(1000 BYTE)를 초과할 때
            mpYjungsanAuth.put("rdParam",   StringUtil.cutText(String.valueOf(mpYjungsanAuth.get("rdParam")), 950, true) );

            if( mrdYjungsan != null && mrdYjungsan.length() != 0) {
                Log.Debug(">>■■■■■■■■■■■■■■■■■■■ ");
                Log.Debug(">>"+ mrdYjungsan);
                Log.Debug(">>"+ mrdYjungsan.substring(mrdYjungsan.lastIndexOf("/")+1));
                Log.Debug(">>"+ mpYjungsanAuth);
                Log.Debug(">>■■■■■■■■■■■■■■■■■■■ ");
            }

            //1.1.1. //체크 프로시저 호출및 결과 받기.
            Map rstMp  = DBConn.executeQueryMap(queryMapYjungsanAuth, "PrcCall_F_SEC_GET_AUTH_CHK_YJUNGSAN", mpYjungsanAuth);

            Log.Debug("PrcCall_F_SEC_GET_AUTH_CHK_YJUNGSAN : " + rstMp );
            String result = (rstMp == null||rstMp.get("result") == null) ? "" : (String)rstMp.get("result");

            JSONObject jObject  = new JSONObject(result); //CODE, SECURITY_KEY, DATA_RW_TYPE, DATA_PRG_TYPE
            String code = (jObject == null) ? "" : jObject.getString("CODE");

            if( code != null && code.equals("0")){

                String securityKey = jObject.getString("SECURITY_KEY");

                if(  securityKey != null && !securityKey.equals("")){ //securityKey
                    request.setAttribute("securityKey", securityKey);
                    request.setAttribute("sKey", jObject.optString("SABUN_KEY")); 
                    request.setAttribute("gKey", jObject.optString("GRPCD_KEY"));
                    request.setAttribute("sType", jObject.optString("STYPE_KEY"));
                    request.setAttribute("qId", jObject.optString("SQLID_KEY"));
                } else {
                    request.setAttribute("securityKey", "");
                }
            }else{
                return code; //에러
            }
        }

        //1.2. 조회구분이 '자신만조회'이고, 파라미터 변조 체크(P)를 할 경우 param조작 체크
        if ( "P".equals((String)session.getAttribute("ssnSearchType"))
                && ((String)session.getAttribute("ssnSecurityDetail")).indexOf("P") > -1 ) {
            String ssnCheckSabun = (String)session.getAttribute("ssnCheckSabun"); //체크 파라미터 명
            String arr[] = ssnCheckSabun.split(",");
            for(int i = 0; i < arr.length; i++) {
                String str = String.valueOf(request.getParameter(arr[i]));
                //1.2.2. 체크 파라미터값이 변조 된 경우
                if( str != null && !"null".equals(str) && !"-1".equals(str) && !"".equals(str) && !str.equals((String)session.getAttribute("ssnSabun")) ){
                    Log.Debug("■■■■■■■■■■■■■■■■■■■ 파라미터 변조 체크 ■■■■■■■■■■■■■■■■■■■■■■■■");
                    Log.Debug("name :" + arr[i] +", param : "+request.getParameter(arr[i]) +", session : "+(String)session.getAttribute("ssnSabun"));
                    session.setAttribute("errorMsg", "[sabun="+str+"]");
                    return "993";
                }
            }
        }
    } catch(Exception e) {

        Log.Debug("□□□□□□□□□□□□□□□□□□□□□ Exception 보안체크 실패! " + e.getMessage() );
        return "에러";
    }
    return "";
}

public String decryptUrl(HttpServletRequest request, String securityXmlPath) {
//암호화URL 조회

    String rtnStr = "";
    try{
        HttpSession session = request.getSession(false);

        Map queryMapYjungsan =XmlQueryParser.getQueryMap(securityXmlPath+"/security/securityMgr.xml");
        //쿼리 맵 셋팅
        Map mpYjungsan = new HashMap();

        mpYjungsan.put("url"            , (request.getParameter("surl")==null?"":(String)request.getParameter("surl")));
        mpYjungsan.put("ssnEncodedKey"  , (session.getAttribute("ssnEncodedKey")==null?"":(String)session.getAttribute("ssnEncodedKey")));
        mpYjungsan.put("ssnEnterCd"     , (String)session.getAttribute("ssnEnterCd"));

        //암호화URL 조회 쿼리 실행및 결과 받기.
        Map rstMp  = DBConn.executeQueryMap(queryMapYjungsan, "getDecryptUrl", mpYjungsan);

        String rn =rstMp.get("sjson").toString();

        JSONObject jObject = new JSONObject(rn);
        Iterator keys = jObject.keys();

        String key   = "";
        String value = "";
        String dataRwType = "";
        String dataPrgType = "";

        while( keys.hasNext() ){
            key = (String)keys.next();
            value = jObject.getString(key);
            if ( "dataRwType".equals(key) )  dataRwType  = value;
            if ( "dataPrgType".equals(key) ) dataPrgType = value;
        }
        if(  dataPrgType != null && "P".equals(dataPrgType)){  //프로그램 권한.
            rtnStr = dataRwType;
        }else{
            rtnStr = (String)session.getAttribute("ssnDataRwType");
        }

    } catch(Exception e) {
        Log.Debug("□□□□□□□□□□□□□□□□□□□□□ Exception 암호화URL 조회 실패! " + e.getMessage() );
    }
    return rtnStr;
}

public void saveError(HttpServletRequest request, String sClientIP, String securityXmlPath, String code) {

    try{
        HttpSession session = request.getSession(false);

        String msg = "Error";
        /*
         * 990 : 로그인 정보가 DB에 존재하지 않음
         * 991 : 세션 변조
         * 992 : 중복 로그인
         * 993 : 파라미터 변조
         * 994 : 권한 없는 화면 접근
         * 995 : URL 직접 접근
         */
        if( code.equals("990")){
            msg = "로그인 정보가 DB에 존재하지 않음";
        }else if( code.equals("991")){
            msg = "세션 변조";
        }else if( code.equals("992")){
            msg = "중복 로그인";
        }else if( code.equals("993")){
            msg = "파라미터 변조 => " + session.getAttribute("errorMsg");
        }else if( code.equals("994")){
            msg = "권한 없는 화면 접근";
        }else if( code.equals("995")){
            msg = "URL 직접 접근";
        }

        String[] type =  new String[]{"STR","STR","STR","STR","STR"
                                    ,"STR","STR","STR","STR","STR"
                                    ,"STR"};

        String[] param = new String[]{(String)session.getAttribute("ssnEnterCd"),"view",sClientIP,"",(String)session.getAttribute("errorUrl")
                                    ,"",code,"",(String)session.getAttribute("ssnGrpCd"),msg
                                    ,(String)session.getAttribute("ssnSabun")};
        //에러로그 프로시저 호출.
        DBConn.executeProcedure("P_COM_SET_OBSERVER",type,param);
        Log.Debug("P_COM_SET_OBSERVER : ");

    } catch(Exception e) {
        Log.Debug("□□□□□□□□□□□□□□□□□□□□□ Exception 에러로그 등록 실패! " + e.getMessage() );
    }
}
public String getYeaLogYn(HttpServletRequest request, String securityXmlPath) throws Exception {
	   //연말정산 로그여부 세션세팅
	try{
		HttpSession session = request.getSession(false);

		Map queryMapYjungsanAuth =XmlQueryParser.getQueryMap(securityXmlPath+"/security/securityMgr.xml");

		Map logYnParam = new HashMap();
		logYnParam.put("ssnEnterCd" ,(String)session.getAttribute("ssnEnterCd"));

		Map logYnMp  = DBConn.executeQueryMap(queryMapYjungsanAuth, "getCpnYeaLogYn", logYnParam);

		String log_yn = "";		
		if (logYnMp != null && logYnMp.containsKey("log_yn")) 
		{
			log_yn = String.valueOf(logYnMp.get("log_yn"));
		}
		
		session.setAttribute("ssnYeaLogYn", log_yn);

    } catch(Exception e) {
    	Log.Debug("□□□□□□□□□□□□□□□□□□□□□ Exception 연말정산 로그여부 조회 실패 " + e.getMessage() );
    }
	return "";
}

/**
 * XSS 공격 치환
 * @param str
 * @return String
 */
public String removeXSS(String str, String opt) {
	if(str == null || str.length() < 1 ) return str;

    String stringStr = str;
    
    /* ---------------------------------------------------------------------
    [ XSS 보안 등급 ] XSS.SEC_LEVEL
    ------------------------------------------------------------------------
     0=기본
	 1=파라미터 치환 속도저하우려
	 2=파라미터,파일경로,파일명 치환( :: 한진칼, HMM) 속도저하우려
    ------------------------------------------------------------------------ */
    Integer XSS_SEC_LEVEL = Integer.valueOf(StringUtil.nvl(StringUtil.getPropertiesValue("XSS.SEC_LEVEL"), "0")) ;
  
    if (XSS_SEC_LEVEL > 0) 
    {
	  	if("1".equals(opt)) 
	  	{
	  	    //옵션이 '1' 이면 공백치환
	  		stringStr = stringStr.replaceAll("/","");	
	  		stringStr = stringStr.replaceAll("\\\\","");
	  		stringStr = stringStr.replaceAll("\\.","");
	  		stringStr = stringStr.replaceAll("&", "");	
	  		
	  	} 
	  	else if (opt != null && opt.indexOf("file") > -1) 
	  	{
	  		if (XSS_SEC_LEVEL >= 2) {
		  	    //옵션이 'file' 관련이면 상황에 따라 치환
		  	    //fileName    : 파일명
		  	    //filePathUrl : 경로 (웹 URL)
		  	    //filePath    : 경로 (물리경로)
				stringStr = stringStr.replaceAll("&", "");
				
				if ("fileName".equals(opt)) {
					stringStr = stringStr.replaceAll("/","");
					stringStr = stringStr.replaceAll("\\\\","");
				} else  {
					stringStr = stringStr.replaceAll("\\\\\\\\","");
					stringStr = stringStr.replaceAll("/*","");
					stringStr = stringStr.replaceAll("\\.",""); //20231216 파일명은 확장자를 고려하여 적용 안 함
					
					if ("filePathUrl".equals(opt)) {
						//웹 URL 경로
					} else {
						//물리 경로
						stringStr = stringStr.replaceAll("//","");	//20231216 웹 url은 경로 고려하여 적용 안 함
					} 
				}
	  		}
	  	} 
	  	else
	  	{
	  		//기타 html특수문자로 치환
			stringStr = stringStr.replaceAll("/","&#47;");	
			stringStr = stringStr.replaceAll("\\\\","&#92;");
			stringStr = stringStr.replaceAll("\\.","&#46;");
			stringStr = stringStr.replaceAll("&", "&amp;");
		}
    }

	return stringStr ;
}

public String removeXSS(String str, char charOpt) {
    String stringChar = String.valueOf(charOpt);
    return removeXSS(str, stringChar);
}

public String removeXSS(Object str, String opt) {
    String stringStr = str != null ? str.toString() : "";
    return removeXSS(stringStr, opt);
}

public String removeXSS(Object str, char charOpt) {
    String stringChar = String.valueOf(charOpt);
    String stringStr = str != null ? str.toString() : "";
    return removeXSS(stringStr, stringChar);
}

/**
 * opti.properties 모듈 프로퍼티 값을 리턴한다.
 * S3 서버의 설정 정보가 기본 패키지쪽 프로퍼티에 기록됨. AWS S3일 경우만 해당 로직을 사용함.
 * @param key
 * @return
*/
public String getOptiPropertiesValue(String key) {

    String value = "";
    Properties tempProp = null;
    
    try( InputStream input = StringUtil.class.getClassLoader().getResourceAsStream("opti.properties") )  {
    	if (input != null) {
			tempProp = new Properties();
    		tempProp.load(input);
    		value = tempProp.getProperty(key);
    	}
	} catch (Exception e) {
    	Log.Error(e.getMessage());
    }

    return value;
}

public static String sanitizeFilePath(String filePath) {
    if (filePath == null || filePath.trim().isEmpty()) {
        return "";
    }

    // 상대 경로 참조 (..) 제거
    String sanitized = filePath.replaceAll("\\.\\.", "");

    // 경로 구분자 제거 (예: /, \)
    //sanitized = sanitized.replaceAll("[/\\\\]", "");

    // 허용된 문자 외 제거 (예: 영문자, 숫자, 하이픈, 밑줄, 점)
    //sanitized = sanitized.replaceAll("[^a-zA-Z0-9-_\\.]", "");

    return sanitized;
}

public static String sanitizeFileName(String fileName) {
    if (fileName == null) {
        throw new IllegalArgumentException("파일 이름이 없습니다.");
    }

    // 디렉토리 이동 및 경로 구분자 확인
    if (fileName.contains("..") || fileName.contains("/") || fileName.contains("\\")) {
        throw new SecurityException("잠재적 경로 이동이 감지되었습니다.");
    }

    // 알파벳, 숫자, 하이픈 및 밑줄만 허용
    String sanitized = fileName.replaceAll("[^a-zA-Z0-9-_]", "");

    // 위험한 파일 확장자 확인 및 제거
    String[] dangerousExtensions = {".exe", ".bat", ".sh", ".js"};
    for (String ext : dangerousExtensions) {
        if (sanitized.toLowerCase().endsWith(ext)) {
            throw new SecurityException("위험한 파일 확장자가 감지되었습니다.");
        }
    }

    // 추가 보안을 위해 파일 이름의 길이 제한
    int MAX_LENGTH = 50;
    if (sanitized.length() > MAX_LENGTH) {
        throw new IllegalArgumentException("파일 이름이 너무 깁니다.");
    }

    return sanitized;
}

%>
<%
String sUrlAuthPg = "";

try {
    String isError = "";
    String chkCode = "";

    session.setAttribute("errorUrl", StringUtil.getRelativeUrl(request));

    //시스템 버전(1 = ActiveX, 2=html)
    String securityXmlPath = "";
    if("1".equals(StringUtil.getPropertiesValue("SYS.VERSION"))) {
        securityXmlPath = session.getServletContext().getRealPath("/JSP/yjungsan/common_jungsan/xml_query");
    } else {
    	if ("Y".equals(StringUtil.getPropertiesValue("CLOUD.HR.YN"))) {
            securityXmlPath = "/yjungsan/common_jungsan/xml_query";
    	} else {
            securityXmlPath = session.getServletContext().getRealPath("/yjungsan/common_jungsan/xml_query");
    	}
    }
    //연말정산 로그여부값 세팅
    getYeaLogYn(request,securityXmlPath);

    //1. Referer null check
    String referrerYjungsan = (String)request.getHeader("Referer");
    if ( null==referrerYjungsan||"".equals(referrerYjungsan) ) {
        Log.Debug("■■■■■■■■■■■■■■■■■■■ 페이지 직접 접근  체크 ■■■■■■■■■■■■■■■■■■■■■■■■");
        isError = "Y";
        chkCode = "905";
    } else {
    //2. 시스템 보안체크 여부가 Y이면 보안체크한다.
        String ssnSecurityYn = (String)session.getAttribute("ssnSecurityYn"); //시스템 보안체크 여부

        Log.Debug("■ [ code: "+ ssnSecurityYn);

        if( null!=ssnSecurityYn && "Y".equals(ssnSecurityYn) ){
        	
        	/*-------------------------------------------------------------------------------
        	!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!! 
        	20240118 구버전 사이트는 com.hr.common.util.StringUtil 클래스에 getClientIP가 없음.
        	         그런 경우는 원래 로직을 살려야 함.
        	         ex) 교촌F&B, 현대하이라이프, IBK투자증권, 교보문고, 성동조선해양 등                
        	!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
        	/*-------------------------------------------------------------------------------
        	 * 20231220 (LoginController.loginUser와 동기화) 
			 * 기본패키지에서 로그인하면서 등록한 client IP를 같은 방식으로 세션 체크
            String sClientIP = request.getHeader("X-FORWARDED-FOR");
            if (sClientIP == null || sClientIP.length() == 0) {
                sClientIP = request.getHeader("Proxy-Client-IP");
            }
            if (sClientIP == null || sClientIP.length() == 0) {
                sClientIP = request.getHeader("WL-Proxy-Client-IP");  // 웹로직
            }
            if (sClientIP == null || sClientIP.length() == 0) {
                sClientIP = request.getRemoteAddr() ;
            }		
            -------------------------------------------------------------------------------*/
			String sClientIP = com.hr.common.util.StringUtil.getClientIP(request) ;

            Log.Debug("■■■■■■■■■■■■■■■■■ [ 보안 체크 시작 ]■■■■■■■■■■■■■■■■■■■■■■■■■■");

            chkCode = securityCheck(request, sClientIP, securityXmlPath);
            Log.Debug("■ [ code: "+chkCode+" ] ");

            //에러 발생시
            if( chkCode != null && !chkCode.equals("") ){
                //에러 로그 등록 프로시저 호출
                saveError(request, sClientIP, securityXmlPath, chkCode);
                isError = "Y";
            }
            Log.Debug("■■■■■■■■■■■■■■■■■[ 보안 체크 종료 ]■■■■■■■■■■■■■■■■■■■■■■■■■");

        } else {
            if(  request.getAttribute("securityKey") == null ){ //securityKey
                request.setAttribute("securityKey", "");
            }
        }
    }

    //에러 발생 시
    if ( "Y".equals(isError) ) {

        //세션 끊기
        session.invalidate();

        if("ajax".equals( request.getHeader("IBUserAgent")) || "ibsheet".equals( request.getHeader("IBUserAgent"))) {
            //ajax로 넘어옴
            out.print("{\"Data\":{},\"Result\":{\"Code\":\""+chkCode+"\",\"Message\":\"\"}}");
            return;

        } else {

            if (chkCode.equals("905")) {
                if("1".equals(StringUtil.getPropertiesValue("SYS.VERSION"))) {
                    response.sendRedirect("/JSP/ErrorPage.jsp");
                } else {
                    response.sendRedirect("/Login.do");
                }
            } else {
                if("1".equals(StringUtil.getPropertiesValue("SYS.VERSION"))) {
                    response.sendRedirect("/JSP/info.jsp?code="+chkCode);
                } else {
                    response.sendRedirect("/Info.do?code="+chkCode);
                }
            }

            return;
        }
    }

    //3. left메뉴에서 surl이 넘어올 경우 암호화URL 조회
    if ( null != request.getParameter("surl") && !"".equals((String)request.getParameter("surl"))) {

        sUrlAuthPg = decryptUrl(request, securityXmlPath);
    }

} catch(Exception e) {
    Log.Debug("□□□□□□□□□□□□□□□□□□□□□ Exception 체크 실패1! " + e.getMessage() );
    throw new Exception();
}


%>


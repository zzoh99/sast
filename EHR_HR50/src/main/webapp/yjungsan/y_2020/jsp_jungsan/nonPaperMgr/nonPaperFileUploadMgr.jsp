<%@page import="javax.xml.ws.Dispatch"%>
<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="yjungsan.util.*"%>
<%@ page import="yjungsan.exception.*"%>
<%@ page import="java.sql.Connection"%>
<%@ page import="java.util.List"%>
<%@ page import="java.util.ArrayList"%>
<%@ page import="java.util.Map"%>
<%@ page import="java.util.HashMap"%>
<%@ page import="java.net.URLDecoder"%>
<%@ page import="java.io.*"%>
<%@ page import="java.net.URLEncoder"%>
<%@ page import="java.util.Enumeration"%>
<%@ page import="org.springframework.web.multipart.MultipartFile"%>
<%@ page import="org.springframework.web.multipart.MultipartHttpServletRequest"%>
<%@ page import="javax.servlet.http.HttpServletResponse"%>


<%@ page import="com.oreilly.servlet.MultipartRequest"%>
<%@ page import="com.oreilly.servlet.multipart.DefaultFileRenamePolicy"%>

 
<%@ page import="org.json.JSONObject" %>
<%@ page import="com.hr.common.logger.Log" %>
<%@ include file="../common/include/session.jsp"%>

<%!

//파일업로드함수
public void UploadFile(HttpServletRequest request, HttpServletResponse response, String ssnEnterCd, String strUpYear, String locPath) throws Exception{

    int sizeLimit = 1024*1024*15;//파일사이즈 지정 현재 150MB
    
    Map paramMap     = new HashMap();
	Map mapData      = new HashMap();
	Map limitSizeMap = new HashMap();

	String path = StringUtil.getPropertiesValue("WAS.PATH") + StringUtil.getPropertiesValue("HRFILE.PATH")+"/"; 
			//D:/workspace/OPTI_YEAR44/WebContent/hrfile
	
	String fileName            = "";
	String oriFileName         = "";
	String fileFullPath        = "";
	String strUploadFileSeq    = "";
	String strUploadPath       = "";
	
	String strAdjtype = "";
	String strSabun   = "";
	String strYear    = "";
	
	String fileNameSet   = "";//파일이름 셋팅변수
	
        try {

        	Map queryMap = XmlQueryParser.getQueryMap(locPath);
        	strUploadPath = path+"YEA_ATT_FILE/"+strUpYear+"/"+ssnEnterCd+"/";
        	//WAS.PATH + HRFILE.PATH + // 체크 후 생성"/YEA_ATT_FILE" + /연말정산 귀속년도 + /세션enter_cd
        	File filrDir = new File(strUploadPath);
        	
        	if(!filrDir.exists()){//디렉토리 존재 여부 확인
        		
        		filrDir.mkdirs(); //디렉토리가 존재하지 않는다면 생성
	        }
        	
        	limitSizeMap = (queryMap == null) ? null : DBConn.executeQueryMap(queryMap,"getFileLimitSize",paramMap);
        	sizeLimit = Integer.parseInt((String)limitSizeMap.get("std_cd_value"));
        	//업로드 최대 파일 사이즈를 가져옴
        	
	        MultipartRequest multi = new MultipartRequest(request, strUploadPath, sizeLimit, "utf-8");
        	//파일업로드
        	
	        oriFileName = multi.getFilesystemName("fileNm");
	        strSabun    = multi.getParameter("uploadSabun");
	        strAdjtype  = multi.getParameter("uploadAdjustType");
	        strYear     = multi.getParameter("uploadYear");
	        
	        paramMap.put("entercd", ssnEnterCd);
	        paramMap.put("uploadsabun", strSabun);
	        paramMap.put("uploadyear", strYear);
	        paramMap.put("uploadadjusttype", strAdjtype);
	        //파일업로드 시퀀스 정보 검색
	        mapData = (queryMap == null) ? null : DBConn.executeQueryMap(queryMap,"getFileMaxSeq",paramMap);
	        strUploadFileSeq = (String)mapData.get("maxseq");
        	
			fileNameSet= ssnEnterCd + strYear + strSabun + strAdjtype + strUploadFileSeq;
			//파일명을 만듬 (회사정보 + 귀속년도 + 사번 + 정산구분 + 파일시퀀스)
	        
	        //*********************파일명을 변경시킴
            int i = -1;
        	    i = oriFileName.lastIndexOf(".");
            String fileType = oriFileName.substring(i, oriFileName.length());
            
	        File oldFile = new File(strUploadPath + oriFileName);
	        File newFile = new File(strUploadPath + fileNameSet + fileType);
	        
	        boolean isExists = newFile.exists();

	        if(isExists) {// 중복되는 파일명이 잇을시 삭제 한다. 
	        	Log.Error("\ndelteFile : "+strUploadPath + fileNameSet + fileType);
	        	newFile.delete(); 
	        }

	        oldFile.renameTo(newFile); // 파일명 변경
	        
	        //********************************
	        
	        fileFullPath = strUploadPath + fileNameSet + fileType;
	        
        } catch (IllegalStateException e) {
            // TODO Auto-generated catch block
			Log.Error("[Exception] " + e);
//             e.printStackTrace();
        } catch (IOException e) {
            // TODO Auto-generated catch block
			Log.Error("[Exception] " + e);
//             e.printStackTrace();
        }
		
		String message = "";
		String code = "1";
		String pgAuth = request.getParameter("pgAuth");
		
		request.setAttribute("fileName", oriFileName);
		request.setAttribute("fileFullPath", fileFullPath);
		
		RequestDispatcher dis = request.getRequestDispatcher("nonPapeFileUpload.jsp");
        dis.forward(request, response);
	
}

//파일다운로드 함수
public void getFilDowload(HttpServletRequest request, HttpServletResponse response) throws Exception {
	 
	String filename = request.getParameter("downFileName");//파일명
	String path = request.getParameter("downFilePath");//파일전체 경로
	String header = request.getHeader("User-Agent");//유저브라우저
	String browser= "";
	
	//String decodeResult = URLDecoder.decode(path, "utf-8");
	//인코딩 경로를 바꿈
	
	/********* 브라우저 체크*****/
	if( header.indexOf("Trident") > -1 || header.indexOf("Edge/") > -1 || header.indexOf("MSIE") > -1) {
			browser = "ie";
			
			/* if(header.indexOf("edge/") > -1) { // Edge
				browser = "edge";
			} */
			
	} else if(header.indexOf("Safari") > -1) { // Chrome or Safari
		if(header.indexOf("Opr") > -1) { // Opera
			browser = "opera";
		} else if(header.indexOf("Chrome") > -1) { // Chrome
			browser = "chrome";
		} else { // Safari
			browser = "safari";
		}
	} else if(header.indexOf("Firefox") > -1) { // Firefox
		browser = "firefox";
	}
	
	//브라우저별 파일명 인코딩 및 헤더셋팅
	if (browser.equals("ie")) { 
		path = URLDecoder.decode(path, "utf-8");
		filename = URLEncoder.encode(filename, "UTF-8").replaceAll("\\+", "%20"); 
		response.setHeader("Content-Type", "doesn/matter;");
		
	} else if (browser.equals("firefox")) { 
		
		filename = new String(filename.getBytes("UTF-8"), "8859_1") ;//한글파일 인코딩
		
		/*************파일다운로드 헤더셋팅*************************************************************/
		response.setHeader("Pragma", "public");
		response.setHeader("Expires", "0");
		response.setHeader("Cache-Control", "must-revalidate, post-check=0, pre-check=0");
		response.setHeader("Content-type", "application-download");
		/**************************************************************************************/		
		
	} else if (browser.equals("opera")) { 
		
		filename = new String(filename.getBytes("UTF-8"), "8859_1"); 
		response.setHeader("Content-Type", "application/unknown");
		
	} else if (browser.equals("safari")) {
		
		filename = new String(filename.getBytes("UTF-8"), "8859_1");//한글파일 인코딩
		/*************파일다운로드 헤더셋팅*************************************************************/
		response.setHeader("Pragma", "public");
		response.setHeader("Expires", "0");
		response.setHeader("Cache-Control", "must-revalidate, post-check=0, pre-check=0");
		response.setHeader("Content-type", "application-download");
		
		/**************************************************************************************/
		
	}else if (browser.equals("chrome")) { 
		
		StringBuffer sb = new StringBuffer(); 
		for (int i = 0; i < filename.length(); i++) { 
			char c = filename.charAt(i); 
			if (c > '~') { 
				sb.append(URLEncoder.encode("" + c, "UTF-8")); 
				} else { 
					sb.append(c); 
				} 
			} filename = sb.toString(); 
		response.setHeader("Content-Type", "application/unknown");
			
	} else {
		
		throw new RuntimeException("Not supported browser"); 
		
	}
	
	/********* 파일명 한글깨짐 인코더 끝*****/
	
	/** HTTP 헤더 셋팅 */
	response.reset();
	response.setHeader("Content-Transfer-Encoding", "binary");
	response.setHeader("Content-Disposition", "attachment;filename=\"" + filename + "\""); //파일명 리네임
	 
	//Log.Error("\nFilePath : "+path);

	/** 파일 다운로드 */
	
	File fp = new File(path);
	Log.Error(fp.length());
	
	int read = 0;
	byte[] b = new byte[(int)fp.length()]; // 파일 크기

	if (fp.isFile()){
		BufferedInputStream fin = new BufferedInputStream(new FileInputStream(fp));
		BufferedOutputStream outs =	new BufferedOutputStream(response.getOutputStream());
		// 파일 읽어서 브라우저로 출력하기

		try {
			while((read=fin.read(b)) != -1){
				outs.write(b, 0, read);
			}
		} catch (Exception e) {
			Log.Error("[Exception] " + e);
// 			e.printStackTrace();
		} finally{
			if (outs != null) {
				outs.flush();
				outs.close();
			}
			if (fin != null) {
				fin.close();
			}
		}
	}
}
%>

<%
	String locPath = xmlPath+"/nonPaperMgr/nonPaperMgr.xml";

	String ssnEnterCd = (String)session.getAttribute("ssnEnterCd");
	String ssnSabun   = (String)session.getAttribute("ssnSabun");
	String strFlag    = (String)request.getParameter("updownFlag");
	String strUpYear    = (String)request.getParameter("uploadYear");
	
	out.clear();
	pageContext.pushBody();
	
	if("UPLOAD".equals(strFlag)){
		UploadFile(request, response, ssnEnterCd, strUpYear, locPath);
	} else {
		getFilDowload(request, response);
	}
%>
<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="java.util.*" %>
<%@ page import="java.io.*"%>
<%@ page import="javax.xml.parsers.DocumentBuilder"%>
<%@ page import="javax.xml.parsers.DocumentBuilderFactory"%>
<%@ page import="PDFExport.ezPDFExportFile"%>
<%@ page import="etiming.astdts.apl3161.*"%>
<%@ page import="org.apache.commons.fileupload.*"%>
<%@ page import="org.apache.commons.fileupload.disk.DiskFileItem"%>
<%@ page import="org.apache.commons.fileupload.disk.DiskFileItemFactory"%>
<%@ page import="org.apache.commons.fileupload.servlet.ServletFileUpload"%>
<%@ page import="java.nio.file.Files"%>
<%@ page import="java.io.InputStream"%>
<%@ page import="org.jdom2.Document"%>
<%@ page import="org.jdom2.Element"%>
<%@ page import="org.jdom2.input.SAXBuilder"%>
<%@ page import="org.w3c.dom.Node"%>
<%@ page import="org.w3c.dom.NodeList"%>
<%@ page import="org.xml.sax.InputSource"%>
<%@ page import="com.hr.common.logger.Log" %>
<%@ page import="yjungsan.exception.UserException"%>
<%@ page import="yjungsan.util.*"%>
<%@ page import="java.sql.Connection"%>
<%@ include file="../common/include/session.jsp"%>
<%@ page import="com.dreamsecurity.exception.DVException"%>
<%@ page import="com.dreamsecurity.jcaos.util.encoders.Base64"%>
<%@ page import="com.dreamsecurity.verify.DSTSPDFSig"%>
<%@ page import="com.epapyrus.api.ExportCustomFile"%>
<%!
    //초기화된 데이터 맵
    public Map getDefaultDataMap(String ssnEnterCd, String ssnSabun, String workYy, String adjustType, String sabun, String docType, String docSeq, String formCd, String resId, String manName) {
        Map mp = new HashMap();
        mp.put("ssnEnterCd", ssnEnterCd);
        mp.put("ssnSabun", ssnSabun);
        mp.put("workYy", workYy);
        mp.put("adjustType", adjustType);
        mp.put("sabun", sabun);
        mp.put("docType", docType);
        mp.put("docSeq", docSeq);
        mp.put("formCd", formCd);

        for(int i = 1; i <= 30; i++) {
            mp.put("A"+i,"");
        }

        mp.put("A1", resId);
        mp.put("A2", manName);

        return mp;
    }

	private DiskFileItem createFileItem(String filePath, String fileName) throws IOException {
		DiskFileItem fileItem = new DiskFileItem(
                "file",  // 필드 이름
                Files.probeContentType(new File(filePath).toPath()),  // 파일의 MIME 타입을 가져옴
                false,  // 파일 필드 여부
                fileName,
                (int) new File(filePath).length(),
                new File(filePath).getParentFile()
        );
		try (InputStream inputStream = Files.newInputStream(new File(filePath).toPath());
	             OutputStream outputStream = fileItem.getOutputStream()) {
	            byte[] buffer = new byte[4096];
	            int bytesRead;
	            while ((bytesRead = inputStream.read(buffer)) != -1) {
	                outputStream.write(buffer, 0, bytesRead);
	            }
	        } catch (IOException e) {
	        	StringWriter sw = new StringWriter();
	            e.printStackTrace(new PrintWriter(sw));
	            Log.Error("파일 처리 중 오류 발생: " + sw.toString());
	        }
	
	    return fileItem;
	}
%>

<%
    //Log.Debug("request.getContentType() === "+request.getContentType());
    //Log.Debug("request.getCharacterEncoding() === "+request.getCharacterEncoding());

    //로그인 정보 Session취득
    String ssnEnterCd = (String)session.getAttribute("ssnEnterCd");
    String ssnSabun = (String)session.getAttribute("ssnSabun");

    //파라메터 초기화.
    String paramYear = "";          //연말정산 년도
    String searchYear = "";          //연말정산 년도
    String paramSabun = "";         //사번
    String paramPwd =  "";          //pdf 패스워드
    String paramAdjustType = "";    //연말정산 타입(1:연말정산, 2:퇴직정산)
    String fileUploadType = "";     //파일 업로드 타입(1:amazon S3, 0:그외)
    String procMessage = "";        //프로시저 실행후 메시지.

  	String pdfCnt = "";

  	Map<String, String> chkPerMap = new HashMap<String, String>(); //2019-11-08. 인적공제인원과 PDF를 비교하기 위한 MAP
  	StringBuffer chkPerMessage = new StringBuffer();               //2019-11-08. 인적공제인원과 PDF를 비교 메세지

try {
    /* 업로드 파일 정의 부분(해당 시스템에서 사용하는 파일 업로드 패키지에 따라 수정 필요) */
    DiskFileUpload fileUpload = new DiskFileUpload();

    fileUpload.setHeaderEncoding(sysEnc);
    boolean isMultipart = ServletFileUpload.isMultipartContent(request);
    List<FileItem> fileItemList = new ArrayList<>();
    if(isMultipart){
    	/* 업로드 컨텐츠 목록 추출 */
        fileItemList = fileUpload.parseRequest(request);
    } else{
    	String filePath = String.valueOf(request.getParameter("filePath"));        
        String fileName = (String)request.getParameter("fileName");
        paramSabun = (String)request.getParameter("paramSabun");
        paramYear = (String)request.getParameter("paramYear");
        paramAdjustType = (String)request.getParameter("paramAdjustType");
        fileUploadType = (String)request.getParameter("fileUploadType");
        
        if (!filePath.contains("/YEA_PDF/"+ssnEnterCd+"/"+paramYear+"/SUM")) {
        	throw new Exception("작업에 실패하였습니다.");
        }
       	if (fileName == null || "".equals(fileName)) {
			throw new Exception("작업에 실패하였습니다.");
       	} else {
       		fileName = fileName.replaceAll("/","");	
       		fileName = fileName.replaceAll("\\\\","");
       		//fileName = fileName.replaceAll("\\.","");
       		//fileName = fileName.replaceAll("&", "");	
       	}	
        
        DiskFileItem fileItem = createFileItem(filePath+"/"+fileName, fileName);
        fileItemList.add(fileItem);
    }
    /* 업로드 컨텐츠 목록 추출 */
    //List fileItemList = fileUpload.parseRequest(request);

    /* 업로드 컨텐츠 종류에 따라 반복 처리 */
    int v_fileCnt = fileItemList.size();
    //폼필드 부분만 먼저 가져온다.
    for(int i = 0 ; i < v_fileCnt ; i++){
        FileItem fileItem = (FileItem) fileItemList.get(i);
        /* 문서 비밀번호 가져오기(비밀번호 없는 문서일 경우 생략 가능. 이 때 p_pwd=null) */
        // 방식1.사용자 입력 방식인 경우(폼필드 입력값 추출)
        if ( fileItem.isFormField() ) {
            if ( "paramPwd".equals(fileItem.getFieldName()) ) {
                paramPwd = fileItem.getString();
            } else if("paramSabun".equals(fileItem.getFieldName()) ) {
                paramSabun = fileItem.getString();
            } else if("paramYear".equals(fileItem.getFieldName()) ) {

            	/* param값으로 파일 path지정하는 부분  수정_보안 20151203 */
            	paramYear = yeaYear;

            } else if("paramAdjustType".equals(fileItem.getFieldName()) ) {
                paramAdjustType = fileItem.getString();
            } else if("fileUploadType".equals(fileItem.getFieldName()) ) {
            	fileUploadType = fileItem.getString();
            }
        }
    }
    /*
    Log.Debug("=============================pdf 파일 업로드 시작=============================");
    Log.Debug("ssnEnterCd ======= "+ssnEnterCd);
    Log.Debug("ssnSabun ========= "+ssnSabun);
    Log.Debug("paramYear ======== "+paramYear);
    Log.Debug("searchYear ======= "+searchYear);
    Log.Debug("paramSabun ======= "+paramSabun);
    Log.Debug("paramPwd ========= "+paramPwd);
    Log.Debug("paramAdjustType == "+paramAdjustType);
    */
    //파일 부분 가져와서 체크.
    for(int i = 0 ; i < v_fileCnt ; i++){
        FileItem fileItem = (FileItem) fileItemList.get(i);

        //폼필드라면 이미 그전에 변수에 할당했다.
        if ( fileItem.isFormField() ) {
            continue;
        }

        // path 제외한 파일명만 취득
        String[] filePath = fileItem.getName().split("\\\\");
        String fileName = filePath[filePath.length -1]; //파일명(ex:abcd.pdf)

        //Log.Debug("fileName ===== "+fileName);
        // PDF파일이 아닌 경우 skip
        if ( !fileName.toUpperCase().endsWith(".PDF") ) {
            throw new UserException("PDF 파일이 아닙니다.");
        }

        // 파일내용을 읽음
        byte[] pdfBytes = fileItem.get();

        //String pdfBytesEnc = new InputStreamReader(fileItem.getInputStream()).getEncoding().toLowerCase();
        String pdfBytesEnc = new InputStreamReader(fileItem.getInputStream()).getEncoding();
        if (pdfBytesEnc != null){
        	pdfBytesEnc = pdfBytesEnc.toLowerCase();
        }
        //Log.Debug("pdf 파일인코딩 ==== "+pdfBytesEnc);
%>

<%@include file="./yeaDataPdfUploadRstInc.jsp"%>

<%
        /////////////// PDF 데이터 DB에 저장하기. /////////////////
        //쿼리 맵 가져오기
        Map queryMap = XmlQueryParser.getQueryMap(xmlPath+"/common/pdfUpload.xml");
        // 기존등록여부 체크
        //파라메터 복사.
		Map pm = new HashMap();
		pm.put("ssnEnterCd", ssnEnterCd );
		pm.put("workYy", paramYear );
		pm.put("adjustType", paramAdjustType );
		pm.put("sabun", paramSabun );

		Map mpCnt = null;
		try{
			//쿼리 실행및 결과 받기.
			mpCnt  = (queryMap==null) ? null : DBConn.executeQueryMap(queryMap,"selectPdfFileCnt",pm);
		} catch (Exception e) {
			Log.Error("[Exception] " + e);
			throw new Exception("조회에 실패하였습니다.");
		}
		if( mpCnt != null ) {
			pdfCnt = String.valueOf(mpCnt.get("cnt"));
		}
		//return;

        //DB 컨트롤.
        //사용자가 직접 트렌젝션 관리하기 위해 커넥션 가져오기.
        Connection conn = DBConn.getConnection();
        int delCnt = 0;
        int rstCnt = 0;
        int fileDelCnt = 0;
        int fileRstCnt = 0;

        if(dataList != null && dataList.size() > 0) {

            //사용자가 직접 트랜젝션 관리
            conn.setAutoCommit(false);

            try{

                //기존 데이터 삭제.
                Map deleteMap = new HashMap();


                deleteMap.put("ssnEnterCd", ssnEnterCd);
                deleteMap.put("workYy", paramYear);
                deleteMap.put("adjustType", paramAdjustType);
                deleteMap.put("sabun", paramSabun);
                deleteMap.put("doc_seq", docSeq);

                delCnt += DBConn.executeUpdate(conn, queryMap, "deletePdfInfo", deleteMap);

                Log.Debug("dataList ========= \n"+dataList);
                Log.Debug("\n\n");

                //현재 데이터 입력.
                for(int idx = 0; idx < dataList.size(); idx++ ) {
                    String query = "";
                    Map mp = (Map)dataList.get(idx);
                    Log.Debug("mp ========= " + idx + "\n"+mp);

                    rstCnt += DBConn.executeUpdate(conn, queryMap, "insertPdfInfo", mp);
                }

                //파일을 다른위치로 저장(파일 저장시 실패하면 롤빽될수 있도록).
                if(!fileItem.isFormField()) {
                    long fileSize = fileItem.getSize();

                    if(fileSize > 0) {
                    	String attFileNm = fileItem.getName().trim();
                        String saveFileNm = paramSabun+attFileNm.substring(attFileNm.lastIndexOf("."));
                        String dbfilePath = StringUtil.getPropertiesValue("HRFILE.PATH")+"/YEA_PDF/"+ssnEnterCd+"/"+paramYear+"/SUM";
                        String saveFilePath = "";

                        String nfsUploadPath = StringUtil.getPropertiesValue("NFS.HRFILE.PATH");
                        if(nfsUploadPath != null && nfsUploadPath.length() > 0) {
                            saveFilePath = nfsUploadPath+StringUtil.getPropertiesValue("HRFILE.PATH")+"/YEA_PDF/"+ssnEnterCd+"/"+paramYear+"/SUM";
                        } else {
                            saveFilePath = StringUtil.getPropertiesValue("WAS.PATH")+StringUtil.getPropertiesValue("HRFILE.PATH")+"/YEA_PDF/"+ssnEnterCd+"/"+paramYear+"/SUM";
                        }

                        Map fileMp = new HashMap();
                        fileMp.put("ssnEnterCd", ssnEnterCd);
                        fileMp.put("sabun", paramSabun);

                        //파일명 암호화
                        //Map mapData  = (queryMap==null) ? null : DBConn.executeQueryMap(queryMap,"selectPdfFileEncrypt",fileMp);
                        String file_name = "";
                        //if ( mapData != null && mapData.get("file_name") != null && !mapData.get("file_name").equals("") ) {
                        Random random = new Random();
                        random.setSeed(new Date().getTime());
						String randomNum = Integer.toString(random.nextInt(10000));
						file_name = paramSabun + StringUtil.padLeft(randomNum, "0" ,4);
                       	//file_name = paramSabun + StringUtil.padLeft((int)(Math.random()*10000)+"", "0" ,4);
                       	
                       	saveFileNm = file_name+attFileNm.substring(attFileNm.lastIndexOf("."));
                       	//file_name = StringUtil.replaceAll(StringUtil.replaceAll((String)mapData.get("file_name"),"/",""),"=", "");
                       	//saveFileNm = file_name+attFileNm.substring(attFileNm.lastIndexOf("."));
                        //}

                      	//파일 정보  db저장
                        fileMp.put("workYy", paramYear);
                        fileMp.put("adjustType", paramAdjustType);
                        fileMp.put("docType", docType);
                        fileMp.put("filePath", dbfilePath);
                        fileMp.put("fileName", saveFileNm);
                        fileMp.put("ssnSabun", ssnSabun);
                        fileMp.put("doc_seq", docSeq);
                        %>

    	            	<%@ include file="../../../common_jungsan/jsp/uploadS3/uploadS3_TYPE2.jsp" %>

    	            	<%
                    	saveFilePath = "/YEA_PDF/"+ssnEnterCd+"/"+paramYear+"/SUM";
    	            	fileMp.put("filePath", saveFilePath);
                    	saveFileToS3(saveFilePath, ssnSabun, saveFileNm, fileItem.getInputStream(), file_name);
                        delCnt += DBConn.executeUpdate(conn, queryMap, "deletePdfFileInfo", fileMp);
                        rstCnt += DBConn.executeUpdate(conn, queryMap, "insertPdfFileInfo", fileMp);
                    }
                }

                //커밋
                conn.commit();
            } catch(Exception e) {
                try {
                    //롤백
                    conn.rollback();
                } catch (Exception e1) {
                    Log.Error("[rollback Exception] " + e);
                }
                throw new Exception("PDF 데이터 insert중 오류가 발생하였습니다.\\n"+e.toString());
            } finally {
                DBConn.closeConnection(conn, null, null);
            }
        }

        /////////////////////// DB저장 및 파일업로드가 완료되었다면 프로시저 호출 //////////////////////////
        String[] type =  new String[]{"OUT","OUT","STR","STR","STR","STR","STR","STR"};
        String[] param = new String[]{"","",ssnEnterCd,paramYear,paramAdjustType,paramSabun,ssnSabun,docSeq};

        String[] rstStr = DBConn.executeProcedure("P_CPN_YEA_PDF_ERRCHK_"+paramYear,type,param);

        if(rstStr[0] != null && "1".equals(rstStr[0])) {
            procMessage = rstStr[1];
        } else {
            throw new UserException("프로시저 실행중 오류가 발생하였습니다.\\n"+rstStr[1]);
        }

        /* 2019-11-08. 인적공제인원과 PDF를 비교
         * 데이터 저장 후 최종 단계에서 비교해서 message가 나오도록 처리
         */
        List<HashMap<String, String>> perList = null;
        Map<String, String>  perMap = new HashMap<String, String>(); //인적공제에만 존재하는 대상자
        try{
    		//쿼리 실행및 결과 받기.
    		perList  = (queryMap == null) ? null : DBConn.executeQueryList(queryMap,"selectPdfPerList",pm);

    		if(perList != null && perList.size() > 0) {

    			//조회 목록에 존재하면 미등록인원 MAP에서 삭제
    			for(int j=0; j<perList.size(); j++) {

    				String famNm = chkPerMap.get(perList.get(j).get("famres"));

    				//조회 목록에 존재하면 미등록인원 MAP에서 삭제
    				if(famNm != null && perList.get(j).get("fam_nm") != null && famNm.equals(perList.get(j).get("fam_nm"))) {
    					chkPerMap.remove(perList.get(j).get("famres"));
    					continue;
    				}

    				//조회목록에는 있으나 PDF에 없을 경우 미등록인원 추가
    				perMap.put(perList.get(j).get("famres"), perList.get(j).get("fam_nm"));
    			}
    		}

    		//MAP에 남은 인원 alert
    		if(chkPerMap.size() > 0 || perMap.size() > 0) {

    			chkPerMessage.append("\\n\\n*참고\\n현재 업로드한 PDF 자료의 인원과 인적공제 인원의 차이가 존재합니다.");

    			if(chkPerMap.size() > 0) {
    				chkPerMessage.append("\\n\\n- PDF자료에만 존재하는 대상자\\n: ");
	    			Iterator<String> keys = chkPerMap.keySet().iterator();
	    			while(keys.hasNext()){
	    				String key = keys.next();
	    				chkPerMessage.append(chkPerMap.get(key)+" ");
	    			}
    			}

    			if(perMap.size() > 0) {
    				chkPerMessage.append("\\n\\n- 인적공제에만 존재하는 대상자\\n: ");
	    			Iterator<String> keys = perMap.keySet().iterator();
	    			while(keys.hasNext()){
	    				String key = keys.next();
	    				chkPerMessage.append(perMap.get(key)+" ");
	    			}
    			}
    		}


    	} catch (Exception e) {
    		Log.Error("[Exception] " + e);
    		throw new Exception("조회에 실패하였습니다.");
    	}

    } /* end of for */

    //Log.Debug("정상 업로드 완료");

%>
    <script>
    parent.doAction("Search");
    if ( "<%=pdfCnt%>" == "" || "<%=pdfCnt%>" == "0" ) { //최초등록인 경우
        parent.procYn("Y","업로드가 정상적으로 완료되었습니다.\n<%=procMessage%><%=chkPerMessage.toString()%>");
    } else{
        parent.procYn("Y","기존 등록된 pdf자료에 정상적으로 업데이트 처리 되었습니다.\n<%=procMessage%><%=chkPerMessage.toString()%>");
    }
    parent.doAction3("Search");
    parent.doAction2("Search");
    </script>
<%
} catch(UserException ue) {
    Log.Debug("[UserException]" + ue.getMessage());
%>
    <script>
        parent.procYn("N","<%=ue.getMessage()%>");
    </script>
<%
} catch(Exception ex) {
	Log.Error("[yeaDataPdfUploadRst]:" + ex.getMessage());
%>
    <script>
        parent.procYn("N","<%=ex.toString()%>");
    </script>
<%
}
Log.Debug("==============================PDF 업로드 끝===============================");
%>

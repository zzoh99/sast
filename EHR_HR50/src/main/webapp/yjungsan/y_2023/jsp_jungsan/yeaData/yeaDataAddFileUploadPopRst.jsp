<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="java.util.*"%>
<%@ page import="java.io.*"%>
<%@ page import="java.text.SimpleDateFormat"%>
<%@ page import="org.apache.commons.fileupload.*"%>
<%@ page import="com.hr.common.logger.Log" %>
<%@ page import="org.json.JSONArray"%>
<%@ page import="org.json.JSONObject" %>
<%@ page import="yjungsan.exception.UserException"%>
<%@ page import="yjungsan.util.*"%>
<%@ page import="java.sql.Connection"%>
<%@ include file="../common/include/session.jsp"%>
<%@ include file="../auth/saveLog.jsp"%>

<%

    Log.Debug("request.getContentType() === "+request.getContentType());
    Log.Debug("request.getCharacterEncoding() === "+request.getCharacterEncoding());

    //로그인 정보 Session취득
    String ssnEnterCd = (String)session.getAttribute("ssnEnterCd");
    String ssnSabun = (String)session.getAttribute("ssnSabun");
    String ssnYeaLogYn = (String)session.getAttribute("ssnYeaLogYn");

    //파라메터 초기화.
    String searchWorkYy = "";       //연말정산 년도
    String searchSabun = "";		//사번
    String searchAdjustType = "";   //연말정산 타입(1:연말정산, 3:퇴직정산)
    String searchFileType = "";     //파일타입
    String fileUploadType = "";     //파일 업로드 타입

    String procYn = "N";            //처리여부
    String procMessage = "";        //프로시저 실행후 메시지.

  	JSONArray memoArr = new JSONArray();
    JSONObject memoObj = null;
    
    int errorCnt = 0;
    
try {

    Log.Debug("=============================pdf 파일 업로드 시작=============================");
    Log.Debug("ssnEnterCd ===== "+ssnEnterCd);
    Log.Debug("ssnSabun ===== "+ssnSabun);

    Map systemInfo = null;
    String limitFileSize = "0";
  	Map param = new HashMap();
  	param.put("ssnEnterCd", ssnEnterCd);
  	param.put("stdCd", "CPN_YEAREND_LIMIT_SIZE");
  	
    String cmd = (String)request.getParameter("cmd");
   	String locPath = xmlPath+"/yeaData/yeaDataAddFileUploadPop.xml";
    
    Log.Debug("errorCnt ===== "+errorCnt);
    //업로드 후 대상자 성명 저장
    if("saveNmTxt".equals(cmd)) {
        Map mp = StringUtil.getRequestMap(request);
        mp.put("ssnEnterCd", ssnEnterCd);
        mp.put("ssnSabun", ssnSabun);
        mp.put("cmd", cmd);

        int cnt = 0;
        String message = "";
        String code = "1";

        try {
            cnt = saveNmTxt(mp, locPath, ssnYeaLogYn);
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
    }else{
        //xml 파서를 이용한 방법;
        Map queryMap = XmlQueryParser.getQueryMap(locPath);
        
	    try{
			//쿼리 실행및 결과 받기.
			systemInfo  = (queryMap==null) ? null : DBConn.executeQueryMap(queryMap,"selectSystemInfo",param);
		} catch (Exception e) {
			Log.Error("[Exception] " + e);
			throw new Exception("시스템 정보 조회에 실패하였습니다.");
		}
	
		if( systemInfo != null ) {
			limitFileSize = String.valueOf(systemInfo.get("std_cd_value"));
		}
	
	    /* 업로드 파일 정의 부분(해당 시스템에서 사용하는 파일 업로드 패키지에 따라 수정 필요) */
	    DiskFileUpload fileUpload = new DiskFileUpload();
	
	    fileUpload.setHeaderEncoding(sysEnc);
	
	    /* 업로드 컨텐츠 목록 추출 */
	    List fileItemList = fileUpload.parseRequest(request);
	
	    /* 업로드 컨텐츠 종류에 따라 반복 처리 */
	    int v_fileCnt = fileItemList.size();
	
	    
	    int fileIndex = 0;
	
	  	//폼필드 부분만 먼저 가져온다.
	    for(int i = 0 ; i < v_fileCnt ; i++){
	        FileItem fileItem = (FileItem) fileItemList.get(i);

	        if ( fileItem.isFormField() ) {
	            if ("searchWorkYy".equals(fileItem.getFieldName())) {
	            	searchWorkYy = fileItem.getString();
	            } else if("searchAdjustType".equals(fileItem.getFieldName())) {
	            	searchAdjustType = fileItem.getString();
	            } else if("searchSabun".equals(fileItem.getFieldName())) {
	                searchSabun = fileItem.getString();
	            } else if("searchFileType".equals(fileItem.getFieldName())) {
	            	searchFileType = fileItem.getString();
	            } else if("fileUploadType".equals(fileItem.getFieldName())) {
	            	fileUploadType = fileItem.getString();
	            }
	        }
	    }

	    //파일 체크
	    fileIndex = 0;
	    for(int i = 0 ; i < v_fileCnt ; i++){
	    	FileItem fileItem = (FileItem) fileItemList.get(i);
	    	
	    	//폼필드라면 이미 그전에 변수에 할당했다.
	        if ( fileItem.isFormField() ) {
	            continue;
	        }
	
	        memoObj = new JSONObject();
	
	     	// path 제외한 파일명만 취득
	        String[] filePath = fileItem.getName().split("\\\\");
	        String fileName = filePath[filePath.length -1]; //파일명(ex:abcd.pdf)
	        String ext = fileName.substring(fileName.lastIndexOf(".")+1);
	        long fileSize = fileItem.getSize();            // 파일크기
	
	        // 파일 확장자 체크
	        String[] arrExt = {"pdf","hwp","txt","doc","docx","ppt","pptx","xls","xlsx","zip","rar","alz","egg","7z","jpg","jpeg","gif","png","tiff","bmp"};
	        boolean isExt = true;
	
	        if(ext != null && !"".equals(ext)) {
	        	for(int k=0; k<arrExt.length; k++) {
	            	if(ext.equalsIgnoreCase(arrExt[k])) {
	            		isExt = true;
	            		break;
	            	} else {
	            		isExt = false;
	            	}
	            }
	        } else {
	        	isExt = false;
	        }
	
	        if(!isExt) {
	        	memoObj.put("fileIdx", fileIndex);
	        	memoObj.put("fileName", fileName);
	        	memoObj.put("errorCode", 1);
	        	memoObj.put("errorMessage", "업로드 할 수 없는 파일 형식입니다.");
	        	memoArr.put(fileIndex, memoObj);
	        	errorCnt++;
	        } else if(!(searchAdjustType.equals("1") || searchAdjustType.equals("3"))) {
	        	//정산구분 체크
	        	memoObj.put("fileIdx", fileIndex);
	        	memoObj.put("fileName", fileName);
	        	memoObj.put("errorCode", 3);
	        	memoObj.put("errorMessage", "정산구분을 확인해 주세요.(1-연말정산, 3-퇴직정산)");
	        	memoArr.put(fileIndex, memoObj);
	        	errorCnt++;
	        } else if(fileSize > Long.valueOf(limitFileSize)) {
	        	//파일크기 체크
	        	memoObj.put("fileIdx", fileIndex);
	        	memoObj.put("fileName", fileName);
	        	memoObj.put("errorCode", 4);
	        	memoObj.put("errorMessage", (Long.valueOf(limitFileSize)/(1024*1024))+"MB 이하의 파일만 업로드 할수 있습니다.");
	        	memoArr.put(fileIndex, memoObj);
	        	errorCnt++;
	        } else {
	        	memoObj.put("fileIdx", fileIndex);
	        	memoObj.put("fileName", fileName);
	        	memoObj.put("errorCode", 0);
	        	memoObj.put("errorMessage", "");
	        	memoArr.put(fileIndex, memoObj);
	        }
	        fileIndex++;
	    }
	
	    if(errorCnt > 0) {
	    	throw new UserException("업로드 할 수 없는 파일이 존재합니다.\\n파일을 확인해 주세요");
	    }
	
	  	//파일 처리
	    fileIndex = 0;
	    for(int i = 0 ; i < v_fileCnt ; i++){
	    	queryMap = XmlQueryParser.getQueryMap(locPath);
	    	
	    	FileItem fileItem = (FileItem) fileItemList.get(i);
	
	      	//폼필드라면 이미 그전에 변수에 할당했다.
	        if ( fileItem.isFormField() ) {
	            continue;
	        }
	
	        memoObj = memoArr.getJSONObject(fileIndex);
	
	        // path 제외한 파일명만 취득
	        String[] filePath = fileItem.getName().split("\\\\");
	        String fileName = filePath[filePath.length -1]; //파일명(ex:abcd.pdf)
	        String fileNameTemp = fileName.substring(0, fileName.lastIndexOf("."));
	        long fileSize = fileItem.getSize();            // 파일크기

			// 사번 및 기존등록여부 체크
			Map pm = new HashMap();
			pm.put("ssnEnterCd", ssnEnterCd );
			pm.put("ssnSabun", ssnSabun );
	
			pm.put("searchWorkYy", searchWorkYy );
			pm.put("searchAdjustType", searchAdjustType );
			pm.put("searchSabun", searchSabun );
			pm.put("searchFileType", searchFileType );
			pm.put("searchFileName", fileName );
	
			//사번 체크
			Map sabunCnt = null;
			try{
				//쿼리 실행및 결과 받기.
				sabunCnt  = (queryMap==null) ? null : DBConn.executeQueryMap(queryMap,"selectSabunCnt",pm);
			} catch (Exception e) {
				Log.Error("[Exception] " + e);
				throw new Exception("조회에 실패하였습니다.");
			}
			if( sabunCnt == null || !"1".equals(String.valueOf(sabunCnt.get("cnt"))) ) {
				memoObj.put("errorCode", 5);
	        	memoObj.put("errorMessage", "사번을 확인해 주세요");
	        	memoArr.put(fileIndex, memoObj);
	        	throw new UserException("사번을 확인해 주세요");
			}
			Map finmCnt = null;
			try{
				//쿼리 실행및 결과 받기.
				finmCnt  = (queryMap==null) ? null : DBConn.executeQueryMap(queryMap,"selectFileNmChkCnt",pm);
			} catch (Exception e) {
				Log.Error("[Exception] " + e);
				throw new Exception("조회에 실패하였습니다.");
			}
	
			if( finmCnt == null || !"0".equals(String.valueOf(finmCnt.get("cnt"))) ) {
				memoObj.put("errorCode", 5);
	        	memoObj.put("errorMessage", "동일한 파일명이 존재합니다");
	        	memoArr.put(fileIndex, memoObj);
	        	throw new UserException("동일한 파일명이 존재합니다");
			}
	
			Map mpCnt = null;
			String pdfCnt = "";
			String saveFileNm = "";
			try{
				//쿼리 실행및 결과 받기.
				mpCnt  = (queryMap==null) ? null : DBConn.executeQueryMap(queryMap,"selectFileCnt",pm);
			} catch (Exception e) {
				Log.Error("[Exception] " + e);
				throw new Exception("조회에 실패하였습니다.");
			}
			if( mpCnt != null ) {
				pdfCnt = String.valueOf(mpCnt.get("cnt"));
			}
	
			if(Integer.valueOf(pdfCnt) > 0) {
				//등록된 파일이 존재하면 파일을 덮어 씌우기 위해 DB에 저장된 이름을 가져운다
				Map mpInfo = null;
				try{
					//쿼리 실행및 결과 받기.
					mpInfo  = (queryMap==null) ? null : DBConn.executeQueryMap(queryMap,"selectFileInfo",pm);
				} catch (Exception e) {
					Log.Error("[Exception] " + e);
					throw new Exception("조회에 실패하였습니다.");
				}
	
				if(mpInfo != null) {
					saveFileNm = String.valueOf(mpInfo.get("file_name"));
				}
	
			}
	
			if("".equals(saveFileNm)) {
				Date today = new Date();
				SimpleDateFormat date = new SimpleDateFormat("yyyyMMddHHmmss");
				String now = date.format(today);
				Random random = new Random();
				String randomNum = Integer.toString(random.nextInt(10000));
				saveFileNm = searchSabun+now+StringUtil.padLeft(randomNum, "0" ,4)+fileName.substring(fileName.lastIndexOf("."));
				//saveFileNm = searchSabun+now+StringUtil.padLeft((int)(Math.random()*10000)+"", "0" ,4)+fileName.substring(fileName.lastIndexOf("."));
			}
	
	
			//DB 컨트롤.
	        //사용자가 직접 트렌젝션 관리하기 위해 커넥션 가져오기.
	        Connection conn = DBConn.getConnection();
	
	        //사용자가 직접 트랜젝션 관리
	        conn.setAutoCommit(false);
	
	        try{
	
	        	//파일 정보 등록
	            String dbfilePath = "";
	            String saveFilePath = "";
	
	            String nfsUploadPath = StringUtil.getPropertiesValue("NFS.HRFILE.PATH");
	
	            int rstCnt = 0;
	
	            if(nfsUploadPath != null && nfsUploadPath.length() > 0) {
	            	if("1".equals(searchFileType)) {
	                	//hrfile/YEA_INCOME/회사코드/년도/
	                	dbfilePath = nfsUploadPath+StringUtil.getPropertiesValue("HRFILE.PATH")+"/YEA_INCOME/"+ssnEnterCd+"/"+searchWorkYy;
	                    saveFilePath = nfsUploadPath+StringUtil.getPropertiesValue("HRFILE.PATH")+"/YEA_INCOME/"+ssnEnterCd+"/"+searchWorkYy;
	                } else {
	                	//hrfile/YEA_ADDFILE/회사코드/년도/
	                	dbfilePath = nfsUploadPath+StringUtil.getPropertiesValue("HRFILE.PATH")+"/YEA_ADDFILE/"+ssnEnterCd+"/"+searchWorkYy;
	                    saveFilePath = nfsUploadPath+StringUtil.getPropertiesValue("HRFILE.PATH")+"/YEA_ADDFILE/"+ssnEnterCd+"/"+searchWorkYy;
	                }
	            } else {
	            	if("1".equals(searchFileType)) {
	                	//hrfile/YEA_INCOME/회사코드/년도/
	                	dbfilePath = StringUtil.getPropertiesValue("HRFILE.PATH")+"/YEA_INCOME/"+ssnEnterCd+"/"+searchWorkYy;
	                    saveFilePath = StringUtil.getPropertiesValue("WAS.PATH")+StringUtil.getPropertiesValue("HRFILE.PATH")+"/YEA_INCOME/"+ssnEnterCd+"/"+searchWorkYy;
	                } else {
	                	//hrfile/YEA_ADDFILE/회사코드/년도/
	                	dbfilePath = StringUtil.getPropertiesValue("HRFILE.PATH")+"/YEA_ADDFILE/"+ssnEnterCd+"/"+searchWorkYy;
	                    saveFilePath = StringUtil.getPropertiesValue("WAS.PATH")+StringUtil.getPropertiesValue("HRFILE.PATH")+"/YEA_ADDFILE/"+ssnEnterCd+"/"+searchWorkYy;
	                }
	            }
	            
	         	// 16자리 난수를 생성하여 실제 저장되는 파일명을 만든다.
	    		String tempFileNm = "";
	    		Random generator = new Random();
	    		for (int j = 0; j < 16; j++) {
	    			tempFileNm += Integer.toString(generator.nextInt(10));
	    		}
	
	            Map infoMap = new HashMap();
	
	            infoMap.put("ssnEnterCd", ssnEnterCd);
	            infoMap.put("ssnSabun", ssnSabun);
	
	            infoMap.put("workYy", searchWorkYy);         	//귀속년도
	            infoMap.put("adjustType", searchAdjustType); 	//정산구분
	            infoMap.put("sabun", searchSabun);           	//사원번호
	            infoMap.put("fileType", searchFileType);		//파일구분
	            infoMap.put("filePath", dbfilePath); 			//파일경로정보
	            infoMap.put("fileName", saveFileNm); 			//파일명
	            infoMap.put("attr1", fileName);					//ATTR1
	            infoMap.put("attr2", tempFileNm); 						//ATTR2
	            infoMap.put("attr3", ""); 						//ATTR3
	            infoMap.put("attr4", ""); 						//ATTR4
	
	            File dir = new File(saveFilePath);
	            if(!dir.exists()) dir.mkdirs();
	
	            File file = new File(saveFilePath, saveFileNm);
	            fileItem.write(file);
	            
	            if(Integer.valueOf(pdfCnt) > 0) {
	            	//파일이 존재하면 일자 업데이트 후 파일 처리
	            	rstCnt = DBConn.executeUpdate(conn, queryMap, "updateFileInfo", infoMap);
	            } else {
	            	//파일이 존재하지 않으면 데이터 등록 후 파일 처리
	            	rstCnt = DBConn.executeUpdate(conn, queryMap, "insertFileInfo", infoMap);
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
	            throw new Exception("데이터 처리중 오류가 발생하였습니다.\\n"+e.toString());
	        } finally {
	            DBConn.closeConnection(conn, null, null);
		        queryMap = null;
	        }
	
	        procYn = "Y";
	        procMessage = "업로드가 정상적으로 완료되었습니다.";
			if(Integer.valueOf(pdfCnt) > 0) {
				memoObj.put("errorMessage", "기존 등록된 자료에 정상적으로 업데이트 처리 되었습니다.");
			} else {
				memoObj.put("errorMessage", "업로드가 정상적으로 완료되었습니다.");
			}
			memoObj.put("errorCode", 0);
	    	memoArr.put(fileIndex, memoObj);
	    	fileIndex++;
	
	    } /* end of for */
    }
    Log.Debug("정상 업로드 완료");
    		
} catch(UserException ue) {
    Log.Debug("[UserException]" + ue.getMessage());
    procYn = "N";
    procMessage = ue.getMessage();
} catch(Exception ex) {
	Log.Error("[yeaDataAddFileUploadPopRst]: " + ex.getMessage());
    procYn = "N";
    procMessage = ex.toString().replace("\r", "").replace("\n", "");
} finally {
%>
<script>
	parent.procYn("<%=procYn%>","<%=procMessage%>","<%=memoArr.toString().replace("\"", "\\\"")%>");
</script>
<%
}
Log.Debug("==============================PDF 업로드 끝===============================");
%>

<%!

//교육비 자료 조회
public int saveNmTxt(Map paramMap, String locPath, String ssnYeaLogYn) throws Exception {
   List list = StringUtil.getParamListData(paramMap);
   //xml 파서를 이용한 방법;
   Map queryMap = XmlQueryParser.getQueryMap(locPath);
   
   Connection conn = DBConn.getConnection();
   int rstCnt = 0;

  //파라메터 복사.
  Map pm =  StringUtil.getParamMapData(paramMap);
  
  String searchWorkYy       = String.valueOf(pm.get("searchWorkYy"));
  String searchAdjustType   = String.valueOf(pm.get("searchAdjustType"));
  String searchSabun        = String.valueOf(pm.get("searchSabun"));
  String searchFileType     = String.valueOf(pm.get("searchFileType"));

  if(list != null && list.size() > 0 && conn != null) {

      //사용자가 직접 트랜젝션 관리
      conn.setAutoCommit(false);

	  try{
          for(int i = 0; i < list.size(); i++ ) {
              Map mp = (Map)list.get(i);
              String nm_txt    = (String)mp.get("nm_txt");
              String file_name = (String)mp.get("file_name");
              
              mp.put("nm_txt"           ,nm_txt);
              mp.put("file_name"        ,file_name);
              mp.put("searchWorkYy"     ,searchWorkYy);
              mp.put("searchAdjustType" ,searchAdjustType);
              mp.put("searchSabun"      ,searchSabun);
              mp.put("searchFileType"   ,searchFileType);
              
              //쿼리 실행및 결과 받기.
              rstCnt += DBConn.executeUpdate(conn,queryMap,"saveNmTxt",mp);
              saveLog(conn, mp, ssnYeaLogYn);
          }
          //커밋
          conn.commit();
	  }  catch(UserException e) {
	      try {
	          //롤백
	          conn.rollback();
	      } catch (Exception e1) {
	          Log.Error("[rollback Exception] " + e);
	      }
	      rstCnt = 0;
	      Log.Error("[Exception] " + e);
	      throw new Exception(e.getMessage());
	  } catch(Exception e) {
	      try {
	          //롤백
	          conn.rollback();
	      } catch (Exception e1) {
	          Log.Error("[rollback Exception] " + e);
	      }
	      rstCnt = 0;
	      Log.Error("[Exception] " + e);
	      throw new Exception("저장에 실패하였습니다.");
	  } finally {
	      DBConn.closeConnection(conn, null, null);
		  queryMap = null;
	  }
  }//end if
  return rstCnt;
}
%>
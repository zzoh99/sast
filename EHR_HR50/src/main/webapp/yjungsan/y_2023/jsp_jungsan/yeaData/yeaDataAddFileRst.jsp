<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="yjungsan.util.*"%>
<%@ page import="yjungsan.exception.*"%>
<%@ page import="java.sql.Connection"%>
<%@ page import="java.util.*"%>
<%@ page import="java.io.*"%>
<%@ page import="java.net.URLDecoder"%>

<%@ page import="org.json.JSONObject" %>
<%@ page import="org.json.JSONArray"%>
<%@ page import="com.hr.common.logger.Log" %>
<%@ include file="../common/include/session.jsp"%>
<%@ include file="../auth/saveLog.jsp"%>

<%@ page import="org.springframework.web.client.RestTemplate" %>
<%@ page import="org.springframework.http.HttpHeaders" %>
<%@ page import="org.springframework.http.HttpEntity" %>
<%@ page import="java.net.URLEncoder" %>
<%@ page import="org.springframework.http.ResponseEntity" %>
<%@ page import="org.springframework.http.HttpMethod" %>
<%!

//증빙자료 목록 조회
public List selectYeaDataAddFileList(Map paramMap, String locPath, String ssnYeaLogYn) throws Exception {

	//파라메터 복사.
	Map pm =  StringUtil.getParamMapData(paramMap);
	//xml 파서를 이용한 방법;
	Map queryMap = XmlQueryParser.getQueryMap(locPath);
	List listData = null;

	try{
		//쿼리 실행및 결과 받기.
		listData  = (queryMap == null) ? null : DBConn.executeQueryList(queryMap,"selectYeaDataAddFileList",pm);
		saveLog(null, pm, ssnYeaLogYn);
	} catch (Exception e) {
		Log.Error("[Exception] " + e);
		throw new Exception("조회에 실패하였습니다.");
	} finally {
		queryMap = null;
	}

	return listData;
}

public int deleteYeaDataAddFileData(Map paramMap, String locPath) throws Exception {

	// 사용자가 직접 트렌젝션 관리하기 위해 커넥션 가져오기.
    Connection conn = DBConn.getConnection();
	//xml 파서를 이용한 방법;
	Map queryMap = XmlQueryParser.getQueryMap(locPath);
    int rstCnt = 0;

    if (conn != null) {
	    try {
	    	conn.setAutoCommit(false);
	
	    	rstCnt = DBConn.executeUpdate(conn, queryMap, "deleteYeaDataAddFileData", paramMap);
	    	conn.commit();
	    } catch( Exception e ) {
	    	try {
	            //롤백
	            conn.rollback();
	        } catch (Exception e1) {
	            Log.Error("[rollback Exception] " + e);
	        }
	        rstCnt = 0;
	        Log.Error("[Exception] " + e);
	        throw new Exception("삭제에 실패하였습니다.");
	    } finally {
	    	DBConn.closeConnection(conn, null, null);
			queryMap = null;
	    }
    }

	return rstCnt;
}
public int saveYeaDataFileList(Map paramMap, String locPath, String ssnYeaLogYn) throws Exception {
    //파라메터 맵안에는 배열형태로 저장되어 있으니 다시 리스트형태로 뽑아서 루프를 돈다.
    List list = StringUtil.getParamListData(paramMap);
	//xml 파서를 이용한 방법;
	Map queryMap = XmlQueryParser.getQueryMap(locPath);
    Map pm =  StringUtil.getParamMapData(paramMap);
    //사용자가 직접 트렌젝션 관리하기 위해 커넥션 가져오기.
    Connection conn = DBConn.getConnection();
    int rstCnt = 0;

    if(list != null && list.size() > 0 && conn != null) {

        //사용자가 직접 트랜젝션 관리
        conn.setAutoCommit(false);

        try{

            String searchSabun  = (String)pm.get("searchSabun");
            String searchWorkYy = (String)pm.get("searchWorkYy");
            String searchAdjustType  = (String)pm.get("searchAdjustType");
			
            for(int i = 0; i < list.size(); i++ ) {
                String query = "";
                Map mp = (Map)list.get(i);
                String sStatus  = (String)mp.get("sStatus");
                String fileType = (String)mp.get("file_type");
                String fileSeq  = (String)mp.get("file_seq");
                
                mp.put("fileType", fileType);
                mp.put("fileSeq", fileSeq);
                mp.put("searchSabun", searchSabun);
                mp.put("searchWorkYy", searchWorkYy);
                mp.put("searchAdjustType", searchAdjustType);

                if("U".equals(sStatus)) {
                    //수정
                    rstCnt += DBConn.executeUpdate(conn, queryMap, "updateYeaDataFileList", mp);
                }
                saveLog(conn, mp, ssnYeaLogYn);
            }

            //커밋
            conn.commit();
        } catch(UserException e) {
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
    }

    return rstCnt;
}
//연말정산 옵션 저장.
public int setConFileFunc(Map paramMap, String locPath) throws Exception {

	List list = StringUtil.getParamListData(paramMap);
	//xml 파서를 이용한 방법;
	Map queryMap = XmlQueryParser.getQueryMap(locPath);

    Connection conn = DBConn.getConnection();

    int rstCnt = 0;

    if(list != null && list.size() > 0 && conn != null) {

        conn.setAutoCommit(false);

        try{
            for(int i = 0; i < list.size(); i++ ) {
                String query = "";
                Map mp = (Map)list.get(i);
                String sStatus = (String)mp.get("sStatus");
                
                if("U".equals(sStatus)) {
                    rstCnt += DBConn.executeUpdate(conn, queryMap, "setConFileFunc", mp);
                //saveLog(conn, mp);
                }
            }

            //커밋
            conn.commit();
        } catch(UserException e) {
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
    }

    return rstCnt;
}
%>

<%
	String locPath = xmlPath+"/yeaData/yeaDataAddFile.xml";

	String ssnEnterCd = (String)session.getAttribute("ssnEnterCd");
	String ssnSabun = (String)session.getAttribute("ssnSabun");
	String ssnYeaLogYn = (String)session.getAttribute("ssnYeaLogYn");
	String cmd = (String)request.getParameter("cmd");

	if("selectYeaDataAddFileList".equals(cmd)) {
		//증빙자료 목록 조회
		Map mp = StringUtil.getRequestMap(request);
		mp.put("ssnEnterCd", ssnEnterCd);
		mp.put("ssnSabun", ssnSabun);
		mp.put("cmd", cmd);
		List listData  = new ArrayList();
		String message = "";
		String code = "1";

		try {
			listData = selectYeaDataAddFileList(mp, locPath, ssnYeaLogYn);
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
		out.print((new org.json.JSONObject(rstMap)).toString());

	} else if("deleteYeaDataAddFileList".equals(cmd)) {
		//PDF 파일 삭제
        Map mp = StringUtil.getRequestMap(request);
        //String paramYear       = request.getParameter("searchWorkYy").toString();
        String paramYear       = request.getParameter("searchWorkYy");
        String fileUploadType       = request.getParameter("fileUploadType").toString();
        if (paramYear != null) {
        	paramYear = paramYear.toString();
        }
	    //String paramValue    	= request.getParameter("pValue").toString();
	    String paramValue    	= request.getParameter("pValue");
	    if (paramValue != null) {
	    	paramValue = paramValue.toString();
        }

		JSONArray jsonArr = new JSONArray(paramValue);
		JSONObject jsonObj = null;

		String serverPath = "";
		String filePath = "";
		String nfsUploadPath = StringUtil.getPropertiesValue("NFS.HRFILE.PATH");

		if(nfsUploadPath != null && nfsUploadPath.length() > 0) {
			serverPath = nfsUploadPath+StringUtil.getPropertiesValue("HRFILE.PATH");
        } else {
        	serverPath = StringUtil.getPropertiesValue("WAS.PATH")+StringUtil.getPropertiesValue("HRFILE.PATH");
        }

		String message = "";
        String code = "1";
        Map param = null;

		if(jsonArr == null || jsonArr.length() == 0) {
			code = "-1";
   	    	message = "잘못된 파라메터";
		} else {

			for(int i=0; i<jsonArr.length(); i++) {
				jsonObj = jsonArr.getJSONObject(i);

				param = new HashMap();
			    param.put("ssnEnterCd", ssnEnterCd);
			    param.put("sabun", jsonObj.getString("sabun"));
			    param.put("workYy", jsonObj.getString("workYy"));
			    param.put("adjustType", jsonObj.getString("adjustType"));
			    param.put("fileType", jsonObj.getString("fileType"));
			    param.put("fileSeq", jsonObj.getString("fileSeq"));

			    String fileName = jsonObj.getString("fileName");
			    String fileType = jsonObj.getString("fileType");
			    
			  	//2023.12.22 : s3 or 기본 분기처리 로직 추가
			  	if(fileUploadType.equals("1")){
			  		if("1".equals(fileType)) {
		            	filePath = "/YEA_INCOME/"+ssnEnterCd+"/"+paramYear;
		            } else {
		            	filePath = "/YEA_ADDFILE/"+ssnEnterCd+"/"+paramYear;
		            }
			  		param.put("fileUploadType", "1");
			  		try {
						boolean flag = true;
						String listEndpoint = getOptiPropertiesValue("s3.api.end.point.delete");
						String apiUrl 		= getOptiPropertiesValue("s3.api.url") + listEndpoint;
						String bucketName 	= getOptiPropertiesValue("s3.api.bucket.name");
						String key 			= filePath.substring(1)+"/"+fileName;

						// Create a JSONObject for request parameters
						org.json.simple.JSONObject requestParams = new org.json.simple.JSONObject();
						requestParams.put("bucketName", bucketName);
						requestParams.put("key", key);

						// Create a RestTemplate
						RestTemplate restTemplate = new RestTemplate();

						// Set request headers
						HttpHeaders headers = new HttpHeaders();
						headers.set("accept", "*/*");
						headers.set("Origin", "http://localhost"); // 원본 도메인 설정
						headers.set("Access-Control-Request-Method", "GET, POST, PUT, DELETE"); // 허용할 HTTP 메서드 설정
						headers.set("Access-Control-Request-Headers", "authorization, content-type"); // 허용할 헤더 설정
						//headers.set("Authorization", "Bearer your-access-token"); // 필요한 경우 인증 정보 설정

						// Create an HttpEntity with the request body and headers
						HttpEntity<String> requestEntity = new HttpEntity<>(requestParams.toString(), headers);

						// Create the queryString
						String queryString = "bucketName=" + URLEncoder.encode(bucketName, "UTF-8") + "&key=" + URLEncoder.encode(key, "UTF-8");
						//String queryString = "bucketName=" + bucketName + "&key=" + key;
						apiUrl += "?" + queryString;

						ResponseEntity<org.json.simple.JSONObject> responseEntity = restTemplate.exchange(
								apiUrl,
								HttpMethod.DELETE,
								new HttpEntity<>(headers),
								org.json.simple.JSONObject.class);

						// 응답 처리
						if (responseEntity.getStatusCodeValue() == 200) {
							// 성공적인 응답 처리
							org.json.simple.JSONObject responseBody = responseEntity.getBody();
							// 파일 데이터 삭제
							if(deleteYeaDataAddFileData(param, locPath) != 1) {
								flag = false;
							}
						} else {
							// 에러 응답 처리
							Log.Debug("============================================================");
							Log.Debug("HTTP 요청 실패: " + responseEntity.getStatusCode());
							Log.Debug("============================================================");
						}

						if(!flag) {
							code = "-1";
							message = "파일 삭제에 실패 하였습니다.";
							break;
						} else {
							code = "1";
							message = "파일 삭제에 성공 하였습니다.";
						}

			        } catch(Exception e) {
			            code = "-1";
			            message = e.getMessage();
			            break;
			        }
			  	} else{
			  		param.put("fileUploadType", "0");
			  		if("1".equals(fileType)) {
		            	//hrfile/YEA_INCOME/회사코드/년도/
		            	filePath = serverPath+"/YEA_INCOME/"+ssnEnterCd+"/"+paramYear;
		            } else {
		            	//hrfile/YEA_ADDFILE/회사코드/년도/
		            	filePath = serverPath+"/YEA_ADDFILE/"+ssnEnterCd+"/"+paramYear;
		            }

				    try {
			       	    File f = new File(filePath+"/"+fileName); // 파일 객체생성
			       	    if( f.exists()) {
			       	    	boolean flag = true;

			       	    	if(f.delete()){ // 파일이 존재하면 파일을 삭제한다.

			       	    		// 파일 데이터 삭제
			       	    		if(deleteYeaDataAddFileData(param, locPath) != 1) {
			       	    			flag = false;
			       	    		}
			       	    	} else {
			       	    		flag = false;
			       	    	}

			       	    	if(!flag) {
			       	    	    code = "-1";
			                    message = "파일 삭제에 실패 하였습니다.";
			                    break;
			                } else {
			                	code = "1";
			                	message = "파일 삭제에 성공 하였습니다.";
			                }
			       	    } else {
			       	    	code = "-1";
			       	    	message = "삭제할 파일이 존재하지 않습니다.";
			       	    	break;
			       	    }
			        } catch(Exception e) {
			            code = "-1";
			            message = e.getMessage();
			            break;
			        }	
			  	}
			}
		}

        Map mapCode = new HashMap();
        mapCode.put("Code", code);
        mapCode.put("Message", message);

        Map rstMap = new HashMap();
        rstMap.put("Result", mapCode);
        out.print((new org.json.JSONObject(rstMap)).toString());
	} else if("saveYeaDataFileList".equals(cmd)) {

        Map mp = StringUtil.getRequestMap(request);
        
        
        mp.put("ssnEnterCd", ssnEnterCd);
        mp.put("ssnSabun", ssnSabun);
        mp.put("cmd", cmd);
        String message = "";
        String code = "1";

        try {
            int cnt = saveYeaDataFileList(mp, locPath, ssnYeaLogYn);

            if(cnt > 0) {
                message = "저장되었습니다.";
            } else {
                code = "-1";
                message = "저장된 내용이 없습니다.";
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

    } else if("setConFileFunc".equals(cmd)) {
        //파일기능제어

        Map mp = StringUtil.getRequestMap(request);

        mp.put("ssnEnterCd", ssnEnterCd);
        mp.put("ssnSabun", ssnSabun);
        mp.put("cmd", cmd);
        String message = "";
        String code = "1";
        
        try {
            int cnt = setConFileFunc(mp, locPath);
        
            if(cnt > 0) {
                message = "저장되었습니다.";
            } else {
                code = "-1";
                message = "저장된 내용이 없습니다.";
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
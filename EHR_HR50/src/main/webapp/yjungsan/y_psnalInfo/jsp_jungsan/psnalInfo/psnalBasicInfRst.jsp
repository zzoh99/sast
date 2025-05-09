<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="yjungsan.util.*"%>
<%@ page import="yjungsan.exception.*"%>
<%@ page import="java.sql.Connection"%>
<%@ page import="java.util.List"%>
<%@ page import="java.util.ArrayList"%>
<%@ page import="java.util.Map"%>
<%@ page import="java.util.HashMap"%>

<%@ page import="com.hr.common.logger.Log" %>
<%@ include file="../common/include/session.jsp"%>
<%!
//private Logger log = Logger.getLogger(this.getClass());

//public Map queryMap = null;

//xml 파서를 이용한 방법;
/* public void setQueryMap(String path) {
    queryMap = XmlQueryParser.getQueryMap(path);
} */



//인적사항관리 조회
public List selectPsnalBasicInfLst(String path, Map paramMap) throws Exception {
	Map queryMap = XmlQueryParser.getQueryMap(path);
    //파라메터 복사.
    Map pm =  StringUtil.getParamMapData(paramMap);
    List list = null;
    
    try{
        //쿼리 실행및 결과 받기.
        list  = (queryMap == null) ? null : DBConn.executeQueryList(queryMap,"selectPsnalBasicInfLst",pm);
    } catch (Exception e) {
        Log.Error("[Exception] " + e);
        throw new Exception("조회에 실패하였습니다.");
    }
    
    return list;
}


//인적사항관리 저장.
public int savePsnalBasicInf(String path, Map paramMap) throws Exception {
	queryMap = XmlQueryParser.getQueryMap(path);
    //파라메터 맵안에는 배열형태로 저장되어 있으니 다시 리스트형태로 뽑아서 루프를 돈다.
    List list = StringUtil.getParamListData(paramMap);

    //사용자가 직접 트렌젝션 관리하기 위해 커넥션 가져오기.
    Connection conn = DBConn.getConnection();
    int rstCnt = 0;
    
    if(conn != null && list != null && list.size() > 0) {
    
        //사용자가 직접 트랜젝션 관리
        conn.setAutoCommit(false);
        
        try{
            for(int i = 0; i < list.size(); i++ ) {
                String query = "";
                Map mp = (Map)list.get(i);
                String sStatus = (String)mp.get("sStatus");
                
                if("D".equals(sStatus)) {
                    //삭제
                    rstCnt += DBConn.executeUpdate(conn, queryMap, "deletePsnalBasicInf", mp);
                } else if("U".equals(sStatus)) {
                    //수정
                    rstCnt += DBConn.executeUpdate(conn, queryMap, "updatePsnalBasicInf", mp);
                } else if("I".equals(sStatus)) {
                	//입력 중복체크
					Map dupMap = DBConn.executeQueryMap(conn, queryMap,"selectPsnalBasicInfCnt",mp);
					
					if(dupMap != null && Integer.parseInt((String)dupMap.get("cnt")) > 0 ) {
						throw new UserException("중복되어 저장할 수 없습니다.");
					}
					
                    //입력
                    rstCnt += DBConn.executeUpdate(conn, queryMap, "insertPsnalBasicInf", mp);
                }
            }
            
            //커밋
            conn.commit();
        } catch(UserException e) {
            try {
                //롤백
                if (conn != null) conn.rollback();
            } catch (Exception e1) {
                Log.Error("[rollback Exception] " + e);
            }
            rstCnt = 0;
            Log.Error("[Exception] " + e);
            throw new Exception(e.getMessage());
        } catch(Exception e) {
            try {
                //롤백
                if (conn != null) conn.rollback();
            } catch (Exception e1) {
                Log.Error("[rollback Exception] " + e);
            }
            rstCnt = 0;
            Log.Error("[Exception] " + e);
            throw new Exception("저장에 실패하였습니다.");
        } finally {
            DBConn.closeConnection(conn, null, null);
        }
    }
    
    return rstCnt;
}

%>

<%
    //쿼리 맵 셋팅
    //setQueryMap(xmlPath+"/psnalInfo/psnalBasicInf.xml");

    String ssnEnterCd = (String)session.getAttribute("ssnEnterCd");
    String ssnSabun = (String)session.getAttribute("ssnSabun");
    String cmd = (String)request.getParameter("cmd");

    if("selectPsnalBasicInfLst".equals(cmd)) {
        //인적사항관리 조회 
        
        Map mp = StringUtil.getRequestMap(request);
        mp.put("ssnEnterCd", ssnEnterCd);
        mp.put("ssnSabun", ssnSabun);
        
        List listData  = new ArrayList();
        String message = "";
        String code = "1";

        try {
            listData = selectPsnalBasicInfLst(xmlPath+"/psnalInfo/psnalBasicInf.xml", mp);
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
        
    }  else if("savePsnalBasicInf".equals(cmd)) {
        //인적사항관리 저장
        
        Map mp = StringUtil.getRequestMap(request);
        mp.put("ssnEnterCd", ssnEnterCd);
        mp.put("ssnSabun", ssnSabun);
        
        List listMap = StringUtil.getParamListData(mp);
        
        String message = "";
        String code = "1";
        
        try {
            /*
        	int cnt = savePsnalBasicInf(mp);
            if(cnt > 0) {
            	
            	//자료생성 프로시저 호출
            	String[] type =  new String[]{"OUT","OUT","STR","STR"};
            	String[] param = new String[]{"","",ssnEnterCd,ssnSabun};
            	
            	String rtnStr = "";
            	
            	try {
            		
            		String[] rstStr = DBConn.executeProcedure("P_HRM_INSA_IF_SAVE",type,param);
            		
            		if(rstStr[1] == null || rstStr[1].length() == 0) {
        				message = "저장되었습니다.";
        			} else {
        				code = "-1";
        				message = "자료생성 처리도중 : "+rstStr[1];
        			}
            		
        		} catch(Exception e) {
        			code = "-1";
        			message = e.getMessage();
        		}
            	
            } else {
                code = "-1";
                message = "저장된 내용이 없습니다.";
            }
            */
			
            int cnt = savePsnalBasicInf(xmlPath+"/psnalInfo/psnalBasicInf.xml", mp);
            if(cnt > 0) {
	            try {
	            	
		            for(int i = 0; i < listMap.size(); i++) {
						Map data = (Map)listMap.get(i);
						
						String sStatus = (String)data.get("sStatus");
		
						if("I".equals(sStatus)) {
							String sabun = (String)data.get("sabun");
							
							String[] type =  new String[]{"OUT","OUT","STR","STR","STR","STR"};
			            	String[] param = new String[]{"","",ssnEnterCd,sabun,"I",ssnSabun};
							
							String[] rstStr = DBConn.executeProcedure("P_HRM_INSA_IF_SAVE",type,param);
							
							if(rstStr[1] == null || rstStr[1].length() == 0) {
		        				message = "저장되었습니다.";
		        			} else {
		        				code = "-1";
		        				message = "자료생성 처리도중 : "+rstStr[1];
		        			}
	
	
						}
						else if("U".equals(sStatus)) {
							String sabun = (String)data.get("sabun");
							
							String[] type =  new String[]{"OUT","OUT","STR","STR","STR","STR"};
			            	String[] param = new String[]{"","",ssnEnterCd,sabun,"U",ssnSabun};
							
							String[] rstStr = DBConn.executeProcedure("P_HRM_INSA_IF_SAVE",type,param);
							
							if(rstStr[1] == null || rstStr[1].length() == 0) {
		        				message = "저장되었습니다.";
		        			} else {
		        				code = "-1";
		        				message = "자료생성 처리도중 : "+rstStr[1];
		        			}
							
						}
						else if("D".equals(sStatus)) {
							String sabun = (String)data.get("sabun");
							
							String[] type =  new String[]{"OUT","OUT","STR","STR","STR","STR"};
			            	String[] param = new String[]{"","",ssnEnterCd,sabun,"D",ssnSabun};
							
							String[] rstStr = DBConn.executeProcedure("P_HRM_INSA_IF_SAVE",type,param);
							
							if(rstStr[1] == null || rstStr[1].length() == 0) {
		        				message = "저장되었습니다.";
		        			} else {
		        				code = "-1";
		        				message = "자료생성 처리도중 : "+rstStr[1];
		        			}
							
						}
					}
	            }
	            catch(Exception e){
	            	code = "-1";
	                message = e.getMessage();
	            }
	            
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
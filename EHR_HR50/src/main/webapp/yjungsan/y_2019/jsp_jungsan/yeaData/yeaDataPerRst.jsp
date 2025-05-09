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

//과거인적공제 현황 자료 조회
public List selectPastYeaDataPerList(Map paramMap, String locPath) throws Exception {

	//파라메터 복사.
	Map pm =  StringUtil.getParamMapData(paramMap);
	Map queryMap = XmlQueryParser.getQueryMap(locPath);
	List listData = null;
	
	try{
		//쿼리 실행및 결과 받기.
		listData  = (queryMap == null) ? null : DBConn.executeQueryList(queryMap,"selectPastYeaDataPerList",pm);
	} catch (Exception e) {
		Log.Error("[Exception] " + e);
		throw new Exception("조회에 실패하였습니다.");
	}
	
	return listData;
}

//장애인등록증 현황 자료 조회
public List selectYeaDataHndcpRegInfoList(Map paramMap, String locPath) throws Exception {

	//파라메터 복사.
	Map pm =  StringUtil.getParamMapData(paramMap);
	Map queryMap = XmlQueryParser.getQueryMap(locPath);
	List listData = null;
	
	try{
		//쿼리 실행및 결과 받기.
		listData  = (queryMap == null) ? null : DBConn.executeQueryList(queryMap,"selectYeaDataHndcpRegInfoList",pm);
	} catch (Exception e) {
		Log.Error("[Exception] " + e);
		throw new Exception("조회에 실패하였습니다.");
	}
	
	return listData;
}

//장애인등록증 현황 자료 저장
public int saveYeaDataHndcpRegInfo(Map paramMap, String locPath) throws Exception {
	//파라메터 맵안에는 배열형태로 저장되어 있으니 다시 리스트형태로 뽑아서 루프를 돈다.
	List list = StringUtil.getParamListData(paramMap);
	Map queryMap = XmlQueryParser.getQueryMap(locPath);

	//사용자가 직접 트렌젝션 관리하기 위해 커넥션 가져오기.
	Connection conn = DBConn.getConnection();
	int rstCnt = 0;
	
	if(list != null && list.size() > 0 && conn != null) {
	
		//사용자가 직접 트랜젝션 관리
		conn.setAutoCommit(false);
		
		try{
			for(int i = 0; i < list.size(); i++ ) {
				String query = "";
				Map mp = (Map)list.get(i);
				String sStatus = (String)mp.get("sStatus");
				String workYy = (String)mp.get("work_yy");
				String adjustType = (String)mp.get("adjust_type");
				String sabun = (String)mp.get("sabun");
				String famres = (String)mp.get("famres");
				String hndcpYn = (String)mp.get("hndcp_yn");
				String hndcpType = (String)mp.get("hndcp_type");
				
				if("I".equals(sStatus) || "U".equals(sStatus)) {
					//입력
					
					Map sp = new HashMap();
					sp.put("ssnEnterCd",mp.get("ssnEnterCd"));
					sp.put("ssnSabun",mp.get("ssnSabun"));
					sp.put("searchWorkYy",workYy);
					sp.put("searchAdjustType",adjustType);
					sp.put("searchSabun",sabun);
					sp.put("searchFamres",famres);
					
					Map sm  = (queryMap == null) ? null : DBConn.executeQueryMap(queryMap, "selectYeaDataHndcpRegInfo", sp);
					
					if("Y".equals(hndcpYn)) {
						if(sm == null || sm.size() == 0) {
							rstCnt += DBConn.executeUpdate(conn, queryMap, "insertYeaDataHndcpRegInfo", mp);
						} else {
							/*
							 * 기준년이 같고 장애구분이 같으면 skip
							 * 기준년이 같고 장애구분이 다르면 update
							 * 기준년이 다르고 장애구분이 같으면 skip
							 * 기준년이 다르고 장애구분이 다르면 insert
							*/
							if(!hndcpType.equals(String.valueOf(sm.get("hndcp_type")))) {
								if(workYy.equals(String.valueOf(sm.get("work_yy")))) {
									rstCnt += DBConn.executeUpdate(conn, queryMap, "updateYeaDataHndcpRegInfo", mp);
								} else {
									rstCnt += DBConn.executeUpdate(conn, queryMap, "insertYeaDataHndcpRegInfo", mp);
								}
							}
						}
						
					} else {
						//자동삭제도 추가 - 기준년도가 같은 경우에만 삭제하기로 함
						if(workYy.equals(String.valueOf(sm.get("work_yy")))) {
							rstCnt += DBConn.executeUpdate(conn, queryMap, "deleteYeaDataHndcpRegDetail", mp);
						}
					}
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
		}
	}
	
	return rstCnt;
}

//장애인등록증 현황 자료 저장
public int saveYeaDataHndcpRegDetail(Map paramMap, String locPath) throws Exception {
	//파라메터 맵안에는 배열형태로 저장되어 있으니 다시 리스트형태로 뽑아서 루프를 돈다.
	List list = StringUtil.getParamListData(paramMap);
	Map queryMap = XmlQueryParser.getQueryMap(locPath);

	//사용자가 직접 트렌젝션 관리하기 위해 커넥션 가져오기.
	Connection conn = DBConn.getConnection();
	int rstCnt = 0;
	
	if(list != null && list.size() > 0 && conn != null) {
	
		//사용자가 직접 트랜젝션 관리
		conn.setAutoCommit(false);
		
		try{
			for(int i = 0; i < list.size(); i++ ) {
				String query = "";
				Map mp = (Map)list.get(i);
				String sStatus = (String)mp.get("sStatus");
				String workYy = (String)mp.get("work_yy");
				String adjustType = (String)mp.get("adjust_type");
				String sabun = (String)mp.get("sabun");
				String famres = (String)mp.get("famres");
				String hndcpYn = (String)mp.get("hndcp_yn");
				String hndcpType = (String)mp.get("hndcp_type");
				
				if("U".equals(sStatus)) {
					rstCnt += DBConn.executeUpdate(conn, queryMap, "updateYeaDataHndcpRegDetail", mp);
				} else if("D".equals(sStatus)) {
					rstCnt += DBConn.executeUpdate(conn, queryMap, "deleteYeaDataHndcpRegDetail", mp);
				} else {}
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
		}
	}
	
	return rstCnt;
}

%>

<%
	String locPath = xmlPath+"/yeaData/yeaDataPer.xml";
	Map queryMap = XmlQueryParser.getQueryMap(locPath);

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
				,"STR","STR","STR","STR","STR","STR"};
		
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
					/* 20181101 6세이하 자녀양육 제거 및 관련 로직 제거 */
					//String child_yn = (String)mp.get("child_yn");
                    String adopt_born_yn = (String)mp.get("adopt_born_yn");
                    String child_order = (String)mp.get("child_order");
                    String add_child_yn = (String)mp.get("add_child_yn"); //2019-11-11. 자녀세액공제 추가
                    
                    //주민등록번호 공백 및 '-' 제거 - 2020.01.30
                    if(famres != null) {
                    	famres = famres.replace("-", "").trim();
                    }
					
					String[] param = new String[]{"","",sStatus,ssnEnterCd,workYy
							,adjustType,sabun,famres,famCd,famNm
							,child_order,dpndntYn,spouseYn,seniorYn,hndcpYn
							,hndcpType,womanYn,oneParentYn,/* child_yn, */add_child_yn,adopt_born_yn,ssnSabun};
					
					String[] rstStr = DBConn.executeProcedure("PKG_CPN_YEA_"+yeaYear+"_SYNC.FAMILY_INS",type,param);
					
					if(rstStr[1] == null || rstStr[1].length() == 0) {
						cnt++;
					} else {
						message = message + "\n\n" + rstStr[1];
					}
					
				}
			}
			
			if(cnt > 0) {
				
				try{
					//장애인등록증 처리
					paramMap.put("ssnEnterCd", ssnEnterCd);
					paramMap.put("ssnSabun", ssnSabun);
					saveYeaDataHndcpRegInfo(paramMap, locPath);
				} catch(Exception e) {
					Log.Error("[yeaDataPerRst]:" + e.getMessage());
				}
				
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
		
	} else if("saveYeaDataPerConfirm".equals(cmd)){

		String inputStatus = request.getParameter("input_status");
		
        Map mp = StringUtil.getRequestMap(request);
        mp.put("ssnEnterCd", ssnEnterCd);
        mp.put("sabun", request.getParameter("sabun"));
        mp.put("adjust_type", request.getParameter("adjust_type"));
        mp.put("work_yy", request.getParameter("work_yy"));
        mp.put("input_status", inputStatus); 
        
        String message = "";
        String code = "1";
        
		//사용자가 직접 트렌젝션 관리하기 위해 커넥션 가져오기.
	    Connection conn = DBConn.getConnection();
	    int rstCnt = 0;		
	    if (conn != null) {
		    try{
			    //사용자가 직접 트랜젝션 관리
		        conn.setAutoCommit(false);
			    
		        rstCnt = DBConn.executeUpdate(conn, queryMap, "updateYeaDataPerConfirm", mp);
		        
		        if(rstCnt > 0) {
	                message = "1".equals(inputStatus) ? "확정되었습니다." : "확정 취소 되었습니다.";
	            } else {
	                code = "-1";
	                message = "1".equals(inputStatus) ? "확정 된 내역이 없습니다." : "확정 취소 된 내역이 없습니다.";
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
	            rstCnt = 0;
	            Log.Error("[Exception] " + e);

				Log.Error("[yeaDataPerRst]:" + e.getMessage());
	            
	            code = "-1";
	            message = "2".equals(inputStatus) ? "확정에 실패하였습니다." : "확정 취소에 실패하였습니다.";
		    } finally {
	            DBConn.closeConnection(conn, null, null);
	        }
	    }
	    Map mapCode = new HashMap();
        mapCode.put("Code", code);
        mapCode.put("Message", message);
        
        Map rstMap = new HashMap();
        rstMap.put("Result", mapCode);
        
        out.print((new org.json.JSONObject(rstMap)).toString());
	} else if("selectPastYeaDataPerList".equals(cmd)){

		//인적공제 자료 조회
		
		Map mp = StringUtil.getRequestMap(request);
		mp.put("ssnEnterCd", ssnEnterCd);
		mp.put("ssnSabun", ssnSabun);
		
		List listData  = new ArrayList();
		String message = "";
		String code = "1";
	
		try {
			listData = selectPastYeaDataPerList(mp, locPath);
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
		
	
	}  else if("selectYeaDataHndcpRegInfoList".equals(cmd)){

		//장애인등록증 현황 조회
		
		Map mp = StringUtil.getRequestMap(request);
		mp.put("ssnEnterCd", ssnEnterCd);
		mp.put("ssnSabun", ssnSabun);
		
		List listData  = new ArrayList();
		String message = "";
		String code = "1";
	
		try {
			listData = selectYeaDataHndcpRegInfoList(mp, locPath);
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
		
	
	} else if("saveYeaDataHndcpRegDetail".equals(cmd)) {
		//기부금 내역 저장
		
		Map paramMap = StringUtil.getRequestMap(request);
		paramMap.put("ssnEnterCd", ssnEnterCd);
		paramMap.put("ssnSabun", ssnSabun);
		
		List listMap = StringUtil.getParamListData(paramMap);
		
		String message = "";
		String code = "1";
		int cnt = 0;
		
		try {
			
			cnt = saveYeaDataHndcpRegDetail(paramMap, locPath);
			
			if(cnt > 0) {
				if(message.length() == 0) {
					message = "저장되었습니다.";
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
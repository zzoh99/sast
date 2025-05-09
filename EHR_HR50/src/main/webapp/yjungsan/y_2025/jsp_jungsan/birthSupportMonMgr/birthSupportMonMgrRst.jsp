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
<%@ include file="../auth/saveLog.jsp"%>
<%!

//출산지원금 조회
public List selectBirthSupportMonMgr(Map paramMap, String locPath, String ssnYeaLogYn) throws Exception {

    //파라메터 복사.
    Map pm =  StringUtil.getParamMapData(paramMap);
	//xml 파서를 이용한 방법;
	Map queryMap = XmlQueryParser.getQueryMap(locPath);
    List list = null;

    try{
        //쿼리 실행및 결과 받기.
        list  = (queryMap == null) ? null : DBConn.executeQueryList(queryMap,"selectBirthSupportMonMgr",pm);
        saveLog(null, pm, ssnYeaLogYn);
    } catch (Exception e) {
        Log.Error("[Exception] " + e);
        throw new Exception("조회에 실패하였습니다.");
    } finally {
		queryMap = null;
	}
    
    return list;
}


//출산지원금 저장.
public int saveBirthSupportMonMgr(Map paramMap, String locPath, String ssnYeaLogYn, String locYeaYear) throws Exception {

	//xml 파서를 이용한 방법;
	Map queryMap = XmlQueryParser.getQueryMap(locPath);
    //파라메터 맵안에는 배열형태로 저장되어 있으니 다시 리스트형태로 뽑아서 루프를 돈다.
    List list = StringUtil.getParamListData(paramMap);

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
                Map mp2 = (Map)list.get(0);
                String menuNm = (String)mp2.get("menuNm");
                mp.put("menuNm", menuNm);
                if("D".equals(sStatus)) {
                    //삭제
                    rstCnt += DBConn.executeUpdate(conn, queryMap, "deleteBirthSupportMonMgr", mp);
                } else if("U".equals(sStatus)) {
                    //수정
                    rstCnt += DBConn.executeUpdate(conn, queryMap, "updateBirthSupportMonMgr", mp);
                } else if("I".equals(sStatus)) {
                    //입력
                    
                    //중복체크
                    Map dupChk = DBConn.executeQueryMap(queryMap, "selectDupChk", mp);
                    
                    if((String)dupChk.get("work_yy") != null) {
                    	String errMsg = "\n - 대상년도 : " + (String)dupChk.get("work_yy")
				           + "\n - 정산구분 : " + (String)dupChk.get("adjust_type")
					       + "\n - 사번 : " + (String)dupChk.get("sabun")
					       + "\n - 자녀성명 : " + (String)dupChk.get("fam_nm")
					       + "\n - 주민등록번호 : " + (String)dupChk.get("famres")
					       + "\n - 지급회차 : " + (String)dupChk.get("sup_cnt")+"회차"
					       ;
                    	throw new UserException("중복되어 저장할 수 없습니다." + errMsg);  
					}
                    
                    rstCnt += DBConn.executeUpdate(conn, queryMap, "insertBirthSupportMonMgr", mp);	
                }
                saveLog(conn, mp, ssnYeaLogYn);

                //아래의 PKG_CPN_YEA_년도_SYNC.CHILD_BIRTH_INS 내에서 변경된 금액으로 
                //TCPN815, TCPN181, TCPN843을 합산해야 하는데 이전 자료를 계속 참조하므로 TCPN887 변경 사항에 대하여 개별 커밋을 선진행함.
                conn.commit();

				String[] type =  new String[]{"OUT", "OUT", "STR", "STR", "STR", "STR", "STR"};
				String[] param = new String[]{ ""
						                     , ""
						                     , (String)paramMap.get("ssnEnterCd")
						                     , (String)mp.get("work_yy")
						                     , (String)mp.get("adjust_type")
						                     , (String)mp.get("sabun")
						                     , (String)paramMap.get("ssnSabun") 
						                     };

				/* saveBirthSupportMonMgr 메소드가 선언문 내에 존재해서 include문서 내에 선언된 yeaYear 변수를 참조하지 못하므로 파라미터로 받아서 처리
				DBConn.executeProcedure("PKG_CPN_YEA_"+yeaYear+"_SYNC.CHILD_BIRTH_INS",type,param); */
				DBConn.executeProcedure("PKG_CPN_YEA_"+locYeaYear+"_SYNC.CHILD_BIRTH_INS",type,param);
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
    String locPath = xmlPath+"/birthSupportMonMgr/birthSupportMonMgr.xml";

    String ssnEnterCd = (String)session.getAttribute("ssnEnterCd");
    String ssnSabun = (String)session.getAttribute("ssnSabun");
    String ssnYeaLogYn = (String)session.getAttribute("ssnYeaLogYn");
    String cmd = (String)request.getParameter("cmd");

    if("selectBirthSupportMonMgr".equals(cmd)) {
        //출산지원금 조회

        Map mp = StringUtil.getRequestMap(request);
        mp.put("ssnEnterCd", ssnEnterCd);
        mp.put("ssnSabun", ssnSabun);
        mp.put("cmd", cmd);

        List listData  = new ArrayList();
        String message = "";
        String code = "1";

        try {
            listData = selectBirthSupportMonMgr(mp, locPath, ssnYeaLogYn);
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

    }  else if("saveBirthSupportMonMgr".equals(cmd)) {
        //출산지원금 저장

        Map mp = StringUtil.getRequestMap(request);
        mp.put("ssnEnterCd", ssnEnterCd);
        mp.put("ssnSabun", ssnSabun);
        mp.put("cmd", cmd);
        String message = "";
        String code = "1";

        try {
            int cnt = saveBirthSupportMonMgr(mp, locPath, ssnYeaLogYn, yeaYear);

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
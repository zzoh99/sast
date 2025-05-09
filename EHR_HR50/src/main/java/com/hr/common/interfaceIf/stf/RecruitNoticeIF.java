package com.hr.common.interfaceIf.stf;

import java.io.InputStream;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.HashMap;
import java.util.Map;
import java.util.Properties;

import javax.naming.Context;
import javax.naming.InitialContext;
import javax.sql.DataSource;

import com.hr.common.logger.Log;

//import oracle.sql.CLOB;

public class RecruitNoticeIF {

	/**
	 * 채용공고등록 - 공고내보내기
	 * 인사-채용 DB 정보를  외부채용DB로 이관
	 */
	private final String JNDI_EHR;
	private final String JNDI_REC;

	String dbYn, dbLog = "";
	
	private String hrDomain;
	private String recDomain;

	/*
	public static void main(String[] argv) throws Exception{
		RecruitNoticeIF recuruitIF = new RecruitNoticeIF();
		//recuruitIF.doAction(null, null, "ALL",null,null);
	}
	*/

	public RecruitNoticeIF() throws Exception{
		InputStream is = getClass().getResourceAsStream("/opti.properties");

		Properties props = new Properties();
		try {
			props.load(is);
		}catch (Exception ex) {
			//ex.printStackTrace();
			throw new Exception(ex.toString());
		}
		
		JNDI_EHR = props != null && props.getProperty("jndi.hrDB") != null ? props.getProperty("jndi.hrDB").trim():"";
		JNDI_REC = props != null && props.getProperty("jndi.hiDB") != null ? props.getProperty("jndi.hiDB").trim():"";
	}
	
	public Map<String,Object> doAction(String enterCd, Map<String, Object> map) throws SQLException {
		Map<String,Object> resultMap = new HashMap<String,Object>();
		ResultSet  rs          = null;
		Connection conn        = null;
		Connection connLocal   = null;
		String     returnValue = "";
		String     msg         = "";
		
		DataSource ds = null;
		Context ctxt = null;
		
		try {
			//인사,채용 도메인 세팅
			hrDomain = map.get("hrDomain").toString();
			recDomain = map.get("recDomain").toString();
			
			Log.Debug("doAction hrDomain : " + hrDomain);
			Log.Debug("doAction recDomain : " + recDomain);
			
			String sabun   = map.get("ssnSabun").toString();
			String recSeqs = map.get("recSeqs").toString();
			
			ctxt = new InitialContext();
			ds = (DataSource)ctxt.lookup(JNDI_EHR);
			conn = ds.getConnection();
			
			ctxt = new InitialContext();
			ds = (DataSource)ctxt.lookup(JNDI_REC);
			connLocal = ds.getConnection();

			dbYn = "Y";
			dbLog = "";

			try {
				// 회사별 전체 삭제 후 insert
				// TSTF101	지원분야관리
				// TSTF121	입사지원서양식관리
				// TSTF123	입사지원서세부항목관리
				// TSTF125	입사지원서양식항목매핑
					
				returnValue = this.doSave( "TSTF101", enterCd, sabun, recSeqs, "ALL", conn, connLocal);
				if (!"Y".equals(returnValue)) msg += "\n TSTF101(지원분야관리) 처리오류.";
				
				returnValue = this.doSave( "TSTF121", enterCd, sabun, recSeqs, "ALL", conn, connLocal);
				if (!"Y".equals(returnValue)) msg += "\n TSTF121(입사지원서양식관리) 처리오류.";
				
				returnValue = this.doSave( "TSTF123", enterCd, sabun, recSeqs, "ALL", conn, connLocal);
				if (!"Y".equals(returnValue)) msg += "\n TSTF123(입사지원서세부항목관리) 처리오류.";
				
				returnValue = this.doSave( "TSTF125", enterCd, sabun, recSeqs, "ALL", conn, connLocal);
				if (!"Y".equals(returnValue)) msg += "\n TSTF125(입사지원서양식항목매핑) 처리오류.";
				
				returnValue = this.doSave( "TSTF357", enterCd, sabun, recSeqs, "ALL", conn, connLocal);
				if (!"Y".equals(returnValue)) msg += "\n TSTF357(전형결과안내문관리) 처리오류.";
				
				returnValue = this.doSave( "TORG900", enterCd, sabun, recSeqs, "ALL", conn, connLocal);
				if (!"Y".equals(returnValue)) msg += "\n TORG900(법인관리) 처리오류.";
				
				// 해당 조건 데이터만 삭제 후, insert
				// TSTF830	채용공고            -- clob 
				// TSTF307  자기소개항목관리
				// TSTF106	채용공고별지원분야
				// TSTF111	희망부서설정
				// TSTF113	채용공고담당회사관리
				if (!"".equals(recSeqs)){ // 공고일련번호가 있을 경우만 처리함
					returnValue = this.doSave( "TSTF830", enterCd, sabun, recSeqs, "REC", conn, connLocal);
					if (!"Y".equals(returnValue)) msg += "\n TSTF830(채용공고) 처리오류.";
					returnValue = this.doSave( "TSTF307", enterCd, sabun, recSeqs, "REC", conn, connLocal);
					if (!"Y".equals(returnValue)) msg += "\n TSTF307(자기소개항목관리) 처리오류.";
					returnValue = this.doSave( "TSTF106", enterCd, sabun, recSeqs, "REC", conn, connLocal);
					if (!"Y".equals(returnValue)) msg += "\n TSTF106(채용공고별지원분야) 처리오류.";
					returnValue = this.doSave( "TSTF111", enterCd, sabun, recSeqs, "REC", conn, connLocal);
					if (!"Y".equals(returnValue)) msg += "\n TSTF111(희망부서설정) 처리오류.";
					returnValue = this.doSave( "TSTF113", enterCd, sabun, recSeqs, "REC", conn, connLocal);
					if (!"Y".equals(returnValue)) msg += "\n TSTF113(채용공고담당회사관리) 처리오류.";
				}
			} catch(Exception e) {
				dbYn = "N";
				dbLog = e.toString().replaceAll("'", "‘");

			}

			if("Y".equals(dbYn)){
				if ("".equals(msg)){
					//공고내보내기 완료 후 이미지파일 FTP업로드
					RecruitFtpUtil.imgFileFtpUpload("TSTF830", "REC_CONTENT", "REC_SEQ", recSeqs, RecruitFtpUtil.TYPE_EHR);
					msg = "채용정보 내보내기 성공";
				} 
			}else{
				msg = "채용정보 내보내기 실패 : " + "\n\n" + dbLog;
			}

			resultMap.put("successFlag", dbYn);
			resultMap.put("msg", msg);
			
		}catch (Exception e) {
			Log.Error("======== RecruitNoticeIF doAction exception:"+e);
			if (conn != null) { try { conn.rollback(); } catch (SQLException e1) { Log.Debug(e.getLocalizedMessage()); } }
			if (connLocal != null) { try { connLocal.rollback(); } catch (SQLException e1) { Log.Debug(e.getLocalizedMessage()); } }
		} finally{
			/**************** DB 종료 *********************/
			if (rs != null) {
				try {
					rs.close();
				} catch (SQLException e) {
					Log.Debug(e.getLocalizedMessage());
				}
			}
			if(conn!=null){
				try {
					conn.close();
				} catch (SQLException e) {
					Log.Debug(e.getLocalizedMessage());
				}
			}
			if(connLocal!=null){
				try {
					connLocal.close();
				} catch (SQLException e) {
					Log.Debug(e.getLocalizedMessage());
				}
			}
			
		}

		return resultMap;
	}

	@SuppressWarnings("resource")
	private String doSave(String tableName, String enterCd, String sabun, String recSeqs, String flag, Connection conn, Connection connLocal) throws Exception {
		// 데이타 조회
		String returnValue = "";
		PreparedStatement psmt = null;
		ResultSet         rs   = null;
		
		try{
			// 회사별 삭제 후 insert
			// TSTF101	지원분야관리
			// TSTF121	입사지원서양식관리
			// TSTF123	입사지원서세부항목관리
			// TSTF125	입사지원서양식항목매핑
			
			// 회사별, 공고번호별 데이터 삭제 후, insert
			// TSTF830	채용공고            -- clob 처리 추가됨
			// TSTF307	자기소개항목관리
			// TSTF106	채용공고별지원분야
			// TSTF111	희망부서설정
			// TSTF113	채용공고담당회사관리
			
			//int    colCnt      = 0;
			String detailQuery1 = ""; // select문
			String detailQuery2 = ""; // insert문
			String detailQuery3 = ""; // where
			String detailQueryValue = ""; // insert문 values
			
			String [][] colsInfo = null ; // key 여부/ data type (D:Date, C:Clob)/ column
			
			if ("TSTF101".equals(tableName)) {
				String[][] data = {{"K", " ", "ENTER_CD" }
				, {"K", " ", "JOB_CD" }
				, {" ", " ", "JOB_NM" }
				, {" ", " ", "JOB_DESC" }
				, {" ", " ", "SEQ" }
                 };
				colsInfo = data;
			} else if ("TSTF121".equals(tableName)) {
				String[][] data = {{"K", " ", "ENTER_CD" }
				, {"K", " ", "APP_TYPE_CD" }
				, {" ", " ", "APP_TYPE_NM" }
				, {" ", " ", "APP_TYPE_DESC" }
				, {" ", " ", "USE_YN" }
                 };
				colsInfo = data;
			} else if ("TSTF123".equals(tableName)) {
				String[][] data = {{"K", " ", "ENTER_CD" }
				, {"K", " ", "APP_ITEM_CD" }
				, {" ", " ", "APP_ITEM_NM" }
				, {" ", " ", "APP_ITEM_DESC" }
				, {" ", " ", "USE_YN" }
				, {" ", " ", "DISP_AREA_CD" }
				, {" ", " ", "PHOTO_YN" }
				, {" ", " ", "DISP_ITEM_NM" }
                 };
				colsInfo = data;
			} else if ("TSTF125".equals(tableName)) {
				String[][] data = {{"K", " ", "ENTER_CD" }
				, {"K", " ", "APP_TYPE_CD" }
				, {"K", " ", "APP_ITEM_CD" }
				, {" ", " ", "DISP_AREA_CD" }
				, {" ", " ", "DISP_ORDER_NO" }
				, {" ", " ", "DISP_YN" }
                 };
				colsInfo = data;
			} else if ("TSTF307".equals(tableName)) {
				String[][] data = {{"K", " ", "ENTER_CD" }
				, {"K", " ", "REC_SEQ" }
				, {"K", " ", "JOB_CD" }
				, {"K", " ", "TITLE_SEQ" }
				, {" ", " ", "TITLE" }
				, {" ", " ", "MAX_LENGTH" }
				, {" ", " ", "ORDER_NO" }
				};
				colsInfo = data;
			} else if ("TSTF106".equals(tableName)) {
				String[][] data = {{"K", " ", "ENTER_CD" }
				, {"K", " ", "REC_SEQ" }
				, {"K", " ", "JOB_CD" }
				, {" ", " ", "ORDER_NO" }
				, {" ", " ", "APP_TYPE_CD" }
				, {" ", " ", "TEMP_CD" }
                 };
				colsInfo = data;
			} else if ("TSTF111".equals(tableName)) {
				String[][] data = {{"K", " ", "ENTER_CD" }
				, {"K", " ", "REC_SEQ" }
				, {"K", " ", "JOB_CD" }
				, {"K", " ", "HOPE_SEQ" }
				, {" ", " ", "HOPE_ORG_NM" }
				, {" ", " ", "ORDER_NO" }
                 };
				colsInfo = data;
			} else if ("TSTF113".equals(tableName)) {
				String[][] data = {{"K", " ", "ENTER_CD" }
				, {"K", " ", "REC_SEQ" }
				, {"K", " ", "JOB_CD" }
				, {"K", " ", "MGR_ENTER_CD" }
                 };
				colsInfo = data;

			} else if ("TSTF830".equals(tableName)) {
				String[][] data = {{"K", " ", "ENTER_CD" }
				, {"K", " ", "REC_SEQ" }
				, {" ", " ", "REC_NM" }
				, {" ", " ", "REC_YYYY" }
				, {" ", " ", "REC_GB" }
				, {" ", " ", "REC_NOTICE_GB" }
				, {" ", " ", "REC_TYPE_CD" }
				, {" ", " ", "DISP_ENTER_NM" }
				, {" ", "D", "DIS_S_DT" }
				, {" ", "D", "DIS_E_DT" }
				, {" ", "D", "ACCEPT_S_DT" }
				, {" ", "D", "ACCEPT_E_DT" }
				, {" ", "C", "REC_CONTENT" }
				, {" ", " ", "MGR_NM" }
				, {" ", " ", "MGR_TEL_NO" }
				, {" ", " ", "MGR_EMAIL" }
				, {" ", " ", "HP_ADDR" }
				, {" ", " ", "BLOG_ADDR" }
				, {" ", " ", "FB_ADDR" }
				, {" ", " ", "TWI_ADDR" }
				, {" ", " ", "INSTA_ADDR" }
				, {" ", " ", "FILE_SEQ" }
				, {" ", " ", "REC_PLAN_CNT" }
				, {" ", " ", "REC_STATUS_CD" }
				, {" ", "D", "REG_DATE" }
				, {" ", " ", "REC_URL" }
                 };
				colsInfo = data;
			} else if ("TSTF357".equals(tableName)) {
				String[][] data = {{"K", " ", "ENTER_CD" }
				, {"K", " ", "STEP_TYPE_CD" }
				, {"K", " ", "APPL_STATUS_CD" }
				, {" ", "C", "STEP_RST_NOTI" }
                 };
				colsInfo = data;
			} else if ("TORG900".equals(tableName)) {
				String[][] data = {{"K", " ", "ENTER_CD" }
				, {" ", " ", "ENTER_NM" }
				, {" ", " ", "ENTER_ENG_NM" }
				, {" ", " ", "ENTER_NO" }
				, {" ", " ", "PRESIDENT_SABUN" }
				, {" ", " ", "PRESIDENT" }
				, {" ", " ", "EPRESIDENT" }
				, {" ", " ", "TEL_NO" }
				, {" ", " ", "FAX_NO" }
				, {" ", " ", "LOCATION_CD" }
				, {"K", " ", "DOMAIN" }
				, {" ", " ", "MEMO" }
				, {" ", " ", "SEQ" }
				, {" ", " ", "ALIAS" }
                 };
				colsInfo = data;
			}

			if(colsInfo != null){
				for(int i=0; i<colsInfo.length; i++){
					//String key      = colsInfo[i][0];
					String dataType = colsInfo[i][1];
					String col      = colsInfo[i][2];

					detailQuery2   += col + ", " ;

					if ( "D".equals(dataType)){
						detailQuery1     += " TO_CHAR("+col+", 'YYYYMMDDHH24MISS') AS " + col + ", ";
						detailQueryValue += " TO_DATE(?, 'YYYYMMDDHH24MISS'), ";
					} else {
						detailQuery1     += col + ", " ;
						detailQueryValue += " ?, ";
					}
				}
			}else{
				Log.Debug("colsInfo is null");
			}

			
			if ("REC".equals(flag) && !"".equals(recSeqs)){
				detailQuery3 = " AND REC_SEQ IN ( " + recSeqs + ") ";
			}
			
			StringBuffer sbQuery = new StringBuffer();
			StringBuffer sbDelete = new StringBuffer();
			
			if ("TORG900".equals(tableName)) {
				sbQuery.append("SELECT " + detailQuery1 + " '' ")
					   .append("  FROM " + tableName  )
					   .append(" WHERE USE_YN = 'Y' ");

				sbDelete.append("LDELETE FROM "+tableName );
			} else {
				sbQuery.append("SELECT " + detailQuery1 + " '' ")
					   .append("  FROM " + tableName  )
					   .append(" WHERE ENTER_CD = ? " + detailQuery3);
	
				sbDelete.append("LDELETE FROM "+tableName+" WHERE ENTER_CD = ? " + detailQuery3);
			}			
			
			StringBuffer sbInsert = new StringBuffer();
			sbInsert.append("LINSERT INTO " + tableName)
					.append("( "+detailQuery2+" CHKID, CHKDATE ) ")
					.append("VALUES ( ")
					.append(detailQueryValue)
					.append(" '"+sabun+"', SYSDATE )");

			
			Log.Debug("=== sbQuery.toString() : "+sbQuery.toString());
			Log.Debug("=== sbDelete.toString(): "+sbDelete.toString());
			Log.Debug("=== sbInsert.toString(): "+sbInsert.toString());

			// 인사DB에서 data select
			psmt = conn.prepareStatement(sbQuery.toString());
			if (!"TORG900".equals(tableName)) {
				psmt.setString(1, enterCd);
			}
			rs = psmt.executeQuery();
			
			// 채용DB data delete
			psmt = connLocal.prepareStatement(sbDelete.toString());
			if (!"TORG900".equals(tableName)) {
				psmt.setString(1, enterCd);
			}
			psmt.executeUpdate();
			psmt.close();

			if ( rs != null ) {
				int startCnt = 1;
				if ("TORG900".equals(tableName)) {
					startCnt = 0;
				} else {
					startCnt = 1;
				}
				
				while(rs.next()){
					psmt = connLocal.prepareStatement(sbInsert.toString());
					if (!"TORG900".equals(tableName)) {
						psmt.setString(1, enterCd);
					}
					
					for(int i=startCnt; i<colsInfo.length; i++){
						String value = "";
						//String col   = colsInfo[i][2];
								
						if ("C".equals(colsInfo[i][1]) ){
							value = " ";
						} else {
							value = rs.getString(i+1);
						}
						psmt.setString(i+1, value);
						
						//Log.Debug("type:"+colsInfo[i][1] + ", colname:"+colsInfo[i][2]);
						//Log.Debug("i+1:"+(i+1)+", value:"+value);
					}
					
					psmt.executeUpdate();
					psmt.close();
					
					if ("TSTF830".equals(tableName)){
						String clobSql1 = "LSELECT REC_CONTENT FROM TSTF830    WHERE ENTER_CD = '"+rs.getString(1)+"' AND REC_SEQ = '"+rs.getString(2)+"' FOR UPDATE";
						String clobSql2 = "LUPDATE TSTF830 SET REC_CONTENT = ? WHERE ENTER_CD = '"+rs.getString(1)+"' AND REC_SEQ = '"+rs.getString(2)+"' ";
						ClobProc(rs.getString("REC_CONTENT"), clobSql1, clobSql2, connLocal, "REC_CONTENT");
					} else if ("TSTF357".equals(tableName)){
						
						String clobSql1 = "LSELECT STEP_RST_NOTI FROM TSTF357 WHERE ENTER_CD = '"+rs.getString(1)+"' AND STEP_TYPE_CD = '"+rs.getString(2)+"' AND APPL_STATUS_CD = '"+rs.getString(3)+"' FOR UPDATE";
						String clobSql2 = "LUPDATE TSTF357 SET STEP_RST_NOTI = ? WHERE ENTER_CD = '"+rs.getString(1)+"' AND STEP_TYPE_CD = '"+rs.getString(2)+"' AND APPL_STATUS_CD = '"+rs.getString(3)+"'";
						ClobProc(rs.getString("STEP_RST_NOTI"), clobSql1, clobSql2, connLocal, "STEP_RST_NOTI");
					}
				}
				rs.close();
			}
			connLocal.commit();  // table 하나 처리시 commit
			returnValue = "Y";
		}catch (Exception e) {
			returnValue = "error";
			Log.Error("======== doSave exception tableName:"+tableName);
			//Log.Debug("======== exception tableName:"+tableName);
			Log.Debug(e.getLocalizedMessage());
		} finally{
			Log.Error("======== doSave finally tableName:"+tableName);
			//Log.Debug("======== finally tableName:"+tableName);
			connLocal.commit();
			if(psmt!=null){psmt.close();}
			if(rs!=null){rs.close();}
		}
		
		return returnValue;

	}

    public String ClobProc(String original_Conents,String Select_Query,String Update_Query, Connection conn, String cName)
        	throws SQLException {

        	String returnFlag = "0" ;
        	
        	PreparedStatement pre = null;
        	ResultSet res = null;

        	try {
            	conn.setAutoCommit(false);
            	pre = conn.prepareStatement(Select_Query);
            	res = pre.executeQuery();
    			returnFlag = "1";
    			conn.commit();
    			conn.setAutoCommit(true);
            } catch(Exception e) {
            	conn.rollback();
                Log.Error("ClobProc e:" + e.getLocalizedMessage());
                returnFlag = "99";
            } finally {
            	conn.setAutoCommit(true);
            	if (res != null) { res.close(); }
            	if (pre != null) { pre.close(); }
            }
        	
        	return returnFlag;
        }

/*
 	public  void StrToClob(String str,CLOB clob )
 	{
    	long   getErrorCode  = 0  ;
    	String getMessage    = "" ;
 		Writer clobWriter    = null;

 		try
 		{
             //clobWriter = clob.getCharacterOutputStream();
 						//clobWriter = ((OracleClob)clob).getCharacterOutputStream();
             //clobWriter.write(str);

            //clobWriter = clob.getCharacterOutputStream(); //deprecated 로 아래 코드로 수정 2020.06.23
            clobWriter = clob.setCharacterStream(clob.length());
            
            Reader src = new CharArrayReader(str.toCharArray());
            char[] buffer = new char[1024];
            int read = 0;
            while ( (read = src.read(buffer, 0, 1024)) != -1){
                clobWriter.write(buffer, 0, read);
            }

 		} catch(SQLException e)
 		{
 			getErrorCode = e.getErrorCode();
 			getMessage   = "Dbw SQLException : "+e.getMessage()+"";

 		} catch(IOException e)
 		{
 			getErrorCode = -99901;
 			getMessage   = "Dbw IOException : "+e.getMessage()+"";

 		}
 		catch(Exception e)
 		{
 			getErrorCode = -99900;
 			getMessage   = "Dbw Exception : "+e.getMessage()+"";
 		}
 		finally
 		{
 			try
 			{
 	    		  if(clobWriter!=null)   clobWriter.flush();
         		  if(clobWriter!=null)   clobWriter.close();
 		    }
 		    catch(IOException e)
 		    {

 			}
         }
    }*/
}
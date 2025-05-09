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

public class RecruitScreenStepRstNotiMgrIF {

	/**
	 * 안내문 - 내보내기
	 * 인사-채용 DB 정보를  외부채용DB로 이관
	 */
	
	private final String JNDI_EHR;
	private final String JNDI_REC;

	String dbYn, dbLog = "";
	
	public RecruitScreenStepRstNotiMgrIF() throws Exception{

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
	
	/*
	private void dbConnection() throws SQLException {
		try{
			Class.forName(DB2_CLASS);
			conn = DriverManager.getConnection(DB2_CN, DB2_ID, DB2_PW);
		}catch (Exception e) {
			if(conn!=null) conn.close();
			Log.Debug(e.getLocalizedMessage());
		}
	}
	*/
	
	public Map<String,Object> doAction(String enterCd, Map<String, Object> map) throws SQLException {

		Map<String,Object> resultMap = new HashMap<String,Object>();
		ResultSet  rs          = null;
		Connection connInsa    = null;
		Connection connRec     = null;
		String     returnValue = "";
		String     msg         = "";
		
		DataSource ds = null;
		Context ctxt = null;
		
		try{
			//인사,채용 도메인 세팅
			//hrDomain = map.get("hrDomain").toString();
			//recDomain = map.get("recDomain").toString();
			
			String sabun   = map.get("ssnSabun").toString();
			
			String recSeq  = map.get("searchRecSeq").toString();
			String jobCd   = map.get("searchJobCd").toString();
			String stepSeq = map.get("searchStepSeq").toString();
			
			try{
				ctxt = new InitialContext();
				ds = (DataSource)ctxt.lookup(JNDI_EHR);
				connInsa = ds.getConnection();
			}catch (Exception e) {
				Log.Error("======== RecruitScreenStepRstNotiMgrIF conn exception:"+e);
				
				if(connInsa!=null){connInsa.close();}

				throw new Exception(e);
			}

			try{
				ctxt = new InitialContext();
				ds = (DataSource)ctxt.lookup(JNDI_REC);
				connRec = ds.getConnection();
			}catch (Exception e) {
				Log.Error("======== RecruitScreenStepRstNotiMgrIF connLocal exception:"+e);
				throw new Exception(e);
			}
			
			dbYn = "Y";
			dbLog = "";

			try {
				returnValue = this.doSave( "TSTF715", enterCd, recSeq, jobCd, stepSeq, sabun, connInsa, connRec);
				if (!"Y".equals(returnValue)) msg += "\n 처리오류.";
				
				returnValue = this.doSave( "TSTF410", enterCd, recSeq, jobCd, stepSeq, sabun, connInsa, connRec);
				if (!"Y".equals(returnValue)) msg += "\n 처리오류.";

				
			} catch(Exception e) {
				dbYn = "N";
				dbLog = e.toString().replaceAll("'", "‘");

			}

			if("Y".equals(dbYn)){
				if ("".equals(msg)) msg = "채용정보 내보내기 성공";
			}else{
				msg = "채용정보 내보내기 실패 : " + "\n\n" + dbLog;
			}

			resultMap.put("successFlag", dbYn);
			resultMap.put("msg", msg);
			
		}catch (Exception e) {
			Log.Error("======== RecruitScreenStepRstNotiMgrIF doAction exception:"+e);
			try {
				if (connInsa != null) connInsa.rollback();
			} catch (SQLException e1) {
				//e1.printStackTrace();
				Log.Debug(e1.getLocalizedMessage());
			}

		} finally{
			/**************** DB 종료 *********************/
			if (rs != null) {
				try {
					rs.close();
				} catch (SQLException e) {
					Log.Debug(e.getLocalizedMessage());
				}
			}
			if(connInsa!=null){
				try {
					connInsa.close();
				} catch (SQLException e) {
					Log.Debug(e.getLocalizedMessage());
				}
			}
			if(connRec!=null){
				try {
					connRec.close();
				} catch (SQLException e) {
					Log.Debug(e.getLocalizedMessage());
				}
			}
			
		}

		return resultMap;
	}

	private String doSave(String tableName, String enterCd, String recSeq, String jobCd, String stepSeq, String sabun, Connection connInsa, Connection connRec) throws Exception {
		// 데이타 조회
		String returnValue = "";
		PreparedStatement psmt  = null;
		PreparedStatement psmt1 = null;
		PreparedStatement psmt2 = null;
		ResultSet         rs    = null;
		
		try{
			//int    colCnt      = 0;
			
			StringBuffer sbQuery    = new StringBuffer();
			StringBuffer insaUpdate = new StringBuffer();
			StringBuffer sbInsert   = new StringBuffer();
			StringBuffer sbDelete   = new StringBuffer();
			
			if ("TSTF715".equals(tableName)) {
				// 전형결과 안내문 update
				// TSTF715	전형단계결과관리
				//colCnt = 5;
				sbQuery.append("SELECT A.ENTER_CD, A.REC_SEQ, A.JOB_CD, A.STEP_SEQ, A.APPL_NO ")
				   .append("  , A.PASS_CD, A.STEP_RST_NOTI, A.NOTE ")
				   .append("  , Z.STEP_TYPE_CD " )
				   .append("  FROM TSTF715 A, TSTF350 Z " )
				   .append(" WHERE A.ENTER_CD = ? ")
				   .append("   AND A.REC_SEQ  = ? ")
				   .append("   AND A.JOB_CD   = ? ")
				   .append("   AND A.STEP_SEQ = ? ")
				   .append("   AND A.ENTER_CD = Z.ENTER_CD ")
				   .append("   AND A.REC_SEQ  = Z.REC_SEQ ")
				   .append("   AND A.JOB_CD   = Z.JOB_CD ")
				   .append("   AND A.STEP_SEQ = Z.STEP_SEQ ")
				   ;
				insaUpdate.append("UPDATE TSTF715 ")
					   .append("   SET INTER_YN = 'Y' ")
					   .append(" WHERE ENTER_CD = ? ")
					   .append("   AND REC_SEQ  = ? ")
					   .append("   AND JOB_CD   = ? ")
					   .append("   AND STEP_SEQ = ? ")
					   .append("   AND APPL_NO  = ? ");
				
				sbDelete.append("DELETE FROM TSTF715 ")
				   .append(" WHERE ENTER_CD = ? ")
				   .append("   AND REC_SEQ  = ? ")
				   .append("   AND JOB_CD   = ? ")
				   .append("   AND STEP_SEQ = ? ");
			
				sbInsert.append(" INSERT INTO TSTF715 ")
						.append(" ( ENTER_CD, REC_SEQ, JOB_CD, STEP_SEQ, APPL_NO ")
						.append(" , PASS_CD, STEP_RST_NOTI, NOTE, CHKID, CHKDATE) ")
						.append(" VALUES ")
						.append(" ( ?, ?, ?, ?, ? ")
						.append(" , ?, ?, ?, ?, SYSDATE ) ");
				
				/*sbInsert.append("UPDATE TSTF715 ")
					   .append("   SET STEP_RST_NOTI = EMPTY_CLOB() ")
					   .append("     , CHKID    = ?  ")
					   .append("     , CHKDATE  = SYSDATE")
					   .append(" WHERE ENTER_CD = ? ")
					   .append("   AND REC_SEQ  = ? ")
					   .append("   AND JOB_CD   = ? ")
					   .append("   AND STEP_SEQ = ? ")
					   .append("   AND APPL_NO  = ? ");
					   */				
			} else if ("TSTF410".equals(tableName)) {
				//colCnt = 4;
				sbQuery.append("SELECT Z.ENTER_CD, Z.APPL_NO, Z.STEP_TYPE_CD, Z.APPL_STATUS_CD ")
				   .append("  FROM TSTF715 A, TSTF410 Z " )
				   .append(" WHERE A.ENTER_CD = ? ")
				   .append("   AND A.REC_SEQ  = ? ")
				   .append("   AND A.JOB_CD   = ? ")
				   .append("   AND A.STEP_SEQ = ? ")
				   .append("   AND A.ENTER_CD	= Z.ENTER_CD ")
				   .append("   AND A.REC_SEQ	= Z.REC_SEQ  ")
				   .append("   AND A.APPL_NO	= Z.APPL_NO  ");
				
				sbInsert.append("UPDATE TSTF410 ")
				   .append("   SET STEP_TYPE_CD   = ?  ")
				   .append("     , APPL_STATUS_CD = ?  ")
				   .append("     , CHKID          = ?  ")
				   .append("     , CHKDATE        = SYSDATE")
				   .append(" WHERE ENTER_CD       = ?  ")
				   .append("   AND APPL_NO        = ?  ");
				
			}
			
			//Log.Debug("=== sbQuery.toString() : "+sbQuery.toString());
			//Log.Debug("=== sbDelete.toString(): "+sbDelete.toString());
			//Log.Debug("=== sbInsert.toString(): "+sbInsert.toString());
			

			// 인사DB에서 data select
			psmt = connInsa.prepareStatement(sbQuery.toString());
			psmt.setString(1, enterCd);
			psmt.setString(2, recSeq );
			psmt.setString(3, jobCd  );
			psmt.setString(4, stepSeq);
			
			rs = psmt.executeQuery();
			
			int cnt = 0;
			if ( rs != null ) {
				while(rs.next()){
					psmt1 = connRec.prepareStatement(sbInsert.toString());
					
					if ("TSTF715".equals(tableName)) {
						if ( cnt == 0){
							//Log.Debug("delete TSTF715 start");
							// delete 채용 TSTF715
							psmt2 = connRec.prepareStatement(sbDelete.toString());
							psmt2.setString(1, enterCd);
							psmt2.setString(2, recSeq );
							psmt2.setString(3, jobCd  );
							psmt2.setString(4, rs.getString("STEP_TYPE_CD"));
							psmt2.executeUpdate();
							psmt2.close();
							
							cnt++;
							//Log.Debug("delete TSTF715 end");
						}						
						
						psmt1.setString(1, rs.getString("ENTER_CD"));
						psmt1.setString(2, rs.getString("REC_SEQ"));
						psmt1.setString(3, rs.getString("JOB_CD"));
						psmt1.setString(4, rs.getString("STEP_TYPE_CD"));
						psmt1.setString(5, rs.getString("APPL_NO"));
						psmt1.setString(6, rs.getString("PASS_CD"));
						psmt1.setString(7, " ");
						psmt1.setString(8, rs.getString("NOTE"));
						psmt1.setString(9, sabun);
						psmt1.executeUpdate();
						psmt1.close();
						
						String clobSql1 = "LSELECT STEP_RST_NOTI FROM TSTF715    WHERE ENTER_CD = '"+rs.getString("ENTER_CD")+"' AND REC_SEQ = '"+rs.getString("REC_SEQ")+"' AND JOB_CD = '"+rs.getString("JOB_CD")+"' AND STEP_SEQ = '"+rs.getString("STEP_TYPE_CD")+"' AND APPL_NO = '"+rs.getString("APPL_NO")+"' FOR UPDATE";
						String clobSql2 = "LUPDATE TSTF715 SET STEP_RST_NOTI = ? WHERE ENTER_CD = '"+rs.getString("ENTER_CD")+"' AND REC_SEQ = '"+rs.getString("REC_SEQ")+"' AND JOB_CD = '"+rs.getString("JOB_CD")+"' AND STEP_SEQ = '"+rs.getString("STEP_TYPE_CD")+"' AND APPL_NO = '"+rs.getString("APPL_NO")+"' ";
	
						ClobProc(rs.getString("STEP_RST_NOTI"), clobSql1, clobSql2, connRec, "STEP_RST_NOTI");
						
						// 인사DB TSTF715.INTER_YN = 'Y'
						psmt2 = connInsa.prepareStatement(insaUpdate.toString());
						psmt2.setString(1, rs.getString("ENTER_CD"));
						psmt2.setString(2, rs.getString("REC_SEQ"));
						psmt2.setString(3, rs.getString("JOB_CD"));
						psmt2.setString(4, rs.getString("STEP_SEQ"));
						psmt2.setString(5, rs.getString("APPL_NO"));
						psmt2.executeUpdate();
						psmt2.close();
						
						
					} else if ("TSTF410".equals(tableName)) {
						//Log.Debug("============= STEP_TYPE_CD  :"+rs.getString("STEP_TYPE_CD"));
						//Log.Debug("============= APPL_STATUS_CD:"+rs.getString("APPL_STATUS_CD"));
						//Log.Debug("============= ENTER_CD      :"+rs.getString("ENTER_CD"));
						//Log.Debug("============= APPL_NO       :"+rs.getString("APPL_NO"));
						
						psmt1.setString(1, rs.getString("STEP_TYPE_CD"));
						psmt1.setString(2, rs.getString("APPL_STATUS_CD"));
						psmt1.setString(3, sabun);
						psmt1.setString(4, rs.getString("ENTER_CD"));
						psmt1.setString(5, rs.getString("APPL_NO"));
						psmt1.executeUpdate();
						psmt1.close();
					}
				}
				rs.close();
			}
			connInsa.commit(); // table 하나 처리시 commit
			connRec.commit();  // table 하나 처리시 commit
			returnValue = "Y";
		}catch (Exception e) {
			returnValue = "error";
			//Log.Debug("======== exception tableName:"+tableName);
			Log.Debug(e.getLocalizedMessage());
		} finally{
			//Log.Debug("======== finally tableName:"+tableName);
			connRec.commit();
			if(psmt !=null){psmt.close();}
			if(psmt1!=null){psmt1.close();}
			if(psmt2!=null){psmt2.close();}
			if(rs!=null){rs.close();}
		}
		
		return returnValue;

	}

    public String ClobProc(String original_Conents,String Select_Query,String Update_Query, Connection conn, String cName) throws SQLException {
    	PreparedStatement pre = null;
    	ResultSet res = null;
    	String returnFlag = "0" ;
    	try {
        	conn.setAutoCommit(false);
        	pre = conn.prepareStatement(Select_Query);
        	res = pre.executeQuery();
			returnFlag = "1";
			conn.commit();
			conn.setAutoCommit(true);
        } catch(Exception e) {
        	conn.rollback();
            Log.Error("ClobProc e:"+e.toString());
            returnFlag = "99";
        } finally {
        	conn.setAutoCommit(true);
        	if (pre != null) { pre.close(); }
        	if (res != null) { res.close(); }
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
package com.hr.common.interfaceIf.stf;

import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.net.SocketException;
import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Properties;

import javax.naming.Context;
import javax.naming.InitialContext;
import javax.sql.DataSource;

import org.apache.commons.net.ftp.FTP;
import org.apache.commons.net.ftp.FTPClient;
import org.apache.commons.net.ftp.FTPFile;
import org.apache.commons.net.ftp.FTPReply;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.hr.common.logger.Log;

//import oracle.sql.CLOB;

//import com.hr.stf.screen.applicantBasis.ApplicantBasisService;


public class RecuruitIF {
	private static final Logger logger = LoggerFactory.getLogger(RecuruitIF.class.getName());

	/**
	 * 입사지원서 기본사항 서비스
	 */

	private final String FTP_IP;
	private final String FTP_PORT;
	private final String FTP_ID;
	private final String FTP_PW;
	private final String FTP_DIR;

	private final String LOCAL_DIR;
	
	private final String JNDI_EHR;
	private final String JNDI_REC;

//	private final String MAIL_ADDR = "";

	private String recruit_seq = "";

	PreparedStatement preStmt = null;
	ResultSet rset = null;
	Connection conn = null;
	FTPClient ftpClient = null;
	String errSql = "";
	String ifType = "ALL"; // ALL-전제정보, BASIC-채용공고
	String ftpYn = "Y";
	String ftpLog = "";
	String dbYn, dbLog = "";

	/*
	public static void main(String[] argv) throws Exception{
		RecuruitIF recuruitIF = new RecuruitIF();
		//recuruitIF.doAction(null, null, "ALL",null,null);
	}
	*/

	public RecuruitIF() throws Exception{
		InputStream is = getClass().getResourceAsStream("/opti.properties");

		Properties props = new Properties();
		try {
			props.load(is);
		}catch (Exception ex) {
			//ex.printStackTrace();
			throw new Exception(ex.toString());
		}

//		FTP_IP = props.getProperty("FTP_IP").trim();
//		FTP_PORT = props.getProperty("FTP_PORT").trim();
//		FTP_ID = props.getProperty("FTP_ID").trim();
//		FTP_PW = props.getProperty("FTP_PW").trim();
//		FTP_DIR = props.getProperty("FTP_DIR").trim();
//		LOCAL_DIR = props.getProperty("LOCAL_DIR").trim();
//		JNDI_EHR = props.getProperty("jndi.hrDB").trim();
//		JNDI_REC = props.getProperty("jndi.hiDB").trim();
		
		FTP_IP = props != null && props.getProperty("FTP_IP") != null ? props.getProperty("FTP_IP").trim():"";
		FTP_PORT = props != null && props.getProperty("FTP_PORT") != null ? props.getProperty("FTP_PORT").trim():"";
		FTP_ID = props != null && props.getProperty("FTP_ID") != null ? props.getProperty("FTP_ID").trim():"";
		FTP_PW = props != null && props.getProperty("FTP_PW") != null ? props.getProperty("FTP_PW").trim():"";
		FTP_DIR = props != null && props.getProperty("FTP_DIR") != null ? props.getProperty("FTP_DIR").trim():"";
		LOCAL_DIR = props != null && props.getProperty("LOCAL_DIR") != null ? props.getProperty("LOCAL_DIR").trim():"";
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
	
	public Map<String,Object> doAction(String pEnterCd, String pSeq, String pIfType, Map<String, Object> map) throws SQLException {

		List<String> arrEnterCd = new ArrayList<String>();
		Map<String,Object> resultMap = null;
		ResultSet rs =null;
		CallableStatement cstmt = null;

		String sabun = map.get("ssnSabun").toString();

		DataSource ds = null;
		Context ctxt = null;
		
		if(!"BASIC".equals(pIfType)){
			String searchRecruitTitle = map.get("searchRecruitTitle").toString();
			recruit_seq = searchRecruitTitle;
		}

		ifType = pIfType;

		/**************** DB 접속 *********************/
		try {
			ctxt = new InitialContext();
			ds = (DataSource)ctxt.lookup(JNDI_REC);
			conn = ds.getConnection();
			
			if ( pEnterCd == null || "".equals(pEnterCd) ) {
				//회사코드 미입력시 회사코드 조회
				rs = conn.prepareStatement("LSELECT ENTER_CD FROM TORG900 ORDER BY SEQ ").executeQuery(); //지원자정보
				if ( rs != null ) {
					while(rs.next()) {
						arrEnterCd.add(rs.getString("ENTER_CD"));
					}
				}
			} else {
				arrEnterCd.add(pEnterCd);
			}

			for (int i=0; i<arrEnterCd.size(); i++) {
				String enterCd = String.valueOf(arrEnterCd.get(i));

				/**************** DB 저장 *********************/

				String ifYn;

				dbYn = "Y";
				dbLog = "";

				try {

					resultMap=this.doSave( enterCd, pIfType, sabun);

				} catch(Exception e) {
					dbYn = "N";
					dbLog = e.toString().replaceAll("'", "‘");

				}

				/**************** I/F결과 저장 *********************/
				if ( "N".equals(ftpYn) || "N".equals(dbYn) ) {
					ifYn = "N";
				} else {
					ifYn = "Y";
				}

				String msg = "";

				if("Y".equals(ifYn)){
					if("BASIC".equals(ifType)){
						msg = "채용정보 가져오기 성공";
					}else{
						msg = "입사정보 가져오기 성공";
					}
				}else{
					if("BASIC".equals(ifType)){
						msg = "채용정보 가져오기 실패 : " + ftpLog + "\n\n" + dbLog;
					}else{
						msg = "입사정보 가져오기 실패 : " + ftpLog + "\n\n" + dbLog;
					}
				}

				conn.prepareStatement( "INSERT INTO TSYS997(ENTER_CD, BIZ_CD, SEQ, ERR_LOG, SUCCESS_YN, CHKDATE, CHKID) VALUES("
						+ "'"+ enterCd +"'"
						+ ", 'STF'"
						+ ", NVL((SELECT MAX(SEQ) FROM TSYS997 WHERE ENTER_CD='"+ enterCd +"' AND BIZ_CD='STF'), 0) + 1"
						+ ", '"+ msg +"'"
						+ ", '"+ ifYn +"'"
						+ ", SYSDATE, 'SYSTEM'"
						+ ")" ).executeUpdate();

			}

			conn.commit();
			
		} catch (Exception e) {
			try {
				conn.rollback();
			} catch (SQLException e1) {
				Log.Error("ROLL BACK FAIL");
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
			if (cstmt != null) {
				try {
					cstmt.close();
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
		}

		return resultMap;
	}

	private Map<String,Object> doSave(String pEnterCd, String pIfType, String sabun) throws Exception {
		// 데이타 조회
		ResultSet rs830 = null;
		ResultSet rs101 = null;
		ResultSet rsJobApp = null;
		ResultSet rsJobAppSocial = null;
		ResultSet rsJobAppSchool = null;
		ResultSet rsJobAppPc = null;
		ResultSet rsJobAppOversea = null;
		ResultSet rsJobAppLicense = null;
		ResultSet rsJobAppForeign = null;
		ResultSet rsJobAppFamily = null;
		ResultSet rsJobAppCareer = null;
		ResultSet rsJobMsCnt = null;
		ResultSet rsJobOracleCnt = null;
		ResultSet rsJobMsOracle = null;
		ResultSet rsJobMsOracle2 = null;

		Map<String,Object> map = null;

		Connection conn = null;
		
		DataSource ds = null;
		Context ctxt = null;
		Connection connLocal = null;
		PreparedStatement psmt = null;
		
		try {
			ctxt = new InitialContext();
			ds = (DataSource)ctxt.lookup(JNDI_EHR);
			conn = ds.getConnection();
			
			ctxt = new InitialContext();
			ds = (DataSource)ctxt.lookup(JNDI_REC);
			connLocal = ds.getConnection();
			
			if("BASIC".equals(pIfType)) {
				if (conn != null){
					rs830 = conn.prepareStatement("select seq, substring(sdate,1,4), title, recruit_type, replace(sdate,'-',''), replace(edate,'-',''), status from tb_recruit").executeQuery();
					rs101 = conn.prepareStatement("Select pkid, p_title From TblPart Where p_name = '지원부서' Order by pkid asc ").executeQuery();
				}
				String delete830 = " LDELETE FROM TSTF830 ";
				String insert830 = " LINSERT INTO TSTF830(ENTER_CD, SEQ, REQ_YYYY, SUBJECT, JOIN_GB, SDATE, EDATE, STATUS_CD) VALUES ";

				String delete101 = " LDELETE FROM TSTF101 ";
				String insert101 = " LINSERT INTO TSTF101(ENTER_CD, RECRUIT_JOB_CODE, RECRUIT_JOB_NM) VALUES ";

				String[] deleteDetailTable = {"TSTF_JOB_APP"
						,"TSTF_JOB_APP_SOCIAL"
						,"TSTF_JOB_APP_SCHOOL"
						,"TSTF_JOB_APP_PC"
						,"TSTF_JOB_APP_OVERSEA"
						,"TSTF_JOB_APP_LICENSE"
						,"TSTF_JOB_APP_FOREIGN"
						,"TSTF_JOB_APP_FAMILY"
						,"TSTF_JOB_APP_CAREER"};

				String recruitSeq = "";

				String val1 = "";
				String val2 = "";
				String val3 = "";
				String val4 = "";
				String val5 = "";
				String val6 = "";
				String val7 = "";
				String tmp = "";

				psmt = connLocal.prepareStatement(delete830);
				psmt.executeUpdate();
				psmt.close();

				psmt = connLocal.prepareStatement(delete101);
				psmt.executeUpdate();

				if ( rs830 != null ) {
					try{
						while(rs830.next()){
							val1 = rs830.getString(1);
							val2 = rs830.getString(2);
							val3 = rs830.getString(3);
							val4 = rs830.getString(4);
							val5 = rs830.getString(5);
							val6 = rs830.getString(6);
							val7 = rs830.getString(7);

							if("".equals(recruitSeq)) {
								recruitSeq = "'"+val1+"'";
							} else {
								recruitSeq += ","+"'"+val1+"'";
							}

							tmp = "('"+pEnterCd+"','"+val1+"','"+val2+"','"+val3+"','"+val4+"','"+val5+"','"+val6+"','"+val7+"')";

							psmt = connLocal.prepareStatement(insert830+tmp);
							psmt.executeUpdate();
							psmt.close();
						}
					}finally {
						try{
							rs830.close();
						}catch(Exception e){
							Log.Debug("ResultSet 830 CLOSE FAIL");
						}
					}
				}


				if ( rs101 != null ) {
					try {
						while (rs101.next()) {
							val1 = rs101.getString(1);
							val2 = rs101.getString(2);
							tmp = "('" + pEnterCd + "','" + val1 + "','" + val2 + "')";
							psmt = connLocal.prepareStatement(insert101 + tmp);
							psmt.executeUpdate();
							psmt.close();
						}
					}finally{
						try {
							rs101.close();
						} catch (Exception e) {
							Log.Debug("ResultSet 101 CLOSE FAIL");
						}
					}
				}

				String sql = "";
				//가족사항,학력사항 등등 삭제
				for(int i = 0; i < deleteDetailTable.length; i++) {
					psmt = connLocal.prepareStatement(sql);
					psmt.executeUpdate();
					psmt.close();
				}
				
			} else if("TSTF".equals(pIfType)){
				map = new HashMap<String,Object>();
				StringBuffer sb = new StringBuffer();
				sb.append(" SELECT COUNT(*) FROM TB_JOB_APP WHERE RECRUIT_SEQ = '"+recruit_seq+"' UNION ALL ")
				  .append(" SELECT COUNT(*) FROM TB_JOB_APP A, TB_RECRUIT B, TB_JOB_APP_CAREER C WHERE B.SEQ = A.RECRUIT_SEQ AND A.APP_SEQ = C.APP_SEQ AND B.SEQ = '"+recruit_seq+"' UNION ALL ")
				  .append(" SELECT COUNT(*) FROM TB_JOB_APP A, TB_RECRUIT B, TB_JOB_APP_FAMILY C WHERE B.SEQ = A.RECRUIT_SEQ AND A.APP_SEQ = C.APP_SEQ AND B.SEQ = '"+recruit_seq+"' UNION ALL ")
				  .append(" SELECT COUNT(*) FROM TB_JOB_APP A, TB_RECRUIT B, TB_JOB_APP_FOREIGN C WHERE B.SEQ = A.RECRUIT_SEQ AND A.APP_SEQ = C.APP_SEQ AND B.SEQ = '"+recruit_seq+"' UNION ALL ")
				  .append(" SELECT COUNT(*) FROM TB_JOB_APP A, TB_RECRUIT B, TB_JOB_APP_LICENSE C WHERE B.SEQ = A.RECRUIT_SEQ AND A.APP_SEQ = C.APP_SEQ AND B.SEQ = '"+recruit_seq+"' UNION ALL ")
				  .append(" SELECT COUNT(*) FROM TB_JOB_APP A, TB_RECRUIT B, TB_JOB_APP_OVERSEA C WHERE B.SEQ = A.RECRUIT_SEQ AND A.APP_SEQ = C.APP_SEQ AND B.SEQ = '"+recruit_seq+"' UNION ALL ")
				  .append(" SELECT COUNT(*) FROM TB_JOB_APP A, TB_RECRUIT B, TB_JOB_APP_PC C WHERE B.SEQ = A.RECRUIT_SEQ AND A.APP_SEQ = C.APP_SEQ AND B.SEQ = '"+recruit_seq+"' UNION ALL ")
				  .append(" SELECT COUNT(*) FROM TB_JOB_APP A, TB_RECRUIT B, tb_job_app_school C WHERE B.SEQ = A.RECRUIT_SEQ AND A.APP_SEQ = C.APP_SEQ AND B.SEQ = '"+recruit_seq+"' UNION ALL ")
				  .append(" SELECT COUNT(*) FROM TB_JOB_APP A, TB_RECRUIT B, TB_JOB_APP_SOCIAL C WHERE B.SEQ = A.RECRUIT_SEQ AND A.APP_SEQ = C.APP_SEQ AND B.SEQ = '"+recruit_seq+"' ");

				StringBuffer sb2 = new StringBuffer();
				sb2.append(" SELECT COUNT(*) FROM TSTF_JOB_APP WHERE ENTER_CD = '"+pEnterCd+"' AND RECRUIT_SEQ = '"+recruit_seq+"' UNION ALL ")
				   .append(" SELECT COUNT(*) FROM TSTF_JOB_APP A, TSTF_JOB_APP_CAREER B ")
				   .append(" WHERE A.ENTER_CD = B.ENTER_CD AND A.APP_SEQ = B.APP_SEQ AND A.ENTER_CD = '"+pEnterCd+"' AND A.RECRUIT_SEQ = '"+recruit_seq+"' UNION ALL ")
				   .append(" SELECT COUNT(*) FROM TSTF_JOB_APP A, TSTF_JOB_APP_FAMILY B ")
				   .append(" WHERE A.ENTER_CD = B.ENTER_CD AND A.APP_SEQ = B.APP_SEQ AND A.ENTER_CD = '"+pEnterCd+"' AND A.RECRUIT_SEQ = '"+recruit_seq+"' UNION ALL ")
				   .append(" SELECT COUNT(*) FROM TSTF_JOB_APP A, TSTF_JOB_APP_FOREIGN B ")
				   .append(" WHERE A.ENTER_CD = B.ENTER_CD AND A.APP_SEQ = B.APP_SEQ AND A.ENTER_CD = '"+pEnterCd+"' AND A.RECRUIT_SEQ = '"+recruit_seq+"' UNION ALL ")
				   .append(" SELECT COUNT(*) FROM TSTF_JOB_APP A, TSTF_JOB_APP_LICENSE B ")
				   .append(" WHERE A.ENTER_CD = B.ENTER_CD AND A.APP_SEQ = B.APP_SEQ AND A.ENTER_CD = '"+pEnterCd+"' AND A.RECRUIT_SEQ = '"+recruit_seq+"' UNION ALL ")
				   .append(" SELECT COUNT(*) FROM TSTF_JOB_APP A, TSTF_JOB_APP_OVERSEA B ")
				   .append(" WHERE A.ENTER_CD = B.ENTER_CD AND A.APP_SEQ = B.APP_SEQ AND A.ENTER_CD = '"+pEnterCd+"' AND A.RECRUIT_SEQ = '"+recruit_seq+"' UNION ALL ")
				   .append(" SELECT COUNT(*) FROM TSTF_JOB_APP A, TSTF_JOB_APP_PC B ")
				   .append(" WHERE A.ENTER_CD = B.ENTER_CD AND A.APP_SEQ = B.APP_SEQ AND A.ENTER_CD = '"+pEnterCd+"' AND A.RECRUIT_SEQ = '"+recruit_seq+"' UNION ALL ")
				   .append(" SELECT COUNT(*) FROM TSTF_JOB_APP A, TSTF_JOB_APP_SCHOOL B ")
				   .append(" WHERE A.ENTER_CD = B.ENTER_CD AND A.APP_SEQ = B.APP_SEQ AND A.ENTER_CD = '"+pEnterCd+"' AND A.RECRUIT_SEQ = '"+recruit_seq+"' UNION ALL ")
				   .append(" SELECT COUNT(*) FROM TSTF_JOB_APP A, TSTF_JOB_APP_SOCIAL B ")
				   .append(" WHERE A.ENTER_CD = B.ENTER_CD AND A.APP_SEQ = B.APP_SEQ AND A.ENTER_CD = '"+pEnterCd+"' AND A.RECRUIT_SEQ = '"+recruit_seq+"' ");

				String deleteJobApp = "";
				String deleteJobAppSchool = ""; 
				String deleteJobAppPc = ""; 
				String deleteJobAppOversea = ""; 
				String deleteJobAppLicense = ""; 
				String deleteJobAppForeign = ""; 
				String deleteJobAppFamily = ""; 
				String deleteJobAppCareer = ""; 
				String deleteJobMsCnt = ""; 
				String insertJobMsCnt = ""; 				
				
				int[] msCnt = new int[9];

				psmt = connLocal.prepareStatement(deleteJobMsCnt);
				psmt.executeUpdate();
				psmt.close();

				String insertJobMsCntVal = "('"+pEnterCd+"','"+recruit_seq+"', "+msCnt[0]+","+msCnt[1]+","+msCnt[2]+","+msCnt[3]+","+msCnt[4]+","+msCnt[5]+","+msCnt[6]+","+msCnt[7]+","+msCnt[8]+",'"+sabun+"', SYSDATE)";
				psmt = connLocal.prepareStatement(insertJobMsCnt+insertJobMsCntVal);
				psmt.executeUpdate();
				psmt.close();

				String recruit_seq = "";
				psmt = connLocal.prepareStatement(deleteJobApp);
				psmt.executeUpdate();
				psmt.close();

				psmt.executeUpdate();
				psmt.close();

				psmt = connLocal.prepareStatement(deleteJobAppSchool);
				psmt.executeUpdate();
				psmt.close();
				psmt = connLocal.prepareStatement(deleteJobAppPc);
				psmt.executeUpdate();
				psmt.close();

				psmt = connLocal.prepareStatement(deleteJobAppOversea);
				psmt.executeUpdate();
				psmt.close();

				psmt = connLocal.prepareStatement(deleteJobAppLicense);
				psmt.executeUpdate();
				psmt.close();

				psmt = connLocal.prepareStatement(deleteJobAppForeign);
				psmt.executeUpdate();
				psmt.close();

				psmt = connLocal.prepareStatement(deleteJobAppFamily);
				psmt.executeUpdate();
				psmt.close();

				psmt = connLocal.prepareStatement(deleteJobAppCareer);
				psmt.executeUpdate();
				psmt.close();

				rsJobOracleCnt = connLocal.prepareStatement(sb2.toString()).executeQuery();

				int idx2 = 0;
				int[] oracleCnt = new int[9];

				if(rsJobOracleCnt != null) {
					try {
						while (rsJobOracleCnt.next()) {
							oracleCnt[idx2] = rsJobOracleCnt.getInt(1);
							idx2++;
						}
					}finally{
						try {
							rsJobOracleCnt.close();
						} catch (Exception e) {
							Log.Debug("ResultSet JobOracleCnt CLOSE FAIL");
						}
					}
				}

				/*
				 * 오라클 DB 이관후 카운트
				 * */
				sb2.setLength(0);
				psmt = connLocal.prepareStatement(sb2.toString());
				psmt.executeUpdate();
				psmt.close();


				/*
				 * MS,ORACLE 비교
				 * */
				sb2.setLength(0);

				sb2.append(" SELECT APP_MS, APP_ORACLE, CAREER_MS, CAREER_ORACLE, FAMILY_MS, FAMILY_ORACLE, FOREIGN_MS, FOREIGN_ORACLE, LICENSE_MS, LICENSE_ORACLE, OVERSEA_MS, OVERSEA_ORACLE, PC_MS, PC_ORACLE, SCHOOL_MS, SCHOOL_ORACLE, SOCIAL_MS, SOCIAL_ORACLE ")
				   .append(" FROM TSTF_JOB_COUNT ")
				   .append(" WHERE ENTER_CD = '"+pEnterCd+"' AND SEQ = '"+recruit_seq+"' ");

				rsJobMsOracle = connLocal.prepareStatement(sb2.toString()).executeQuery();

				if(rsJobMsOracle != null) {
					try {
						if (rsJobMsOracle.next()) {
							map.put("APP_MS", rsJobMsOracle.getInt(1));
							map.put("APP_ORACLE", rsJobMsOracle.getInt(2));
							map.put("CAREER_MS", rsJobMsOracle.getInt(3));
							map.put("CAREER_ORACLE", rsJobMsOracle.getInt(4));
							map.put("FAMILY_MS", rsJobMsOracle.getInt(5));
							map.put("FAMILY_ORACLE", rsJobMsOracle.getInt(6));
							map.put("FOREIGN_MS", rsJobMsOracle.getInt(7));
							map.put("FOREIGN_ORACLE", rsJobMsOracle.getInt(8));
							map.put("LICENSE_MS", rsJobMsOracle.getInt(9));
							map.put("LICENSE_ORACLE", rsJobMsOracle.getInt(10));
							map.put("OVERSEA_MS", rsJobMsOracle.getInt(11));
							map.put("OVERSEA_ORACLE", rsJobMsOracle.getInt(12));
							map.put("PC_MS", rsJobMsOracle.getInt(13));
							map.put("PC_ORACLE", rsJobMsOracle.getInt(14));
							map.put("SCHOOL_MS", rsJobMsOracle.getInt(15));
							map.put("SCHOOL_ORACLE", rsJobMsOracle.getInt(16));
							map.put("SOCIAL_MS", rsJobMsOracle.getInt(17));
							map.put("SOCIAL_ORACLE", rsJobMsOracle.getInt(18));
						}
					}finally{
						try {
							rsJobMsOracle.close();
						} catch (Exception e) {
							Log.Debug("ResultSet JobMsOracle CLOSE FAIL");
						}
					}
				}

				sb2.setLength(0);
				sb2.append(" SELECT COUNT(*) FROM TSTF_JOB_COUNT ")
					.append(" WHERE ENTER_CD = '"+pEnterCd+"'AND SEQ = '"+recruit_seq+"' ")
					.append(" AND (APP_MS <> APP_ORACLE OR CAREER_MS <> CAREER_ORACLE OR ")
					.append(" FAMILY_MS <> FAMILY_ORACLE OR FOREIGN_MS <> FOREIGN_ORACLE OR ")
					.append(" LICENSE_MS <> LICENSE_ORACLE OR OVERSEA_MS <> OVERSEA_ORACLE OR ")
					.append(" PC_MS <> PC_ORACLE OR SCHOOL_MS <> SCHOOL_ORACLE OR ")
					.append(" SOCIAL_MS <> SOCIAL_ORACLE ) ");

				rsJobMsOracle2 = connLocal.prepareStatement(sb2.toString()).executeQuery();

				if(rsJobMsOracle2 != null) {
					try{
						if(rsJobMsOracle2.next()){
							map.put("CMP", rsJobMsOracle2.getInt(1));
						}
					}finally{
						try {
							rsJobMsOracle2.close();
						} catch (Exception e) {
							Log.Debug("ResultSet JobMsOracle2 CLOSE FAIL");
						}
					}
				}
			}
			
		} catch (Exception e) {
			if(conn!=null){conn.close();}
			throw new Exception(e);
		} finally {
			if(conn!=null){conn.close();}
			if(connLocal!=null) {connLocal.close();}
			if(psmt!=null){psmt.close();}
			if(rs830!=null){rs830.close();}
			if(rs101!=null){rs101.close();}
			if(rsJobApp!=null){rsJobApp.close();}
			if(rsJobAppSocial!=null){rsJobAppSocial.close();}
			if(rsJobAppSchool!=null){rsJobAppSchool.close();}
			if(rsJobAppPc!=null){rsJobAppPc.close();}
			if(rsJobAppOversea!=null){rsJobAppOversea.close();}
			if(rsJobAppLicense!=null){rsJobAppLicense.close();}
			if(rsJobAppForeign!=null){rsJobAppForeign.close();}
			if(rsJobAppFamily!=null){rsJobAppFamily.close();}
			if(rsJobAppCareer!=null){rsJobAppCareer.close();}
			if(rsJobMsCnt!=null){rsJobMsCnt.close();}
			if(rsJobOracleCnt!=null){rsJobOracleCnt.close();}
			if(rsJobMsOracle!=null){rsJobMsOracle.close();}
			if(rsJobMsOracle2!=null){rsJobMsOracle2.close();}
		}

		return map;
	}

    public String ClobProc(String original_Conents,String Select_Query,String Update_Query, Connection conn, String cName) throws SQLException {
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
            Log.Error(e.getLocalizedMessage());
            returnFlag = "99";
        } finally {
        	conn.setAutoCommit(true);
        	if (pre != null) pre.close();
        	if (res != null) res.close();
        }
    	
    	return returnFlag;
    }

 	@SuppressWarnings("unused")
	private void ftpSet(){

		try{
			/*************** 로컬 디렉토리 생성 *********************/
			File df = new File(LOCAL_DIR);
		    if(!df.isDirectory()) df.mkdirs();

			/*************** FTP 접속 *********************/
			ftpClient = new FTPClient();
			ftpClient.setControlEncoding("UTF-8");
			ftpClient.connect(FTP_IP, Integer.parseInt(FTP_PORT));

			int reply;
			// 연결 시도후, 성공했는지 응답 코드 확인
			reply = ftpClient.getReplyCode();

			if(!FTPReply.isPositiveCompletion(reply)){
				ftpClient.disconnect();
				logger.debug("ftp server connect fail.");
				Log.Debug("ftp server connect fail.");
			} else {
				logger.debug("ftp server connect success!!!");
			}

			//ftpClient.setSoTimeout(10000);

			if(!ftpClient.login(FTP_ID, FTP_PW)){
				logger.debug("ftp login fail...");
				Log.Debug("ftp login fail...");
				ftpClient.logout();
			} else {
				logger.debug("ftp login success!!!");
			}

			ftpClient.setFileType(FTP.BINARY_FILE_TYPE);
			//ftpClient.enterLocalPassiveMode();
			ftpClient.enterLocalActiveMode();
			//ftpClient.enterRemotePassiveMode();
			//ftpClient.enterRemoteActiveMode();
			ftpClient.changeWorkingDirectory(FTP_DIR);
			//ftpClient.makeDirectory();
			//ftpClient.changeWorkingDirectory();
		}catch(Exception e){
			Log.Debug(e.getLocalizedMessage());
			if(ftpClient != null && ftpClient.isConnected()){
				try{
					ftpClient.disconnect();
				}catch(IOException ioe){
					Log.Debug(ioe.getLocalizedMessage());
					//ioe.printStackTrace();
				}
			}
		}
 	}

	@SuppressWarnings("unused")
	private String ftpDown(String dFile) throws NumberFormatException, SocketException, IOException {
		String rInt = "";

		try{

			/*************** FTP의 ls 명령, 모든 파일 리스트를 가져온다 *********************/
	        FTPFile[] files = null;
	        files = ftpClient.listFiles();

	        File existFile = new File(LOCAL_DIR);
	        File[] existList = existFile.listFiles();

	        boolean bDown = false;
	        OutputStream output = null;
	        /*************** 파일을 전송 받는다 *********************/
	        for (int i = 0; i < files.length ; i++) {
	            String fileName = files[i].getName();
	            boolean fileYn = true;
	            if (existList != null) {
	            	for(int j = 0; j < existList.length; j++){
		            	if(fileName.equals(existList[j].getName())){
		            		fileYn = false;
		            		continue;
		            	}
		            }
	            }
	            if(fileYn && fileName.equals(dFile)){
					try{
						File local = new File(LOCAL_DIR + fileName);
						output = new FileOutputStream(local);
						bDown = ftpClient.retrieveFile(fileName, output);

						if(!bDown){
							rInt += fileName + "누락|";
						}
					}finally {
						try{
							output.close();
						}catch(IOException e){
							Log.Debug(e.getLocalizedMessage());
						}
					}
	            }
	        }

		/*************** FTP 종료 *********************/
		}catch(Exception e){
			Log.Debug(e.getLocalizedMessage());
			rInt += e.toString().replaceAll("'", "‘");
			if(ftpClient != null && ftpClient.isConnected()){
				try{
					ftpClient.disconnect();
				}catch(IOException ioe){
					//ioe.printStackTrace();
					Log.Error(ioe.getLocalizedMessage());
				}
			}
		}

		return rInt;
	}


	@SuppressWarnings("unused")
	private void ftpClose(){
        try{
        	ftpClient.logout();
        }catch(IOException e){
        	Log.Debug(e.getLocalizedMessage());
        }finally{
			if(ftpClient != null && ftpClient.isConnected()){
				try{
					ftpClient.disconnect();
				}catch(IOException ioe){
					Log.Debug(ioe.getLocalizedMessage());
				}
			}
        }
	}

}
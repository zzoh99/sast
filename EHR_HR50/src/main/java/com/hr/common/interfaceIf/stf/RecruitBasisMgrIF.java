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

public class RecruitBasisMgrIF {
	/**
	 * 입사지원서 - 기본사항 - 지원자정보 가져오기
	 * 외부채용DB 에서  인사-채용 DB 정보로 이관  
	 */

	private final String JNDI_EHR;
	private final String JNDI_REC;

	String dbYn, dbLog = "";

	public RecruitBasisMgrIF() throws Exception{
		InputStream is = getClass().getResourceAsStream("/opti.properties");
		Properties props = new Properties();
		try {
			props.load(is);
		} catch (Exception ex) {
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
		
		try {
			String sabun    = (String) map.get("ssnSabun");
			String recSeq   = (String) map.get("searchRecSeq");
			String tableIds = (String) map.get("tableIds");
			String tableNms = (String) map.get("tableNms");
			
			dbYn = "Y";
			dbLog = "";
			
			ctxt = new InitialContext();
			ds = (DataSource)ctxt.lookup(JNDI_EHR);
			connInsa = ds.getConnection();
			
			ctxt = new InitialContext();
			ds = (DataSource)ctxt.lookup(JNDI_REC);
			connRec = ds.getConnection();
			
			try {
				String[] tableIdArr = tableIds.split("/");
				String[] tableNmArr = tableNms.split("/");
				for(int i=0; i<tableIdArr.length; i++){
					returnValue = this.doSave( enterCd, sabun, recSeq, tableIdArr[i], connInsa, connRec );
					if (!"Y".equals(returnValue)) msg += "\n "+tableIdArr[i]+"("+tableNmArr[i]+") 처리오류.";
				}
			} catch(Exception e) {
				dbYn = "N";
				dbLog = e.toString().replaceAll("'", "‘");
			}

			if("Y".equals(dbYn)) {
				if ("".equals(msg)) {
					msg = "지원자정보 가져오기 성공";
					//이미지파일FTP다운로드
					String keyVal = "'" + enterCd + "" + recSeq + "'";
					RecruitFtpUtil.imgFileFtpDownload("ENTER_CD||REC_SEQ", keyVal, RecruitFtpUtil.TYPE_EHR);
				}
			} else {
				msg = "지원자정보 가져오기 실패 : " + "\n\n" + dbLog;
			}

			resultMap.put("successFlag", dbYn);
			resultMap.put("msg", msg);
			
		}catch (Exception e) {
			Log.Error("■■■■■ >RecruitBasisMgrIF doAction exception:"+e);
			if (connInsa != null) { try { connInsa.rollback(); } catch (SQLException e1) { Log.Debug(e.getLocalizedMessage()); } }
			if (connRec != null) { try { connRec.rollback(); } catch (SQLException e1) { Log.Debug(e.getLocalizedMessage()); } }
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

	private String doSave(String enterCd, String sabun, String recSeq, String tableName, Connection connInsa, Connection connRec) throws Exception {
		// 데이타 조회
		String returnValue = "";
		PreparedStatement psmt = null;
		ResultSet         rs   = null;
		PreparedStatement psmtTemp = null;
		ResultSet         rsTemp   = null;
		
		try{
			//	TSTF410 기본사항
			//	TSTF445	추가인적사항
			//	TSTF415	가족사항
			//	TSTF420	학력사항
			//	TSTF425	자격사항
			//	TSTF430	경력사항
			//	TSTF435	외국어사항
			//	TSTF440	해외경험
			//	TSTF450	수상내역
			//	TSTF453	사회봉사활동
			//	TSTF455	자기소개서
			//	TSTF465	첨부파일
		 
			String detailQuery  = ""; // select문
			String detailQuery1 = ""; // merge문 insert select
			String detailQuery2 = ""; // merge문 insert value
			String detailQuery3 = ""; // select 용 where
			String detailQuerySel =""; // merge 문 select ? AS 
			String detailQueryKey =""; // merge 문 key
			String detailQueryUp  =""; // merge 문 update
			String [][] colsInfo = null ; // key 여부/ data type (D:Date, C:Clob)/ column
			
			if ("TSTF410".equals(tableName)) {
				String[][] data = {{"K", " ", "APPL_NO" }
				, {" ", " ", "REC_SEQ" }
				, {" ", " ", "JOB_CD" }
				, {" ", " ", "WISH_JOB_CD1" }
				, {" ", " ", "WISH_JOB_CD2" }
				, {" ", " ", "NAME" }
				, {" ", " ", "ENAME" }
				, {" ", " ", "CNAME" }
				, {" ", " ", "BIRTH_YMD" }
				, {" ", " ", "SEX_TYPE" }
				, {" ", " ", "WED_YN" }
				, {" ", " ", "TEL_NO" }
				, {" ", " ", "MOBILE_NO" }
				, {" ", " ", "EMER_TEL_NO" }
				, {" ", " ", "MAIL_ADDR" }
				, {" ", " ", "ZIP_NO" }
				, {" ", " ", "ADDR1" }
				, {" ", " ", "FOREIGN_YN" }
				, {" ", " ", "BOHUN_YN" }
				, {" ", " ", "BOHUN_NO" }
				, {" ", " ", "HANDICAP_YN" }
				, {" ", " ", "HANDICAP_NM" }
				, {" ", " ", "SPECIALITY_NOTE" }
				, {" ", " ", "HOBBY" }
				, {" ", " ", "NATIONAL_CD" }
				, {" ", " ", "INTERN_YN" }
				, {" ", " ", "INTERN_S_YM" }
				, {" ", " ", "INTERN_E_YM" }
				, {" ", " ", "TRANSFER_CD" }
				, {" ", " ", "ARMY_DIS_CD" }
				, {" ", " ", "ARMY_CD" }
				, {" ", " ", "ARMY_POSITION_CD" }
				, {" ", " ", "ARMY_S_YM" }
				, {" ", " ", "ARMY_E_YM" }
				, {" ", " ", "ARMY_MEMO" }
				, {" ", " ", "REC_GB" }
				, {" ", " ", "SUBMIT_STATUS_CD" }
				, {" ", " ", "PHOTO_INFO" }
				, {" ", " ", "FILE_SEQ" }
				, {" ", " ", "PASSWORD" }
				, {" ", " ", "TOT_CARR_MTH" }
				, {" ", "D", "SUBMIT_DATE" }
				, {" ", " ", "STEP_TYPE_CD" }
				, {" ", " ", "APPL_STATUS_CD" }
				, {" ", " ", "TEMP_APPL_NO" }
                 };
				colsInfo = data;
			} else if ("TSTF445".equals(tableName)) {
				String[][] data = {{"K", " ", "APPL_NO" }
				, {" ", " ", "HEIGHT" }
				, {" ", " ", "WEIGHT" }
				, {" ", " ", "NATIVE_LANG_CD" }
				, {" ", " ", "ZIP_NO_BASIC" }
				, {" ", " ", "ADDR1_BASIC" }
				, {" ", " ", "RESPECT_PERSON" }
				, {" ", " ", "MOTTO_NOTE" }
				, {" ", " ", "BOOK_NM" }
				, {" ", " ", "COUNTRY_CD" }
				, {" ", " ", "HOPE_JOB" }
				, {" ", " ", "APP_PATH_CD" }
				, {" ", " ", "SELF_APPL_YN" }
				, {" ", " ", "SNS" }
                 };
				colsInfo = data;
				
			} else if ("TSTF415".equals(tableName)) {
				String[][] data = {{"K", " ", "APPL_NO" }
				, {"K", " ", "SEQ" }
				, {" ", " ", "FAM_CD" }
				, {" ", " ", "FAM_NM" }
				, {" ", " ", "FAM_BIRTH" }
				, {" ", " ", "FAM_OFFICE_NM" }
				, {" ", " ", "FAM_JIKWEE_NM" }
				, {" ", " ", "TOGETHER_YN" }
                 };
				colsInfo = data;
			} else if ("TSTF420".equals(tableName)) {
				String[][] data = {{"K", " ", "APPL_NO" }
				, {"K", " ", "SEQ" }
				, {" ", " ", "ACA_TYPE_CD" }
				, {" ", " ", "ENT_GRA_GB" }
				, {" ", " ", "ACA_CD" }
				, {" ", " ", "ACA_NM" }
				, {" ", " ", "ACA_PLACE_CD" }
				, {" ", " ", "ACA_MAJ_CD" }
				, {" ", " ", "ACA_MAJ_NM" }
				, {" ", " ", "ACA_MIN_GB" }
				, {" ", " ", "ACA_MIN_CD" }
				, {" ", " ", "ACA_MIN_NM" }
				, {" ", " ", "DOUMAJ_NM" }
				, {" ", " ", "ACA_S_YM" }
				, {" ", " ", "ACA_E_YM" }
				, {" ", " ", "GRADU_TYPE_CD" }
				, {" ", " ", "ACA_POINT" }
				, {" ", " ", "ACA_PER_POINT" }
				, {" ", " ", "ACA_DAY_NIGHT_GB" }
				, {" ", " ", "TRANSFER_YN" }
				, {" ", " ", "ACA_TYPE" }
                 };
				colsInfo = data;
			} else if ("TSTF425".equals(tableName)) {
				String[][] data = {{"K", " ", "APPL_NO" }
				, {"K", " ", "SEQ" }
				, {" ", " ", "LICENSE_CD" }
				, {" ", " ", "LICENSE_NM" }
				, {" ", " ", "LICENSE_OFFICE_NM" }
				, {" ", " ", "LICENSE_NO" }
				, {" ", " ", "LICENSE_S_YM" }
				, {" ", " ", "LICENSE_GRD" }
				, {" ", " ", "NOTE" }
                 };
				colsInfo = data;
			} else if ("TSTF430".equals(tableName)) {
				String[][] data = {{"K", " ", "APPL_NO" }
				, {"K", " ", "SEQ" }
				, {" ", " ", "COMPANY_NM" }
				, {" ", " ", "S_YM" }
				, {" ", " ", "E_YM" }
				, {" ", " ", "DEPART_NM" }
				, {" ", " ", "POSITION_NM" }
				, {" ", " ", "JOB_NM" }
				, {" ", " ", "HIRE_TYPE_CD" }
				, {" ", " ", "BASIC_SAL" }
				, {" ", " ", "PLACE_CD" }
				, {" ", " ", "COMPANY_DESC" }
				, {" ", " ", "MAIN_JOB" }
				, {" ", " ", "MAIN_JOB_DESC" }
				, {" ", " ", "RETIRE_REASON" }
				, {" ", " ", "HIRED_YN" }
				, {" ", " ", "MAIN_YN" }
				};
				colsInfo = data;
			} else if ("TSTF435".equals(tableName)) {
				String[][] data = {{"K", " ", "APPL_NO" }
				, {"K", " ", "SEQ" }
				, {" ", " ", "TEST_TYPE_CD" }
				, {" ", " ", "F_TEST_CD" }
				, {" ", " ", "F_TEST_NM" }
				, {" ", " ", "TEST_SCORE" }
				, {" ", " ", "TEST_GRADE" }
				, {" ", " ", "PERF_GRADE" }
				, {" ", " ", "TEST_YM" }
				, {" ", " ", "EXPIRE_YMD" }
				, {" ", " ", "NOTE" }
				};
				colsInfo = data;
			} else if ("TSTF440".equals(tableName)) {
				String[][] data = {{"K", " ", "APPL_NO" }
				, {"K", " ", "SEQ" }
				, {" ", " ", "ABROAD_CD" }
				, {" ", " ", "NATION_CD" }
				, {" ", " ", "S_YM" }
				, {" ", " ", "E_YM" }
				, {" ", " ", "NOTE" }
				};
				colsInfo = data;
			} else if ("TSTF450".equals(tableName)) {
				String[][] data = {{"K", " ", "APPL_NO" }
				, {"K", " ", "SEQ" }
				, {" ", " ", "CONTEST_NM" }
				, {" ", " ", "AWARD_NOTE" }
				, {" ", " ", "OFFICE_NM" }
				, {" ", " ", "AWARD_YM" }
				, {" ", " ", "PERSON_CNT" }
				};
				colsInfo = data;
			} else if ("TSTF453".equals(tableName)) {
				String[][] data = {{"K", " ", "APPL_NO" }
				, {"K", " ", "SEQ" }
				, {" ", " ", "ACTIVE_NM" }
				, {" ", " ", "S_YM" }
				, {" ", " ", "E_YM" }
				, {" ", " ", "ACTIVE_OFFICE" }
				, {" ", " ", "ACTIVE_NOTE" }
				};
				colsInfo = data;
			} else if ("TSTF455".equals(tableName)) {
				String[][] data = {{"K", " ", "APPL_NO" }
				, {"K", " ", "TITLE_SEQ" }
				, {" ", "C", "CONTENTS" }  // CLOB
				, {" ", " ", "SELF_APPL_YN" }
				};
				colsInfo = data;
			} else if ("TSTF465".equals(tableName)) {
				String[][] data = {{"K", " ", "APPL_NO" }
				, {"K", " ", "SEQ" }
				, {" ", " ", "FILE_PATH" }
				, {" ", " ", "FILE_NM" }
				, {" ", " ", "FILE_NM_ORG" }
				};
				colsInfo = data;
			}

			if ("TSTF410".equals(tableName)) {
				detailQuery3 = " WHERE (ENTER_CD, REC_SEQ, JOB_CD) IN (SELECT ENTER_CD, REC_SEQ, JOB_CD FROM TSTF113 WHERE MGR_ENTER_CD = '"+enterCd+"' AND REC_SEQ = "+recSeq+" ) "
						     + "   AND SUBMIT_STATUS_CD = 'B' ";
			} else {
				detailQuery3 = " WHERE APPL_NO IN ( SELECT APPL_NO FROM TSTF410 WHERE SUBMIT_STATUS_CD = 'B' AND (ENTER_CD, REC_SEQ, JOB_CD) IN (SELECT ENTER_CD, REC_SEQ, JOB_CD FROM TSTF113 WHERE MGR_ENTER_CD = '"+enterCd+"' AND REC_SEQ = "+recSeq+" )  ) ";
			}
			
			//Log.Debug("colsInfo.length:" +colsInfo.length);
			
			detailQuery  = "   ENTER_CD ";
			detailQuery1 = " T.ENTER_CD ";
			detailQuery2 = " S.ENTER_CD ";
			detailQueryKey = " T.ENTER_CD = S.ENTER_CD ";
			detailQuerySel = " ? AS ENTER_CD ";

			if(colsInfo != null){
				for(int i=0; i<colsInfo.length; i++){
					String key      = colsInfo[i][0];
					String dataType = colsInfo[i][1];
					String col      = colsInfo[i][2];

					if ( "D".equals(dataType)){
						detailQuery    += " , TO_CHAR("+col+", 'YYYYMMDDHH24MISS') AS " + col ;
					} else {
						detailQuery    += " , " +col;
					}

					detailQuery1   += " , T." +col;
					detailQuery2   += " , S." +col;

					if ( "D".equals(dataType)){
						detailQuerySel += " , TO_DATE(TRIM(?), 'YYYYMMDDHH24MISS')	AS " + col;
					} else {
						detailQuerySel += " , ? AS " +col;
					}

					if ("TSTF410".equals(tableName)) {
						if ( "K".equals(key)){
							detailQueryKey += " AND T." + col + " = S." +col;
						} else {
							// APPL_STATUS_CD, STEP_TYPE_CD insert시만 set 하고 update 하지 않는다
							if (!"APPL_STATUS_CD".equals(col) && !"STEP_TYPE_CD".equals(col)){
								detailQueryUp  += "  T." + col + " = S." +col + ", ";
							}

						}
					} else {
						if ( "K".equals(key)){
							detailQueryKey += " AND T." + col + " = S." +col;
						} else {
							detailQueryUp  += "  T." + col + " = S." +col + ", ";
						}
					}

				}
			} else {
				Log.Debug("colsInfo is null");
			}

			
			StringBuffer sbQuery = new StringBuffer();
			sbQuery.append("SELECT " + detailQuery)
				   .append("  FROM " + tableName + " T " )
				   .append("  " + detailQuery3);
			
			StringBuffer sbInsert = new StringBuffer();
			sbInsert.append(" MERGE INTO " + tableName + " T ")
					.append(" USING	( ")
					.append("         SELECT ")
					.append(detailQuerySel)
					.append("           FROM DUAL ")
					.append("                   ) S ")
					.append(" ON ( ")
					.append(detailQueryKey) 
					.append(" ) ")
					.append(" WHEN MATCHED THEN ")
					.append("      UPDATE SET ")
					.append(detailQueryUp)
					.append("             T.CHKDATE	 = SYSDATE ")
					.append("           , T.CHKID	 = '" + sabun + "'")
					.append(" WHEN NOT MATCHED THEN ")
					.append("      INSERT ( ")
					.append(detailQuery1)
					.append("           , T.CHKID, T.CHKDATE ")
					.append("             ) VALUES ( ")
					.append(detailQuery2)
					.append("           ,'" + sabun + "', SYSDATE ")
					.append("             ) ");

			//Log.Debug("=== sbQuery.toString() : "+sbQuery.toString());
			//Log.Debug("=== sbInsert.toString(): "+sbInsert.toString());
			
			String queryGetTEMP_APPL_NO = "SELECT F_STF_TEMP_APPLNO_CRE(?, ?) FROM DUAL ";
			
			// 채용DB에서 data select
			psmt = connRec.prepareStatement(sbQuery.toString());
			rs = psmt.executeQuery();
			
			if ( rs != null ) {
				while(rs.next()){
					psmt = connInsa.prepareStatement(sbInsert.toString());
					
					psmt.setString(1, enterCd);
					
					if ("TSTF410".equals(tableName)) {
						String tempApplNo = "";
						psmtTemp = connInsa.prepareStatement(queryGetTEMP_APPL_NO);
						psmtTemp.setString(1, enterCd);
						psmtTemp.setString(2, rs.getString(3));
						
						rsTemp = psmtTemp.executeQuery();
						while(rsTemp.next()){
							tempApplNo = rsTemp.getString(1); 
						}
						rsTemp.close();
						psmtTemp.close();
						
						for(int i=0; i<colsInfo.length; i++){
							String value = "";
							String col   = colsInfo[i][2];
									
							if ("C".equals(colsInfo[i][1]) ){
								value = " ";
							} else if ("APPL_STATUS_CD".equals(col)){
								value = "A0";
							} else if ("STEP_TYPE_CD".equals(col)){
								value = "A01";
							} else if ("TEMP_APPL_NO".equals(col)){	
								value = tempApplNo;
								//Log.Debug("tempApplNo : "+tempApplNo);
							} else {
								value = rs.getString(i+2);
							}
							psmt.setString(i+2, value);
							
							//Log.Debug("type:"+colsInfo[i][1] + ", colname:"+colsInfo[i][2]);
							//Log.Debug("i+2:"+(i+2)+", value:"+value);
						}
						
					} else {
						for(int i=0; i<colsInfo.length; i++){
							String value = "";
							//String col   = colsInfo[i][2];
									
							if ("C".equals(colsInfo[i][1]) ){
								value = " ";
							} else {
								value = rs.getString(i+2);
							}
							psmt.setString(i+2, value);
							
							//Log.Debug("type:"+colsInfo[i][1] + ", colname:"+colsInfo[i][2]);
							//Log.Debug("i+2:"+(i+2)+", value:"+value);
						}
					}
					
					psmt.executeUpdate();
					psmt.close();
					
					if ("TSTF455".equals(tableName)){
						String clobSql1 = "LSELECT CONTENTS FROM TSTF455    WHERE ENTER_CD = '"+enterCd+"' AND APPL_NO = '"+rs.getString("APPL_NO")+"' AND TITLE_SEQ = '"+rs.getString("TITLE_SEQ")+"' FOR UPDATE";
						String clobSql2 = "LUPDATE TSTF455 SET CONTENTS = ? WHERE ENTER_CD = '"+enterCd+"' AND APPL_NO = '"+rs.getString("APPL_NO")+"' AND TITLE_SEQ = '"+rs.getString("TITLE_SEQ")+"' ";
						ClobProc(rs.getString("CONTENTS"), clobSql1, clobSql2, connInsa, "CONTENTS");
					}					
				}
				rs.close();
			}
			connInsa.commit();  // table 하나 처리시 commit
			returnValue = "Y";
		}catch (Exception e) {
			returnValue = "error";
			Log.Error("■■■■■ > RecruitBasisMgrIF doSave exception tableName:"+tableName);
			Log.Debug(e.getLocalizedMessage());
		} finally{
			Log.Error("■■■■■ > RecruitBasisMgrIF doSave finally tableName:"+tableName);
			connInsa.commit();
			if(psmt!=null){psmt.close();}
			if(rs!=null){rs.close();}
			if(psmtTemp!=null){psmtTemp.close();}
			if(rsTemp!=null){rsTemp.close();}
		}
		
		return returnValue;

	}

    public String ClobProc(String original_Conents,String Select_Query,String Update_Query, Connection conn, String cName) throws SQLException {
    	String returnFlag = "0" ;
    	PreparedStatement pre = null;
    	ResultSet res = null;
    	try {
        	conn.setAutoCommit(false);       	 //   resource = new ConnectionResource(this);
        	pre = conn.prepareStatement(Select_Query);
        	res = pre.executeQuery();
			returnFlag = "1";
			conn.commit();
			conn.setAutoCommit(true);
        } catch(Exception e) {
        	conn.rollback();
            Log.Error("ClobProc e : " + e.toString());
            returnFlag = "99";
        } finally {
        	if (res != null) res.close();
			if (pre != null) pre.close();
        	conn.setAutoCommit(true);
        }
    	
    	return returnFlag;
    }
}
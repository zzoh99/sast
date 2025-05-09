package com.hr.common.interfaceIf.stf;

import java.io.File;
import java.io.InputStream;
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

import com.hr.common.logger.Log;
import com.hr.common.util.StringUtil;

public class RecruitDeleteIF {

	/**
	 * 채용공고등록 - 채용DB 지원자정보 삭제 
	 */
	private final String diskPath;
	
	private final String JNDI_EHR;
	private final String JNDI_REC;

	String dbYn, dbLog = "";

	public RecruitDeleteIF() throws Exception{
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
		diskPath = props != null && props.getProperty("disk.path") != null ? props.getProperty("disk.path").trim():"";
	}

	@SuppressWarnings("resource")
	public Map<String,Object> doAction(String enterCd, Map<String, Object> map) throws SQLException {
	//public Map<String,Object> doAction(String enterCd, String recSeq) throws SQLException {

		Map<String,Object> resultMap = new HashMap<String,Object>();
		ResultSet  rs          = null;
		Connection connInsa    = null;
		Connection connRec     = null;
		//String     returnValue = "";
		String     msg         = "";
		PreparedStatement psmt = null;
		
		CallableStatement cstmt = null;
		
		DataSource ds = null;
		Context ctxt = null;
		
		try{
			String recSeq = "";
			String sabun  = "";
			try {
				recSeq = map.get("recSeq").toString();
				sabun  = map.get("ssnSabun").toString();
			} catch (Exception e){
				Log.Debug("RecruitDeleteIF get e:"+ e);
			}
			
			try{
				ctxt = new InitialContext();
				ds = (DataSource)ctxt.lookup(JNDI_EHR);
				connInsa = ds.getConnection();
			}catch (Exception e) {
				Log.Error("======== RecruitDeleteIF conn exception:"+e);
				
				if(connInsa!=null){connInsa.close();}

				throw new Exception(e);
			}

			try{
				ctxt = new InitialContext();
				ds = (DataSource)ctxt.lookup(JNDI_REC);
				connRec = ds.getConnection();
			}catch (Exception e) {
				Log.Error("======== RecruitDeleteIF connLocal exception:"+e);
				throw new Exception(e);
			}
			
			dbYn = "Y";
			dbLog = "";

			try {
				List<Map<String,Object>> recList = new ArrayList<Map<String,Object>>();

				if (recSeq == null || "".equals(recSeq)){
					// recSeq 공고번호가 없으면 공고게시종료일 기준 180일 이후 데이터 삭제 
					
					StringBuffer sbQuery = new StringBuffer();
					sbQuery.append("SELECT ENTER_CD, REC_SEQ ")
						   .append("  FROM TSTF830 " )
						   .append(" WHERE SYSDATE - DIS_E_DT > 180 ")
						   .append("   AND REC_NOTICE_GB != 'P' ")
						   .append("   AND NVL(DELETE_YN,'N') = 'N' ");

					//Log.Debug("===sbQuery:"+sbQuery.toString());
					
					// 채용DB에서 data select
					psmt = connInsa.prepareStatement(sbQuery.toString());
					rs = psmt.executeQuery();
					
					if ( rs != null ) {
						while(rs.next()){
							Map<String,Object> tempMap = new HashMap<String,Object>();
							tempMap.put("ENTER_CD", rs.getString("ENTER_CD"));
							tempMap.put("REC_SEQ",  rs.getString("REC_SEQ"));
							recList.add(tempMap);
						}
					}
				} else {
					Map<String,Object> tempMap = new HashMap<String,Object>();
					tempMap.put("ENTER_CD", enterCd);
					tempMap.put("REC_SEQ",  recSeq);
					recList.add(tempMap);
				}
				
				StringBuffer sbUpdate = new StringBuffer();
				sbUpdate.append("UPDATE TSTF830 " )
					    .append("   SET DELETE_YN = 'Y', DELETE_DATE = SYSDATE ")
					    .append(" WHERE ENTER_CD  = ? ")
					    .append("   AND REC_SEQ   = ? ");
				
				for(Map<String,Object> mp : recList) {
					String tempEnterCd = (String)mp.get("ENTER_CD");
					String tempRecSeq  = (String)mp.get("REC_SEQ");
					
					//Log.Debug("======= tempEnterCd:"+tempEnterCd +", tempRecSeq:"+tempRecSeq);
					
					// 1. 채용DB 삭제 할 테이블 ==========> 아래 프로시저 호출로 변경 함
					//	TSTF410 기본사항   -- 맨 마지막에 delete 해야함....
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
					
					//Log.Debug("채용DB 삭제 - start");
					/*
					returnValue = this.doSave( "TSTF445", tempEnterCd, sabun, tempRecSeq, connRec);
					if (!"Y".equals(returnValue)) msg += "\n TSTF445(추가인적사항) 처리오류.";
					
					returnValue = this.doSave( "TSTF415", tempEnterCd, sabun, tempRecSeq, connRec);
					if (!"Y".equals(returnValue)) msg += "\n TSTF415(가족사항) 처리오류.";
					
					returnValue = this.doSave( "TSTF420", tempEnterCd, sabun, tempRecSeq, connRec);
					if (!"Y".equals(returnValue)) msg += "\n TSTF420(학력사항) 처리오류.";
					
					returnValue = this.doSave( "TSTF425", tempEnterCd, sabun, tempRecSeq, connRec);
					if (!"Y".equals(returnValue)) msg += "\n TSTF425(자격사항) 처리오류.";
					
					returnValue = this.doSave( "TSTF430", tempEnterCd, sabun, tempRecSeq, connRec);
					if (!"Y".equals(returnValue)) msg += "\n TSTF430(경력사항) 처리오류.";
					
					returnValue = this.doSave( "TSTF435", tempEnterCd, sabun, tempRecSeq, connRec);
					if (!"Y".equals(returnValue)) msg += "\n TSTF435(외국어사항) 처리오류.";
					
					returnValue = this.doSave( "TSTF440", tempEnterCd, sabun, tempRecSeq, connRec);
					if (!"Y".equals(returnValue)) msg += "\n TSTF440(해외경험) 처리오류.";

					returnValue = this.doSave( "TSTF450", tempEnterCd, sabun, tempRecSeq, connRec);
					if (!"Y".equals(returnValue)) msg += "\n TSTF450(수상내역) 처리오류.";

					returnValue = this.doSave( "TSTF453", tempEnterCd, sabun, tempRecSeq, connRec);
					if (!"Y".equals(returnValue)) msg += "\n TSTF453(사회봉사활동) 처리오류.";

					returnValue = this.doSave( "TSTF455", tempEnterCd, sabun, tempRecSeq, connRec);
					if (!"Y".equals(returnValue)) msg += "\n TSTF455(자기소개서) 처리오류.";
					
					returnValue = this.doSave( "TSTF465", tempEnterCd, sabun, tempRecSeq, connRec);
					if (!"Y".equals(returnValue)) msg += "\n TSTF465(첨부파일) 처리오류.";
					
					returnValue = this.doSave( "TSTF410", tempEnterCd, sabun, tempRecSeq, connRec);
					if (!"Y".equals(returnValue)) msg += "\n TSTF410(기본사항) 처리오류.";
					*/
					
					//Log.Debug("채용DB 삭제 - end");
					
					// 1. 채용DB 삭제 - 프로시저 호출 P_STF_DELETE_ALL
					try{
						//Log.Debug("call P_STF_DELETE_ALL start");
						
						cstmt = connRec.prepareCall("{call P_STF_DELETE_ALL(?,?,?,?,?)}");
				        cstmt.registerOutParameter(1, java.sql.Types.VARCHAR);
				        cstmt.registerOutParameter(2, java.sql.Types.VARCHAR);
						cstmt.setString(3, tempEnterCd);
						cstmt.setString(4, tempRecSeq);
						cstmt.setString(5, sabun);
						/* boolean flag = */cstmt.execute();
						//Log.Debug("call P_STF_DELETE_ALL end");
					} catch (Exception e){
						msg += "\n 채용 P_STF_DELETE_ALL 처리오류.";
						Log.Error("채용 P_STF_DELETE_ALL e:"+e);
					}
					
					// 2. 인사DB 삭제 - 프로시저 호출 P_STF_DELETE_ALL
					try{
						//Log.Debug("call P_STF_DELETE_ALL start");
						cstmt = connInsa.prepareCall("{call P_STF_DELETE_ALL(?,?,?,?,?)}");
				        cstmt.registerOutParameter(1, java.sql.Types.VARCHAR);
				        cstmt.registerOutParameter(2, java.sql.Types.VARCHAR);
						cstmt.setString(3, tempEnterCd);
						cstmt.setString(4, tempRecSeq);
						cstmt.setString(5, sabun);
						/* boolean flag = */cstmt.execute();
						//Log.Debug("call P_STF_DELETE_ALL end");
					} catch (Exception e){
						msg += "\n 인사 P_STF_DELETE_ALL 처리오류.";
						Log.Error("인사 P_STF_DELETE_ALL e:"+e);
					}
					
					connRec.commit();
					connInsa.commit();

					         
					// 3. 채용사진, 첨부파일 삭제
					// recfile 아래 공고번호별로 삭제
					//Log.Debug("recfile 삭제 - start");
					/* returnValue = */this.doDelFile(tempEnterCd, tempRecSeq);
					//Log.Debug("recfile 삭제 - end");
					
					
					//Log.Debug("인사DB 채용공고테이블(TSTF830)에 삭제여부 update - start");
					// 4. 인사DB 채용공고테이블(TSTF830)에 삭제 완료 flag 저장   ===> 프로시저안에서 처리함
					/*
					psmt = connInsa.prepareStatement(sbUpdate.toString());
					psmt.setString(1, tempEnterCd);
					psmt.setString(2, tempRecSeq);
					psmt.executeUpdate();
					psmt.close();
					*/
					//Log.Debug("인사DB 채용공고테이블(TSTF830)에 삭제여부 update - end");
				}
			} catch(Exception e) {
				dbYn = "N";
				dbLog = e.toString().replaceAll("'", "‘");
			}

			if("Y".equals(dbYn)){
				if ("".equals(msg)) msg = "채용정보 삭제 성공";
			}else{
				msg = "채용정보 삭제 실패 : " + "\n\n" + dbLog;
			}

			resultMap.put("successFlag", dbYn);
			resultMap.put("msg", msg);
			
		}catch (Exception e) {
			Log.Error("======== RecruitDeleteIF doAction exception:"+e);
			try {
				if(connInsa != null) connInsa.rollback();
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
			if (psmt != null) {
				try {
					psmt.close();
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
			
			if(connInsa !=null){
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

	@SuppressWarnings("unused")
	private String doSave(String tableName, String enterCd, String sabun, String recSeq, Connection connRec) throws Exception {
		// 데이타 조회
		String returnValue = "";
		PreparedStatement psmt = null;
		ResultSet         rs   = null;
		
		try{
			// 채용DB 삭제 할 테이블
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
			
			int    colCnt      = 0;
			String detailQuery = ""; // where
			
			if ("TSTF410".equals(tableName)) {
				detailQuery = " WHERE REC_SEQ = '" + recSeq + "' ";
			} else {
				detailQuery = " WHERE APPL_NO IN ( SELECT APPL_NO FROM TSTF410 WHERE REC_SEQ = '" + recSeq + "' ) ";
			}

			StringBuffer sbDelete = new StringBuffer();
			sbDelete.append("LDELETE FROM "+tableName + detailQuery );
			
			//Log.Debug("=== sbDelete.toString(): "+sbDelete.toString());

			// 채용DB data delete
			psmt = connRec.prepareStatement(sbDelete.toString());
			psmt.executeUpdate();

			connRec.commit();  // table 하나 처리시 commit
			returnValue = "Y";
		}catch (Exception e) {
			returnValue = "error";
			Log.Error("======== doSave exception tableName:"+tableName);
		} finally{
			Log.Info("======== doSave finally tableName:"+tableName);
			if(connRec != null) {
				connRec.commit();
				connRec.close();
			}
			if(psmt!=null){psmt.close();}
			if(rs!=null){rs.close();}
		}
		
		return returnValue;
	}
	
	private String doDelFile(String enterCd, String recSeq) throws Exception {
		// 채용서버 파일 삭제 - 사진/첨부파일만 삭제
		// recfile/ssnEnterCd/ssnRecSeq/photo <— 사진
		// recfile/ssnEnterCd/ssnRecSeq/attach <— 첨부
		
		String returnValue = "";
		
		try{
			String path1 = diskPath;
			String path2      = "/recfile/" +enterCd +"/" + recSeq + "/";
			
			List<String> dirList = new ArrayList<String>();
			dirList.add("photo");
			dirList.add("attach");
					
			String workPath = "";

			for(String dirName : dirList) {
				try {
					workPath = StringUtil.replaceAll( path1 + path2 + dirName, "//", "/");
					File d = new File(workPath);
					//Log.Debug("=============== File Delete Path        : "+ workPath);
					
					File[] tempFile = d.listFiles();
					if(tempFile != null && tempFile.length > 0){
						for (int i = 0; i < tempFile.length; i++) {
							if(tempFile[i].isFile()){
								tempFile[i].delete();
							}
							tempFile[i].delete();
						}
					}			
					d.delete();
				} catch(Exception e){
					Log.Debug("doDelFile e:"+e);
				}
			}
			
			returnValue = "Y";
		}catch (Exception e) {
			returnValue = "error";
			Log.Error("======== doDelFile exception ");
			Log.Debug(e.getLocalizedMessage());
		} finally{
			Log.Error("======== doDelFile finally ");
		}
		
		return returnValue;

	}
}
package com.hr.common.interfaceIf.sys;

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

public class GrpCdMgrIF {
	
	/**
	 * 채용DB로 코드정보 내보내기
	 * 인사-채용 DB 정보를  외부채용DB로 이관
	 */
	
	private final String JNDI_EHR;
	private final String JNDI_REC;

	String dbYn, dbLog = "";

	public GrpCdMgrIF() throws Exception{
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
			String sabun    = map.get("ssnSabun").toString();
			ctxt = new InitialContext();
			ds = (DataSource)ctxt.lookup(JNDI_EHR);
			connInsa = ds.getConnection();
			
			ctxt = new InitialContext();
			ds = (DataSource)ctxt.lookup(JNDI_REC);
			connRec = ds.getConnection();
			
			dbYn = "Y";
			dbLog = "";

			try {
				returnValue = this.doSave( enterCd, sabun, "TSYS001", connInsa, connRec );
				if (!"Y".equals(returnValue)) msg += "\n TSYS001  처리오류.";
				returnValue = this.doSave( enterCd, sabun, "TSYS005", connInsa, connRec );
				if (!"Y".equals(returnValue)) msg += "\n TSYS005  처리오류.";
			} catch(Exception e) {
				dbYn = "N";
				dbLog = e.toString().replaceAll("'", "‘");
			}
			
			if("Y".equals(dbYn)){
				if ("".equals(msg)) msg = "코드정보 내보내기 성공";
			}else{
				msg = "코드정보 내보내기 실패 : " + "\n\n" + dbLog;
			}

			resultMap.put("successFlag", dbYn);
			resultMap.put("msg", msg);
		} catch (Exception e) {
			Log.Error("======== GrpCdMgrIF doAction exception:"+e);
			if (connInsa != null) { try { connInsa.rollback(); } catch (SQLException e1) { Log.Debug(e1.getLocalizedMessage()); } }
			if (connRec != null) { try { connRec.rollback(); } catch (SQLException e1) { Log.Debug(e1.getLocalizedMessage()); } }
			msg = "코드정보 내보내기 실패 : " + "\n\n" + dbLog;
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

	@SuppressWarnings("resource")
	private String doSave(String enterCd, String sabun, String tableName, Connection connInsa, Connection connRec) throws Exception {
		// 데이타 조회
		String returnValue = "";
		PreparedStatement psmt = null;
		ResultSet         rs   = null;
		
		try{
//				int    colCnt      = 0;
//				String detailQuery1 = ""; // select문
//				String detailQuery2 = ""; // insert문
//				String detailQuery3 = ""; // where1
//				String detailQuery4 = ""; // where2
//				String detailQueryValue = ""; // insert문 values
			
			String [][] colsInfo = null ; // key 여부/ data type (D:Date, C:Clob)/ column
			
			if ("TSYS001".equals(tableName)) {
				String[][] data = {{"K", " ", "GRCODE_CD" }
				, {" ", " ", "GRCODE_NM" }
				, {" ", " ", "GRCODE_FULL_NM" }
				, {" ", " ", "GRCODE_ENG_NM" }
				, {" ", " ", "TYPE" }
				, {" ", " ", "SEQ" }
				, {" ", " ", "BIZ_CD" }
				, {" ", " ", "COMMON_YN" }
				, {" ", " ", "REC_YN" }
                 };
				colsInfo = data;
				
//					detailQuery4 = " WHERE REC_YN = 'Y' ";
			} else if ("TSYS005".equals(tableName)) {
				String[][] data = {{"K", " ", "ENTER_CD" }
				, {"K", " ", "GRCODE_CD" }
				, {"K", " ", "CODE" }
				, {" ", " ", "CODE_NM" }
				, {" ", " ", "CODE_FULL_NM" }
				, {" ", " ", "CODE_ENG_NM" }
				, {" ", " ", "SEQ" }
				, {" ", " ", "VISUAL_YN" }
				, {" ", " ", "USE_YN" }
				, {" ", " ", "NOTE1" }
				, {" ", " ", "NOTE2" }
				, {" ", " ", "NOTE3" }
				, {" ", " ", "NUM_NOTE" }
				, {" ", " ", "MEMO" }
				, {" ", " ", "ERP_CODE" }
				, {" ", " ", "NOTE4" }
                 };
				colsInfo = data;
//					detailQuery3 = " WHERE GRCODE_CD IN (SELECT GRCODE_CD FROM TSYS001 WHERE REC_YN = 'Y' ) ";
			}

			if(colsInfo != null){
				for(int i=0; i<colsInfo.length; i++){
//					String key      = colsInfo[i][0];
//					String dataType = colsInfo[i][1];
//					String col      = colsInfo[i][2];

//					detailQuery2   += col + ", " ;

//					if ( "D".equals(dataType)){
//						detailQuery1     += " TO_CHAR("+col+", 'YYYYMMDDHH24MISS') AS " + col + ", ";
//						detailQueryValue += " TO_DATE(?, 'YYYYMMDDHH24MISS'), ";
//					} else {
//						detailQuery1     += col + ", " ;
//						detailQueryValue += " ?, ";
//					}
				}
			}else{
				Log.Debug("colsInfo is null");
			}
			
			StringBuffer sbQuery = new StringBuffer();
			StringBuffer sbDelete = new StringBuffer();
			StringBuffer sbInsert = new StringBuffer();
/*				
				sbQuery.append("LSELECT " + detailQuery1+ " '' ")
					   .append("  FROM " + tableName  )
					   .append( detailQuery3 + detailQuery4);

				sbDelete.append("LDELETE FROM "+tableName );

				sbInsert.append("LINSERT INTO " + tableName)
				.append("( "+detailQuery2+" CHKID, CHKDATE ) ")
				.append("VALUES ( ")
				.append(detailQueryValue)
				.append(" '"+sabun+"', SYSDATE )");
				
*/				
			
			Log.Debug("=== sbQuery.toString() : "+sbQuery.toString());
			Log.Debug("=== sbDelete.toString(): "+sbDelete.toString());
			Log.Debug("=== sbInsert.toString(): "+sbInsert.toString());

			// 인사DB data select
			psmt = connInsa.prepareStatement(sbQuery.toString());
			rs = psmt.executeQuery();
			
			// 채용DB data delete
			psmt = connRec.prepareStatement(sbDelete.toString());
			psmt.executeUpdate();
			psmt.close();
			
			if ( rs != null ) {
				while(rs.next()){
					psmt = connRec.prepareStatement(sbInsert.toString());
					for(int i=0; i<colsInfo.length; i++){
						String value = "";
//							String col   = colsInfo[i][2];
								
						if ("C".equals(colsInfo[i][1]) ){
							value = " ";
						} else {
							value = rs.getString(i+1);
						}
						psmt.setString(i+1, value);
					}
					
					psmt.executeUpdate();
					psmt.close();
				}
				rs.close();
			}
			connRec.commit();  // table 하나 처리시 commit
			returnValue = "Y";
		}catch (Exception e) {
			returnValue = "error";
			Log.Error("======== GrpCdMgrIF doSave exception tableName:"+tableName);
			//Log.Debug("======== exception tableName:"+tableName);
			Log.Debug(e.getLocalizedMessage());
		} finally{
			Log.Debug("======== GrpCdMgrIF doSave finally tableName:"+tableName);
			//Log.Debug("======== finally tableName:"+tableName);
			connInsa.commit();
			if(psmt!=null){psmt.close();}
			if(rs!=null){rs.close();}
		}
		
		return returnValue;

	}

    public String ClobProc(String original_Conents,String Select_Query,String Update_Query, Connection conn, String cName) throws SQLException {
    	PreparedStatement pre = null;
    	ResultSet res = null;
    	String returnFlag = "0" ;

    	try {
        	conn.setAutoCommit(false);       	 //   resource = new ConnectionResource(this);
        	pre = conn.prepareStatement(Select_Query);
        	res = pre.executeQuery();
			returnFlag = "1";
			conn.commit();
			conn.setAutoCommit(true);
			res.close();
			pre.close();
        } catch(Exception e) {
        	conn.rollback();
            Log.Error("ClobProc e:" + e.getLocalizedMessage());
            returnFlag = "99";
        } finally {
        	conn.setAutoCommit(true);
        	if (pre != null) pre.close();
        	if (res != null) res.close();
        }
    	
    	return returnFlag;
    }
}
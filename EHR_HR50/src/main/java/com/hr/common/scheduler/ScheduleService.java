package com.hr.common.scheduler;

import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.ResultSetMetaData;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.inject.Inject;
import javax.inject.Named;

import org.springframework.stereotype.Service;

import com.hr.common.dao.Dao;
import com.hr.common.logger.Log;
import com.hr.common.mssql.MsSqlConnection;

@Service("ScheduleService")
@SuppressWarnings("unchecked")
public class ScheduleService {

	@Inject
	public Dao dao;
	
	@Inject
	@Named("MsSqlConnection")
	private MsSqlConnection msSqlConn;
	
	public List<?> getSendDataList(Map<?, ?> paramMap) throws Exception {
		return  (List<?>) dao.getList("getSendDataList", paramMap);
	}
	
	public int updateSMTP(Map<?, ?> paramMap) throws Exception {
		return dao.update("updateSMTP", paramMap);
	}
	
	/**
	 * 마지막 업데이트 기준시간 가져오기
	 * @param paramMap
	 * @return
	 * @throws Exception
	 */
	public Map<String, Object> getScheduleLastTime(Map<String, Object> paramMap) throws Exception {
		Log.Debug();
		Map<String, Object> resultMap = (Map<String, Object>)dao.getMap("getScheduleLastTime", paramMap);
		Log.Debug();
		return resultMap;
	}
	
	/**
	 * 마지막 업데이트 시간 저장
	 * @param convertMap
	 * @return
	 * @throws Exception
	 */
	public int saveScheduleLastTime(Map<?, ?> convertMap) throws Exception {
		Log.Debug();
		int cnt= dao.update("saveScheduleLastTime", convertMap);
		return cnt;
	}

	/**
	 * 세콤 데이터 연동
	 * @param paramMap
	 * @return
	 */
	public Map<String, Object> getSecomData(Map<String, Object> paramMap) {
		return getSecomDataDtl(paramMap, "secom"); 
	}
	/**
	 * 세콤 데이터 연동
	 * @param paramMap
	 * @return
	 */
	public Map<String, Object> getSecomDataDtl(Map<String, Object> paramMap, String connName) {
		Log.DebugStart();
		
		//에로로그 기록을 위한 값
		paramMap.put("bizCd", "SECOM");
		paramMap.put("objectNm", "getSecomData");

		Map<String, Object> resultMap = new HashMap<String, Object>();
		resultMap.put("Code", "0");
		resultMap.put("Message", "");
		
		String ssnSabun = String.valueOf(paramMap.get("ssnSabun"));

		//MS SQL Connection 
		Connection con = null;
		Statement stmt1 = null;
		Statement stmt2 = null;
		ResultSet rs1 = null;
		ResultSet rs2 = null;
		
		try {
			Log.Debug("MS-SQL driver 연결");
			Log.Debug(">> 연동 시작" );
			con = msSqlConn.getConn(connName); //커넥스 풀 가져오기
			
			if (con != null) {
				int cnt1 = 0, cnt2 = 0;
				
				//T_SECOM_ALARM
				String sql1 = "SELECT A.ATime,   A.ID,      A.EqCode,  A.Master,     A.Param" 
						   + "     , A.Ack,     A.AckUser, A.AckTime, A.AckContent, A.Transfer" 
						   + "     , A.AckMode, A.CardNo,  A.Name,    A.State,      A.Flag1" 
						   + "     , A.Flag2,   A.Flag3,   A.Flag4,   A.InsertTime, A.UpdateTime"
						   + "     , A.Version, B.Sabun" 
						   + "  FROM T_SECOM_ALARM A, T_SECOM_PERSON B " 
						   + " WHERE A.CardNo = B.CardNo";
				
				//T_SECOM_WORKHISTORY
				String sql2 = "SELECT A.WorkDate,      A.JuminNo,    A.Name,         A.Sabun,         A.Company" 
						   + "      , A.Department,    A.Team,       A.Part,         A.Grade,         A.WorkGroupCode" 
						   + "      , A.WorkGroupName, A.ScheduleID, A.ScheduleName, A.ScheduleType,  A.WorkType" 
						   + "      , A.bWS,           A.bWC,        A.WSTime,       A.WCTime,        A.PWType"
						   + "      , A.PWTime,        A.OWTime,     A.NWTime,       A.TotalWorkTime, A.NormalWorkTime" 
						   + "      , A.HWTime,        A.bLate,      A.bPWC,         A.bAbsent,       A.LateTime"
						   + "      , A.ModifyUser,    A.ModifyTime,  A.InsertTime,  A.UpdateTime,    A.Version"
						   + "  FROM T_SECOM_WORKHISTORY A" 
						   + " WHERE A.UpdateTime IS NOT NULL";
				
				//Schedule
				if( ssnSabun.equals("Schedule")) {
					String sTime = String.valueOf(paramMap.get("sTime"));
					String eTime = String.valueOf(paramMap.get("eTime"));
					if( paramMap.get("sTime") == null || "".equals(sTime) ) {
						sTime = String.valueOf(paramMap.get("searchYmd")) +"000000";
					}
					
					sql1+= "   AND A.ATime >= '"+sTime+"' ";
					sql1+= "   AND A.ATime <= '"+eTime+"' "; //현재시간

					sql2+= "   AND A.UpdateTime >= '"+sTime+"' ";
					sql2+= "   AND A.UpdateTime <= '"+eTime+"' "; //현재시간
				}else {
					//화면에서 수동 실행
					sql1+= "   AND SUBSTRING(A.ATime, 1, 8)  = '"+String.valueOf(paramMap.get("searchYmd"))+"' ";
					sql2+= "   AND A.WorkDate  = '"+String.valueOf(paramMap.get("searchYmd"))+"' ";
				}
				
				
				//------------------------------------------------------------------------------------------------------
				// 1. T_SECOM_ALARM 저장
				//------------------------------------------------------------------------------------------------------
				stmt1 = con.createStatement();
				rs1 = stmt1.executeQuery(sql1);

				List<Map<String, Object>> resultList1 = new ArrayList<Map<String,Object>>();
				resultList1 = convertResultSetToArrayList(rs1);
				for(Map<String, Object> map : resultList1) {
					//Log.Debug(saveCnt + " --> map: "+ map.toString());
			        map.put("ssnEnterCd", paramMap.get("ssnEnterCd"));
			        cnt1 += dao.update("saveScheduleSecom", map);
				}
				Log.Debug("1.저장 데이터 수 : "+cnt1);
				

				//------------------------------------------------------------------------------------------------------
				// 2. T_SECOM_WORKHISTORY 저장
				//------------------------------------------------------------------------------------------------------
				stmt2 = con.createStatement();
				rs2 = stmt2.executeQuery(sql2);

				List<Map<String, Object>> resultList2 = new ArrayList<Map<String,Object>>();
				resultList2 = convertResultSetToArrayList(rs2);
				for(Map<String, Object> map : resultList2) {
			        //Log.Debug(saveCnt + " --> map: "+ map.toString());
			        map.put("ssnEnterCd", paramMap.get("ssnEnterCd"));
			        cnt2 += dao.update("saveScheduleSecomWork", map);
				}
				Log.Debug("2.저장 데이터 수 : "+cnt2);
				
				if( cnt1 > 0 || cnt2 > 0 ) { //새로 저장된 데이터가 있을때만 출퇴근 반영 
					//TTIM330에 반영
					Map<?, ?> map = (Map<?, ?>) dao.excute("prcScheduleTimecardIns", paramMap);
					if (map.get("sqlCode") != null) {
						resultMap.put("Code", map.get("sqlCode").toString());
					}
					if (map.get("sqlErrm") != null) {
						resultMap.put("Message", "출퇴근 반영 중 오류 => "  + map.get("sqlErrm").toString());
					}
					
					if (map.get("sqlCode") != null || map.get("sqlErrm") != null ) {
		
						// 에러 로그
						paramMap.put("errLocation", "prc");
						paramMap.put("errLog", String.valueOf(map.get("sqlErrm")));
						//Map<?, ?> error = (Map<?, ?>)dao.excute("procScheErrLog", paramMap);
					}
				}
			}
		} catch (SQLException ex) {
			//ex.printStackTrace();
			Log.Debug(ex.getMessage());

			resultMap.put("Code", "-99");
			resultMap.put("Message", ex.getMessage());
			
			// 에러 로그
			paramMap.put("errLocation", "SQLEx");
			paramMap.put("errLog", ex.getMessage());
			//Map error = (Map)dao.excute("procScheErrLog", paramMap);
		} catch (Exception e) {
			Log.Debug(e.getLocalizedMessage());
			resultMap.put("Code", "-98");
			resultMap.put("Message", e.getMessage());
		} finally {
			if (rs1 != null) try { rs1.close(); } catch(Exception e) { Log.Debug(e.getLocalizedMessage()); } ;
			if (rs2 != null) try { rs2.close(); } catch(Exception e) { Log.Debug(e.getLocalizedMessage()); } ;
			if (stmt1 != null) try { stmt1.close(); } catch(Exception e) { Log.Debug(e.getLocalizedMessage()); } ;
			if (stmt2 != null) try { stmt2.close(); } catch(Exception e) { Log.Debug(e.getLocalizedMessage()); } ;
			if (con != null) try { con.close(); Log.Debug("정보 연동 끝" );} catch(Exception e) { Log.Debug(e.getLocalizedMessage()); } ;
		}
		
		Log.DebugEnd();
		return resultMap;
	}
	
	
	/**
	 * ResultSet To ArrayList
	 * @param rs
	 * @return
	 * @throws SQLException
	 */
	public List<Map<String, Object>> convertResultSetToArrayList(ResultSet rs) throws SQLException {
	    ResultSetMetaData md = rs.getMetaData();
	    int columns = md.getColumnCount();
	    List<Map<String, Object>> list = new ArrayList<Map<String,Object>>();
	 
	    while(rs.next()) {
	        HashMap<String,Object> row = new HashMap<String, Object>(columns);
	        for(int i=1; i<=columns; ++i) {
	            row.put(md.getColumnName(i), rs.getObject(i));
	        }
	        list.add(row);
	    }
	 
	    return list;
	}
}

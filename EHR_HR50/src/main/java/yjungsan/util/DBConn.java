package yjungsan.util;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import javax.naming.Context;
import javax.naming.InitialContext;
import javax.sql.DataSource;

import com.hr.common.logger.Log;
import oracle.jdbc.OracleTypes;
 

public class DBConn {
	 

	private static DataSource ds;
	
	/**
	 * db 커넥션 리턴.
	 * @return
	 */
	public  static synchronized Connection getConnection(){
		
		Connection rtnCon = null;
		
		try{
			if(ds == null) {
				Context ctx = new InitialContext();
				ds = (DataSource)ctx.lookup(StringUtil.getPropertiesValue("JNDI.NAME"));
			}
			rtnCon = ds.getConnection();
			
			Log.Debug("연말정산 DB접속 완료");
		}catch(Exception e){
			Log.Error("[getConnection Exception] \n"+e); 
		}
		
		return rtnCon;  
	}

	/**
	 * 디비 커넥션 닫기.
	 * @param conn
	 */
	public static synchronized void dbclose(Connection conn){

		if(conn==null){
			return;
		}  
		try {
			if(!conn.isClosed()){
				conn.close();
			}
		} catch (SQLException e) {
			Log.Error("[dbclose Exception] \n"+e); 
		} 

		conn = null;
	}
	
	/**
	 * Connection,PreparedStatement,ResultSet 을 닫는다.
	 * @param con
	 * @param ps
	 * @param rs
	 */
	public static synchronized void closeConnection(Connection con, PreparedStatement ps, ResultSet rs)
	{
	    if(rs != null) {
	        try {
	            rs.close();
	            rs = null;
	            Log.Debug("[closeConnection] rs.close");
	        } catch(Exception e) {
	        	Log.Error("[closeConnection-ResultSet Exception] \n" + e);
	        }
	    }
	    
	    if(ps != null) {
	        try {
	            ps.close();
	            ps = null;
	            Log.Debug("[closeConnection] ps.close");
	        } catch(Exception e) {
	        	Log.Error("[closeConnection-PreparedStatement Exception] \n" + e);
	        }
	    }
	    if(con != null) {
	        try {
	            con.close();
	            con = null;
	            Log.Debug("[closeConnection] con.close");
	        } catch(Exception e) {
	        	Log.Error("[closeConnection-Connection Exception] \n" + e);
	        }
	    }
	}
	
	/**
	 * Connection,CallableStatement,ResultSet 을 닫는다.
	 * @param con
	 * @param ps
	 * @param rs
	 */
	public static synchronized void closeConnection(Connection con, CallableStatement cs, ResultSet rs)
	{
	    if(rs != null) {
	        try {
	            rs.close();
	            rs = null;
	            Log.Debug("[closeConnection] rs.close");
	        } catch(Exception e) {
	        	Log.Error("[closeConnection-ResultSet Exception] \n" + e);
	        }
	    }
	    
	    if(cs != null) {
	        try {
	        	cs.close();
	        	cs = null;
	            Log.Debug("[closeConnection] cs.close");
	        } catch(Exception e) {
	        	Log.Error("[closeConnection-CallableStatement Exception] \n" + e);
	        }
	    }
	    if(con != null) {
	        try {
	            con.close();
	            con = null;
	            Log.Debug("[closeConnection] con.close");
	        } catch(Exception e) {
	        	Log.Error("[closeConnection-Connection Exception] \n" + e);
	        }
	    }
	}	
	
	/**
	 * 쿼리 스티링 과 파라메터를 매핑하여 리턴.
	 * @param query
	 * @param paramMap
	 * @return
	 */
	public static QueryBean getQueryMapping(String query, Map<String,Object> paramMap) throws Exception  {
		String convQuery = query;
		String logQuery = query;
		
		if(convQuery == null || convQuery.trim().length() == 0 ) {
			Log.Debug("쿼리가 null 입니다.");
			throw new Exception("error query null");
		}
		
		if(paramMap == null) {
			Log.Debug("파라메터가 null 입니다.");
			throw new Exception("error paramMap null");
		}
		
		Log.Debug("[queryMapping param] : "+paramMap);
		
		Pattern pattern = Pattern.compile("\\$(.*?)\\$"); 
		Matcher match = pattern.matcher(convQuery);
		
		while(match.find()){
			String strParam = match.group(1);
			String strValue = (String)paramMap.get(match.group(1));
			if(strValue != null) {
				convQuery = convQuery.replaceAll ("\\$"+strParam+"\\$", strValue.replaceAll("[$]", "\\\\\\$"));
				logQuery = logQuery.replaceAll ("\\$"+strParam+"\\$", strValue.replaceAll("[$]", "\\\\\\$") + "	/** param[ "+ strParam + " ] **/");
			}
		} 		
		
		List paramName = new ArrayList();
		List paramValue = new ArrayList();
		
		if(convQuery != null && convQuery.length() > 0) {
			pattern = Pattern.compile("\\#(.*?)\\#"); 
			match = pattern.matcher(convQuery);
			
			while(match.find()){
				String strParam = match.group(1);
				String strValue = ((String)paramMap.get(match.group(1)));
				if(strValue != null) {
					convQuery = convQuery.replaceAll ("\\#"+strParam+"\\#", "?");
					logQuery = logQuery.replaceAll ("\\#"+strParam+"\\#", "'"+strValue.replaceAll("[$]", "\\\\\\$") +"'" + "	/** param[ "+ strParam + " ] **/");
					paramName.add(strParam);
					paramValue.add(strValue);
				}
			}
		}
		
		return new QueryBean(query, convQuery, logQuery, paramName, paramValue);
	}	

	/**
	 * 쿼리맵과 쿼리아이디,파라메터를 입력받아 매핑시킨후 DB조회(리스트형태로 리턴).
	 * @param queryMap
	 * @param queryId
	 * @param param
	 * @return
	 * @throws Exception
	 */
	public static List executeQueryList(Map queryMap, String queryId, Map param) throws Exception {
		
		Connection conn = null;
		PreparedStatement ps = null;
		ResultSet rs = null;
		List rtnList = null;

		try {
			conn = getConnection();

			if(conn != null) {
				rs = executeQueryCommon(conn, ps, queryMap, queryId, param);
				rtnList = ResultSetUtil.getRsToList(rs);
			}
			
		} catch(Exception e) {
			Log.Error("[executeQueryList Exception] \n" + e);
			throw new Exception();
		} finally {
			closeConnection(conn, ps, rs);
		}
		
		return rtnList;
	}
	
	/**
	 * 커넥션 객체,쿼리맵,쿼리아이디,파라메터를 입력받아 DB조회(리스트형태로 리턴).
	 * 사용자가 직접 커넥션을 생성해서 작업할때 사용하며 커넥션은 사용자가 직접 닫아줘야한다.(리스트형태로 리턴)
	 * @param con
	 * @param queryMap
	 * @param queryId
	 * @param param
	 * @return
	 * @throws Exception
	 */
	public static List executeQueryList(Connection con, Map queryMap, String queryId, Map param) throws Exception {
		
		PreparedStatement ps = null;
		ResultSet rs = null;
		List rtnList = null;
		
		try {
			if(con != null) {
				rs = executeQueryCommon(con, ps, queryMap, queryId, param);
				rtnList = ResultSetUtil.getRsToList(rs);
			}
		} catch(Exception e) {
			Log.Error("[executeQueryList Exception] \n" + e);
			throw new Exception(e);
		} finally {
			closeConnection(null, ps, rs);
		}
		
		return rtnList;
	}	
	
	/**
	 * 쿼리맵과 쿼리아이디,파라메터를 입력받아 매핑시킨후 DB조회(맵형태로 리턴).
	 * @param queryMap
	 * @param queryId
	 * @param param
	 * @return
	 */
	public static Map executeQueryMap(Map queryMap, String queryId, Map param) throws Exception {
		
		Connection conn = null;
		PreparedStatement ps = null;
		ResultSet rs = null;
		Map rtnMap = null;
		
		try {
			conn = getConnection();

			if(conn != null) {
				rs = executeQueryCommon(conn, ps, queryMap, queryId, param);
				rtnMap = ResultSetUtil.getRsToMap(rs);
			}
		} catch(Exception e) {
			Log.Error("[executeQueryMap Exception] \n" + e);
			throw new Exception();
		} finally {
			closeConnection(conn, ps, rs);
		}
		
		return rtnMap;
	}

	/**
	 * 커넥션 객체,쿼리맵,쿼리아이디,파라메터를 입력받아 DB조회(맵형태로 리턴).
	 * 사용자가 직접 커넥션을 생성해서 작업할때 사용하며 커넥션은 사용자가 직접 닫아줘야한다.(맵형태로 리턴)
	 * @param con
	 * @param queryMap
	 * @param queryId
	 * @param param
	 * @return
	 * @throws Exception
	 */
	public static Map executeQueryMap(Connection con, Map queryMap, String queryId, Map param) throws Exception {
		
		PreparedStatement ps = null;
		ResultSet rs = null;
		Map rtnMap = null;
		
		try {
			if(con != null) {
				rs = executeQueryCommon(con, ps, queryMap, queryId, param);
				rtnMap = ResultSetUtil.getRsToMap(rs);
			}
		} catch(Exception e) {
			Log.Error("[executeQueryMap Exception] \n" + e);
			throw new Exception(e);
		} finally {
			closeConnection(null, ps, rs);
		}
		
		return rtnMap;
	}	

	/**
	 * executeQueryList, executeQueryMap 조회 시 권한 체크 로직 공통화
	 * @param conn
	 * @param ps
	 * @param rs
	 * @param queryMap
	 * @param queryId
	 * @param param
	 * @return ResultSet
	 * @throws Exception
	 */
	private static ResultSet executeQueryCommon(Connection conn, PreparedStatement ps, Map queryMap, String queryId, Map param) throws Exception {

		ResultSet rs = null;
		
		//쿼리랑 파라메터랑 매핑.
		QueryBean queryBean = getQueryMapping((String)queryMap.get(queryId), param);
		
		Log.Debug("[queryId] : "+queryId);
		Log.Debug(queryBean.getLogQuery());

		if(queryBean != null) {
			//쿼리 실행
			ps = conn.prepareStatement(queryBean.getConvQuery());
			
			for(int i = 0; i < queryBean.getParamName().size(); i++) {
				ps.setString(i+1, queryBean.getParamValue(i));
			}
			
			//권한제약 없이, 전체 자료 조회 (관리자권한에 준함)
			rs = ps.executeQuery();
			
			ResultSetMetaData rsmd = rs.getMetaData();
			String colName = null;
			for(int i=1 ; i < rsmd.getColumnCount()+1; i++){
				colName = colName + "," +rsmd.getColumnName(i);
			}

			String ssnSearchType = (String)param.get("ssnSearchType");
			
			if( colName != null && colName.contains("SABUN") && !("A".equals(ssnSearchType)) ) {
				//조회자료에 sabun 필드가 포함되어 있고(단순 코드셋 등을 조회할 경우는 권한제약할 필요 없음.성능개선.),
				//권한(O 또는 P) 체크가 필요하므로... 위에서 전체로 조회한 자료는 close하고 권한제약하여 재조회
				rs.close();
				ps.close();
				String convQeury = "SELECT RESULT.* FROM (" + queryBean.getConvQuery() + ") RESULT " ;

				String ssnEnterCd    = (String)param.get("ssnEnterCd");
				String ssnSabun      = (String)param.get("ssnSabun");
				String ssnGrpCd      = (String)param.get("ssnGrpCd");
				
				if("P".equals(ssnSearchType)) {
					// select절에 enter_cd가 없는 경우가 많아서 삼항연산
					convQeury = convQeury + " WHERE RESULT.SABUN = '" + ssnSabun + "' " 
					                + (colName.contains("ENTER_CD")?" AND RESULT.ENTER_CD = '" + ssnEnterCd + "' ":"") ;
				} else if("O".equals(ssnSearchType)) {
					Connection authConn = null;
					PreparedStatement authPs = null;
					ResultSet authRs=null;
		
					try{
						authConn = getConnection();
						
						Map rtnMap = null;
						String authQuery = null;
						
						if (authConn != null) {
							authPs = authConn.prepareStatement("SELECT F_COM_GET_SQL_AUTH('"+ssnEnterCd+"'"
									+",''"
									+",'"+ssnSearchType+"'"
									+",'"+ssnSabun+"'"
									+",'"+ssnGrpCd+"'"
									+",'') AS AUTH_QUERY FROM DUAL"
									);
							authRs = authPs.executeQuery();
							rtnMap = ResultSetUtil.getRsToMap(authRs);
							
							authQuery = (String)rtnMap.get("auth_query");
							param.put("AUTH_QUERY",authQuery);
						}
		                else {
							Log.Error("[GET authQueryBean rtnMap Exception] rtnMap is null ");
							throw new Exception();
		                }
		
						// -------------------------------------------------------------------------------------------------------------------
						//원천세 사업자등록 테이블(TCPN903) 체크 추가 20240923 START
						//기본패키지의 [권한범위]를 추가하면 F_COM_GET_SQL_AUTH 내에서 OR 조건이 아닌 AND 조건으로 동작하므로 F_COM_GET_SQL_AUTH_OTAX를 추가함.
						// -------------------------------------------------------------------------------------------------------------------
						try {
							rtnMap = null;
							authQuery = "";
							
							if (authConn != null) {
								authPs = authConn.prepareStatement("SELECT F_COM_GET_SQL_AUTH_OTAX('"+ssnEnterCd+"'"
										+",''"
										+",'"+ssnSearchType+"'"
										+",'"+ssnSabun+"'"
										+",'"+ssnGrpCd+"'"
										+",'') AS AUTH_QUERY FROM DUAL"
										);
								authRs = authPs.executeQuery();
								rtnMap = ResultSetUtil.getRsToMap(authRs);
								
								authQuery = (String)rtnMap.get("auth_query");
							}
							param.put("AUTH_OTAX",authQuery);
						} catch(Exception e) {
							param.put("AUTH_OTAX","");
						}
						// -------------------------------------------------------------------------------------------------------------------
						//원천세 사업자등록 테이블(TCPN903) 체크 추가 20240923 END
						// -------------------------------------------------------------------------------------------------------------------
						
					} catch(Exception e) {
						Log.Error("[GET authQueryBean rtnMap Exception] \n" + e);
						throw new Exception();
					} finally {
						closeConnection(authConn, authPs, authRs);
					}
		
					String authQuery = (String)param.get("AUTH_QUERY");
					String authOtax  = (String)param.get("AUTH_OTAX");
					
					// select절에 enter_cd가 없는 경우가 많아서 삼항연산
					convQeury = convQeury + " LEFT JOIN (" + authQuery + ") AUTH ON AUTH.SABUN = RESULT.SABUN " + ((colName.contains("ENTER_CD"))?" AND AUTH.ENTER_CD = RESULT.ENTER_CD ":"") ;
					convQeury = convQeury + " LEFT JOIN (" + authOtax  + ") AUTHO ON AUTHO.SABUN = RESULT.SABUN " + ((colName.contains("ENTER_CD"))?" AND AUTHO.ENTER_CD = RESULT.ENTER_CD ":"") ;
					convQeury = convQeury + " WHERE NVL(AUTH.SABUN, AUTHO.SABUN) IS NOT NULL " ;						
				} else {
					// 전사조회(A)도 아니고 권한범위적용(O)도 아니고 자신만조회(P)도 아니라면, 파라미터변조로 인식하여 자료를 조회하지 않음.
					return null ;
				}
				
				ps = conn.prepareStatement(convQeury);
				Log.Debug(convQeury);
				
				for(int i = 0; i < queryBean.getParamName().size(); i++) {
					ps.setString(i+1, queryBean.getParamValue(i));
				}
				
				rs = ps.executeQuery();
			}
		}
		
		return rs;
	}
	
	/**
	 * 쿼리맵과 쿼리아이디,파라메터를 입력받아 매핑시킨후 DB수정(수정갯수 리턴).
	 * @param queryMap
	 * @param queryId
	 * @param param
	 * @return
	 */
	public static int executeUpdate(Map queryMap, String queryId, Map param) throws Exception {
		
		Connection conn = null;
		PreparedStatement ps = null;
		int rtnCnt = 0;
		
		try {
			conn = getConnection();
			
			//쿼리랑 파라메터랑 매핑.
			QueryBean queryBean = getQueryMapping((String)queryMap.get(queryId), param);
			
			Log.Debug("[queryId] : "+queryId);
			Log.Debug(queryBean.getLogQuery());
			
			if(conn != null && queryBean != null) {
				conn.setAutoCommit(false);
				//쿼리 실행
				ps = conn.prepareStatement(queryBean.getConvQuery());
				
				for(int i = 0; i < queryBean.getParamName().size(); i++) {
					ps.setString(i+1, queryBean.getParamValue(i));
				}
				rtnCnt = ps.executeUpdate();
				
				conn.commit();
			}
			
		} catch(Exception e) {
			try {
				if (conn != null) conn.rollback();
			} catch (Exception e1) {
				Log.Error("[executeUpdate rollback Exception] \n" + e);
				throw new Exception();
			}
			Log.Error("[executeUpdate Exception] \n" + e);
			throw new Exception();
		} finally {
			closeConnection(conn, ps, null);
		}
		
		return rtnCnt;
	}	
	
	/**
	 * 커넥션 객체,쿼리맵,쿼리아이디,파라메터를 입력받아 DB수정
	 * 사용자가 직접 커넥션을 생성해서 작업할때 사용하며 커넥션은 사용자가 직접 닫아줘야한다.(수정갯수 리턴)
	 * @param con
	 * @param queryMap
	 * @param queryId
	 * @param param
	 * @return
	 * @throws Exception
	 */
	public static int executeUpdate(Connection con, Map queryMap, String queryId, Map param) throws Exception {
		
		PreparedStatement ps = null;
		int rtnCnt = 0;
		
		try {
			
			//쿼리랑 파라메터랑 매핑.
			QueryBean queryBean = getQueryMapping((String)queryMap.get(queryId), param);
			
			Log.Debug("[queryId] : "+queryId);
			Log.Debug(queryBean.getLogQuery());
			
			if(queryBean != null) {
				//쿼리 실행
				ps = con.prepareStatement(queryBean.getConvQuery());
				
				for(int i = 0; i < queryBean.getParamName().size(); i++) {
					ps.setString(i+1, queryBean.getParamValue(i));
				}
			}
			
			rtnCnt = ps.executeUpdate();			

		} catch(Exception e) {
			Log.Error("[executeUpdate Exception] \n" + e);
			throw new Exception(e);
		} finally {
			closeConnection(null, ps, null);
		}
		
		return rtnCnt;
	}	
	
	
    /**
     * db 프로시져 호출.
     * @param procudureName 프로시져이름
     * @param typeList  파라메트 타입정의
     * @param paramList  파라메트 값
     * @return String[] 프로시져 호출 후 결과
     */
    public static String[] executeProcedure(String procudureName, String[] typeList, String[] paramList) throws Exception {
        
    	Connection conn = null;
        CallableStatement cs = null;
        ResultSet rs = null;
        String[] rtnParam = new String[paramList.length];

        
        if(typeList.length != paramList.length ){
        	Log.Error("프로시저 typeList 와 paramList 의 사이즈가 다릅니다.");
        	throw new Exception("error typeList or paramList length error");
        }
        
        try {
        	
        	conn = getConnection();
            String paramString = "";
            String prepareCallString = "";

			for(int i = 0 ; i < typeList.length ; i++){
			    paramString = paramString + "?,";
			}
                
			paramString = paramString.substring(0, paramString.length()-1);
			prepareCallString = "{call "+procudureName+"(" + paramString + ")}";

			Log.Debug("prepareCallString "+prepareCallString);
			
			if (conn != null) {
				cs = conn.prepareCall(prepareCallString);
	            for(int i = 0 ; i < typeList.length ; i++){

	            	if(typeList[i].toUpperCase().equals("OUT")) {
	                	cs.registerOutParameter(i+1, OracleTypes.VARCHAR);
	            	}else if(typeList[i].toUpperCase().equals("INT")){
	            		cs.setInt(i+1, Integer.parseInt(paramList[i]));
	                }else if(typeList[i].toUpperCase().equals("STR")){
	                	cs.setString(i+1, paramList[i]);
	                }else{
	                	Log.Error("프로시져 변수 타입이 다릅니다.");
	                }
	            	Log.Debug("typeList(paramList) =>> "+typeList[i]+" ( "+paramList[i]+" )");
	            }

	            cs.execute();
	            
	            for (int i=0; i < typeList.length; i++) {
	            	if(typeList[i].toUpperCase().equals("OUT")) {
	            		if(cs.getString(i+1) == null || "null".equals(cs.getString(i+1))) {
	                		rtnParam[i] = "";
	            		} else {
	            			rtnParam[i] = cs.getString(i+1);
	            		}
	            	}
	            }
			}
			
			
        } catch(Exception e) {
        	Log.Error("[executeProcedure Exception] \n" + e);
        	throw new Exception(e);
        } finally {
        	closeConnection(conn,cs,rs);
        }
        
        return rtnParam;
    }	
}
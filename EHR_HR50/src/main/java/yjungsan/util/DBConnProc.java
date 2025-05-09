package yjungsan.util;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import javax.naming.Context;
import javax.naming.InitialContext;
import javax.sql.DataSource;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import oracle.jdbc.OracleTypes;

public class DBConnProc {

	private static final Logger log = LoggerFactory.getLogger(DBConnProc.class);

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

			log.debug("연말정산 DB접속 완료");
		}catch(Exception e){
			log.error("[getConnection Exception] \n"+e);
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
			log.error("[dbclose Exception] \n"+e);
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
	            log.debug("[closeConnection] rs.close");
	        } catch(Exception e) {
	        	log.error("[closeConnection-ResultSet Exception] \n" + e);
	        }
	    }

	    if(ps != null) {
	        try {
	            ps.close();
	            ps = null;
	            log.debug("[closeConnection] ps.close");
	        } catch(Exception e) {
	        	log.error("[closeConnection-PreparedStatement Exception] \n" + e);
	        }
	    }
	    if(con != null) {
	        try {
	            con.close();
	            con = null;
	            log.debug("[closeConnection] con.close");
	        } catch(Exception e) {
	        	log.error("[closeConnection-Connection Exception] \n" + e);
	        }
	    }
	}

	/**
	 * Connection,CallableStatement,ResultSet 을 닫는다.
	 * @param con
	 * @param rs
	 */
	public static synchronized void closeConnection(Connection con, CallableStatement cs, ResultSet rs)
	{
	    if(rs != null) {
	        try {
	            rs.close();
	            rs = null;
	            log.debug("[closeConnection] rs.close");
	        } catch(Exception e) {
	        	log.error("[closeConnection-ResultSet Exception] \n" + e);
	        }
	    }

	    if(cs != null) {
	        try {
	        	cs.close();
	        	cs = null;
	            log.debug("[closeConnection] cs.close");
	        } catch(Exception e) {
	        	log.error("[closeConnection-CallableStatement Exception] \n" + e);
	        }
	    }
	    if(con != null) {
	        try {
	            con.close();
	            con = null;
	            log.debug("[closeConnection] con.close");
	        } catch(Exception e) {
	        	log.error("[closeConnection-Connection Exception] \n" + e);
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
			log.debug("쿼리가 null 입니다.");
			throw new Exception("error query null");
		}

		if(paramMap == null) {
			log.debug("파라메터가 null 입니다.");
			throw new Exception("error paramMap null");
		}

		log.debug("[queryMapping param] : "+paramMap);

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
		ResultSet rs=null;
		List rtnList = null;

		try {
			conn = getConnection();

			//쿼리랑 파라메터랑 매핑.
			QueryBean queryBean = getQueryMapping((String)queryMap.get(queryId), param);

			log.debug("[queryId] : "+queryId);
			log.debug(queryBean.getLogQuery());

			if(conn != null && queryBean != null) {
				//쿼리 실행
				ps = conn.prepareStatement(queryBean.getConvQuery());
				if (ps != null) {
					for(int i = 0; i < queryBean.getParamName().size(); i++) {
						ps.setString(i+1, queryBean.getParamValue(i));
					}
					rs = ps.executeQuery();
				}
			}
			rtnList = ResultSetUtil.getRsToList(rs);
		} catch(Exception e) {
			log.error("[executeQueryList Exception] \n" + e);
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
		ResultSet rs=null;
		List rtnList = null;

		try {

			//쿼리랑 파라메터랑 매핑.
			QueryBean queryBean = getQueryMapping((String)queryMap.get(queryId), param);

			log.debug("[queryId] : "+queryId);
			log.debug(queryBean.getLogQuery());

			if(queryBean != null) {
				//쿼리 실행
				ps = con.prepareStatement(queryBean.getConvQuery());

				for(int i = 0; i < queryBean.getParamName().size(); i++) {
					ps.setString(i+1, queryBean.getParamValue(i));
				}
			}

		} catch(Exception e) {
			log.error("[executeQueryList Exception] \n" + e);
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
		ResultSet rs=null;
		Map rtnMap = null;

		try {

			conn = getConnection();

			//쿼리랑 파라메터랑 매핑.
			QueryBean queryBean = getQueryMapping((String)queryMap.get(queryId), param);

			log.debug("[queryId] : "+queryId);
			log.debug(queryBean.getLogQuery());

			if(conn != null && queryBean != null) {
				//쿼리 실행
				ps = conn.prepareStatement(queryBean.getConvQuery());
				if (ps != null) {
					for(int i = 0; i < queryBean.getParamName().size(); i++) {
						ps.setString(i+1, queryBean.getParamValue(i));
					}
				}
				rs = ps.executeQuery();
			}
			
			rtnMap = ResultSetUtil.getRsToMap(rs);

		} catch(Exception e) {
			log.error("[executeQueryMap Exception] \n" + e);
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
		ResultSet rs=null;
		Map rtnMap = null;

		try {

			//쿼리랑 파라메터랑 매핑.
			QueryBean queryBean = getQueryMapping((String)queryMap.get(queryId), param);

			log.debug("[queryId] : "+queryId);
			log.debug(queryBean.getLogQuery());

			if(queryBean != null) {
				//쿼리 실행
				ps = con.prepareStatement(queryBean.getConvQuery());

				for(int i = 0; i < queryBean.getParamName().size(); i++) {
					ps.setString(i+1, queryBean.getParamValue(i));
				}
			}

			rs = ps.executeQuery();
			rtnMap = ResultSetUtil.getRsToMap(rs);

		} catch(Exception e) {
			log.error("[executeQueryMap Exception] \n" + e);
			throw new Exception(e);
		} finally {
			closeConnection(null, ps, rs);
		}

		return rtnMap;
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
			if (conn != null) {
				conn.setAutoCommit(false);

				//쿼리랑 파라메터랑 매핑.
				QueryBean queryBean = getQueryMapping((String)queryMap.get(queryId), param);

				log.debug("[queryId] : "+queryId);
				log.debug(queryBean.getLogQuery());

				if(queryBean != null) {
					//쿼리 실행
					ps = conn.prepareStatement(queryBean.getConvQuery());
					if (ps != null) {
						for(int i = 0; i < queryBean.getParamName().size(); i++) {
							ps.setString(i+1, queryBean.getParamValue(i));
						}
						rtnCnt = ps.executeUpdate();
					}
				}
				conn.commit();
			}
		} catch(Exception e) {
			try {
				if (conn != null) conn.rollback();
			} catch (Exception e1) {
				log.error("[executeUpdate rollback Exception] \n" + e);
				throw new Exception();
			}
			log.error("[executeUpdate Exception] \n" + e);
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

			log.debug("[queryId] : "+queryId);
			log.debug(queryBean.getLogQuery());

			if(queryBean != null) {
				//쿼리 실행
				ps = con.prepareStatement(queryBean.getConvQuery());

				for(int i = 0; i < queryBean.getParamName().size(); i++) {
					ps.setString(i+1, queryBean.getParamValue(i));
				}
			}

			rtnCnt = ps.executeUpdate();

		} catch(Exception e) {
			log.error("[executeUpdate Exception] \n" + e);
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
        	log.error("프로시저 typeList 와 paramList 의 사이즈가 다릅니다.");
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

			log.debug("prepareCallString "+prepareCallString);
			
			if (conn != null) {
				cs = conn.prepareCall(prepareCallString);
				if (cs != null) {
					for(int i = 0 ; i < typeList.length ; i++){

		            	if(typeList[i].toUpperCase().equals("OUT")) {
		                	cs.registerOutParameter(i+1, OracleTypes.VARCHAR);
		            	}else if(typeList[i].toUpperCase().equals("INT")){
		            		cs.setInt(i+1, Integer.parseInt(paramList[i]));
		                }else if(typeList[i].toUpperCase().equals("STR")){
		                	cs.setString(i+1, paramList[i]);
		                }else{
		                	log.error("프로시져 변수 타입이 다릅니다.");
		                }
		            	log.debug("typeList(paramList) =>> "+typeList[i]+" ( "+paramList[i]+" )");
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
			}
        } catch(Exception e) {
        	log.error("[executeProcedure Exception] \n" + e);
        	throw new Exception(e);
        } finally {
        	closeConnection(conn,cs,rs);
        }

        return rtnParam;
    }
}
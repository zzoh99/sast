package com.hr.common.mssql;

import java.io.InputStream;
import java.sql.Connection;
import java.sql.DriverManager;
import java.util.Properties;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;

import com.hr.common.logger.Log;

@Service("MsSqlConnection")  
public class MsSqlConnection {
	
	//mssql 서버 연동 DB 접속 정보
	@Value("${mssql.driver}") private String driver;
	
	/**
	 * MS-SQL Connection 생성
	 * 
	 * @return Connection
	 * @throws Exception
	 */
	public Connection getConn(String name) throws Exception {

		Log.Debug("MS-SQL driver: "+driver);
		Log.Debug("MS-SQL name: "+name);
		
		InputStream is = getClass().getResourceAsStream("/opti.properties");

		Properties props = new Properties();
		try {
			props.load(is);
		}catch (Exception ex) {
			//ex.printStackTrace();
			throw new Exception(ex.toString());
		}
//		String url = props.getProperty("mssql."+name+".url").trim();
//		String id  = props.getProperty("mssql."+name+".id").trim();
//		String pw  = props.getProperty("mssql."+name+".pw").trim();
		String url = props != null && props.getProperty("mssql."+name+".url") != null ? props.getProperty("mssql."+name+".url").trim():"";
		String id  = props != null && props.getProperty("mssql."+name+".id") != null ? props.getProperty("mssql."+name+".id").trim():"";
		String pw  = props != null && props.getProperty("mssql."+name+".pw") != null ? props.getProperty("mssql."+name+".pw").trim():"";

		Log.Debug("MS-SQL url: "+url);
		//Log.Debug("MS-SQL id: "+id);
		//Log.Debug("MS-SQL pw: "+pw);
		
		Connection conn = null;
		
		try {
				Class.forName(driver);
				conn = DriverManager.getConnection(url, id, pw);
				Log.Debug("MS-SQL driver 연결 완료");
			} catch (Exception e) {
				Log.Debug("MS-SQL driver 연결 오류 :"+ e.getMessage());
				Log.Debug(e.getLocalizedMessage());
			}
		return conn;
	}
}

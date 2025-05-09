package yjungsan.util;
import java.sql.ResultSetMetaData;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

public class ResultSetUtil {
	
	private static final Logger log = LoggerFactory.getLogger(ResultSetUtil.class);
	
	/**
	 * ResultSet 을 List 형태로 변환
	 * @param rs
	 * @return
	 */
	public static List getRsToList(ResultSet rs){
    	List list = new ArrayList();

    	try {
            if( rs!= null && rs.next() ){
                do{
                    Map map = new HashMap();
                    ResultSetMetaData rsMD= rs.getMetaData();
                    int rsMDCnt = rsMD.getColumnCount();

                    for( int i = 1; i <= rsMDCnt; i++ ) {
                        String column = rsMD.getColumnName(i).toLowerCase();
                        String value  = rs.getString(column);
                        
                    	if("_level".equals(column)) {
                    		column = "Level";
                    	}
                    	
                        if(value == null) {
                        	value = "";
                        }

                    	map.put(column, value);
                    }

                    list.add(map);
                }while( rs.next() );
            }else{
                list = java.util.Collections.EMPTY_LIST;
            }
        } catch (Exception e) {
            list = null;
        	log.error(String.valueOf(e));
        }

        return list;
    }
	
	/**
	 * ResultSet 을 Map 형태로 변환
	 * @param rs
	 * @return
	 */
	public static Map getRsToMap(ResultSet rs){
    	Map map = new HashMap();

    	try {
            if( rs!= null && rs.next() ){
                ResultSetMetaData rsMD= rs.getMetaData();
                int rsMDCnt = rsMD.getColumnCount();

                for( int i = 1; i <= rsMDCnt; i++ ) {
                	
                    String column = rsMD.getColumnName(i).toLowerCase();
                    String value  = rs.getString(column);

                	if("_level".equals(column)) {
                		column = "Level";
                	}
                	
                    if(value == null) {
                    	value = "";
                    }
                	
                    map.put(column, value);
                }
            }else{
                map = java.util.Collections.EMPTY_MAP;
            }
        } catch (Exception e) {                 
        	map = null;
        	log.error(String.valueOf(e));
        }

        return map;
    }	
}
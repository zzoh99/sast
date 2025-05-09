package com.hr.common.com;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.inject.Inject;
import javax.inject.Named;

import com.hr.common.dao.Dao;
import com.hr.common.exception.HrException;
import com.hr.common.logger.Log;
/**
 * 근무패턴관리 Service
 *
 * @author JSG
 *
 */
@SuppressWarnings("unchecked")
public class ComUtilService {

	@Inject
	@Named("Dao")
	private Dao dao;
	
	public int prcComEdateCreate(Map<?, ?> convertMap, String tableId, String param1,String param2, String param3 ) throws Exception, HrException {
		Log.Debug();
		int cnt=0;

		List<Map<String, Object>> deleteRows = (List<Map<String, Object>>) convertMap.get("deleteRows");
		List<Map<String, Object>> mergeRows = (List<Map<String, Object>>) convertMap.get("mergeRows");
		
		if( deleteRows.size() > 0){
			
			//종료일자(EDATE) 생성
			for(Map<String,Object> mp : deleteRows) {
				Map<String,Object> map = new HashMap<String,Object>();
				map.put("ssnEnterCd",	convertMap.get("ssnEnterCd"));
				map.put("table",		tableId);
				map.put("param1",		mp.get(param1));
				map.put("param2",		( param2 == null )?null:mp.get(param2));
				map.put("param3",		( param3 == null )?null:mp.get(param3));
				
				Map<?, ?> rsMap  = (Map<?, ?>)dao.excute("prcComEdateCreate", map);
				if (rsMap.get("sqlErrm") != null) {
					throw new HrException(rsMap.get("sqlErrm").toString());
				}
				
			}
			
		}
		if( mergeRows.size() > 0){

			//종료일자(EDATE) 생성
			for(Map<String,Object> mp : mergeRows) {
				Map<String,Object> map = new HashMap<String,Object>();
				map.put("ssnEnterCd",	convertMap.get("ssnEnterCd"));
				map.put("table",		tableId);
				map.put("param1",		mp.get(param1));
				map.put("param2",		( param2 == null )?null:mp.get(param2));
				map.put("param3",		( param3 == null )?null:mp.get(param3));

				Map<?, ?> rsMap  = (Map<?, ?>)dao.excute("prcComEdateCreate", map);
				if (rsMap.get("sqlErrm") != null) {
					throw new HrException(rsMap.get("sqlErrm").toString());
				}
			}
		
		}
		Log.Debug("prcComEdateCreate End");
		return cnt;
	}
	

}
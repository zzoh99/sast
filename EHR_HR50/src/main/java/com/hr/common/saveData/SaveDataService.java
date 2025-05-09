package com.hr.common.saveData;
import java.util.List;
import java.util.Map;

import javax.inject.Inject;
import javax.inject.Named;

import org.springframework.stereotype.Service;

import com.hr.common.dao.Dao;
import com.hr.common.logger.Log;

/**
 * SaveData Service
 *
 * @author RYU SIOONG
 *
 */
@Service("SaveDataService")
public class SaveDataService{
	@Inject
	@Named("Dao")
	private Dao dao;

	public int saveData(Map<?, ?> convertMap) throws Exception {
		Log.Debug();

		int cnt=0;
		if( ((List<?>)convertMap.get("deleteRows")).size() > 0){
			String deleteQueryId = convertMap.get("cmd").toString();
			deleteQueryId = deleteQueryId.replace("save","delete");
			cnt += dao.delete(deleteQueryId, convertMap);
		}
		if( ((List<?>)convertMap.get("mergeRows")).size() > 0){
			cnt += dao.update(convertMap.get("cmd").toString(), convertMap);
		}

		return cnt;
	}

	public int saveFormData(Map<String, Object> paramMap) throws Exception {

		String sStatus = (String) paramMap.get("sStatus");

		if ( "D".equals(sStatus)){
			String deleteQueryId = paramMap.get("cmd").toString();
			deleteQueryId = deleteQueryId.replace("save","delete");
			dao.delete(deleteQueryId, paramMap);
		
		} else {
			dao.update(paramMap.get("cmd").toString(), paramMap);
		}
		
		return 1;
		
	}
	
}
package com.hr.tim.month.timeCardUpload;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.inject.Inject;
import javax.inject.Named;

import org.springframework.stereotype.Service;

import com.hr.common.dao.Dao;
import com.hr.common.logger.Log;
/**
 * TimeCard업로드 Service
 * 
 * @author 이름
 *
 */
@Service("TimeCardUploadService")  
public class TimeCardUploadService {
	@Inject
	@Named("Dao")
	private Dao dao;

	/**
	 * TimeCard업로드 저장 Service
	 *
	 * @param convertMap
	 * @return int
	 * @throws Exception
	 */
	public int saveTimeCardUpload(Map<?, ?> convertMap) throws Exception {
		Log.Debug();
		int cnt=0;

		if( ((List<?>)convertMap.get("deleteRows")).size() > 0){
			cnt += dao.delete("deleteTimeCardUpload", convertMap);
		}

		if( ((List<?>)convertMap.get("mergeRows")).size() > 0){
			cnt += dao.update("saveTimeCardUpload", convertMap);
		}

		return cnt;
	}

	/**
	 *  일근무갱신 Service
	 *
	 * @param convertMap
	 * @return int
	 * @throws Exception
	 */
	public void prcTimeCardUpload(Map<?, ?> convertMap) throws Exception {
		Log.Debug();
		int cnt = 1;
		if( ((List<?>)convertMap.get("sabunList")).size() > 0){
			List<Map> list = (List<Map>)convertMap.get("sabunList");
			for ( Map<String, Object> mp : list ){
				
				Map<String,Object> paramMap = new HashMap<String,Object>();
				paramMap.put("ssnEnterCd", convertMap.get("ssnEnterCd"));
				paramMap.put("ssnSabun", convertMap.get("ssnSabun"));
				paramMap.put("searchYmd", convertMap.get("searchYmd"));
				paramMap.put("searchYmd2", convertMap.get("searchYmd2"));
				paramMap.put("sabun", mp.get("sabun"));
				
				Log.Debug(cnt+". SABUN : "+ mp.get("sabun")); cnt++;

				dao.excute("prcTimeCardUpload", paramMap);

			}
		}
	}
}
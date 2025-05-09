package com.hr.pap.progress.appAdjStausMng;
import java.util.List;
import java.util.Map;

import javax.inject.Inject;
import javax.inject.Named;

import org.springframework.stereotype.Service;

import com.hr.common.dao.Dao;
import com.hr.common.logger.Log;
/**
 * 평가진행상태관리 Service
 *
 * @author JCY
 *
 */
@Service("AppAdjStausMngService")
public class AppAdjStausMngService{
	@Inject
	@Named("Dao")
	private Dao dao;


	public Map<?, ?> getBaseYmd(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return dao.getMap("getBaseYmd", paramMap);
	}

	/**
	 * 평가진행상태관리 저장 Service
	 *
	 * @param convertMap
	 * @return int
	 * @throws Exception
	 */
	public int saveAppAdjStausMng2(Map<?, ?> convertMap) throws Exception {
		Log.Debug();
		int cnt=0;

		List<Map> updateList = (List<Map>)convertMap.get("updateRows");

		for(Map<String,Object> mp : updateList) {

			mp.put("ssnEnterCd", convertMap.get("ssnEnterCd"));
			mp.put("ssnSabun", 	convertMap.get("ssnSabun"));

			cnt += dao.update("saveAppAdjStausMng2", mp);
		}

		Log.Debug();
		return cnt;
	}

	/**
	 * 평가진행상태관리 저장 Service
	 *
	 * @param convertMap
	 * @return int
	 * @throws Exception
	 */
	public int saveAppAdjStausMng3(Map<?, ?> convertMap) throws Exception {
		Log.Debug();
		int cnt=0;

		if( ((List<?>)convertMap.get("mergeRows")).size() > 0){
			cnt += dao.update("saveAppAdjStausMng3", convertMap);

			cnt += dao.update("saveAppAdjStausMng4", convertMap);
		}


		Log.Debug();
		return cnt;
	}

	/**
	 * 평가진행상태관리3 > 평가진행상태 및 평가완료여부 저장 Service
	 *
	 * @param convertMap
	 * @return int
	 * @throws Exception
	 */
	public int saveAppAdjStausMng3StatusCdAndAppraisalYn(Map<?, ?> convertMap) throws Exception {
		Log.Debug();
		int cnt=0;

		List<Map> mergeList = (List<Map>) convertMap.get("mergeRows");

		for(Map<String,Object> mp : mergeList) {
			mp.put("ssnEnterCd", convertMap.get("ssnEnterCd"));
			mp.put("ssnSabun", 	convertMap.get("ssnSabun"));

			cnt += dao.update("saveAppAdjStausMng3AppraisalYn", mp);
			cnt += dao.update("saveAppAdjStausMng3StatusCd", mp);
		}

		Log.Debug();
		return cnt;
	}
}
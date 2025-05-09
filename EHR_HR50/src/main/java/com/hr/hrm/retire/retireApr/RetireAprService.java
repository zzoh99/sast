package com.hr.hrm.retire.retireApr;
import java.util.List;
import java.util.Map;

import javax.inject.Inject;
import javax.inject.Named;

import org.springframework.stereotype.Service;

import com.hr.common.dao.Dao;
import com.hr.common.logger.Log;

/**
 * 퇴직원신청현황 Service
 *
 * @author bckim
 *
 */
@Service("RetireAprService")
public class RetireAprService{

	@Inject
	@Named("Dao")
	private Dao dao;

	/**
	 * getRetireAprList 다건 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getRetireAprList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getRetireAprList", paramMap);
	}
	
	/**
	 * 퇴직원신청현황 저장 Service
	 *
	 * @param convertMap
	 * @return int
	 * @throws Exception
	 */
	public int updateRetireApr(Map<?, ?> convertMap) throws Exception {
		Log.Debug();

		List<Map<String,Object>> updateList = (List<Map<String,Object>>)convertMap.get("updateRows");

		int cnt=0;
		if( updateList.size() > 0){
			for(Map<String,Object> mp : updateList) {
				mp.put("ssnEnterCd", convertMap.get("ssnEnterCd") );
				mp.put("ssnSabun", convertMap.get("ssnSabun") );

				cnt += dao.update("updateRetireApr", mp);
			}
		}
		Log.Debug();
		return cnt;
	}


	/**
	 * 퇴직원신청현황 가발령처리 저장 Service
	 *
	 * @param convertMap
	 * @return int
	 * @throws Exception
	 */
	public int saveRetireAprOrd(Map<?, ?> convertMap) throws Exception {
		Log.Debug();
		List<Map<String,Object>> updateList = (List<Map<String,Object>>)convertMap.get("updateRows");

		int cnt=0;
		if( updateList.size() > 0){
			for(Map<String,Object> mp : updateList) {
				mp.put("ssnEnterCd", convertMap.get("ssnEnterCd") );
				mp.put("ssnSabun", convertMap.get("ssnSabun") );

				if("1".equals(mp.get("ibsCheck"))) {
					cnt += dao.create("saveRetireAprOrd", mp);
				}
			}
		}
		Log.Debug();
		return cnt;
	}

}
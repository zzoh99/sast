package com.hr.cpn.basisConfig.payEtcCdStd;
import java.util.List;
import java.util.Map;

import javax.inject.Inject;
import javax.inject.Named;

import org.springframework.stereotype.Service;

import com.hr.common.dao.Dao;
import com.hr.common.logger.Log;

/**
 * payEtcCdStd Service
 *
 * @author EW
 *
 */
@Service("PayEtcCdStdService")
public class PayEtcCdStdService{

	@Inject
	@Named("Dao")
	private Dao dao;

	/**
	 * payEtcCdStd 다건 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getPayEtcCdStdList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getPayEtcCdStdList", paramMap);
	}

	/**
	 * payEtcCdStd 저장 Service
	 *
	 * @param convertMap
	 * @return int
	 * @throws Exception
	 */
	public int savePayEtcCdStd(Map<?, ?> convertMap) throws Exception {
		Log.Debug();
		int cnt=0;
		if( ((List<?>)convertMap.get("deleteRows")).size() > 0){
			cnt += dao.delete("deletePayEtcCdStd", convertMap);
		}
		if( ((List<?>)convertMap.get("mergeRows")).size() > 0){
			cnt += dao.update("savePayEtcCdStd", convertMap);
		}

		return cnt;
	}
	/**
	 * payEtcCdStd 단건 조회 Service
	 *
	 * @param paramMap
	 * @return Map
	 * @throws Exception
	 */
	public Map<?, ?> getPayEtcCdStdMap(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		Map<?, ?> resultMap = dao.getMap("getPayEtcCdStdMap", paramMap);
		Log.Debug();
		return resultMap;
	}
}

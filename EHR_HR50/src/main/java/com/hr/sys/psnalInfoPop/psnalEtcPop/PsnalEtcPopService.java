package com.hr.sys.psnalInfoPop.psnalEtcPop;
import java.util.List;
import java.util.Map;

import javax.inject.Inject;
import javax.inject.Named;

import org.springframework.stereotype.Service;

import com.hr.common.dao.Dao;
import com.hr.common.logger.Log;

/**
 * psnalEtcPop Service
 *
 * @author EW
 *
 */
@Service("PsnalEtcPopService")
public class PsnalEtcPopService{

	@Inject
	@Named("Dao")
	private Dao dao;

	/**
	 * psnalEtcPop 다건 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getPsnalEtcPopList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getPsnalEtcPopList", paramMap);
	}

	/**
	 * psnalEtcPop 저장 Service
	 *
	 * @param convertMap
	 * @return int
	 * @throws Exception
	 */
	public int savePsnalEtcPop(Map<?, ?> convertMap) throws Exception {
		Log.Debug();
		int cnt=0;
		if( ((List<?>)convertMap.get("deleteRows")).size() > 0){
			cnt += dao.delete("deletePsnalEtcPop", convertMap);
		}
		if( ((List<?>)convertMap.get("mergeRows")).size() > 0){
			cnt += dao.update("savePsnalEtcPop", convertMap);
		}

		return cnt;
	}
	/**
	 * psnalEtcPop 단건 조회 Service
	 *
	 * @param paramMap
	 * @return Map
	 * @throws Exception
	 */
	public Map<?, ?> getPsnalEtcPopMap(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		Map<?, ?> resultMap = dao.getMap("getPsnalEtcPopMap", paramMap);
		Log.Debug();
		return resultMap;
	}
}

package com.hr.sys.psnalInfoPop.psnalWelfarePop;
import java.util.List;
import java.util.Map;

import javax.inject.Inject;
import javax.inject.Named;

import org.springframework.stereotype.Service;

import com.hr.common.dao.Dao;
import com.hr.common.logger.Log;

/**
 * psnalWelfarePop Service
 *
 * @author EW
 *
 */
@Service("PsnalWelfarePopService")
public class PsnalWelfarePopService{

	@Inject
	@Named("Dao")
	private Dao dao;

	/**
	 * psnalWelfarePop 다건 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getPsnalWelfarePopList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getPsnalWelfarePopList", paramMap);
	}

	/**
	 * psnalWelfarePop 저장 Service
	 *
	 * @param convertMap
	 * @return int
	 * @throws Exception
	 */
	public int savePsnalWelfarePop(Map<?, ?> convertMap) throws Exception {
		Log.Debug();
		int cnt=0;
		if( ((List<?>)convertMap.get("deleteRows")).size() > 0){
			cnt += dao.delete("deletePsnalWelfarePop", convertMap);
		}
		if( ((List<?>)convertMap.get("mergeRows")).size() > 0){
			cnt += dao.update("savePsnalWelfarePop", convertMap);
		}

		return cnt;
	}
	/**
	 * psnalWelfarePop 단건 조회 Service
	 *
	 * @param paramMap
	 * @return Map
	 * @throws Exception
	 */
	public Map<?, ?> getPsnalWelfarePopMap(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		Map<?, ?> resultMap = dao.getMap("getPsnalWelfarePopMap", paramMap);
		Log.Debug();
		return resultMap;
	}
}

package com.hr.sys.psnalInfoPop.psnalJusticePop;
import java.util.List;
import java.util.Map;

import javax.inject.Inject;
import javax.inject.Named;

import org.springframework.stereotype.Service;

import com.hr.common.dao.Dao;
import com.hr.common.logger.Log;

/**
 * psnalJusticePop Service
 *
 * @author EW
 *
 */
@Service("PsnalJusticePopService")
public class PsnalJusticePopService{

	@Inject
	@Named("Dao")
	private Dao dao;

	/**
	 * psnalJusticePop 다건 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getPsnalJusticePopList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getPsnalJusticePopList", paramMap);
	}

	/**
	 * psnalJusticePop 저장 Service
	 *
	 * @param convertMap
	 * @return int
	 * @throws Exception
	 */
	public int savePsnalJusticePop(Map<?, ?> convertMap) throws Exception {
		Log.Debug();
		int cnt=0;
		if( ((List<?>)convertMap.get("deleteRows")).size() > 0){
			cnt += dao.delete("deletePsnalJusticePop", convertMap);
		}
		if( ((List<?>)convertMap.get("mergeRows")).size() > 0){
			cnt += dao.update("savePsnalJusticePop", convertMap);
		}

		return cnt;
	}
	/**
	 * psnalJusticePop 단건 조회 Service
	 *
	 * @param paramMap
	 * @return Map
	 * @throws Exception
	 */
	public Map<?, ?> getPsnalJusticePopMap(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		Map<?, ?> resultMap = dao.getMap("getPsnalJusticePopMap", paramMap);
		Log.Debug();
		return resultMap;
	}
}

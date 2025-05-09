package com.hr.hri.applyApproval.appAfterLst;
import java.util.List;
import java.util.Map;

import javax.inject.Inject;
import javax.inject.Named;

import org.springframework.stereotype.Service;

import com.hr.common.dao.Dao;
import com.hr.common.logger.Log;

/**
 * appAfterLst Service
 *
 * @author EW
 *
 */
@Service("AppAfterLstService")
public class AppAfterLstService{

	@Inject
	@Named("Dao")
	private Dao dao;

	/**
	 * appAfterLst 다건 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getAppAfterLstList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getAppAfterLstList", paramMap);
	}

	/**
	 * appAfterLst 저장 Service
	 *
	 * @param convertMap
	 * @return int
	 * @throws Exception
	 */
	public int saveAppAfterLst(Map<?, ?> convertMap) throws Exception {
		Log.Debug();
		int cnt=0;
		if( ((List<?>)convertMap.get("deleteRows")).size() > 0){
			cnt += dao.delete("deleteAppAfterLst", convertMap);
		}
		if( ((List<?>)convertMap.get("mergeRows")).size() > 0){
			cnt += dao.update("saveAppAfterLst", convertMap);
		}

		return cnt;
	}
	/**
	 * appAfterLst 단건 조회 Service
	 *
	 * @param paramMap
	 * @return Map
	 * @throws Exception
	 */
	public Map<?, ?> getAppAfterLstMap(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		Map<?, ?> resultMap = dao.getMap("getAppAfterLstMap", paramMap);
		Log.Debug();
		return resultMap;
	}
}

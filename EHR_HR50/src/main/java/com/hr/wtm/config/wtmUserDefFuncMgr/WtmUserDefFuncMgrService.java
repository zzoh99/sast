package com.hr.wtm.config.wtmUserDefFuncMgr;

import com.hr.common.dao.Dao;
import com.hr.common.logger.Log;
import org.springframework.stereotype.Service;

import javax.inject.Inject;
import javax.inject.Named;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

/**
 * 사용자정의함수 Service
 * 
 * @author 이름
 *
 */
@Service("WtmUserDefFuncMgrService")
public class WtmUserDefFuncMgrService {

	@Inject
	@Named("Dao")
	private Dao dao;

	/**
	 * 사용자정의함수 Master 다건 조회 Service
	 * 
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getWtmUserDefFuncMgrFirstList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getWtmUserDefFuncMgrFirstList", paramMap);
	}	
	
	/**
	 * 사용자정의함수 Detail 다건 조회 Service
	 * 
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getWtmUserDefFuncMgrSecondList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getWtmUserDefFuncMgrSecondList", paramMap);
	}

	/**
	 * 항목링크(계산식) 저장 Service
	 * 
	 * @param convertMap
	 * @return int
	 * @throws Exception
	 */
	public int saveWtmUserDefFuncMgrFirst(Map<String, Object> convertMap) throws Exception {
		Log.Debug();

		int cnt = 0;
		if ( ((List<?>)convertMap.get("deleteRows")).size() > 0) {
			cnt += dao.delete("deleteWtmUserDefFuncMgrSecond2", convertMap);
			cnt += dao.delete("deleteWtmUserDefFuncMgrFirst", convertMap);
		}

		if (convertMap.containsKey("mergeRows") && convertMap.get("mergeRows") instanceof List) {
			List<Map<String, Object>> mergeRows = (List<Map<String, Object>>) convertMap.get("mergeRows");
			if (!mergeRows.isEmpty()) {
				List<Map<String, Object>> mRows = mergeRows.stream().map(map -> {
					Map<String, Object> tmpMap = new HashMap<>(map);
					tmpMap.put("bizCd", "WTM");
					return tmpMap;
				}).collect(Collectors.toList());
				convertMap.put("mergeRows", mRows);
				cnt += dao.update("saveWtmUserDefFuncMgrFirst", convertMap);
			}
		}
		Log.Debug();
		return cnt;
	}
	
	/**
	 * 항목링크(계산식) 저장 Service
	 * 
	 * @param convertMap
	 * @return int
	 * @throws Exception
	 */
	public int saveWtmUserDefFuncMgrSecond(Map<?, ?> convertMap) throws Exception {
		Log.Debug();
		int cnt=0;
		if( ((List<?>)convertMap.get("deleteRows")).size() > 0){
			cnt += dao.delete("deleteWtmUserDefFuncMgrSecond", convertMap);
		}
		if( ((List<?>)convertMap.get("mergeRows")).size() > 0){
			cnt += dao.update("saveWtmUserDefFuncMgrSecond", convertMap);
		}
		Log.Debug();
		return cnt;
	}
	


}
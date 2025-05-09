package com.hr.hrm.psnalInfo.psnalPost;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

import javax.inject.Inject;
import javax.inject.Named;

import org.springframework.stereotype.Service;

import com.hr.common.dao.Dao;
import com.hr.common.logger.Log;

/**
 * psnalPost Service
 *
 * @author EW
 *
 */
@Service("PsnalPostService")
public class PsnalPostService{

	@Inject
	@Named("Dao")
	private Dao dao;

	/**
	 * psnalPost 다건 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getPsnalPostList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getPsnalPostList", paramMap);
	}

	/**
	 * psnalPost 저장 Service
	 *
	 * @param convertMap
	 * @return int
	 * @throws Exception
	 */
	public int savePsnalPost(Map<?, ?> convertMap) throws Exception {
		Log.Debug();
		int cnt=0;
		if( ((List<?>)convertMap.get("deleteRows")).size() > 0){
			cnt += dao.delete("deletePsnalPost", convertMap);
		}
		if( ((List<?>)convertMap.get("mergeRows")).size() > 0){
			cnt += dao.update("savePsnalPost", convertMap);
		}

		return cnt;
	}
	/**
	 * psnalPost 단건 조회 Service
	 *
	 * @param paramMap
	 * @return Map
	 * @throws Exception
	 */
	public Map<?, ?> getPsnalPostMap(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		Map<?, ?> resultMap = dao.getMap("getPsnalPostMap", paramMap);
		Log.Debug();
		return resultMap;
	}
	
	/**
	 * getPsnalPostPop 단건 조회 Service
	 *
	 * @param paramMap
	 * @return Map
	 * @throws Exception
	 */
	public Map<?, ?> getPsnalPostPop(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		Map<?, ?> resultMap = dao.getMap("getPsnalPostPop", paramMap);
		Log.Debug();
		return resultMap;
	}

	/**
	 * 발령항목매핑관리 다건 조회 Service
	 * 해당 항목 조회 시 dContent 는 제외하고 보여준다.
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getAppmtItemMapMgrList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		List<Map<String, Object>> list = (List<Map<String, Object>>) dao.getList("getAppmtItemMapMgrList", paramMap);
		return list.stream().map(map -> {
			Map<String, Object> reMap = new HashMap<>(map);
			reMap.remove("dContent");
			return reMap;
		}).collect(Collectors.toList());
	}
}

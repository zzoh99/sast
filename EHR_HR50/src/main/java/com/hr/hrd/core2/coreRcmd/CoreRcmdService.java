package com.hr.hrd.core2.coreRcmd;

import com.hr.common.dao.Dao;
import com.hr.common.logger.Log;
import com.hr.common.util.StringUtil;
import org.springframework.stereotype.Service;

import javax.inject.Inject;
import javax.inject.Named;
import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * 핵심인재후보추천 Service
 *
 * @author JSG
 *
 */
@Service("CoreRcmdService")
public class CoreRcmdService {
	@Inject
	@Named("Dao")
	private Dao dao;

	/**
	 *  검색 Layer 다건 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getCoreRcmdLayerList(Map<?, ?> paramMap) throws Exception {
		Log.Debug("getCoreRcmdLayerList");
		return (List<?>) dao.getList("getCoreRcmdLayerList", paramMap);
	}

	/**
	 *  인재탐색/비교 다건 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getCoreRcmdList(Map<?, ?> paramMap) throws Exception {
		Log.Debug("getCoreRcmdList");
		return (List<?>) dao.getList("getCoreRcmdList", paramMap);
	}

	/**
	 * 핵심인재 선발조직 다건조회
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getCoreRcmdOrgList(Map<?, ?> paramMap) throws Exception {
		Log.Debug("getCoreRcmdOrgList");
		return (List<?>) dao.getList("getCoreRcmdOrgList", paramMap);
	}

	/**
	 *  핵심인재후보추천 저장 Service
	 *
	 * @param convertMap
	 * @return int
	 * @throws Exception
	 */
	public int saveCoreRcmd(Map<?, ?> convertMap) throws Exception {
		Log.Debug();
		int cnt=0;
		if( ((List<?>)convertMap.get("mergeRows")).size() > 0){
			cnt += dao.update("saveCoreRcmd", convertMap);
		}
		return cnt;
	}
}
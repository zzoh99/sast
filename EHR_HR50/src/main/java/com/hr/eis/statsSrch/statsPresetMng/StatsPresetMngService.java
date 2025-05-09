package com.hr.eis.statsSrch.statsPresetMng;

import java.util.List;
import java.util.Map;

import javax.inject.Inject;
import javax.inject.Named;

import org.springframework.stereotype.Service;

import com.hr.common.dao.Dao;
import com.hr.common.logger.Log;

/**
 * 통계그래프 > 통계구성 Service
 * @author gjyoo
 *
 */
@Service("StatsPresetMngService")
public class StatsPresetMngService {
	@Inject
	@Named("Dao")
	private Dao dao;
	
	/**
	 * 권한그룹별 통계구성 저장 
	 * @param convertMap
	 * @return
	 * @throws Exception
	 */
	public int saveStatsPresetMng(Map<?, ?> convertMap) throws Exception {
		Log.Debug();
		int cnt = 0; 
		if( ((List<?>)convertMap.get("deleteRows")).size() > 0){
			dao.delete("deleteStatsPresetMngUseList", convertMap);
			cnt += dao.delete("deleteStatsPresetMng", convertMap);
		}
		if( ((List<?>)convertMap.get("mergeRows")).size() > 0){
			cnt += dao.update("saveStatsPresetMng", convertMap);
		}
		return cnt;
	}

	
	/**
	 * 사용 통계 목록 저장 
	 * @param convertMap
	 * @return
	 * @throws Exception
	 */
	public int saveStatsPresetMngUseItem(Map<?, ?> convertMap) throws Exception {
		Log.Debug();
		int cnt = 0; 
		if( ((List<?>)convertMap.get("mergeRows")).size() > 0){
			dao.delete("deleteStatsPresetMngUseItemAll", convertMap);
			cnt += dao.update("saveStatsPresetMngUseItem", convertMap);
		}
		return cnt;
	}
	
	/**
	 * 사용 통계 차트 상세 목록 조회
	 * @param paramMap
	 * @return
	 * @throws Exception
	 */
	public List<?> getStatsPresetMngUseItemDtlDataList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getStatsPresetMngUseItemDtlDataList", paramMap);
	}
}

package com.hr.sys.research.researchResultLst;
import java.util.List;
import java.util.Map;

import javax.inject.Inject;
import javax.inject.Named;

import org.springframework.stereotype.Service;

import com.hr.common.dao.Dao;
import com.hr.common.logger.Log;

/**
 * researchResultLst Service
 *
 * @author EW
 *
 */
@Service("ResearchResultLstService")
public class ResearchResultLstService{

	@Inject
	@Named("Dao")
	private Dao dao;

	/**
	 * researchResultLst 다건 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getResearchResultLstList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getResearchResultLstList", paramMap);
	}

	/**
	 * researchResultLst 저장 Service
	 *
	 * @param convertMap
	 * @return int
	 * @throws Exception
	 */
	public int saveResearchResultLst(Map<?, ?> convertMap) throws Exception {
		Log.Debug();
		int cnt=0;
		if( ((List<?>)convertMap.get("deleteRows")).size() > 0){
			cnt += dao.delete("deleteResearchResultLst", convertMap);
		}
		if( ((List<?>)convertMap.get("mergeRows")).size() > 0){
			cnt += dao.update("saveResearchResultLst", convertMap);
		}

		return cnt;
	}
	/**
	 * researchResultLst 단건 조회 Service
	 *
	 * @param paramMap
	 * @return Map
	 * @throws Exception
	 */
	public Map<?, ?> getResearchResultLstMap(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		Map<?, ?> resultMap = dao.getMap("getResearchResultLstMap", paramMap);
		Log.Debug();
		return resultMap;
	}
	
	/**
	 * 설문 질문 조회 Serivce
	 * 
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getResearchResultLstQuestionList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>)dao.getList("getResearchResultLstQuestionList", paramMap);
	}
	
	/**
	 * 설문지 조회 Serivce
	 * 
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getResearchResultLstResearchList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>)dao.getList("getResearchResultLstResearchList", paramMap);
	}
	
}

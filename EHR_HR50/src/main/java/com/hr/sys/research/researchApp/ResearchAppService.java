package com.hr.sys.research.researchApp;

import java.util.List;
import java.util.Map;
import javax.inject.Inject;
import javax.inject.Named;
import org.springframework.stereotype.Service;
import com.hr.common.dao.Dao;
import com.hr.common.logger.Log;

@Service("ResearchAppService") 
public class ResearchAppService{
 
	@Inject
	@Named("Dao")
	private Dao dao;
	
	/**
	 * 설문조사참여 조회 Serivce
	 * 
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getResearchAppList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>)dao.getList("getResearchAppList", paramMap);
	}
	/**
	 * 설문조사참여 질문 조회 Serivce
	 * 
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getResearchAppQuestionList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>)dao.getList("getResearchAppQuestionList", paramMap);
	}


	public List<?> getResearchAppQuestionFormList(Map<String, Object> paramMap) throws Exception {
		Log.Debug();
		return (List<?>)dao.getList("getResearchAppQuestionFormList", paramMap);
	}
	
	
	/**
	 * 설문조사참여 질문 조회 Serivce
	 * 
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getResearchAppWriteList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>)dao.getList("getResearchAppWriteList", paramMap);
	}
	
	/**
	 * 설문조사참여 결과 선택 중복 조회 Serivce
	 * 
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getResearchAppQuestionResultList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>)dao.getList("getResearchAppQuestionResultList", paramMap);
	}
	/**
	 * 설문조사참여 결과 서술 조회 Serivce
	 * 
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getResearchAppQuestionResultDescList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>)dao.getList("getResearchAppQuestionResultDescList", paramMap);
	}
	/**
	 * 설문조사참여 저장 Serivce
	 * 
	 * @param convertMap
	 * @return
	 * @throws Exception
	 */
	public int saveResearchAppWrite(Map<?, ?> convertMap) throws Exception {
		Log.Debug();
		int cnt = 0;
		if( ((List<?>)convertMap.get("mergeRows")).size() > 0){
			cnt += dao.update("saveResearchAppWrite", convertMap);
		}
		Log.Debug();
		return cnt;
	}

	/**
	 * 설문조사참여 Form형 저장 Serivce
	 *
	 * @param convertMap
	 * @return
	 * @throws Exception
	 */
	public int saveResearchAppWriteForm(Map<?, ?> convertMap) throws Exception {
		Log.Debug();
		dao.delete("deleteResearchAppWrite", convertMap);
		int cnt=dao.update("saveResearchAppWrite", convertMap);
		Log.Debug();
		return cnt;
	}

}
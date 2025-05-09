package com.hr.tra.outcome.eduSurveryLst;
import java.util.List;
import java.util.Map;

import javax.inject.Inject;
import javax.inject.Named;

import org.springframework.stereotype.Service;

import com.hr.common.dao.Dao;
import com.hr.common.logger.Log;
/**
 * 만족도조사 Service
 *
 * @author JSG
 *
 */
@Service("EduSurveryLstService")
public class EduSurveryLstService{
	@Inject
	@Named("Dao")
	private Dao dao;
	/**
	 * 만족도조사 다건 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getEduSurveryLstList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getEduSurveryLstList", paramMap);
	}
	/**
	 * 만족도조사 다건  조회 Popup Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getEduSurveryPopupList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getEduSurveryPopupList", paramMap);
	}
	/**
	 *  만족도조사POPUP MEMO 단건 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public Map<?,?> getEduSurveryPopupMemo(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return dao.getMap("getEduSurveryPopupMemo", paramMap);
	}
	
	
	/**
	 * 만족도조사 저장 Service
	 *
	 * @param convertMap
	 * @return int
	 * @throws Exception
	 */
	public int saveEduSurveryLst(Map<?, ?> convertMap) throws Exception {
		Log.DebugStart();
		int cnt=0;
		if( ((List<?>)convertMap.get("mergeRows")).size() > 0){
			cnt += dao.update("saveEduSurveryLst", convertMap);
		}
		Log.Debug(convertMap.toString());
		cnt += dao.update("saveEduSurveryPopupMemo", convertMap);
		
		String eduSurveyYn = String.valueOf(convertMap.get("eduSurveyYn"));
		Log.Debug("eduSurveyYn:"+eduSurveyYn);
		if( eduSurveyYn != null && !"".equals(eduSurveyYn) && "Y".equals(eduSurveyYn) ){
			cnt += dao.update("saveEduSurveryPopupYn", convertMap); //설문조사 완료
		}
		
		
		Log.DebugEnd();
		return cnt;
	}
}
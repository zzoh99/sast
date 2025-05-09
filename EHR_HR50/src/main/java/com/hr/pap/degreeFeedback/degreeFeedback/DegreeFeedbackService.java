package com.hr.pap.degreeFeedback.degreeFeedback;

import com.hr.common.dao.Dao;
import com.hr.common.logger.Log;
import org.springframework.stereotype.Service;

import javax.inject.Inject;
import javax.inject.Named;
import java.util.List;
import java.util.Map;
/**
 * 다면평가 Service
 *
 * @author kwook
 *
 */
@Service("DegreeFeedbackService")
public class DegreeFeedbackService {

	@Inject
	@Named("Dao")
	private Dao dao;

	/**
	 * 다면평가 다건 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getDegreeFeedbackList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getDegreeFeedbackList", paramMap);
	}
	
	/**
	 * 다면평가 저장
	 *
	 * @param convertMap
	 * @return int
	 * @throws Exception
	 */
	public int saveDegreeFeedback(Map<?, ?> convertMap) throws Exception {
		Log.Debug();
		int cnt=0;
		if( ((List<?>)convertMap.get("mergeRows")).size() > 0){
			cnt += dao.update("saveDegreeFeedback", convertMap);
		}
		Log.Debug();
		return cnt;
	}
}
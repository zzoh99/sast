package com.hr.pap.degreeFeedback.degreeFeedbackResult;

import com.hr.common.dao.Dao;
import com.hr.common.logger.Log;
import org.springframework.stereotype.Service;

import javax.inject.Inject;
import javax.inject.Named;
import java.util.List;
import java.util.Map;
/**
 * 다면평가결과조회 Service
 * 
 * @author JCY
 *
 */
@Service("DegreeFeedbackResultService")
public class DegreeFeedbackResultService {

	@Inject
	@Named("Dao")
	private Dao dao;
	
	/**
	 * 다면평가결과조회 다건 조회 Service
	 * 
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getDegreeFeedbackResultList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getDegreeFeedbackResultList", paramMap);
	}
}
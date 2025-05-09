package com.hr.pap.appCompetency.compAppResult;
import java.util.List;
import java.util.Map;
import javax.inject.Inject;
import javax.inject.Named;
import org.springframework.stereotype.Service;
import com.hr.common.dao.Dao;
import com.hr.common.logger.Log;
/**
 * 다면평가결과조회 Service
 * 
 * @author JCY
 *
 */
@Service("CompAppResultService")
public class CompAppResultService{
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
	public List<?> getCompAppResultList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getCompAppResultList", paramMap);
	}	

	/**
	 * 다면평가결과조회 상세팝업 다건 조회 Service
	 * 
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getCompAppResultDtlList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getCompAppResultDtlList", paramMap);
	}
}
package com.hr.pap.evaluation.mboCoachingApr;
import java.util.List;
import java.util.Map;
import javax.inject.Inject;
import javax.inject.Named;
import org.springframework.stereotype.Service;
import com.hr.common.dao.Dao;
import com.hr.common.logger.Log;
/**
 * 목표합의서코칭 Service
 *
 * @author JCY
 *
 */
@Service("MboCoachingAprService")
public class MboCoachingAprService{
	@Inject
	@Named("Dao")
	private Dao dao;
	/**
	 * 목표합의서코칭 다건 조회 - 피평가자 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getMboCoachingAprList1(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getMboCoachingAprList1", paramMap);
	}

	/**
	 * 목표합의서코칭 다건 조회 - 목표합의서 승인 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getMboCoachingAprList2(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getMboCoachingAprList2", paramMap);
	}



	/**
	 *  목표합의서코칭 단건 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public Map<?, ?> getMboCoachingAprMap(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return dao.getMap("getMboCoachingAprMap", paramMap);
	}
	/**
	 * 목표합의서코칭 저장 Service
	 *
	 * @param convertMap
	 * @return int
	 * @throws Exception
	 */
	public int saveMboCoachingApr(Map<?, ?> convertMap) throws Exception {
		Log.Debug();
		int cnt=0;
		if( ((List<?>)convertMap.get("deleteRows")).size() > 0){
			cnt += dao.delete("deleteMboCoachingApr", convertMap);
		}
		if( ((List<?>)convertMap.get("mergeRows")).size() > 0){
			cnt += dao.update("saveMboCoachingApr", convertMap);
		}
		Log.Debug();
		return cnt;
	}


}
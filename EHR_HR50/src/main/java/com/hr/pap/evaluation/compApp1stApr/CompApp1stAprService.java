package com.hr.pap.evaluation.compApp1stApr;
import java.util.List;
import java.util.Map;
import javax.inject.Inject;
import javax.inject.Named;
import org.springframework.stereotype.Service;
import com.hr.common.dao.Dao;
import com.hr.common.logger.Log;
/**
 * 1차평가 Service
 *
 * @author JCY
 *
 */
@Service("CompApp1stAprService")
public class CompApp1stAprService{
	@Inject
	@Named("Dao")
	private Dao dao;
	/**
	 * 1차평가 -피평가자- 다건 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getCompApp1stAprList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getCompApp1stAprList", paramMap);
	}

	/**
	 * 1차평가 -역량평가- 다건 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getCompApp1stAprList2(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getCompApp1stAprList2", paramMap);
	}


	/**
	 *  1차평가 단건 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public Map<?, ?> getCompApp1stAprMap(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return dao.getMap("getCompApp1stAprMap", paramMap);
	}
	/**
	 * 1차평가 -확정- 저장 Service
	 *
	 * @param convertMap
	 * @return int
	 * @throws Exception
	 */
	public int saveCompApp1stApr1(Map<?, ?> convertMap) throws Exception {
		Log.Debug();
		int cnt=0;
		if( ((List<?>)convertMap.get("mergeRows")).size() > 0){
			cnt += dao.update("saveCompApp1stApr1", convertMap);
		}
		Log.Debug();
		return cnt;
	}


	/**
	 * 1차평가  -평가- 저장 Service
	 *
	 * @param convertMap
	 * @return int
	 * @throws Exception
	 */
	public int saveCompApp1stApr3(Map<?, ?> convertMap) throws Exception {
		Log.Debug();
		int cnt=0;
		if( ((List<?>)convertMap.get("mergeRows")).size() > 0){
			cnt += dao.update("saveCompApp1stApr3", convertMap);
		}
		Log.Debug();
		return cnt;
	}


	/**
	 * 1차평가 -역량평가- 저장 Service
	 *
	 * @param convertMap
	 * @return int
	 * @throws Exception
	 */
	public int saveCompApp1stApr2(Map<?, ?> convertMap) throws Exception {
		Log.Debug();
		int cnt=0;
		if( ((List<?>)convertMap.get("deleteRows")).size() > 0){
			cnt += dao.delete("deleteCompApp1stApr2", convertMap);
		}
		if( ((List<?>)convertMap.get("mergeRows")).size() > 0){
			cnt += dao.update("saveCompApp1stApr2", convertMap);
		}
		Log.Debug();
		return cnt;
	}


}
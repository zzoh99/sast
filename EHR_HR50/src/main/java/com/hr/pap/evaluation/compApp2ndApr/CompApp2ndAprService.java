package com.hr.pap.evaluation.compApp2ndApr;
import java.util.List;
import java.util.Map;
import javax.inject.Inject;
import javax.inject.Named;
import org.springframework.stereotype.Service;
import com.hr.common.dao.Dao;
import com.hr.common.logger.Log;
/**
 * 2차평가 Service
 *
 * @author JCY
 *
 */
@Service("CompApp2ndAprService")
public class CompApp2ndAprService{
	@Inject
	@Named("Dao")
	private Dao dao;
	/**
	 * 2차평가 다건 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getCompApp2ndAprList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getCompApp2ndAprList", paramMap);
	}
	/**
	 *  2차평가 단건 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public Map<?, ?> getCompApp2ndAprMap(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return dao.getMap("getCompApp2ndAprMap", paramMap);
	}
	/**
	 * 2차평가 저장 Service
	 *
	 * @param convertMap
	 * @return int
	 * @throws Exception
	 */
	public int saveCompApp2ndApr(Map<?, ?> convertMap) throws Exception {
		Log.Debug();
		int cnt=0;
		if( ((List<?>)convertMap.get("deleteRows")).size() > 0){
			cnt += dao.delete("deleteCompApp2ndApr", convertMap);
		}
		if( ((List<?>)convertMap.get("mergeRows")).size() > 0){
			cnt += dao.update("saveCompApp2ndApr", convertMap);
		}
		Log.Debug();
		return cnt;
	}

	/**
	 * 2차평가 저장 Service
	 *
	 * @param convertMap
	 * @return int
	 * @throws Exception
	 */
	public int saveCompApp2ndAprReturn(Map<?, ?> convertMap) throws Exception {
		Log.Debug();
		int cnt=0;

		if( ((List<?>)convertMap.get("mergeRows")).size() > 0){
			cnt += dao.update("saveCompApp2ndAprReturn1", convertMap);
		}
		if( ((List<?>)convertMap.get("mergeRows")).size() > 0){
			cnt += dao.update("saveCompApp2ndAprReturn2", convertMap);
		}
		Log.Debug();
		return cnt;
	}

}
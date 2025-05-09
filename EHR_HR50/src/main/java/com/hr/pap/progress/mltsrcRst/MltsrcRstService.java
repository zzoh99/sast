package com.hr.pap.progress.mltsrcRst;
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
@Service("MltsrcRstService")  
public class MltsrcRstService{
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
	public List<?> getMltsrcRstList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getMltsrcRstList", paramMap);
	}	
	/**
	 *  다면평가결과조회 단건 조회 Service 
	 * 
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public Map<?, ?> getMltsrcRstMap(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return dao.getMap("getMltsrcRstMap", paramMap);
	}
	/**
	 * 다면평가결과조회 저장 Service
	 * 
	 * @param convertMap
	 * @return int
	 * @throws Exception
	 */
	public int saveMltsrcRst(Map<?, ?> convertMap) throws Exception {
		Log.Debug();
		int cnt=0;
		if( ((List<?>)convertMap.get("deleteRows")).size() > 0){
			cnt += dao.delete("deleteMltsrcRst", convertMap);
		}
		if( ((List<?>)convertMap.get("mergeRows")).size() > 0){
			cnt += dao.update("saveMltsrcRst", convertMap);
		}
		Log.Debug();
		return cnt;
	}


}
package com.hr.pap.evaluation.mltsrcEvltSbj;
import java.util.List;
import java.util.Map;
import javax.inject.Inject;
import javax.inject.Named;
import org.springframework.stereotype.Service;
import com.hr.common.dao.Dao;
import com.hr.common.logger.Log;
/**
 * 다면평가 대상자 리스트 Service
 * 
 * @author JCY
 *
 */
@Service("MltsrcEvltSbjtService")  
public class MltsrcEvltSbjtService{
	@Inject
	@Named("Dao")
	private Dao dao;
	/**
	 * 다면평가 대상자 리스트 다건 조회 Service
	 * 
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getMltsrcEvltSbjtList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getMltsrcEvltSbjtList", paramMap);
	}	
	/**
	 *  다면평가 대상자 리스트 단건 조회 Service 
	 * 
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public Map<?, ?> getMltsrcEvltSbjtMap(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return dao.getMap("getMltsrcEvltSbjtMap", paramMap);
	}
	/**
	 * 다면평가 대상자 리스트 저장 Service
	 * 
	 * @param convertMap
	 * @return int
	 * @throws Exception
	 */
	public int saveMltsrcEvltSbjt(Map<?, ?> convertMap) throws Exception {
		Log.Debug();
		int cnt=0;
		if( ((List<?>)convertMap.get("deleteRows")).size() > 0){
			cnt += dao.delete("deleteMltsrcEvltSbjt", convertMap);
		}
		if( ((List<?>)convertMap.get("mergeRows")).size() > 0){
			cnt += dao.update("saveMltsrcEvltSbjt", convertMap);
		}
		Log.Debug();
		return cnt;
	}


}
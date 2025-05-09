package com.hr.pap.evaluation.mboAppSelfReg;
import java.util.List;
import java.util.Map;
import javax.inject.Inject;
import javax.inject.Named;
import org.springframework.stereotype.Service;
import com.hr.common.dao.Dao;
import com.hr.common.logger.Log;
/**
 * 실적등록 Service
 * 
 * @author jcy
 *
 */
@Service("MboAppSelfRegService")  
public class MboAppSelfRegService{
	@Inject
	@Named("Dao")
	private Dao dao;
	/**
	 * 실적등록 다건 조회 Service
	 * 
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getMboAppSelfRegList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getMboAppSelfRegList", paramMap);
	}
	
	/**
	 * 실적등록 -본인의견- 단건 조회 Service
	 * 
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getMboAppSelfRegList2(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getMboAppSelfRegList2", paramMap);
	}	
	
	
	/**
	 *  실적등록 단건 조회 Service 
	 * 
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public Map<?, ?> getMboAppSelfRegStatusMap(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return dao.getMap("getMboAppSelfRegStatusMap", paramMap);
	}
	/**
	 * 실적등록 저장 Service
	 * 
	 * @param convertMap
	 * @return int
	 * @throws Exception
	 */
	public int saveMboAppSelfReg(Map<?, ?> convertMap) throws Exception {
		Log.Debug();
		int cnt=0;
		if( ((List<?>)convertMap.get("deleteRows")).size() > 0){
			cnt += dao.delete("deleteMboAppSelfReg", convertMap);
		}
		if( ((List<?>)convertMap.get("mergeRows")).size() > 0){
			cnt += dao.update("saveMboAppSelfReg", convertMap);
		}
		Log.Debug();
		return cnt;
	}
	
	/**
	 * 실적등록 저장 Service
	 * 
	 * @param convertMap
	 * @return int
	 * @throws Exception
	 */
	public int saveMboAppSelfReg2(Map<?, ?> convertMap) throws Exception {
		Log.Debug();
		int cnt=0;
		if( ((List<?>)convertMap.get("deleteRows")).size() > 0){
			cnt += dao.delete("deleteMboAppSelfReg2", convertMap);
		}
		if( ((List<?>)convertMap.get("mergeRows")).size() > 0){
			cnt += dao.update("saveMboAppSelfReg2", convertMap);
		}
		Log.Debug();
		return cnt;
	}
	
	/**
	 * 실적등록 저장 Service
	 * 
	 * @param convertMap
	 * @return int
	 * @throws Exception
	 */
	public int saveMboAppSelfRegRequest(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return dao.update("saveMboAppSelfRegRequest", paramMap);
	}
	


}
package com.hr.pap.evaluation.compAppSelfReg;
import java.util.List;
import java.util.Map;
import javax.inject.Inject;
import javax.inject.Named;
import org.springframework.stereotype.Service;
import com.hr.common.dao.Dao;
import com.hr.common.logger.Log;
/**
 * 본인평가 Service
 * 
 * @author JCY
 *
 */
@Service("CompAppSelfRegService")  
public class CompAppSelfRegService{
	@Inject
	@Named("Dao")
	private Dao dao;
	/**
	 * 본인평가 다건 조회 Service
	 * 
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getCompAppSelfRegList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getCompAppSelfRegList", paramMap);
	}
	
	/**
	 * 본인평가 -실적확인팝업- 다건 조회 Service
	 * 
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getCompAppSelfRegPopList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getCompAppSelfRegPopList", paramMap);
	}
	
	/**
	 * 본인평가 다건 조회 Service
	 * 
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getPapGradeInfoList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getPapGradeInfoList", paramMap);
	}	
	
	
	/**
	 *  본인평가 단건 조회 Service 
	 * 
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public Map<?, ?> getCompAppSelfRegStatusMap(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return dao.getMap("getCompAppSelfRegStatusMap", paramMap);
	}
	
	
	/**
	 *  본인평가 -실적확인 평가ID- 단건 조회 Service 
	 * 
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public Map<?, ?> getCompAppSelfRegSearchAppraisalCdMap(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return dao.getMap("getCompAppSelfRegSearchAppraisalCdMap", paramMap);
	}
	
	
	
	
	/**
	 * 본인평가 저장 Service
	 * 
	 * @param convertMap
	 * @return int
	 * @throws Exception
	 */
	public int saveCompAppSelfReg(Map<?, ?> convertMap) throws Exception {
		Log.Debug();
		int cnt=0;
		if( ((List<?>)convertMap.get("deleteRows")).size() > 0){
			cnt += dao.delete("deleteCompAppSelfReg", convertMap);
		}
		if( ((List<?>)convertMap.get("mergeRows")).size() > 0){
			cnt += dao.update("saveCompAppSelfReg", convertMap);
		}
		Log.Debug();
		return cnt;
	}
	
	
	/**
	 * 본인평가- 평가확정처리 - 저장 Service
	 * 
	 * @param paramMap
	 * @return int
	 * @throws Exception
	 */
	public int saevCompAppSelfRegRequest(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return dao.create("saevCompAppSelfRegRequest", paramMap);
	}

}
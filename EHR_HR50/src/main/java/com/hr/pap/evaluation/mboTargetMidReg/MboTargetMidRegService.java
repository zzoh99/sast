package com.hr.pap.evaluation.mboTargetMidReg;
import java.util.List;
import java.util.Map;
import javax.inject.Inject;
import javax.inject.Named;
import org.springframework.stereotype.Service;
import com.hr.common.dao.Dao;
import com.hr.common.logger.Log;
/**
 * 중간점검등록 Service
 * 
 * @author JCY
 *
 */
@Service("MboTargetMidRegService")  
public class MboTargetMidRegService{
	@Inject
	@Named("Dao")
	private Dao dao;
	/**
	 * 중간점검등록 다건 조회 Service
	 * 
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getMboTargetMidRegList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getMboTargetMidRegList", paramMap);
	}	
	/**
	 *  중간점검등록 단건 조회 Service 
	 * 
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public Map<?, ?> getMboTargetMidRegMap(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return dao.getMap("getMboTargetMidRegMap", paramMap);
	}


}
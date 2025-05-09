package com.hr.pap.evaluation.mboTargetMidApr;
import java.util.List;
import java.util.Map;
import javax.inject.Inject;
import javax.inject.Named;
import org.springframework.stereotype.Service;
import com.hr.common.dao.Dao;
import com.hr.common.logger.Log;
/**
 * 중간점검승인 Service
 * 
 * @author JCY
 *
 */
@Service("MboTargetMidAprService")  
public class MboTargetMidAprService{
	@Inject
	@Named("Dao")
	private Dao dao;
	/**
	 * 중간점검승인 다건 조회 Service
	 * 
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getMboTargetMidAprList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getMboTargetMidAprList", paramMap);
	}	
	/**
	 *  중간점검승인 단건 조회 Service 
	 * 
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public Map<?, ?> getMboTargetMidAprMap(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return dao.getMap("getMboTargetMidAprMap", paramMap);
	}



}
package com.hr.cpn.basisConfig.taxStd;
import java.util.List;
import java.util.Map;
import javax.inject.Inject;
import javax.inject.Named;
import org.springframework.stereotype.Service;
import com.hr.common.dao.Dao;
import com.hr.common.logger.Log;
/**
 * 세율 및 과세표준 관리 Service
 * 
 * @author 이름
 *
 */
@Service("TaxStdService")  
public class TaxStdService{
	@Inject
	@Named("Dao")
	private Dao dao;
	/**
	 * 세율 및 과세표준 관리 다건 조회 Service
	 * 
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getTaxStdList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getTaxStdList", paramMap);
	}	
	/**
	 *  세율 및 과세표준 관리 단건 조회 Service 
	 * 
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public Map<?, ?> getTaxStdMap(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return dao.getMap("getTaxStdMap", paramMap);
	}



}
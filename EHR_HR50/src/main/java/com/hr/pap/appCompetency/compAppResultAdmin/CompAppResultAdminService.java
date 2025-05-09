package com.hr.pap.appCompetency.compAppResultAdmin;
import java.util.List;
import java.util.Map;
import javax.inject.Inject;
import javax.inject.Named;
import org.springframework.stereotype.Service;
import com.hr.common.dao.Dao;
import com.hr.common.logger.Log;
/**
 * 다면진단통계 Service
 * 
 * @author JCY
 *
 */
@Service("CompAppResultAdminService")
public class CompAppResultAdminService {
	@Inject
	@Named("Dao")
	private Dao dao;
	
	/**
	 * 다면진단통계 다건 조회 Service
	 * 
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getCompAppResultAdminList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getCompAppResultAdminList", paramMap);
	}	
}
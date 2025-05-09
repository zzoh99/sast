package com.hr.hrm.other.allEmpStat;
import java.util.List;
import java.util.Map;
import javax.inject.Inject;
import javax.inject.Named;
import org.springframework.stereotype.Service;
import com.hr.common.dao.Dao;
import com.hr.common.logger.Log;
/**
 * 현황/검색  Service
 * 
 * @author jcy
 *
 */
@Service("AllEmpStatService")  
public class AllEmpStatService{
	@Inject
	@Named("Dao")
	private Dao dao;
	/**
	 * 현황/검색  -구분별 - 다건 조회 Service
	 * 
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getAllEmpStatList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getAllEmpStatList", paramMap);
	}

}
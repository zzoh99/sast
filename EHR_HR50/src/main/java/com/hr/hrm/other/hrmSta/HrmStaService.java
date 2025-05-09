package com.hr.hrm.other.hrmSta;
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
@Service("HrmStaService")  
public class HrmStaService{
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
	public List<?> getHrmStaList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getHrmStaList", paramMap);
	}

	
	/**
	 * 현황/검색  헤더 정보  조회 Service
	 * 
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getHrmStaTitleList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getHrmStaTitleList", paramMap);
	}
	
	/**
	 * 현황/검색 팝업 다건 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getHrmStaPopupList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getHrmStaPopupList", paramMap);
	}
}
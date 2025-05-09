package com.hr.hrm.other.hrQueryAppDet;
import java.util.List;
import java.util.Map;

import javax.inject.Inject;
import javax.inject.Named;

import org.springframework.stereotype.Service;

import com.hr.common.dao.Dao;
import com.hr.common.logger.Log;
/**
 * HR문의요청 신청팝업 Service
 * 
 * @author jcy
 *
 */
@Service("HrQueryAppDetService")  
public class HrQueryAppDetService{
	@Inject
	@Named("Dao")
	private Dao dao;
	/**
	 * HR문의요청 신청팝업 다건 조회 Service
	 * 
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getHrQueryAppDetList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getHrQueryAppDetList", paramMap);
	}	
	/**
	 *  HR문의요청 신청팝업 단건 조회 Service 
	 * 
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public Map<?, ?> getHrQueryAppDetMap(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return dao.getMap("getHrQueryAppDetMap", paramMap);
	}
	/**
	 * HR문의요청 신청팝업 저장 Service
	 * 
	 * @param convertMap
	 * @return int
	 * @throws Exception
	 */
	public int saveHrQueryAppDet(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return dao.update("saveHrQueryAppDet", paramMap);
	}



}

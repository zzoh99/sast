package com.hr.tra.basis.eduEmpStat;

import java.util.List;
import java.util.Map;

import javax.inject.Inject;
import javax.inject.Named;

import org.springframework.stereotype.Service;

import com.hr.common.dao.Dao;
import com.hr.common.logger.Log;

/**
 * 과정별수강인원현황 Service
 *
 * @author JSG
 *
 */
@Service("EduEmpStatService")
public class EduEmpStatService {
	@Inject
	@Named("Dao")
	private Dao dao;

	/**
	 * 과정별수강인원현황 다건 조회 Service
	 * 
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getEduEmpStatList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		List<?> resultList = (List<?>)dao.getList("getEduEmpStatList", paramMap);
		Log.Debug();
		return resultList;
	}	
}

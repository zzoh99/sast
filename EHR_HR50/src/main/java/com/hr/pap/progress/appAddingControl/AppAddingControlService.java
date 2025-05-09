package com.hr.pap.progress.appAddingControl;
import java.util.Map;

import javax.inject.Inject;
import javax.inject.Named;

import org.springframework.stereotype.Service;

import com.hr.common.dao.Dao;
import com.hr.common.logger.Log;
/**
 * 평가결과집계및마감 Service
 *
 * @author JCY
 *
 */
@Service("AppAddingControlService")
public class AppAddingControlService{
	@Inject
	@Named("Dao")
	private Dao dao;

	/**
	 * 평가결과집계및마감 단건 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public Map<?, ?> getAppAddingControlMap1(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		Map<?, ?> resultMap = dao.getMap("getAppAddingControlMap1", paramMap);
		Log.Debug();
		return resultMap;
	}
	
}
package com.hr.sys.system.requirement.reqDefinitionPop;
import java.util.Map;

import javax.inject.Inject;
import javax.inject.Named;

import org.springframework.stereotype.Service;

import com.hr.common.dao.Dao;
import com.hr.common.logger.Log;

/**
 * 요구사항팝업 Service
 *
 * @author EW
 *
 */
@Service("ReqDefinitionPopService")
public class ReqDefinitionPopService{ 

	@Inject
	@Named("Dao")
	private Dao dao;

	/**
	 * 요구사항팝업 저장 Service
	 *
	 * @param convertMap
	 * @return int
	 * @throws Exception
	 */
	public int saveReqDefinitionPop(Map<?, ?> convertMap) throws Exception {
		Log.Debug();
		return dao.update("saveReqDefinitionPop", convertMap);
	}
}

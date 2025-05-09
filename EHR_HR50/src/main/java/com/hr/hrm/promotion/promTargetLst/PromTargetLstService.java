package com.hr.hrm.promotion.promTargetLst;
import java.util.Map;

import javax.inject.Inject;
import javax.inject.Named;

import org.springframework.stereotype.Service;

import com.hr.common.dao.Dao;
import com.hr.common.logger.Log;

/**
 * 승진대상자명단 Service
 *
 * @author bckim
 *
 */
@Service("PromTargetLstService")
public class PromTargetLstService{

	@Inject
	@Named("Dao")
	private Dao dao;

	/**
	 * 승진대상자명단(대상자생성) 프로시저
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public Map prcPromTargetLst(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (Map) dao.excute("prcPromTargetLst", paramMap);
	}

}
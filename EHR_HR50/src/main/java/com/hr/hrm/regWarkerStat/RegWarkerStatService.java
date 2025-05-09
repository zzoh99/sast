package com.hr.hrm.regWarkerStat;
import java.util.List;
import java.util.Map;

import javax.inject.Inject;
import javax.inject.Named;

import org.springframework.stereotype.Service;

import com.hr.common.dao.Dao;
import com.hr.common.logger.Log;

/**
 * 월별근로자수(\C774\C218) Service
 *
 * @author EW
 *
 */
@Service("RegWarkerStatService")
public class RegWarkerStatService{

	@Inject
	@Named("Dao")
	private Dao dao;

	/**
	 * 월별근로자수(\C774\C218) 다건 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getRegWarkerStatList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getRegWarkerStatList", paramMap);
	}
}

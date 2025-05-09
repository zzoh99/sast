package com.hr.common.commonTabInfo;
import java.util.List;
import java.util.Map;

import javax.inject.Inject;
import javax.inject.Named;

import org.springframework.stereotype.Service;

import com.hr.common.dao.Dao;
import com.hr.common.logger.Log;

/**
 * 공통탭 정보 Service
 *
 * @author bckim
 *
 */
@Service("CommonTabInfoService")
public class CommonTabInfoService{

	@Inject
	@Named("Dao")
	private Dao dao;

	/**
	 * 공통탭 정보 다건 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getCommonTabInfoList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getCommonTabInfoList", paramMap);
	}
	public List<?> getCommonTabInfoList_PAP(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getCommonTabInfoList_PAP", paramMap);
	}
	public List<?> getCommonTabInfoList_POP(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getCommonTabInfoList_POP", paramMap);
	}
}
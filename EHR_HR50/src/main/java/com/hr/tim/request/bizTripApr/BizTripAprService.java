package com.hr.tim.request.bizTripApr;
import java.util.List;
import java.util.Map;

import javax.inject.Inject;
import javax.inject.Named;

import org.springframework.stereotype.Service;

import com.hr.common.dao.Dao;
import com.hr.common.logger.Log;
/**
 * 출장내신서승인 Service
 *
 * @author PHY
 *
 */
@Service("BizTripAprService")
public class BizTripAprService{

	@Inject
	@Named("Dao")
	private Dao dao;

	/**
	 *  출장내신서승인 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getBizTripAprList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getBizTripAprList", paramMap);
	}


}
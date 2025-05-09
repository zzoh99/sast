package com.hr.hrm.other.profileCardPrt;
import java.util.List;
import java.util.Map;

import javax.inject.Inject;
import javax.inject.Named;

import org.springframework.stereotype.Service;

import com.hr.common.dao.Dao;
import com.hr.common.logger.Log;

/**
 * 프로필카드출력 Service
 *
 * @author bckim
 *
 */
@Service("ProfileCardPrtService")
public class ProfileCardPrtService{

	@Inject
	@Named("Dao")
	private Dao dao;

	/**
	 * 프로필카드출력 다건 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getProfileCardPrtAuthList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getProfileCardPrtAuthList", paramMap);
	}
	
	/**
	 * getProfileCardPrtList 다건 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getProfileCardPrtList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getProfileCardPrtList", paramMap);
	}
}
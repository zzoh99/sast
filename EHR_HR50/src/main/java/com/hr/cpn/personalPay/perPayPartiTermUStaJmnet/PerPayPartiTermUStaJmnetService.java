package com.hr.cpn.personalPay.perPayPartiTermUStaJmnet;
import java.util.List;
import java.util.Map;

import javax.inject.Inject;
import javax.inject.Named;

import org.springframework.stereotype.Service;

import com.hr.common.dao.Dao;
import com.hr.common.logger.Log;
/**
 * 메뉴명 Service
 *
 * @author 이름
 *
 */
@Service("PerPayPartiTermUStaJmnetService")
public class PerPayPartiTermUStaJmnetService{
	@Inject
	@Named("Dao")
	private Dao dao;
	/**
	 * 메뉴명 다건 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getPerPayPartiTermUStaJmnetList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getPerPayPartiTermUStaJmnetList", paramMap);
	}
	/**
	 * 메뉴명 다건 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getPerPayPartiTermUStaJmnetListFirst(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getPerPayPartiTermUStaJmnetListFirst", paramMap);
	}
	/**
	 * 메뉴명 다건 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getPerPayPartiTermUStaJmnetListSecond(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getPerPayPartiTermUStaJmnetListSecond", paramMap);
	}



}
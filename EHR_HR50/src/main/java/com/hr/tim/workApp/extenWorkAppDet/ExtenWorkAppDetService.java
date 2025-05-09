package com.hr.tim.workApp.extenWorkAppDet;
import java.util.List;
import java.util.Map;

import javax.inject.Inject;
import javax.inject.Named;

import org.springframework.stereotype.Service;

import com.hr.common.dao.Dao;
import com.hr.common.logger.Log;
/**
 * 연장근무추가신청 Service
 *
 * @author
 *
 */
@Service("ExtenWorkAppDetService")
public class ExtenWorkAppDetService{
	@Inject
	@Named("Dao")
	private Dao dao;

	/**
	 * 근무코드 리스트
	 * 
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getExtenWorkAppDetTitle(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getExtenWorkAppDetWorkCd", paramMap);
	}

	/**
	 * 연장근무추가신청 저장 Service
	 *
	 * @param convertMap
	 * @return int
	 * @throws Exception
	 */
	public int saveExtenWorkAppDet(Map<?, ?> convertMap) throws Exception {
		Log.Debug();
		int cnt=0;
		cnt += dao.update("saveExtenWorkAppDet", convertMap);
		dao.update("saveExtenWorkAppDet2", convertMap);
		Log.Debug();
		return cnt;
	}

}
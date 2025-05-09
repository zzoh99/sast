package com.hr.tim.workApp.otWorkOrgUpdAppDet;
import java.util.Map;

import javax.inject.Inject;
import javax.inject.Named;

import org.springframework.stereotype.Service;

import com.hr.common.dao.Dao;
import com.hr.common.logger.Log;

/**
 * 연장근무변경신청 세부내역 Service
 *
 * @author
 *
 */
@Service("OtWorkOrgUpdAppDetService")
public class OtWorkOrgUpdAppDetService{

	@Inject
	@Named("Dao")
	private Dao dao;
	
	/**
	 * 연장근무변경신청 저장
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public int saveOtWorkOrgUpdAppDet(Map<?, ?> convertMap) throws Exception {
		Log.Debug();
		int cnt=0;
		dao.delete("deleteOtWorkOrgUpdAppDet", convertMap);   //삭제후
		cnt += dao.update("saveOtWorkOrgUpdAppDet", convertMap); //다시 저장

		return cnt;
	}
	
}
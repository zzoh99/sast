package com.hr.tim.workApp.otWorkOrgAppDet;
import java.util.Map;

import javax.inject.Inject;
import javax.inject.Named;

import org.springframework.stereotype.Service;

import com.hr.common.dao.Dao;
import com.hr.common.logger.Log;

/**
 * 연장근무사전신청 세부내역 Service
 *
 * @author
 *
 */
@Service("OtWorkOrgAppDetService")
public class OtWorkOrgAppDetService{

	@Inject
	@Named("Dao")
	private Dao dao;
	
	/**
	 * 연장근무사전신청 저장
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public int saveOtWorkOrgAppDet(Map<?, ?> convertMap) throws Exception {
		Log.Debug();
		int cnt=0;
		dao.delete("deleteOtWorkOrgAppDet", convertMap);   //삭제후
		cnt += dao.update("saveOtWorkOrgAppDet", convertMap); //다시 저장

		return cnt;
	}
	
}
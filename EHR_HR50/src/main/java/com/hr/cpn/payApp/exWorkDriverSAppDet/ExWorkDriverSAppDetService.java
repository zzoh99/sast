package com.hr.cpn.payApp.exWorkDriverSAppDet;
import java.util.List;
import java.util.Map;

import javax.inject.Inject;
import javax.inject.Named;

import org.springframework.stereotype.Service;

import com.hr.common.dao.Dao;
import com.hr.common.logger.Log;

/**
 * 특근수당(기원) 종합신청 세부내역 Service
 *
 * @author  YSH
 *
 */
@Service("ExWorkDriverSAppDetService")
public class ExWorkDriverSAppDetService{

	@Inject
	@Named("Dao")
	private Dao dao;

	/**
	 * 특근수당(기원) 종합신청 세부내역 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getExWorkDriverSAppDetList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getExWorkDriverSAppDetList", paramMap);
	}

	/**
	 * 특근수당(기원) 종합신청 저장 Service
	 *
	 * @param convertMap
	 * @return int
	 * @throws Exception
	 */
	public int saveExWorkDriverSAppDet(Map<?, ?> convertMap) throws Exception {
		Log.Debug();
		int cnt=0;
		
		//특근수당(기원) 종합신청 Master 저장		//
		cnt += dao.update("saveExWorkDriverSApp", convertMap);
		
		//특근수당(기원) 종합신청 Detail 저장
		cnt += dao.update("saveExWorkDriverSAppDet", convertMap);

		Log.Debug();
		return cnt;
	}

	
}
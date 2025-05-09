package com.hr.cpn.payApp.exWorkDriverNAppDet;
import java.util.List;
import java.util.Map;

import javax.inject.Inject;
import javax.inject.Named;

import org.springframework.stereotype.Service;

import com.hr.common.dao.Dao;
import com.hr.common.logger.Log;

/**
 * 야근수당(기원) 종합신청 세부내역 Service
 *
 * @author  YSH
 *
 */
@Service("ExWorkDriverNAppDetService")
public class ExWorkDriverNAppDetService{

	@Inject
	@Named("Dao")
	private Dao dao;

	/**
	 * 야근수당(기원) 종합신청 세부내역 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getExWorkDriverNAppDetList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getExWorkDriverNAppDetList", paramMap);
	}

	/**
	 * 야근수당(기원) 종합신청 저장 Service
	 *
	 * @param convertMap
	 * @return int
	 * @throws Exception
	 */
	public int saveExWorkDriverNAppDet(Map<?, ?> convertMap) throws Exception {
		Log.Debug();
		int cnt=0;
		
		//야근수당(기원) 종합신청 Master 저장		//
		cnt += dao.update("saveExWorkDriverNApp", convertMap);
		
		//야근수당(기원) 종합신청 Detail 저장
		cnt += dao.update("saveExWorkDriverNAppDet", convertMap);

		Log.Debug();
		return cnt;
	}

	
}
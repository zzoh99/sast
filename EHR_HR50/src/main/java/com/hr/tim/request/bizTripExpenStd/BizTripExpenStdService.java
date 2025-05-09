package com.hr.tim.request.bizTripExpenStd;
import java.util.List;
import java.util.Map;

import javax.inject.Inject;
import javax.inject.Named;

import org.springframework.stereotype.Service;

import com.hr.common.com.ComService;
import com.hr.common.com.ComUtilService;
import com.hr.common.dao.Dao;
import com.hr.common.exception.HrException;
import com.hr.common.logger.Log;
/**
 * 출장비기준관리 Service
 * 
 * @author 이름
 *
 */
@Service("BizTripExpenStdService")  
public class BizTripExpenStdService extends ComUtilService{
	
	@Inject
	@Named("Dao")
	private Dao dao;

	@Inject
	@Named("ComService")
	private ComService comService;

	/**
	 *  출장비기준관리 - 유류비 저장 Service
	 *
	 * @param convertMap
	 * @return int
	 * @throws Exception
	 */
	public int saveBizTripExpenStdOil(Map<?, ?> convertMap) throws Exception {
		Log.Debug();
		int cnt=0;
		
		if( ((List<?>)convertMap.get("deleteRows")).size() > 0){
			cnt += dao.delete("deleteBizTripExpenStdOil", convertMap);
		}
		if( ((List<?>)convertMap.get("mergeRows")).size() > 0){
			cnt += dao.update("saveBizTripExpenStdOil", convertMap);
		}

		//EDATE 자동생성
		prcComEdateCreate(convertMap, "TTIM856", "gubunCd", null, null);

		return cnt;
	}

	/**
	 *  출장비기준관리 - 유류비 저장 Service
	 *
	 * @param convertMap
	 * @return int
	 * @throws Exception
	 */
	public int saveBizTripExpenStdExc(Map<?, ?> convertMap) throws Exception {
		Log.Debug();
		int cnt=0;
		
		if( ((List<?>)convertMap.get("deleteRows")).size() > 0){
			cnt += dao.delete("deleteBizTripExpenStdExc", convertMap);
		}
		if( ((List<?>)convertMap.get("mergeRows")).size() > 0){
			cnt += dao.update("saveBizTripExpenStdExc", convertMap);
		}

		//EDATE 자동생성
		prcComEdateCreate(convertMap, "TTIM857", "gubunCd", null, null);

		return cnt;
	}
	/**
	 *  출장비기준관리 - 출장비여비 저장 Service
	 *
	 * @param convertMap
	 * @return int
	 * @throws Exception
	 */
	public int saveBizTripExpenStdLmt(Map<?, ?> convertMap) throws Exception {
		Log.Debug();
		int cnt=0;
		
		if( ((List<?>)convertMap.get("deleteRows")).size() > 0){
			cnt += dao.delete("deleteBizTripExpenStdLmt", convertMap);
		}
		if( ((List<?>)convertMap.get("mergeRows")).size() > 0){
			cnt += dao.update("saveBizTripExpenStdLmt", convertMap);
		}

		return cnt;
	}
}	
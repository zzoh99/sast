package com.hr.sys.psnalInfoPop.psnalLicensePop;
import java.util.List;
import java.util.Map;

import javax.inject.Inject;
import javax.inject.Named;

import org.springframework.stereotype.Service;

import com.hr.common.dao.Dao;
import com.hr.common.logger.Log;

/**
 * psnalLicensePop Service
 *
 * @author EW
 *
 */
@Service("PsnalLicensePopService")
public class PsnalLicensePopService{

	@Inject
	@Named("Dao")
	private Dao dao;

	/**
	 * psnalLicensePop 다건 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getPsnalLicensePopList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getPsnalLicensePopList", paramMap);
	}

	/**
	 * psnalLicensePop 저장 Service
	 *
	 * @param convertMap
	 * @return int
	 * @throws Exception
	 */
	public int savePsnalLicensePop(Map<?, ?> convertMap) throws Exception {
		Log.Debug();
		int cnt=0;
		if( ((List<?>)convertMap.get("deleteRows")).size() > 0){
			cnt += dao.delete("deletePsnalLicensePop", convertMap);
		}
		if( ((List<?>)convertMap.get("mergeRows")).size() > 0){
			cnt += dao.update("savePsnalLicensePop", convertMap);
		}

		return cnt;
	}
	/**
	 * psnalLicensePop 단건 조회 Service
	 *
	 * @param paramMap
	 * @return Map
	 * @throws Exception
	 */
	public Map<?, ?> getPsnalLicensePopMap(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		Map<?, ?> resultMap = dao.getMap("getPsnalLicensePopMap", paramMap);
		Log.Debug();
		return resultMap;
	}
}

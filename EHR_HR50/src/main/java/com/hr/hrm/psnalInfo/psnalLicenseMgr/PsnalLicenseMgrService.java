package com.hr.hrm.psnalInfo.psnalLicenseMgr;
import java.util.List;
import java.util.Map;

import javax.inject.Inject;
import javax.inject.Named;

import org.springframework.stereotype.Service;

import com.hr.common.dao.Dao;
import com.hr.common.logger.Log;

/**
 * PsnalLicenseMgr Service
 *
 * @author jy
 *
 */
@Service("PsnalLicenseMgrService")
public class PsnalLicenseMgrService{

	@Inject
	@Named("Dao")
	private Dao dao;
	
	/**
	 * 개인별자격사항관리 저장
	 *
	 * @param convertMap
	 * @return int
	 * @throws Exception
	 */
	public int savePsnalLicenseMgr(Map<?, ?> convertMap) throws Exception {
		Log.Debug();
		int cnt=0;
		if( ((List<?>)convertMap.get("deleteRows")).size() > 0){
			cnt += dao.delete("deletePsnalLicenseMgr", convertMap);
		}
		if( ((List<?>)convertMap.get("mergeRows")).size() > 0){
			cnt += dao.update("savePsnalLicenseMgr", convertMap);
		}

		return cnt;
	}

	
}

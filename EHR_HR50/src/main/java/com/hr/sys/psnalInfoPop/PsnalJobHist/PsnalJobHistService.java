package com.hr.sys.psnalInfoPop.PsnalJobHist;
import java.util.List;
import java.util.Map;

import javax.inject.Inject;
import javax.inject.Named;

import org.springframework.stereotype.Service;

import com.hr.common.dao.Dao;
import com.hr.common.logger.Log;

/**
 * PsnalJobHist Service
 *
 * @author jy
 *
 */
@Service("PsnalJobHistService")
public class PsnalJobHistService{

	@Inject
	@Named("Dao")
	private Dao dao;

	/**
	 * 직무이력 저장
	 *
	 * @param convertMap
	 * @return int
	 * @throws Exception
	 */
	public int savePsnalJobHist(Map<?, ?> convertMap) throws Exception {
		Log.Debug();
		int cnt=0;
		if( ((List<?>)convertMap.get("deleteRows")).size() > 0){
			cnt += dao.delete("deletePsnalJobHist", convertMap);
		}
		if( ((List<?>)convertMap.get("mergeRows")).size() > 0){
			cnt += dao.update("savePsnalJobHist", convertMap);
		}

		return cnt;
	}
	
}

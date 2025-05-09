package com.hr.hrm.psnalInfo.psnalLangMgr;
import java.util.List;
import java.util.Map;

import javax.inject.Inject;
import javax.inject.Named;

import org.springframework.stereotype.Service;

import com.hr.common.dao.Dao;
import com.hr.common.logger.Log;

/**
 * PsnalLangMgr Service
 *
 * @author jy
 *
 */
@Service("PsnalLangMgrService")
public class PsnalLangMgrService{

	@Inject
	@Named("Dao")
	private Dao dao;
	
	/**
	 * 개인별어학사항관리 저장
	 *
	 * @param convertMap
	 * @return int
	 * @throws Exception
	 */
	public int savePsnalLangMgr(Map<?, ?> convertMap) throws Exception {
		Log.Debug();
		int cnt=0;
		if( ((List<?>)convertMap.get("deleteRows")).size() > 0){
			cnt += dao.delete("deletePsnalLangMgr", convertMap);
		}
		if( ((List<?>)convertMap.get("mergeRows")).size() > 0){
			cnt += dao.update("savePsnalLangMgr", convertMap);
		}

		return cnt;
	}


    public List<?> getForeignGradeMgrList3(Map<?, ?> paramMap) throws Exception {
        Log.Debug();
        return (List<?>) dao.getList("getForeignGradeMgrList3", paramMap);
    }
	
}

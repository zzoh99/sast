package com.hr.pap.execCompAppMngResultSrh;

import java.util.List;
import java.util.Map;

import javax.inject.Inject;
import javax.inject.Named;

import org.springframework.stereotype.Service;

import com.hr.common.dao.Dao;
import com.hr.common.logger.Log;

/**
 * 임원다면평가업로드 Service
 */
@Service("ExecCompAppMngResultSrhService")
public class ExecCompAppMngResultSrhService {
	@Inject
	@Named("Dao")
	private Dao dao;

	/**
	 * getExecCompAppMngUploadList 다건 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getExecCompAppMngResultSrhList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getExecCompAppMngResultSrhList", paramMap);
	}
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
			cnt += dao.delete("deleteExecCompAppMng", convertMap);
		}
		if( ((List<?>)convertMap.get("mergeRows")).size() > 0){
			cnt += dao.update("saveExecCompAppMng", convertMap);
		}

		return cnt;
	}	

}

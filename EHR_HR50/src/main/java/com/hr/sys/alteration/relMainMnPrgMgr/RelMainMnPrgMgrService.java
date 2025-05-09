package com.hr.sys.alteration.relMainMnPrgMgr;

import java.util.List;
import java.util.Map;

import javax.inject.Inject;
import javax.inject.Named;

import org.springframework.stereotype.Service;

import com.hr.common.dao.Dao;
import com.hr.common.logger.Log;

@Service("RelMainMnPrgMgrService")
public class RelMainMnPrgMgrService {

	@Inject
	@Named("Dao")
	private Dao dao;

	/**
	 * 관련메뉴관리 저장 Service
	 * 
	 * @param convertMap
	 * @return int
	 * @throws Exception
	 */
	public int addRelMainMnPrgMgr(Map<?, ?> convertMap) throws Exception {
		Log.Debug();
		int cnt=0;
		if( ((List<?>)convertMap.get("mergeRows")).size() > 0){
			cnt += dao.update("addRelMainMnPrgMgr", convertMap);
		}
		Log.Debug();
		return cnt;
	}

	/**
	 * 연관메뉴 설명 업데이트
	 * @param paramMap
	 * @return
	 * @throws Exception
	 */
	public int updateRelMainMnPrgMgrRelMenuDescription(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return dao.updateClob("updateRelMainMnPrgMgrRelMenuDescription", paramMap);
	}
}

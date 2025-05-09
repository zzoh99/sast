package com.hr.hrm.retire.retireCheckListMgr;
import java.util.List;
import java.util.Map;

import javax.inject.Inject;
import javax.inject.Named;

import org.springframework.stereotype.Service;

import com.hr.common.dao.Dao;
import com.hr.common.logger.Log;

/**
 * retireCheckListMgr Service
 *
 * @author EW
 *
 */
@Service("RetireCheckListMgrService")
public class RetireCheckListMgrService{

	@Inject
	@Named("Dao")
	private Dao dao;

	/**
	 * retireCheckListMgr 다건 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getRetireCheckListMgrList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getRetireCheckListMgrList", paramMap);
	}

	/**
	 * retireCheckListMgr 저장 Service
	 *
	 * @param convertMap
	 * @return int
	 * @throws Exception
	 */
	public int saveRetireCheckListMgr(Map<?, ?> convertMap) throws Exception {
		Log.Debug();
		int cnt=0;
		if( ((List<?>)convertMap.get("deleteRows")).size() > 0){
			cnt += dao.delete("deleteRetireCheckListAppEx103",  convertMap);  //delete THRI103
			cnt += dao.delete("deleteRetireCheckListAppEx107", convertMap);  //delete THRI107
			cnt += dao.delete("deleteRetireCheckListAppEx125", convertMap);  //delete THRI125
			cnt += dao.delete("deleteRetireCheckListMgr", convertMap);
		}
		if( ((List<?>)convertMap.get("mergeRows")).size() > 0){
			cnt += dao.update("saveRetireCheckListMgr", convertMap);
		}

		return cnt;
	}
	/**
	 * retireCheckListMgr 단건 조회 Service
	 *
	 * @param paramMap
	 * @return Map
	 * @throws Exception
	 */
	public Map<?, ?> getRetireCheckListMgrMap(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		Map<?, ?> resultMap = dao.getMap("getRetireCheckListMgrMap", paramMap);
		Log.Debug();
		return resultMap;
	}
	
	/**
	 * 퇴직자 checkList 프로시저
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public Map prcPHrmRetireCheckList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (Map) dao.excute("prcPHrmRetireCheckList", paramMap);
	}
	
	/**
	 * 퇴직자 checkList 상세 프로시저
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public Map prcHrmRetireCheckCnt(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (Map) dao.excute("prcHrmRetireCheckCnt", paramMap);
	}

    public List<?> getRetireCheckListAppDet(Map<?, ?> paramMap) throws Exception {
        Log.Debug();
        return (List<?>) dao.getList("getRetireCheckListAppDet", paramMap);
    }
}

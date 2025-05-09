package com.hr.cpn.payRetire.sepRmidMgr;
import java.util.List;
import java.util.Map;

import javax.inject.Inject;
import javax.inject.Named;

import org.springframework.stereotype.Service;

import com.hr.common.dao.Dao;
import com.hr.common.logger.Log;

/**
 * 퇴직금중간정산내역관리 Service
 *
 * @author EW
 *
 */
@Service("SepRmidMgrService")
public class SepRmidMgrService{

	@Inject
	@Named("Dao")
	private Dao dao;

	/**
	 * 퇴직금중간정산내역관리 다건 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getSepRmidMgrList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getSepRmidMgrList", paramMap);
	}

	/**
	 * 퇴직금중간정산내역관리 저장 Service
	 *
	 * @param convertMap
	 * @return int
	 * @throws Exception
	 */
	public int saveSepRmidMgr(Map<?, ?> convertMap) throws Exception {
		Log.Debug();
		int cnt=0;
		if( ((List<?>)convertMap.get("deleteRows")).size() > 0){
			cnt += dao.delete("deleteSepRmidMgr", convertMap);
		}
		if( ((List<?>)convertMap.get("mergeRows")).size() > 0){
			cnt += dao.update("saveSepRmidMgr", convertMap);
		}

		return cnt;
	}
}

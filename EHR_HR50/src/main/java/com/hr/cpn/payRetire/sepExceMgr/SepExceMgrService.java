package com.hr.cpn.payRetire.sepExceMgr;
import java.util.List;
import java.util.Map;

import javax.inject.Inject;
import javax.inject.Named;

import org.springframework.stereotype.Service;

import com.hr.common.dao.Dao;
import com.hr.common.logger.Log;

/**
 * 퇴직금예외관리 Service
 *
 * @author JM
 *
 */
@Service("SepExceMgrService")
public class SepExceMgrService{
	@Inject
	@Named("Dao")
	private Dao dao;

	/**
	 * 퇴직금예외관리 다건 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getSepExceMgrList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();

		return (List<?>) dao.getList("getSepExceMgrList", paramMap);
	}

	/**
	 * 퇴직금예외관리 저장 Service
	 *
	 * @param convertMap
	 * @return int
	 * @throws Exception
	 */
	public int saveSepExceMgr(Map<?, ?> convertMap) throws Exception {
		Log.Debug();

		int cnt=0;
		if( ((List<?>)convertMap.get("deleteRows")).size() > 0){
			cnt += dao.delete("deleteSepExceMgr", convertMap);
		}
		if( ((List<?>)convertMap.get("mergeRows")).size() > 0){
			cnt += dao.update("saveSepExceMgr", convertMap);
		}
		return cnt;
	}
}
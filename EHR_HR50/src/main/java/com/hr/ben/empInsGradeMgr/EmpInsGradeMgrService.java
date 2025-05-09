package com.hr.ben.empInsGradeMgr;
import java.util.List;
import java.util.Map;

import javax.inject.Inject;
import javax.inject.Named;

import org.springframework.stereotype.Service;

import com.hr.common.dao.Dao;
import com.hr.common.logger.Log;

/**
 * 고용보험등급변경관리 Service
 *
 * @author EW
 *
 */
@Service("EmpInsGradeMgrService")
public class EmpInsGradeMgrService{

	@Inject
	@Named("Dao")
	private Dao dao;

	/**
	 * 고용보험등급변경관리 다건 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getEmpInsGradeMgrList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getEmpInsGradeMgrList", paramMap);
	}

	/**
	 * 고용보험등급변경관리 저장 Service
	 *
	 * @param convertMap
	 * @return int
	 * @throws Exception
	 */
	public int saveEmpInsGradeMgr(Map<?, ?> convertMap) throws Exception {
		Log.Debug();
		int cnt=0;
		if( ((List<?>)convertMap.get("deleteRows")).size() > 0){
			cnt += dao.delete("deleteEmpInsGradeMgr", convertMap);
		}
		if( ((List<?>)convertMap.get("mergeRows")).size() > 0){
			cnt += dao.update("saveEmpInsGradeMgr", convertMap);
		}

		return cnt;
	}

	/**
	 * 고용보험등급변경관리 반영작업
	 *
	 * @param paramMap
	 * @return int
	 * @throws Exception
	 */
	public Map prcP_BEN_NP_UPD(Map<?, ?> paramMap) throws Exception {
		Log.Debug();

		return (Map) dao.excute("EmpInsGradeMgrP_BEN_NP_UPD", paramMap);
	}
}

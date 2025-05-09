package com.hr.pap.appCompetency.compCreatMng;
import java.util.List;
import java.util.Map;

import javax.inject.Inject;
import javax.inject.Named;

import org.springframework.stereotype.Service;

import com.hr.common.dao.Dao;
import com.hr.common.logger.Log;
/**
 * 리더십진단표관리 Service
 *
 * @author JSG
 *
 */
@Service("CompCreatMngService")
public class CompCreatMngService{
	@Inject
	@Named("Dao")
	private Dao dao;

	/**
	 * 리더십진단표관리 다건 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getCompCreatMngList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getCompCreatMngList", paramMap);
	}

	/**
	 * 리더십진단표관리 저장 Service
	 *
	 * @param convertMap
	 * @return int
	 * @throws Exception
	 */
	public int saveCompCreatMng(Map<?, ?> convertMap) throws Exception {
		Log.Debug();
		int cnt=0;
		if( ((List<?>)convertMap.get("deleteRows")).size() > 0){
			cnt += dao.delete("deleteCompCreatMng", convertMap);
		}
		Log.Debug();
		return cnt;
	}

	/**
	 * 리더십진단표관리 저장 Service (리더십표생성)
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public Map prcCompCreatMng(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (Map) dao.excute("prcCompCreatMng", paramMap);
	}
}
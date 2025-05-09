package com.hr.cpn.payRetire.sepTaxDefMgr;
import java.util.List;
import java.util.Map;

import javax.inject.Inject;
import javax.inject.Named;

import org.springframework.stereotype.Service;

import com.hr.common.dao.Dao;
import com.hr.common.logger.Log;

/**
 * 과세이연기초 Service
 *
 * @author JM
 *
 */
@Service("SepTaxDefMgrService")
public class SepTaxDefMgrService{
	@Inject
	@Named("Dao")
	private Dao dao;

	/**
	 * 과세이연기초 다건 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getSepTaxDefMgrList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();

		return (List<?>) dao.getList("getSepTaxDefMgrList", paramMap);
	}

	/**
	 * 과세이연기초 저장 Service
	 *
	 * @param convertMap
	 * @return int
	 * @throws Exception
	 */
	public int saveSepTaxDefMgr(Map<?, ?> convertMap) throws Exception {
		Log.Debug();

		int cnt=0;
		if( ((List<?>)convertMap.get("deleteRows")).size() > 0){
			cnt += dao.delete("deleteSepTaxDefMgr", convertMap);
		}
		if( ((List<?>)convertMap.get("mergeRows")).size() > 0){
			cnt += dao.update("saveSepTaxDefMgr", convertMap);
		}

		return cnt;
	}
}
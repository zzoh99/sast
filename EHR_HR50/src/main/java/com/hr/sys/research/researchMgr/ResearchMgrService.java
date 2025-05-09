package com.hr.sys.research.researchMgr;

import java.util.List;
import java.util.Map;

import javax.inject.Inject;
import javax.inject.Named;

import org.springframework.stereotype.Service;

import com.hr.common.dao.Dao;
import com.hr.common.logger.Log;

@Service("ResearchMgrService") 
public class ResearchMgrService{
 
	@Inject
	@Named("Dao")
	private Dao dao;
	
	/**
	 * 설문조사 Master 조회 Serivce
	 * 
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getResearchMgrOrgList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>)dao.getList("getResearchMgrOrgList", paramMap);
	}
	/**
	 * 설문조사 Master 조회 Serivce
	 * 
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getResearchMgrList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>)dao.getList("getResearchMgrList", paramMap);
	}
	/**
	 * 설문조사 Detail 조회 Serivce
	 * 
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getResearchMgrDetailList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>)dao.getList("getResearchMgrDetailList", paramMap);
	}
	/**
	 * 설문조사 DetailType 조회 Serivce
	 * 
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getResearchMgrDetailTypeList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>)dao.getList("getResearchMgrDetailTypeList", paramMap);
	}
	/**
	 * 설문조사 세부내역 직급 직책 직위 조회 Serivce
	 * 
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getResearchMgrNoticeLvl(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>)dao.getList("getResearchMgrNoticeLvl", paramMap);
	}
	/**
	 * 설문조사 세부내역 직급 직책 직위 해당 리스트 조회 Serivce
	 * 
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getResearchMgrNoticeLvlList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>)dao.getList("getResearchMgrNoticeLvlList", paramMap);
	}
	public int saveResearchMgr(Map<?, ?> convertMap) throws Exception {
		Log.Debug();
		int cnt=0;
		if( ((List<?>)convertMap.get("deleteRows")).size() > 0){
			cnt += dao.delete("deleteResearchMasterMgr609", convertMap);
			cnt += dao.delete("deleteResearchMasterMgr605", convertMap);
			cnt += dao.delete("deleteResearchMasterMgr603", convertMap);
			cnt += dao.delete("deleteResearchMasterMgr601", convertMap);
		}
		if( ((List<?>)convertMap.get("mergeRows")).size() > 0){
			cnt += dao.update("saveResearchMgr", convertMap);
		}
		Log.Debug();
		return cnt;
	}
	public int saveResearchMgrDetail(Map<?, ?> convertMap) throws Exception {
		Log.Debug();
		int cnt=0;
		if( ((List<?>)convertMap.get("deleteRows")).size() > 0){
			cnt += dao.delete("deleteResearchMasterMgrSeq603", convertMap);
		}
		if( ((List<?>)convertMap.get("mergeRows")).size() > 0){
			cnt += dao.update("saveResearchMgrDetail", convertMap);
		}
		Log.Debug();
		return cnt;
	}
	public int insertResearchMgrNotice(Map<?, ?> convertMap) throws Exception {
		Log.Debug();
		int cnt=0;
		if( ((List<?>)convertMap.get("mergeRows")).size() > 0){
			cnt += dao.delete("deleteResearchMasterMgrSeq609", convertMap);
			cnt += dao.create("insertResearchMgrNotice", convertMap);
		}
		Log.Debug();
		return cnt;
	}
	public int saveResearchMgrDetailType(Map<?, ?> convertMap) throws Exception {
		Log.Debug();
		int cnt=0;
		if( ((List<?>)convertMap.get("deleteRows")).size() > 0){
			cnt += dao.delete("deleteResearchMasterMgrSeq605", convertMap);
		}
		if( ((List<?>)convertMap.get("mergeRows")).size() > 0){
			cnt += dao.update("saveResearchMgrDetailType", convertMap);
		}
		Log.Debug();
		return cnt;
	}
	public int saveResearchMgrNotice(Map<?, ?> convertMap) throws Exception {
		Log.Debug();
		int cnt=0;
		if( ((List<?>)convertMap.get("deleteRows")).size() > 0){
			cnt += dao.delete("deleteResearchMgrNotice", convertMap);
		}
		if( ((List<?>)convertMap.get("mergeRows")).size() > 0){
			cnt += dao.update("saveResearchMgrNotice", convertMap);
		}
		Log.Debug();
		return cnt;
	}
}
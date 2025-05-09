package com.hr.org.organization.orgGbnUploadMgr;
import java.util.List;
import java.util.Map;

import javax.inject.Inject;
import javax.inject.Named;

import org.springframework.stereotype.Service;

import com.hr.common.dao.Dao;
import com.hr.common.logger.Log;
/**
 * 조직구분업로드 Service
 *
 * @author JSG
 *
 */
@Service("OrgGbnUploadMgrService")
public class OrgGbnUploadMgrService{
	@Inject
	@Named("Dao")
	private Dao dao;
	/**
	 * 조직구분업로드 다건 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getOrgGbnUploadMgrList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getOrgGbnUploadMgrList", paramMap);
	}

	/**
	 * 조직구분업로드 저장 Service
	 *
	 * @param convertMap
	 * @return int
	 * @throws Exception
	 */
	public int saveOrgGbnUploadMgr(Map<?, ?> convertMap) throws Exception {
		Log.Debug();
		int cnt=0;
		if( ((List<?>)convertMap.get("deleteRows")).size() > 0){
			cnt += dao.delete("deleteOrgGbnUploadMgr", convertMap);
		}
		if( ((List<?>)convertMap.get("mergeRows")).size() > 0){
			cnt += dao.update("saveOrgGbnUploadMgrFirst", convertMap);
		}
		dao.update("saveOrgGbnUploadMgrSecond", convertMap);
		Log.Debug();
		return cnt;
	}

	/**
	 * 조직구분업로드 삭제 Service
	 *
	 * @param paramMap
	 * @return int
	 * @throws Exception
	 */
	public int deleteOrgGbnUploadMgr(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return dao.delete("deleteOrgGbnUploadMgr", paramMap);
	}
}
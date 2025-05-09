package com.hr.org.job.orgKnowledgeReg;
import java.util.List;
import java.util.Map;

import javax.inject.Inject;
import javax.inject.Named;

import org.springframework.stereotype.Service;

import com.hr.common.dao.Dao;
import com.hr.common.logger.Log;
/**
 * 조직의지식등록 Service
 *
 * @author jy
 *
 */
@Service("OrgKnowledgeRegService")
public class OrgKnowledgeRegService{
	@Inject
	@Named("Dao")
	private Dao dao;
	
	/**
	 * 조직의지식등록 저장
	 *
	 * @param convertMap
	 * @return int
	 * @throws Exception
	 */
	public int saveOrgKnowledgeReg(Map<?, ?> convertMap) throws Exception {
		Log.Debug();
		int cnt=0;
		if( ((List<?>)convertMap.get("deleteRows")).size() > 0){
			cnt += dao.delete("deleteOrgKnowledgeReg", convertMap);
		}
		if( ((List<?>)convertMap.get("mergeRows")).size() > 0){
			cnt += dao.update("saveOrgKnowledgeReg", convertMap);
		}

		return cnt;
	}
}
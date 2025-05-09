package com.hr.hrd.trmManage;

import com.hr.common.dao.Dao;
import com.hr.common.logger.Log;
import org.springframework.stereotype.Service;

import javax.inject.Inject;
import javax.inject.Named;
import java.util.List;
import java.util.Map;

/**
 * 조직도관리 Service
 *
 * @author CBS
 *
 */
@Service("TRMManageService")
public class TRMManageService {
	@Inject
	@Named("Dao")
	private Dao dao;


	public List<?> getSkillList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getSkillList", paramMap);
	}

	public List<?> getKnowledgeList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getKnowledgeList", paramMap);
	}

	public List<?> getTRMRegList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getTRMRegList", paramMap);
	}


	public List<?> getTRMEduPopupList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getTRMEduPopupList", paramMap);
	}



	public List<?> getAppOrgSchemeMgrList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getAppOrgSchemeMgrList", paramMap);
	}

	/**
	 * 조직도관리 sheet2 저장 Service
	 *
	 * @param convertMap
	 * @return int
	 * @throws Exception
	 */
	public int saveTRM(Map<?, ?> convertMap) throws Exception {
		Log.Debug();
		int cnt=0;
		if( ((List<?>)convertMap.get("deleteRows")).size() > 0){
			cnt += dao.delete("deleteTRM", convertMap);
		}
		if( ((List<?>)convertMap.get("mergeRows")).size() > 0){
			cnt += dao.update("saveTRM", convertMap);
		}
		Log.Debug();
		return cnt;
	}
	
	/**
	 *  TRM조회화면 저장 Service
	 *
	 * @param convertMap
	 * @return int
	 * @throws Exception
	 */
	public int saveTcdpwTree(Map<?, ?> convertMap) throws Exception {
		Log.Debug();
		
		int cnt=0;

		String searchBizType = convertMap.get("searchBizType").toString();
		
		if("S".equals(searchBizType)){
			if( ((List<?>)convertMap.get("deleteRows")).size() > 0){
				cnt += dao.delete("deleteTcdpw203", convertMap);
			}
			if( ((List<?>)convertMap.get("mergeRows")).size() > 0){
				cnt += dao.update("saveTcdpw203", convertMap);
			}
		}else {
			if( ((List<?>)convertMap.get("deleteRows")).size() > 0){
				cnt += dao.delete("deleteTcdpw201", convertMap);
			}
			if( ((List<?>)convertMap.get("mergeRows")).size() > 0){
				cnt += dao.update("saveTcdpw201", convertMap);
			}
		}
		
		Log.Debug();
		
		return cnt;
	}

}
package com.hr.sys.other.workflow;
import java.util.List;
import java.util.Map;

import javax.inject.Inject;
import javax.inject.Named;

import org.springframework.stereotype.Service;

import com.hr.common.dao.Dao;
import com.hr.common.logger.Log;
/**
 * 워크플로우 Service
 *
 * @author 이름
 *
 */
@Service("WorkflowService")
public class WorkflowService{
	@Inject
	@Named("Dao")
	private Dao dao;

	/**
	 * 워크플로우 프로세스 다건 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getWorkflowList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getWorkflowList", paramMap);
	}

	/**
	 * 워크플로우 화면단 프로그램 리스트 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getWorkflowViewPrgList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getWorkflowViewPrgList", paramMap);
	}

	/**
	 *  워크플로우 프로세스 단건 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public Map<?, ?> getWorkflowMap(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return dao.getMap("getWorkflowMap", paramMap);
	}

	/**
	 *  워크플로우 프로그램 단건 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public Map<?, ?> getWorkflowOpenPrgMap(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return dao.getMap("getWorkflowOpenPrgMap", paramMap);
	}

	/**
	 * 워크플로우 권한그룹 팝업 다건 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getWorkflowAuthGrpPopList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getWorkflowAuthGrpPopList", paramMap);
	}

	/**
	 * 워크플로우 하위프로세스 다건 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getWorkflowSubList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getWorkflowSubList", paramMap);
	}

	/**
	 * 워크플로우 프로그램 다건 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getWorkflowPrgList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getWorkflowPrgList", paramMap);
	}

	/**
	 * 워크플로우 저장 Service
	 *
	 * @param convertMap
	 * @return int
	 * @throws Exception
	 */
	public int saveWorkflowList(Map<?, ?> convertMap) throws Exception {
		Log.Debug();
		int cnt=0;
		if( ((List<?>)convertMap.get("deleteRows")).size() > 0){
			cnt += dao.delete("deleteWorkflowList", convertMap);
			cnt += dao.delete("deleteWorkflowSubAll", convertMap);
			cnt += dao.delete("deleteWorkflowPrgAll1", convertMap);
		}
		if( ((List<?>)convertMap.get("mergeRows")).size() > 0){
			cnt += dao.update("saveWorkflowList", convertMap);
		}
		Log.Debug();
		return cnt;
	}

	/**
	 * 워크플로우 권한그룹 저장 Service
	 *
	 * @param convertMap
	 * @return int
	 * @throws Exception
	 */
	public int saveWorkflowAuthGrpPopList(Map<?, ?> convertMap) throws Exception {
		Log.Debug();
		int cnt=0;
		List list = (List)convertMap.get("mergeRows");

		if(list.size() > 0) {
			for(int i = 0, size = list.size(); i < size; i++) {
				Map mp = (Map)list.get(i);
				String chk = (String)mp.get("chk");

				mp.put("ssnEnterCd", convertMap.get("ssnEnterCd"));
				mp.put("ssnSabun", convertMap.get("ssnSabun"));

				if("Y".equals(chk)) {
					cnt += dao.update("insertWorkflowAuthGrpPop", mp);
				} else {
					cnt += dao.delete("deleteWorkflowAuthGrpPop", mp);
				}
			}
		}

		Log.Debug();
		return cnt;
	}

	/**
	 * 워크플로우 하위프로세스 저장 Service
	 *
	 * @param convertMap
	 * @return int
	 * @throws Exception
	 */
	public int saveWorkflowSubList(Map<?, ?> convertMap) throws Exception {
		Log.Debug();
		int cnt=0;
		if( ((List<?>)convertMap.get("deleteRows")).size() > 0){
			cnt += dao.delete("deleteWorkflowSubList", convertMap);
			cnt += dao.delete("deleteWorkflowPrgAll2", convertMap);
		}
		if( ((List<?>)convertMap.get("mergeRows")).size() > 0){
			cnt += dao.update("saveWorkflowSubList", convertMap);
		}
		Log.Debug();
		return cnt;
	}

	/**
	 * 워크플로우 프로그램 저장 Service
	 *
	 * @param convertMap
	 * @return int
	 * @throws Exception
	 */
	public int saveWorkflowPrgList(Map<?, ?> convertMap) throws Exception {
		Log.Debug();
		int cnt=0;
		if( ((List<?>)convertMap.get("deleteRows")).size() > 0){
			cnt += dao.delete("deleteWorkflowPrgList", convertMap);
		}
		if( ((List<?>)convertMap.get("mergeRows")).size() > 0){
			cnt += dao.update("saveWorkflowPrgList", convertMap);
		}
		Log.Debug();
		return cnt;
	}

	public int saveWorkflowContentsEmpty(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return dao.update("saveWorkflowContentsEmpty", paramMap);
	}

	/**
	 * 근로계약서관리 Contents 저장 Service
	 *
	 * @param convertMap
	 * @return int
	 * @throws Exception
	 */
	public int saveWorkflowContents(Map<?, ?> convertMap) throws Exception {
		Log.Debug();
		int cnt = dao.updateClob("saveWorkflowContents", convertMap);
		Log.Debug();
		return cnt;
	}
}
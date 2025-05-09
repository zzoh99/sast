package com.hr.hrm.promotion.promStdMgr;
import java.util.List;
import java.util.Map;
import javax.inject.Inject;
import javax.inject.Named;
import org.springframework.stereotype.Service;
import com.hr.common.dao.Dao;
import com.hr.common.logger.Log;

/**
 * 승진기준관리 Service
 *
 * @author 이름
 *
 */
@Service("PromStdMgrService")
public class PromStdMgrService{

	@Inject
	@Named("Dao")
	private Dao dao;

	/**
	 * 승진기준관리(코드 형태) 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getPromStdCodeList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getPromStdCodeList", paramMap);
	}

	/**
	 *  승진기준관리(기준일) 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public Map<?, ?> getPromStdBaseYmdMap(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return dao.getMap("getPromStdBaseYmdMap", paramMap);
	}

	/**
	 * 승진기준관리 다건 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getPromStdMgrList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getPromStdMgrList", paramMap);
	}

	/**
	 * 승진기준관리 저장 Service
	 *
	 * @param convertMap
	 * @return int
	 * @throws Exception
	 */
	public int savePromStdMgr(Map<?, ?> convertMap) throws Exception {
		Log.Debug();
		int cnt=0;
		if( ((List<?>)convertMap.get("deleteRows")).size() > 0){
			// 승진기준 삭제
			cnt += dao.delete("deletePromStdMgr1", convertMap);
			// 승진년차 삭제
			dao.delete("deletePromStdMgr2", convertMap);
			// 상벌(포상 삭제)
			dao.delete("deletePromStdMgr4", convertMap);
			// 상벌(징계 삭제)
			dao.delete("deletePromStdMgr5", convertMap);
		}
		if( ((List<?>)convertMap.get("mergeRows")).size() > 0){
			cnt += dao.update("savePromStdMgr", convertMap);
		}
		Log.Debug();
		return cnt;
	}

	/**
	 * 승진기준관리(과거기준복사) 프로시저
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public Map prcPromStdMgr(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (Map) dao.excute("prcPromStdMgr", paramMap);
	}

}
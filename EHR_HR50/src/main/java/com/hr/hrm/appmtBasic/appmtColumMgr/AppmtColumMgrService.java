package com.hr.hrm.appmtBasic.appmtColumMgr;
import java.util.List;
import java.util.Map;
import javax.inject.Inject;
import javax.inject.Named;
import org.springframework.stereotype.Service;
import com.hr.common.dao.Dao;
import com.hr.common.logger.Log;

/**
 * 발령항목정의 Service
 *
 * @author 이름
 *
 */
@Service("AppmtColumMgrService")
public class AppmtColumMgrService{

	@Inject
	@Named("Dao")
	private Dao dao;

	/**
	 * 발령항목정의 다건 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getAppmtColumMgrList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getAppmtColumMgrList", paramMap);
	}

	/**
	 * 인사기본사항 다건 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getAppmtCodeMappingList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getAppmtCodeMappingList", paramMap);
	}

	/**
	 * 발령항목정의 저장 Service
	 *
	 * @param convertMap
	 * @return int
	 * @throws Exception
	 */
	public int saveAppmtColumMgr(Map<?, ?> convertMap) throws Exception {
		Log.Debug();
		int cnt=0;
		/*if( ((List<?>)convertMap.get("deleteRows")).size() > 0){
			cnt += dao.delete("deleteAppmtColumMgr", convertMap);
		}*/
		if( ((List<?>)convertMap.get("mergeRows")).size() > 0){
			cnt += dao.update("saveAppmtColumMgr", convertMap);
		}
		Log.Debug();
		return cnt;
	}

	/**
	 * 인사기본사항 매핑 저장 Service
	 *
	 * @param convertMap
	 * @return int
	 * @throws Exception
	 */
	public int saveAppmtCodeMapping(Map<?, ?> convertMap) throws Exception {
		Log.Debug();
		int cnt=0;

		cnt += dao.delete("deleteAppmtCodeMapping", convertMap);

		if( ((List<?>)convertMap.get("mergeRows")).size() > 0){
			cnt += dao.update("saveAppmtCodeMapping", convertMap);
		}
		Log.Debug();
		return cnt;
	}

	/**
	 * 발령항목정의 삭제 Service
	 *
	 * @param paramMap
	 * @return int
	 * @throws Exception
	 */
	public int deleteAppmtColumMgr(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return dao.delete("deleteAppmtColumMgr", paramMap);
	}
}
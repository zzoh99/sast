package com.hr.sys.security.privacyActMgr;
import java.util.List;
import java.util.Map;
import javax.inject.Inject;
import javax.inject.Named;
import org.springframework.stereotype.Service;
import com.hr.common.dao.Dao;
import com.hr.common.logger.Log;
/**
 * 개인정보보호법관리 Service
 *
 * @author CBS
 *
 */
@Service("PrivacyActMgrService")
public class PrivacyActMgrService{
	@Inject
	@Named("Dao")
	private Dao dao;
	/**
	 * 개인정보보호법관리 sheet1 다건 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getPrivacyActMgrSheet1List(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getPrivacyActMgrSheet1List", paramMap);
	}

	/**
	 * 개인정보보호법관리 sheet1 저장 Service
	 *
	 * @param convertMap
	 * @return int
	 * @throws Exception
	 */
	public int savePrivacyActMgrSheet1(Map<?, ?> convertMap) throws Exception {
		Log.Debug();
		int cnt=0;
		if( ((List<?>)convertMap.get("deleteRows")).size() > 0){
			cnt += dao.delete("deletePrivacyActMgrSheet1", convertMap);
		}
		if( ((List<?>)convertMap.get("mergeRows")).size() > 0){
			cnt += dao.update("savePrivacyActMgrSheet1", convertMap);
		}
		Log.Debug();
		return cnt;
	}

	/**
	 * 개인정보보호법관리 sheet1 삭제 Service
	 *
	 * @param paramMap
	 * @return int
	 * @throws Exception
	 */
	public int deletePrivacyActMgrSheet1(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return dao.delete("deletePrivacyActMgrSheet1", paramMap);
	}

	/**
	 * 개인정보보호법관리 미리보기 팝업 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getPrivacyPopupList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getPrivacyPopupList", paramMap);
	}

	/**
	 * 개인정보보호법관리 sheet2 다건 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getPrivacyActMgrSheet2List(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getPrivacyActMgrSheet2List", paramMap);
	}

	/**
	 * 개인정보보호법관리 sheet2 저장 Service
	 *
	 * @param convertMap
	 * @return int
	 * @throws Exception
	 */
	public int savePrivacyActMgrSheet2(Map<?, ?> convertMap) throws Exception {
		Log.Debug();
		int cnt=0;
		if( ((List<?>)convertMap.get("deleteRows")).size() > 0){
			cnt += dao.delete("deletePrivacyActMgrSheet2", convertMap);
		}
		if( ((List<?>)convertMap.get("mergeRows")).size() > 0){
			cnt += dao.update("savePrivacyActMgrSheet2", convertMap);
		}
		Log.Debug();
		return cnt;
	}

	/**
	 * 개인정보보호법관리 sheet2 삭제 Service
	 *
	 * @param paramMap
	 * @return int
	 * @throws Exception
	 */
	public int deletePrivacyActMgrSheet2(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return dao.delete("deletePrivacyActMgrSheet2", paramMap);
	}

}
package com.hr.ben.pension.staPenMgr;
import java.util.List;
import java.util.Map;
import javax.inject.Inject;
import javax.inject.Named;
import org.springframework.stereotype.Service;
import com.hr.common.dao.Dao;
import com.hr.common.logger.Log;

/**
 * 국민연금기본사항 Service
 *
 * @author JM
 *
 */
@Service("StaPenMgrService")
public class StaPenMgrService{
	@Inject
	@Named("Dao")
	private Dao dao;

	/**
	 * 국민연금기본사항 기본사항TAB 단건 조회 Service
	 *
	 * @param paramMap
	 * @return Map
	 * @throws Exception
	 */
	public Map<?, ?> getStaPenMgrBasicMap(Map<?, ?> paramMap) throws Exception {
		Log.Debug();

		return dao.getMap("getStaPenMgrBasicMap", paramMap);
	}

	/**
	 * 국민연금기본사항 변동내역TAB 다건 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getStaPenMgrChangeList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();

		return (List<?>) dao.getList("getStaPenMgrChangeList", paramMap);
	}

	/**
	 * 국민연금기본사항 불입내역TAB 다건 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getStaPenMgrPaymentList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();

		return (List<?>) dao.getList("getStaPenMgrPaymentList", paramMap);
	}

	/**
	 * 국민연금기본사항 기본사항TAB 저장 Service
	 *
	 * @param paramMap
	 * @return int
	 * @throws Exception
	 */
	public int saveStaPenMgrBasic(Map<?, ?> paramMap) throws Exception {
		Log.Debug();

		int cnt = dao.update("saveStaPenMgrBasic", paramMap);

		return cnt;
	}

	/**
	 * 국민연금기본사항 변동내역TAB 저장 Service
	 *
	 * @param convertMap
	 * @return int
	 * @throws Exception
	 */
	public int saveStaPenMgrChange(Map<?, ?> convertMap) throws Exception {
		Log.Debug();

		int cnt=0;
		if( ((List<?>)convertMap.get("deleteRows")).size() > 0){
			cnt += dao.delete("deleteStaPenMgrChange", convertMap);
		}
		if( ((List<?>)convertMap.get("mergeRows")).size() > 0){
			cnt += dao.update("saveStaPenMgrChange", convertMap);
		}

		return cnt;
	}

	/**
	 * 국민연금기본사항 불입내역TAB 저장 Service
	 *
	 * @param convertMap
	 * @return int
	 * @throws Exception
	 */
	public int saveStaPenMgrPayment(Map<?, ?> convertMap) throws Exception {
		Log.Debug();

		int cnt=0;
		if( ((List<?>)convertMap.get("deleteRows")).size() > 0){
			cnt += dao.delete("deleteStaPenMgrPayment", convertMap);
		}
		if( ((List<?>)convertMap.get("mergeRows")).size() > 0){
			cnt += dao.update("saveStaPenMgrPayment", convertMap);
		}

		return cnt;
	}
	/**
	 * 본인부담금 가져오기 Service
	 *
	 * @param paramMap
	 * @return Map
	 * @throws Exception
	 */
	public Map<?, ?> getF_BEN_NP_SELF_MON(Map<?, ?> paramMap) throws Exception {
		Log.Debug();

		return dao.getMap("getF_BEN_NP_SELF_MON", paramMap);
	}
	/**
	 * 본인부담금 가져오기 Service
	 *
	 * @param paramMap
	 * @return Map
	 * @throws Exception
	 */
	public Map<?, ?> getStaPenMgrF_BEN_NP_SELF_MON(Map<?, ?> paramMap) throws Exception {
		Log.Debug();

		return dao.getMap("getStaPenMgrF_BEN_NP_SELF_MON", paramMap);
	}
}
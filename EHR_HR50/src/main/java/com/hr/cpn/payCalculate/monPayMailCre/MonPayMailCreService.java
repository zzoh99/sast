package com.hr.cpn.payCalculate.monPayMailCre;

import com.hr.common.dao.Dao;
import com.hr.common.logger.Log;
import org.springframework.stereotype.Service;

import javax.inject.Inject;
import javax.inject.Named;
import java.util.List;
import java.util.Map;
/**
 * 월급여메일발송 Service
 *
 * @author JSG
 *
 */
@Service("MonPayMailCreService")
public class MonPayMailCreService{

	@Inject
	@Named("Dao")
	private Dao dao;

	/**
	 * 1 다건 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getMonPayMailCreList(Map<String, Object> paramMap) throws Exception {
		Log.Debug();
		String searchSuccessYn = paramMap.get("searchSuccessYn")+"";
		paramMap.put("searchSuccessYn", searchSuccessYn.split(","));
		return (List<?>) dao.getList("getMonPayMailCreList", paramMap);
	}

	/**
	 * 메일생성 데이터 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getMonPayMailCreHTML1(Map<?, ?> paramMap) throws Exception {
		Log.Debug("getMonPayMailCreHTML1 ");
		return (List<?>) dao.getList("getMonPayMailCreHTML1", paramMap);
	}
	/**
	 * 메일생성 데이터 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getMonPayMailCreHTML2(Map<?, ?> paramMap) throws Exception {
		Log.Debug("getMonPayMailCreHTML2 ");
		return (List<?>) dao.getList("getMonPayMailCreHTML2", paramMap);
	}
	/**
	 * 메일생성 데이터 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getMonPayMailCreHTML3(Map<?, ?> paramMap) throws Exception {
		Log.Debug("getMonPayMailCreHTML3 ");
		return (List<?>) dao.getList("getMonPayMailCreHTML3", paramMap);
	}

	/**
	 * 메일발송후 메일시퀀스 업데이트(TCPN203) Service
	 * 
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public int updateMailSeqForTcpn203(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return dao.update("updateMailSeqForTcpn203", paramMap);
	}

	/**
	 * 1 저장 Service
	 *
	 * @param convertMap
	 * @return int
	 * @throws Exception
	 */
	public int saveMonPayMailCre(Map<?, ?> convertMap) throws Exception {
		Log.Debug();
		int cnt=0;
		if( ((List<?>)convertMap.get("deleteRows")).size() > 0){
			cnt += dao.delete("deleteMonPayMailCre", convertMap);
			dao.delete("deleteAppmtUserMgr", convertMap);
		}
		if( ((List<?>)convertMap.get("mergeRows")).size() > 0){
			cnt += dao.update("saveMonPayMailCre", convertMap);
		}
		Log.Debug("saveMonPayMailCre End");
		return cnt;
	}
}
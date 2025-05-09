package com.hr.pap.evaluation.appSelf;
import java.util.List;
import java.util.Map;

import javax.inject.Inject;
import javax.inject.Named;

import org.springframework.stereotype.Service;

import com.hr.common.dao.Dao;
import com.hr.common.logger.Log;
/**
 * 본인평가 Service
 *
 * @author jcy
 *
 */
@Service("AppSelfService")
public class AppSelfService{
	@Inject
	@Named("Dao")
	private Dao dao;

	/**
	 *  본인평가 단건 조회 Service (평가자정보 조회)
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public Map<?, ?> getAppSelfMapAppEmployee(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return dao.getMap("getAppSelfMapAppEmployee", paramMap);
	}

	/**
	 *  본인평가 단건 조회 Service (업적평가 조회)
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public Map<?, ?> getAppSelfMap1(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return dao.getMap("getAppSelfMap1", paramMap);
	}

	/**
	 * 본인평가 저장 Service(첨부파일 저장)
	 *
	 * @param convertMap
	 * @return int
	 * @throws Exception
	 */
	public int saveAppAttFile(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		int cnt=0;

		cnt += dao.update("saveAppAttFile", paramMap);

		Log.Debug();
		return cnt;
	}

	/**
	 * 본인평가 저장 -  - (평가완료)
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public Map prcAppSelf1(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (Map) dao.excute("prcAppSelf1", paramMap);
	}

	/**
	 * 본인평가 저장 -  - (평가완료)
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public Map prcAppSelf2(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (Map) dao.excute("prcAppSelf2", paramMap);
	}

	/**
	 * 반려의견 저장
	 * @param paramMap
	 * @return
	 * @throws Exception
	 */
	public int saveAppSelfReturnComment(Map<String, Object> paramMap) throws Exception {
		Log.Debug();
		int cnt=0;
		cnt += dao.update("saveAppSelfReturnComment", paramMap);
		Log.Debug();
		return cnt;
	}


	/**
	 * 반려 처리
	 * @param paramMap
	 * @return
	 * @throws Exception
	 */
	public Map saveAppSelfReturnStatus(Map<String, Object> paramMap) throws Exception {
		Log.Debug();
		return (Map) dao.excute("saveAppSelfReturnStatus", paramMap);
	}
}
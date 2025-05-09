package com.hr.pap.progress.appStatusMgr;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.inject.Inject;
import javax.inject.Named;

import org.springframework.stereotype.Service;

import com.hr.common.dao.Dao;
import com.hr.common.logger.Log;
/**
 * 평가진행상태관리 Service
 *
 * @author JCY
 *
 */
@Service("AppStatusMgrService")
public class AppStatusMgrService{
	@Inject
	@Named("Dao")
	private Dao dao;


	/**
	 * 평가진행상태관리 -취소 팝업- 다건 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getAppStatusMgrPopList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getAppStatusMgrPopList", paramMap);
	}



	/**
	 *  평가진행상태관리 단건 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public Map<?, ?> getAppStatusMgrMap(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return dao.getMap("getAppStatusMgrMap", paramMap);
	}
	/**
	 * 평가진행상태관리 저장 Service
	 *
	 * @param convertMap
	 * @return int
	 * @throws Exception
	 */
	public int saveAppStatusMgr(Map<?, ?> convertMap) throws Exception {
		Log.Debug();
		int cnt=0;
		cnt += dao.update("saveAppStatusMgr", convertMap);
		Log.Debug();
		return cnt;
	}

	/**
	 * 평가진행상태관리 팝업 저장 Service
	 *
	 * @param convertMap
	 * @return int
	 * @throws Exception
	 */
	public int saveAppStatusMgrPop(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		int cnt=0;

		String appraisalCds = (String)paramMap.get("searchAppraisalCds");
		String appOrgCds = (String)paramMap.get("searchAppOrgCds");
		String appStepCds = (String)paramMap.get("searchAppStepCds");
		String sabuns = (String)paramMap.get("searchSabuns");

		String[] arrAppraisalCd = appraisalCds.split(",");
		String[] arrAppOrgCd = appOrgCds.split(",");
		String[] arrAppStepCd = appStepCds.split(",");
		String[] arrSabun = sabuns.split(",");

		for(int i = 0; i < arrAppraisalCd.length; i++) {
			Map mp = new HashMap();

			mp.put("ssnEnterCd", paramMap.get("ssnEnterCd"));
			mp.put("ssnSabun", paramMap.get("ssnSabun"));
			mp.put("searchAppraisalCd", arrAppraisalCd[i]);
			mp.put("searchAppOrgCd", arrAppOrgCd[i]);
			mp.put("searchAppStepCd", arrAppStepCd[i]);
			mp.put("searchSabun", arrSabun[i]);
			mp.put("appStatusCd", paramMap.get("appStatusCd"));

			Map map = (Map)dao.excute("prcAppStatusMgr", mp);

			if (map.get("sqlCode") == null) {
				cnt ++;
			}

		}

		Log.Debug();
		return cnt;
	}


}
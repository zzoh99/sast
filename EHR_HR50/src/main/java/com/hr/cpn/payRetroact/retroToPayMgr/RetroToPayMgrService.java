package com.hr.cpn.payRetroact.retroToPayMgr;
import java.util.List;
import java.util.Map;

import javax.inject.Inject;
import javax.inject.Named;

import org.springframework.stereotype.Service;

import com.hr.common.dao.Dao;
import com.hr.common.logger.Log;

/**
 * 소급결과급여반영 Service
 *
 * @author JM
 *
 */
@Service("RetroToPayMgrService")
public class RetroToPayMgrService{
	@Inject
	@Named("Dao")
	private Dao dao;

	/**
	 * 소급결과급여반영 다건 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getRetroToPayMgrList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();

		return (List<?>) dao.getList("getRetroToPayMgrList", paramMap);
	}

	/**
	 * 소급결과급여반영 급여반영
	 *
	 * @param paramMap
	 * @return int
	 * @throws Exception
	 */
	public Map prcP_CPN_RE_CAL_TO_PAY_APPLY(Map<?, ?> paramMap) throws Exception {
		Log.Debug();

		return (Map) dao.excute("RetroToPayMgrP_CPN_RE_CAL_TO_PAY_APPLY", paramMap);
	}

	/**
	 * 소급결과급여반영 급여반영취소
	 *
	 * @param paramMap
	 * @return int
	 * @throws Exception
	 */
	public Map prcP_CPN_RE_CAL_TO_PAY_CANCEL(Map<?, ?> paramMap) throws Exception {
		Log.Debug();

		return (Map) dao.excute("RetroToPayMgrP_CPN_RE_CAL_TO_PAY_CANCEL", paramMap);
	}

    public List<?> getRetroToPayMgrPriorList(Map<?, ?> paramMap) throws Exception {
        Log.Debug();

        return (List<?>) dao.getList("getRetroToPayMgrPriorList", paramMap);
    }

    public int saveRetroToPayMgrPriorList(Map convertMap) throws Exception {
        Log.Debug();
        int cnt = 0;
        if (((List<?>)convertMap.get("deleteRows")).size() > 0){
            cnt += dao.delete("deleteRetroToPayMgrPriorList", convertMap);
        }
        if (((List<?>)convertMap.get("mergeRows")).size() > 0){
            cnt += dao.update("saveRetroToPayMgrPriorList", convertMap);
        }

        return cnt;
    }
}
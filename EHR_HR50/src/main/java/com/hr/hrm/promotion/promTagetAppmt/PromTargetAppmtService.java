package com.hr.hrm.promotion.promTagetAppmt;
import java.util.List;
import java.util.Map;

import javax.inject.Inject;
import javax.inject.Named;

import org.springframework.stereotype.Service;

import com.hr.common.dao.Dao;
import com.hr.common.logger.Log;

/**
 * 승진대상자품의처리 Service
 *
 * @author bckim
 *
 */
@Service("PromTargetAppmtService")
public class PromTargetAppmtService{

	@Inject
	@Named("Dao")
	private Dao dao;

	/**
	 * 승진대상자품의처리 수정 Service
	 *
	 * @param paramMap
	 * @return int
	 * @throws Exception
	 */
	public int updatePromTargetAppmt(Map<?, ?> paramMap) throws Exception {
		Log.Debug();

		int cnt = 0;
		List<?> list = (List<?>)paramMap.get("mergeRows");

		if(list != null && list.size() > 0) {
			for(int i = 0; i < list.size(); i++) {
				Map<String,Object> mp = (Map<String,Object>)list.get(i);
				mp.put("ssnEnterCd", (String)paramMap.get("ssnEnterCd"));
				mp.put("ssnSabun", (String)paramMap.get("ssnSabun"));

				cnt += dao.update("updatePromTargetAppmt", mp);
			}
		}

		return cnt;
	}

	/**
	 * 승진대상자품의처리(품의번호적용) 프로시저
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public Map prcPromTargetAppmt(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (Map) dao.excute("prcPromTargetAppmt", paramMap);
	}

}
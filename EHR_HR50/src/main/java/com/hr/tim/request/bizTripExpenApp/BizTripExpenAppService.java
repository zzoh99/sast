package com.hr.tim.request.bizTripExpenApp;
import java.util.List;
import java.util.Map;
import javax.inject.Inject;
import javax.inject.Named;
import org.springframework.stereotype.Service;

import com.hr.common.dao.Dao;
import com.hr.common.logger.Log;

/**
 * 출장보고서 Service
 *
 * @author EW
 *
 */
@Service("BizTripExpenAppService")
public class BizTripExpenAppService{

	@Inject
	@Named("Dao")
	private Dao dao;

	/**
	 * getBizTripExpenAppList 다건 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getBizTripExpenAppList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getBizTripExpenAppList", paramMap);
	}
	
	
	/**
	 * 출장보고서 삭제
	 *
	 * @param convertMap
	 * @return int
	 * @throws Exception
	 */
	public int deleteBizTripExpenApp(Map<?, ?> convertMap) throws Exception {
		Log.Debug();
		int cnt=0;
		if( ((List<?>)convertMap.get("deleteRows")).size() > 0){
			cnt += dao.delete("deleteBizTripExpenApp", convertMap);
			dao.delete("deleteBizTripExpenApp2", convertMap);
			dao.delete("deleteBizTripExpenApp3", convertMap);
			dao.delete("deleteBizTripExpenApp4", convertMap);
			dao.delete("deleteApprovalMgrMaster", convertMap);
			dao.delete("deleteApprovalMgrAppLine", convertMap);
		}

		return cnt;
	}
}

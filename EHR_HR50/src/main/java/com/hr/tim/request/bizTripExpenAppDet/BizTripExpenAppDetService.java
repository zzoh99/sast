package com.hr.tim.request.bizTripExpenAppDet;
import java.util.List;
import java.util.Map;
import javax.inject.Inject;
import javax.inject.Named;

import org.springframework.stereotype.Service;

import com.hr.common.dao.Dao;
import com.hr.common.logger.Log;
import com.hr.common.util.ParamUtils;

/**
 * 출장보고서 Service
 *
 * @author EW
 *
 */
@Service("BizTripExpenAppDetService")
public class BizTripExpenAppDetService{

	@Inject
	@Named("Dao")
	private Dao dao;

	/**
	 * 출장보고서 신청 저장
	 *
	 * @param convertMap
	 * @return int
	 * @throws Exception
	 */
	public int saveBizTripExpenAppDet(Map<?, ?> convertMap) throws Exception {
		Log.Debug();
		int cnt=1;
		if( ((List<?>)convertMap.get("mergeRows")).size() > 0){
			cnt += dao.delete("deleteBizTripExpenAppDet2", convertMap);
			cnt += dao.delete("deleteBizTripExpenAppDet3", convertMap);
			cnt += dao.delete("deleteBizTripExpenAppDet4", convertMap);

			cnt += dao.update("saveBizTripExpenAppDet1", convertMap);

			ParamUtils.mergeParams(convertMap, (List<Map<String, Object>>)convertMap.get("mergeRows"));
			dao.batchUpdate("saveBizTripExpenAppDet2", (List<Map<?,?>>)convertMap.get("mergeRows"));
			dao.batchUpdate("saveBizTripExpenAppDet3", (List<Map<?,?>>)convertMap.get("mergeRows"));
			dao.batchUpdate("saveBizTripExpenAppDet4", (List<Map<?,?>>)convertMap.get("mergeRows"));
			
			
			//cnt += dao.update("saveBizTripExpenAppDet1", convertMap);
			//cnt += dao.update("saveBizTripExpenAppDet2", convertMap);
			//cnt += dao.update("saveBizTripExpenAppDet3", convertMap);
			//cnt += dao.update("saveBizTripExpenAppDet4", convertMap);
		}

		return cnt;
	}

}

package com.hr.tim.request.bizTripAppDet;
import java.util.List;
import java.util.Map;
import javax.inject.Inject;
import javax.inject.Named;

import org.springframework.stereotype.Service;

import com.hr.common.dao.Dao;
import com.hr.common.logger.Log;
import com.hr.common.util.ParamUtils;

/**
 * 해외출장신청/보고서 Service
 *
 * @author EW
 *
 */
@Service("BizTripAppDetService")
public class BizTripAppDetService{

	@Inject
	@Named("Dao")
	private Dao dao;

	/**
	 * 해외출장신청/보고서 신청 저장
	 *
	 * @param convertMap
	 * @return int
	 * @throws Exception
	 */
	public int saveBizTripAppDet(Map<?, ?> convertMap) throws Exception {
		Log.Debug();
		int cnt=1;
		if( ((List<?>)convertMap.get("mergeRows")).size() > 0){
			cnt += dao.delete("deleteBizTripAppDet2", convertMap);
			cnt += dao.delete("deleteBizTripAppDet3", convertMap);
			cnt += dao.delete("deleteBizTripAppDet4", convertMap);

			cnt += dao.update("saveBizTripAppDet1", convertMap);

			ParamUtils.mergeParams(convertMap, (List<Map<String, Object>>)convertMap.get("mergeRows"));
			dao.batchUpdate("saveBizTripAppDet2", (List<Map<?,?>>)convertMap.get("mergeRows"));
			dao.batchUpdate("saveBizTripAppDet3", (List<Map<?,?>>)convertMap.get("mergeRows"));
			dao.batchUpdate("saveBizTripAppDet4", (List<Map<?,?>>)convertMap.get("mergeRows"));
			
			
			//cnt += dao.update("saveBizTripAppDet1", convertMap);
			//cnt += dao.update("saveBizTripAppDet2", convertMap);
			//cnt += dao.update("saveBizTripAppDet3", convertMap);
			//cnt += dao.update("saveBizTripAppDet4", convertMap);
		}

		return cnt;
	}

}

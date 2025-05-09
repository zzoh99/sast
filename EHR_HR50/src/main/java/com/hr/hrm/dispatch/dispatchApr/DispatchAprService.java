package com.hr.hrm.dispatch.dispatchApr;

import java.util.List;
import java.util.Map;

import javax.inject.Inject;
import javax.inject.Named;

import org.springframework.stereotype.Service;

import com.hr.common.dao.Dao;
import com.hr.common.logger.Log;

@Service("DispatchAprService")
public class DispatchAprService{

	@Inject
	@Named("Dao")
	private Dao dao;

	public int updateDispatchApr(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		int cnt=0;
		
		// 파견신청
		cnt += dao.update("updateDispatchAprFirst", paramMap);
		
		// THRI103 신청서마스터
		cnt += dao.update("updateDispatchAprSecond", paramMap);
		
		Log.Debug();
		return cnt;
	}

	public int saveDispatchAprOrd(Map<?, ?> convertMap) throws Exception {
		Log.Debug();

		int cnt=0;
		if( ((List<?>)convertMap.get("deleteRows")).size() > 0){
			cnt += dao.delete("deleteExecAppmt", convertMap);
		}

		List<Map<String,Object>> updateList = (List<Map<String,Object>>)convertMap.get("updateRows");

		if( updateList.size() > 0){
			for(Map<String,Object> mp : updateList) {

				if("1".equals(mp.get("chkBx"))) {
					mp.put("ssnEnterCd", convertMap.get("ssnEnterCd") );
					mp.put("ssnSabun", convertMap.get("ssnSabun") );

					cnt += dao.update("saveDispatchAprOrd", mp);
				}
			}
		}

		return cnt;
	}

}
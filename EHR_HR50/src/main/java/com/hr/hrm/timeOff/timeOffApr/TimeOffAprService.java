package com.hr.hrm.timeOff.timeOffApr;

import java.util.List;
import java.util.Map;

import javax.inject.Inject;
import javax.inject.Named;

import org.springframework.stereotype.Service;

import com.hr.common.dao.Dao;
import com.hr.common.logger.Log;

@Service("TimeOffAprService")
public class TimeOffAprService{

	@Inject
	@Named("Dao")
	private Dao dao;

	public int saveTimeOffAprOrd(Map<?, ?> convertMap) throws Exception {
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

					cnt += dao.update("saveTimeOffAprOrd", mp);
					
					if("C01".equals(mp.get("ordDetailCd")) && mp.get("famres") != null && ((String)mp.get("famres")).length() > 0) {
						dao.update("saveExecAppmt4", mp);
					}
					
				}
			}
		}

		return cnt;
	}
	
	public int saveTimeOffAprTHRM229(Map<?, ?> convertMap) throws Exception {
		Log.Debug();

		int cnt=0;
		List<Map<String,Object>> updateList = (List<Map<String,Object>>)convertMap.get("mergeRows");

		if( updateList.size() > 0){
			for(Map<String,Object> mp : updateList) {

				
				mp.put("ssnEnterCd", convertMap.get("ssnEnterCd") );
				mp.put("ssnSabun", convertMap.get("ssnSabun") );
					
				if("C01".equals(mp.get("ordDetailCd")) && mp.get("famres") != null && ((String)mp.get("famres")).length() > 0) {
					cnt = dao.update("saveExecAppmt4", mp);
				}
					
			}
		}

		return cnt;
	}

    public List<?> getTimeOffAprApplCodeList(Map<?, ?> paramMap) throws Exception {
        Log.Debug();
        return (List<?>) dao.getList("getTimeOffAprApplCodeList", paramMap);
    }

    public List<?> getApplStatusCdList(Map<?, ?> paramMap) throws Exception {
        Log.Debug();
        return (List<?>) dao.getList("getApplStatusCdList", paramMap);
    }

    public List<?> getTimeOffAprList(Map<?, ?> paramMap) throws Exception {
        Log.Debug();
        return (List<?>) dao.getList("getTimeOffAprList", paramMap);
    }
}
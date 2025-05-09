package com.hr.hrm.timeOff.timeOffApp;

import java.util.List;
import java.util.Map;

import javax.inject.Inject;
import javax.inject.Named;

import org.springframework.stereotype.Service;

import com.hr.common.dao.Dao;
import com.hr.common.exception.HrException;
import com.hr.common.logger.Log;

@Service("TimeOffAppService") 
public class TimeOffAppService{
 
	@Inject
	@Named("Dao")
	private Dao dao;
	
	public int saveTimeOffApp(Map<?, ?> convertMap) throws Exception {
		Log.Debug();
		int cnt=0;
		if( ((List<?>)convertMap.get("deleteRows")).size() > 0){
			cnt += dao.delete("deleteTimeOffApp", convertMap);
			
			//THRI103삭제
			cnt += dao.delete("deleteApprovalMgrMaster", convertMap);
			
			//THRI107삭제
			cnt += dao.delete("deleteApprovalMgrAppLine", convertMap);
		}
		Log.Debug();
		return cnt;
	}
	
	//육아
	public int saveTimeOffAppPatDet(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		int cnt=dao.update("saveTimeOffAppPatDet", paramMap);
		Log.Debug();
		return cnt;
	}
	public Map getTimeOffAppDateValideCnt(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return dao.getMap("getTimeOffAppDateValideCnt", paramMap);
	}

	//가족돌봄
	public int saveTimeOffAppFamDet(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		int cnt=dao.update("saveTimeOffAppPatDet", paramMap);
		Log.Debug();
		return cnt;
	}
	
	//복직
	public int saveTimeOffAppReturnWorkAppDet(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		int cnt=dao.update("saveTimeOffAppReturnWorkAppDet", paramMap);
		Log.Debug();
		return cnt;
	}
	
	
	//일반
	public int saveTimeOffAppDet(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		int cnt=dao.update("saveTimeOffAppDet", paramMap);
		Log.Debug();
		return cnt;
	}
	
	/**
	 * 서명데이타 저장 Service
	 *
	 * @param paramMap
	 * @return int
	 * @throws Exception
	 */
	public int saveTimeOffAppSignData(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		int cnt = dao.update("saveTimeOffAppSignData", paramMap);
		Log.Debug();
		return cnt;
	}
	
	/**
	 * 서명데이타 저장 후 동의 처리 Service
	 *
	 * @param paramMap
	 * @return int
	 * @throws Exception
	 */
	public int saveTimeOffAppProcCall(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		int cnt=0;
		Map prcRtn = (Map) dao.excute("saveTimeOffAppProcCall",paramMap);
		Log.Debug("##########################"+prcRtn.toString());
		Object outCode		= prcRtn.get("outCode");
		Object outErrorMsg	= prcRtn.get("outErrorMsg");
		if(null == outCode){
			cnt++;
		}else{
			cnt = -1;
			throw new HrException(outErrorMsg.toString());
		}
		
		Log.Debug();
		return cnt;
	}

	/**
	 * getTimeOffAppList 다건 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getTimeOffAppList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getTimeOffAppList", paramMap);
	}

    public List<?> getTimeOffAppApplCodeList(Map<?, ?> paramMap) throws Exception {
        Log.Debug();
        return (List<?>) dao.getList("getTimeOffAppApplCodeList", paramMap);
    }

    public List<?> getTimeOffAppPatDetFamCodeList(Map<?, ?> paramMap) throws Exception {
        Log.Debug();
        return (List<?>) dao.getList("getTimeOffAppPatDetFamCodeList", paramMap);
    }

    public Map<?, ?> getTimeOffAppPatDetSaveMap(Map<?, ?> paramMap) throws Exception {
        Log.Debug();
        Map<?, ?> resultMap = dao.getMap("getTimeOffAppPatDetSaveMap", paramMap);
        Log.Debug();
        return resultMap;
    }

    public Map<?, ?> getTimeOffTypeTermMap(Map<?, ?> paramMap) throws Exception {
        Log.Debug();
        Map<?, ?> resultMap = dao.getMap("getTimeOffTypeTermMap", paramMap);
        Log.Debug();
        return resultMap;
    }

    public Map<?, ?> getTimeOffAppPatDetEmpYmdMap(Map<?, ?> paramMap) throws Exception {
        Log.Debug();
        Map<?, ?> resultMap = dao.getMap("getTimeOffAppPatDetEmpYmdMap", paramMap);
        Log.Debug();
        return resultMap;
    }

    public List<?> getTimeOffAppPatDetList(Map<?, ?> paramMap) throws Exception {
        Log.Debug();
        return (List<?>) dao.getList("getTimeOffAppPatDetList", paramMap);
    }

    public Map<?, ?> getTimeOffAppMap(Map<?, ?> paramMap) throws Exception {
        Log.Debug();
        Map<?, ?> resultMap = dao.getMap("getTimeOffAppMap", paramMap);
        Log.Debug();
        return resultMap;
    }

    public Map<?, ?> getStatusCd(Map<?, ?> paramMap) throws Exception {
        Log.Debug();
        Map<?, ?> resultMap = dao.getMap("getStatusCd", paramMap);
        Log.Debug();
        return resultMap;
    }

    public Map<?, ?> getTimeOffAppDetSumMap(Map<?, ?> paramMap) throws Exception {
        Log.Debug();
        Map<?, ?> resultMap = dao.getMap("getTimeOffAppDetSumMap", paramMap);
        Log.Debug();
        return resultMap;
    }

    public Map<?, ?> getTimeOffAppReturnWorkAppDetSaveMap(Map<?, ?> paramMap) throws Exception {
        Log.Debug();
        Map<?, ?> resultMap = dao.getMap("getTimeOffAppReturnWorkAppDetSaveMap", paramMap);
        Log.Debug();
        return resultMap;
    }

    public List<?> getTimeOffAppFamDetList(Map<?, ?> paramMap) throws Exception {
        Log.Debug();
        return (List<?>) dao.getList("getTimeOffAppFamDetList", paramMap);
    }

	public List<?> getTimeOffAppFamDetFamCodeList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getTimeOffAppFamDetFamCodeList", paramMap);
	}

	public Map<?, ?> getTimeOffAppReturnWorkAppDetMap(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		Map<?, ?> resultMap = dao.getMap("getTimeOffAppReturnWorkAppDetMap", paramMap);
		return resultMap;
	}


}
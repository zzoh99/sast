package com.hr.ben.longWork.longWorkPersonMgr;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.inject.Inject;
import javax.inject.Named;

import org.springframework.stereotype.Service;

import com.hr.common.dao.Dao;
import com.hr.common.exception.HrException;
import com.hr.common.logger.Log;

/**
 * 근속포상대상자관리 Service
 *
 * @author EW
 *
 */
@Service("LongWorkPersonMgrService")
public class LongWorkPersonMgrService{

	@Inject
	@Named("Dao")
	private Dao dao;

	/**
	 * 근속포상대상자관리 다건 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getLongWorkPersonMgrList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getLongWorkPersonMgrList", paramMap);
	}

	 
	/**
	 * 근속포상대상자관리 단건 조회 Service
	 *
	 * @param paramMap
	 * @return Map
	 * @throws Exception
	 */
	public Map<?, ?> getLongWorkPersonMgrMap(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		Map<?, ?> resultMap = dao.getMap("getLongWorkPersonMgrMap", paramMap);
		Log.Debug();
		return resultMap;
	}

	
	/**
	 * 근속포상대상자 생성 프로시저
	 *
	 * @param paramMap
	 * @return Map
	 * @throws Exception
	 */
	public Map prcP_HRM_LONG_WORK_PERSON_CREATE(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (Map) dao.excute("prcP_HRM_LONG_WORK_PERSON_CREATE", paramMap);
	}	
	
	/**
	 * 근속포상대상자 확정 프로시저
	 *
	 * @param paramMap
	 * @return Map
	 * @throws Exception
	 */
	public Map prcP_HRM_LONG_WORK_PERSON_CONFIRM(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (Map) dao.excute("prcP_HRM_LONG_WORK_PERSON_CONFIRM", paramMap);
	}		
	
	/**
	 * 근속포상대상자 확정 취소 프로시저
	 *
	 * @param paramMap
	 * @return Map
	 * @throws Exception
	 */
	public Map prcP_HRM_LONG_WORK_PERSON_CANCEL(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (Map) dao.excute("prcP_HRM_LONG_WORK_PERSON_CANCEL", paramMap);
	}
	
	
	/**
	 * 근속포상대상자 확정
	 *
	 * @param convertMap
	 * @return Map
	 * @throws Exception
	 */
	
	public int prcConfirmLongWorkPersonMgr(Map convertMap) throws Exception {
		Log.Debug();
		int cnt=0;
		List procDataList 	= (List) convertMap.get("updateRows");
		Log.Debug(convertMap.toString());
		Log.Debug("procDataList Size : "+procDataList.size());
		Map procData		= new HashMap();
		for(int i=0; i<procDataList.size(); i++){
			Map tempData = (Map) procDataList.get(i);
			procData.put("ssnEnterCd",		convertMap.get("ssnEnterCd"));
			procData.put("searchBasicYyyy",	tempData.get("basicYyyy") );
			procData.put("searchPrizeCd",	tempData.get("prizeCd"));
			procData.put("searchSabun",	tempData.get("sabun"));
			procData.put("ssnSabun",		convertMap.get("ssnSabun"));
			
			Map prcRtn = (Map) dao.excute("prcP_HRM_LONG_WORK_PERSON_CONFIRM",procData);
			Log.Debug(prcRtn.toString());
			
			Object outCode		= prcRtn.get("outCode");
			Object outErrorMsg	= prcRtn.get("outErrorMsg");
			if(null == outCode){
				cnt++;
			}else{
				cnt = -1;
				throw new HrException(outErrorMsg.toString());
			}
		}
		Log.Debug();
		return cnt;
	}
	
	/**
	 * 근속포상대상자 취소
	 *
	 * @param convertMap
	 * @return Map
	 * @throws Exception
	 */
	public int prcCancelLongWorkPersonMgr(Map convertMap) throws Exception {
		Log.Debug();
		int cnt=0;
		List procDataList 	= (List) convertMap.get("updateRows");
		Log.Debug(convertMap.toString());
		Log.Debug("procDataList Size : "+procDataList.size());
		Map procData		= new HashMap();
		for(int i=0; i<procDataList.size(); i++){
			Map tempData = (Map) procDataList.get(i);
			procData.put("ssnEnterCd",		convertMap.get("ssnEnterCd"));
			procData.put("searchBasicYyyy",	tempData.get("basicYyyy") );
			procData.put("searchPrizeCd",	tempData.get("prizeCd"));
			procData.put("searchSabun",	tempData.get("sabun"));
			procData.put("ssnSabun",		convertMap.get("ssnSabun"));
			
			Map prcRtn = (Map) dao.excute("prcP_HRM_LONG_WORK_PERSON_CANCEL",procData);
			Log.Debug(prcRtn.toString());
			
			Object outCode		= prcRtn.get("outCode");
			Object outErrorMsg	= prcRtn.get("outErrorMsg");
			if(null == outCode){
				cnt++;
			}else{
				cnt = -1;
				throw new HrException(outErrorMsg.toString());
			}
		}
		Log.Debug();
		return cnt;
	}

    public int saveLongWorkPersonMgr(Map convertMap) throws Exception {
        Log.Debug();
        int cnt = 0;
        if (((List<?>)convertMap.get("deleteRows")).size() > 0){
            cnt += dao.delete("deleteLongWorkPersonMgr", convertMap);
        }
        if (((List<?>)convertMap.get("mergeRows")).size() > 0){
            cnt += dao.update("saveLongWorkPersonMgr", convertMap);
        }

        return cnt;
    }

    public Map<?, ?> getLongWorkPersonMgrWorkYear(Map<?, ?> paramMap) throws Exception {
        Log.Debug();
        Map<?, ?> resultMap = dao.getMap("getLongWorkPersonMgrWorkYear", paramMap);
        Log.Debug();
        return resultMap;
    }
}

package com.hr.hri.applyApproval.appBeforeLst;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.inject.Inject;
import javax.inject.Named;

import org.springframework.stereotype.Service;

import com.hr.common.dao.Dao;
import com.hr.common.exception.HrException;
import com.hr.common.logger.Log;

@Service("AppBeforeLstService") 
public class AppBeforeLstService{
 
	@Inject
	@Named("Dao")
	private Dao dao;

	public List<?> getAppBeforeLstList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>)dao.getList("getAppBeforeLstList", paramMap);
	}
	public List<?> getAppBeforeLstApplCdList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>)dao.getList("getAppBeforeLstApplCdList", paramMap);
	}
	
	public int saveAppBeforeLst(Map<?, ?> convertMap) throws Exception {
		Log.Debug();
		int cnt = 0;
		
		Map<?, ?> agtimemap = dao.getMap("getAgreeDateMap", convertMap);
		String agreeTime = agtimemap != null && agtimemap.get("agreeTime") != null ? agtimemap.get("agreeTime").toString():null;
		List<?> procDataList 	= (List<?>) convertMap.get("updateRows");
		Log.Debug(convertMap.toString());
		Log.Debug("procDataList Size : {}", procDataList.size());
		Map<String, Object> procData = new HashMap<>();
		for(int i=0; i<procDataList.size(); i++){
			Map<?, ?> tempData = (Map<?, ?>) procDataList.get(i);
			procData.put("ssnEnterCd",		convertMap.get("ssnEnterCd"));
			procData.put("searchApplSabun",	tempData.get("applSabun"));
			procData.put("searchApplSeq",	tempData.get("applSeq") );
			procData.put("searchApplCd",	tempData.get("applCd"));
			procData.put("ssnSabun",		convertMap.get("ssnSabun"));
			procData.put("agreeSeq",		tempData.get("agreeSeq"));
			procData.put("agreeGubun",		tempData.get("gubun"));
			procData.put("agreeTime",		agreeTime);
			procData.put("agreeUserMemo",	convertMap.get("agreeUserMemo"));
			procData.put("ssnSabun",		convertMap.get("ssnSabun"));
			Map<?, ?> prcRtn = (Map<?, ?>) dao.excute("prcAppBeforeLstProcCall",procData);
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
	 * 일괄결재 프로시저
	 *
	 * @param paramMap
	 * @return Map
	 * @throws Exception
	 */
	public Map prcAppBeforeLstProcCall(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (Map) dao.excute("prcAppBeforeLstProcCall", paramMap);
	}
}
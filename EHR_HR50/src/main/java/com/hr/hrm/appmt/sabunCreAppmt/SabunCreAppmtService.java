package com.hr.hrm.appmt.sabunCreAppmt;
import java.util.List;
import java.util.Map;

import javax.inject.Inject;
import javax.inject.Named;

import org.springframework.stereotype.Service;

import com.hr.common.dao.Dao;
import com.hr.common.logger.Log;

/**
 * 사번생성/가발령 Service
 *
 * @author bckim
 *
 */
@Service("SabunCreAppmtService")
public class SabunCreAppmtService{

	@Inject
	@Named("Dao")
	private Dao dao;

	/**
	 * 사번생성/가발령 저장 Service
	 *
	 * @param convertMap
	 * @return int
	 * @throws Exception
	 */
	public int saveSabunCreAppmt(Map<?, ?> convertMap) throws Exception {
		Log.Debug();
		
		List<Map<String,Object>> updateList = (List<Map<String,Object>>)convertMap.get("updateRows");
		
		int cnt=0;
		if( updateList.size() > 0){
			for(Map<String,Object> mp : updateList) {
				String prePostYn = (String)mp.get("prePostYn");
				mp.put("ssnEnterCd", convertMap.get("ssnEnterCd") );
				mp.put("ssnSabun", convertMap.get("ssnSabun") );
				//중복체크는 화면단에서 함 by JSG Order CBS
				//Map<String,Object> dupMap = (Map<String,Object>)dao.getMap("getSabunCreAppmtCnt",mp);
				
				if("1".equals(prePostYn) /*and Integer.parseInt(dupMap.get("cnt").toString()) == 0*/) {
					dao.update("updateSabunCreAppmt", mp);
					cnt += dao.create("insertSabunCreAppmt", mp);
				} else {
					cnt += dao.update("updateSabunCreAppmt", mp);
				}
			}
		}

		Log.Debug();
		return cnt;
	}

	/**
	 * 사번생성/가발령 사번생성 Service
	 *
	 * @param convertMap
	 * @return int
	 * @throws Exception
	 */
	public int saveSabunCreAppmtSabunCre(Map<?, ?> convertMap) throws Exception {
		Log.Debug();

		List<Map<String,Object>> updateList = (List<Map<String,Object>>)convertMap.get("updateRows");

		int cnt=0;
		if( updateList.size() > 0){
			for(Map<String,Object> mp : updateList) {
				mp.put("ssnEnterCd", convertMap.get("ssnEnterCd") );
				mp.put("ssnSabun", convertMap.get("ssnSabun") );

				cnt += dao.update("updateSabunCreAppmtSabunCre", mp);
			}
		}

		Log.Debug();
		return cnt;
	}
	/**
	 * 발령처리 프로시저
	 *
	 * @param paramMap
	 * @return Map
	 * @throws Exception
	 */
	public Map prcSabunCreAppmtSave(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (Map) dao.excute("prcSabunCreAppmtSave", paramMap);
	}
}
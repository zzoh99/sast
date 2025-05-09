package com.hr.ben.etc.sealMgr;

import com.hr.common.com.ComService;
import com.hr.common.com.ComUtilService;
import com.hr.common.dao.Dao;
import com.hr.common.exception.HrException;
import com.hr.common.logger.Log;
import org.springframework.stereotype.Service;

import javax.inject.Inject;
import javax.inject.Named;
import java.util.List;
import java.util.Map;
/**
 * 인장현황관리 Service
 * 
 * @author 이름
 *
 */
@Service("SealMgrService")  
public class SealMgrService extends ComUtilService{
	@Inject
	@Named("Dao")
	private Dao dao;

	@Inject
	@Named("ComService")
	private ComService comService;

	/**
	 *  인장담당자 저장 Service
	 *
	 * @param convertMap
	 * @return int
	 * @throws Exception
	 */
	public int saveSealMgrMng(Map<?, ?> convertMap) throws Exception {
		Log.Debug();
		int cnt=0;
		
		if( ((List<?>)convertMap.get("deleteRows")).size() > 0){
			cnt += dao.delete("deleteSealMgrMng", convertMap);
		}
		int dupCnt = comService.getDupCnt(convertMap);
		//중복데이터 존재함.
		if( dupCnt > 0 ) {
			throw new HrException("중복체크 시 오류가 발생 했습니다."); 
		}

		
		if( ((List<?>)convertMap.get("mergeRows")).size() > 0){
			cnt += dao.update("saveSealMgrMng", convertMap);
		}

		//EDATE 자동생성 2020.06.03 
		prcComEdateCreate(convertMap, "TBEN743", "orgCd", "seq", "gubun");
		

		return cnt;
	}
	

	
}
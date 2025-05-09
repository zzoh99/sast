package com.hr.cpn.payRetire.sepEleMgr;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.inject.Inject;
import javax.inject.Named;

import com.hr.common.code.CommonCodeService;
import com.hr.common.exception.HrException;
import org.springframework.stereotype.Service;

import com.hr.common.dao.Dao;
import com.hr.common.logger.Log;

/**
 * 퇴직금항목관리 Service
 *
 * @author JM
 *
 */
@Service("SepEleMgrService")
public class SepEleMgrService {

	@Inject
	@Named("Dao")
	private Dao dao;

	@Inject
	@Named("CommonCodeService")
	private CommonCodeService commonCodeService;

	/**
	 * 퇴직금항목관리 다건 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getSepEleMgrList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();

		return (List<?>) dao.getList("getSepEleMgrList", paramMap);
	}

	/**
	 * 퇴직금항목관리 제외급여코드 팝업 다건 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getSepEleMgrExPayCdList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();

		return (List<?>) dao.getList("getSepEleMgrExPayCdList", paramMap);
	}

	/**
	 * 퇴직금항목관리 저장 Service
	 *
	 * @param convertMap
	 * @return int
	 * @throws Exception
	 */
	public int saveSepEleMgr(Map<?, ?> convertMap) throws Exception {
		Log.Debug();

		int cnt = 0;
		if ( ((List<?>)convertMap.get("deleteRows")).size() > 0 ) {
			cnt += dao.delete("deleteSepEleMgr", convertMap);

			// 퇴직금항목_제외급여코드관리 삭제
			dao.delete("deleteAllSepEleMgrExPayCd", convertMap);
		}

		// 중복체크.. 는 삭제 이후에 해야 하는거 아닌가....
		List<Map<String,Object>> insertList = (List<Map<String,Object>>)convertMap.get("insertRows");
		List<Map<String,Object>> dupList = new ArrayList<>();

		for (Map<String,Object> mp : insertList) {
			Map<String,Object> dupMap = new HashMap<>();
			dupMap.put("ENTER_CD", convertMap.get("ssnEnterCd"));
			dupMap.put("ELEMENT_CD", mp.get("elementCd"));
			dupList.add(dupMap);
		}

		int dupCnt = 0;
		if (!insertList.isEmpty()) {
			// 중복체크
			dupCnt = commonCodeService.getDupCnt("TCPN741","ENTER_CD,ELEMENT_CD","s,s",dupList);
		}

		if(dupCnt > 0)
			throw new HrException("중복된 값이 존재합니다.");

		if ( ((List<?>)convertMap.get("mergeRows")).size() > 0 ) {
			cnt += dao.update("saveSepEleMgr", convertMap);
		}

		return cnt;
	}

	/**
	 * 퇴직금항목관리 제외급여코드 팝업 저장 Service
	 *
	 * @param convertMap
	 * @return int
	 * @throws Exception
	 */
	public int saveSepEleMgrExPayCd(Map<?, ?> convertMap) throws Exception {
		Log.Debug();

		int cnt=0;
		if( ((List<?>)convertMap.get("deleteRows")).size() > 0){
			cnt += dao.delete("deleteSepEleMgrExPayCd", convertMap);
		}
		if( ((List<?>)convertMap.get("mergeRows")).size() > 0){
			cnt += dao.update("saveSepEleMgrExPayCd", convertMap);
		}

		return cnt;
	}

	/**
	 * 퇴직금항목관리 삭제 Service
	 *
	 * @param paramMap
	 * @return int
	 * @throws Exception
	 */
	public int deleteSepEleMgr(Map<?, ?> paramMap) throws Exception {
		Log.Debug();

		return dao.delete("deleteSepEleMgr", paramMap);
	}

	/**
	 * 퇴직금항목관리 제외급여코드 팝업 삭제 Service
	 *
	 * @param paramMap
	 * @return int
	 * @throws Exception
	 */
	public int deleteSepEleMgrExPayCd(Map<?, ?> paramMap) throws Exception {
		Log.Debug();

		return dao.delete("deleteSepEleMgrExPayCd", paramMap);
	}

	/**
	 * 퇴직금항목관리 퇴직금항목_제외급여코드관리 삭제 Service
	 *
	 * @param paramMap
	 * @return int
	 * @throws Exception
	 */
	public int deleteAllSepEleMgrExPayCd(Map<?, ?> paramMap) throws Exception {
		Log.Debug();

		return dao.delete("deleteAllSepEleMgrExPayCd", paramMap);
	}
}
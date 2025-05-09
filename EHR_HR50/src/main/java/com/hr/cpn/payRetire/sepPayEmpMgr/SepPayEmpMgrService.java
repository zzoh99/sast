package com.hr.cpn.payRetire.sepPayEmpMgr;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.inject.Inject;
import javax.inject.Named;

import org.springframework.stereotype.Service;

import com.hr.common.dao.Dao;
import com.hr.common.logger.Log;

/**
 * 퇴직금대상자관리 Service
 *
 * @author JM
 *
 */
@Service("SepPayEmpMgrService")
public class SepPayEmpMgrService{
	@Inject
	@Named("Dao")
	private Dao dao;

	/**
	 * 퇴직금대상자관리 기본정보 단건 조회 Service
	 *
	 * @param paramMap
	 * @return Map
	 * @throws Exception
	 */
	public Map<?, ?> getSepPayEmpMgrBasicMap(Map<?, ?> paramMap) throws Exception {
		Log.Debug();

		return dao.getMap("getSepPayEmpMgrBasicMap", paramMap);
	}

	/**
	 * 퇴직금대상자관리 다건 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getSepPayEmpMgrList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();

		return (List<?>) dao.getList("getSepPayEmpMgrList", paramMap);
	}

	/**
	 * 퇴직금대상자관리 저장 Service
	 *
	 * @param convertMap
	 * @return int
	 * @throws Exception
	 */
	public int saveSepPayEmpMgr(Map<?, ?> convertMap) throws Exception {
		Log.Debug();

		int cnt = 0;
		int insertResultCnt = 0;
		int updateResultCnt = 0;
		int updateResultStatusCnt = 0;
		int deleteResultCnt = 0;
		List<Map> insertList = (List<Map>)convertMap.get("insertRows");
		List<Map> updateList = (List<Map>)convertMap.get("updateRows");
		List<Map> deleteList = (List<Map>)convertMap.get("deleteRows");
		List<Map> mergeList = (List<Map>)convertMap.get("mergeRows");
		
		// 신규 : P_CPN_SEP_EMP_INS -> Update 쿼리 호출
		if( ((List<?>)convertMap.get("insertRows")).size() > 0){
			Log.Debug("신규 => P_CPN_SEP_EMP_INS 호출");

			for(Map<String,Object> mp : insertList) {
				Map<String,Object> insertMap = new HashMap<String,Object>();
				insertMap.put("ssnEnterCd",convertMap.get("ssnEnterCd"));
				insertMap.put("ssnSabun",convertMap.get("ssnSabun"));
				insertMap.put("payActionCd",mp.get("payActionCd"));
				insertMap.put("sabun",mp.get("sabun"));

				Map map = (Map) dao.excute("SepPayEmpMgrP_CPN_SEP_EMP_INS", insertMap);

				Log.Debug("map[" + map + "] sqlcode[" + map.get("sqlcode") + "] sqlerrm[" + map.get("sqlerrm") + "]");

				if (map.get("sqlerrm") != null) {
					cnt = -1;
					return cnt;
				}
				insertResultCnt++;
			}

			Log.Debug("신규 => Update 쿼리 호출");
			// Update 쿼리 호출(급여대상자상태 포함)
			dao.update("saveSepPayEmpMgr2", convertMap);
			
			for(Map<String,Object> mp : insertList) {
				Map<String,Object> insertMap = new HashMap<String,Object>();
				insertMap.put("ssnEnterCd",convertMap.get("ssnEnterCd"));
				insertMap.put("ssnSabun",convertMap.get("ssnSabun"));
				insertMap.put("payActionCd",mp.get("payActionCd"));
				insertMap.put("sabun",mp.get("sabun"));

				Map map = (Map) dao.excute("SepPayEmpMgrP_CPN_SEP_EMP_UPD", insertMap);

				Log.Debug("map[" + map + "] sqlcode[" + map.get("sqlcode") + "] sqlerrm[" + map.get("sqlerrm") + "]");

				if (map.get("sqlerrm") != null) {
					cnt = -1;
					return cnt;
				}
			}
			
		}

		// 삭제 : P_CPN_SEP_EMP_DEL -> Delete 쿼리 호출
		if( ((List<?>)convertMap.get("deleteRows")).size() > 0){
			Log.Debug("삭제 => P_CPN_SEP_EMP_DEL 호출");

			for(Map<String,Object> mp : deleteList) {
				Map<String,Object> deleteMap = new HashMap<String,Object>();
				deleteMap.put("ssnEnterCd",convertMap.get("ssnEnterCd"));
				deleteMap.put("ssnSabun",convertMap.get("ssnSabun"));
				deleteMap.put("payActionCd",mp.get("payActionCd"));
				deleteMap.put("sabun",mp.get("sabun"));

				Map map = (Map) dao.excute("SepPayEmpMgrP_CPN_SEP_EMP_DEL", deleteMap);

				Log.Debug("map[" + map + "] sqlcode[" + map.get("sqlcode") + "] sqlerrm[" + map.get("sqlerrm") + "]");

				if (map.get("sqlerrm") != null) {
					cnt = -1;
					return cnt;
				}
				deleteResultCnt++;
			}

			Log.Debug("삭제 => Delete 쿼리 호출");
			// Delete 쿼리 호출
			dao.delete("deleteSepPayEmpMgr", convertMap);
		}

		cnt = insertResultCnt + deleteResultCnt;

		// 수정 : Update 쿼리  -> P_CPN_SEP_EMP_UPD -> 급여대상자상태 UPDATE 쿼리 호출
		if( ((List<?>)convertMap.get("updateRows")).size() > 0){

			Log.Debug("수정 => Update 쿼리 호출");
			// 수정 Update 쿼리 호출(급여대상자상태 미포함)
			cnt += dao.update("saveSepPayEmpMgr", convertMap);

			for(Map<String,Object> mp : updateList) {
				// 상태가 변경되었을경우만 프로시저 호출
				//if("Y".equals(mp.get("payPeopleStatusChgYn").toString())) {
				Log.Debug("수정 => P_CPN_SEP_EMP_UPD 호출");

				Map<String,Object> updateMap = new HashMap<String,Object>();
				updateMap.put("ssnEnterCd",convertMap.get("ssnEnterCd"));
				updateMap.put("ssnSabun",convertMap.get("ssnSabun"));
				updateMap.put("payActionCd",mp.get("payActionCd"));
				updateMap.put("sabun",mp.get("sabun"));

				Map map = (Map) dao.excute("SepPayEmpMgrP_CPN_SEP_EMP_UPD", updateMap);

				Log.Debug("map[" + map + "] sqlcode[" + map.get("sqlcode") + "] sqlerrm[" + map.get("sqlerrm") + "]");

				if (map.get("sqlerrm") != null) {
					cnt = -1;
					return cnt;
				}
				updateResultCnt++;
				//}
			}

			//Log.Debug("수정 => 급여대상자상태 UPDATE 쿼리 호출");
			// 수정  급여대상자상태 UPDATE 쿼리 호출
			//updateResultStatusCnt = dao.update("saveSepPayEmpMgrPayPeopleStatus", convertMap);

			//if (updateResultStatusCnt <= 0) cnt = 0;
		}

		return cnt;
	}

	/**
	 * 퇴직금대상자관리 퇴직계산 대상자 선정 작업
	 *
	 * @param paramMap
	 * @return int
	 * @throws Exception
	 */
	public Map prcP_CPN_SEP_EMP_INS(Map<?, ?> paramMap) throws Exception {
		Log.Debug();

		return (Map) dao.excute("SepPayEmpMgrP_CPN_SEP_EMP_INS", paramMap);
	}

	/**
	 * 퇴직금대상자관리 퇴직계산 대상자 확정 작업
	 *
	 * @param paramMap
	 * @return int
	 * @throws Exception
	 */
	public Map prcP_CPN_SEP_EMP_UPD(Map<?, ?> paramMap) throws Exception {
		Log.Debug();

		return (Map) dao.excute("SepPayEmpMgrP_CPN_SEP_EMP_UPD", paramMap);
	}


	/**
	 * 퇴직금대상자관리 퇴직계산 대상자 확정취소 작업
	 *
	 * @param paramMap
	 * @return int
	 * @throws Exception
	 */
	public Map prcP_CPN_SEP_EMP_DEL(Map<?, ?> paramMap) throws Exception {
		Log.Debug();

		return (Map) dao.excute("SepPayEmpMgrP_CPN_SEP_EMP_DEL", paramMap);
	}
}
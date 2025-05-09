package com.hr.cpn.payRetroact.retroCalcCre;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import javax.inject.Inject;
import javax.inject.Named;
import org.springframework.stereotype.Service;
import com.hr.common.dao.Dao;
import com.hr.common.logger.Log;

/**
 * 소급계산 Service
 *
 * @author JM
 *
 */
@Service("RetroCalcCreService")
public class RetroCalcCreService{
	@Inject
	@Named("Dao")
	private Dao dao;

	/**
	 * 소급계산 기본정보 단건 조회 Service
	 *
	 * @param paramMap
	 * @return Map
	 * @throws Exception
	 */
	public Map<?, ?> getRetroCalcCreBasicMap(Map<?, ?> paramMap) throws Exception {
		Log.Debug();

		return dao.getMap("getRetroCalcCreBasicMap", paramMap);
	}

	/**
	 * 소급계산 인원관련정보 단건 조회 Service
	 *
	 * @param paramMap
	 * @return Map
	 * @throws Exception
	 */
	public Map<?, ?> getRetroCalcCrePeopleMap(Map<?, ?> paramMap) throws Exception {
		Log.Debug();

		return dao.getMap("getRetroCalcCrePeopleMap", paramMap);
	}

	/**
	 * 소급계산 마감현황 다건 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getRetroCalcCreCloseList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();

		return (List<?>) dao.getList("getRetroCalcCreCloseList", paramMap);
	}

	/**
	 * 소급계산 대상자기준 팝업 다건 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getRetroCalcCrePeopleSetList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();

		return (List<?>) dao.getList("getRetroCalcCrePeopleSetList", paramMap);
	}

	/**
	 * 소급계산 급여대상자상태 저장 Service
	 *
	 * @param paramMap
	 * @return int
	 * @throws Exception
	 */
	public int saveRetroCalcCrePeopleStatus(Map<?, ?> paramMap) throws Exception {
		Log.Debug();

		int cnt = dao.update("saveRetroCalcCrePeopleStatus", paramMap);

		return cnt;
	}

	/**
	 * 소급계산 대상자기준 팝업 급여대상자 저장 Service
	 *
	 * @param paramMap
	 * @return int
	 * @throws Exception
	 */
	public int saveRetroCalcCrePeopleSet(Map<?, ?> convertMap) throws Exception {
		Log.Debug();

		int cnt = 0;
		int insertResultCnt = 0;
		int updateResultCnt = 0;
		int deleteResultCnt = 0;
		List<Map> insertList = (List<Map>)convertMap.get("insertRows");
		List<Map> deleteList = (List<Map>)convertMap.get("deleteRows");

		// 신규생성은 P_CPN_CAL_EMP_INS 호출
		if( ((List<?>)convertMap.get("insertRows")).size() > 0){
			Log.Debug("신규생성 => P_CPN_CAL_EMP_INS 호출");

			for(Map<String,Object> mp : insertList) {
				Map<String,Object> insertMap = new HashMap<String,Object>();
				insertMap.put("ssnEnterCd",convertMap.get("ssnEnterCd"));
				insertMap.put("ssnSabun",convertMap.get("ssnSabun"));
				insertMap.put("payActionCd",mp.get("payActionCd"));
				insertMap.put("sabun",mp.get("sabun"));
				insertMap.put("businessPlaceCd",mp.get("businessPlaceCd"));

				Map map = (Map) dao.excute("RetroCalcCreP_CPN_CAL_EMP_INS", insertMap);

				Log.Debug("map[" + map + "] sqlcode[" + map.get("sqlcode") + "] sqlerrm[" + map.get("sqlerrm") + "]");

				if (map.get("sqlerrm") != null) {
					cnt = -1;
					return cnt;
				}
				insertResultCnt++;
			}
		}

		// 수정은 쿼리 호출
		if( ((List<?>)convertMap.get("updateRows")).size() > 0){
			Log.Debug("수정 => saveRetroCalcCrePeopleSet 호출");

			updateResultCnt = dao.update("saveRetroCalcCrePeopleSet", convertMap);
		}

		// 삭제는 P_CPN_RE_PAY_CANCEL 호출
		if( ((List<?>)convertMap.get("deleteRows")).size() > 0){
			Log.Debug("삭제 => P_CPN_RE_PAY_CANCEL 호출");

			for(Map<String,Object> mp : deleteList) {
				Map<String,Object> deleteMap = new HashMap<String,Object>();
				deleteMap.put("ssnEnterCd",convertMap.get("ssnEnterCd"));
				deleteMap.put("ssnSabun",convertMap.get("ssnSabun"));
				deleteMap.put("payActionCd",mp.get("payActionCd"));
				deleteMap.put("businessPlaceCd",mp.get("businessPlaceCd"));
				deleteMap.put("sabun",mp.get("sabun"));

				Map map = (Map) dao.excute("RetroCalcCreP_CPN_RE_PAY_CANCEL", deleteMap);

				Log.Debug("map[" + map + "] sqlcode[" + map.get("sqlcode") + "] sqlerrm[" + map.get("sqlerrm") + "]");

				if (map.get("sqlerrm") != null) {
					cnt = -1;
					return cnt;
				}
				deleteResultCnt++;
			}
		}

		cnt = insertResultCnt + updateResultCnt + deleteResultCnt;
		return cnt;
	}

	/**
	 * 소급계산 취소
	 *
	 * @param paramMap
	 * @return int
	 * @throws Exception
	 */
	public Map prcP_CPN_RE_PAY_CANCEL(Map<?, ?> paramMap) throws Exception {
		Log.Debug();

		return (Map) dao.excute("RetroCalcCreP_CPN_RE_PAY_CANCEL", paramMap);
	}

	/**
	 * 소급계산 대상자기준 팝업 급여대상자 생성
	 *
	 * @param paramMap
	 * @return int
	 * @throws Exception
	 */
	public Map prcP_CPN_CAL_EMP_INS(Map<?, ?> paramMap) throws Exception {
		Log.Debug();

		return (Map) dao.excute("RetroCalcCreP_CPN_CAL_EMP_INS", paramMap);
	}

	/**
	 * 소급계산 대상자기준 팝업 급여대상자 삭제 Service
	 *
	 * @param paramMap
	 * @return int
	 * @throws Exception
	 */
	public int deleteRetroCalcCrePeopleSet(Map<?, ?> paramMap) throws Exception {
		Log.Debug();

		return dao.delete("deleteRetroCalcCrePeopleSet", paramMap);
	}
}
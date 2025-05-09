package com.hr.cpn.payCalculate.payCalcReCre;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.inject.Inject;
import javax.inject.Named;

import org.springframework.stereotype.Service;

import com.hr.common.dao.Dao;
import com.hr.common.logger.Log;

/**
 * 월급여재계산 Service
 *
 * @author JM
 *
 */
@Service("PayCalcReCreService")
public class PayCalcReCreService{
	@Inject
	@Named("Dao")
	private Dao dao;

	/**
	 * 월급여재계산 급여구분별 항목리스트 다건 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getPayCalcReCreTitleList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();

		return (List<?>) dao.getList("getPayCalcReCreTitleList", paramMap);
	}

	/**
	 * 월급여재계산 다건 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getPayCalcReCreList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();

		return (List<?>) dao.getList("getPayCalcReCreList", paramMap);
	}

	/**
	 * 월급여재계산 급여대상자상태 저장 Service
	 *
	 * @param convertMap
	 * @return int
	 * @throws Exception
	 */
	public int savePayCalcReCre(Map<?, ?> convertMap) throws Exception {
		Log.Debug();

		int cnt = 0;
		int insertResultCnt = 0;
		int updateResultCnt = 0;
		List<Map> insertList = (List<Map>)convertMap.get("insertRows");

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

				Map map = (Map) dao.excute("PayCalcReCreP_CPN_CAL_EMP_INS", insertMap);

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
			Log.Debug("수정 => savePayCalcReCre 호출");

			updateResultCnt = dao.update("savePayCalcReCre", convertMap);
		}

		cnt = insertResultCnt + updateResultCnt;
		return cnt;
	}

	/**
	 * 월급여재계산
	 *
	 * @param paramMap
	 * @return int
	 * @throws Exception
	 */
	public Map prcP_CPN_RETRY_PAY_MAIN(Map<?, ?> paramMap) throws Exception {
		Log.Debug();

		return (Map) dao.excute("PayCalcReCreP_CPN_RETRY_PAY_MAIN", paramMap);
	}
}
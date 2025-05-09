package com.hr.wtm.config.wtmLeaveCreStd;

import com.hr.common.dao.Dao;
import com.hr.common.logger.Log;
import com.hr.wtm.domain.WtmAnnualLeaveCreateType;
import com.hr.wtm.domain.WtmAnnualLeaveCreateTypeU1Y;
import com.hr.wtm.domain.WtmMonthlyLeaveCreateTypeU1Y;
import org.springframework.stereotype.Service;

import javax.inject.Inject;
import javax.inject.Named;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * 휴가생성기준 Service
 *
 * @author bckim
 *
 */
@Service
public class WtmLeaveCreStdService {

	@Inject
	@Named("Dao")
	private Dao dao;

	/**
	 * 휴가생성기준_연차코드 조회 Service
	 *
	 * @param paramMap
	 * @return 휴가생성기준 Map
	 * @throws Exception
	 */
	public Map<String, Object> getWtmLeaveCreStdLeaveCdMap(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		Map<String, Object> result = new HashMap<>();
		result.put("gntCd", dao.getList("getWtmLeaveCreStdLeaveCdMap", paramMap));
		result.put("annualCreType", WtmAnnualLeaveCreateType.getCodeList());
		result.put("monthlyCreTypeU1y", WtmMonthlyLeaveCreateTypeU1Y.getCodeList());
		result.put("annualCreTypeU1y", WtmAnnualLeaveCreateTypeU1Y.getCodeList());
		return result;
	}

	/**
	 * 휴가생성기준_대상자조건검색 리스트 조회 Service
	 *
	 * @param paramMap
	 * @return 휴가생성기준 Map
	 * @throws Exception
	 */
	public List<Map<String, Object>> getWtmLeaveCreStdSearchSeqList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<Map<String, Object>>) dao.getList("getWtmLeaveCreStdSearchSeqList", paramMap);
	}

	/**
	 * 휴가생성기준 조회 Service
	 *
	 * @param paramMap
	 * @return 휴가생성기준 Map
	 * @throws Exception
	 */
	public Map<String, Object> getWtmLeaveCreStdMap(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		Map<String, Object> result = (Map<String, Object>) dao.getOne("getWtmLeaveCreStdMap", paramMap);

		if(result != null) {
			if (result.containsKey("annualCreType") && result.get("annualCreType") != null) {
				result.put("annualCreTypeNm", WtmAnnualLeaveCreateType.findByCode((String) result.get("annualCreType")).getTitle());
			}
			if (result.containsKey("annualCreTypeU1y") && result.get("annualCreTypeU1y") != null) {
				result.put("annualCreTypeU1yNm", WtmAnnualLeaveCreateType.findByCode((String) result.get("annualCreTypeU1y")).getTitle());
			}
			if (result.containsKey("monthlyCreTypeU1y") && result.get("monthlyCreTypeU1y") != null) {
				result.put("monthlyCreTypeU1yNm", WtmAnnualLeaveCreateType.findByCode((String) result.get("monthlyCreTypeU1y")).getTitle());
			}
		}
		return result;
	}

	/**
	 * 휴가생성기준 저장 Service
	 *
	 * @param convertMap
	 * @return 저장 count
	 * @throws Exception
	 */
	public int saveWtmLeaveCreStd(Map<String, Object> convertMap) throws Exception {
		Log.Debug();
		return dao.create("saveWtmLeaveCreStd", convertMap);
	}

	/**
	 * 휴가생성기준 신규 조건검색 저장 Service
	 *
	 * @param convertMap
	 * @return 저장 count
	 * @throws Exception
	 */
	public int saveWtmLeaveCreStdAddSearchSeq(Map<String, Object> convertMap) throws Exception {
		Log.Debug();
		return dao.update("saveWtmLeaveCreStdAddSearchSeq", convertMap);
	}

	/**
	 * 휴가생성기준 조건검색 수정 Service
	 *
	 * @param convertMap
	 * @return 저장 count
	 * @throws Exception
	 */
	public int saveWtmLeaveCreStdModifySearchSeq(Map<String, Object> convertMap) throws Exception {
		Log.Debug();
		return dao.update("saveWtmLeaveCreStdModifySearchSeq", convertMap);
	}

	/**
	 * 휴가생성기준_연차부여 예상 조회 Service
	 *
	 * @param paramMap
	 * @return int
	 * @throws Exception
	 */
	public Map<String, List<WtmLeaveCreSimulationDTO>> getWtmLeaveCreStdSimulationMap(Map<String, Object> paramMap) throws Exception {
		Log.DebugStart();
		WtmLeaveCreOption option = new WtmLeaveCreOption(paramMap);
		WtmLeaveCreSimulation simulation = new WtmLeaveCreSimulation(option);
		simulation.calc((String) paramMap.get("searchEmpYmd"));
		Log.DebugEnd();
		return simulation.getResultByYear();
	}
}
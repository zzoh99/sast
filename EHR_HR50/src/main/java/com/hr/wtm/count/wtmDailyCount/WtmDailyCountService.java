package com.hr.wtm.count.wtmDailyCount;

import com.hr.common.dao.Dao;
import com.hr.common.exception.HrException;
import com.hr.common.logger.Log;
import com.hr.wtm.calc.dto.WtmDailyCountDTO;
import com.hr.wtm.calc.dto.WtmWrkDtlDTO;
import com.hr.wtm.calc.workTime.WtmCalcWorkTimeService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import javax.inject.Inject;
import javax.inject.Named;
import java.util.*;
import java.util.stream.Collectors;


/**
 * 일근태/근무집계 Service
 */
@Service("WtmDailyCountService")
public class WtmDailyCountService {

	@Inject
	@Named("Dao")
	private Dao dao;

	@Autowired
	private WtmCalcWorkTimeService wtmCalcWorkTimeService;

	/**
	 * 일근태/근무집계(마감) 수정 Service
	 *
	 * @param paramMap
	 * @return int
	 * @throws Exception
	 */
	public int updateWtmDailyCountEndYn(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		int cnt = dao.update("updateWtmDailyCountEndYn", paramMap);
		return cnt;
	}

	/**
	 * 일근태/근무집계 처리
	 *
	 * @param paramMap
	 * @return Map
	 * @throws Exception
	 */
	public int prcWtmDailyCount(Map<String, Object> paramMap) throws Exception {
		Log.Debug();
		int result = -1;
		int countCnt = -1;
		try {

			boolean isBatch = true;
			if(paramMap.containsKey("useBatchMode") && "N".equals(paramMap.get("useBatchMode").toString())){
				isBatch = false;
			}

			Log.Debug("=========== 근무 일 마감 시작 ===========");
			wtmCalcWorkTimeService.setCode(paramMap.get("enterCd").toString(), isBatch);
			Map<String, Object> countMap = wtmCalcWorkTimeService.countDailyWorkTime(paramMap, isBatch);

			List<WtmWrkDtlDTO> insertDataList = (List<WtmWrkDtlDTO>) countMap.get("realWorkList"); // 저장할 리스트
			List<WtmWrkDtlDTO> delDataList = (List<WtmWrkDtlDTO>) countMap.get("delWorkList"); // 삭제할 리스트
			countCnt = 0;
			if(!delDataList.isEmpty()) {
				countCnt += delDataList.size();
				if(isBatch) {
					result += dao.updateBatchMode("deleteWtmDailyCountAutoCreWork", delDataList);
				} else {
					for(WtmWrkDtlDTO dto : delDataList) {
						result += dao.updateBatch("deleteWtmDailyCountAutoCreWork", dto);
					}
				}
			}

			// 자동생성 근무
			List<WtmWrkDtlDTO> autoCreList = insertDataList.stream()
					.filter(dto -> "Y".equals(dto.getNewDataYn()))
					.collect(Collectors.toList());
			if(!autoCreList.isEmpty()) {
				countCnt += autoCreList.size();
				if(isBatch) {
					result += dao.updateBatchMode("saveWtmDailyCountAutoCreWork", autoCreList);
				} else {
					for(WtmWrkDtlDTO dto : autoCreList) {
						result += dao.updateBatch("saveWtmDailyCountAutoCreWork", dto);
					}
				}
			}

			insertDataList.removeAll(autoCreList);
			if(!insertDataList.isEmpty()) {
				countCnt += insertDataList.size();
				if(isBatch) {
					result += dao.updateBatchMode("saveWtmDailyCountRealTime", insertDataList);
				} else {
					for(WtmWrkDtlDTO dto : insertDataList) {
						result += dao.updateBatch("saveWtmDailyCountRealTime", dto);
					}
				}
			}

			List<WtmDailyCountDTO> workSummary = (List<WtmDailyCountDTO>) countMap.get("workSummary");
			if(workSummary != null && !workSummary.isEmpty()) {
				countCnt += workSummary.size();
				if(isBatch) {
					result += dao.updateBatchMode("saveWtmDailyCountWorkSummary", workSummary);
				} else {
					for(WtmDailyCountDTO dto : workSummary) {
						result += dao.updateBatch("saveWtmDailyCountWorkSummary", dto);
					}
				}
			}

			if(result > 0 && workSummary != null && !workSummary.isEmpty()) {
				if(isBatch) {
					dao.updateBatchMode("deleteWtmDailyCountWorkTime", workSummary);
					dao.updateBatchMode("saveWtmDailyCountWorkTime", workSummary);
				} else {
					for(WtmDailyCountDTO dto : workSummary) {
						dao.updateBatch("deleteWtmDailyCountWorkTime", dto);
						dao.updateBatch("saveWtmDailyCountWorkTime", dto);
					}
				}
			}

			result = countCnt == 0 ? 0 : result;
			Log.Debug("=========== 근무 일 마감 종료 ===========");
		} catch (Exception e) {
			e.getStackTrace();
			throw new HrException(e.getMessage());
		}

		return result;
	}

	/**
	 * 작업 도중 로그 파일 삭제 Service
	 * 
	 * @param paramMap
	 * @return int
	 * @throws Exception
	 */
	public int deleteTSYS906ForWtmDailyCount(Map<?, ?> paramMap) throws Exception {
		Log.Debug("deleteTSYS906ForWtmDailyCount");
		return dao.delete("deleteTSYS906ForWtmDailyCount", paramMap);
	}
	
	/**
	 * wtmDailyCount 단건 조회 Service
	 *
	 * @param paramMap
	 * @return Map
	 * @throws Exception
	 */
	public Map<?, ?> getWtmDailyCount(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		Map<?, ?> resultMap = dao.getMap("getWtmDailyCount", paramMap);
		Log.Debug();
		return resultMap;
	}
	
	/**
	 * wtmDailyCount 단건 조회 Service
	 *
	 * @param paramMap
	 * @return Map
	 * @throws Exception
	 */
	public Map<?, ?> getTimWorkEndYn(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		Map<?, ?> resultMap = dao.getMap("getTimWorkEndYn", paramMap);
		Log.Debug();
		return resultMap;
	}

}
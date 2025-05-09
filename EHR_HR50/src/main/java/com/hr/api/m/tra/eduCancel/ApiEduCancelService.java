package com.hr.api.m.tra.eduCancel;

import com.hr.common.com.ComService;
import com.hr.common.dao.Dao;
import com.hr.common.logger.Log;
import com.hr.common.util.NumberUtil;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.stereotype.Service;

import javax.inject.Inject;
import javax.inject.Named;
import javax.servlet.http.HttpSession;
import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

/**
 * 사내강사료신청 세부내역 Service
 */
@Service("ApiEduCancelService")
public class ApiEduCancelService {

	@Inject
	@Named("Dao")
	private Dao dao;

	@Autowired
	@Qualifier("ComService")
	private ComService comService;

	/**
	 * 경조금신청 상세 조회
	 *
	 * @param paramMap
	 * @return
	 * @throws Exception
	 */
	public List<?> getEduCancelAppDetMoMap(Map<String, Object> paramMap, HttpSession session) throws Exception {
		Log.Debug();
		Map<String, Object> result = new LinkedHashMap<>();

		paramMap.put("cmd", "getEduCancelAppDetMap");
		Map<?, ?> resultMap = comService.getDataMap(paramMap);

		String realExpenseMon = resultMap.get("realExpenseMon") != null ? NumberUtil.getCommaNumber(Double.parseDouble(resultMap.get("realExpenseMon").toString()), 3) + "원" : "";

		result.put("교육과정명", resultMap.get("eduCourseNm"));
		result.put("교육구분", resultMap.get("eduBranchNm"));
		result.put("교육분류", resultMap.get("eduMBranchNm"));
		result.put("교육기관", resultMap.get("eduOrgNm"));
		result.put("사내/외구분", resultMap.get("inOutTypeNm"));
		result.put("교육내용", resultMap.get("eduMemo"));
		result.put("교육기간", resultMap.get("eduYmd"));
		result.put("교육장소", resultMap.get("eduPlace"));
		result.put("교육비용", realExpenseMon);
		result.put("고용보험", resultMap.get("laborApplyYn"));
		result.put("사업계획입안", resultMap.get("eduPlace"));
		result.put("관련직무", resultMap.get("jobNm"));
		result.put("미참석사유", resultMap.get("gubunCd"));
		result.put("상세내용", resultMap.get("appMemo"));

		// Map을 List로 변환
		List<Map.Entry<String, Object>> list = new ArrayList<>(result.entrySet());

		Log.Debug();
		return list;
	}

}
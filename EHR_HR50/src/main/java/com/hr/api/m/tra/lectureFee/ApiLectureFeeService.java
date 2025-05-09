package com.hr.api.m.tra.lectureFee;

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
@Service("ApiLectureFeeService")
public class ApiLectureFeeService {

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
	public List<?> getLectureFeeAppDetMoMap(Map<String, Object> paramMap, HttpSession session) throws Exception {
		Log.Debug();
		Map<String, Object> result = new LinkedHashMap<>();

		paramMap.put("cmd", "getLectureFeeAppDetMap");
		Map<?, ?> resultMap = comService.getDataMap(paramMap);

		//eduSeq
		paramMap.remove("cmd");
		paramMap.put("cmd", "getLectureFeeAppDetInfo");
		paramMap.put("eduSeq", resultMap.get("eduSeq"));
		paramMap.put("eduEventSeq", resultMap.get("eduEventSeq"));
		Map<?, ?> infoMap = comService.getDataMap(paramMap);

//		String famYmd = resultMap.get("famYmd") != null ? StringUtil.formatDate(resultMap.get("famYmd").toString()) : "";
		String lectureFee = resultMap.get("lectureFee") != null ? NumberUtil.getCommaNumber(Double.parseDouble(resultMap.get("lectureFee").toString()), 3) + "원" : "";

		result.put("교육과정명", resultMap.get("eduCourseNm"));
		result.put("교육구분", resultMap.get("eduBranchNm"));
		result.put("교육분류", resultMap.get("eduMBranchNm"));
		result.put("교육기관", resultMap.get("eduOrgNm"));
		result.put("교육내용", resultMap.get("eduMemo"));
		result.put("교육기간", resultMap.get("eduYmd"));
		result.put("강의과목", infoMap.get("subjectLecture"));
		result.put("강의료", lectureFee);
		result.put("비고", resultMap.get("note"));

		// Map을 List로 변환
		List<Map.Entry<String, Object>> list = new ArrayList<>(result.entrySet());

		Log.Debug();
		return list;
	}

}
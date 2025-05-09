package com.hr.cpn.personalPay.psnalPayUser;

import com.hr.common.dao.Dao;
import com.hr.common.logger.Log;
import org.springframework.stereotype.Service;
import yjungsan.util.StringUtil;

import javax.inject.Inject;
import javax.inject.Named;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

/**
 * 개인별급여내역 Service
 *
 * @author JM
 *
 */
@Service("PsnalPayUserService")
public class PsnalPayUserService {

	@Inject
	@Named("Dao")
	private Dao dao;

	/**
	 * 개인별급여내역 최근급여일자 단건 조회 Service
	 *
	 * @param paramMap
	 * @return Map
	 * @throws Exception
	 */
	public Map<?, ?> getLatestPaymentInfoMap(Map<?, ?> paramMap) throws Exception {
		Log.Debug();

		return dao.getMap("getLatestPaymentInfoMap", paramMap);
	}

	/**
	 * 개인별급여내역 급여내역 기본정보 조회
	 *
	 * @param paramMap
	 * @return
	 * @throws Exception
	 */
	public Map<String, Object> getPsnalPayUserBaseInfo(Map<String, Object> paramMap) throws Exception {
		Log.DebugStart();

		Map<String, Object> info = new HashMap<>();

		String visibleYn = StringUtil.stringValueOf(paramMap.get("visibleYn"));

		Map<String, Object> salarySum = (Map<String, Object>) dao.getMap("getPsnalPayUserBase", paramMap);
		if (salarySum == null) salarySum = new HashMap<>();

		if (!"Y".equals(visibleYn)) {
			salarySum.put("totPaymentMon", "");
		}
		info.put("total", salarySum); // 개인별급여내역 기간별 합산

		// 개인별급여내역 기간별 항목 합산 리스트
		List<Map<String, Object>> salaryList = (List<Map<String, Object>>) dao.getList("getPsnalPayUserBaseList", paramMap);

		// 보여주기 여부에 따라 금액을 가져올지 말지 결정
		if ("Y".equals(visibleYn)) {
			info.put("salaries", salaryList);
		} else {
			info.put("salaries", salaryList.stream()
					.map(map -> {
						Map<String, Object> tmp = new HashMap<>(map);
						tmp.put("paymentMon", "");
						return tmp;
					})
					.collect(Collectors.toList()));
		}

		Log.DebugEnd();
		return info;
	}

	/**
	 * 개인별급여내역 급여내역 상세리스트 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public Map<String, Object> getPsnalPayUserDetailList(Map<?, ?> paramMap) throws Exception {
		Log.DebugStart();
		Map<String, Object> result = new HashMap<>();
		result.put("list", dao.getList("getPsnalPayUserDetailList", paramMap));
		result.put("summary", dao.getMap("getPsnalPayUserDetailListSum", paramMap));
		Log.DebugEnd();
		return result;
	}

	/**
	 * 개인별급여내역 급여상세레이어 급여 리스트 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<Map<String, Object>> getPsnalPayDetailUserPayActionList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<Map<String, Object>>) dao.getList("getPsnalPayDetailUserPayActionList", paramMap);
	}

	/**
	 * 개인별급여내역 급여상세레이어 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public Map<String, Object> getPsnalPayDetailUser(Map<?, ?> paramMap) throws Exception {
		Log.DebugStart();
		Map<String, Object> result = new HashMap<>();
		Map<String, Object> isOpenMap = (Map<String, Object>) dao.getMap("getPsnalPayUserIsOpen", paramMap);
		String isOpenYn = StringUtil.stringValueOf(isOpenMap.get("openYn"));
		result.put("isOpenYn", isOpenYn);
		if ("Y".equals(isOpenYn)) {
			result.put("summary", dao.getMap("getPsnalPayDetailUserSummary", paramMap));
			result.put("pay", dao.getList("getPsnalPayDetailUserPay", paramMap));
			result.put("deduct", dao.getList("getPsnalPayDetailUserDeduct", paramMap));
			result.put("basic", dao.getList("getPsnalPayDetailUserBasic", paramMap));
			result.put("etcList", dao.getList("getPsnalPayDetailUserEtcList", paramMap));
		} else {
			result.put("summary", new HashMap<>());
			result.put("pay", new ArrayList<>());
			result.put("deduct", new ArrayList<>());
			result.put("basic", new ArrayList<>());
			result.put("etcList", new ArrayList<>());
		}
		Log.DebugEnd();
		return result;
	}

	/**
	 * 개인별급여내역 항목별 세부내역 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public Map<String, Object> getPsnalPayItemDetailUser(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		Map<String, Object> result = new HashMap<>();
		Map<String, Object> isOpenMap = (Map<String, Object>) dao.getMap("getPsnalPayUserIsOpen", paramMap);
		String isOpenYn = StringUtil.stringValueOf(isOpenMap.get("openYn"));
		result.put("isOpenYn", isOpenYn);
		if ("Y".equals(isOpenYn)) {
			result.put("list", dao.getList("getPsnalPayItemDetailUser", paramMap));
		} else {
			result.put("list", new ArrayList<>());
		}
		return result;
	}

	/**
	 * 개인별급여내역 항목별 계산방법 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public Map<String, Object> getPsnalPayFormulaUser(Map<String, Object> paramMap) throws Exception {
		Log.Debug();
		Map<String, Object> result = new HashMap<>();
		Map<String, Object> isOpenMap = (Map<String, Object>) dao.getMap("getPsnalPayUserIsOpen", paramMap);
		String isOpenYn = StringUtil.stringValueOf(isOpenMap.get("openYn"));
		result.put("isOpenYn", isOpenYn);
		if ("Y".equals(isOpenYn)) {
			paramMap.put("searchElementType", "A");
			result.put("pay", dao.getList("getPsnalPayFormulaUser", paramMap));
			paramMap.put("searchElementType", "D");
			result.put("deduct", dao.getList("getPsnalPayFormulaUser", paramMap));
		} else {
			result.put("pay", new ArrayList<>());
			result.put("deduct", new ArrayList<>());
		}
		return result;
	}
}
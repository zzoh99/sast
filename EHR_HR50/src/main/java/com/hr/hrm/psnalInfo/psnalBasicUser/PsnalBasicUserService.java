package com.hr.hrm.psnalInfo.psnalBasicUser;

import com.hr.common.dao.Dao;
import com.hr.common.logger.Log;
import org.springframework.stereotype.Service;
import yjungsan.util.StringUtil;

import javax.inject.Inject;
import javax.inject.Named;
import java.util.Comparator;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

/**
 * 인사기본_임직원공통_기본탭 Service
 *
 * @author 이름
 *
 */
@Service("PsnalBasicUserService")
public class PsnalBasicUserService {

	@Inject
	@Named("Dao")
	private Dao dao;

	/**
	 * 인사기본_임직원공통 헤더정보 조회
	 *
	 * @param paramMap
	 * @return
	 * @throws Exception
	 */
	public Map<String, Object> getPsnalBasicUserEmployeeHeader(Map<String, Object> paramMap) throws Exception {
		Log.Debug();

		return (Map<String, Object>) dao.getMap("getPsnalBasicUserEmployeeHeader", paramMap);
	}

	/**
	 * 인사기본_임직원공통 탭 Json 데이터 조회
	 *
	 * @param paramMap
	 * @return
	 * @throws Exception
	 */
	public Map<String, Object> getPsnalBasicUserTabs(Map<String, Object> paramMap) throws Exception {
		Log.Debug();
		return (Map<String, Object>) dao.getMap("getPsnalBasicUserConfigJson", paramMap);
	}

	/**
	 * 인사기본_임직원공통 개인정보 데이터 조회
	 *
	 * @param paramMap
	 * @return
	 * @throws Exception
	 */
	public Map<String, Object> getPsnalBasicUserPsnlInfo(Map<String, Object> paramMap) throws Exception {
		Log.Debug();

		return (Map<String, Object>) dao.getMap("getPsnalBasicUserPsnlInfo", paramMap);
	}

	/**
	 * 인사기본_임직원공통 연락처 데이터 조회
	 *
	 * @param paramMap
	 * @return
	 * @throws Exception
	 */
	public List<Map<String, Object>> getPsnalBasicUserContacts(Map<String, Object> paramMap) throws Exception {
		Log.Debug();

		return (List<Map<String, Object>>) dao.getList("getPsnalBasicUserContacts", paramMap);
	}

	/**
	 * 인사기본_임직원공통 근무정보 데이터 조회
	 *
	 * @param paramMap
	 * @return
	 * @throws Exception
	 */
	public Map<String, Object> getPsnalBasicUserWorkInfo(Map<String, Object> paramMap) throws Exception {
		Log.Debug();

		return (Map<String, Object>) dao.getMap("getPsnalBasicUserWorkInfo", paramMap);
	}

	/**
	 * 인사기본_임직원공통 주소 데이터 조회
	 *
	 * @param paramMap
	 * @return
	 * @throws Exception
	 */
	public List<Map<String, Object>> getPsnalBasicUserAddress(Map<String, Object> paramMap) throws Exception {
		Log.Debug();

		return (List<Map<String, Object>>) dao.getList("getPsnalBasicUserAddress", paramMap);
	}

	/**
	 * 인사기본_임직원공통 가족 데이터 조회
	 *
	 * @param paramMap
	 * @return
	 * @throws Exception
	 */
	public List<Map<String, Object>> getPsnalBasicUserFamily(Map<String, Object> paramMap) throws Exception {
		Log.Debug();

		return (List<Map<String, Object>>) dao.getList("getPsnalBasicUserFamily", paramMap);
	}

	/**
	 * 인사기본_임직원공통 보증보험 데이터 조회
	 *
	 * @param paramMap
	 * @return
	 * @throws Exception
	 */
	public List<Map<String, Object>> getPsnalBasicUserGuaranteeInsurance(Map<String, Object> paramMap) throws Exception {
		Log.Debug();

		return (List<Map<String, Object>>) dao.getList("getPsnalBasicUserGuaranteeInsurance", paramMap);
	}

	/**
	 * 인사기본_임직원공통 발령 데이터 조회
	 *
	 * @param paramMap
	 * @return
	 * @throws Exception
	 */
	public List<Map<String, Object>> getPsnalBasicUserPost(Map<String, Object> paramMap) throws Exception {
		Log.Debug();

		return (List<Map<String, Object>>) dao.getList("getPsnalBasicUserPost", paramMap);
	}

	/**
	 * 인사기본_임직원공통 근무정보 데이터 조회
	 *
	 * @param paramMap
	 * @return
	 * @throws Exception
	 */
	public Map<String, Object> getPsnalBasicUserRewardAndPunish(Map<String, Object> paramMap) throws Exception {
		Log.DebugStart();

		Map<String, Object> map = new HashMap<>();
		map.put("reward", dao.getList("getPsnalBasicUserReward", paramMap));
		map.put("punish", dao.getList("getPsnalBasicUserPunish", paramMap));

		Log.DebugEnd();
		return map;
	}

	/**
	 * 인사기본_임직원공통 교육 데이터 조회
	 *
	 * @param paramMap
	 * @return
	 * @throws Exception
	 */
	public Map<String, Object> getPsnalBasicUserEducation(Map<String, Object> paramMap) throws Exception {
		Log.DebugStart();

		Map<String, Object> map = new HashMap<>();
		List<Map<String, Object>> totalList = (List<Map<String, Object>>) dao.getList("getPsnalBasicUserEducation", paramMap);
		int totCnt = totalList.stream().mapToInt(obj -> StringUtil.parseInt(StringUtil.stringValueOf(obj.get("rnum")))).max().orElse(0);
		map.put("totPage", (totCnt == 0) ? 1 : Math.ceil((double) totCnt / (double) 3));

		if (!paramMap.containsKey("page") || paramMap.get("page") == null || "".equals(paramMap.get("page"))) {
			map.put("list", totalList);
		} else {
			int page = StringUtil.parseInt(StringUtil.stringValueOf(paramMap.get("page")));
			int from = (page-1) * 3 + 1;
			int to = page * 3;
			map.put("list", totalList.stream()
					.filter(obj -> StringUtil.parseInt(StringUtil.stringValueOf(obj.get("rnum"))) >= from && StringUtil.parseInt(StringUtil.stringValueOf(obj.get("rnum"))) <= to)
					.collect(Collectors.toList()));
		}

		Log.DebugEnd();
		return map;
	}

	/**
	 * 인사기본_임직원공통 자격 데이터 조회
	 *
	 * @param paramMap
	 * @return
	 * @throws Exception
	 */
	public List<Map<String, Object>> getPsnalBasicUserLicense(Map<String, Object> paramMap) throws Exception {
		Log.Debug();

		return (List<Map<String, Object>>) dao.getList("getPsnalBasicUserLicense", paramMap);
	}

	/**
	 * 인사기본_임직원공통 학력 데이터 조회
	 *
	 * @param paramMap
	 * @return
	 * @throws Exception
	 */
	public List<Map<String, Object>> getPsnalBasicUserSchool(Map<String, Object> paramMap) throws Exception {
		Log.Debug();

		return (List<Map<String, Object>>) dao.getList("getPsnalBasicUserSchool", paramMap);
	}

	/**
	 * 인사기본_임직원공통 경력 데이터 조회
	 *
	 * @param paramMap
	 * @return
	 * @throws Exception
	 */
	public Map<String, Object> getPsnalBasicUserCareer(Map<String, Object> paramMap) throws Exception {
		Log.DebugStart();

		Map<String, Object> map = new HashMap<>();
		map.put("info", dao.getMap("getPsnalBasicUserCareerInfo", paramMap));
		map.put("inner", dao.getList("getPsnalBasicUserInnerCareer", paramMap));
		map.put("outer", dao.getList("getPsnalBasicUserOuterCareer", paramMap));

		Log.DebugEnd();
		return map;
	}

	/**
	 * 인사기본_임직원공통 어학 데이터 조회
	 *
	 * @param paramMap
	 * @return
	 * @throws Exception
	 */
	public List<Map<String, Object>> getPsnalBasicUserLanguage(Map<String, Object> paramMap) throws Exception {
		Log.Debug();

		return (List<Map<String, Object>>) dao.getList("getPsnalBasicUserLanguage", paramMap);
	}

	/**
	 * 인사기본_임직원공통 해외연수 데이터 조회
	 *
	 * @param paramMap
	 * @return
	 * @throws Exception
	 */
	public List<Map<String, Object>> getPsnalBasicUserOverseasStudy(Map<String, Object> paramMap) throws Exception {
		Log.Debug();

		return (List<Map<String, Object>>) dao.getList("getPsnalBasicUserOverseasStudy", paramMap);
	}

	/**
	 * 인사기본_임직원공통 병역사항 데이터 조회
	 *
	 * @param paramMap
	 * @return
	 * @throws Exception
	 */
	public Map<String, Object> getPsnalBasicUserMilitary(Map<String, Object> paramMap) throws Exception {
		Log.Debug();
		return (Map<String, Object>) dao.getMap("getPsnalBasicUserMilitary", paramMap);
	}

	/**
	 * 인사기본_임직원공통 병역특례 데이터 조회
	 *
	 * @param paramMap
	 * @return
	 * @throws Exception
	 */
	public Map<String, Object> getPsnalBasicUserMilitaryException(Map<String, Object> paramMap) throws Exception {
		Log.Debug();
		return (Map<String, Object>) dao.getMap("getPsnalBasicUserMilitaryException", paramMap);
	}

	/**
	 * 인사기본_임직원공통 보훈사항 데이터 조회
	 *
	 * @param paramMap
	 * @return
	 * @throws Exception
	 */
	public Map<String, Object> getPsnalBasicUserVeteransAffairs(Map<String, Object> paramMap) throws Exception {
		Log.Debug();
		return (Map<String, Object>) dao.getMap("getPsnalBasicUserVeteransAffairs", paramMap);
	}

	/**
	 * 인사기본_임직원공통 장애사항 데이터 조회
	 *
	 * @param paramMap
	 * @return
	 * @throws Exception
	 */
	public Map<String, Object> getPsnalBasicUserDisability(Map<String, Object> paramMap) throws Exception {
		Log.Debug();
		return (Map<String, Object>) dao.getMap("getPsnalBasicUserDisability", paramMap);
	}
}
package com.hr.hrm.psnalInfo.psnalBasicUser;

import com.hr.common.logger.Log;
import com.hr.hrm.psnalInfo.psnalBasicUserConfig.PsnalBasicUserConfigService;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;

import javax.inject.Inject;
import javax.inject.Named;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * 인사기본_임직원공통_기본탭 Controller
 *
 * @author 이름
 *
 */
@Controller
@RequestMapping(value="/PsnalBasicUser.do", method=RequestMethod.POST )
public class PsnalBasicUserController {

	/**
	 * 인사기본_임직원공통_기본탭 서비스
	 */
	@Inject
	@Named("PsnalBasicUserService")
	private PsnalBasicUserService psnalBasicUserService;

	/**
	 * 인사기본_임직원공통 설정 서비스
	 */
	@Inject
	@Named("PsnalBasicUserConfigService")
	private PsnalBasicUserConfigService psnalBasicUserConfigService;

	/**
	 * 인사기본_임직원공통_기본탭 View
	 *
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewPsnalBasicUser", method = {RequestMethod.POST, RequestMethod.GET} )
	public ModelAndView viewPsnalBasicUser(HttpSession session
			, @RequestParam Map<String, Object> paramMap) throws Exception {
		Log.DebugStart();
		ModelAndView mv = new ModelAndView("hrm/psnalInfo/psnalBasicUser/psnalBasicUser");
		Log.DebugEnd();
		return mv;
	}

	/**
	 * 인사기본_임직원공통 헤더 정보 조회
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getPsnalBasicUserEmployeeHeader", method = RequestMethod.POST )
	public ModelAndView getPsnalBasicUserEmployeeHeader(
			HttpSession session, HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();

		paramMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
		paramMap.put("ssnSabun", session.getAttribute("ssnSabun"));

		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		try {
			Map<String, Object> map = psnalBasicUserService.getPsnalBasicUserEmployeeHeader(paramMap);
			mv.addObject("map", map);
		} catch(Exception e) {
			Log.Error(" ** 인사기본 헤더정보 조회 시 오류가 발생하였습니다. >> " + e.getLocalizedMessage());
			mv.addObject("msg", "조회에 실패하였습니다.");
			mv.addObject("map", new ArrayList<>());
		}

		Log.DebugEnd();
		return mv;
	}

	/**
	 * 인사기본_임직원공통 설정 조회
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getPsnalBasicUserConfigJson", method = RequestMethod.POST )
	public ModelAndView getPsnalBasicUserConfigJson(
			HttpSession session, HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();

		paramMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
		paramMap.put("ssnSabun", session.getAttribute("ssnSabun"));

		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		try {
			Map<String, Object> map = psnalBasicUserConfigService.getPsnalBasicUserConfigJson(paramMap);
			mv.addObject("map", map);
			mv.addObject("msg", "");
		} catch(Exception e) {
			Log.Error(" ** 인사기본_임직원공통 설정 데이터 시 오류가 발생하였습니다. >> " + e.getLocalizedMessage());
			mv.addObject("map", new HashMap<>());
			mv.addObject("msg", "조회에 실패하였습니다.");
		}

		Log.DebugEnd();
		return mv;
	}

	/**
	 * 인사기본_임직원공통 탭 리스트 조회
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getPsnalBasicUserTabs", method = RequestMethod.POST )
	public ModelAndView getPsnalBasicUserTabs(
			HttpSession session, HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();

		paramMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
		paramMap.put("ssnSabun", session.getAttribute("ssnSabun"));

		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		try {
			Map<String, Object> map = psnalBasicUserService.getPsnalBasicUserTabs(paramMap);
			mv.addObject("map", map);
		} catch(Exception e) {
			Log.Error(" ** 인사기본 기본 탭 리스트 조회 시 오류가 발생하였습니다. >> " + e.getLocalizedMessage());
			mv.addObject("msg", "조회에 실패하였습니다.");
			mv.addObject("map", new HashMap<>());
		}

		Log.DebugEnd();
		return mv;
	}

	/**
	 * 인사기본_임직원공통 개인정보 데이터 조회
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getPsnalBasicUserPsnlInfo", method = RequestMethod.POST )
	public ModelAndView getPsnalBasicUserPsnlInfo(
			HttpSession session, HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();

		paramMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
		paramMap.put("ssnSabun", session.getAttribute("ssnSabun"));

		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		try {
			Map<String, Object> map = psnalBasicUserService.getPsnalBasicUserPsnlInfo(paramMap);
			mv.addObject("map", map);
		} catch(Exception e) {
			Log.Error(" ** 인사기본 개인정보 조회 시 오류가 발생하였습니다. >> " + e.getLocalizedMessage());
			mv.addObject("msg", "조회에 실패하였습니다.");
			mv.addObject("map", new HashMap<String, Object>());
		}

		Log.DebugEnd();
		return mv;
	}

	/**
	 * 인사기본_임직원공통 연락처 데이터 조회
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getPsnalBasicUserContacts", method = RequestMethod.POST )
	public ModelAndView getPsnalBasicUserContacts(
			HttpSession session, HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();

		paramMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
		paramMap.put("ssnSabun", session.getAttribute("ssnSabun"));

		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		try {
			List<Map<String, Object>> list = psnalBasicUserService.getPsnalBasicUserContacts(paramMap);
			mv.addObject("list", list);
		} catch(Exception e) {
			Log.Error(" ** 인사기본 연락처 조회 시 오류가 발생하였습니다. >> " + e.getLocalizedMessage());
			mv.addObject("msg", "조회에 실패하였습니다.");
			mv.addObject("list", new ArrayList<>());
		}

		Log.DebugEnd();
		return mv;
	}

	/**
	 * 인사기본_임직원공통 근무정보 데이터 조회
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getPsnalBasicUserWorkInfo", method = RequestMethod.POST )
	public ModelAndView getPsnalBasicUserWorkInfo(
			HttpSession session, HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();

		paramMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
		paramMap.put("ssnSabun", session.getAttribute("ssnSabun"));

		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		try {
			Map<String, Object> map = psnalBasicUserService.getPsnalBasicUserWorkInfo(paramMap);
			mv.addObject("map", map);
		} catch(Exception e) {
			Log.Error(" ** 인사기본 근무정보 조회 시 오류가 발생하였습니다. >> " + e.getLocalizedMessage());
			mv.addObject("msg", "조회에 실패하였습니다.");
			mv.addObject("map", new HashMap<>());
		}

		Log.DebugEnd();
		return mv;
	}

	/**
	 * 인사기본_임직원공통 주소 데이터 조회
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getPsnalBasicUserAddress", method = RequestMethod.POST )
	public ModelAndView getPsnalBasicUserAddress(
			HttpSession session, HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();

		paramMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
		paramMap.put("ssnSabun", session.getAttribute("ssnSabun"));

		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		try {
			List<Map<String, Object>> list = psnalBasicUserService.getPsnalBasicUserAddress(paramMap);
			mv.addObject("list", list);
		} catch(Exception e) {
			Log.Error(" ** 인사기본 주소 정보 조회 시 오류가 발생하였습니다. >> " + e.getLocalizedMessage());
			mv.addObject("msg", "조회에 실패하였습니다.");
			mv.addObject("list", new ArrayList<>());
		}

		Log.DebugEnd();
		return mv;
	}

	/**
	 * 인사기본_임직원공통 가족 데이터 조회
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getPsnalBasicUserFamily", method = RequestMethod.POST )
	public ModelAndView getPsnalBasicUserFamily(
			HttpSession session, HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();

		paramMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
		paramMap.put("ssnSabun", session.getAttribute("ssnSabun"));

		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		try {
			List<Map<String, Object>> list = psnalBasicUserService.getPsnalBasicUserFamily(paramMap);
			mv.addObject("list", list);
		} catch(Exception e) {
			Log.Error(" ** 인사기본 가족 정보 조회 시 오류가 발생하였습니다. >> " + e.getLocalizedMessage());
			mv.addObject("msg", "조회에 실패하였습니다.");
			mv.addObject("list", new ArrayList<>());
		}

		Log.DebugEnd();
		return mv;
	}

	/**
	 * 인사기본_임직원공통 보증보험 데이터 조회
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getPsnalBasicUserGuaranteeInsurance", method = RequestMethod.POST )
	public ModelAndView getPsnalBasicUserGuaranteeInsurance(
			HttpSession session, HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();

		paramMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
		paramMap.put("ssnSabun", session.getAttribute("ssnSabun"));

		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		try {
			List<Map<String, Object>> list = psnalBasicUserService.getPsnalBasicUserGuaranteeInsurance(paramMap);
			mv.addObject("list", list);
		} catch(Exception e) {
			Log.Error(" ** 인사기본 보증보험 정보 조회 시 오류가 발생하였습니다. >> " + e.getLocalizedMessage());
			mv.addObject("msg", "조회에 실패하였습니다.");
			mv.addObject("list", new ArrayList<>());
		}

		Log.DebugEnd();
		return mv;
	}

	/**
	 * 인사기본_임직원공통 발령 데이터 조회
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getPsnalBasicUserPost", method = RequestMethod.POST )
	public ModelAndView getPsnalBasicUserPost(
			HttpSession session, HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();

		paramMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
		paramMap.put("ssnSabun", session.getAttribute("ssnSabun"));

		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		try {
			List<Map<String, Object>> list = psnalBasicUserService.getPsnalBasicUserPost(paramMap);
			mv.addObject("list", list);
		} catch(Exception e) {
			Log.Error(" ** 인사기본 발령 정보 조회 시 오류가 발생하였습니다. >> " + e.getLocalizedMessage());
			mv.addObject("msg", "조회에 실패하였습니다.");
			mv.addObject("list", new ArrayList<>());
		}

		Log.DebugEnd();
		return mv;
	}

	/**
	 * 인사기본_임직원공통 상벌 데이터 조회
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getPsnalBasicUserRewardAndPunish", method = RequestMethod.POST )
	public ModelAndView getPsnalBasicUserRewardAndPunish(
			HttpSession session, HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();

		paramMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
		paramMap.put("ssnSabun", session.getAttribute("ssnSabun"));

		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		try {
			Map<String, Object> map = psnalBasicUserService.getPsnalBasicUserRewardAndPunish(paramMap);
			mv.addObject("map", map);
		} catch(Exception e) {
			Log.Error(" ** 인사기본 상벌 정보 조회 시 오류가 발생하였습니다. >> " + e.getLocalizedMessage());
			mv.addObject("msg", "조회에 실패하였습니다.");
			mv.addObject("map", new ArrayList<>());
		}

		Log.DebugEnd();
		return mv;
	}

	/**
	 * 인사기본_임직원공통 교육 데이터 조회
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getPsnalBasicUserEducation", method = RequestMethod.POST )
	public ModelAndView getPsnalBasicUserEducation(
			HttpSession session, HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();

		paramMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
		paramMap.put("ssnSabun", session.getAttribute("ssnSabun"));

		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		try {
			Map<String, Object> map = psnalBasicUserService.getPsnalBasicUserEducation(paramMap);
			mv.addObject("map", map);
		} catch(Exception e) {
			Log.Error(" ** 인사기본 교육 정보 조회 시 오류가 발생하였습니다. >> " + e.getLocalizedMessage());
			mv.addObject("msg", "조회에 실패하였습니다.");
			mv.addObject("map", new HashMap<>());
		}

		Log.DebugEnd();
		return mv;
	}

	/**
	 * 인사기본_임직원공통 자격 데이터 조회
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getPsnalBasicUserLicense", method = RequestMethod.POST )
	public ModelAndView getPsnalBasicUserLicense(
			HttpSession session, HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();

		paramMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
		paramMap.put("ssnSabun", session.getAttribute("ssnSabun"));

		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		try {
			List<Map<String, Object>> list = psnalBasicUserService.getPsnalBasicUserLicense(paramMap);
			mv.addObject("list", list);
		} catch(Exception e) {
			Log.Error(" ** 인사기본 자격 정보 조회 시 오류가 발생하였습니다. >> " + e.getLocalizedMessage());
			mv.addObject("msg", "조회에 실패하였습니다.");
			mv.addObject("list", new ArrayList<>());
		}

		Log.DebugEnd();
		return mv;
	}

	/**
	 * 인사기본_임직원공통 학력 데이터 조회
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getPsnalBasicUserSchool", method = RequestMethod.POST )
	public ModelAndView getPsnalBasicUserSchool(
			HttpSession session, HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();

		paramMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
		paramMap.put("ssnSabun", session.getAttribute("ssnSabun"));

		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		try {
			List<Map<String, Object>> list = psnalBasicUserService.getPsnalBasicUserSchool(paramMap);
			mv.addObject("list", list);
		} catch(Exception e) {
			Log.Error(" ** 인사기본 학력 정보 조회 시 오류가 발생하였습니다. >> " + e.getLocalizedMessage());
			mv.addObject("msg", "조회에 실패하였습니다.");
			mv.addObject("list", new ArrayList<>());
		}

		Log.DebugEnd();
		return mv;
	}

	/**
	 * 인사기본_임직원공통 경력 데이터 조회
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getPsnalBasicUserCareer", method = RequestMethod.POST )
	public ModelAndView getPsnalBasicUserCareer(
			HttpSession session, HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();

		paramMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
		paramMap.put("ssnSabun", session.getAttribute("ssnSabun"));

		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		try {
			Map<String, Object> map = psnalBasicUserService.getPsnalBasicUserCareer(paramMap);
			mv.addObject("map", map);
		} catch(Exception e) {
			Log.Error(" ** 인사기본 경력 정보 조회 시 오류가 발생하였습니다. >> " + e.getLocalizedMessage());
			mv.addObject("msg", "조회에 실패하였습니다.");
			mv.addObject("map", new ArrayList<>());
		}

		Log.DebugEnd();
		return mv;
	}

	/**
	 * 인사기본_임직원공통 어학 데이터 조회
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getPsnalBasicUserLanguage", method = RequestMethod.POST )
	public ModelAndView getPsnalBasicUserLanguage(
			HttpSession session, HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();

		paramMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
		paramMap.put("ssnSabun", session.getAttribute("ssnSabun"));

		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		try {
			List<Map<String, Object>> list = psnalBasicUserService.getPsnalBasicUserLanguage(paramMap);
			mv.addObject("list", list);
		} catch(Exception e) {
			Log.Error(" ** 인사기본 어학 정보 조회 시 오류가 발생하였습니다. >> " + e.getLocalizedMessage());
			mv.addObject("msg", "조회에 실패하였습니다.");
			mv.addObject("list", new ArrayList<>());
		}

		Log.DebugEnd();
		return mv;
	}

	/**
	 * 인사기본_임직원공통 해외연수 데이터 조회
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getPsnalBasicUserOverseasStudy", method = RequestMethod.POST )
	public ModelAndView getPsnalBasicUserOverseasStudy(
			HttpSession session, HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();

		paramMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
		paramMap.put("ssnSabun", session.getAttribute("ssnSabun"));

		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		try {
			List<Map<String, Object>> list = psnalBasicUserService.getPsnalBasicUserOverseasStudy(paramMap);
			mv.addObject("list", list);
		} catch(Exception e) {
			Log.Error(" ** 인사기본 해외연수 정보 조회 시 오류가 발생하였습니다. >> " + e.getLocalizedMessage());
			mv.addObject("msg", "조회에 실패하였습니다.");
			mv.addObject("list", new ArrayList<>());
		}

		Log.DebugEnd();
		return mv;
	}

	/**
	 * 인사기본_임직원공통 병역사항 데이터 조회
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getPsnalBasicUserMilitary", method = RequestMethod.POST )
	public ModelAndView getPsnalBasicUserMilitary(
			HttpSession session, HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();

		paramMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
		paramMap.put("ssnSabun", session.getAttribute("ssnSabun"));

		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		try {
			Map<String, Object> map = psnalBasicUserService.getPsnalBasicUserMilitary(paramMap);
			mv.addObject("map", map);
		} catch(Exception e) {
			Log.Error(" ** 인사기본 병역사항 정보 조회 시 오류가 발생하였습니다. >> " + e.getLocalizedMessage());
			mv.addObject("msg", "조회에 실패하였습니다.");
			mv.addObject("map", new ArrayList<>());
		}

		Log.DebugEnd();
		return mv;
	}

	/**
	 * 인사기본_임직원공통 병역특례 데이터 조회
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getPsnalBasicUserMilitaryException", method = RequestMethod.POST )
	public ModelAndView getPsnalBasicUserMilitaryException(
			HttpSession session, HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();

		paramMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
		paramMap.put("ssnSabun", session.getAttribute("ssnSabun"));

		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		try {
			Map<String, Object> map = psnalBasicUserService.getPsnalBasicUserMilitaryException(paramMap);
			mv.addObject("map", map);
		} catch(Exception e) {
			Log.Error(" ** 인사기본 병역특례 정보 조회 시 오류가 발생하였습니다. >> " + e.getLocalizedMessage());
			mv.addObject("msg", "조회에 실패하였습니다.");
			mv.addObject("map", new ArrayList<>());
		}

		Log.DebugEnd();
		return mv;
	}

	/**
	 * 인사기본_임직원공통 보훈사항 데이터 조회
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getPsnalBasicUserVeteransAffairs", method = RequestMethod.POST )
	public ModelAndView getPsnalBasicUserVeteransAffairs(
			HttpSession session, HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();

		paramMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
		paramMap.put("ssnSabun", session.getAttribute("ssnSabun"));

		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		try {
			Map<String, Object> map = psnalBasicUserService.getPsnalBasicUserVeteransAffairs(paramMap);
			mv.addObject("map", map);
		} catch(Exception e) {
			Log.Error(" ** 인사기본 보훈사항 정보 조회 시 오류가 발생하였습니다. >> " + e.getLocalizedMessage());
			mv.addObject("msg", "조회에 실패하였습니다.");
			mv.addObject("map", new ArrayList<>());
		}

		Log.DebugEnd();
		return mv;
	}

	/**
	 * 인사기본_임직원공통 장애사항 데이터 조회
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getPsnalBasicUserDisability", method = RequestMethod.POST )
	public ModelAndView getPsnalBasicUserDisability(
			HttpSession session, HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();

		paramMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
		paramMap.put("ssnSabun", session.getAttribute("ssnSabun"));

		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		try {
			Map<String, Object> map = psnalBasicUserService.getPsnalBasicUserDisability(paramMap);
			mv.addObject("map", map);
		} catch(Exception e) {
			Log.Error(" ** 인사기본 장애사항 정보 조회 시 오류가 발생하였습니다. >> " + e.getLocalizedMessage());
			mv.addObject("msg", "조회에 실패하였습니다.");
			mv.addObject("map", new ArrayList<>());
		}

		Log.DebugEnd();
		return mv;
	}
}

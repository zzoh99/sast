package com.hr.main.sub;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.inject.Inject;
import javax.inject.Named;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;

import com.hr.common.logger.Log;
import com.hr.common.security.SecurityMgrService;
import com.hr.common.util.SessionUtil;
import com.hr.main.main.MainService;

/**
 * 메뉴 화면(Sub)
 *
 * @author isusystem
 *
 */
@Controller
@SuppressWarnings("unchecked")
public class SubController {


	@Inject
	@Named("MainService")
	private MainService mainService;
	
	@Inject
	@Named("SubService")
	private SubService subService;

	@Inject
	@Named("SecurityMgrService")
	private SecurityMgrService securityMgrService;


	/**
	 * Sub 화면
	 *
	 * @param paramMap
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(value="/Hr.do", method=RequestMethod.POST )
	public ModelAndView viewSub (HttpSession session
							   , @RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		paramMap.put("ssnGrpCd", session.getAttribute("ssnGrpCd"));
		Map<?, ?> getMainMajorMenuListCount2021 = null;
		
		ModelAndView mv = new ModelAndView();
		Map<String, Object> urlParam = new HashMap<String, Object>();
		String murl = String.valueOf(paramMap.get("murl"));
		String mmc = null;
		if( paramMap.get("murl") != null ){
			String skey = String.valueOf(SessionUtil.getRequestAttribute("ssnEncodedKey"));
			urlParam = (Map<String, Object>) securityMgrService.getDecryptUrl( murl, skey  );
			Log.Debug("■■■■■■■■■■■■■■■■■■■■■■■    "+urlParam);
			urlParam.put("murl", murl);
			mmc = String.valueOf(urlParam.get("mainMenuCd"));
			
			if (paramMap.get("linkedBarProcMapSeq") != null && paramMap.get("linkedBarProcSeq") != null) {
				urlParam.put("linkedBarProcMapSeq", paramMap.get("linkedBarProcMapSeq"));
				urlParam.put("linkedBarProcSeq", paramMap.get("linkedBarProcSeq"));
			}
			
			Log.Debug("■■■■■■■■■■■■■■■■■■■■■■■");
			Log.Debug("urlParam====>>>>"+ urlParam);
			Log.Debug("■■■■■■■■■■■■■■■■■■■■■■■");
		}

		if(null == mmc){
			mv.setViewName("redirect:/Main.do");
			return mv;
		}
		
		getMainMajorMenuListCount2021 = mainService.getMainMajorMenuListCount2021(paramMap);// mainMenuCd 20 21 count
		//mv.setViewName("main/sub/sub");
		mv.setViewName("main/sub/hr");
		mv.addObject("getMainMajorMenuListCount2021",getMainMajorMenuListCount2021);
		mv.addObject("result", urlParam);
		return mv;
	}

	/**
	 * 대분류 메뉴 조회
	 *
	 * @param session
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(value="/getSubLowMenuList.do", method=RequestMethod.POST )
	public ModelAndView getSubLowMenuList(
			HttpSession session,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		paramMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
		paramMap.put("ssnSabun", session.getAttribute("ssnSabun"));
		paramMap.put("ssnGrpCd", session.getAttribute("ssnGrpCd"));

		//////////
		Map<String, Object> urlParam = new HashMap<String, Object>();
		String surl =paramMap.get("murl").toString();
		String skey = session.getAttribute("ssnEncodedKey").toString();

		urlParam = (Map<String, Object>) securityMgrService.getDecryptUrl( surl, skey  );

		paramMap.put("mainMenuCd", urlParam.get("mainMenuCd"));
		paramMap.put("ssnEncodedKey", skey);
		//////////

		List<?> result = subService.getSubLowMenuList(paramMap);

		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("result", result);
		Log.DebugEnd();
		return mv;
	}




	/**
	 * 바로가기  함수생성
	 *
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(value="/getDirectSubMenu.do", method=RequestMethod.POST )
	public ModelAndView getDirectSubMenuMap(
			HttpSession session,  HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {

		Map<?, ?> map = subService.getDirectSubMenuMap(paramMap);
		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("map", map);

		Log.DebugEnd();
		return mv;
	}

	/**
	 * 바로가기 Map
	 *
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(value="/geSubDirectMap.do", method=RequestMethod.POST )
	public ModelAndView geSubDirectMap (
			HttpSession session,  HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {

		Map<?, ?> map = subService.geSubDirectMap (paramMap);
		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("map", map);

		Log.DebugEnd();
		return mv;

	}



	/**
	 * 나의메뉴 리스트 조회
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */

	@RequestMapping(value="/getMyMenuList.do", method=RequestMethod.POST )
	public ModelAndView tsys331SelectMyMenuList(
			HttpSession session, HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap) throws Exception {
		Log.DebugStart();

		List<?> result = subService.tsys331SelectMyMenuList(paramMap);

		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("result", result);
		Log.DebugEnd();
		return mv;
	}



	/**
	 * 나의메뉴 관리
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(value="/getMymenu.do", method=RequestMethod.POST )
	public ModelAndView myMenuMgr(
			HttpSession session,  HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		// comment 시작
		Log.DebugStart();
		String status = paramMap.get("status").toString();

		//////////
		Map<String, Object> urlParam = new HashMap<String, Object>();
		String surl =paramMap.get("surl").toString();
		String skey = session.getAttribute("ssnEncodedKey").toString();

		urlParam = (Map<String, Object>) securityMgrService.getDecryptUrl( surl, skey  );

		//paramMap.put("mainMenuCd", urlParam.get("mainMenuCd"));

		//////////
		paramMap.put("menuSeq", urlParam.get("menuSeq"));
		paramMap.put("prgCd", urlParam.get("prgCd"));


		Log.Debug("urlParam■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■"+ urlParam);
		Log.Debug("paramMap■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■"+ paramMap);




		String message = "";
		int resultCnt = -1;
		try{
			resultCnt = subService.tsys331saveMyMenuMgr(paramMap);
			if(resultCnt > 0){
				if(status.equals("I")) {
					//message = LanguageUtil.getMessage("msg.alertSaveMyMenuOk"); //"나의메뉴에 저장되었습니다.";
					message = "나의메뉴에 저장되었습니다."; //"나의메뉴에 저장되었습니다.";
				} else {
					//message = LanguageUtil.getMessage("msg.alertDelMyMenuOk"); //"나의메뉴에 삭제되었습니다.";
					message = "나의메뉴에 삭제되었습니다.";
				}
			} else {
				//message = LanguageUtil.getMessage("msg.alertSaveMyMenuNoData"); //"나의메뉴에 저장된 내용이 없습니다.";
				message = "나의메뉴에 저장된 내용이 없습니다.";
			}
		}catch(Exception e){
			resultCnt = -1;
			//message = LanguageUtil.getMessage("msg.alertSaveMyMenuFail"); //"나의메뉴 저장에 실패하였습니다.";
			message = "나의메뉴 저장에 실패하였습니다.";
		}

		Map<String, Object> resultMap = new HashMap<String, Object>();
		resultMap.put("Code", resultCnt);
		resultMap.put("Message", message);

		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("result", resultMap);
		Log.DebugEnd();
		return mv;
	}

	/**
	 * 메뉴 AUTOCOMPLETE 검색
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(value="/getSearchMenuList.do", method=RequestMethod.POST )
	public ModelAndView searchMenuList( HttpSession session,  HttpServletRequest request, @RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		List<?> menuList = subService.getSearchMenuList(paramMap);

		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("DATA", menuList);
		Log.DebugEnd();
		return mv;
	}
	/**
	 * 알림 목록 리스트
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(value="/getAlertInfoList.do", method=RequestMethod.POST )
	public ModelAndView getAlertInfoList(HttpSession session, HttpServletRequest request, @RequestParam Map<String, Object> paramMap ) throws Exception {
		List<?> list = subService.getAlertInfoList(paramMap);

		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("DATA", list);
		return mv;
	}
	/**
	 * 알림 목록 상세
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(value="/getAlertInfoCnt.do", method=RequestMethod.POST )
	public ModelAndView getAlertInfoMap(HttpSession session, HttpServletRequest request, @RequestParam Map<String, Object> paramMap ) throws Exception {
		Map<?,?> map = subService.getAlertInfoCnt(paramMap);
		int cnt = 0;
		try {
			cnt = Integer.parseInt(String.valueOf(map.get("cnt")));
		} catch (Exception e) {
			cnt = 0;
		}

		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("DATA", cnt);
		return mv;
	}

	/**
	 * 알림 목록 조회 여부 수정
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(value="/updateAlertInfoReadYn.do", method=RequestMethod.POST )
	public ModelAndView updateAlertInfoReadYn(HttpSession session, HttpServletRequest request, @RequestParam Map<String, Object> paramMap ) throws Exception {
		String Message = "";

		int result = subService.updateAlertInfoReadYn(paramMap);
		if(result == 0){
			Message="수정에 실패하였습니다.";
		}

		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("Message", Message);
		return mv;
	}
	
	/**
	 * 알림 목록 전체 삭제
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(value="/deleteAllAlert.do", method=RequestMethod.POST )
	public ModelAndView deleteAllAlert(HttpSession session, HttpServletRequest request, @RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		String Message;
		int result = -1;

		try {
			result = subService.deleteAllAlert(paramMap);
			if (result > 0) {
				Message = "알림이 삭제되었습니다.";
			} else {
				Message = "삭제할 알림이 없습니다.";
			}
		} catch(Exception e) {
			Log.Error(" ## 개인 알림 삭제 시 오류가 발생하였습니다. >> " + e.getLocalizedMessage());
			Message = "알림 삭제에 실패하였습니다.";
		}
		
		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("Code", result);
		mv.addObject("Message", Message);
		Log.DebugEnd();
		return mv;
	}
	
	/**
	 * 최근 알림 조회
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(value="/getRecentAlert.do", method=RequestMethod.POST )
	public ModelAndView getRecentAlert(HttpSession session, HttpServletRequest request, @RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		Map<?,?> map = subService.getRecentAlert(paramMap);
		
		Log.Debug("paramMap = "+ paramMap.toString());
		
		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("Result", map);
		Log.DebugEnd();
		return mv;
	}

	/**
	 * 대메뉴 클릭시 컨텐츠 화면.
	 *
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(value="/getSubMenuContents.do", method=RequestMethod.POST )
	public ModelAndView getSubMenuContents(
			HttpSession session,  HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {

		paramMap.put("ssnEnterCd",session.getAttribute("ssnEnterCd"));
		paramMap.put("ssnSabun", session.getAttribute("ssnSabun"));
		paramMap.put("ssnGrpCd", session.getAttribute("ssnGrpCd"));
		paramMap.put("ssnLocaleCd",	session.getAttribute("ssnLocaleCd"));

		Map<String, Object> urlParam = new HashMap<String, Object>();
		String surl = paramMap.get("murl").toString();
		String skey = session.getAttribute("ssnEncodedKey").toString();

		urlParam = (Map<String, Object>) securityMgrService.getDecryptUrl( surl, skey  );
		paramMap.put("mainMenuCd", urlParam.get("mainMenuCd"));
		paramMap.put("ssnEncodedKey", skey);
		//////////

		Map<String, Object> map = (Map<String, Object>) subService.getSubMenuContents(paramMap);
		ModelAndView mv = new ModelAndView();
		mv.setViewName("main/contents/mainMenuLayout");
//		mv.setViewName("main/contents/base"+urlParam.get("mainMenuCd"));
		mv.addObject("map", map);
		mv.addObject("mainMenuCd", urlParam.get("mainMenuCd"));
		Log.DebugEnd();
		return mv;
	}
	
	/*근태마스터*/
	@RequestMapping(value="/base08Data.do", method=RequestMethod.POST )
	public ModelAndView getBase08Data(HttpSession session,
			@RequestParam Map<String, Object> paramMap ) throws Exception{ 
		
		Map<String, Object> param = new HashMap<>();
		param.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
		param.put("ssnSabun", session.getAttribute("ssnSabun"));
		param.put("ssnLocaleCd", session.getAttribute("ssnLocaleCd"));
		
		Map<String, Object> data = new HashMap<>();
		
		/*시간외 근무 사용현황*/
		Map<String, Object> overTimeUse = new HashMap<>();
		overTimeUse.put("data", mainService.getListOverTime(param));
		
		data.put("overTimeUse", overTimeUse);	
		/*//시간외 근무 사용현황*/
		
		/* 연차 보상 비용 현황 */
		Map<String, Object> vacationLeaveCost = new HashMap<>();
		
		vacationLeaveCost.put("data", mainService.getVacationLeaveCost(param));
				
		data.put("vacationLeaveCost", vacationLeaveCost);
		/*//연차 보상 비용 현황 */

		/*전사 근태 현황 비율*/
		Map<String, Object> attendanceCnt = new HashMap<>();
		
		attendanceCnt.put("data", mainService.getAttendanceCnt(param));
				
		data.put("attendanceCnt", attendanceCnt);
		/*//전사 근태 현황 정보 비율*/
		
		/*전사 근태 현황 전체 목록*/
		Map<String, Object> attendanceAllInfo = new HashMap<>();
		
		attendanceAllInfo.put("data", mainService.getAttendanceAllInfo(param));
		attendanceAllInfo.put("enterCd", session.getAttribute("ssnEnterCd"));
				
		data.put("attendanceAllInfo", attendanceAllInfo);
		/*//전사 근태 현황 전체 목록*/
		
		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("data", data);
		
		return mv;
	}
	
	/*급여마스터*/
	@RequestMapping(value="/base07Data.do", method=RequestMethod.POST )
	public ModelAndView getBase07Data(HttpSession session,
			@RequestParam Map<String, Object> paramMap,@RequestParam(value = "jikwee", required = false, defaultValue = "B0017") String jikwee ) throws Exception{ 
		
		Map<String, Object> param = new HashMap<>();
		param.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
		param.put("ssnSabun", session.getAttribute("ssnSabun"));
		param.put("ssnLocaleCd", session.getAttribute("ssnLocaleCd"));
		param.put("jikwee", jikwee);
		
		Map<String, Object> data = new HashMap<>();
		
		/* 직급대비 급여 상위*/
		Map<String, Object> salaryTop = new HashMap<>();
		
		salaryTop.put("data", mainService.getSalaryTop(param));
		salaryTop.put("enterCd", session.getAttribute("ssnEnterCd"));
		
		data.put("salaryTop", salaryTop);
		/*//직급대비 급여 상위*/
		
		/*직급대비 급여 하위*/
		Map<String, Object> salaryBottom = new HashMap<>();
		
		salaryBottom.put("data", mainService.getSalaryBottom(param));
		salaryBottom.put("enterCd", session.getAttribute("ssnEnterCd"));
		
		data.put("salaryBottom", salaryBottom);
		/*//직급대비 급여 하위*/
		
		/*급여인상 TOP*/
		Map<String, Object> salaryIncrease = new HashMap<>();
		
		salaryIncrease.put("data", mainService.getSalaryIncrease(param));
		salaryIncrease.put("enterCd", session.getAttribute("ssnEnterCd"));
		data.put("salaryIncrease", salaryIncrease);
		/*//급여인상 TOP*/

		/*급여아웃라이어 TOP*/
		Map<String, Object> salaryOutlier = new HashMap<>();
		
		salaryOutlier.put("data", mainService.getSalaryOutlier(param));
		
		data.put("salaryOutlier", salaryOutlier);
		/*//급여인상 TOP*/
		
		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("data", data);
		
		return mv;
	}
	
	/*인사마스터*/
	@RequestMapping(value="/base02Data.do", method=RequestMethod.POST )
	public ModelAndView getBase02Data(HttpSession session,
			@RequestParam Map<String, Object> paramMap, @RequestParam(value = "stand", required= false, defaultValue = "all") String stand ) throws Exception{ 
		
		Map<String, Object> param = new HashMap<>();
		param.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
		param.put("ssnSabun", session.getAttribute("ssnSabun"));
		param.put("ssnLocaleCd", session.getAttribute("ssnLocaleCd"));
		param.put("stand", stand);
		
		Map<String, Object> data = new HashMap<>();
		
//		/* 전사인원 추이 */
//		Map<String, Object> companyTrends = new HashMap<>();
//		
//		companyTrends.put("data", mainService.getCompanyTrends(param));
//		
//		data.put("companyTrends", companyTrends);
//		/*//전사인원 추이 */
//		
		/* 입/퇴사 추이 */
		Map<String, Object> yearlyEnterExitTrend = new HashMap<>();
		
		yearlyEnterExitTrend.put("data", mainService.getYearlyEnterExitTrend(param));
		yearlyEnterExitTrend.put("monthlyData", mainService.getMonthlyEnterExitTrend(param));
		
		data.put("yearlyEnterExitTrend", yearlyEnterExitTrend);
		/*//입/퇴사 추이 */
		
		/* 3개년 채용인원  + 채용지수*/
		Map<String, Object> getCompanyYearlyTrendsValues = new HashMap<>();
		
		getCompanyYearlyTrendsValues.put("data", mainService.getCompanyYearlyTrendsValues(param));
		
		data.put("getCompanyYearlyTrendsValues", getCompanyYearlyTrendsValues);
		
		/*//3개년 채용인원 + 채용지수 */
		
		/* 승진후보자 현황*/
		Map<String, Object> candidate = new HashMap<>();
		
		candidate.put("data", mainService.getJikweeList(param));
		candidate.put("data", mainService.getCandidate(param));
		candidate.put("enterCd", session.getAttribute("ssnEnterCd"));
		data.put("candidate", candidate);
		/*//승진후보자 현황*/
		
		/* 퇴사율*/
		Map<String, Object> leave = new HashMap<>();
		
		leave.put("data", mainService.getYearlyEnterExitTrend(param));
		data.put("leave", leave);
		/*//퇴사율*/
		
		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("data", data);
		
		return mv;
	}

	/*
	 * 사용안함[메뉴생성시 authPg에 하당되는 값을 받아서 Session 값으로 처리 하는 부분 ]
	 */

	/*
	@RequestMapping(value="/AuthPg.do", method=RequestMethod.POST )
	public ModelAndView setAuthPg(
			HttpSession session,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		session.removeAttribute("authPg"); session.setAttribute("authPg", paramMap.get("authPg"));
		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("success", "yes");
		Log.Debug("SubController.setAuthPg > "+session.getAttribute("authPg"));
		return mv;
	}
	*/

	/**
	 * 서브 > 비밀번호 변경 레이어
	 * @param session
	 * @param params
	 * @param request
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value="/SubChangePw.do", method=RequestMethod.POST )
	public ModelAndView viewWorkdayApp(HttpSession session
			, @RequestParam Map<String, Object> params
			, HttpServletRequest request) throws Exception {

		ModelAndView mv = new ModelAndView();
		mv.setViewName("main/main/chgPwLayer");

		return mv;
	}

}
